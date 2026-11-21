#!/usr/bin/env python3
"""Stevie cross-bank trampoline layer: registry extract / generate / check.

The cross-bank call layer consists of:
  - vector tables: src/modules/rom.vectors.bank[0-f].asm  (slot -> target label)
  - stubs:         src/modules/rom.stubs.bank[1-7].asm    (label -> bank+slot)

Single source of truth after generation:
  - build/vector-registry.txt   (vector slots + ordered stub blocks)
  - build/stub-raw/*.blk        (verbatim whole-block text for irregular stubs)

Hand-written, never generated:
  - rom.vectors.bank0.asm       (equ-based boot vectors)
  - rom.stubs.bankx.asm         (.ifgt conditional SAMS stubs)

Commands:
  extract    parse src -> rewrite registry + raw blocks
  generate   parse registry -> write src files (--out DIR for dry run)
  check      regenerate into temp dir, diff vs src; exit 1 on drift

Round-trip contract: generate(extract(src)) emits the same code in the same
order as src; only comment/whitespace cosmetics may differ. Proof of any
registry/generator change is therefore a byte-identical .bin rebuild.
"""

import argparse
import difflib
import os
import re
import shutil
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SRC = os.path.join(ROOT, "src", "modules")
REGISTRY = os.path.join(HERE, "vector-registry.txt")
RAWDIR = os.path.join(HERE, "stub-raw")

VECTOR_BANKS = [f"{i:x}" for i in range(1, 16)]        # bank1..bankf (0 excluded)
STUB_BANKS = [str(i) for i in range(1, 8)]             # banks with stub content
EMPTY_STUB_BANKS = [f"{i:x}" for i in range(8, 16)]    # placeholder stub files

BANNER = "*" * 63
SUBBAN = "********|*****|*********************|**************************"
RULE = "*" + "-" * 62
COL = 36   # source column where inline comments start


def cmt(code, comment):
    """Assemble one source line; comment begins with ';' and lands at COL."""
    if comment is None:
        return code
    return code.ljust(COL) + comment if len(code) < COL else f"{code} {comment}"


# ---------------------------------------------------------------------------
# Templates for the two regular stub shapes (canonical formatting)
# ---------------------------------------------------------------------------

def farjump_block(dest, vec):
    d = dest.upper()
    return [
        "        ;------------------------------------------------------",
        f"        ; Call function in bank {d}",
        "        ;------------------------------------------------------",
        cmt("        bl    @rom.farjump", r"; \ Trampoline jump to bank"),
        cmt(f"              data bank{dest}.rom", "; | i  p0 = bank address"),
        cmt(f"              data vec.{vec}", "; | i  p1 = Vector with target address"),
        cmt("              data bankid", "; / i  p2 = Source ROM bank for return"),
    ]


def inline_body(label, dest, vec, variant):
    body = [f"{label}:"]
    if variant == "regs":
        body.append(cmt("        .pushregs 0",
                        "; Push return address and registers on stack"))
        body += farjump_block(dest, vec)
        body += [
            "        ;------------------------------------------------------",
            "        ; Exit",
            "        ;------------------------------------------------------",
            f"{label}.exit:",
            cmt("        .popregs 0", "; Pop registers and return to caller"),
        ]
    else:
        body += [
            "        dect  stack",
            cmt("        mov   r11,*stack", "; Save return address"),
        ]
        body += farjump_block(dest, vec)
        body += [
            "        ;------------------------------------------------------",
            "        ; Exit",
            "        ;------------------------------------------------------",
        ]
        if variant == "exitlabel":
            body.append(f"{label}.exit:")
        body += [
            cmt("        mov   *stack+,r11", "; Pop r11"),
            cmt("        b     *r11", "; Return to caller"),
        ]
    return body


def trmp_body(label, vec, helper, form, comment):
    code = (f"        jmp   {helper}" if form == "jmp"
            else f"        b     @{helper}")
    return [
        f"{label}:",
        f"        mov   @{label}.vector,@trmpvector",
        cmt(code, f"; {comment}"),
        f"{label}.vector:",
        f"        data  vec.{vec}",
    ]


# ---------------------------------------------------------------------------
# Parsing: vector tables
# ---------------------------------------------------------------------------

VEC_RE = re.compile(r"^vec\.(\d+)\s+data\s+(\S+)\s*(?:;\s?(.*))?\s*$")

BANK_META = {"8": {"aorg": ">7f70", "trapfill": "0"}}   # bank-specific layout


def parse_vectors(path):
    slots = {}
    with open(path, encoding="latin-1") as fh:
        for line in fh:
            m = VEC_RE.match(line.rstrip())
            if not m:
                continue
            slot, target, comment = int(m.group(1)), m.group(2), (m.group(3) or "").strip()
            if target in ("cpu.crash", "0"):
                target, comment = "TRAP", ""
            slots[slot] = (target, comment)
    missing = [s for s in range(1, 65) if s not in slots]
    if missing:
        sys.exit(f"error: {path}: vector slots missing: {missing}")
    return slots


def render_vectors(bank, slots):
    meta = BANK_META.get(bank, {})
    aorg = meta.get("aorg", "bankx.vectab")
    trapfill = meta.get("trapfill", "cpu.crash")
    hexb = bank.upper()

    def slot_lines(lo, hi):
        lines = []
        for s in range(lo, hi + 1):
            target, comment = slots[s]
            operand = trapfill if target == "TRAP" else target
            code = f"{'vec.' + str(s):<8}data  {operand}"
            if not comment and len(code) >= COL:
                lines.append(code)        # no room for the bare ';' marker
            else:
                lines.append(cmt(code, "; " + comment if comment else ";"))
        return lines

    out = [
        f"* FILE......: rom.vectors.bank{bank}.asm",
        f"* Purpose...: Bank {hexb} vectors for trampoline function",
        "",
        RULE,
        f"* ROM {hexb}: Vectors 1-32",
        RULE,
        f"        aorg  {aorg}",
    ]
    out += slot_lines(1, 32)
    out += [RULE, f"* ROM {hexb}: Vectors 33-64", RULE]
    out += slot_lines(33, 64)
    out += [
        "",
        RULE,
        "* ROM identification string for CPU crash",
        RULE,
        "cpu.crash.showbank.bankstr:",
        "        aorg >7fea",
        f"        stri 'ROM#{hexb}'",
    ]
    return "\n".join(out) + "\n"


# ---------------------------------------------------------------------------
# Parsing: stub files
# ---------------------------------------------------------------------------

class Block:
    def __init__(self, kind):
        self.kind = kind          # trmp | inline | raw
        self.label = ""
        self.dest = None
        self.vec = None
        self.helper = None
        self.form = None
        self.comment = None
        self.variant = None
        self.desc = None          # non-canonical '* Stub for ...' header line
        self.text = []            # raw: verbatim whole-block lines


def split_blocks(lines):
    """Split stub file at BANNER lines. Each block's lines start with the
    BANNER line; preamble before the first banner is ignored (the file header
    is regenerated)."""
    blocks, cur = [], None
    for ln in lines:
        ln = ln.rstrip("\r\n").rstrip()
        if ln == BANNER:
            if cur is not None:
                blocks.append(cur)
            cur = [ln]
        elif cur is not None:
            cur.append(ln)
    if cur:
        blocks.append(cur)
    return blocks


TRMP_RE = re.compile(
    r"^(?P<label>\S+):\n"
    r"        mov   @(?P=label)\.vector,@trmpvector\n"
    r"        (?P<op>jmp   |b     @)(?P<helper>_trampoline\.\S+)"
    r"\s*;\s*(?P<comment>[^\n]*)\n"
    r"(?:[ \t]*\n)*"
    r"(?P=label)\.vector:\n"
    r"        data  vec\.(?P<vec>\d+)$"
)

FJ_RE = re.compile(
    r"bl    @rom\.farjump[^\n]*\n\s+data\s+bank(\w)\.rom\b[^\n]*\n"
    r"\s+data\s+vec\.(\d+)[^\n]*\n\s+data\s+bankid"
)


def classify(block_lines):
    body, seen_subban = [], False
    hdr = None
    for ln in block_lines:
        if not seen_subban:
            if ln.startswith("* Stub for"):
                hdr = ln
            elif ln.startswith("********|"):
                seen_subban = True
            continue
        body.append(ln)
    while body and not body[-1].strip():
        body.pop()
    text = "\n".join(body)

    m = TRMP_RE.match(text)
    if m:
        blk = Block("trmp")
        blk.label = m.group("label")
        blk.helper = m.group("helper")
        blk.form = "jmp" if m.group("op") == "jmp   " else "bindirect"
        dm = re.match(r"_trampoline\.bank(\w)", blk.helper)
        blk.dest = dm.group(1) if dm else None
        blk.vec = int(m.group("vec"))
        blk.comment = m.group("comment").strip() or "Longjump"
        canon = f'* Stub for "{blk.label}"'
        if hdr and hdr != canon:
            blk.desc = hdr
        return blk

    fj = FJ_RE.findall(text)
    lm = re.match(r"^(\S+):", text, re.M)
    if len(fj) == 1 and lm:
        label = lm.group(1)
        dest, vec = fj[0][0], int(fj[0][1])
        for variant in ("plain", "exitlabel", "regs"):
            if inline_body(label, dest, vec, variant) == body:
                blk = Block("inline")
                blk.label, blk.dest, blk.vec, blk.variant = label, dest, vec, variant
                canon = f'* Stub for "{label}"'
                if hdr and hdr != canon:
                    blk.desc = hdr
                return blk

    # Irregular block: keep whole block verbatim. Derive the mapping from the
    # code if possible (farjump triple or trampoline reference); fall back to
    # the 'bankN vec.M' header comment and warn when they disagree.
    blk = Block("raw")
    blk.text = block_lines
    lm2 = re.search(r"^(\S+):", text, re.M)
    blk.label = lm2.group(1).rstrip(":") if lm2 else "block"
    code_dest = code_vec = None
    if len(fj) == 1:
        code_dest, code_vec = fj[0][0], int(fj[0][1])
    else:
        hm = re.search(r"jmp   _trampoline\.bank(\w)|b     @_trampoline\.bank(\w)", text)
        vm = re.search(r"\.vector:\n\s+data  vec\.(\d+)", text)
        if hm:
            code_dest = hm.group(1) or hm.group(2)
        if vm:
            code_vec = int(vm.group(1))
    cm = [re.match(r"\*\s+bank(\w) vec\.(\d+)", ln) for ln in block_lines]
    cm = next((x for x in cm if x), None)
    if cm and code_dest and (cm.group(1) != code_dest or int(cm.group(2)) != code_vec):
        print(f"WARNING: stub '{blk.label}': header comment says "
              f"bank{cm.group(1)} vec.{cm.group(2)} but code says "
              f"bank{code_dest} vec.{code_vec}; using code")
    if code_dest:
        blk.dest, blk.vec = code_dest, code_vec
    elif cm:
        blk.dest, blk.vec = cm.group(1), int(cm.group(2))
    return blk


def parse_stub_file(path):
    with open(path, encoding="latin-1") as fh:
        return [classify(b) for b in split_blocks(fh.readlines())]


# ---------------------------------------------------------------------------
# extract: src -> registry + raw blocks
# ---------------------------------------------------------------------------

def cmd_extract(_args):
    if os.path.isdir(RAWDIR):
        shutil.rmtree(RAWDIR)
    os.makedirs(RAWDIR)

    reg = [
        "# Stevie cross-bank trampoline registry",
        "# Generated by build/gen_vectors.py extract; hand-editable.",
        "# After editing run:  python3 build/gen_vectors.py generate",
        "# Build guard:        python3 build/gen_vectors.py check",
        "#",
        "# Single source of truth for:",
        "#   vector slots -> src/modules/rom.vectors.bank[1-f].asm",
        "#   stub blocks  -> src/modules/rom.stubs.bank[1-7].asm",
        "# Block order within a @stubs section is significant: it fixes the",
        "# address of every stub and trampoline helper in the ROM image.",
        "#",
        "# Record types (inside sections):",
        "#   slot N <label|TRAP> [purpose]   vector slot 1-64",
        '#   stub <label> bank<D> vec.<N> trmp helper=<h> form=<jmp|bindirect> comment=".."',
        "#   stub <label> bank<D> vec.<N> inline variant=<plain|exitlabel|regs>",
        "#   raw  <name.blk> [bank<D> vec.<N>]   verbatim block",
    ]

    for bank in VECTOR_BANKS:
        slots = parse_vectors(os.path.join(SRC, f"rom.vectors.bank{bank}.asm"))
        used = sum(1 for t, _ in slots.values() if t != "TRAP")
        reg.append("")
        reg.append(f"@vectors bank{bank}   # {used}/64 slots used")
        for s in range(1, 65):
            target, comment = slots[s]
            line = f"slot {s:2d} {target}"
            if comment:
                line += f"  {comment}"
            reg.append(line)

    counts = {"trmp": 0, "inline": 0, "raw": 0}
    raw_report = []
    for bank in STUB_BANKS:
        blocks = parse_stub_file(os.path.join(SRC, f"rom.stubs.bank{bank}.asm"))
        reg.append("")
        reg.append(f"@stubs bank{bank}")
        for blk in blocks:
            counts[blk.kind] += 1
            if blk.kind == "raw":
                name = (f"bank{bank}-{counts['raw']:02d}-"
                        f"{re.sub(r'[^A-Za-z0-9._-]', '_', blk.label)}.blk")
                with open(os.path.join(RAWDIR, name), "w", encoding="latin-1") as fh:
                    fh.write("\n".join(blk.text) + "\n")
                mapstr = f" bank{blk.dest} vec.{blk.vec}" if blk.dest else ""
                reg.append(f"raw  {name}{mapstr}")
                raw_report.append((bank, blk.label, name))
            elif blk.kind == "trmp":
                extra = f" desc={blk.desc}" if blk.desc else ""
                reg.append(
                    f'stub {blk.label} bank{blk.dest} vec.{blk.vec} trmp '
                    f'helper={blk.helper} form={blk.form} comment="{blk.comment}"{extra}')
            else:
                extra = f" desc={blk.desc}" if blk.desc else ""
                reg.append(
                    f"stub {blk.label} bank{blk.dest} vec.{blk.vec} inline "
                    f"variant={blk.variant}{extra}")

    with open(REGISTRY, "w", encoding="latin-1") as fh:
        fh.write("\n".join(reg) + "\n")
    print(f"wrote {REGISTRY}")
    print(f"stub blocks: trmp={counts['trmp']} inline={counts['inline']} raw={counts['raw']}")
    for bank, label, name in raw_report:
        print(f"  raw bank{bank}: {label} -> stub-raw/{name}")


# ---------------------------------------------------------------------------
# generate: registry -> src files
# ---------------------------------------------------------------------------

def load_registry():
    vectors, stubs = {}, {}
    section = None
    with open(REGISTRY, encoding="latin-1") as fh:
        for lineno, line in enumerate(fh, 1):
            line = line.rstrip("\n")
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            try:
                if line.startswith("@vectors "):
                    bank = re.match(r"@vectors bank(\w+)", line).group(1)
                    vectors[bank] = {}
                    section = "v"
                elif line.startswith("@stubs "):
                    bank = re.match(r"@stubs bank(\w+)", line).group(1)
                    stubs[bank] = []
                    section = "s"
                elif line.startswith("slot "):
                    m = re.match(r"slot\s+(\d+)\s+(\S+)(?:\s+(.*))?$", line)
                    assert m and section == "v", line
                    vectors[list(vectors)[-1]][int(m.group(1))] = (
                        m.group(2), (m.group(3) or "").strip())
                elif line.startswith(("stub ", "raw ")):
                    assert section == "s", line
                    parts = line.split()
                    if parts[0] == "raw":
                        blk = {"kind": "raw", "file": parts[1]}
                        if len(parts) > 2:
                            blk["dest"] = re.match(r"bank(\w)", parts[2]).group(1)
                            blk["vec"] = int(parts[3].split(".")[1])
                    else:
                        kv = dict(t.split("=", 1) for t in parts[5:] if "=" in t)
                        blk = {
                            "kind": parts[4],
                            "label": parts[1],
                            "dest": re.match(r"bank(\w)", parts[2]).group(1),
                            "vec": int(parts[3].split(".")[1]),
                        }
                        md = re.search(r"\bdesc=(\* .*)$", line)
                        if md:
                            blk["desc"] = md.group(1)
                        if blk["kind"] == "trmp":
                            mc = re.search(r'comment="([^"]*)"', line)
                            blk["helper"] = kv["helper"]
                            blk["form"] = kv["form"]
                            blk["comment"] = mc.group(1) if mc else "Longjump"
                        else:
                            blk["variant"] = kv["variant"]
                    stubs[list(stubs)[-1]].append(blk)
                else:
                    sys.exit(f"registry:{lineno}: unrecognized line: {line}")
            except (AssertionError, AttributeError, IndexError, KeyError) as exc:
                sys.exit(f"registry:{lineno}: cannot parse: {line!r} ({exc})")
    return vectors, stubs


def render_stub_block(blk):
    if blk["kind"] == "raw":
        with open(os.path.join(RAWDIR, blk["file"]), encoding="latin-1") as fh:
            return fh.read().rstrip("\n").split("\n")
    body = (trmp_body(blk["label"], blk["vec"], blk["helper"], blk["form"],
                      blk["comment"])
            if blk["kind"] == "trmp" else
            inline_body(blk["label"], blk["dest"], blk["vec"], blk["variant"]))
    header = blk.get("desc") or f'* Stub for "{blk["label"]}"'
    return [BANNER,
            header,
            f'* bank{blk["dest"]} vec.{blk["vec"]}',
            SUBBAN] + body


def render_stub_file(bank, blocks):
    out = [
        f"* FILE......: rom.stubs.bank{bank}.asm",
        f"* Purpose...: Bank {bank.upper()} stubs for functions in other banks",
        "",
    ]
    for blk in blocks:
        out += render_stub_block(blk)
        out.append("")
    return "\n".join(out).rstrip("\n") + "\n"


def do_generate(vectors, stubs, outdir):
    written = []
    for bank in VECTOR_BANKS:
        if bank not in vectors:
            sys.exit(f"error: registry has no @vectors section for bank{bank}")
        path = os.path.join(outdir, f"rom.vectors.bank{bank}.asm")
        with open(path, "w", encoding="latin-1") as fh:
            fh.write(render_vectors(bank, vectors[bank]))
        written.append(path)
    for bank in STUB_BANKS:
        if bank not in stubs:
            sys.exit(f"error: registry has no @stubs section for bank{bank}")
        path = os.path.join(outdir, f"rom.stubs.bank{bank}.asm")
        with open(path, "w", encoding="latin-1") as fh:
            fh.write(render_stub_file(bank, stubs[bank]))
        written.append(path)
    for bank in EMPTY_STUB_BANKS:
        path = os.path.join(outdir, f"rom.stubs.bank{bank}.asm")
        with open(path, "w", encoding="latin-1") as fh:
            fh.write(
                f"* FILE......: rom.stubs.bank{bank}.asm\n"
                f"* Purpose...: Bank {bank.upper()} stubs for functions in other banks\n")
        written.append(path)
    return written


def cmd_generate(args):
    vectors, stubs = load_registry()
    outdir = args.out or SRC
    os.makedirs(outdir, exist_ok=True)
    written = do_generate(vectors, stubs, outdir)
    print(f"generated {len(written)} files into {outdir}")


# ---------------------------------------------------------------------------
# check: drift guard for the build pipeline
# ---------------------------------------------------------------------------

def cmd_check(_args):
    vectors, stubs = load_registry()
    with tempfile.TemporaryDirectory() as tmp:
        do_generate(vectors, stubs, tmp)
        drift = []
        for name in sorted(os.listdir(tmp)):
            new = open(os.path.join(tmp, name), encoding="latin-1").read()
            old_path = os.path.join(SRC, name)
            if not os.path.exists(old_path):
                print(f"MISSING in src: {name}")
                drift.append(name)
                continue
            old = open(old_path, encoding="latin-1").read()
            if new != old:
                drift.append(name)
                diff = list(difflib.unified_diff(
                    old.splitlines(), new.splitlines(),
                    fromfile=f"src/modules/{name}", tofile="generated", lineterm="", n=1))
                print("\n".join(diff[:40]))
                if len(diff) > 40:
                    print(f"... ({len(diff)} diff lines total)")
        if drift:
            print(f"\nDRIFT in {len(drift)} file(s): {', '.join(drift)}")
            print("fix: python3 build/gen_vectors.py generate   (then commit)")
            sys.exit(1)
    print("gen_vectors check: src matches registry (vectors + stubs up to date)")


# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("extract", help="src -> registry").set_defaults(func=cmd_extract)
    g = sub.add_parser("generate", help="registry -> src")
    g.add_argument("--out", help="output dir (default: src/modules)")
    g.set_defaults(func=cmd_generate)
    sub.add_parser("check", help="fail if src drifted").set_defaults(func=cmd_check)
    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Stevie cross-bank trampoline layer: registry extract / generate / check.

The cross-bank call layer consists of:
  - vector tables: src/modules/rom.vectors.bank[0-f].asm  (slot -> target label)
  - stubs:         src/modules/rom.stubs.bank[1-7].asm    (label -> bank+slot)

Single source of truth after generation:
  - build/vector-registry.txt   (vector slots + ordered stub blocks)
  - build/stub-raw/*.blk        (verbatim whole-block text for irregular stubs)

Run from anywhere: python3 build/tools/gen_vectors.py <command>

Hand-written, never generated:
  - rom.vectors.bank0.asm       (equ-based boot vectors)
  - rom.stubs.bankx.asm         (.ifgt conditional SAMS stubs)

Table geometry (see bankx.* in src/modules/equ.rom.build.asm):
  slots 1-32    main table at bankx.vectab, present in every bank
  slots 33-48   extension island at bankx.exttab, emitted only for banks that
                need more than 32 entry points; other banks get those bytes as
                program space instead. Call sites address them as
                bankx.exttab+2*(slot-33), which is bank independent just like
                the vec.N labels, because rom.farjump dereferences p1 after
                switching to the target bank.

Commands:
  extract    parse src -> rewrite registry + raw blocks
  generate   parse registry -> write src files (--out DIR for dry run)
  compact    pack slot numbers per bank (--reap also frees unreferenced slots)
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
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))     # build/tools
BUILD = os.path.dirname(HERE)                         # build
ROOT = os.path.dirname(BUILD)                         # stevie
SRC = os.path.join(ROOT, "src", "modules")
REGISTRY = os.path.join(BUILD, "vector-registry.txt")
RAWDIR = os.path.join(BUILD, "stub-raw")

VECTOR_BANKS = [f"{i:x}" for i in range(1, 16)]        # bank1..bankf (0 excluded)
STUB_BANKS = [str(i) for i in range(1, 8)]             # banks with stub content
EMPTY_STUB_BANKS = [f"{i:x}" for i in range(8, 16)]    # placeholder stub files

BANNER = "*" * 63
SUBBAN = "********|*****|*********************|**************************"
RULE = "*" + "-" * 62
COL = 36   # source column where inline comments start

# ---------------------------------------------------------------------------
# Vector table geometry
#
# Every bank ends with fixed AORG islands (bankx.* equates in
# src/modules/equ.rom.build.asm):
#
#     code ......  up to the lowest island below               (.ifge guard)
#     exttab       vector extension, slots 33-48 - only banks that need more
#                  than 32 entry points carry it (today: bank3 and bank4)
#     vectab       main vector table, slots 1-32 (every bank has one)
#     vdptab       VDP mode tables
#     >7fea        ROM identification string 'ROM#n'
#     >7ff0        cpu.crash.showbank
#
# A call site only needs the *address* of the target slot, and rom.farjump
# dereferences it after switching banks. Slots 1-32 therefore use the local
# vec.N label (all banks put their table at the same address) and slots 33-48
# use bankx.exttab+offset, which is bank independent as well.
# ---------------------------------------------------------------------------
SLOTS_MAIN = 32
SLOTS_EXT = 16
SLOT_MAX = SLOTS_MAIN + SLOTS_EXT
ROM_ID_STRING = 0x7FEA        # 'ROM#n' aorg emitted below the tables
MAIN_FILE_CEILING = re.compile(r"(?P<pre>\.ifge\s+\$,\s+>)"
                               r"(?P<addr>[0-9a-fA-F]{4})")
LAYOUT_EQU = re.compile(r"^(bankx\.[\w.]+)\s+equ\s+>([0-9a-fA-F]{4})")


def slot_operand(slot):
    """Operand a call site uses to reference vector slot N."""
    if not 1 <= slot <= SLOT_MAX:
        sys.exit(f"error: vector slot {slot} outside 1-{SLOT_MAX}")
    if slot <= SLOTS_MAIN:
        return f"vec.{slot}"
    return f"bankx.exttab+{2 * (slot - SLOTS_MAIN - 1)}"


def slot_from_ref(ref):
    """Inverse of slot_operand(); None when ref is not a vector reference."""
    ref = ref.strip()
    m = re.fullmatch(r"vec\.(\d+)", ref)
    if m:
        return int(m.group(1))
    m = re.fullmatch(r"bankx\.exttab\+(\d+)", ref)
    if m and int(m.group(1)) % 2 == 0:
        return SLOTS_MAIN + int(m.group(1)) // 2 + 1
    return None


def read_layout():
    """bankx.* equates from src/modules/equ.rom.build.asm (address source)."""
    equs = {}
    with open(os.path.join(SRC, "equ.rom.build.asm"), encoding="latin-1") as fh:
        for line in fh:
            m = LAYOUT_EQU.match(line)
            if m:
                equs[m.group(1)] = int(m.group(2), 16)
    return equs


def layout_errors(equs):
    """Validate the island map: no overlaps, everything below 'ROM#n'."""
    errs = []
    need = ("bankx.exttab", "bankx.vectab", "bankx.vdptab",
            "bankx.crash.showbank")
    missing = [k for k in need if k not in equs]
    if missing:
        return [f"equ.rom.build.asm: missing layout equates {missing}"]
    ext, vec = equs["bankx.exttab"], equs["bankx.vectab"]
    vdp, crash = equs["bankx.vdptab"], equs["bankx.crash.showbank"]
    if ext + 2 * SLOTS_EXT > vec:
        errs.append(f"extension island (>{ext:04x}, {2 * SLOTS_EXT}B) overlaps "
                    f"the main table at >{vec:04x}")
    if vec + 2 * SLOTS_MAIN > vdp:
        errs.append(f"main table (>{vec:04x}, {2 * SLOTS_MAIN}B) overlaps the "
                    f"VDP mode tables at >{vdp:04x}")
    if vdp + 32 > ROM_ID_STRING:
        errs.append(f"VDP mode tables (>{vdp:04x}, 32B) reach the ROM id "
                    f"string at >{ROM_ID_STRING:04x}")
    if crash < vdp + 32:
        errs.append(f"cpu.crash.showbank (>{crash:04x}) overlaps the VDP mode "
                    f"tables")
    return errs


def uses_ext_slots(slots):
    """True when a bank has entry points in the extension island."""
    return any(t != "TRAP" for s, (t, _) in slots.items() if s > SLOTS_MAIN)


# Registry preamble (shared by extract and convert-lean).
REGISTRY_HEADER = [
    "# Stevie cross-bank trampoline registry",
    "# Generated by build/tools/gen_vectors.py extract; hand-editable.",
    "# After editing run:  python3 build/tools/gen_vectors.py generate",
    "# Build guard:        python3 build/tools/gen_vectors.py check",
    "#",
    "# Single source of truth for:",
    "#   vector slots -> src/modules/rom.vectors.bank[1-f].asm",
    "#   stub blocks  -> src/modules/rom.stubs.bank[1-7].asm",
    "# Block order within a @stubs section is significant: it fixes the",
    "# address of every stub and trampoline helper in the ROM image.",
    "#",
    "# Slot numbers are addresses, not identities: slots 1-32 live in every",
    "# bank's main table, slots 33-48 in that bank's extension island.",
    "# Run 'compact [--reap]' to pack a bank's entry points without gaps.",
    "#",
    "# Record types (inside sections):",
    "#   slot N <label|TRAP> [purpose]   vector slot 1-32, or 33-48 when the",
    "#                                   bank carries the extension island",
    '#   stub <label> bank<D> vec.<N> trmp helper=<h> form=<jmp|bindirect> comment=".."',
    "#   stub <label> bank<D> vec.<N> lean  form=<jmp|bindirect>",
    "#   stub <label> bank<D> vec.<N> inline variant=<plain|exitlabel|regs>",
    "#   helper bank<D>                       shared tail-jump trampoline",
    "#   raw  <name.blk> [bank<D> vec.<N>]   verbatim block",
]


def normalize_slots(slots):
    """Complete the main table and keep the extension island all-or-nothing.

    Slots are addressed as vectab+2*(N-1) and exttab+2*(N-33), so a bank that
    uses any extension slot emits the whole 32-byte island; unused entries are
    TRAP-filled to keep those addresses stable."""
    for s in slots:
        if not 1 <= s <= SLOT_MAX:
            sys.exit(f"error: vector slot {s} outside 1-{SLOT_MAX}")
    for s in range(1, SLOTS_MAIN + 1):
        slots.setdefault(s, ("TRAP", ""))
    if uses_ext_slots(slots):
        for s in range(SLOTS_MAIN + 1, SLOT_MAX + 1):
            slots.setdefault(s, ("TRAP", ""))
    else:
        for s in [s for s in slots if s > SLOTS_MAIN]:
            del slots[s]
    return slots


def ceiling_errors(vectors):
    """Every bank main file guards its free space with '.ifge $, >xxxx'.

    That limit must equal the lowest island the bank actually carries: a bank
    that gains an extension island has to lower it, or code would be silently
    overwritten by the island."""
    equs = read_layout()
    errs = layout_errors(equs)
    for bank in VECTOR_BANKS:
        path = os.path.join(ROOT, "src", f"stevie_b{bank}.asm")
        if not os.path.exists(path):
            continue
        with open(path, encoding="latin-1") as fh:
            m = next((MAIN_FILE_CEILING.search(ln) for ln in fh
                      if MAIN_FILE_CEILING.search(ln)), None)
        if not m:
            errs.append(f"stevie_b{bank}.asm: no '.ifge $, >xxxx' bank guard")
            continue
        want = (equs["bankx.exttab"] if uses_ext_slots(vectors[bank])
                else equs["bankx.vectab"])
        got = int(m.group("addr"), 16)
        if got != want:
            what = ("vector extension island"
                    if uses_ext_slots(vectors[bank]) else "main vector table")
            errs.append(f"stevie_b{bank}.asm: bank guard is >{got:04x} but the "
                        f"{what} starts at >{want:04x}")
    return errs


def cmt(code, comment):
    """Assemble one source line; comment begins with ';' and lands at COL."""
    if comment is None:
        return code
    return code.ljust(COL) + comment if len(code) < COL else f"{code} {comment}"


# ---------------------------------------------------------------------------
# Templates for the two regular stub shapes (canonical formatting)
# ---------------------------------------------------------------------------

def vector_comment(vec):
    """Comment for the p1 operand of a farjump triple."""
    if vec <= SLOTS_MAIN:
        return "; | i  p1 = Vector with target address"
    return f"; | i  p1 = Vector in bankx.exttab (slot {vec})"


def farjump_block(dest, vec):
    d = dest.upper()
    return [
        "        ;------------------------------------------------------",
        f"        ; Call function in bank {d}",
        "        ;------------------------------------------------------",
        cmt("        bl    @rom.farjump", r"; \ Trampoline jump to bank"),
        cmt(f"              data bank{dest}.rom", "; | i  p0 = bank address"),
        cmt(f"              data {slot_operand(vec)}", vector_comment(vec)),
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
        f"        data  {slot_operand(vec)}",
    ]


def helper_body(dest):
    """Shared tail-jump trampoline for one target bank (lean stub form).

    One instance per (stub bank, target bank) pair replaces the per-stub
    push+farjump sequence: lean stubs store their vector in @trmpvector and
    jump here; rom.farjump derefs p1 = >ffff from @trmpvector after the bank
    switch (scratchpad is bank-independent)."""
    return [
        f"_trampoline.bank{dest}.ret:",
        "        dect  stack",
        cmt("        mov   r11,*stack", "; Save return address"),
        "        ;------------------------------------------------------",
        f"        ; Call routine in bank {dest.upper()}",
        "        ;------------------------------------------------------",
        cmt("        bl    @rom.farjump", r"; \ Trampoline jump to bank"),
        cmt(f"              data bank{dest}.rom", "; | i  p0 = bank address"),
        cmt("              data >ffff",
            "; | i  p1 = Vector with target address"),
        "                                    ; |         (deref @trmpvector)",
        cmt("              data bankid", "; / i  p2 = Source ROM bank for return"),
        "        ;------------------------------------------------------",
        "        ; Exit",
        "        ;------------------------------------------------------",
        cmt("        mov   *stack+,r11", "; Pop r11"),
        cmt("        b     *r11", "; Return to caller"),
    ]


def lean_body(label, vec, helper, form):
    return trmp_body(label, vec, helper, form, "Longjump")


# ---------------------------------------------------------------------------
# Parsing: vector tables
# ---------------------------------------------------------------------------

VEC_RE = re.compile(r"^(vec|extvec)\.(\d+)\s+data\s+(\S+)\s*(?:;\s?(.*))?\s*$")

# Bank-specific table quirks (the aorg itself always comes from bankx.vectab:
# every bank must place its table at the same address for vec.N to work).
BANK_META = {"8": {"trapfill": "0"}}


def parse_vectors(path):
    slots = {}
    with open(path, encoding="latin-1") as fh:
        for line in fh:
            m = VEC_RE.match(line.rstrip())
            if not m:
                continue
            slot = int(m.group(2))          # extvec.N keeps the same number
            lo, hi = ((1, SLOTS_MAIN) if m.group(1) == "vec"
                      else (SLOTS_MAIN + 1, SLOT_MAX))
            if not lo <= slot <= hi:
                sys.exit(f"error: {path}: {m.group(1)}.{slot} outside "
                         f"{lo}-{hi}")
            target, comment = m.group(3), (m.group(4) or "").strip()
            if target in ("cpu.crash", "0"):
                target, comment = "TRAP", ""
            slots[slot] = (target, comment)
    missing = [s for s in range(1, SLOTS_MAIN + 1) if s not in slots]
    if missing:
        sys.exit(f"error: {path}: vector slots missing: {missing}")
    over = [s for s in slots if s > SLOT_MAX]
    if over:
        sys.exit(f"error: {path}: slots beyond the extension island: {over}")
    if uses_ext_slots(slots):
        # The island is a fixed 32-byte block; fill the gaps so slot numbers
        # keep meaning bankx.exttab + 2*(slot-33).
        for s in range(SLOTS_MAIN + 1, SLOT_MAX + 1):
            slots.setdefault(s, ("TRAP", ""))
    else:
        for s in [s for s in slots if s > SLOTS_MAIN]:
            del slots[s]
    return slots


def render_vectors(bank, slots):
    meta = BANK_META.get(bank, {})
    trapfill = meta.get("trapfill", "cpu.crash")
    hexb = bank.upper()

    def slot_lines(lo, hi):
        """One line per slot: 'vec.N' in the main table, 'extvec.N' in the
        extension island (labels differ, the address of both is fixed)."""
        lines = []
        for s in range(lo, hi + 1):
            target, comment = slots[s]
            operand = trapfill if target == "TRAP" else target
            label = f"{'extvec' if s > SLOTS_MAIN else 'vec'}.{s}"
            code = f"{label:<{max(8, len(label) + 1)}}data  {operand}"
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
        f"* ROM {hexb}: Vectors 1-{SLOTS_MAIN} (main table, bankx.vectab)",
        RULE,
        "        aorg  bankx.vectab",
    ]
    out += slot_lines(1, SLOTS_MAIN)
    if uses_ext_slots(slots):
        out += [
            RULE,
            f"* ROM {hexb}: Vectors {SLOTS_MAIN + 1}-{SLOT_MAX} "
            f"(extension island, bankx.exttab)",
            "*           Referenced from other banks as bankx.exttab+offset",
            RULE,
            "        aorg  bankx.exttab",
        ]
        out += slot_lines(SLOTS_MAIN + 1, SLOT_MAX)
    out += [
        "",
        RULE,
        "* ROM identification string for CPU crash",
        RULE,
        "cpu.crash.showbank.bankstr:",
        f"        aorg >{ROM_ID_STRING:04x}",
        f"        stri 'ROM#{hexb}'",
    ]
    return "\n".join(out) + "\n"


# ---------------------------------------------------------------------------
# Parsing: stub files
# ---------------------------------------------------------------------------

class Block:
    def __init__(self, kind):
        self.kind = kind          # trmp | lean | inline | helper | raw
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
    r"        data  (?P<ref>\S+)$"      # vec.N or bankx.exttab+offset
)

FJ_RE = re.compile(
    r"bl    @rom\.farjump[^\n]*\n\s+data\s+bank(\w)\.rom\b[^\n]*\n"
    r"\s+data\s+(\S+)[^\n]*\n\s+data\s+bankid"   # vec.N or bankx.exttab+N
)


def ref_slot(ref, where):
    """Slot number behind a parsed vector reference; aborts on garbage."""
    slot = slot_from_ref(ref)
    if slot is None:
        sys.exit(f"error: {where}: '{ref}' is not a vector slot reference")
    return slot


def norm_lines(lines):
    """Code-only view of a block: strip comments/blank lines, collapse runs
    of spaces. Used to recognize template-shaped blocks whose comments were
    hand-worded differently (comments don't assemble, so the ROM bytes of a
    re-rendered block are unchanged)."""
    out = []
    for ln in lines:
        code = ln.split(";", 1)[0].rstrip()
        if code.strip():
            out.append(" ".join(code.split()))
    return out


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
        blk.vec = ref_slot(m.group("ref"), f"stub block '{blk.label}'")
        blk.comment = m.group("comment").strip() or "Longjump"
        canon = f'* Stub for "{blk.label}"'
        if hdr and hdr != canon:
            blk.desc = hdr
        # Canonical lean form: standard helper name + default comment.
        if (blk.comment == "Longjump"
                and blk.helper == f"_trampoline.bank{blk.dest}.ret"):
            blk.kind = "lean"
        return blk

    fj = FJ_RE.findall(text)
    lm = re.match(r"^(\S+):", text, re.M)
    if len(fj) == 1 and lm and slot_from_ref(fj[0][1]):
        label = lm.group(1)
        dest, vec = fj[0][0], ref_slot(fj[0][1], f"stub '{lm.group(1)}'")
        for variant in ("plain", "exitlabel", "regs"):
            tmpl = inline_body(label, dest, vec, variant)
            # Tolerant fallback: same code, hand-worded comments. Re-rendering
            # the canonical template keeps ROM bytes identical.
            if tmpl == body or norm_lines(tmpl) == norm_lines(body):
                blk = Block("inline")
                blk.label, blk.dest, blk.vec, blk.variant = label, dest, vec, variant
                canon = f'* Stub for "{label}"'
                if hdr and hdr != canon:
                    blk.desc = hdr
                return blk

    # Shared tail-jump helper (lean stub target); comments may differ.
    hm = re.match(r"_trampoline\.bank(\w)\.ret:", text)
    if hm and (body == helper_body(hm.group(1))
               or norm_lines(body) == norm_lines(helper_body(hm.group(1)))):
        blk = Block("helper")
        blk.label = f"_trampoline.bank{hm.group(1)}.ret"
        blk.dest = hm.group(1)
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
        code_dest, code_vec = fj[0][0], slot_from_ref(fj[0][1])
    else:
        hm = re.search(r"jmp   _trampoline\.bank(\w)|b     @_trampoline\.bank(\w)", text)
        vm = re.search(r"\.vector:\n\s+data  (\S+)", text)
        if hm:
            code_dest = hm.group(1) or hm.group(2)
        if vm:
            code_vec = slot_from_ref(vm.group(1))
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

    reg = list(REGISTRY_HEADER)

    for bank in VECTOR_BANKS:
        slots = parse_vectors(os.path.join(SRC, f"rom.vectors.bank{bank}.asm"))
        used = sum(1 for t, _ in slots.values() if t != "TRAP")
        reg.append("")
        reg.append(f"@vectors bank{bank}   # {used}/{SLOT_MAX} slots used"
                   + ("  [extension island]" if uses_ext_slots(slots) else ""))
        for s in sorted(slots):
            target, comment = slots[s]
            line = f"slot {s:2d} {target}"
            if comment:
                line += f"  {comment}"
            reg.append(line)

    counts = {"trmp": 0, "lean": 0, "inline": 0, "helper": 0, "raw": 0}
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
            elif blk.kind == "lean":
                extra = f" desc={blk.desc}" if blk.desc else ""
                reg.append(
                    f'stub {blk.label} bank{blk.dest} vec.{blk.vec} lean '
                    f'form={blk.form}{extra}')
            elif blk.kind == "helper":
                reg.append(f"helper bank{blk.dest}")
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
        print(f"  raw bank{bank}: {label} -> build/stub-raw/{name}")


# ---------------------------------------------------------------------------
# generate: registry -> src files
# ---------------------------------------------------------------------------

# Pre-extension registries numbered slots up to 64; compact accepts those so
# it can migrate them, everything else insists on the current geometry.
LEGACY_SLOT_MAX = 64


def load_registry(slot_limit=SLOT_MAX, normalize=True):
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
                    slot = int(m.group(1))
                    if not 1 <= slot <= slot_limit:
                        raise ValueError(f"slot {slot} outside 1-{slot_limit}")
                    vectors[list(vectors)[-1]][slot] = (
                        m.group(2), (m.group(3) or "").strip())
                elif line.startswith(("stub ", "raw ", "helper ")):
                    assert section == "s", line
                    parts = line.split()
                    if parts[0] == "raw":
                        blk = {"kind": "raw", "file": parts[1]}
                        if len(parts) > 2:
                            blk["dest"] = re.match(r"bank(\w)", parts[2]).group(1)
                            blk["vec"] = int(parts[3].split(".")[1])
                    elif parts[0] == "helper":
                        blk = {"kind": "helper",
                               "dest": re.match(r"bank(\w)", parts[1]).group(1)}
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
                        if blk["kind"] in ("trmp", "lean"):
                            mc = re.search(r'comment="([^"]*)"', line)
                            blk["helper"] = kv.get(
                                "helper", f"_trampoline.bank{blk['dest']}.ret")
                            blk["form"] = kv["form"]
                            blk["comment"] = (mc.group(1) if mc
                                              else "Longjump")
                        else:
                            blk["variant"] = kv["variant"]
                    stubs[list(stubs)[-1]].append(blk)
                else:
                    sys.exit(f"registry:{lineno}: unrecognized line: {line}")
            except (AssertionError, AttributeError, IndexError, KeyError,
                    ValueError) as exc:
                sys.exit(f"registry:{lineno}: cannot parse: {line!r} ({exc})")
    if normalize:
        for bank in vectors:
            normalize_slots(vectors[bank])
    return vectors, stubs


def render_stub_block(blk):
    if blk["kind"] == "raw":
        with open(os.path.join(RAWDIR, blk["file"]), encoding="latin-1") as fh:
            return fh.read().rstrip("\n").split("\n")
    kind = blk["kind"]
    if kind == "helper":
        return [BANNER,
                f"* Trampoline bank {blk['dest'].upper()} with return",
                SUBBAN] + helper_body(blk["dest"])
    body = (trmp_body(blk["label"], blk["vec"], blk["helper"], blk["form"],
                      blk["comment"])
            if kind in ("trmp", "lean") else
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
        "*",
        "* GENERATED FILE - DO NOT EDIT. Content and block order are derived",
        "* from build/vector-registry.txt; edit the registry (or re-run",
        "* 'gen_vectors.py extract' after moving code) and regenerate with:",
        "*     python3 build/tools/gen_vectors.py generate",
        "* The build aborts on drift ('gen_vectors.py check'). Exception that",
        "* stays hand-written: rom.stubs.bankx.asm (conditional SAMS stubs).",
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
            fh.write(render_stub_file(bank, []))
        written.append(path)
    return written


def cmd_generate(args):
    vectors, stubs = load_registry()
    outdir = args.out or SRC
    os.makedirs(outdir, exist_ok=True)
    written = do_generate(vectors, stubs, outdir)
    print(f"generated {len(written)} files into {outdir}")


# ---------------------------------------------------------------------------
# convert-lean: rewrite pass-through inline stubs to the lean tail-jump form
# ---------------------------------------------------------------------------

LIST_DIR = os.path.join(BUILD, "list")
GEN_LINE_RE = re.compile(r"^[0-9A-F]{4}\s+([0-9A-F]{4})")

# Exact emitted sizes in bytes (verified against build/list listings).
SZ_INLINE_PLAIN = 18       # dect/push + bl@farjump + 3 operands + pop/return
SZ_LEAN = 10               # mov @v.vector,@trmpvector (4) + jmp helper (4) + data vec.N (2)
SZ_HELPER = 18             # shared per-target-bank trampoline (listing-measured)
MIN_STUBS_FOR_NEW_HELPER = 3   # helper pays off only from 3 pass-throughs on


def measure_stub_labels(bank):
    """label -> address from the xas99 symbol dump at the end of the listing.

    Symbols are unique per assembly unit, and stub blocks are laid out in
    source order, so sorted addresses give exact block spans."""
    lst = os.path.join(LIST_DIR, f"stevie_b{bank}.lst")
    if not os.path.exists(lst):
        return None
    sym_re = re.compile(r"^\s+(\S+\.?\S*)\s+>([0-9a-fA-F]{4})\s*:")
    out = {}
    with open(lst, encoding="latin-1", errors="replace") as fh:
        for line in fh:
            m = sym_re.match(line)
            if m:
                addr = int(m.group(2), 16)
                if 0x6000 <= addr < 0x8000:
                    out.setdefault(m.group(1), addr)
    return out or None


def raw_label(blk):
    """Stub label encoded in a raw block filename: bankN-NN-<label>.blk"""
    m = re.match(r"bank\w-\d+-(.+)\.blk$", blk["file"])
    return m.group(1) if m else None


def measure_bytes(blocks, sizes):
    """Per-block size in bytes: exact templates or listing-measured raw spans."""
    addrs = sorted(sizes.values())
    out = []
    for blk in blocks:
        kind = blk["kind"]
        if kind == "inline":
            out.append(24 if blk.get("variant") == "regs" else SZ_INLINE_PLAIN)
        elif kind in ("lean", "trmp"):
            out.append(SZ_LEAN)
        elif kind == "helper":
            out.append(SZ_HELPER)
        else:
            label = raw_label(blk) if kind == "raw" else blk.get("label")
            a = sizes.get(label or "")
            if a is None:
                out.append(48)     # conservative for unmeasurable raw blocks
                continue
            nxt = next((x for x in addrs if x > a), a + 0x30)
            out.append(max(4, nxt - a))
    return out


def convert_bank(blocks, sizes):
    """Rewrite pass-through inline stubs as lean blocks + shared helpers.

    A helper is emitted at the position of the first converted stub that needs
    its target bank; later stubs to the same bank jump back to it (or use
    b-indirect when outside the +-256-byte branch range).

    A target bank with no helper yet costs SZ_HELPER bytes, so it only pays
    off from MIN_STUBS_FOR_NEW_HELPER stubs onwards; below that the block is
    left in its inline form."""
    out, pos, active = [], 0, {}
    nbytes = measure_bytes(blocks, sizes)
    per_dest = Counter(b["dest"] for b in blocks
                       if b["kind"] == "inline" and b.get("variant") == "plain")
    # Helpers already present in the block list are valid jump targets; never
    # emit a second one with the same label.
    scan = 0
    for blk, nb in zip(blocks, nbytes):
        if blk["kind"] == "helper" and blk["dest"] not in active:
            active[blk["dest"]] = scan
        scan += nb
    converted = helpers = skipped = 0
    for blk, nb in zip(blocks, nbytes):
        if not (blk["kind"] == "inline" and blk.get("variant") == "plain"):
            out.append(blk)
            pos += nb
            continue
        dest = blk["dest"]
        if dest not in active:
            if per_dest[dest] < MIN_STUBS_FOR_NEW_HELPER:
                skipped += 1
                out.append(blk)
                pos += nb
                continue
            active[dest] = pos                   # helper emitted here
            out.append({"kind": "helper", "dest": dest})
            pos += SZ_HELPER
            helpers += 1
        dist_bytes = active[dest] - pos          # negative: helper lies below
        form = "jmp" if -256 <= dist_bytes <= 254 else "bindirect"
        out.append({"kind": "lean", "label": blk["label"], "dest": dest,
                    "vec": blk["vec"], "helper": f"_trampoline.bank{dest}.ret",
                    "form": form})
        pos += SZ_LEAN
        converted += 1
    return out, converted, helpers, skipped


def cmd_convert_lean(args):
    vectors, stubs = load_registry()
    banks = [args.bank] if args.bank else [b for b in STUB_BANKS if b != "1"]

    for bank in banks:
        sizes = measure_stub_labels(bank) or {}
        new_blocks, n_conv, n_help, n_skip = convert_bank(stubs[bank], sizes)
        stubs[bank] = new_blocks
        extra = f" skipped(too few to target)={n_skip}" if n_skip else ""
        print(f"bank{bank}: converted={n_conv} helpers={n_help}{extra}")

    if args.dry:
        print("dry run: registry not modified")
        return
    write_registry(vectors, stubs)
    print(f"wrote {REGISTRY}")


def write_registry(vectors, stubs):
    reg = list(REGISTRY_HEADER)
    for bank in VECTOR_BANKS:
        slots = normalize_slots(vectors[bank])
        used = sum(1 for t, _ in slots.values() if t != "TRAP")
        reg.append("")
        reg.append(f"@vectors bank{bank}   # {used}/{SLOT_MAX} slots used"
                   + ("  [extension island]" if uses_ext_slots(slots) else ""))
        for s in sorted(slots):
            target, comment = slots[s]
            line = f"slot {s:2d} {target}"
            if comment:
                line += f"  {comment}"
            reg.append(line)
    for bank in STUB_BANKS:
        reg.append("")
        reg.append(f"@stubs bank{bank}")
        for blk in stubs[bank]:
            k = blk["kind"]
            extra = f" desc={blk['desc']}" if blk.get("desc") else ""
            if k == "raw":
                mapstr = (f" bank{blk['dest']} vec.{blk['vec']}"
                          if blk.get("dest") else "")
                reg.append(f"raw  {blk['file']}{mapstr}")
            elif k == "helper":
                reg.append(f"helper bank{blk['dest']}")
            elif k == "lean":
                reg.append(f"stub {blk['label']} bank{blk['dest']} "
                           f"vec.{blk['vec']} lean form={blk['form']}{extra}")
            elif k == "trmp":
                reg.append(f'stub {blk["label"]} bank{blk["dest"]} '
                           f'vec.{blk["vec"]} trmp helper={blk["helper"]} '
                           f'form={blk["form"]} comment="{blk["comment"]}"{extra}')
            else:
                reg.append(f"stub {blk['label']} bank{blk['dest']} "
                           f"vec.{blk['vec']} inline variant={blk['variant']}{extra}")
    with open(REGISTRY, "w", encoding="latin-1") as fh:
        fh.write("\n".join(reg) + "\n")


# ---------------------------------------------------------------------------
# References outside the registry
#
# Hand-written farjumps (rom.stubs.bankx.asm and inline triples in ordinary
# modules) and `data vec.N` inside raw blocks name a slot directly, so they
# have to move with a renumbered slot. compact rewrites them; check verifies
# that each one still points at a filled slot.
# ---------------------------------------------------------------------------
BANK_ROM_RE = re.compile(r"\bbank(\w)\.rom\b")
SLOT_TOKEN_RE = re.compile(r"vec\.(\d+)|bankx\.exttab\+(\d+)")
SLOT_COMMENT_RE = re.compile(
    r"^(?P<pre>\s*\*\s+bank(?P<bank>\w)\s+vec\.)(?P<slot>\d+)\b")
GENERATED_SRC = re.compile(r"rom\.(vectors|stubs)\.bank[0-9a-f]\.asm$")


def ref_files():
    """Hand-written sources that may reference a vector slot."""
    files = ([os.path.join(RAWDIR, n) for n in sorted(os.listdir(RAWDIR))]
             if os.path.isdir(RAWDIR) else [])
    for name in sorted(os.listdir(SRC)):
        if name.endswith(".asm") and not GENERATED_SRC.match(name) \
                and not name.startswith("rom.vectors."):
            files.append(os.path.join(SRC, name))
    return files


def _token_slot(tok):
    """Slot number for a SLOT_TOKEN_RE match tuple."""
    return int(tok[0]) if tok[0] else SLOTS_MAIN + int(tok[1]) // 2 + 1


def find_slot_line(lines, i):
    """Line index holding the p1 vector operand of the call site at line i.

    Two spellings exist: the compact one-liner 'data bankX.rom,vec.N,bankid'
    and the spread triple where vec.N follows on the next line. Stops at the
    next 'bankX.rom' so two adjacent call sites can never be mixed up."""
    if SLOT_TOKEN_RE.search(lines[i]):
        return i
    for j in range(i + 1, min(i + 4, len(lines))):
        if SLOT_TOKEN_RE.search(lines[j]):
            return j
        if BANK_ROM_RE.search(lines[j]):
            break
    return None


def file_slot_refs(lines):
    """Every vector reference in one hand-written source: (lineno, bank, slot).

    Three spellings exist:
      * farjump triple - 'data bankX.rom' followed by the p1 operand
        ('data vec.N' or 'data bankx.exttab+N'), possibly on the same line;
      * a '* bankN vec.M' block header comment (documentation of the target);
      * a standalone '.vector:' data line, as used by trampoline stubs and the
        raw blocks that contain one. Its target bank comes from the nearest
        preceding block header comment, because the code itself only carries
        the slot number.
    """
    out, consumed = [], set()
    for i, line in enumerate(lines):
        m = BANK_ROM_RE.search(line)
        if not m:
            continue
        j = find_slot_line(lines, i)
        if j is None:
            continue
        tok = SLOT_TOKEN_RE.search(lines[j])
        out.append((j, m.group(1), _token_slot(tok.groups())))
        consumed.add(j)

    refs, header_bank = list(out), None      # farjump triples are complete
    for i, line in enumerate(lines):
        cm = SLOT_COMMENT_RE.match(line)
        if cm:
            header_bank = cm.group("bank")
            refs.append((i, cm.group("bank"), int(cm.group("slot"))))
            continue
        if i in consumed:
            continue
        tok = SLOT_TOKEN_RE.search(line)
        if not tok:
            continue
        if header_bank is None:
            sys.exit(f"error: {line.strip()}: vector reference without a "
                     f"'* bankN vec.M' block header to tell which bank it "
                     f"targets")
        refs.append((i, header_bank, _token_slot(tok.groups())))
    return sorted(refs)


def read_lines(path):
    with open(path, encoding="latin-1") as fh:
        return fh.read().splitlines()


def external_refs():
    """[(path, lineno, destbank, slot)] outside the registry."""
    out = []
    for path in ref_files():
        for lineno, bank, slot in file_slot_refs(read_lines(path)):
            out.append((path, lineno + 1, bank, slot))
    return out


def external_ref_errors(vectors):
    """Hand-written call sites that point at an empty or missing slot."""
    errs = []
    for path, lineno, bank, slot in external_refs():
        target = vectors.get(bank, {}).get(slot)
        if target is None or target[0] == "TRAP":
            errs.append(f"{os.path.basename(path)}:{lineno}: call site targets "
                        f"empty slot bank{bank} vec.{slot}")
    return errs


def _swap_token(line, bank, mapping, comment=False):
    """Rewrite the slot reference in one line; returns (line, changed).

    Code operands take the addressing form of their new slot (vec.N or
    bankx.exttab+N); comments always keep the plain 'bankN vec.M' spelling
    because they name the logical slot."""
    def sub(m):
        if comment:
            old, prefix = int(m.group("slot")), m.group("pre")
        else:
            old, prefix = _token_slot(m.groups()), ""
        new = mapping[bank].get(old, old)
        return prefix + (str(new) if comment else slot_operand(new))
    pat = SLOT_COMMENT_RE if comment else SLOT_TOKEN_RE
    new_line, n = pat.subn(sub, line, count=1)
    return (keep_comment_column(new_line, line), n) if n else (line, n)


def keep_comment_column(new, old):
    """Restores the comment column after an operand changed width.

    Only lines whose comment already sits at COL are re-padded; hand-worded
    comments elsewhere keep whatever spacing their author chose."""
    oc = old.find(";")
    nc = new.find(";")
    if oc < COL or nc < 0:
        return new
    code = new[:nc].rstrip()
    return f"{code} {new[nc + 1:].strip()}" if len(code) >= oc \
        else code.ljust(oc) + ";" + new[nc + 1:]


def rewrite_external_refs(mapping):
    """Apply destbank -> {old slot: new slot} to hand-written call sites."""
    touched = []
    for path in ref_files():
        with open(path, encoding="latin-1") as fh:
            text = fh.read()
        lines = text.splitlines(keepends=True)
        hits = 0
        for lineno, bank, _slot in file_slot_refs(read_lines(path)):
            if bank not in mapping:
                continue
            i = lineno                         # both iterate the same order
            comment = bool(SLOT_COMMENT_RE.match(lines[i]))
            new, n = _swap_token(lines[i], bank, mapping, comment=comment)
            if n:
                lines[i] = new
                hits += n
        if hits:
            with open(path, "w", encoding="latin-1") as fh:
                fh.write("".join(lines))
            touched.append((os.path.relpath(path, ROOT), hits))
    return touched


def sync_ceilings(vectors, dry=False):
    """Point every bank's '.ifge $, >xxxx' guard at its lowest AORG island."""
    equs = read_layout()
    changed = []
    for bank in VECTOR_BANKS:
        path = os.path.join(ROOT, "src", f"stevie_b{bank}.asm")
        if not os.path.exists(path):
            continue
        want = (equs["bankx.exttab"] if uses_ext_slots(vectors[bank])
                else equs["bankx.vectab"])
        with open(path, encoding="latin-1") as fh:
            text = fh.read()
        lines = text.splitlines(keepends=True)
        for i, line in enumerate(lines):
            m = MAIN_FILE_CEILING.search(line)
            if not m:
                continue
            if int(m.group("addr"), 16) != want:
                lines[i] = MAIN_FILE_CEILING.sub(
                    lambda m: m.group("pre") + f"{want:04x}", line, count=1)
                changed.append((bank, int(m.group("addr"), 16), want))
                if not dry:
                    with open(path, "w", encoding="latin-1") as fh:
                        fh.write("".join(lines))
            break
    return changed


# ---------------------------------------------------------------------------
# compact: pack the tables (and optionally free unreferenced slots)
# ---------------------------------------------------------------------------

def slot_references(stubs):
    """All (destbank, slot) pairs that some call site uses."""
    refs = {(bank, slot) for _, _, bank, slot in external_refs()}
    for blocks in stubs.values():
        for blk in blocks:
            if blk.get("vec") is not None and blk.get("dest"):
                refs.add((blk["dest"], blk["vec"]))
    return refs


def cmd_compact(args):
    """Renumber slots densely per bank and, with --reap, free dead ones.

    Slot numbers are pure addressing: a call site only needs the address of
    the target slot, so packing the tables moves no code. Every reference has
    to move along - registry stub records, raw block bodies and the
    hand-written farjumps outside the registry."""
    vectors, stubs = load_registry(LEGACY_SLOT_MAX, normalize=False)
    errs = layout_errors(read_layout())
    if errs:
        sys.exit("error: ROM layout is inconsistent:\n  " + "\n  ".join(errs))
    # A pre-extension registry numbers slots up to 64, which the current
    # geometry cannot render; compact is exactly the tool to migrate it, so
    # the drift pre-check only applies to registries that already fit.
    legacy = any(s > SLOT_MAX for slots in vectors.values() for s in slots) \
        or any(blk.get("vec", 0) > SLOT_MAX
               for blocks in stubs.values() for blk in blocks)
    if legacy:
        print("migrating a pre-extension registry (slots above "
              f"{SLOT_MAX}); skipping the drift pre-check")
    elif not args.force and drift_files(vectors, stubs):
        sys.exit("error: src/modules drifted from the registry; run 'generate' "
                 "or 'extract' first (or use --force)")

    refs = slot_references(stubs)
    reaped = []
    if args.reap:
        for bank in VECTOR_BANKS:
            for s in sorted(vectors[bank]):
                target, _ = vectors[bank][s]
                if target != "TRAP" and (bank, s) not in refs:
                    print(f"  reap bank{bank} vec.{s}: {target}")
                    vectors[bank][s] = ("TRAP", "")
                    reaped.append(bank)

    mapping = {}
    for bank in VECTOR_BANKS:
        order = [s for s in sorted(vectors[bank])
                 if vectors[bank][s][0] != "TRAP"]
        if len(order) > SLOT_MAX:
            sys.exit(f"error: bank{bank} needs {len(order)} slots; the maximum "
                     f"is {SLOT_MAX} ({SLOTS_MAIN} + {SLOTS_EXT} extension)")
        mapping[bank] = {old: i + 1 for i, old in enumerate(order)}
        vectors[bank] = {new: vectors[bank][old] for old, new in
                         mapping[bank].items()}

    for blocks in stubs.values():
        for blk in blocks:
            if blk.get("vec") is None or not blk.get("dest"):
                continue          # shared helpers carry no slot
            new = mapping[blk["dest"]].get(blk["vec"])
            if new is None:
                sys.exit(f"error: stub '{blk.get('label', blk['file'])}' calls "
                         f"bank{blk['dest']} vec.{blk['vec']}, which is not a "
                         f"filled slot anymore")
            blk["vec"] = new

    # Rewrite the hand-written call sites first: generated stub files embed the
    # raw block bodies verbatim, so they must already carry the new slots.
    write_registry(vectors, stubs)
    touched = rewrite_external_refs(mapping)
    do_generate(vectors, stubs, SRC)
    ceilings = sync_ceilings(vectors)

    print(f"reaped {len(reaped)} unreferenced slot(s) in "
          f"{len(set(reaped))} bank(s); rewrote call sites in "
          f"{len(touched)} file(s)")
    for name, hits in touched:
        print(f"  {name}: {hits} reference(s)")
    for bank, old, new in ceilings:
        print(f"  stevie_b{bank}.asm: bank guard >{old:04x} -> >{new:04x}")
    print(f"{'bank':6}{'slots':>6}{'island':>8}   ceiling")
    equs = read_layout()
    for bank in VECTOR_BANKS:
        slots = normalize_slots(vectors[bank])
        used = sum(1 for t, _ in slots.values() if t != "TRAP")
        if not used:
            continue
        ext = uses_ext_slots(slots)
        top = max(s for s, (t, _) in slots.items() if t != "TRAP")
        print(f"bank{bank:<2}{used:6}{'yes' if ext else 'no':>8}   "
              f">{(equs['bankx.exttab'] if ext else equs['bankx.vectab']):04x}"
              f"   (highest slot {top})")


# ---------------------------------------------------------------------------
# check: drift guard for the build pipeline
# ---------------------------------------------------------------------------

def drift_files(vectors, stubs):
    """Regenerate into a temp dir and report files that differ from src."""
    drift = []
    with tempfile.TemporaryDirectory() as tmp:
        do_generate(vectors, stubs, tmp)
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
    return drift


def cmd_check(_args):
    vectors, stubs = load_registry()
    problems = list(ceiling_errors(vectors)) + external_ref_errors(vectors)
    for p in problems:
        print(f"LAYOUT: {p}")
    drift = drift_files(vectors, stubs)
    if drift:
        print(f"\nDRIFT in {len(drift)} file(s): {', '.join(drift)}")
        print("fix: python3 build/tools/gen_vectors.py generate   (then commit)")
    if drift or problems:
        sys.exit(1)
    print("gen_vectors check: src matches registry (vectors + stubs up to date)")


# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("extract", help="src -> registry").set_defaults(func=cmd_extract)
    c = sub.add_parser(
        "convert-lean",
        help="rewrite pass-through inline stubs as lean tail-jumps + helpers")
    c.add_argument("--bank", help="single stub bank (default: 2-7)")
    c.add_argument("--dry", action="store_true", help="report only")
    c.set_defaults(func=cmd_convert_lean)
    g = sub.add_parser("generate", help="registry -> src")
    g.add_argument("--out", help="output dir (default: src/modules)")
    g.set_defaults(func=cmd_generate)
    sub.add_parser("check", help="fail if src drifted").set_defaults(func=cmd_check)
    c = sub.add_parser(
        "compact",
        help="pack vector slots per bank (and optionally free unreferenced ones)")
    c.add_argument("--reap", action="store_true",
                   help="also TRAP slots that no call site references")
    c.add_argument("--force", action="store_true",
                   help="compact even when src/modules drifted from the registry")
    c.set_defaults(func=cmd_compact)
    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

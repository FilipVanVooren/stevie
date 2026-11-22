#!/usr/bin/env python3
"""
bank_report.py - Per-bank ROM headroom report for Stevie.

Parses xas99 listing files (build/list/stevie_bN.lst) and reports, per bank:
  * program segment base / end (the contiguous run of emitted code in the
    cartridge bank window; absolute AORG islands are detected separately)
  * bytes used and free bytes up to the vector table (bankx.vectab = >7F70)
  * top N largest modules by emitted ROM bytes in the program segment

Listing format facts (xas99 3.6.x):
  "     **** ****     > name"  opens a copy/macro frame
  "                   < name"  closes a frame; for macro expansions xas99
                               prints the *parent* file name, not the macro
  "60A0 71C2 04D1  12  ..."    generated line; column 2 is the address
Macro frames are uppercase names without dots (PUSHREGS, ...); their bytes are
attributed to the enclosing module.

Usage:
    python3 build/bank_report.py [--top N] [--bank B] [--json] [--list-dir D]
"""

import argparse
import json
import re
import sys
from pathlib import Path

VEC_BASE = 0x7F70          # bankx.vectab (equ.rom.build.asm)
VDPTAB_BASE = 0x7F50       # bankx.vdptab - fixed anchor below the vectors
BANK_LO, BANK_HI = 0x6000, 0x8000
TIGHT_WARN = 256           # free bytes below which a bank is flagged

OPEN_RE = re.compile(r"^\s+\*{4} \*{4} +> (\S+)")
CLOSE_RE = re.compile(r"^\s+< (\S+)")
CODE_RE = re.compile(r"^[0-9A-F]{4} ([0-9A-F]{4})((?: [0-9A-F]{2,4})+)")
BANKNAME_RE = re.compile(r'^\s*(?:[0-9]{4}\s+)?\*\s+Bank\s+\S+\s+"(.*?)"\s*$')



def is_macro(name):
    return "." not in name and name.upper() == name


def parse_emissions(path):
    """Yield (addr, nbytes, module) for every generated line in the listing."""
    stack = []          # open frame names, innermost last
    with path.open(errors="replace") as fh:
        for line in fh:
            m = OPEN_RE.match(line)
            if m:
                stack.append(m.group(1))
                continue
            m = CLOSE_RE.match(line)
            if m and stack:
                # xas99 prints the ENCLOSING file on every close, including
                # macro-expansion closes. Truncate the stack to just above the
                # named frame; if that frame is no longer open (macro close
                # whose parent was already closed), pop the innermost frame.
                name = m.group(1)
                if name in stack:
                    del stack[len(stack) - 1 - stack[::-1].index(name):]
                else:
                    stack.pop()
                continue
            m = CODE_RE.match(line)
            if m and stack:
                addr = int(m.group(1), 16)
                nbytes = sum(len(g) // 2 for g in m.group(2).split())
                module = next((n for n in reversed(stack) if not is_macro(n)),
                              stack[-1])
                yield addr, nbytes, module


def bank_title(path):
    with path.open(errors="replace") as fh:
        for i, line in enumerate(fh):
            if i >= 60:
                break
            m = BANKNAME_RE.match(line)
            if m:
                return m.group(1)
    return ""


def report_bank(lst_path):
    all_em = list(parse_emissions(lst_path))
    emissions = [(a, n, mod) for a, n, mod in all_em
                 if BANK_LO <= a < BANK_HI
                 and not (mod or "").startswith("rom.vectors.")]
    vectors = sum(n for a, n, mod in all_em
                  if (mod or "").startswith("rom.vectors."))
    if not emissions:
        return None

    # Relative program content can only live in [BANK_LO, VDPTAB_BASE): the
    # .ifge $, >7f50 guard plus fixed AORG anchors at >7F50/>7FF0 guarantee it.
    prog = [(a, n, mod) for a, n, mod in emissions if a < VDPTAB_BASE]
    islands_em = [(a, n, mod) for a, n, mod in emissions if a >= VDPTAB_BASE]
    if not prog:
        return None
    prog_start = min(a for a, _, _ in prog)
    prog_end = max(((a + n - 1) & 0xFFFE) + 2 for a, n, _ in prog)

    per_mod = {}
    for addr, n, mod in prog:
        per_mod[mod] = per_mod.get(mod, 0) + n
    island_names = {}
    for a, n, mod in islands_em:
        island_names.setdefault(mod, set()).add(a)

    used = sum(per_mod.values())
    free = VDPTAB_BASE - prog_end
    return {
        "bank": lst_path.stem.replace("stevie_b", ""),
        "title": bank_title(lst_path),
        "prog_start": prog_start,
        "prog_end": prog_end,
        "used": used,
        "free": free,
        "vectors_bytes": vectors,
        "islands": {k: sorted(v) for k, v in sorted(island_names.items())},
        "top_modules": sorted(per_mod.items(), key=lambda t: -t[1])[:20],
    }


def main():
    ap = argparse.ArgumentParser(description="Stevie bank headroom report")
    ap.add_argument("--list-dir",
                    default=str(Path(__file__).resolve().parent / "list"))
    ap.add_argument("--top", type=int, default=5, help="modules listed per bank")
    ap.add_argument("--bank", help="single bank, e.g. 3")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    list_dir = Path(args.list_dir)
    names = ([f"stevie_b{args.bank}.lst"] if args.bank
             else sorted(p.name for p in list_dir.glob("stevie_b*.lst")))
    results = [r for r in (report_bank(list_dir / n) for n in names) if r]

    if args.json:
        print(json.dumps(results, indent=1))
        return 0

    hdr = (f"{'bank':<5} {'name':<14} {'base':>6} {'prog end':>8} "
           f"{'used':>6} {'free':>6}  fill")
    print(hdr)
    print("-" * len(hdr))
    for r in results:
        span = VDPTAB_BASE - r["prog_start"]
        pct = 100.0 * (r["prog_end"] - r["prog_start"]) / span
        warn = "  <-- TIGHT" if r["free"] < TIGHT_WARN else ""
        print(f"{r['bank']:<5} {r['title'][:14]:<14} >{r['prog_start']:04X} "
              f">{r['prog_end']:04X} {r['used']:>6} {r['free']:>6}  "
              f"{pct:5.1f}%{warn}")
    if args.top:
        print()
        for r in results:
            tops = ", ".join(f"{n} {s}B" for n, s in r["top_modules"][:args.top])
            print(f"bank {r['bank']} largest: {tops}")
        islands = [(r["bank"], r["islands"]) for r in results if r["islands"]]
        if islands:
            print("\nAORG islands (excluded from program segment):")
            for bank, isl in islands:
                txt = ", ".join(
                    f"{m}@{'/'.join(f'>{a:04X}' for a in addrs[:3])}"
                    for m, addrs in list(isl.items())[:6])
                print(f"  bank {bank}: {txt}")
    return 0


if __name__ == "__main__":
    sys.exit(main())

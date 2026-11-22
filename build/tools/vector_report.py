#!/usr/bin/env python3
"""Vector-slot occupancy / reachability report for the trampoline layer.

Read-only companion to gen_vectors.py: answers "how many slots does each bank
really need, which ones are dead weight, and who calls the extension island?".
Run from anywhere:  python3 build/tools/vector_report.py [--json]

Two sources of truth, both shared with gen_vectors.py so this can never disagree
with `gen_vectors.py check`:
  1. build/vector-registry.txt  -> declared slots per bank + stub records
  2. gv.external_refs()         -> every hand-written call site: farjump triples
                                   (also the compact one-liner form), raw .blk
                                   bodies incl. their standalone `.vector:`
                                   lines, and '* bankN vec.M' header comments

Table geometry (see src/modules/equ.rom.build.asm): slots 1-32 live in every
bank's main table at bankx.vectab; slots 33-48 live in the optional extension
island at bankx.exttab, which only banks that need it carry.
"""
import argparse
import json
import os
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
os.chdir(ROOT)
sys.path.insert(0, HERE)
import gen_vectors as gv                                              # noqa: E402


def collect():
    vectors, stubs = gv.load_registry()
    refs = defaultdict(lambda: defaultdict(set))       # bank -> slot -> {who}
    for srcbank, blocks in stubs.items():
        for blk in blocks:
            if "vec" in blk and "dest" in blk:
                refs[blk["dest"]][blk["vec"]].add(
                    f"stub {blk.get('label', '?')}@bank{srcbank}")
    for path, lineno, bank, slot in gv.external_refs():
        refs[bank][slot].add(
            f"{os.path.relpath(path, ROOT)}:{lineno}")
    return vectors, refs


def rows(vectors, refs):
    out = []
    for bank in sorted(vectors):
        used = {s: t for s, (t, _) in vectors[bank].items() if t != "TRAP"}
        if not used and not refs.get(bank):
            continue
        dead = sorted(s for s in used if s not in refs.get(bank, {}))
        seen = defaultdict(list)
        for s in sorted(used):
            seen[used[s]].append(s)
        out.append({
            "bank": bank,
            "used": len(used),
            "main": sum(1 for s in used if s <= gv.SLOTS_MAIN),
            "island": sum(1 for s in used if s > gv.SLOTS_MAIN),
            "highest": max(used) if used else 0,
            "referenced": len(refs.get(bank, {})),
            "dead": dead,
            "dupes": {t: ss for t, ss in seen.items() if len(ss) > 1},
        })
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    vectors, refs = collect()
    table = rows(vectors, refs)

    if args.json:
        print(json.dumps(table, indent=1))
        return 0

    hdr = (f"{'bank':5} {'used':>4} {'main':>5} {'isle':>5} {'high':>5}"
           f" {'refd':>5} {'dead':>5} {'dupes':>6}")
    print(hdr)
    print("-" * len(hdr))
    for r in table:
        print(f"bank{r['bank']:<4}{r['used']:>4} {r['main']:>5} {r['island']:>5}"
              f" {r['highest']:>5} {r['referenced']:>5} {len(r['dead']):>5}"
              f" {len(r['dupes']):>6}")
    print("-" * len(hdr))
    dead_total = sum(len(r["dead"]) for r in table)
    island_total = sum(r["island"] for r in table)
    over_main = [r["bank"] for r in table if r["main"] > gv.SLOTS_MAIN]
    print(f"dead slots (declared, never called) = {dead_total}"
          f"{'   -> python3 build/tools/gen_vectors.py compact --reap'
             if dead_total else ''}")
    print(f"slots in the extension island       = {island_total}"
          f"{'   (banks: ' + ', '.join(over_main) + ')' if over_main else ''}")

    print("\nA) DEAD SLOTS (in a table, nobody reaches them through that slot)")
    if not dead_total:
        print("  none")
    for r in table:
        for s in r["dead"]:
            print(f"  bank{r['bank']} vec.{s:<3} {vectors[r['bank']][s][0]}")

    print("\nB) EXTENSION ISLAND (slots 33+ and who calls them)")
    if not island_total:
        print("  none - every bank fits the 32-slot main table")
    for r in table:
        for s in sorted(vectors[r["bank"]]):
            if s > gv.SLOTS_MAIN and vectors[r["bank"]][s][0] != "TRAP":
                callers = sorted(refs.get(r["bank"], {}).get(s, []))
                print(f"  bank{r['bank']} slot {s:<3} "
                      f"{vectors[r['bank']][s][0]:<26} <- {', '.join(callers)}")

    print("\nC) DUPLICATE TARGETS (same routine reachable via several slots)")
    found = False
    for r in table:
        for t, ss in sorted(r["dupes"].items()):
            found = True
            print(f"  bank{r['bank']} {t}: slots {ss}")
    if not found:
        print("  none")

    print("\nD) BROKEN REFERENCES (call site aims at an empty slot)")
    bad = 0
    for bank in sorted(refs):
        for s in sorted(refs[bank]):
            tgt = vectors.get(bank, {}).get(s)
            if tgt is None or tgt[0] == "TRAP":
                print(f"  bank{bank} vec.{s:<3} <- "
                      f"{', '.join(sorted(refs[bank][s]))}")
                bad += 1
    if not bad:
        print("  none")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

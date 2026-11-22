#!/usr/bin/env python3
"""Vector-slot occupancy / reachability report for the trampoline layer.

Read-only companion to gen_vectors.py: answers "how many vector slots does each
bank really need, which ones are dead weight, and which ones block a smaller
table?".  Run from anywhere:  python3 build/tools/vector_report.py

Cross-checks three sources of truth:
  1. build/vector-registry.txt   -> declared slots per bank
  2. registry stub records       -> (dest bank, vec.N) actually called
  3. raw .blk bodies + every other src module -> hand-written farjump call
     sites (`data bankX.rom` .. `data vec.N`, incl. the compact one-liner form)

Reports per bank: slots in use, highest slot number, used-but-unreferenced
(dead) slots and duplicate targets, plus what a 32-slot table would require.
"""
import os
import re
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
BUILD = os.path.dirname(HERE)
ROOT = os.path.dirname(BUILD)
os.chdir(ROOT)
sys.path.insert(0, HERE)
import gen_vectors as gv                                              # noqa: E402

vectors, stubs = gv.load_registry()

# ---------------------------------------------------------------------------
# References
# ---------------------------------------------------------------------------
refs = defaultdict(set)                 # bank -> {slot}
refby = defaultdict(lambda: defaultdict(list))   # bank -> slot -> [who]

def add(bank, slot, who):
    refs[bank].add(slot)
    refby[bank][slot].append(who)

for srcbank, blocks in stubs.items():
    for blk in blocks:
        if "vec" in blk and "dest" in blk:
            add(blk["dest"], blk["vec"], f"stub {blk.get('label','?')}@bank{srcbank}")

BANK_RE = re.compile(r"\bbank(\w)\.rom\b")
VEC_RE = re.compile(r"\bvec\.(\d+)\b")


def scan(text, who):
    """Pair every `data bankX.rom` with the vec.N of the same call site."""
    lines = text.splitlines()
    for i, line in enumerate(lines):
        m = BANK_RE.search(line)
        if not m:
            continue
        v = VEC_RE.search(line)                     # compact one-liner form
        if v:
            add(m.group(1), int(v.group(1)), who)
            continue
        for j in range(i + 1, min(i + 4, len(lines))):
            v = VEC_RE.search(lines[j])
            if v:
                add(m.group(1), int(v.group(1)), who)
                break
            if BANK_RE.search(lines[j]):
                break


# raw block bodies (may contain their own bank/vec pairing)
for name in sorted(os.listdir("build/stub-raw")):
    scan(open(f"build/stub-raw/{name}", encoding="latin-1").read(), f"raw {name}")

# every other module: hand-written farjump call sites
for path in sorted(os.listdir("src/modules")):
    if not path.endswith(".asm") or path.startswith("rom.vectors."):
        continue                   # vector tables declare slots, they don't call
    if path.startswith("rom.stubs.bank") and path != "rom.stubs.bankx.asm":
        continue                   # registry-owned, already counted
    scan(open(f"src/modules/{path}", encoding="latin-1").read(), f"call {path}")
for path in sorted(os.listdir("src")):
    if path.endswith(".asm"):
        scan(open(f"src/{path}", encoding="latin-1").read(), f"call src/{path}")

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
MAXSLOT = 64
print(f"{'bank':4} {'used':>5} {'max':>4} {'refd':>5} {'dead':>5} {'dupes':>6}"
      f" {'>32':>4}   dead slots / >32 slots")
print("-" * 100)
tot_dead = tot_over = 0
for bank in sorted(vectors):
    used = {s: t for s, (t, _) in vectors[bank].items() if t != "TRAP"}
    if not used and not refs.get(bank):
        continue
    maxslot = max(used) if used else 0
    dead = sorted(s for s in used if s not in refs.get(bank, set()))
    dupes = defaultdict(list)
    for s, t in used.items():
        dupes[t].append(s)
    dup = {t: ss for t, ss in dupes.items() if len(ss) > 1}
    over = sorted(s for s in used if s > 32)
    tot_dead += len(dead)
    tot_over += len(over)
    print(f"{bank:4} {len(used):5} {maxslot:4} {len(refs.get(bank, [])):5}"
          f" {len(dead):5} {len(dup):6} {len(over):4}")
print("-" * 100)
print(f"dead (declared but never called) = {tot_dead}")
print(f"slots above 32                    = {tot_over}")

print("\nA) DEAD SLOTS (in the table, nobody calls them through that slot)")
for bank in sorted(vectors):
    for s in sorted(vectors[bank]):
        t = vectors[bank][s][0]
        if t != "TRAP" and s not in refs.get(bank, set()):
            print(f"  bank{bank} vec.{s:<2} {t}")

print("\nB) SLOTS ABOVE 32 (block a 32-slot table)")
for bank in sorted(vectors):
    for s in sorted(vectors[bank]):
        t = vectors[bank][s][0]
        if t != "TRAP" and s > 32:
            callers = sorted(set(refby.get(bank, {}).get(s, [])))
            print(f"  bank{bank} vec.{s:<2} {t:<28} <- {', '.join(callers)}")

print("\nC) DUPLICATE TARGETS (same routine in several slots)")
found = False
for bank in sorted(vectors):
    seen = defaultdict(list)
    for s in sorted(vectors[bank]):
        t = vectors[bank][s][0]
        if t != "TRAP":
            seen[t].append(s)
    for t, ss in seen.items():
        if len(ss) > 1:
            found = True
            print(f"  bank{bank} {t}: slots {ss}")
if not found:
    print("  none")

print("\nreferenced slots that are TRAPped or missing in the target bank:")
bad = 0
for bank, slots in sorted(refs.items()):
    for s in sorted(slots):
        tgt = vectors.get(bank, {}).get(s)
        if tgt is None or tgt[0] == "TRAP":
            print(f"  bank{bank} vec.{s:<2} <- {', '.join(refby[bank][s])}")
            bad += 1
print("  none" if not bad else f"  ({bad} broken references)")

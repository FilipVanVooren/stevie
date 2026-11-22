# Stevie build tree

The entry points live in this directory; everything they call lives in a
subdirectory. All scripts resolve their own location, so they can be run from
any working directory:

```sh
build/build.sh                # assemble 16 banks + concatenate cartridge image
build/build.sh 2480 3080      # one or more VDP modes (2480/3080/4880/6080)
build/buildone.sh 5           # re-assemble a single bank, relink the image
build/buildrpk.sh 3080        # cartridge image + RPK package
```

| Path | Kind | Contents |
| --- | --- | --- |
| `lib/` | helper | Shell helpers sourced by the entry points: `helper.sh` (logging), `assemble.sh` (xas99 / easyxdt99 container wrapper), `concat.sh` (banks -> cartridge image) |
| `tools/` | helper | Python tools: `gen_vectors.py` (cross-bank vector/stub generator and build guard), `vector_report.py` (slot occupancy, dead slots, dangling calls), `bank_report.py` (per-bank headroom report from the listings) |
| `tests/` | helper | Old-Js99er regression suites (`test_*.cjs`) plus `build_autorepeat.py`, the xdt99 builder that produces the images and symbol files those suites load |
| `validate/` | helper | `validate_r6.py` ... `validate_r10.py`: revision drivers that run the suites for every VDP mode in parallel |
| `bin/` | output | Per-bank `.bin` files, cartridge images, RPK payload files |
| `list/` | output | xas99 listings; input for `tools/bank_report.py` |
| `.buildinfo/` | output | Generated build-date assembly files (on the assembler include path) |
| `autorepeat/` | output | Gitignored: emulator test images, listings, symbol files, validation logs |
| `vector-registry.txt`, `stub-raw/` | input | Source of truth for the generated trampoline layer; see `../docs/devs/function-bank-overview.md` |

## Requirements

* docker with an `easyxdt99` image, or `xas99.py` on `$PATH`. The container
  image can be overridden with `IMAGE=easyxdt99:3.6.5-cpython3.14-slim build/build.sh`.
* A sibling Spectra2 checkout at `../spectra2` (its `src/` is on the include path).
* `python3` for the registry guard that `build.sh` runs before assembling.

## Vector layer

`tools/gen_vectors.py` owns the cross-bank trampoline layer and runs as a build
guard (`build.sh` calls `check` before assembling). Slots 1-32 live in every
bank's table at `bankx.vectab`; slots 33-48 live in an optional island at
`bankx.exttab`, which only banks 3 and 4 carry. All addresses are equated in
`../src/modules/equ.rom.build.asm`.

```sh
python3 build/tools/gen_vectors.py check        # src matches the registry?
python3 build/tools/gen_vectors.py generate     # re-render tables + stubs
python3 build/tools/gen_vectors.py compact --reap   # drop dead slots, close gaps,
                                                # rewrite call sites, move ceilings
python3 build/tools/vector_report.py            # who uses which slot
python3 build/tools/bank_report.py              # free bytes per bank
```

`compact` rewrites registry, generated files, `stub-raw/*.blk` and hand-written
farjump triples in one pass; it aborts rather than guess when a reference cannot
be attributed to a bank. Details: `../docs/devs/function-bank-overview.md`.

## Regression suites

The suites need the emulator sources in `../test-emulator/src` and images built
by `tests/build_autorepeat.py`:

```sh
python3 build/tests/build_autorepeat.py
node build/tests/test_autorepeat.cjs 3080
python3 build/validate/validate_r10.py BASE IMPORT
```

See `../AUTOREPEAT.md` for the full per-revision test history.

# Stevie subroutines by bank

This overview is intentionally at the assembly-subroutine level, not the file level. A single file may contain many labels, and the same logical routine can be reached from several banks via the ROM stub / far-jump mechanism.

## Generated trampoline layer (do not hand-edit)

The cross-bank call layer is generated from a single registry:

- `build/vector-registry.txt` — source of truth for every vector slot
  (`rom.vectors.bank[1-f].asm`) and every cross-bank stub block
  (`rom.stubs.bank[1-7].asm`), including block order (which fixes ROM addresses).
- `build/stub-raw/*.blk` — verbatim bodies of irregular stub blocks referenced by the registry.

Workflow: edit the registry (or re-run `extract` after moving code), then run
`python3 build/tools/gen_vectors.py generate`. `build/build.sh` runs
`gen_vectors.py check` before assembling and aborts when `src/modules` drifted
from the registry. Exceptions that stay hand-written: `rom.vectors.bank0.asm`
(equ-based boot vectors) and `rom.stubs.bankx.asm` (conditional SAMS stubs).

### Table geometry: 32 main slots + an optional 16-slot island

Every bank exposes its vector table at a fixed address, so a call site only
needs *(bank, slot)*. The addresses are equated once, in
`src/modules/equ.rom.build.asm`; `gen_vectors.py` reads them back and refuses to
generate if they overlap or collide with the ROM-id signature:

| island | address | size | contents |
|---|---|---|---|
| `bankx.exttab`  | >7F68 | 32 B | extension slots **33-48**, only in banks that need them |
| `bankx.vectab`  | >7F88 | 64 B | main slots **1-32**, in every bank |
| `bankx.vdptab`  | >7FC8 | 32 B | per-bank VDP mode table |
| (ROM id)        | >7FEA |  8 B | `'ROM#N'` signature |
| `bankx.crash.showbank` | >7FF0 | 16 B | crash banner |

Slots 1-32 are addressed as `vec.N`; slots 33-48 as `bankx.exttab+<2*(N-33)>`
(`gen_vectors.py` emits and rewrites both spellings). A bank without an island
may therefore use code space up to >7F88; a bank with one must stop at >7F68.
Each bank asserts its own ceiling:

```asm
        .ifge   $, >7f88          ; >7f68 in banks 3 and 4 (they carry the island)
        .error  'Aborted. Bank N cartridge program too large!'
        .endif
```

`gen_vectors.py` owns that guard: `compact` rewrites it together with the table,
so the ceiling can never disagree with how many slots a bank actually declares.
Before 2026-11-22 the single table held 64 slots at >7F70 and every bank stopped
at >7F50; splitting it reclaimed 17 unreferenced slots and gave every non-island
bank 56 more bytes of code space (banks 3/4: 24 B).

`python3 build/tools/gen_vectors.py compact [--reap] [--force]` renumbers slots
so each bank's used slots are 1..N with no gaps (`--reap` first drops slots that
nothing calls), rewrites *every* reference — registry, generated files, raw
`.blk` bodies and hand-written farjump triples — and moves the `.ifge` ceilings.
It refuses to reap when a call site cannot be attributed to a bank. Read-only
census: `python3 build/tools/vector_report.py` (dead slots, island users,
duplicate targets, dangling references).

Legend:
- Stevie function: editor logic, file management, dialogs, buffer operations, screen logic, etc.
- Spectra2 low-level function: ROM bridge, SAMS/VDP helpers, bank switching, crash/return plumbing, TI-Basic session glue.

### Stub forms and `convert-lean`

Pass-through cross-bank calls exist in two registry-recorded forms:

- `inline variant=plain` (fat, 18 B/stub): every stub embeds its own
  `bl @rom.farjump` with the target vector as immediate operands.
- `lean` (10 B/stub + one shared 18 B helper per *target* bank): the stub is
  just `mov @label.vector,@trmpvector` + `jmp _trampoline.bankN.ret`. The
  shared `_trampoline.bankN.ret` helper calls `rom.farjump` with `p1 =>ffff`,
  which makes farjump dereference `@trmpvector` *after* the bank switch
  (`trmpvector` lives in scratch pad, so it survives the switch). This is the
  form bank 1 and bank 6 originally used.

`python3 build/tools/gen_vectors.py convert-lean [--bank N] [--dry]` rewrites every
convertible stub (only `inline variant=plain`; exitlabel/regs/raw variants
keep their post-return processing) to the lean form, inserts the needed
`helper bankN` records and picks `form=jmp|bindirect` per stub based on the
measured distance to the helper (`b @helper` when the ±256 B branch range is
not enough). A *new* helper costs 18 B, so it is only emitted when at least
`MIN_STUBS_FOR_NEW_HELPER` (3) pass-throughs share that target bank and no
helper for it exists yet; otherwise the stub stays inline (cheaper). After
conversion run `generate`, a full build, and verify: zero diagnostics,
`check` passes, vector tables byte-identical, binary diff confined to
converted banks.

Converted 2026-11-22 (78 stubs total): bank 2 −162 B used (352→464 free),
bank 3 −138 B (2626→2700 free), bank 4 −46 B, bank 5 −72 B (5196→5238 free),
bank 7 −16 B. Bank 6 and bank 1 were already lean or cost-guarded.

### Raw blocks (`build/stub-raw/`)

`extract` matches block bodies against the templates comment-insensitively,
so a pass-through stub whose comments were merely hand-worded differently is
still recorded as `inline`/`helper`, never as raw — re-rendering such a block
changes no ROM bytes. What remains in `stub-raw/` (7 blocks since 2026-11-22,
all in bank 1) are stubs with genuine *behavior*: pre-call guards or side
effects (`dialog.unsaved`, `_trampoline.bank3` cursor hide/show), post-return
logic (`fm.loadfile` unsaved-changes dialog), session setup (`tibasic1/2/3`,
`tibasic.uncrunch`) and `dialog.main` block-mode handling. Anything else that
lands in `stub-raw/` after an `extract` is a classification miss worth
checking.

## Bank headroom report

`python3 build/tools/bank_report.py` parses the xas99 listings in `build/list/` and
reports per bank: program segment end, bytes used, free bytes up to that bank's
ceiling (the extension island at >7F68 when it carries one, otherwise the main
vector table at >7F88 - i.e. exactly where its `.ifge` guard trips), whether the
bank has an island, and the largest contributing modules. Fixed AORG islands
(extension + main vector tables, the per-bank VDP mode tables at >7FC8, the
crash banner at >7FF0) are detected and excluded from the program segment. The
ceiling addresses are read from `equ.rom.build.asm` through `gen_vectors.py`, so
the report cannot silently disagree with the generator. Options: `--bank N`, `--top N`, `--json`. Run after a
build; use it before deciding where new code or data should go (banks 8-D are
the overflow pool).

## Data residency rules

A shared read-mostly table must have exactly one *runtime* home; extra ROM
copies are only allowed when they resolve labels for the copier/relocator code
that installs the runtime copy:

- `data.dialogs.asm` — canonical ROM copy in bank E (`dialogs`..`enddial`),
  copied to SAMS RAM pages #2/#3 at boot by `rom.dialogs2ram`. Bank 3 re-includes
  it under `aorg >b000` purely so dialog code assembles against the runtime
  addresses. Do not add a third copy; new banks reach dialogs through the SAMS window.
- `data.colorscheme.asm` — lives only in bank 4 (owner of
  `pane.colorscheme.index`, the sole reader of `tv.colorscheme.table`). Other
  banks cycle/read schemes through the vector stub. A stale second copy in
  bank 1 was removed on 2026-11-22 (bank 1 is the tightest bank).
- `data.vdpmodes.asm` — intentional per-bank copy: each bank must expose its
  video-mode table at the fixed address `bankx.vdptab` (>7FC8), so it is an
  AORG island, not program churn.

## Rebalancing tight banks (playbook)

Measured 2026-11-22, after the vector-table split and slot compaction: banks
0/1/7 run at 97–98% fill (142–228 bytes free; the split added 56 B to each of
them). An audit found **no dead weight** there — the pressure is structural:

- Bank 0 hosts the RAM-resident runtime library copy plus bootstrap.
- Bank 1 is the editor core; keymap tables are referenced by immediate loads
  (`li tmp,keymap_actions.editor`) from `edk.key.process` in the same bank, so
  tables and dispatcher must stay co-resident.
- Bank 7 hosts the TI-Basic bridge as one cohesive cluster
  (`tib.session.*`, `tib.uncrunch.*`, `data.tib.tokens` via `tib.tokenindex`,
  `data.scrpad`/`data.sams.layout` via `mem.run.ea5`).

When a tight bank needs headroom, move a *cohesive cluster* to the overflow
pool (banks 8-D, ~7.7 KB free each) instead of scattering single modules:

1. Move the `copy "…"` lines of the whole cluster from e.g. `stevie_b7.asm` to
   `stevie_b8.asm` (keep relative order inside the cluster).
2. Update `owner=` for every exported vector of the cluster in
   `build/vector-registry.txt`; slots freed in the old bank may be re-used by
   functions moving in the opposite direction.
3. `python3 build/tools/gen_vectors.py generate`, then full `build/build.sh`.
4. Verify: zero assembler diagnostics, `gen_vectors check` passes, and binary
   diff shows changes only in the affected banks (plus shifted addresses).

Candidate clusters if needed: the TI-Basic bridge bank 7 → bank 8 (largest
single relief, ~2–3 KB); a set of `edk.*` keyboard handlers bank 1 → bank 9
(smaller win, each handler needs its own vector slot for the dispatcher).

## Shared / cross-bank symbols

These are the bank-agnostic routines that get reused from multiple banks and are the key low-level bridges between Stevie and the underlying Spectra2 runtime.

- `rom.farjump` — Spectra2 low-level: bank-switch trampoline used by stubs in every nonzero bank.
- `mem.sams.setup.stevie` — Stevie / low-level bridge: the standard SAMS setup entry that is stubbed into many banks.
- `mem.sams.set.legacy`, `mem.sams.set.boot`, `mem.sams.set.stevie` — Spectra2 low-level: SAMS mode selection helpers.
- `cpu.crash.showbank`, `cpu.crash.showbank.bankstr` — Spectra2 low-level: bank-id crash display.
- `stevie.80x30` — Spectra2 low-level / config: VDP mode table selector.
- `tib.run`, `tib.run.return`, `tib.uncrunch`, `tib.uncrunch.prg` — Stevie + TI-Basic bridge: to/from TI-Basic session helpers.

## Bank 0 — bootstrap and startup

This is the cartridge entry point, with just a handful of real labels.

- `rom.program1` — Spectra2 low-level: startup/ROM program entry.
- `mem.sams.setup.stevie` — Stevie bridge: SAMS setup entry used via stubs.
- `mem.sams.set.legacy`, `mem.sams.set.boot`, `mem.sams.set.stevie` — Spectra2 low-level: memory mode setup.
- `stevie.80x30`, `tibasic.32x24`, `edasm.32x24` — Spectra2 low-level / config: VDP and session config selectors.
- `cpu.crash.showbank.bankstr` — Spectra2 low-level: crash screen bank string.

## Bank 1 — editor core, keyboard engine, and command actions

This is the largest Stevie bank; most of the actual editor behavior is here.

### Main entry / setup

- `main.stevie`, `main.continue` — Stevie function: main editor loop/boot path.
- `mem.sams.setup.stevie`, `mem.sams.setup.stevie.exit` — Stevie bridge: SAMS startup helpers.

### Keyboard processing

- `edkey.keyscan.hook`, `edkey.keyscan.hook.clear`, `edkey.keyscan.hook.exit` — Spectra2 low-level: keyboard hook layer.
- `edkey.key.process`, `edkey.key.process.special`, `edkey.key.process.loadmap.editor`, `edkey.key.process.loadmap.cmdb` — Stevie function: keyboard dispatch.
- `edkey.key.check.next`, `edkey.key.check.scope`, `edkey.key.process.action`, `edkey.key.process.addbuffer`, `edkey.key.process.crash`, `edkey.key.process.enter`, `edkey.key.process.flash`, `edkey.key.process.exit` — Stevie function: action routing and command capture.

### Framebuffer editing actions

- `edk.act.left`, `edk.act.right`, `edk.act.home`, `edk.act.end` — Stevie function: cursor motion.
- `edk.act.pword`, `edk.act.nword`, `edk.act.scroll.left`, `edk.act.scroll.right`, `edk.act.ppage`, `edk.act.npage`, `edk.act.top`, `edk.act.bot`, `edk.act.up`, `edk.act.down` — Stevie function: word / page / screen movement.
- `edkey.fb.goto.toprow`, `edkey.fb.goto.offset`, `edkey.fb.goto.row`, `edkey.fb.goto.line`, `edk.act.goto`, `edk.act.goto.refresh` — Stevie function: line / cursor goto.
- `edk.act.del_char`, `edk.act.del_eol`, `edk.act.del_line` — Stevie function: delete character / line actions.
- `edk.act.ins_char.ws`, `edk.act.ins_line`, `edk.act.ins_line_after`, `edk.act.enter`, `edk.act.newline`, `edk.act.ins_onoff` — Stevie function: insert and newline logic.
- `edk.act.toggle.ruler`, `edk.act.toggle.ruler.on`, `edk.act.toggle.ruler.off` — Stevie function: ruler display toggle.
- `edk.act.quit` — Stevie function: exit editor.
- `edk.act.copyblock_or_clipboard`, `edk.act.fb.load.file` — Stevie function: clipboard / file-open action.
- `edk.act.block.mark`, `edk.act.block.reset`, `edk.act.block.copy`, `edk.act.block.delete`, `edk.act.block.move`, `edk.act.block.goto.m1` — Stevie function: block manipulation.
- `edk.act.fb.tab.prev`, `edk.act.fb.tab.next` — Stevie function: tab movement.
- `edk.act.goto.pmatch`, `edk.act.goto.nmatch`, `edk.act.find.reset` — Stevie function: find / match navigation.
- `edk.fb.char`, `edk.fb.char.overwrite`, `edk.fb.char.drawcursor`, `edk.fb.char.exit` — Stevie function: character insert/overwrite drawing.

### Command buffer and command-mode actions

- `edk.act.cmdb.left`, `edk.act.cmdb.right`, `edk.act.cmdb.home`, `edk.act.cmdb.end`, `edk.act.cmdb.clear` — Stevie function: command-buffer motion.
- `edk.act.cmdb.del_char`, `edk.act.cmdb.char`, `edk.act.cmdb.show`, `edk.act.cmdb.hide` — Stevie function: command editing and visibility toggles.
- `edk.act.cmdb.cfg.clip`, `edk.act.cmdb.file.new`, `edk.act.cmdb.load`, `edk.act.cmdb.insert`, `edk.act.cmdb.append`, `edk.act.cmdb.clip`, `edk.act.cmdb.save`, `edk.act.cmdb.print`, `edk.act.cmdb.file.delete`, `edk.act.cmdb.file.directory`, `edk.act.cmdb.file.run`, `edk.act.cmdb.pick.prev`, `edk.act.cmdb.pick.next`, `edk.act.cmdb.updir` — Stevie function: command-buffer file operations.
- `edk.act.cmdb.autoinsert`, `edk.act.cmdb.linelen`, `edk.act.cmdb.close.dialog` — Stevie function: toggles and dialog close logic.

## Bank 2 — file I/O and file-manager routines

This bank is all about reading and writing files, EA5 loads, directory browsing, and file-manager callbacks.

- `fh.file.read.mem`, `fh.file.read.edb`, `fh.file.write.edb` — Stevie function: file reading/writing into memory or editor buffer.
- `fh.file.load.bin`, `fh.file.load.ea5`, `fh.file.delete` — Stevie function: binary/EA5 load and file delete paths.
- `fm.loadfile`, `fm.insertfile`, `fm.savefile`, `fm.newfile`, `fm.delfile`, `fm.run.ea5` — Stevie function: file-management actions.
- `fm.clock.read` — Stevie function: clock-related file-manager note/indicator.
- `fm.browse.fname.set`, `fm.browse.fname.prev`, `fm.browse.fname.next`, `fm.browse.updir`, `fm.directory` — Stevie function: file-browser navigation.
- `fm.loadsave.cb.indicator1`, `fm.dir.callback1`, `fm.load.ea5.cb.indicator1`, `fm.clock.read.cb.stopflag`, `fm.delfile.callback1` — Stevie function: callback handlers.
- `edb.line.unpack` — Spectra2 low-level / bridge: editor-buffer line unpack helper.

## Bank 3 — dialogs and command UI

This bank contains the dialog runtime and the command/pane helpers that draw and handle overlays.

- `dialog`, `dialog.main`, `dialog.file`, `dialog.cart.type`, `dialog.cart.fg99`, `dialog.help` — Stevie function: dialog framework and specific dialogs.
- `dialog.open`, `dialog.save`, `dialog.append`, `dialog.insert`, `dialog.delete`, `dialog.print`, `dialog.run`, `dialog.cat`, `dialog.opt`, `dialog.opt.clip`, `dialog.font`, `dialog.clipboard`, `dialog.unsaved`, `dialog.basic`, `dialog.shortcuts`, `dialog.goto`, `dialog.find` — Stevie function: concrete dialog handlers.
- `pane.show_hintx`, `pane.cmdb.draw`, `pane.cmdb.statlines` — Stevie function: pane and status display helpers.
- `cmdb.refresh_prompt`, `cmdb.cmd.clear`, `cmdb.cmd.set`, `cmdb.cmd.preset`, `cmdb.cfg.fname` — Stevie function: command-buffer management.
- `fm.lineterm`, `tv.clock.toggle`, `tv.autoinsert.toggle`, `tv.linelen.toggle` — Stevie function: editor toggles.
- `tibasic.am.toggle` — Stevie / TI-Basic bridge: toggle AM mode.
- `tv.clock.start` — Spectra2 low-level / bridge: clock-start helper.

## Bank 4 — framebuffer, pane rendering, and cursor drawing

This bank is mostly the text engine and pane redraw logic.

- `fb.cursor.top`, `fb.cursor.topscr`, `fb.cursor.bot`, `fb.cursor.botscr`, `fb.cursor.up.cursor`, `fb.cursor.down`, `fb.cursor.home` — Stevie function: cursor positioning.
- `fb.insert.line`, `fb.insert.char`, `fb.replace.char`, `fb.null2char` — Stevie function: framebuffer mutation.
- `fb.tab.prev`, `fb.tab.next`, `fb.goto.toprow`, `fb.goto.nextmatch`, `fb.goto.prevmatch` — Stevie function: tab and search-result navigation.
- `fb.ruler.init` — Stevie function: ruler initialization.
- `fb.colorlines`, `fb.vdpdump`, `fb.scan.fname`, `fb.hscroll` — Stevie function: rendering and scanning helpers.
- `fb.restore`, `fb.refresh`, `fb.get.nonblank` — Stevie function: redraw and refresh helpers.
- `pane.cmdb.hide`, `pane.cmdb.show`, `pane.topline`, `pane.botline`, `pane.botline.busy.on`, `pane.errline.drawcolor` — Stevie function: pane rendering and error line display.
- `error.display` — Stevie function: error pane output.
- `pane.colorscheme.cycle`, `pane.colorscheme.index`, `pane.colorscheme.load`, `pane.colorscheme.botline`, `pane.filebrowser`, `pane.filebrowser.hilight`, `pane.filebrowser.colbar` — Stevie function: colorscheme and file-browser pane logic.
- `edb.line.pack.fb` — Spectra2 low-level bridge: pack editor line into framebuffer state.

## Bank 5 — editor buffer operations, blocks, search, and pane display state

- `edb.clear.sams` — Stevie function: clear SAMS-backed editor buffer state.
- `edb.line.del`, `edb.line.copy` — Stevie function: line operations.
- `edb.block.mark.m1`, `edb.block.clip`, `edb.block.reset`, `edb.block.delete`, `edb.block.copy`, `edb.block.match` — Stevie function: block-manipulation routines.
- `edb.lock`, `edb.unlock` — Stevie function: buffer locking.
- `edb.find.init`, `edb.find.search`, `edb.find.scan.showbusy` — Stevie function: find / scan engine.
- `pane.clock.time` — Stevie function: clock display pane.
- `fm.clock.on`, `fm.clock.off` — Stevie function: clock toggle.
- `tv.flash.screen` — Stevie function: transient screen flash action.
- `tv.clock.start` — Spectra2 low-level bridge: clock start helper.

## Bank 6 — VDP, fonts, and display helpers

This bank is more display- and hardware-oriented than the main editor banks.

- `vdp.dump.patterns`, `vdp.dump.font`, `vdp.colors.line` — Stevie function: display/debug routines.
- `vdp.cursor.tat`, `vdp.cursor.tat.fb`, `vdp.cursor.tat.cmdb`, `vdp.cursor.tat.cmdb.hide` — Stevie function: cursor tracking / VDP state helpers.
- `tv.set.font` — Stevie function: set current font.
- `pane.colorscheme.index` — Stevie function: colorscheme index helper.
- `cursors` — Spectra2 low-level / data: VDP cursor pattern data.

## Bank 7 — TI-Basic bridge, memory layout, and SAMS plumbing

This is the most mixed bank: it contains the TI-Basic session logic, memory layout, and entry points that Stevie must call into when switching in and out of Basic.

- `rom.program1` — Spectra2 low-level: ROM header / boot vector.
- `_mem.sams.set.banks` — Spectra2 low-level: memory layout setup.
- `tv.reset` — Stevie function: reset screen/editor state.
- `tib.run`, `isr`, `tib.run.return` — Stevie + TI-Basic bridge: session execution and return path.
- `_v2sams`, `tib.uncrunch`, `tib.uncrunch.prepare`, `tib.uncrunch.prg`, `tib.uncrunch.token`, `tib.uncrunch.line.pack` — Stevie function: TI-Basic token unpacking and line conversion.
- `mem.run.ea5`, `cart.fg99.mgr` — Stevie function: run EA5 and FG99 cartridge tasks.
- `cmdb.dialog.close` — Stevie function: close command/dialog state.
- `mem.sams.layout.boot` — Spectra2 low-level / config: SAMS layout boot data.

## Banks 8-9 and A-F — mostly empty / reserved / expansion banks

These banks do not carry the bulk of Stevie editor logic. They are mostly placeholder banks, stub banks, or support tables.

Bank 8 now holds `edkey.key.repeat`, the frame-paced keyboard autorepeat
engine, at far-jump vector 1. The normal key dispatcher remains in bank 1.

- `data.bank8.asm`, `data.bank9.asm`, `data.banka.asm`, `data.bankb.asm`, `data.bankc.asm`, `data.bankd.asm`, `data.banke.asm` — Spectra2 low-level / data: reserved bank data.
- `rom.stubs.banka.asm`, `rom.stubs.bankb.asm`, `rom.stubs.bankc.asm`, `rom.stubs.bankd.asm`, `rom.stubs.banke.asm`, `rom.stubs.bankf.asm` — Spectra2 low-level: bank-specific stub vectors.
- `rom.vectors.bank8.asm`, `rom.vectors.bank9.asm`, `rom.vectors.banka.asm`, `rom.vectors.bankb.asm`, `rom.vectors.bankc.asm`, `rom.vectors.bankd.asm`, `rom.vectors.banke.asm`, `rom.vectors.bankf.asm` — Spectra2 low-level: far-jump vectors.
- `cpu.crash.showbank`, `cpu.crash.showbank.bankstr` — Spectra2 low-level: shared crash-bank display.

Bank F is a small exception because it holds help content and display content: 
- `dialog.help.content` — Stevie function: help panel text assembly.
- `dialog.help.maxpage` — Stevie function: help pagination data for the various screen modes.

## Practical summary

- The practical Stevie code is concentrated in Banks 1-5.
- Banks 6-7 contain the VDP/SAMS/TI-Basic bridge layer and a mix of low-level + editor tasks.
- Banks 8-F are mostly empty, stubbed, or data-only banks.
- The same routine can be reached from multiple banks because the cartridge uses a far-jump stub pattern, so bank membership is not a perfect one-to-one map to a single file or routine family.

In short: the real editor logic is mainly a set of Stevie subroutines such as `main.stevie`, `edk.act.*`, `edb.*`, `fb.*`, `dialog.*`, and `fm.*`, while the low-level plumbing is the Spectra2 layer (`rom.farjump`, `mem.sams.*`, `cpu.crash.*`, `vdp.*`, `tib.*`).

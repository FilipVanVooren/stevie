# Stevie subroutines by bank

This overview is intentionally at the assembly-subroutine level, not the file level. A single file may contain many labels, and the same logical routine can be reached from several banks via the ROM stub / far-jump mechanism.

Legend:
- Stevie function: editor logic, file management, dialogs, buffer operations, screen logic, etc.
- Spectra2 low-level function: ROM bridge, SAMS/VDP helpers, bank switching, crash/return plumbing, TI-Basic session glue.

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

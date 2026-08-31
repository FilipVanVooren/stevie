| Function | ROM banks | Register usage | Input parameters | Output parameters | Macros | Called functions | External calls |
| --- | --- | --- | --- | --- | --- | --- | --- |
| cart.fg99.mgr | 7 | — | @cmdb.cmdall | @outparm1 | .pushregs, .popregs | cart.fg99.run, cmdb.cmd.getlength, rom.farjump | cpym2m, xpym2m |
| cart.fg99.run | — | — | @tv.fg99.img.ptr | — | — | — | f18rst, scroff, vidtab, xfg99 |
| cmdb.cfg.fname | 3 | — | @parm1, @parm2 | @outparm1 | .pushregs, .popregs | cmdb.cmd.getlength, error.display, pane.cmdb.hide | hchar, rsslot, xpym2m |
| cmdb.cmd.clear | 1, 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.getlength | film |
| cmdb.cmd.cursor_eol | 3 | — | — | @outparm1 | .popregs | cmdb.cmd.getlength, rom.farjump | — |
| cmdb.cmd.delete | 3 | — | @cmdb.column | @outparm1 | .pushregs, .popregs | cmdb.cmd.cursor_eol, cmdb.cmd.getlength | — |
| cmdb.cmd.delete.shift | — | — | @cmdb.column | @outparm1 | — | — | — |
| cmdb.cmd.getlength | 3 | tmp0,tmp1,tmp2,tmp3 | @cmdb.cmd | — | — | cmdb.cmd.insert, rom.farjump | string.getlenc |
| cmdb.cmd.insert | 3 | tmp0,tmp1,tmp2,tmp3 | @cmdb.column, @parm1 | — | .pushregs, .popregs | cmdb.cmd.delete, cmdb.cmd.getlength | — |
| cmdb.cmd.insert.shift | — | — | @cmdb.column, @parm1 | — | — | — | — |
| cmdb.cmd.preset | 3 | — | @waux1, @cmdb.dialog | — | .pushregs, .popregs | cmdb.cmd.cursor_eol, cmdb.cmd.set | — |
| cmdb.cmd.set | 3 | — | @parm1 | — | .pushregs, .popregs | — | film, xpym2m |
| cmdb.dialog.close | 1 | — | — | — | — | pane.cmdb.hide, rom.farjump | — |
| cmdb.init | — | — | — | — | .pushregs, .popregs | — | film |
| cmdb.refresh_prompt | 3 | — | @cmdb.yxprompt, @cmdb.cmd | — | .pushregs, .popregs | rom.farjump | putstr, xpym2v, yx2pnt |
| dialog | 3 | — | — | — | .pushregs, .popregs | — | cpym2m |
| dialog.append | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, fb.scan.fname, pane.cursor.blink, pane.filebrowser | — |
| dialog.append.keylist | — | — | — | — | — | cmdb.cmd.set | — |
| dialog.append.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.basic | 3 | — | — | — | .pushregs, .popregs | fb.row2line, pane.cursor.hide, rom.farjump | cpym2m, mknum, trimnum |
| dialog.cart.fg99 | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.clear, dialog.unsaved, pane.cursor.blink | cpym2m |
| dialog.cart.fg99.setup | — | — | — | — | — | cmdb.cmd.clear, pane.cursor.blink | cpym2m |
| dialog.cart.type | 3 | — | — | — | .pushregs, .popregs | pane.cursor.hide | — |
| dialog.cat | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, pane.cursor.blink, pane.filebrowser | — |
| dialog.cat.keylist | — | — | — | — | — | — | — |
| dialog.clipboard | 3 | — | — | @outparm1 | .pushregs, .popregs | cmdb.cmd.clear, fb.row2line, pane.cursor.hide | cpym2m, film, mknum |
| dialog.clipboard.setup | — | — | — | @outparm1 | — | cmdb.cmd.clear, fb.row2line | cpym2m, film, mknum |
| dialog.clock | — | — | — | — | .pushregs, .popregs | pane.cursor.hide | — |
| dialog.clock.setup | — | — | — | — | — | pane.cursor.hide | — |
| dialog.delete | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, fb.scan.fname, fm.browse.fname.set, pane.cursor.blink, pane.filebrowser | film |
| dialog.delete.keylist | — | — | — | — | — | — | — |
| dialog.delete.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.file | 3 | — | — | — | .pushregs, .popregs | mem.sams.dialogs.off, mem.sams.dialogs.on, pane.cmdb.statlines, pane.cursor.hide | — |
| dialog.find | 3 | — | — | — | .pushregs, .popregs | pane.cursor.blink | cpym2m |
| dialog.font | 3 | — | — | — | .pushregs, .popregs | pane.cursor.hide | — |
| dialog.font.keylist | — | — | — | — | — | pane.cursor.hide | — |
| dialog.font.setup | — | — | — | — | — | — | — |
| dialog.goto | 3 | — | — | — | .pushregs, .popregs | pane.cursor.blink | film |
| dialog.help | 3 | — | — | — | — | dialog.help.content | — |
| dialog.help.content | f | — | @cmdb.dialog.var | — | .pushregs, .popregs | rom.farjump | at, filv, hchar, putat, putlst, putnum, xfilv |
| dialog.help.content.clear | — | — | @cmdb.dialog.var | — | — | — | at, filv, hchar, putat, putlst, putnum, xfilv |
| dialog.insert | 3 | — | — | @outparm1 | .pushregs, .popregs | cmdb.cmd.set, fb.row2line, fb.scan.fname, pane.cursor.blink, pane.filebrowser | cpym2m, film, mknum |
| dialog.insert.setup | — | — | — | @outparm1 | — | fb.row2line, fb.scan.fname | cpym2m, film, mknum |
| dialog.main | 3 | — | — | — | .pushregs, .popregs | mem.sams.dialogs.off, mem.sams.dialogs.on, pane.cmdb.statlines, pane.filebrowser.colbar.remove | edk.act.block.reset |
| dialog.open | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, dialog.unsaved, fb.scan.fname, fm.browse.fname.set, pane.cursor.blink, pane.filebrowser | film |
| dialog.open.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.opt | 3 | — | — | — | .pushregs, .popregs | pane.cursor.hide | — |
| dialog.opt.clip | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, pane.cursor.blink | — |
| dialog.print | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, pane.cursor.blink | edb.line.pack |
| dialog.print.default | — | — | — | — | — | — | — |
| dialog.run | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.set, dialog.unsaved, fb.scan.fname, fm.browse.fname.set, pane.cursor.blink, pane.cursor.hide, pane.filebrowser | film |
| dialog.run.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.save | 3 | — | — | — | .pushregs, .popregs | cmdb.cmd.clear, cmdb.cmd.set, pane.cursor.blink, pane.filebrowser | cpym2m, edb.line.pack |
| dialog.shortcuts | 3 | — | — | — | .pushregs, .popregs | pane.cursor.hide | — |
| dialog.unsaved | 3 | — | — | — | .pushregs, .popregs | pane.cursor.hide | hchar |
| edb.block.clip | 5 | — | @edb.clip.filename, @edb.block.m1, @edb.block.m2, @parm1 | — | .pushregs, .popregs | fm.savefile | cpym2m |
| edb.block.copy | 5 | — | @edb.block.m1, @edb.block.m2, @parm1 | @outparm1 | .pushregs, .popregs | edb.line.copy, fb.row2line, idx.entry.insert, pane.colorscheme.botline, pane.errline.show | cpym2m, hchar, putat |
| edb.block.delete | 5 | — | @edb.block.m1, @edb.block.m2, @parm1 | @outparm1 | .pushregs, .popregs | edb.block.reset, fb.refresh, idx.entry.delete, pane.colorscheme.botline | hchar, putat |
| edb.block.mark | 5 | — | @edb.block.m1, @edb.block.m2 | @outparm1 | — | edb.block.mark.m1, edb.block.mark.m2, fb.row2line | — |
| edb.block.mark.m1 | 5 | — | @edb.block.m1 | @outparm1 | — | edb.block.mark.m2, fb.row2line | — |
| edb.block.mark.m2 | 5 | tmp0,tmp1 | @edb.block.m2 | @outparm1 | — | edb.block.mark, fb.row2line | — |
| edb.block.match | 5 | — | @parm1 | @outparm1 | .pushregs, .popregs | fb.row2line, rom.farjump | — |
| edb.block.reset | 5 | — | — | — | — | pane.colorscheme.botline, pane.colorscheme.load | hchar |
| edb.clear.sams | 1, 5 | — | — | — | .pushregs, .popregs | rom.farjump | film, xsams.page.set |
| edb.find.init | 5 | — | — | — | .pushregs, .popregs | rom.farjump | film |
| edb.find.scan | 5 | — | — | — | — | — | — |
| edb.find.search | 5 | — | — | — | .pushregs, .popregs | edb.find.scan, fb.calc.scrrows, fb.goto.nextmatch, fb.refresh, fb.vdpdump, pane.cmdb.hide, rom.farjump | hchar, putat |
| edb.hipage.alloc | — | — | @edb.next_free.ptr | — | .pushregs, .popregs | — | cpu.crash, xsams.page.set |
| edb.hipage.alloc.check_setpage | — | — | @edb.next_free.ptr | — | — | — | — |
| edb.hipage.alloc.setpage | — | — | @edb.next_free.ptr | — | — | — | xsams.page.set |
| edb.init | — | — | — | — | .pushregs, .popregs | — | — |
| edb.line.copy | 5 | — | @parm1, @parm2 | — | .pushregs, .popregs | edb.hipage.alloc, edb.line.mappage, idx.entry.update | cpu.crash, xpym2m, xsams.page.set |
| edb.line.del | 5 | — | @parm1 | — | .pushregs, .popregs | idx.entry.delete | cpu.crash |
| edb.line.getlength | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | edb.line.mappage | — |
| edb.line.getlength2 | — | — | @fb.row | @outparm1, @outparm2 | .pushregs, .popregs | edb.line.getlength | — |
| edb.line.mappage | — | — | — | @outparm1, @outparm2 | .pushregs, .popregs | idx.pointer.get | cpu.crash, xsams.page.set |
| edb.line.mappage.lookup | — | — | — | @outparm1, @outparm2 | — | idx.pointer.get | xsams.page.set |
| edb.line.pack.fb | 1 | — | @fb.top, @fb.row, @fb.column, @fb.colsline | — | .pushregs, .popregs | edb.hipage.alloc, fb.calc.pointer, idx.entry.update, rom.farjump | cpu.crash, xpym2m, xsams.page.set |
| edb.line.pack.fb.scan | — | — | @fb.top, @fb.row, @fb.column, @fb.colsline | — | — | — | — |
| edb.line.unpack.fb | 1 | — | @parm1, @parm2, @parm3, @fb.vwco | @outparm1 | .pushregs, .popregs | edb.line.mappage, rom.farjump | xfilm, xpym2m |
| edb.lock | 1, 5 | — | @edb.locked | — | .pushregs, .popregs | — | putat, rsslot |
| edb.unlock | 1, 5 | — | @edb.locked | — | .pushregs, .popregs | — | putat, rsslot |
| edk.act.cmdb.am.toggle | — | — | — | — | — | edk.act.cmdb.preset, tibasic.am.toggle | edkey.keyscan.hook.debounce |
| edk.act.cmdb.char | — | — | tmp1 | — | — | cmdb.cmd.getlength, cmdb.cmd.insert, cmdb.refresh_prompt, vdp.cursor.tat | edkey.keyscan.hook.debounce |
| edk.act.cmdb.clear | — | tmp0 | — | — | — | cmdb.cmd.clear, cmdb.refresh_prompt, edk.act.cmdb.del_char | edk.act.cmdb.home |
| edk.act.cmdb.close.about | — | — | — | — | — | cmdb.dialog.close, edk.act.cmdb.close.dialog | edkey.keyscan.hook.debounce, hchar |
| edk.act.cmdb.close.dialog | — | — | — | — | — | cmdb.dialog.close | edkey.keyscan.hook.debounce |
| edk.act.cmdb.del_char | — | tmp0 | — | — | — | cmdb.cmd.delete, cmdb.refresh_prompt, edk.act.cmdb.char | edkey.keyscan.hook.debounce |
| edk.act.cmdb.lineterm.toggle | — | — | — | — | — | edk.act.cmdb.am.toggle, fm.lineterm | edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.next | — | — | — | — | — | cmdb.cmd.cursor_eol, cmdb.refresh_prompt, fm.browse.fname.next, pane.filebrowser.hilight, vdp.cursor.tat | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.next.setfile | — | — | — | — | — | cmdb.cmd.cursor_eol, cmdb.refresh_prompt, vdp.cursor.tat | cpym2m |
| edk.act.cmdb.pick.prev | — | — | — | — | — | cmdb.cmd.cursor_eol, cmdb.refresh_prompt, fm.browse.fname.prev, pane.filebrowser.hilight, vdp.cursor.tat | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.prev.setfile | — | — | — | — | — | cmdb.cmd.cursor_eol, cmdb.refresh_prompt, vdp.cursor.tat | cpym2m |
| edk.act.cmdb.preset | — | — | — | — | — | cmdb.cmd.preset, edk.act.cmdb.close.about | edkey.keyscan.hook.debounce |
| edk.act.cmdb.proceed | — | — | @cmdb.action.ptr | — | — | cmdb.cmd.clear, edk.act.cmdb.lineterm.toggle, pane.cursor.blink | cpu.crash, edkey.keyscan.hook.debounce |
| edk.act.cmdb.show | 1 | — | — | — | — | pane.cmdb.show, rom.farjump | — |
| edk.act.cmdb.updir | — | — | — | — | — | fm.browse.updir, fm.directory | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.fb.clip.save.1 | — | — | — | — | — | — | — |
| edk.act.fb.clip.save.2 | — | — | — | — | — | — | — |
| edk.act.fb.clip.save.3 | — | — | — | — | — | edb.block.clip | — |
| edk.act.fb.load.file | — | — | @parm1, @parm2 | — | — | error.display, pane.cmdb.hide | — |
| edk.act.find.reset | — | — | — | — | — | edb.find.init | edkey.keyscan.hook.debounce |
| edk.fb.char | — | — | tmp0 | — | .pushregs, .popregs | fb.insert.char, fb.replace.char, vdp.cursor.tat | — |
| edkey.fb.goto.line | — | — | @parm1, @parm2 | — | — | edb.line.getlength2, fb.calc.pointer, fb.refresh | edkey.keyscan.hook.debounce |
| edkey.fb.goto.offset | — | — | @parm1, @parm2 | — | — | — | — |
| edkey.fb.goto.row | — | — | @parm1, @parm2 | — | — | — | — |
| edkey.fb.goto.toprow | — | — | @parm1, @parm2 | — | — | — | — |
| error.display | 4 | — | @parm1 | — | .pushregs, .popregs | pane.errline.show, rom.farjump | xpym2m |
| errpane.init | — | — | — | — | .pushregs | — | film |
| fb.calc.pointer | — | — | @fb.top, @fb.topline, @fb.row, @fb.scrrows, @fb.column, @fb.colsline | — | .pushregs, .popregs | — | — |
| fb.calc.scrrows | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.errors | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.mc | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.ruler | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.colorlines | 4 | — | @parm1, @fb.colorize | — | .pushregs, .popregs | — | xfilv |
| fb.cursor.bot | 4 | — | — | — | — | edb.line.pack.fb, fb.cursor.botscr, fb.goto.toprow | — |
| fb.cursor.bot.refresh | — | — | — | — | — | fb.cursor.botscr, fb.goto.toprow | — |
| fb.cursor.botscr | 4 | — | — | — | .pushregs, .popregs | edb.line.getlength2, edb.line.pack.fb, fb.calc.pointer | — |
| fb.cursor.botscr.cursor | — | — | — | — | — | — | — |
| fb.cursor.botscr.eof | — | — | — | — | — | edb.line.getlength2, fb.calc.pointer | — |
| fb.cursor.down | 4 | — | — | — | .pushregs, .popregs | edb.line.getlength2, edb.line.pack.fb, fb.calc.pointer, fb.refresh, vdp.cursor.tat | down, xsetx |
| fb.cursor.down.move | — | — | — | — | — | fb.refresh | — |
| fb.cursor.home | 4 | — | — | — | .pushregs, .popregs | fb.calc.pointer, vdp.cursor.tat | — |
| fb.cursor.on | — | — | — | — | — | — | — |
| fb.cursor.top | 4 | — | — | — | — | edb.line.pack.fb, fb.goto.toprow, rom.farjump | — |
| fb.cursor.top.refresh | — | — | — | — | — | fb.goto.toprow | — |
| fb.cursor.topscr | 4 | — | — | — | — | edb.line.pack.fb, fb.goto.toprow | — |
| fb.cursor.topscr.refresh | — | — | — | — | — | fb.goto.toprow | — |
| fb.cursor.up | 4 | — | — | — | — | — | — |
| fb.cursor.up.cursor | — | — | — | — | — | fb.refresh | — |
| fb.get.nonblank | 4 | — | — | @outparm1, @outparm2 | .pushregs, .popregs | edb.line.getlength2, fb.calc.pointer | — |
| fb.goto.nextmatch | 4 | — | — | — | .pushregs | rom.farjump | — |
| fb.goto.prevmatch | 4 | — | — | — | .pushregs | — | — |
| fb.goto.toprow | 4 | — | @parm1, @parm2 | — | .pushregs, .popregs | edb.line.getlength2, fb.calc.pointer, fb.refresh | — |
| fb.goto.toprow.line | — | — | @parm1, @parm2 | — | — | edb.line.getlength2, fb.calc.pointer, fb.refresh | — |
| fb.goto.toprow.offset | — | — | @parm1, @parm2 | — | — | — | — |
| fb.hscroll | 4 | — | @parm1 | — | .pushregs, .popregs | fb.refresh | — |
| fb.init | — | — | — | — | .pushregs, .popregs | fb.calc.scrrows | film |
| fb.insert.char | 4 | — | @parm1 | — | .pushregs, .popregs | edb.line.pack.fb, fb.calc.pointer, fb.cursor.down, fb.insert.line, fb.replace.char | — |
| fb.insert.char.check1 | — | — | @parm1 | — | — | — | — |
| fb.insert.char.check2 | — | — | @parm1 | — | — | edb.line.pack.fb, fb.cursor.down, fb.insert.line | — |
| fb.insert.line | 4 | — | @parm1 | — | .pushregs, .popregs | edb.line.pack.fb, fb.calc.pointer, fb.cursor.home, fb.refresh, idx.entry.insert | — |
| fb.insert.line.insert | — | — | @parm1 | — | — | fb.calc.pointer, idx.entry.insert | — |
| fb.null2char | — | — | tmp1, tmp2 | — | .pushregs, .popregs | fb.calc.pointer | cpu.crash |
| fb.null2char.crash | — | — | tmp1, tmp2 | — | — | — | cpu.crash |
| fb.null2char.init | — | — | tmp1, tmp2 | — | — | fb.calc.pointer | — |
| fb.refresh | 4 | — | @parm1, @fb.topline | @outparm1 | .pushregs, .popregs | edb.line.unpack.fb, rom.farjump | xfilm |
| fb.refresh.unpack_line | — | — | @parm1, @fb.topline | @outparm1 | — | edb.line.unpack.fb | — |
| fb.replace.char | 4 | — | @parm1 | — | .pushregs, .popregs | fb.calc.pointer | — |
| fb.restore | 4 | — | @parm1 | — | — | fb.colorlines, fb.refresh, pane.colorscheme.botline, pane.cursor.blink | — |
| fb.row2line | 1 | — | @fb.topline, @parm1, @fb.scrrows | @outparm1 | .pushregs, .popregs | — | — |
| fb.ruler.init | 4 | — | — | — | .pushregs, .popregs | — | cpym2m, xfilm |
| fb.scan.fname | 4 | — | — | — | .pushregs, .popregs | fb.calc.pointer, rom.farjump | cpu.crash, film |
| fb.scan.fname.copy | — | — | — | — | — | fb.calc.pointer | film |
| fb.tab.next | 4 | — | — | — | .pushregs, .popregs | fb.calc.pointer, fb.null2char | xsetx |
| fb.tab.prev | 4 | — | — | — | .pushregs, .popregs | fb.calc.pointer | xsetx |
| fb.vdpdump | 1, 4 | — | @parm1 | — | .pushregs, .popregs | rom.farjump | xpym2v |
| fb.vdpdump.calc | — | — | @parm1 | — | — | — | xpym2v |
| fg.goto.nextmatch.first | — | — | — | — | — | — | — |
| fg.goto.nextmatch.goto | — | — | — | — | — | fb.calc.pointer, fb.goto.toprow | — |
| fg.goto.prevmatch.goto | — | — | — | — | — | fb.calc.pointer, fb.goto.toprow | — |
| fg.goto.prevmatch.last | — | — | — | — | — | — | — |
| fh.file.delete | — | — | — | @outparm1 | .pushregs, .popregs | — | cpu.crash, file.delete, film, vgetb, xpym2v |
| fh.file.load.bin | — | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | file.vmem | cpu.crash, file.load, film, filv, vgetb, xpym2v, xpyv2m |
| fh.file.load.bin.newfile | — | — | — | @outparm1 | — | — | — |
| fh.file.load.ea5 | — | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | fh.file.load.bin, pane.botline.busy.on | cpyv2m, hchar, xpyv2m |
| fh.file.load.ea5.parm | — | — | — | @outparm1 | — | — | — |
| fh.file.read.edb | 2 | — | @fh.line, @fh.workmode | — | .pushregs | — | — |
| fh.file.read.edb.assert1 | — | — | @fh.line, @fh.workmode | — | — | — | — |
| fh.file.read.mem | 2 | — | — | — | .pushregs, .popregs | file.vmem | cpu.crash, fh.file.read.mem.error, fh.file.read.mem.record, file.close, file.record.read, film, xfile.open, xpym2v, xpyv2m |
| fh.file.write.edb | 2 | — | — | — | .pushregs | — | — |
| file.vmem | 2 | — | — | — | — | rom.farjump | — |
| fm.browse.fname.next | 2 | — | @cat.shortcut.idx | @outparm1 | .pushregs, .popregs | fm.browse.fname.set, pane.filebrowser | — |
| fm.browse.fname.next.divok | — | — | @cat.shortcut.idx | @outparm1 | — | — | — |
| fm.browse.fname.prev | 2 | — | @cat.shortcut.idx | @outparm1 | .pushregs, .popregs | fm.browse.fname.set, pane.filebrowser | — |
| fm.browse.fname.prev.divok | — | — | @cat.shortcut.idx | @outparm1 | — | — | — |
| fm.browse.fname.prev.page | — | — | @cat.shortcut.idx | @outparm1 | — | fm.browse.fname.set, pane.filebrowser | — |
| fm.browse.fname.set | 2 | — | @tv.devpath, @cat.shortcut.idx | — | .pushregs, .popregs | rom.farjump | film, xpym2m |
| fm.browse.updir | 2 | — | @tv.devpath | @outparm1 | .pushregs, .popregs | — | xfilm |
| fm.browse.updir.loop1 | — | — | @tv.devpath | @outparm1 | — | — | xfilm |
| fm.browse.updir.loop1.cont | — | — | @tv.devpath | @outparm1 | — | — | xfilm |
| fm.clock.off | 5 | — | @parm1 | — | .pushregs, .popregs | rom.farjump, tv.flash.screen | clslot, film, putat |
| fm.clock.on | 5 | — | — | — | .pushregs, .popregs | tv.clock.start | putat, rsslot |
| fm.clock.read | 2 | — | — | — | .pushregs, .pushparms | fh.file.read.mem, fm.clock.off, rom.farjump | — |
| fm.clock.read.cb.stopflag | — | — | @fh.callback1 | — | — | — | — |
| fm.delfile | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | fh.file.delete, fm.directory, pane.cmdb.hide | — |
| fm.delfile.callback1 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | fm.delfile.callback2, pane.botline.busy.on | at, hchar, putat, xutst0 |
| fm.delfile.callback1.filename | — | — | — | — | — | — | at, xutst0 |
| fm.delfile.callback2 | — | — | — | — | .pushregs, .popregs | pane.botline.busy.off | putat, rsslot |
| fm.delfile.refreshdir | — | — | — | @outparm1 | — | fm.directory, pane.cmdb.hide | — |
| fm.dir.callback1 | — | tmp0,tmp1,tmp2,tmp3,tmp4 | — | — | .pushregs, .popregs | fm.dir.callback2, pane.botline.busy.on | at, putat, xutst0 |
| fm.dir.callback2 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | fm.dir.callback3 | fm.dir.callback2.exit, putnum, xpym2m |
| fm.dir.callback2.volname | — | — | — | — | — | — | fm.dir.callback2.exit, xpym2m |
| fm.dir.callback3 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | fm.dir.callback4, pane.botline.busy.off | putat, rsslot |
| fm.dir.callback4 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | fm.dir.callback5, pane.botline.busy.off | putat, rsslot |
| fm.dir.callback5 | — | — | — | — | .pushregs, .popregs | pane.botline.busy.off | — |
| fm.directory | 2 | — | — | — | .pushregs, .pushparms, .popparms, .popregs | fh.file.read.mem, fm.browse.fname.set, pane.cursor.blink, pane.cursor.hide, pane.filebrowser, pane.filebrowser.colbar.remove, rom.farjump, vdp.cursor.tat.cmdb.hide | film, filv, fm.directory.browser, fm.directory.exit, mknum, trimnum, xfilv, xpym2m |
| fm.insertfile | 2 | — | — | — | .pushregs, .pushparms, .popparms, .popregs | fh.file.read.edb, rom.farjump | — |
| fm.lineterm | 3 | — | — | — | .pushregs, .popregs | — | cpu.crash, mknum, trimnum |
| fm.load.cb.memfull | — | — | — | — | — | pane.botline.busy.off, pane.errline.show | cpym2m, hchar |
| fm.load.ea5.cb.fioerr | — | — | — | — | .pushregs, .popregs | fm.newfile, pane.botline.busy.off, pane.colorscheme.load, pane.errline.show, tv.set.font, vdp.dump.patterns | cpym2m, hchar, putat, putnum, rsslot, xpym2m |
| fm.load.ea5.cb.indicator1 | — | tmp0,tmp1,tmp2,tmp3 | @parm1, @fh.callback1 | — | .pushregs, .popregs | — | at, putat, xutst0 |
| fm.load.ea5.cb.indicator1.filename | — | — | @parm1, @fh.callback1 | — | — | — | at, xutst0 |
| fm.load.ea5.cb.indicator1.loading | — | — | @parm1, @fh.callback1 | — | — | — | putat |
| fm.load.ea5.cb.indicator2 | — | — | @parm1, @fh.callback1 | — | .pushregs | pane.botline.busy.off | cpyv2m |
| fm.load.ea5.cb.message | — | — | — | — | — | — | at, hchar, rsslot, xutst0 |
| fm.loadfile | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | dialog.unsaved, fh.file.read.edb, pane.colorscheme.load, rom.farjump, tv.reset | scroff, xfilv, xpym2m |
| fm.loadsave.cb.fioerr | — | — | — | — | .pushregs, .popregs | pane.botline.busy.off, pane.errline.show | cpym2m, hchar, putat, putnum, rsslot, xpym2m |
| fm.loadsave.cb.fioerr.load | — | — | — | — | — | — | cpym2m |
| fm.loadsave.cb.indicator1 | — | tmp0 | @parm1, @fh.callback1 | — | .pushregs, .popregs | pane.botline.busy.on | at, cpu.crash, hchar, putat, xsams.page.get, xsams.page.set, xutst0 |
| fm.loadsave.cb.indicator1.newfile | — | — | @parm1, @fh.callback1 | — | — | — | — |
| fm.loadsave.cb.indicator1.sams | — | — | @parm1, @fh.callback1 | — | — | — | xsams.page.get, xsams.page.set |
| fm.loadsave.cb.indicator2 | — | tmp0,tmp1,tmp2,tmp3 | — | — | .pushregs, .popregs | fb.calc.scrrows, fb.refresh, fb.vdpdump | putat, putnum |
| fm.loadsave.cb.indicator2.loadsave | — | — | — | — | — | — | — |
| fm.loadsave.cb.indicator2.refresh | — | — | — | — | — | fb.calc.scrrows, fb.refresh, fb.vdpdump | — |
| fm.loadsave.cb.indicator2.topline | — | — | — | — | — | — | — |
| fm.loadsave.cb.indicator3 | — | — | — | — | .pushregs | pane.botline.busy.off | putat, putnum |
| fm.newfile | 2 | — | — | — | .pushregs, .popregs | edb.clear.sams, pane.botline.busy.off, pane.botline.busy.on, rom.farjump, tv.reset | hchar, putat |
| fm.run.ea5 | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | fb.cursor.top, fh.file.load.ea5, mem.run.ea5, pane.colorscheme.load, tv.reset | scroff, xfilv |
| fm.savefile | 2 | — | — | — | .pushregs, .popregs | fh.file.write.edb, rom.farjump | xpym2m |
| get_cursorcolor | — | — | tmp1 | @outparm1 | .pushregs, .popregs | edb.block.match, pane.colorscheme.index | — |
| idx.entry.delete | — | — | @parm1, @parm2 | — | .pushregs, .popregs | — | — |
| idx.entry.delete.lastline | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.delete.reorg | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.insert | — | — | @parm1, @parm2 | — | .pushregs, .popregs | — | — |
| idx.entry.insert.reorg | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.insert.reorg.complex | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.update | — | — | @parm1, @parm2, @parm3 | @outparm1 | .pushregs, .popregs | — | — |
| idx.entry.update.save | — | — | @parm1, @parm2, @parm3 | @outparm1 | — | — | — |
| idx.init | — | tmp0,tmp1,tmp2 | — | — | .pushregs, .popregs | — | film |
| idx.pointer.get | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | — | — |
| idx.pointer.get.parm | — | — | @parm1 | @outparm1, @outparm2 | — | — | — |
| isr | — | r7, r10 | — | — | — | tib.run.return | — |
| isr.scan.crunchbuf | — | — | — | — | — | — | — |
| isr.scan.end | — | — | — | — | — | tib.run.return | — |
| isr.scan.old | — | — | — | — | — | — | — |
| isr.showid | — | — | — | — | — | — | — |
| main.continue | — | — | — | — | .ifeq, .endif | dialog, mem.sams.setup.stevie, pane.colorscheme.load, rom.dialogs2ram, tv.init, tv.reset, tv.set.font, vdp.dump.patterns | at, clslot, f18unl, film, filv, mkhook, mkslot, mute, putvr, scroff, tmgr |
| main.stevie | — | — | — | — | — | — | putstr |
| mem.run.ea5 | 7 | — | — | — | — | file.vmem, rom.farjump | 6040, cpym2v, f18rst, filv, ldfnt, scroff, scron, vidtab |
| mem.sams.dialogs.off | e | — | @tv.sams.b000, @tv.sams.c000 | — | .pushregs | rom.farjump | xsams.page.set |
| mem.sams.dialogs.on | e | — | — | — | — | rom.farjump | sams.page.set |
| mem.sams.set.basic1 | 7 | tmp0, r12 | — | — | — | — | — |
| mem.sams.set.basic2 | 7 | tmp0, r12 | — | — | — | — | — |
| mem.sams.set.basic3 | 7 | r0, r12 | — | — | — | — | — |
| mem.sams.set.boot | 7 | r0, r12 | — | — | — | rom.farjump | — |
| mem.sams.set.external | 7 | tmp0, r12 | — | — | — | — | — |
| mem.sams.set.legacy | 7 | r0, r12 | — | — | — | rom.farjump | — |
| mem.sams.set.legacy.code | — | r0, r12 | — | — | — | — | — |
| mem.sams.set.stevie | 7 | — | — | — | .endif | rom.farjump | — |
| mem.sams.setup.stevie | 1 | — | — | — | .endif, .ifgt, .ifne | mem.sams.set.boot, rom.farjump | sams.layout.copy |
| pane.botline | 4 | — | — | — | .pushregs, .popregs | fb.row2line, pane.botline.keycolor, tv.pad.string, vdp.colors.line | at, film, hchar, mknum, putat, putnum, trimnum, xutst0 |
| pane.botline.busy.off | 4 | — | — | — | — | pane.colorscheme.botline, rom.farjump | hchar |
| pane.botline.busy.on | 4 | — | — | — | — | pane.botline.busy.off, pane.colorscheme.botline, rom.farjump | hchar |
| pane.botline.keycolor | 4 | — | @cmdb.keycolors | @outparm1, @outparm5 | .pushregs, .popregs | mem.sams.dialogs.off, mem.sams.dialogs.on, pane.colorscheme.index, rom.farjump | cpym2v, xfilm |
| pane.botline.mc | — | — | — | — | — | tv.pad.string, vdp.colors.line | at, xutst0 |
| pane.clock.time | 5 | — | @tv.clock.state | — | .pushregs, .popregs | rom.farjump | cpym2v, xpym2v |
| pane.cmdb.draw | 3 | — | @cmdb.panhead, @cmdb.paninfo, @cmdb.panhint, @cmdb.pankeys | @outparm1 | .pushregs, .ifge, .endif, .else, .popregs | cmdb.refresh_prompt, mem.sams.dialogs.off, mem.sams.dialogs.on, pane.botline.keycolor, pane.clock.time, pane.show_hintx, rom.farjump, tv.pad.string | at, cpym2m, film, hchar, putat, vchar, xfilm, xutst0 |
| pane.cmdb.hide | 4 | — | — | — | .pushregs, .ifge, .endif, .popregs | pane.colorscheme.load, pane.cursor.blink, rom.farjump | hchar |
| pane.cmdb.show | 4 | — | — | — | .pushregs, .popregs | cmdb.cmd.cursor_eol, pane.errline.hide, rom.farjump, vdp.cursor.tat.fb | — |
| pane.cmdb.show.rest | — | — | — | — | — | cmdb.cmd.cursor_eol, pane.errline.hide, vdp.cursor.tat.fb | — |
| pane.cmdb.statlines | — | — | @tv.devpath, @tv.sams.maxpage, @tv.sams.hipage | — | .pushregs, .popregs | pane.cursor.hide | cpym2m, film, hchar, mknum, trimnum |
| pane.colorscheme.address | — | — | @tv.colorscheme | @outparm1 | .pushregs, .popregs | — | — |
| pane.colorscheme.botline | 4 | — | @parm1 | — | .pushregs, .popregs | rom.farjump, vdp.colors.line | — |
| pane.colorscheme.cycle | 4 | — | — | — | .pushregs | — | — |
| pane.colorscheme.index | 4 | tmp0,tmp1 | @tv.colorscheme | @outparm1 | .pushregs, .popregs | pane.colorscheme.address, rom.farjump | — |
| pane.colorscheme.load | 4 | — | @tv.colorscheme, @parm1, @parm2, @parm3 | @outparm1 | .pushregs | pane.colorscheme.address, rom.farjump | putvrx, scroff |
| pane.colorscheme.switch | — | — | — | — | — | pane.colorscheme.load | putat, putnum, rsslot |
| pane.cursor.blink | 1 | — | — | — | — | rom.farjump | mkslot |
| pane.cursor.hide | 1 | — | — | — | — | rom.farjump | clslot |
| pane.errline.drawcolor | 4 | tmp0,tmp1 | @tv.error.rows, @parm1 | — | .pushregs, .popregs | pane.errline.show, vdp.colors.line | — |
| pane.errline.hide | 1, 4 | — | — | — | .pushregs, .popregs | errpane.init, fb.calc.scrrows, pane.errline.drawcolor, rom.farjump | — |
| pane.errline.hide.fbcolor | — | — | — | — | — | fb.calc.scrrows, pane.errline.drawcolor | — |
| pane.errline.show | 1, 4 | tmp0 | @tv.error.msg | — | .pushregs, .popregs | fb.calc.scrrows, pane.errline.drawcolor, pane.errline.hide, rom.farjump, tv.pad.string | at, xutst0 |
| pane.filebrowser | 4 | — | @cat.fpicker.idx | — | .pushregs, .popregs | cmdb.cmd.cursor_eol, cmdb.refresh_prompt, pane.colorscheme.load, pane.filebrowser.hilight, rom.farjump | at, cpym2m, filv, hchar, mknum, pane.filebrowser.exit, putat, putlst, trimnum, vchar, xfilv |
| pane.filebrowser.colbar | 4 | tmp0,tmp1,tmp2 | @wyx, tmp0 | — | .pushregs, .popregs | pane.filebrowser.colbar.remove, rom.farjump | putstr, xfilv, xvputb, yx2pnt |
| pane.filebrowser.colbar.remove | 4 | — | @cat.barpos | — | .pushregs, .popregs | pane.filebrowser.colbar, rom.farjump | putstr |
| pane.filebrowser.hilight | 4 | — | @cat.shortcut.idx | — | .pushregs, .popregs | pane.filebrowser.colbar, pane.filebrowser.colbar.remove, rom.farjump | cpu.crash, putstr |
| pane.filebrowser.hilight.divok | — | — | @cat.shortcut.idx | — | — | — | — |
| pane.show_hintx | 3 | — | @parm1, @parm2, @parm3 | — | .pushregs, .popregs | — | cpu.crash, xfilv, xutst0, yx2pnt |
| pane.topline | 4 | — | — | — | .pushregs, .popregs | tv.pad.string, tv.uint16.unpack | at, film, hchar, mknum, putat, putnum, trimnum, xutst0 |
| pane.topline.file | — | — | — | — | — | — | at |
| pane.topline.oneshot.clearmsg | — | — | — | — | — | — | hchar |
| pane.vdpdump | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | .pushregs, .popregs | fb.calc.scrrows, fb.colorlines, fb.vdpdump, pane.botline, pane.cmdb.draw, pane.colorscheme.load, pane.topline | cpym2v, putat |
| pane.vdpdump.alpha_lock | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | — | — | putat |
| pane.vdpdump.alpha_lock.down | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | — | — | putat |
| rom.dialogs2ram | e | — | — | — | .pushregs, .popregs | mem.sams.dialogs.off, mem.sams.dialogs.on, rom.farjump | cpym2m |
| rom.farjump | — | — | — | — | — | — | — |
| tib.run | 7 | — | @tib.session | — | .pushregs | mem.sams.set.basic1, mem.sams.set.basic2, mem.sams.set.basic3, mem.sams.set.external | cpu.crash, cpu.scrpad.backup, cpu.scrpad.restore, cpym2m, cpym2v, cpyv2m, f18rst, filv, ldfnt, sams.layout.copy, scroff, tib.run.resume.basic1, tib.run.resume.basic2, vidtab |
| tib.run.return | 7 | — | — | — | — | — | cpu.crash, cpym2m |
| tib.run.return.1 | — | — | — | — | — | — | cpym2m |
| tib.uncrunch | 7 | — | @parm1 | — | .pushregs, .popregs | cmdb.dialog.close, edb.line.getlength2, fb.calc.pointer, fb.refresh, pane.colorscheme.botline, tib.uncrunch.prepare, tib.uncrunch.prg | hchar, putat, xsams.page.set |
| tib.uncrunch.line.pack | — | — | @fb.uncrunch, @parm1 | — | .pushregs, .popregs | edb.hipage.alloc, idx.entry.update | xpym2m, xsams.page.set |
| tib.uncrunch.prepare | — | — | @parm1 | — | .pushregs, .popregs | — | cpu.crash, sams.page.set, xpym2m |
| tib.uncrunch.prg | — | — | @parm1 | — | .pushregs | fb.row2line, tib.uncrunch.token | at, mknum, tib.uncrunch.prg.exit, trimnum |
| tib.uncrunch.token | — | — | @parm1, @parm2 | @outparm1, @outparm2 | .pushregs, .popregs | — | mknum, tib.uncrunch.token.setlen, trimnum, xpym2m |
| tibasic.am.off | — | — | — | — | — | — | — |
| tibasic.am.toggle | 3 | — | — | — | .pushregs | — | — |
| tv.autoinsert.toggle | 3 | — | @tv.autoinsert, @edb.locked | — | .pushregs | — | hchar, putat |
| tv.bcd.pack | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | — | — |
| tv.clock.start | 1 | — | — | — | .pushregs, .popregs | rom.farjump | film, mkslot |
| tv.clock.toggle | 3 | — | @tv.clock.state | — | .pushregs | tv.clock.start | clslot, hchar, putat |
| tv.flash.screen | 5 | — | — | — | — | pane.colorscheme.load | — |
| tv.init | — | — | — | — | .pushregs, .popregs | — | cpym2m |
| tv.linelen.oneshot | — | — | @tv.show.linelen | — | — | — | rsslot |
| tv.linelen.toggle | 3 | — | @tv.show.linelen | — | .pushregs | — | hchar, putat |
| tv.pad.string | — | — | @parm1, @parm2, @parm3, @parm4 | @outparm1 | .pushregs, .popregs | — | cpu.crash, xpym2m |
| tv.quit | — | — | — | — | — | rom.farjump | f18rst |
| tv.reset | 7 | — | — | — | — | cmdb.init, edb.find.init, edb.init, errpane.init, fb.init, idx.init, rom.farjump | hchar |
| tv.set.font | 6 | — | @parm1 | — | .pushregs, .popregs | rom.farjump, vdp.dump.font | cpu.crash |
| tv.set.font.ptr | — | — | @parm1 | — | — | — | — |
| tv.set.font.vdpdump | — | — | @parm1 | — | — | vdp.dump.font | — |
| tv.uint16.pack | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | — | xstring.getlenc |
| tv.uint16.unpack | — | — | @parm1 | — | .pushregs, .popregs | — | mknum, trimnum |
| txt.clockon | — | — | — | — | — | — | — |
| vdp.colors.line | 6 | — | @parm1, @parm2 | — | .pushregs, .popregs | rom.farjump | xfilv |
| vdp.cursor.tat | 6 | — | — | — | .pushregs, .popregs | rom.farjump, vdp.cursor.tat.cmdb, vdp.cursor.tat.fb | cpu.crash |
| vdp.cursor.tat.cmdb | — | — | @cmdb.cursor, @cmdb.prevcursor | — | .pushregs, .popregs | vdp.cursor.tat.cmdb.hide | xvputb, yx2pnt |
| vdp.cursor.tat.cmdb.hide | 6 | — | @cmdb.cursor | — | .pushregs, .popregs | rom.farjump | xvputb, yx2pnt |
| vdp.cursor.tat.cmdb.show | — | — | @cmdb.cursor, @cmdb.prevcursor | — | — | — | xvputb, yx2pnt |
| vdp.cursor.tat.cur.cmdb | — | — | — | — | — | vdp.cursor.tat.cmdb | — |
| vdp.cursor.tat.cur.fb | — | — | — | — | — | vdp.cursor.tat.fb | — |
| vdp.cursor.tat.fb | 6 | tmp0,tmp1 | @wyx, @fb.prevcursor | @outparm1 | .pushregs, .popregs | get_cursorcolor, rom.farjump | xvputb, yx2pnt |
| vdp.cursor.tat.fb.hide | — | — | @wyx, @fb.prevcursor | @outparm1 | — | get_cursorcolor | xvputb, yx2pnt |
| vdp.dump.font | 6 | — | @tv.font.ptr | — | .pushregs, .popregs | — | xpym2v |
| vdp.dump.patterns | 6 | — | — | — | — | rom.farjump | cpym2v |
| xrom.farjump | — | — | — | — | .ifeq, .endif | — | — |

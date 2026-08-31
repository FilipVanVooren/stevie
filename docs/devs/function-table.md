| Function | ROM banks | Register usage | Input parameters | Output parameters | Macros | Called functions | External calls |
| --- | --- | --- | --- | --- | --- | --- | --- |
| cart.fg99.mgr | 7 | — | @cmdb.cmdall | @outparm1 | .pushregs, .popregs | rom.farjump | cpym2m, xpym2m |
| cart.fg99.run | — | — | @tv.fg99.img.ptr | — | — | f18rst, vidtab, scroff, xfg99 | f18rst, scroff, vidtab, xfg99 |
| cmdb.cfg.fname | 3 | — | @parm1, @parm2 | @outparm1 | .pushregs, .popregs | — | hchar, rsslot, xpym2m |
| cmdb.cmd.clear | 1, 3 | — | — | — | .pushregs, .popregs | — | film |
| cmdb.cmd.cursor_eol | 3 | — | — | @outparm1 | .popregs | rom.farjump | — |
| cmdb.cmd.delete | 3 | — | @cmdb.column | @outparm1 | .pushregs, .popregs | — | — |
| cmdb.cmd.delete.shift | — | — | @cmdb.column | @outparm1 | — | — | — |
| cmdb.cmd.getlength | 3 | tmp0,tmp1,tmp2,tmp3 | @cmdb.cmd | — | — | rom.farjump | string.getlenc |
| cmdb.cmd.insert | 3 | tmp0,tmp1,tmp2,tmp3 | @cmdb.column, @parm1 | — | .pushregs, .popregs | — | — |
| cmdb.cmd.insert.shift | — | — | @cmdb.column, @parm1 | — | — | — | — |
| cmdb.cmd.preset | 3 | — | @waux1, @cmdb.dialog | — | .pushregs, .popregs | — | — |
| cmdb.cmd.set | 3 | — | @parm1 | — | .pushregs, .popregs | — | film, xpym2m |
| cmdb.dialog.close | 1 | — | — | — | — | rom.farjump | — |
| cmdb.init | — | — | — | — | .pushregs, .popregs | film | film |
| cmdb.refresh_prompt | 3 | — | @cmdb.yxprompt, @cmdb.cmd | — | .pushregs, .popregs | rom.farjump | putstr, xpym2v, yx2pnt |
| dialog | 3 | — | — | — | .pushregs, .popregs | — | cpym2m |
| dialog.append | 3 | — | — | — | .pushregs, .popregs | — | — |
| dialog.append.keylist | — | — | — | — | — | cmdb.cmd.set | — |
| dialog.append.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.basic | 3 | — | — | — | .pushregs, .popregs | rom.farjump | cpym2m, mknum, trimnum |
| dialog.cart.fg99 | 3 | — | — | — | .pushregs, .popregs | — | cpym2m |
| dialog.cart.fg99.setup | — | — | — | — | — | pane.cursor.blink, cmdb.cmd.clear, cpym2m | cpym2m |
| dialog.cart.type | 3 | — | — | — | .pushregs, .popregs | mem.sams.dialogs.on, pane.cursor.hide, mem.sams.dialogs.off | — |
| dialog.cat | 3 | — | — | — | .pushregs, .popregs | — | — |
| dialog.cat.keylist | — | — | — | — | — | — | — |
| dialog.clipboard | 3 | — | — | @outparm1 | .pushregs, .popregs | — | cpym2m, film, mknum |
| dialog.clipboard.setup | — | — | — | @outparm1 | — | film, cpym2m, fb.row2line, mknum, cmdb.cmd.clear | cpym2m, film, mknum |
| dialog.clock | — | — | — | — | .pushregs, .popregs | mem.sams.dialogs.on | — |
| dialog.clock.setup | — | — | — | — | — | pane.cursor.hide, mem.sams.dialogs.off | — |
| dialog.delete | 3 | — | — | — | .pushregs, .popregs | — | film |
| dialog.delete.keylist | — | — | — | — | — | — | — |
| dialog.delete.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.file | 3 | — | — | — | .pushregs, .popregs | — | — |
| dialog.find | 3 | — | — | — | .pushregs, .popregs | — | cpym2m |
| dialog.font | 3 | — | — | — | .pushregs, .popregs | — | — |
| dialog.font.keylist | — | — | — | — | — | pane.cursor.hide, mem.sams.dialogs.off | — |
| dialog.font.setup | — | — | — | — | — | — | — |
| dialog.goto | 3 | — | — | — | .pushregs, .popregs | — | film |
| dialog.help | 3 | — | — | — | — | — | — |
| dialog.help.content | f | — | @cmdb.dialog.var | — | .pushregs, .popregs | rom.farjump | at, filv, hchar, putat, putlst, putnum, xfilv |
| dialog.help.content.clear | — | — | @cmdb.dialog.var | — | — | filv, hchar, putnum, putat, xfilv, at, putlst | at, filv, hchar, putat, putlst, putnum, xfilv |
| dialog.insert | 3 | — | — | @outparm1 | .pushregs, .popregs | — | cpym2m, film, mknum |
| dialog.insert.setup | — | — | — | @outparm1 | — | fb.scan.fname, film, cpym2m, fb.row2line, mknum | cpym2m, film, mknum |
| dialog.main | 3 | — | — | — | .pushregs, .popregs | — | edk.act.block.reset |
| dialog.open | 3 | — | — | — | .pushregs, .popregs | — | film |
| dialog.open.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.opt | 3 | — | — | — | .pushregs, .popregs | mem.sams.dialogs.on | — |
| dialog.opt.clip | 3 | — | — | — | .pushregs, .popregs | mem.sams.dialogs.on, cmdb.cmd.set, pane.cursor.blink, mem.sams.dialogs.off | — |
| dialog.print | 3 | — | — | — | .pushregs, .popregs | — | edb.line.pack |
| dialog.print.default | — | — | — | — | — | — | — |
| dialog.run | 3 | — | — | — | .pushregs, .popregs | — | film |
| dialog.run.setup | — | — | — | — | — | fb.scan.fname | — |
| dialog.save | 3 | — | — | — | .pushregs, .popregs | — | cpym2m, edb.line.pack |
| dialog.shortcuts | 3 | — | — | — | .pushregs, .popregs | — | — |
| dialog.unsaved | 3 | — | — | — | .pushregs, .popregs | — | hchar |
| edb.block.clip | 5 | — | @edb.clip.filename, @edb.block.m1, @edb.block.m2, @parm1 | — | .pushregs, .popregs | — | cpym2m |
| edb.block.copy | 5 | — | @edb.block.m1, @edb.block.m2, @parm1 | @outparm1 | .pushregs, .popregs | — | cpym2m, hchar, putat |
| edb.block.delete | 5 | — | @edb.block.m1, @edb.block.m2, @parm1 | @outparm1 | .pushregs, .popregs | — | hchar, putat |
| edb.block.mark | 5 | — | @edb.block.m1, @edb.block.m2 | @outparm1 | — | — | — |
| edb.block.mark.m1 | 5 | — | @edb.block.m1 | @outparm1 | — | — | — |
| edb.block.mark.m2 | 5 | tmp0,tmp1 | @edb.block.m2 | @outparm1 | — | — | — |
| edb.block.match | 5 | — | @parm1 | @outparm1 | .pushregs, .popregs | rom.farjump | — |
| edb.block.reset | 5 | — | — | — | — | — | hchar |
| edb.clear.sams | 1, 5 | — | — | — | .pushregs, .popregs | rom.farjump | film, xsams.page.set |
| edb.find.init | 5 | — | — | — | .pushregs, .popregs | rom.farjump | film |
| edb.find.scan | 5 | — | — | — | — | — | — |
| edb.find.search | 5 | — | — | — | .pushregs, .popregs | rom.farjump | hchar, putat |
| edb.hipage.alloc | — | — | @edb.next_free.ptr | — | .pushregs, .popregs | — | cpu.crash, xsams.page.set |
| edb.hipage.alloc.check_setpage | — | — | @edb.next_free.ptr | — | — | — | — |
| edb.hipage.alloc.setpage | — | — | @edb.next_free.ptr | — | — | xsams.page.set | xsams.page.set |
| edb.init | — | — | — | — | .pushregs, .popregs | — | — |
| edb.line.copy | 5 | — | @parm1, @parm2 | — | .pushregs, .popregs | cpu.crash, edb.line.mappage | cpu.crash, xpym2m, xsams.page.set |
| edb.line.del | 5 | — | @parm1 | — | .pushregs, .popregs | — | cpu.crash |
| edb.line.getlength | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | edb.line.mappage | — |
| edb.line.getlength2 | — | — | @fb.row | @outparm1, @outparm2 | .pushregs, .popregs | edb.line.getlength | — |
| edb.line.mappage | — | — | — | @outparm1, @outparm2 | .pushregs, .popregs | cpu.crash | cpu.crash, xsams.page.set |
| edb.line.mappage.lookup | — | — | — | @outparm1, @outparm2 | — | idx.pointer.get, xsams.page.set | xsams.page.set |
| edb.line.pack.fb | 1 | — | @fb.top, @fb.row, @fb.column, @fb.colsline | — | .pushregs, .popregs | rom.farjump | cpu.crash, xpym2m, xsams.page.set |
| edb.line.pack.fb.scan | — | — | @fb.top, @fb.row, @fb.column, @fb.colsline | — | — | — | — |
| edb.line.unpack.fb | 1 | — | @parm1, @parm2, @parm3, @fb.vwco | @outparm1 | .pushregs, .popregs | rom.farjump | xfilm, xpym2m |
| edb.lock | 1, 5 | — | @edb.locked | — | .pushregs, .popregs | — | putat, rsslot |
| edb.unlock | 1, 5 | — | @edb.locked | — | .pushregs, .popregs | — | putat, rsslot |
| edk.act.cmdb.am.toggle | — | — | — | — | — | tibasic.am.toggle | edkey.keyscan.hook.debounce |
| edk.act.cmdb.char | — | — | tmp1 | — | — | cmdb.cmd.getlength, cmdb.cmd.insert | edkey.keyscan.hook.debounce |
| edk.act.cmdb.clear | — | tmp0 | — | — | — | cmdb.cmd.clear, cmdb.refresh_prompt | edk.act.cmdb.home |
| edk.act.cmdb.close.about | — | — | — | — | — | hchar, cmdb.dialog.close | edkey.keyscan.hook.debounce, hchar |
| edk.act.cmdb.close.dialog | — | — | — | — | — | cmdb.dialog.close | edkey.keyscan.hook.debounce |
| edk.act.cmdb.del_char | — | tmp0 | — | — | — | cmdb.cmd.delete, cmdb.refresh_prompt | edkey.keyscan.hook.debounce |
| edk.act.cmdb.lineterm.toggle | — | — | — | — | — | fm.lineterm | edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.next | — | — | — | — | — | fm.browse.fname.next, pane.filebrowser.hilight | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.next.setfile | — | — | — | — | — | cpym2m, cmdb.refresh_prompt, cmdb.cmd.cursor_eol, vdp.cursor.tat | cpym2m |
| edk.act.cmdb.pick.prev | — | — | — | — | — | fm.browse.fname.prev, pane.filebrowser.hilight | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.cmdb.pick.prev.setfile | — | — | — | — | — | cpym2m, cmdb.refresh_prompt, cmdb.cmd.cursor_eol, vdp.cursor.tat | cpym2m |
| edk.act.cmdb.preset | — | — | — | — | — | cmdb.cmd.preset | edkey.keyscan.hook.debounce |
| edk.act.cmdb.proceed | — | — | @cmdb.action.ptr | — | — | pane.cursor.blink, cmdb.cmd.clear, cpu.crash | cpu.crash, edkey.keyscan.hook.debounce |
| edk.act.cmdb.show | 1 | — | — | — | — | rom.farjump | — |
| edk.act.cmdb.updir | — | — | — | — | — | fm.browse.updir, fm.directory, cpym2m | cpym2m, edkey.keyscan.hook.debounce |
| edk.act.fb.clip.save.1 | — | — | — | — | — | — | — |
| edk.act.fb.clip.save.2 | — | — | — | — | — | — | — |
| edk.act.fb.clip.save.3 | — | — | — | — | — | edb.block.clip | — |
| edk.act.fb.load.file | — | — | @parm1, @parm2 | — | — | pane.cmdb.hide, error.display | — |
| edk.act.find.reset | — | — | — | — | — | edb.find.init | edkey.keyscan.hook.debounce |
| edk.fb.char | — | — | tmp0 | — | .pushregs, .popregs | fb.insert.char | — |
| edkey.fb.goto.line | — | — | @parm1, @parm2 | — | — | fb.refresh, fb.calc.pointer, edb.line.getlength2 | edkey.keyscan.hook.debounce |
| edkey.fb.goto.offset | — | — | @parm1, @parm2 | — | — | — | — |
| edkey.fb.goto.row | — | — | @parm1, @parm2 | — | — | — | — |
| edkey.fb.goto.toprow | — | — | @parm1, @parm2 | — | — | — | — |
| error.display | 4 | — | @parm1 | — | .pushregs, .popregs | rom.farjump | xpym2m |
| errpane.init | — | — | — | — | .pushregs | film | film |
| fb.calc.pointer | — | — | @fb.top, @fb.topline, @fb.row, @fb.scrrows, @fb.column, @fb.colsline | — | .pushregs, .popregs | — | — |
| fb.calc.scrrows | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.errors | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.mc | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.calc.scrrows.handle.ruler | — | — | @tv.ruler.visible, @edb.special.file, @tv.error.visible | — | — | — | — |
| fb.colorlines | 4 | — | @parm1, @fb.colorize | — | .pushregs, .popregs | — | xfilv |
| fb.cursor.bot | 4 | — | — | — | — | — | — |
| fb.cursor.bot.refresh | — | — | — | — | — | fb.goto.toprow, fb.cursor.botscr | — |
| fb.cursor.botscr | 4 | — | — | — | .pushregs, .popregs | — | — |
| fb.cursor.botscr.cursor | — | — | — | — | — | — | — |
| fb.cursor.botscr.eof | — | — | — | — | — | fb.calc.pointer, edb.line.getlength2 | — |
| fb.cursor.down | 4 | — | — | — | .pushregs, .popregs | — | down, xsetx |
| fb.cursor.down.move | — | — | — | — | — | fb.refresh | — |
| fb.cursor.home | 4 | — | — | — | .pushregs, .popregs | — | — |
| fb.cursor.on | — | — | — | — | — | — | — |
| fb.cursor.top | 4 | — | — | — | — | rom.farjump | — |
| fb.cursor.top.refresh | — | — | — | — | — | fb.goto.toprow | — |
| fb.cursor.topscr | 4 | — | — | — | — | — | — |
| fb.cursor.topscr.refresh | — | — | — | — | — | fb.goto.toprow | — |
| fb.cursor.up | 4 | — | — | — | — | — | — |
| fb.cursor.up.cursor | — | — | — | — | — | fb.refresh | — |
| fb.get.nonblank | 4 | — | — | @outparm1, @outparm2 | .pushregs, .popregs | — | — |
| fb.goto.nextmatch | 4 | — | — | — | .pushregs | rom.farjump | — |
| fb.goto.prevmatch | 4 | — | — | — | .pushregs | — | — |
| fb.goto.toprow | 4 | — | @parm1, @parm2 | — | .pushregs, .popregs | — | — |
| fb.goto.toprow.line | — | — | @parm1, @parm2 | — | — | fb.refresh, fb.calc.pointer, edb.line.getlength2 | — |
| fb.goto.toprow.offset | — | — | @parm1, @parm2 | — | — | — | — |
| fb.hscroll | 4 | — | @parm1 | — | .pushregs, .popregs | — | — |
| fb.init | — | — | — | — | .pushregs, .popregs | fb.calc.scrrows, film | film |
| fb.insert.char | 4 | — | @parm1 | — | .pushregs, .popregs | — | — |
| fb.insert.char.check1 | — | — | @parm1 | — | — | — | — |
| fb.insert.char.check2 | — | — | @parm1 | — | — | edb.line.pack.fb, fb.insert.line, fb.cursor.down | — |
| fb.insert.line | 4 | — | @parm1 | — | .pushregs, .popregs | — | — |
| fb.insert.line.insert | — | — | @parm1 | — | — | fb.calc.pointer, idx.entry.insert | — |
| fb.null2char | — | — | tmp1, tmp2 | — | .pushregs, .popregs | — | cpu.crash |
| fb.null2char.crash | — | — | tmp1, tmp2 | — | — | cpu.crash | cpu.crash |
| fb.null2char.init | — | — | tmp1, tmp2 | — | — | fb.calc.pointer | — |
| fb.refresh | 4 | — | @parm1, @fb.topline | @outparm1 | .pushregs, .popregs | rom.farjump | xfilm |
| fb.refresh.unpack_line | — | — | @parm1, @fb.topline | @outparm1 | — | edb.line.unpack.fb | — |
| fb.replace.char | 4 | — | @parm1 | — | .pushregs, .popregs | — | — |
| fb.restore | 4 | — | @parm1 | — | — | — | — |
| fb.row2line | 1 | — | @fb.topline, @parm1, @fb.scrrows | @outparm1 | .pushregs, .popregs | — | — |
| fb.ruler.init | 4 | — | — | — | .pushregs, .popregs | — | cpym2m, xfilm |
| fb.scan.fname | 4 | — | — | — | .pushregs, .popregs | rom.farjump | cpu.crash, film |
| fb.scan.fname.copy | — | — | — | — | — | film, fb.calc.pointer | film |
| fb.tab.next | 4 | — | — | — | .pushregs, .popregs | — | xsetx |
| fb.tab.prev | 4 | — | — | — | .pushregs, .popregs | — | xsetx |
| fb.vdpdump | 1, 4 | — | @parm1 | — | .pushregs, .popregs | rom.farjump | xpym2v |
| fb.vdpdump.calc | — | — | @parm1 | — | — | xpym2v | xpym2v |
| fg.goto.nextmatch.first | — | — | — | — | — | — | — |
| fg.goto.nextmatch.goto | — | — | — | — | — | fb.goto.toprow, fb.calc.pointer | — |
| fg.goto.prevmatch.goto | — | — | — | — | — | fb.goto.toprow, fb.calc.pointer | — |
| fg.goto.prevmatch.last | — | — | — | — | — | — | — |
| fh.file.delete | — | — | — | @outparm1 | .pushregs, .popregs | — | cpu.crash, file.delete, film, vgetb, xpym2v |
| fh.file.load.bin | — | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | — | cpu.crash, file.load, film, filv, vgetb, xpym2v, xpyv2m |
| fh.file.load.bin.newfile | — | — | — | @outparm1 | — | — | — |
| fh.file.load.ea5 | — | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | hchar, pane.botline.busy.on | cpyv2m, hchar, xpyv2m |
| fh.file.load.ea5.parm | — | — | — | @outparm1 | — | — | — |
| fh.file.read.edb | 2 | — | @fh.line, @fh.workmode | — | .pushregs | — | — |
| fh.file.read.edb.assert1 | — | — | @fh.line, @fh.workmode | — | — | — | — |
| fh.file.read.mem | 2 | — | — | — | .pushregs, .popregs | — | cpu.crash, fh.file.read.mem.error, fh.file.read.mem.record, file.close, file.record.read, film, xfile.open, xpym2v, xpyv2m |
| fh.file.write.edb | 2 | — | — | — | .pushregs | — | — |
| file.vmem | 2 | — | — | — | — | rom.farjump | — |
| fm.browse.fname.next | 2 | — | @cat.shortcut.idx | @outparm1 | .pushregs, .popregs | — | — |
| fm.browse.fname.next.divok | — | — | @cat.shortcut.idx | @outparm1 | — | — | — |
| fm.browse.fname.prev | 2 | — | @cat.shortcut.idx | @outparm1 | .pushregs, .popregs | — | — |
| fm.browse.fname.prev.divok | — | — | @cat.shortcut.idx | @outparm1 | — | — | — |
| fm.browse.fname.prev.page | — | — | @cat.shortcut.idx | @outparm1 | — | pane.filebrowser, fm.browse.fname.set | — |
| fm.browse.fname.set | 2 | — | @tv.devpath, @cat.shortcut.idx | — | .pushregs, .popregs | rom.farjump | film, xpym2m |
| fm.browse.updir | 2 | — | @tv.devpath | @outparm1 | .pushregs, .popregs | — | xfilm |
| fm.browse.updir.loop1 | — | — | @tv.devpath | @outparm1 | — | — | xfilm |
| fm.browse.updir.loop1.cont | — | — | @tv.devpath | @outparm1 | — | xfilm | xfilm |
| fm.clock.off | 5 | — | @parm1 | — | .pushregs, .popregs | rom.farjump | clslot, film, putat |
| fm.clock.on | 5 | — | — | — | .pushregs, .popregs | tv.clock.start, putat, rsslot | putat, rsslot |
| fm.clock.read | 2 | — | — | — | .pushregs, .pushparms | rom.farjump | — |
| fm.clock.read.cb.stopflag | — | — | @fh.callback1 | — | — | — | — |
| fm.delfile | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | — | — |
| fm.delfile.callback1 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | hchar, pane.botline.busy.on, putat | at, hchar, putat, xutst0 |
| fm.delfile.callback1.filename | — | — | — | — | — | at, xutst0 | at, xutst0 |
| fm.delfile.callback2 | — | — | — | — | .pushregs, .popregs | pane.botline.busy.off, putat, rsslot | putat, rsslot |
| fm.delfile.refreshdir | — | — | — | @outparm1 | — | fm.directory, pane.cmdb.hide | — |
| fm.dir.callback1 | — | tmp0,tmp1,tmp2,tmp3,tmp4 | — | — | .pushregs, .popregs | pane.botline.busy.on, putat, at, xutst0 | at, putat, xutst0 |
| fm.dir.callback2 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | — | fm.dir.callback2.exit, putnum, xpym2m |
| fm.dir.callback2.volname | — | — | — | — | — | xpym2m | fm.dir.callback2.exit, xpym2m |
| fm.dir.callback3 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | pane.botline.busy.off, putat, rsslot | putat, rsslot |
| fm.dir.callback4 | — | tmp0,tmp1 | — | — | .pushregs, .popregs | pane.botline.busy.off, putat, rsslot | putat, rsslot |
| fm.dir.callback5 | — | — | — | — | .pushregs, .popregs | pane.botline.busy.off | — |
| fm.directory | 2 | — | — | — | .pushregs, .pushparms, .popparms, .popregs | rom.farjump | film, filv, fm.directory.browser, fm.directory.exit, mknum, trimnum, xfilv, xpym2m |
| fm.insertfile | 2 | — | — | — | .pushregs, .pushparms, .popparms, .popregs | rom.farjump | — |
| fm.lineterm | 3 | — | — | — | .pushregs, .popregs | — | cpu.crash, mknum, trimnum |
| fm.load.cb.memfull | — | — | — | — | — | hchar, cpym2m, pane.errline.show, pane.botline.busy.off | cpym2m, hchar |
| fm.load.ea5.cb.fioerr | — | — | — | — | .pushregs, .popregs | vdp.dump.patterns, tv.set.font, pane.colorscheme.load, fm.newfile, hchar | cpym2m, hchar, putat, putnum, rsslot, xpym2m |
| fm.load.ea5.cb.indicator1 | — | tmp0,tmp1,tmp2,tmp3 | @parm1, @fh.callback1 | — | .pushregs, .popregs | — | at, putat, xutst0 |
| fm.load.ea5.cb.indicator1.filename | — | — | @parm1, @fh.callback1 | — | — | at, xutst0 | at, xutst0 |
| fm.load.ea5.cb.indicator1.loading | — | — | @parm1, @fh.callback1 | — | — | putat | putat |
| fm.load.ea5.cb.indicator2 | — | — | @parm1, @fh.callback1 | — | .pushregs | cpyv2m, pane.botline.busy.off | cpyv2m |
| fm.load.ea5.cb.message | — | — | — | — | — | hchar, at, xutst0, rsslot | at, hchar, rsslot, xutst0 |
| fm.loadfile | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | rom.farjump | scroff, xfilv, xpym2m |
| fm.loadsave.cb.fioerr | — | — | — | — | .pushregs, .popregs | hchar | cpym2m, hchar, putat, putnum, rsslot, xpym2m |
| fm.loadsave.cb.fioerr.load | — | — | — | — | — | cpym2m | cpym2m |
| fm.loadsave.cb.indicator1 | — | tmp0 | @parm1, @fh.callback1 | — | .pushregs, .popregs | — | at, cpu.crash, hchar, putat, xsams.page.get, xsams.page.set, xutst0 |
| fm.loadsave.cb.indicator1.newfile | — | — | @parm1, @fh.callback1 | — | — | — | — |
| fm.loadsave.cb.indicator1.sams | — | — | @parm1, @fh.callback1 | — | — | xsams.page.get, xsams.page.set | xsams.page.get, xsams.page.set |
| fm.loadsave.cb.indicator2 | — | tmp0,tmp1,tmp2,tmp3 | — | — | .pushregs, .popregs | — | putat, putnum |
| fm.loadsave.cb.indicator2.loadsave | — | — | — | — | — | — | — |
| fm.loadsave.cb.indicator2.refresh | — | — | — | — | — | fb.refresh, fb.calc.scrrows, fb.vdpdump | — |
| fm.loadsave.cb.indicator2.topline | — | — | — | — | — | — | — |
| fm.loadsave.cb.indicator3 | — | — | — | — | .pushregs | pane.botline.busy.off, putnum, putat | putat, putnum |
| fm.newfile | 2 | — | — | — | .pushregs, .popregs | rom.farjump | hchar, putat |
| fm.run.ea5 | 2 | — | — | @outparm1 | .pushregs, .pushparms, .popparms, .popregs | — | scroff, xfilv |
| fm.savefile | 2 | — | — | — | .pushregs, .popregs | rom.farjump | xpym2m |
| get_cursorcolor | — | — | tmp1 | @outparm1 | .pushregs, .popregs | edb.block.match, pane.colorscheme.index | — |
| idx.entry.delete | — | — | @parm1, @parm2 | — | .pushregs, .popregs | _idx.samspage.get | — |
| idx.entry.delete.lastline | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.delete.reorg | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.insert | — | — | @parm1, @parm2 | — | .pushregs, .popregs | — | — |
| idx.entry.insert.reorg | — | — | @parm1, @parm2 | — | — | — | — |
| idx.entry.insert.reorg.complex | — | — | @parm1, @parm2 | — | — | _idx.sams.mapcolumn.on, _idx.entry.insert.reorg, _idx.sams.mapcolumn.off | — |
| idx.entry.update | — | — | @parm1, @parm2, @parm3 | @outparm1 | .pushregs, .popregs | — | — |
| idx.entry.update.save | — | — | @parm1, @parm2, @parm3 | @outparm1 | — | _idx.samspage.get | — |
| idx.init | — | tmp0,tmp1,tmp2 | — | — | .pushregs, .popregs | _idx.sams.mapcolumn.on, film, _idx.sams.mapcolumn.off | film |
| idx.pointer.get | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | _idx.samspage.get | — |
| idx.pointer.get.parm | — | — | @parm1 | @outparm1, @outparm2 | — | — | — |
| isr | — | r7, r10 | — | — | — | — | — |
| isr.scan.crunchbuf | — | — | — | — | — | — | — |
| isr.scan.end | — | — | — | — | — | — | — |
| isr.scan.old | — | — | — | — | — | — | — |
| isr.showid | — | — | — | — | — | — | — |
| main.continue | — | — | — | — | .ifeq, .endif | mute, scroff, filv, film, f18unl, putvr, vdp.dump.patterns, tv.set.font, mem.sams.setup.stevie, tv.init, tv.reset, dialog, rom.dialogs2ram, pane.colorscheme.load, at, mkslot, clslot, mkhook | at, clslot, f18unl, film, filv, mkhook, mkslot, mute, putvr, scroff, tmgr |
| main.stevie | — | — | — | — | — | putstr | putstr |
| mem.run.ea5 | 7 | — | — | — | — | rom.farjump | 6040, cpym2v, f18rst, filv, ldfnt, scroff, scron, vidtab |
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
| mem.sams.setup.stevie | 1 | — | — | — | .endif, .ifgt, .ifne | rom.farjump | sams.layout.copy |
| pane.botline | 4 | — | — | — | .pushregs, .popregs | — | at, film, hchar, mknum, putat, putnum, trimnum, xutst0 |
| pane.botline.busy.off | 4 | — | — | — | — | rom.farjump | hchar |
| pane.botline.busy.on | 4 | — | — | — | — | rom.farjump | hchar |
| pane.botline.keycolor | 4 | — | @cmdb.keycolors | @outparm1, @outparm5 | .pushregs, .popregs | rom.farjump | cpym2v, xfilm |
| pane.botline.mc | — | — | — | — | — | vdp.colors.line, at, tv.pad.string, xutst0 | at, xutst0 |
| pane.clock.time | 5 | — | @tv.clock.state | — | .pushregs, .popregs | rom.farjump | cpym2v, xpym2v |
| pane.cmdb.draw | 3 | — | @cmdb.panhead, @cmdb.paninfo, @cmdb.panhint, @cmdb.pankeys | @outparm1 | .pushregs, .ifge, .endif, .else, .popregs | rom.farjump | at, cpym2m, film, hchar, putat, vchar, xfilm, xutst0 |
| pane.cmdb.hide | 4 | — | — | — | .pushregs, .ifge, .endif, .popregs | rom.farjump | hchar |
| pane.cmdb.show | 4 | — | — | — | .pushregs, .popregs | rom.farjump | — |
| pane.cmdb.show.rest | — | — | — | — | — | vdp.cursor.tat.fb, cmdb.cmd.cursor_eol, pane.errline.hide | — |
| pane.cmdb.statlines | — | — | @tv.devpath, @tv.sams.maxpage, @tv.sams.hipage | — | .pushregs, .popregs | film, pane.cursor.hide, hchar, cpym2m, mknum, trimnum | cpym2m, film, hchar, mknum, trimnum |
| pane.colorscheme.address | — | — | @tv.colorscheme | @outparm1 | .pushregs, .popregs | — | — |
| pane.colorscheme.botline | 4 | — | @parm1 | — | .pushregs, .popregs | rom.farjump | — |
| pane.colorscheme.cycle | 4 | — | — | — | .pushregs | — | — |
| pane.colorscheme.index | 4 | tmp0,tmp1 | @tv.colorscheme | @outparm1 | .pushregs, .popregs | rom.farjump | — |
| pane.colorscheme.load | 4 | — | @tv.colorscheme, @parm1, @parm2, @parm3 | @outparm1 | .pushregs | rom.farjump | putvrx, scroff |
| pane.colorscheme.switch | — | — | — | — | — | pane.colorscheme.load, putnum, putat, rsslot | putat, putnum, rsslot |
| pane.cursor.blink | 1 | — | — | — | — | rom.farjump | mkslot |
| pane.cursor.hide | 1 | — | — | — | — | rom.farjump | clslot |
| pane.errline.drawcolor | 4 | tmp0,tmp1 | @tv.error.rows, @parm1 | — | .pushregs, .popregs | — | — |
| pane.errline.hide | 1, 4 | — | — | — | .pushregs, .popregs | rom.farjump | — |
| pane.errline.hide.fbcolor | — | — | — | — | — | pane.errline.drawcolor, fb.calc.scrrows | — |
| pane.errline.show | 1, 4 | tmp0 | @tv.error.msg | — | .pushregs, .popregs | rom.farjump | at, xutst0 |
| pane.filebrowser | 4 | — | @cat.fpicker.idx | — | .pushregs, .popregs | rom.farjump | at, cpym2m, filv, hchar, mknum, pane.filebrowser.exit, putat, putlst, trimnum, vchar, xfilv |
| pane.filebrowser.colbar | 4 | tmp0,tmp1,tmp2 | @wyx, tmp0 | — | .pushregs, .popregs | rom.farjump | putstr, xfilv, xvputb, yx2pnt |
| pane.filebrowser.colbar.remove | 4 | — | @cat.barpos | — | .pushregs, .popregs | rom.farjump | putstr |
| pane.filebrowser.hilight | 4 | — | @cat.shortcut.idx | — | .pushregs, .popregs | rom.farjump | cpu.crash, putstr |
| pane.filebrowser.hilight.divok | — | — | @cat.shortcut.idx | — | — | — | — |
| pane.show_hintx | 3 | — | @parm1, @parm2, @parm3 | — | .pushregs, .popregs | — | cpu.crash, xfilv, xutst0, yx2pnt |
| pane.topline | 4 | — | — | — | .pushregs, .popregs | — | at, film, hchar, mknum, putat, putnum, trimnum, xutst0 |
| pane.topline.file | — | — | — | — | — | at | at |
| pane.topline.oneshot.clearmsg | — | — | — | — | — | hchar | hchar |
| pane.vdpdump | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | .pushregs, .popregs | — | cpym2v, putat |
| pane.vdpdump.alpha_lock | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | — | putat | putat |
| pane.vdpdump.alpha_lock.down | — | — | @fb.dirty, @fb.status.dirty, @fb.colorize, @cmdb.dirty, @tv.ruler.visible | — | — | putat | putat |
| rom.dialogs2ram | e | — | — | — | .pushregs, .popregs | rom.farjump | cpym2m |
| rom.farjump | — | — | — | — | — | — | — |
| tib.run | 7 | — | @tib.session | — | .pushregs | sams.layout.copy, scroff, mem.sams.set.external, cpyv2m, f18rst, vidtab, cpu.crash | cpu.crash, cpu.scrpad.backup, cpu.scrpad.restore, cpym2m, cpym2v, cpyv2m, f18rst, filv, ldfnt, sams.layout.copy, scroff, tib.run.resume.basic1, tib.run.resume.basic2, vidtab |
| tib.run.return | 7 | — | — | — | — | — | cpu.crash, cpym2m |
| tib.run.return.1 | — | — | — | — | — | cpym2m | cpym2m |
| tib.uncrunch | 7 | — | @parm1 | — | .pushregs, .popregs | pane.colorscheme.botline, hchar, putat, tib.uncrunch.prepare, tib.uncrunch.prg, xsams.page.set, cmdb.dialog.close, fb.refresh, fb.calc.pointer, edb.line.getlength2 | hchar, putat, xsams.page.set |
| tib.uncrunch.line.pack | — | — | @fb.uncrunch, @parm1 | — | .pushregs, .popregs | edb.hipage.alloc, idx.entry.update | xpym2m, xsams.page.set |
| tib.uncrunch.prepare | — | — | @parm1 | — | .pushregs, .popregs | cpu.crash | cpu.crash, sams.page.set, xpym2m |
| tib.uncrunch.prg | — | — | @parm1 | — | .pushregs | fb.row2line | at, mknum, tib.uncrunch.prg.exit, trimnum |
| tib.uncrunch.token | — | — | @parm1, @parm2 | @outparm1, @outparm2 | .pushregs, .popregs | — | mknum, tib.uncrunch.token.setlen, trimnum, xpym2m |
| tibasic.am.off | — | — | — | — | — | mem.sams.dialogs.off | — |
| tibasic.am.toggle | 3 | — | — | — | .pushregs | mem.sams.dialogs.on | — |
| tv.autoinsert.toggle | 3 | — | @tv.autoinsert, @edb.locked | — | .pushregs | hchar, putat | hchar, putat |
| tv.bcd.pack | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | — | — |
| tv.clock.start | 1 | — | — | — | .pushregs, .popregs | film, mkslot | film, mkslot |
| tv.clock.toggle | 3 | — | @tv.clock.state | — | .pushregs | hchar, tv.clock.start, putat, clslot | clslot, hchar, putat |
| tv.flash.screen | 5 | — | — | — | — | pane.colorscheme.load | — |
| tv.init | — | — | — | — | .pushregs, .popregs | cpym2m | cpym2m |
| tv.linelen.oneshot | — | — | @tv.show.linelen | — | — | rsslot | rsslot |
| tv.linelen.toggle | 3 | — | @tv.show.linelen | — | .pushregs | hchar, putat | hchar, putat |
| tv.pad.string | — | — | @parm1, @parm2, @parm3, @parm4 | @outparm1 | .pushregs, .popregs | xpym2m | cpu.crash, xpym2m |
| tv.quit | — | — | — | — | — | f18rst, rom.farjump | f18rst |
| tv.reset | 7 | — | — | — | — | cmdb.init, edb.init, edb.find.init, idx.init, fb.init, errpane.init, hchar | hchar |
| tv.set.font | 6 | — | @parm1 | — | .pushregs, .popregs | cpu.crash | cpu.crash |
| tv.set.font.ptr | — | — | @parm1 | — | — | — | — |
| tv.set.font.vdpdump | — | — | @parm1 | — | — | vdp.dump.font | — |
| tv.uint16.pack | — | — | @parm1 | @outparm1, @outparm2 | .pushregs, .popregs | xstring.getlenc | xstring.getlenc |
| tv.uint16.unpack | — | — | @parm1 | — | .pushregs, .popregs | mknum, trimnum | mknum, trimnum |
| txt.clockon | — | — | — | — | — | — | — |
| vdp.colors.line | 6 | — | @parm1, @parm2 | — | .pushregs, .popregs | xfilv | xfilv |
| vdp.cursor.tat | 6 | — | — | — | .pushregs, .popregs | cpu.crash | cpu.crash |
| vdp.cursor.tat.cmdb | — | — | @cmdb.cursor, @cmdb.prevcursor | — | .pushregs, .popregs | vdp.cursor.tat.cmdb.hide | xvputb, yx2pnt |
| vdp.cursor.tat.cmdb.hide | 6 | — | @cmdb.cursor | — | .pushregs, .popregs | yx2pnt, xvputb | xvputb, yx2pnt |
| vdp.cursor.tat.cmdb.show | — | — | @cmdb.cursor, @cmdb.prevcursor | — | — | yx2pnt, xvputb | xvputb, yx2pnt |
| vdp.cursor.tat.cur.cmdb | — | — | — | — | — | vdp.cursor.tat.cmdb | — |
| vdp.cursor.tat.cur.fb | — | — | — | — | — | vdp.cursor.tat.fb | — |
| vdp.cursor.tat.fb | 6 | tmp0,tmp1 | @wyx, @fb.prevcursor | @outparm1 | .pushregs, .popregs | — | xvputb, yx2pnt |
| vdp.cursor.tat.fb.hide | — | — | @wyx, @fb.prevcursor | @outparm1 | — | yx2pnt, get_cursorcolor | xvputb, yx2pnt |
| vdp.dump.font | 6 | — | @tv.font.ptr | — | .pushregs, .popregs | xpym2v | xpym2v |
| vdp.dump.patterns | 6 | — | — | — | — | cpym2v | cpym2v |
| xrom.farjump | — | — | — | — | .ifeq, .endif | — | — |

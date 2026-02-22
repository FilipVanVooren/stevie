* FILE......: data.keymap.actions.asm
* Purpose...: Keyboard actions

*---------------------------------------------------------------
* Action keys mapping table: Editor
*---------------------------------------------------------------
keymap_actions.editor:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        byte  key.enter, pane.focus.fb
        data  edkey.action.enter

        byte  key.fctn.s, pane.focus.fb
        data  edkey.action.left

        byte  key.fctn.d, pane.focus.fb
        data  edkey.action.right

        byte  key.fctn.e, pane.focus.fb
        data  edkey.action.up

        byte  key.fctn.x, pane.focus.fb
        data  edkey.action.down

        byte  key.fctn.h, pane.focus.fb
        data  edkey.action.home

        byte  key.fctn.j, pane.focus.fb
        data  edkey.action.pword

        byte  key.fctn.k, pane.focus.fb
        data  edkey.action.nword

        byte  key.fctn.l, pane.focus.fb
        data  edkey.action.end

        byte  key.fctn.4, pane.focus.fb
        data  edkey.action.npage

        byte  key.fctn.5, pane.focus.fb
        data  edkey.action.scroll.right

        byte  key.fctn.6, pane.focus.fb
        data  edkey.action.ppage

        byte  key.ctrl.7, pane.focus.fb
        data  edkey.action.fb.tab.prev

        byte  key.fctn.7, pane.focus.fb
        data  edkey.action.fb.tab.next

        byte  key.ctrl.e, pane.focus.fb
        data  edkey.action.ppage

        byte  key.ctrl.g, pane.focus.fb
        data  dialog.goto

        byte  key.ctrl.x, pane.focus.fb
        data  edkey.action.npage

        byte  key.fctn.v, pane.focus.fb
        data  edkey.action.topscr

        byte  key.fctn.b, pane.focus.fb
        data  edkey.action.botscr

        byte  key.ctrl.v, pane.focus.fb
        data  edkey.action.top

        byte  key.ctrl.b, pane.focus.fb
        data  edkey.action.bot

        byte  key.ctrl.comma, pane.focus.fb
        data  edkey.action.goto.pmatch

        byte  key.ctrl.dot, pane.focus.fb
        data  edkey.action.goto.nmatch
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        byte  key.fctn.1, pane.focus.fb
        data  edkey.action.del_char

        byte  key.fctn.3, pane.focus.fb
        data  edkey.action.del_line

        byte  key.ctrl.l, pane.focus.fb
        data  edkey.action.del_eol
        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        byte  key.fctn.2, pane.focus.fb
        data  edkey.action.ins_char.ws

        byte  key.fctn.dot, pane.focus.fb
        data  edkey.action.ins_onoff

        byte  key.fctn.8, pane.focus.fb
        data  edkey.action.ins_line
        ;-------------------------------------------------------
        ; Block marking/modifier
        ;-------------------------------------------------------
        byte  key.ctrl.space, pane.focus.fb
        data  edkey.action.block.mark

        byte  key.ctrl.c, pane.focus.fb
        data  edkey.action.copyblock_or_clipboard

        byte  key.ctrl.d, pane.focus.fb
        data  edkey.action.block.delete

        byte  key.ctrl.m, pane.focus.fb
        data  edkey.action.block.move

        byte  key.ctrl.g, pane.focus.fb
        data  edkey.action.block.goto.m1
        ;-------------------------------------------------------
        ; Clipboards
        ;-------------------------------------------------------
        byte  key.ctrl.1, pane.focus.fb
        data  edkey.action.fb.clip.save.1

        byte  key.ctrl.2, pane.focus.fb
        data  edkey.action.fb.clip.save.2

        byte  key.ctrl.3, pane.focus.fb
        data  edkey.action.fb.clip.save.3
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        byte  key.fctn.plus, pane.focus.fb
        data  edkey.action.quit

        byte  key.ctrl.5, pane.focus.fb
        data  edkey.action.scroll.left

        byte  key.ctrl.q, pane.focus.fb
        data  edkey.action.quit

        byte  key.ctrl.z, pane.focus.fb
        data  pane.colorscheme.cycle

        byte  key.fctn.0, pane.focus.fb
        data  tibasic

        byte  key.ctrl.0, pane.focus.fb
        data  dialog.basic
        
        byte  key.ctrl.4, pane.focus.fb
        data  edkey.action.find.reset

        byte  key.ctrl.slash, pane.focus.fb
        data  dialog.shortcuts
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        byte  key.ctrl.a, pane.focus.fb
        data  dialog.append

        byte  key.ctrl.h, pane.focus.fb
        data  dialog.help

        byte  key.ctrl.f, pane.focus.fb
        data  dialog.find

        byte  key.ctrl.i, pane.focus.fb
        data  dialog.insert

        byte  key.ctrl.l, pane.focus.fb
        data  edkey.action.cmdb.lock

        byte  key.ctrl.s, pane.focus.fb
        data  dialog.save

        byte  key.ctrl.o, pane.focus.fb
        data  dialog.open

        byte  key.ctrl.u, pane.focus.fb
        data  edkey.action.cmdb.unlock

        byte  key.ctrl.p, pane.focus.fb
        data  dialog.print

        byte  key.ctrl.r, pane.focus.fb
        data  dialog.run

        ;
        ; FCTN-9 has multiple purposes, if block mode is on
        ; reset block, otherwise show dialog "Main Menu".
        ;
        byte  key.fctn.9, pane.focus.fb
        data  dialog.main
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL


*---------------------------------------------------------------
* Action keys mapping table: Command Buffer (CMDB)
*---------------------------------------------------------------
keymap_actions.cmdb:
        ;-------------------------------------------------------
        ; Dialog: Main Menu
        ;-------------------------------------------------------
        byte  key.uc.f, id.dialog.main
        data  dialog.file

        byte  key.uc.b, id.dialog.main
        data  dialog.basic

        byte  key.uc.c, id.dialog.main
        data  dialog.cartridge

        byte  key.uc.o, id.dialog.main
        data  dialog.config

        byte  key.uc.s, id.dialog.main
        data  dialog.shortcuts

        byte  key.uc.h, id.dialog.main
        data  dialog.help

        byte  key.uc.q, id.dialog.main
        data  edkey.action.quit

        byte  key.uc.l, id.dialog.main
        data  edkey.action.cmdb.lock

        byte  key.uc.u, id.dialog.main
        data  edkey.action.cmdb.unlock

        byte  key.fctn.9, id.dialog.main
        data  edkey.action.cmdb.close.dialog
        ;-------------------------------------------------------
        ; Dialog: File
        ;-------------------------------------------------------
        byte  key.uc.n, id.dialog.file
        data  edkey.action.cmdb.file.new

        byte  key.uc.o, id.dialog.file
        data  dialog.open

        byte  key.uc.s, id.dialog.file
        data  dialog.save

        byte  key.uc.i, id.dialog.file
        data  dialog.insert

        byte  key.uc.a, id.dialog.file
        data  dialog.append

        byte  key.uc.d, id.dialog.file
        data  dialog.delete

        byte  key.uc.c, id.dialog.file
        data  dialog.cat

        byte  key.uc.p, id.dialog.file
        data  dialog.print

        byte  key.uc.r, id.dialog.file
        data  dialog.run
        ;-------------------------------------------------------
        ; Dialog: Open file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.open
        data  edkey.action.cmdb.load

        byte  key.fctn.e, id.dialog.open
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.open
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.open
        data  edkey.action.cmdb.updir

        byte  key.ctrl.r, id.dialog.open
        data  dialog.run        
        ;-------------------------------------------------------
        ; Dialog: Insert file at line ...
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.insert
        data  edkey.action.cmdb.insert

        byte  key.fctn.e, id.dialog.insert
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.insert
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.insert
        data  edkey.action.cmdb.updir        
        ;-------------------------------------------------------
        ; Dialog: Append file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.append
        data  edkey.action.cmdb.append

        byte  key.fctn.e, id.dialog.append
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.append
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.append
        data  edkey.action.cmdb.updir                
        ;-------------------------------------------------------
        ; Dialog: Run program image (EA5)
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.run
        data  edkey.action.cmdb.file.run

        byte  key.fctn.e, id.dialog.run
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.run
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.run
        data  edkey.action.cmdb.updir 

        byte  key.ctrl.o, id.dialog.run
        data  dialog.open                        
        ;-------------------------------------------------------
        ; Dialog: Copy clipboard to line ...
        ;-------------------------------------------------------
        byte  key.fctn.7, id.dialog.clipboard
        data  dialog.clipdev

        byte  key.num.1, id.dialog.clipboard
        data  edkey.action.cmdb.clip.1

        byte  key.num.2, id.dialog.clipboard
        data  edkey.action.cmdb.clip.2

        byte  key.num.3, id.dialog.clipboard
        data  edkey.action.cmdb.clip.3
        ;-------------------------------------------------------
        ; Dialog: Catalog drive/directory
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.cat
        data  edkey.action.cmdb.load

        byte  key.fctn.e, id.dialog.cat
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.cat
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.cat
        data  edkey.action.cmdb.updir

        byte  key.enter, id.dialog.cat        
        data  edkey.action.cmdb.file.directory.device 
        ;-------------------------------------------------------
        ; Dialog: Options
        ;-------------------------------------------------------
        byte  key.uc.a, id.dialog.opt
        data  edkey.action.cmdb.autoinsert

        byte  key.uc.c, id.dialog.opt
        data  dialog.clipdev

        byte  key.uc.o, id.dialog.opt
        data  edkey.action.cmdb.clock

        byte  key.uc.f, id.dialog.opt
        data  dialog.font

        byte  key.uc.l, id.dialog.opt
        data  edkey.action.cmdb.linelen
        ;-------------------------------------------------------
        ; Dialog: Configure clipboard
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.opt.clip
        data  edkey.action.cmdb.cfg.clip
        ;-------------------------------------------------------
        ; Dialog: Configure font
        ;-------------------------------------------------------
        byte  key.num.1, id.dialog.font
        data  edkey.action.cmdb.font1

        byte  key.num.2, id.dialog.font
        data  edkey.action.cmdb.font2
        ;-------------------------------------------------------
        ; Dialog: Save file
        ;-------------------------------------------------------
        byte  key.fctn.e, id.dialog.save
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.save
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.save
        data  edkey.action.cmdb.updir 

        byte  key.enter, id.dialog.save
        data  edkey.action.cmdb.save

        byte  key.fctn.6, id.dialog.save
        data  edkey.action.cmdb.lineterm.toggle
        ;-------------------------------------------------------
        ; Dialog: Save block to file
        ;-------------------------------------------------------
        byte  key.fctn.e, id.dialog.saveblock
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.saveblock
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.saveblock
        data  edkey.action.cmdb.updir 

        byte  key.enter, id.dialog.saveblock
        data  edkey.action.cmdb.save

        byte  key.fctn.6, id.dialog.saveblock
        data  edkey.action.cmdb.lineterm.toggle        
        ;-------------------------------------------------------
        ; Dialog: Print file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.print
        data  edkey.action.cmdb.print

        byte  key.enter, id.dialog.printblock
        data  edkey.action.cmdb.print

        byte  key.fctn.6, id.dialog.print
        data  edkey.action.cmdb.lineterm.toggle

        byte  key.fctn.6, id.dialog.printblock
        data  edkey.action.cmdb.lineterm.toggle             
        ;-------------------------------------------------------
        ; Dialog: Delete file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.delete
        data  edkey.action.cmdb.load

        byte  key.fctn.e, id.dialog.delete
        data  edkey.action.cmdb.pick.prev

        byte  key.fctn.x, id.dialog.delete
        data  edkey.action.cmdb.pick.next

        byte  key.space, id.dialog.delete
        data  edkey.action.cmdb.updir
        ;-------------------------------------------------------
        ; Dialog: Unsaved changes
        ;-------------------------------------------------------
        byte  key.fctn.6, id.dialog.unsaved
        data  edkey.action.cmdb.proceed

        byte  key.space, id.dialog.unsaved
        data  edkey.action.cmdb.proceed

        byte  key.enter, id.dialog.unsaved
        data  dialog.save
        ;-------------------------------------------------------
        ; Dialog: Cartridge Type
        ;-------------------------------------------------------
        byte  key.uc.f, id.dialog.cart.type
        data  dialog.cart.fg99

        ; byte  key.uc.s, id.dialog.cart.type
        ; data  strg.module
        ;-------------------------------------------------------
        ; Dialog: FinalGROM 99
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.cart.fg99
        data  cart.fg99.mgr
        ;-------------------------------------------------------
        ; Dialog: Basic
        ;-------------------------------------------------------
        byte  key.num.1, id.dialog.basic
        data  tibasic1

        byte  key.num.2, id.dialog.basic
        data  tibasic2

        byte  key.num.3, id.dialog.basic
        data  tibasic3

        byte  key.fctn.5, id.dialog.basic
        data  edkey.action.cmdb.am.toggle

        byte  key.space, id.dialog.basic
        data  tibasic.uncrunch
        ;-------------------------------------------------------
        ; Dialog: Run program image (EA5)
        ;-------------------------------------------------------        
        byte  key.enter, id.dialog.run
        data  edkey.action.cmdb.file.run
        ;-------------------------------------------------------
        ; Dialog: Shortcuts
        ;-------------------------------------------------------
        byte  key.uc.c, id.dialog.shortcuts
        data  pane.colorscheme.cycle

        byte  key.uc.r, id.dialog.shortcuts
        data  edkey.action.toggle.ruler

        byte  key.num.1, id.dialog.shortcuts
        data  edkey.action.block.m1

        byte  key.num.2, id.dialog.shortcuts
        data  edkey.action.block.m2

        byte  key.uc.f, id.dialog.shortcuts
        data  dialog.find

        byte  key.uc.g, id.dialog.shortcuts
        data  dialog.goto
        ;-------------------------------------------------------
        ; Dialog: Goto
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.goto
        data  edkey.action.cmdb.goto
        ;-------------------------------------------------------
        ; Dialog: find
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.find
        data  edkey.action.cmdb.find.search
        ;-------------------------------------------------------
        ; Dialog: Help
        ;-------------------------------------------------------
        byte  key.space, id.dialog.help
        data  dialog.help.next

        byte  key.fctn.9, id.dialog.help
        data  edkey.action.cmdb.close.about

        byte  key.enter, id.dialog.help
        data  edkey.action.cmdb.close.about
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        byte  key.fctn.s, pane.focus.cmdb
        data  edkey.action.cmdb.left

        byte  key.fctn.d, pane.focus.cmdb
        data  edkey.action.cmdb.right

        byte  key.fctn.h, pane.focus.cmdb
        data  edkey.action.cmdb.home

        byte  key.fctn.l, pane.focus.cmdb
        data  edkey.action.cmdb.end
        ;-------------------------------------------------------
        ; Modifier keys
        ;-------------------------------------------------------
        byte  key.fctn.3, pane.focus.cmdb
        data  edkey.action.cmdb.clear
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        byte  key.fctn.9, pane.focus.cmdb
        data  dialog.main

        byte  key.fctn.plus, pane.focus.cmdb
        data  edkey.action.quit

        byte  key.ctrl.0, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.tipi

        byte  key.ctrl.1, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.1

        byte  key.ctrl.2, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.2

        byte  key.ctrl.3, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.3

        byte  key.ctrl.4, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.4

        byte  key.ctrl.5, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.5

        byte  key.ctrl.6, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.6

        byte  key.ctrl.7, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.7

        byte  key.ctrl.8, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.8

        byte  key.ctrl.9, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.9

        byte  key.ctrl.a, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.scs1        

        byte  key.ctrl.b, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.scs2

        byte  key.ctrl.c, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.scs3

        byte  key.ctrl.i, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.ide1        

        byte  key.ctrl.f, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.ide2

        byte  key.ctrl.g, pane.focus.cmdb
        data  edkey.action.cmdb.file.directory.ide3

        byte  key.ctrl.s, pane.focus.cmdb
        data  edkey.action.filebrowser.prevcol

        byte  key.ctrl.d, pane.focus.cmdb
        data  edkey.action.filebrowser.nextcol

        byte  key.ctrl.e, pane.focus.cmdb
        data  edkey.action.filebrowser.prevpage

        byte  key.ctrl.x, pane.focus.cmdb
        data  edkey.action.filebrowser.nextpage

        byte  key.ctrl.z, pane.focus.cmdb
        data  pane.colorscheme.cycle   
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL

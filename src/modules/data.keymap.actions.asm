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

        byte  key.fctn.6, pane.focus.fb
        data  edkey.action.ppage

        byte  key.fctn.4, pane.focus.fb
        data  edkey.action.npage

        byte  key.fctn.5, pane.focus.fb
        data  edkey.action.scroll.right

        byte  key.ctrl.e, pane.focus.fb
        data  edkey.action.ppage

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

        byte  key.fctn.7, pane.focus.fb
        data  edkey.action.fb.tab.next

        byte  key.ctrl.t, pane.focus.fb
        data  edkey.action.fb.tab.next

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

        byte  key.ctrl.5, pane.focus.fb
        data  edkey.action.scroll.left
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        byte  key.fctn.plus, pane.focus.fb
        data  edkey.action.quit

        byte  key.ctrl.q, pane.focus.fb
        data  edkey.action.quit

        byte  key.ctrl.r, pane.focus.fb
        data  edkey.action.toggle.ruler

        byte  key.ctrl.z, pane.focus.fb
        data  pane.action.colorscheme.cycle

        byte  key.ctrl.comma, pane.focus.fb
        data  edkey.action.fb.fname.dec.load

        byte  key.ctrl.dot, pane.focus.fb
        data  edkey.action.fb.fname.inc.load

        byte  key.ctrl.slash, pane.focus.fb
        data  dialog.basic

        byte  key.fctn.0, pane.focus.fb
        data  tibasic
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        byte  key.ctrl.a, pane.focus.fb
        data  dialog.append

        byte  key.ctrl.h, pane.focus.fb
        data  dialog.help

        byte  key.ctrl.f, pane.focus.fb
        data  dialog.file

        byte  key.ctrl.i, pane.focus.fb
        data  dialog.insert

        byte  key.ctrl.s, pane.focus.fb
        data  dialog.save

        byte  key.ctrl.o, pane.focus.fb
        data  dialog.load

        byte  key.ctrl.u, pane.focus.fb
        data  dialog.shortcuts

        byte  key.ctrl.p, pane.focus.fb
        data  dialog.print

        ;
        ; FCTN-9 has multiple purposes, if block mode is on it
        ; resets the block, otherwise show dialog "Main Menu".
        ;
        byte  key.fctn.9, pane.focus.fb
        data  dialog.menu
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
        byte  key.uc.f, id.dialog.menu
        data  dialog.file

        byte  key.uc.c, id.dialog.menu
        data  dialog.cartridge

        byte  key.uc.o, id.dialog.menu
        data  dialog.config

        byte  key.uc.s, id.dialog.menu
        data  dialog.shortcuts

        byte  key.uc.h, id.dialog.menu
        data  dialog.help

        byte  key.uc.q, id.dialog.menu
        data  edkey.action.quit
        ;-------------------------------------------------------
        ; Dialog: File
        ;-------------------------------------------------------
        byte  key.uc.n, id.dialog.file
        data  edkey.action.cmdb.file.new

        byte  key.uc.s, id.dialog.file
        data  dialog.save

        byte  key.uc.o, id.dialog.file
        data  dialog.load

        byte  key.uc.i, id.dialog.file
        data  dialog.insert

        byte  key.uc.a, id.dialog.file
        data  dialog.append

        byte  key.uc.p, id.dialog.file
        data  dialog.print
        ;-------------------------------------------------------
        ; Dialog: Open file
        ;-------------------------------------------------------
        byte  key.fctn.5, id.dialog.load
        data  edkey.action.cmdb.fastmode.toggle

        byte  key.enter, id.dialog.load
        data  edkey.action.cmdb.load
        ;-------------------------------------------------------
        ; Dialog: Insert file at line ...
        ;-------------------------------------------------------
        byte  key.fctn.5, id.dialog.insert
        data  edkey.action.cmdb.fastmode.toggle

        byte  key.enter, id.dialog.insert
        data  edkey.action.cmdb.insert
        ;-------------------------------------------------------
        ; Dialog: Append file
        ;-------------------------------------------------------
        byte  key.fctn.5, id.dialog.append
        data  edkey.action.cmdb.fastmode.toggle

        byte  key.enter, id.dialog.append
        data  edkey.action.cmdb.append
        ;-------------------------------------------------------
        ; Dialog: Copy clipboard to line ...
        ;-------------------------------------------------------
        byte  key.fctn.5, id.dialog.clipboard
        data  edkey.action.cmdb.fastmode.toggle

        byte  key.fctn.7, id.dialog.clipboard
        data  dialog.clipdev

        byte  key.num.1, id.dialog.clipboard
        data  edkey.action.cmdb.clip.1

        byte  key.num.2, id.dialog.clipboard
        data  edkey.action.cmdb.clip.2

        byte  key.num.3, id.dialog.clipboard
        data  edkey.action.cmdb.clip.3

        byte  key.num.4, id.dialog.clipboard
        data  edkey.action.cmdb.clip.4

        byte  key.num.5, id.dialog.clipboard
        data  edkey.action.cmdb.clip.5
        ;-------------------------------------------------------
        ; Dialog: Configure clipboard
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.clipdev
        data  edkey.action.cmdb.clipdev.configure
        ;-------------------------------------------------------
        ; Dialog: Configure
        ;-------------------------------------------------------
        byte  key.uc.c, id.dialog.config
        data  dialog.clipdev
        ;-------------------------------------------------------
        ; Dialog: Save file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.save
        data  edkey.action.cmdb.save

        byte  key.enter, id.dialog.saveblock
        data  edkey.action.cmdb.save
        ;-------------------------------------------------------
        ; Dialog: Print file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.print
        data  edkey.action.cmdb.print

        byte  key.enter, id.dialog.printblock
        data  edkey.action.cmdb.print
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
        ; Dialog: Cartridge
        ;-------------------------------------------------------
        byte  key.uc.b, id.dialog.cartridge
        data  dialog.basic
        ;-------------------------------------------------------
        ; Dialog: Basic
        ;-------------------------------------------------------
        byte  key.num.1, id.dialog.basic
        data  tibasic1

        byte  key.num.2, id.dialog.basic
        data  tibasic2

        byte  key.num.3, id.dialog.basic
        data  tibasic3

        byte  key.num.4, id.dialog.basic
        data  tibasic4

        byte  key.num.5, id.dialog.basic
        data  tibasic5

        byte  key.fctn.5, id.dialog.basic
        data  edkey.action.cmdb.am.toggle

        byte  key.space, id.dialog.basic
        data  tibasic.uncrunch
        ;-------------------------------------------------------
        ; Dialog: Shortcuts
        ;-------------------------------------------------------
        byte  key.uc.c, id.dialog.shortcuts
        data  pane.action.colorscheme.cycle

        byte  key.uc.r, id.dialog.shortcuts
        data  edkey.action.toggle.ruler

        byte  key.num.1, id.dialog.shortcuts
        data  edkey.action.block.m1

        byte  key.num.2, id.dialog.shortcuts
        data  edkey.action.block.m2
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
        data  edkey.action.cmdb.close.dialog

        byte  key.fctn.plus, pane.focus.cmdb
        data  edkey.action.quit

        byte  key.ctrl.a, pane.focus.cmdb
        data  edkey.action.cmdb.preset

        byte  key.ctrl.b, pane.focus.cmdb
        data  edkey.action.cmdb.preset

        byte  key.ctrl.c, pane.focus.cmdb
        data  edkey.action.cmdb.preset

        byte  key.ctrl.z, pane.focus.cmdb
        data  pane.action.colorscheme.cycle
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL

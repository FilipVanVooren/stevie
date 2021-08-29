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

        byte  key.ctrl.e, pane.focus.fb
        data  edkey.action.ppage

        byte  key.ctrl.x, pane.focus.fb
        data  edkey.action.npage

        byte  key.ctrl.t, pane.focus.fb
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

        byte  key.fctn.4, pane.focus.fb
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

        byte  key.fctn.8, pane.focus.fb
        data  edkey.action.ins_line
        ;-------------------------------------------------------
        ; Block marking/modifier
        ;-------------------------------------------------------
        byte  key.ctrl.v, pane.focus.fb
        data  edkey.action.block.mark

        byte  key.ctrl.c, pane.focus.fb
        data  edkey.action.block.copy

        byte  key.ctrl.d, pane.focus.fb
        data  edkey.action.block.delete

        byte  key.ctrl.m, pane.focus.fb
        data  edkey.action.block.move

        byte  key.ctrl.g, pane.focus.fb
        data  edkey.action.block.goto.m1
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        byte  key.fctn.plus, pane.focus.fb
        data  edkey.action.quit
        
        byte  key.ctrl.q, pane.focus.fb
        data  edkey.action.quit

        byte  key.ctrl.u, pane.focus.fb
        data  edkey.action.toggle.ruler        

        byte  key.ctrl.z, pane.focus.fb
        data  pane.action.colorscheme.cycle

        byte  key.ctrl.comma, pane.focus.fb
        data  edkey.action.fb.fname.dec.load

        byte  key.ctrl.dot, pane.focus.fb
        data  edkey.action.fb.fname.inc.load
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        byte  key.ctrl.h, pane.focus.fb 
        data  edkey.action.about

        byte  key.ctrl.f, pane.focus.fb
        data  dialog.file

        byte  key.ctrl.s, pane.focus.fb
        data  dialog.save

        byte  key.ctrl.o, pane.focus.fb
        data  dialog.load

        ; 
        ; FCTN-9 has multipe purposes, if block mode is on it
        ; resets the block, otherwise show Stevie menu dialog.
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
        ; Dialog: Stevie Menu
        ;-------------------------------------------------------
        byte  key.uc.f, id.dialog.menu
        data  dialog.file

        byte  key.uc.b, id.dialog.menu
        data  run.tibasic
        
        byte  key.uc.h, id.dialog.menu
        data  edkey.action.about

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
        ;-------------------------------------------------------
        ; Dialog: Open DV80 file
        ;-------------------------------------------------------
        byte  key.fctn.5, id.dialog.load
        data  edkey.action.cmdb.fastmode.toggle

        byte  key.enter, id.dialog.load
        data  edkey.action.cmdb.load
        ;-------------------------------------------------------
        ; Dialog: Unsaved changes
        ;-------------------------------------------------------
        byte  key.fctn.6, id.dialog.unsaved
        data  edkey.action.cmdb.proceed

        byte  key.enter, id.dialog.unsaved
        data  dialog.save
        ;-------------------------------------------------------
        ; Dialog: Save DV80 file
        ;-------------------------------------------------------
        byte  key.enter, id.dialog.save
        data  edkey.action.cmdb.save

        byte  key.enter, id.dialog.saveblock
        data  edkey.action.cmdb.save
        ;-------------------------------------------------------
        ; Dialog: Basic
        ;-------------------------------------------------------
        byte  key.uc.b, id.dialog.basic
        data  run.tibasic

        ;-------------------------------------------------------
        ; Dialog: About
        ;-------------------------------------------------------
        byte  key.fctn.9, id.dialog.about
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

        byte  key.ctrl.z, pane.focus.cmdb
        data  pane.action.colorscheme.cycle
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL
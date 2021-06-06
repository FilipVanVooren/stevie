* FILE......: data.keymap.actions.asm
* Purpose...: Keyboard actions

*---------------------------------------------------------------
* Action keys mapping table: Editor 
*---------------------------------------------------------------
keymap_actions.editor:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        data  key.enter, pane.focus.fb, edkey.action.enter
        data  key.fctn.s, pane.focus.fb, edkey.action.left
        data  key.fctn.d, pane.focus.fb, edkey.action.right
        data  key.fctn.e, pane.focus.fb, edkey.action.up
        data  key.fctn.x, pane.focus.fb, edkey.action.down
        data  key.fctn.h, pane.focus.fb, edkey.action.home
        data  key.fctn.j, pane.focus.fb, edkey.action.pword
        data  key.fctn.k, pane.focus.fb, edkey.action.nword
        data  key.fctn.l, pane.focus.fb, edkey.action.end           
        data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
        data  key.ctrl.x, pane.focus.fb, edkey.action.npage
        data  key.ctrl.t, pane.focus.fb, edkey.action.top
        data  key.ctrl.b, pane.focus.fb, edkey.action.bot
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        data  key.fctn.1, pane.focus.fb, edkey.action.del_char
        data  key.fctn.3, pane.focus.fb, edkey.action.del_line        
        data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
        data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
        data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
        data  key.fctn.7, pane.focus.fb, edkey.action.fb.tab.next
        ;-------------------------------------------------------
        ; Block marking/modifier
        ;-------------------------------------------------------
        data  key.ctrl.v, pane.focus.fb, edkey.action.block.mark
        data  key.fctn.9, pane.focus.fb, edkey.action.block.reset
        data  key.ctrl.c, pane.focus.fb, edkey.action.block.copy
        data  key.ctrl.d, pane.focus.fb, edkey.action.block.delete
        data  key.ctrl.m, pane.focus.fb, edkey.action.block.move
        data  key.ctrl.g, pane.focus.fb, edkey.action.block.goto.m1
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, pane.focus.fb, edkey.action.quit
        data  key.ctrl.q, pane.focus.fb, edkey.action.quit
        data  key.ctrl.u, pane.focus.fb, edkey.action.toggle.ruler        
        data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
        data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
        data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.ctrl.h, pane.focus.fb, edkey.action.about        
        data  key.ctrl.f, pane.focus.fb, dialog.file
        data  key.ctrl.s, pane.focus.fb, dialog.save                
        data  key.ctrl.o, pane.focus.fb, dialog.load        
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL




*---------------------------------------------------------------
* Action keys mapping table: Command Buffer (CMDB)
*---------------------------------------------------------------
keymap_actions.cmdb:
        ;-------------------------------------------------------
        ; Dialog: File
        ;-------------------------------------------------------
        data  key.uc.n, id.dialog.file, edkey.action.cmdb.file.new
        data  key.uc.s, id.dialog.file, dialog.save
        data  key.uc.o, id.dialog.file, dialog.load
        ;-------------------------------------------------------
        ; Dialog: Open DV80 file
        ;-------------------------------------------------------
        data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
        data  key.enter, id.dialog.load, edkey.action.cmdb.load
        ;-------------------------------------------------------
        ; Dialog: Unsaved changes
        ;-------------------------------------------------------
        data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
        data  key.enter, id.dialog.unsaved, dialog.save
        ;-------------------------------------------------------
        ; Dialog: Save DV80 file
        ;-------------------------------------------------------
        data  key.enter, id.dialog.save, edkey.action.cmdb.save
        data  key.enter, id.dialog.saveblock, edkey.action.cmdb.save
        ;-------------------------------------------------------
        ; Dialog: About
        ;-------------------------------------------------------
        data  key.fctn.9, id.dialog.about, edkey.action.cmdb.close.about
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------        
        data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
        data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
        data  key.fctn.h, pane.focus.cmdb, edkey.action.cmdb.home
        data  key.fctn.l, pane.focus.cmdb, edkey.action.cmdb.end
        ;-------------------------------------------------------
        ; Modifier keys
        ;-------------------------------------------------------
        data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
        data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
        data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL
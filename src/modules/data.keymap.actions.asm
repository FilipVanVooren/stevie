* FILE......: data.keymap.actions.asm
* Purpose...: Stevie Editor - data segment (keyboard actions)

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
        data  key.ctrl.a, pane.focus.fb, edkey.action.home
        data  key.ctrl.f, pane.focus.fb, edkey.action.end   
        data  key.ctrl.s, pane.focus.fb, edkey.action.pword
        data  key.ctrl.d, pane.focus.fb, edkey.action.nword
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
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, pane.focus.fb, edkey.action.quit
        data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
        data  key.ctrl.1, pane.focus.fb, edkey.action.block.mark.m1
        data  key.ctrl.2, pane.focus.fb, edkey.action.block.mark.m2
        data  key.ctrl.v, pane.focus.fb, edkey.action.block.delete
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
        data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
        data  key.fctn.7, pane.focus.fb, edkey.action.about
        data  key.ctrl.k, pane.focus.fb, dialog.save                
        data  key.ctrl.l, pane.focus.fb, dialog.load
        data  key.ctrl.m, pane.focus.fb, dialog.block
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL




*---------------------------------------------------------------
* Action keys mapping table: Command Buffer (CMDB)
*---------------------------------------------------------------
keymap_actions.cmdb:
        ;-------------------------------------------------------
        ; Dialog specific: File load / save
        ;-------------------------------------------------------
        data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
        ;-------------------------------------------------------
        ; Dialog specific: Unsaved changes
        ;-------------------------------------------------------
        data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
        data  key.enter, id.dialog.unsaved, dialog.save
        ;-------------------------------------------------------
        ; Dialog specific: Block move/copy/delete
        ;-------------------------------------------------------
        data  key.ctrl.e, id.dialog.block, edkey.action.ppage
        data  key.ctrl.x, id.dialog.block, edkey.action.npage
        data  key.ctrl.t, id.dialog.block, edkey.action.top
        data  key.ctrl.b, id.dialog.block, edkey.action.bot
        ;-------------------------------------------------------
        ; Dialog specific: About
        ;-------------------------------------------------------
        data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------        
        data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
        data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
        data  key.ctrl.a, pane.focus.cmdb, edkey.action.cmdb.home
        data  key.ctrl.f, pane.focus.cmdb, edkey.action.cmdb.end
        ;-------------------------------------------------------
        ; Modifier keys
        ;-------------------------------------------------------
        data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
        data  key.enter, pane.focus.cmdb, edkey.action.cmdb.enter
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
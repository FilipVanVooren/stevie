* FILE......: data.keymap.asm
* Purpose...: Stevie Editor - data segment (keyboard actions)

*---------------------------------------------------------------
* Action keys mapping table: Editor 
*---------------------------------------------------------------
keymap_actions.editor:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        data  key.enter, txt.enter, edkey.action.enter
        data  key.fctn.s, txt.fctn.s, edkey.action.left
        data  key.fctn.d, txt.fctn.d, edkey.action.right
        data  key.fctn.e, txt.fctn.e, edkey.action.up
        data  key.fctn.x, txt.fctn.x, edkey.action.down
        data  key.ctrl.a, txt.ctrl.a, edkey.action.home
        data  key.ctrl.f, txt.ctrl.f, edkey.action.end   
        data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
        data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
        data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
        data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
        data  key.ctrl.t, txt.ctrl.t, edkey.action.top
        data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        data  key.fctn.1, txt.fctn.1, edkey.action.del_char
        data  key.fctn.3, txt.fctn.3, edkey.action.del_line        
        data  key.fctn.4, txt.fctn.4, edkey.action.del_eol

        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
        data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
        data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
        data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.ctrl.comma, txt.ctrl.comma, edkey.action.fb.fname.dec.load
        data  key.ctrl.dot, txt.ctrl.dot, edkey.action.fb.fname.inc.load
        data  key.fctn.7, txt.fctn.7, edkey.action.about
        data  key.ctrl.k, txt.ctrl.k, dialog.save                
        data  key.ctrl.l, txt.ctrl.l, dialog.load
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL




*---------------------------------------------------------------
* Action keys mapping table: Command Buffer (CMDB)
*---------------------------------------------------------------
keymap_actions.cmdb:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------        
        data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
        data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
        data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
        data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
        ;-------------------------------------------------------
        ; Modifier keys
        ;-------------------------------------------------------
        data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
        data  key.enter, txt.enter, edkey.action.cmdb.enter
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
        data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
        ;-------------------------------------------------------
        ; File load dialog
        ;-------------------------------------------------------
        data  key.fctn.5, txt.fctn.5, edkey.action.cmdb.fastmode.toggle
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.fctn.6, txt.fctn.6, edkey.action.cmdb.proceed
        data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL
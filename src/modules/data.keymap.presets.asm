* FILE......: data.keymap.presets.asm
* Purpose...: Shortcut presets in dialogs

*---------------------------------------------------------------
* Shorcut presets for dialogs
*-------------|---------------------|---------------------------
cmdb.cmd.preset.data:
        ;-------------------------------------------------------
        ; Dialog "Configure clipboard"
        ;-------------------------------------------------------
        data  id.dialog.opt.clip, key.ctrl.a, def.clip.fname.a
        data  id.dialog.opt.clip, key.ctrl.b, def.clip.fname.b
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                   ; EOL        

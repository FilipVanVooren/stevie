* FILE......: data.keymap.presets.asm
* Purpose...: Shortcut presets in dialogs

*---------------------------------------------------------------
* Shorcut presets for dialogs
*-------------|---------------------|---------------------------
cmdb.cmd.preset.data:
        ;-------------------------------------------------------
        ; Dialog "Configure clipboard device"
        ;-------------------------------------------------------
        data  id.dialog.clipdev,key.ctrl.a,def.clip.fname
        data  id.dialog.clipdev,key.ctrl.b,def.clip.fname.b
        data  id.dialog.clipdev,key.ctrl.c,def.clip.fname.C
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                   ; EOL        

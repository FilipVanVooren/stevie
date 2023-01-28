* FILE......: data.keymap.presets.asm
* Purpose...: Shortcut presets in dialogs

*---------------------------------------------------------------
* Shorcut presets for dialogs
*-------------|---------------------|---------------------------
cmdb.cmd.preset.data:
        ;-------------------------------------------------------
        ; Dialog "Configure clipboard device"
        ;-------------------------------------------------------
        data  id.dialog.cfg.clip,key.ctrl.a,def.clip.fname.a
        data  id.dialog.cfg.clip,key.ctrl.b,def.clip.fname.b
        data  id.dialog.cfg.clip,key.ctrl.c,def.clip.fname.C
        ;------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                   ; EOL        

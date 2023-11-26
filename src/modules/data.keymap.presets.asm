* FILE......: data.keymap.presets.asm
* Purpose...: Shortcut presets in dialogs

*---------------------------------------------------------------
* Shorcut presets for dialogs
*-------------|---------------------|---------------------------
cmdb.cmd.preset.data:
        ;-------------------------------------------------------
        ; Dialog "Configure clipboard"
        ;-------------------------------------------------------
        data  id.dialog.cfg.clip, key.ctrl.a, def.clip.fname.a
        data  id.dialog.cfg.clip, key.ctrl.b, def.clip.fname.b
        data  id.dialog.cfg.clip, key.ctrl.c, def.clip.fname.C
        ;-------------------------------------------------------
        ; Dialog "Configure Master Catalog"
        ;-------------------------------------------------------
        data  id.dialog.cfg.mc, key.ctrl.a, def.mc.fname.a
        data  id.dialog.cfg.mc, key.ctrl.b, def.mc.fname.b
        data  id.dialog.cfg.mc, key.ctrl.c, def.mc.fname.C        
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                   ; EOL        

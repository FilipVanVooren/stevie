* FILE......: rom.vectors.bank3.asm
* Purpose...: Bank 3 vectors for trampoline function
        
*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
vec.1   data  dialog.about          ; Dialog "About"
vec.2   data  dialog.load           ; Dialog "Load DV80 file"
vec.3   data  dialog.save           ; Dialog "Save DV80 file"
vec.4   data  dialog.unsaved        ; Dialog "Unsaved changes"
vec.5   data  dialog.file           ; Dialog "File"
vec.6   data  dialog.menu           ; Dialog "Stevie Menu"
vec.7   data  dialog.basic          ; Dialog "Basic"
vec.8   data  cpu.crash             ; 
vec.9   data  cpu.crash             ; 
vec.10  data  run.tibasic           ; Run TI Basic interpreter
vec.11  data  cpu.crash             ; 
vec.12  data  cpu.crash             ; 
vec.13  data  cpu.crash             ; 
vec.14  data  cpu.crash             ; 
vec.15  data  cpu.crash             ; 
vec.16  data  cpu.crash             ; 
vec.17  data  cpu.crash             ; 
vec.18  data  pane.show_hint        ; Show or hide hint
vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
vec.22  data  pane.cmdb.draw        ; Draw content in command
vec.23  data  cpu.crash             ; 
vec.24  data  cmdb.refresh          ; 
vec.25  data  cmdb.cmd.clear        ; 
vec.26  data  cmdb.cmd.getlength    ; 
vec.27  data  cmdb.cmd.history.add  ;
vec.28  data  cpu.crash             ; 
vec.29  data  cpu.crash             ; 
vec.30  data  cpu.crash 
vec.31  data  cpu.crash             ; 
vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog

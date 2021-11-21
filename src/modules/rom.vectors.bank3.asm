* FILE......: rom.vectors.bank3.asm
* Purpose...: Bank 3 vectors for trampoline function
        
*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
vec.1   data  dialog.help           ; Dialog "About"
vec.2   data  dialog.load           ; Dialog "Load file"
vec.3   data  dialog.save           ; Dialog "Save file"
vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
vec.5   data  dialog.print          ; Dialog "Print file"
vec.6   data  dialog.file           ; Dialog "File"
vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
vec.9   data  dialog.clipdev        ; Dialog "Configure clipboard device"
vec.10  data  dialog.config         ; Dialog "Configure"
vec.11  data  cpu.crash             ; 
vec.12  data  cpu.crash             ; 
vec.13  data  cpu.crash             ; 
vec.14  data  cpu.crash             ; 
vec.15  data  tibasic               ; Run TI Basic interpreter
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
vec.30  data  dialog.menu           ; Dialog "Main Menu"
vec.31  data  cpu.crash             ; 
vec.32  data  fm.fastmode           ; Toggle fastmode on/off in Load dialog

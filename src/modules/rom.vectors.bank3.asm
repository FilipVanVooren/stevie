* FILE......: rom.vectors.bank3.asm
* Purpose...: Bank 3 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#3'

*--------------------------------------------------------------
* ROM 3: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   data  dialog.help           ; Dialog "Help"
vec.2   data  dialog.load           ; Dialog "Load file"
vec.3   data  dialog.save           ; Dialog "Save file"
vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
vec.5   data  dialog.print          ; Dialog "Print file"
vec.6   data  dialog.file           ; Dialog "File"
vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
vec.9   data  dialog.cfg.clip       ; Dialog "Configure clipboard"
vec.10  data  dialog.cfg            ; Dialog "Configure"
vec.11  data  dialog.append         ; Dialog "Append file"
vec.12  data  dialog.cartridge      ; Dialog "Cartridge"
vec.13  data  dialog.basic          ; Dialog "TI Basic"
vec.14  data  dialog.shortcuts      ; Dialog "Shortcuts"
vec.15  data  dialog.cat            ; Dialog "Catalog"
vec.16  data  dialog.goto           ; Dialog "Go to line"
vec.17  data  dialog.font           ; Dialog "Configure font"
vec.18  data  dialog.run            ; Dialog "Run file"
vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
vec.22  data  pane.cmdb.draw        ; Draw content in command
vec.23  data  cpu.crash             ;
vec.24  data  cmdb.refresh_prompt   ; Refresh command line
vec.25  data  cmdb.cmd.clear        ; Clear command line
vec.26  data  cmdb.cmd.getlength    ; Get length of command line
vec.27  data  cmdb.cmd.preset       ;
vec.28  data  cmdb.cmd.set          ;
vec.29  data  cmdb.cmd.cursor_eol   ; Position cursor at end of command line
vec.30  data  dialog.menu           ; Dialog "Main Menu"
vec.31  data  tibasic.am.toggle     ; Toggle AutoUnpack in Run TI-Basic dialog
vec.32  data  fm.fastmode           ; Toggle FastMode on/off in Load
*--------------------------------------------------------------
* ROM 3: Vectors 33-64
*--------------------------------------------------------------
vec.33  data  cmdb.cfg.fname        ; Configure filename
vec.34  data  fm.lineterm           ; Toggle line term on/off in Save/Print
vec.35  data  cpu.crash             ;
vec.36  data  cpu.crash             ;
vec.37  data  cpu.crash             ;
vec.38  data  cpu.crash             ;
vec.39  data  cpu.crash             ;
vec.40  data  cpu.crash             ;
vec.41  data  cpu.crash             ;
vec.42  data  dialog                ; Dialog initialisation code
vec.43  data  dialog.find           ; Dialog "Find"
vec.44  data  cpu.crash             ;
vec.45  data  cpu.crash             ;
vec.46  data  cpu.crash             ; 
vec.47  data  cpu.crash             ;
vec.48  data  error.display         ; Show error message
vec.49  data  cpu.crash             ;
vec.50  data  cpu.crash             ;
vec.51  data  cpu.crash             ;
vec.52  data  cpu.crash             ;
vec.53  data  cpu.crash             ;
vec.54  data  cpu.crash             ;
vec.55  data  cpu.crash             ;
vec.56  data  cpu.crash             ;
vec.57  data  cpu.crash             ;
vec.58  data  cpu.crash             ;
vec.59  data  cpu.crash             ;
vec.60  data  cpu.crash             ;
vec.61  data  cpu.crash             ;
vec.62  data  cpu.crash             ;
vec.63  data  cpu.crash             ;
vec.64  data  cpu.crash             ;

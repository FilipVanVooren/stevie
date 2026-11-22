* FILE......: rom.vectors.bank3.asm
* Purpose...: Bank 3 vectors for trampoline function

*--------------------------------------------------------------
* ROM 3: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  dialog.help           ; Dialog "Help"
vec.2   data  dialog.open           ; Dialog "Open file"
vec.3   data  dialog.save           ; Dialog "Save file"
vec.4   data  dialog.insert         ; Dialog "Insert file at line ..."
vec.5   data  dialog.print          ; Dialog "Print file"
vec.6   data  dialog.file           ; Dialog "File"
vec.7   data  dialog.unsaved        ; Dialog "Unsaved changes"
vec.8   data  dialog.clipboard      ; Dialog "Copy clipboard to line ..."
vec.9   data  dialog.opt.clip       ; Dialog "Configure clipboard"
vec.10  data  dialog.opt            ; Dialog "Configure"
vec.11  data  dialog.append         ; Dialog "Append file"
vec.12  data  dialog.cart.type      ; Dialog "Cartridge Type"
vec.13  data  dialog.basic          ; Dialog "TI Basic"
vec.14  data  dialog.shortcuts      ; Dialog "Shortcuts"
vec.15  data  dialog.cat            ; Dialog "Catalog"
vec.16  data  dialog.goto           ; Dialog "Go to line"
vec.17  data  dialog.font           ; Dialog "Configure font"
vec.18  data  dialog.run            ; Dialog "Run program image (EA5)"
vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
vec.20  data  pane.cmdb.draw        ; Draw content in command
vec.21  data  cmdb.refresh_prompt   ; Refresh command line
vec.22  data  cmdb.cmd.clear        ; Clear command line
vec.23  data  cmdb.cmd.getlength    ; Get length of command line
vec.24  data  cmdb.cmd.preset       ;
vec.25  data  cmdb.cmd.set          ;
vec.26  data  cmdb.cmd.cursor_eol   ; Position cursor at end of command line
vec.27  data  dialog.main           ; Dialog "Main Menu"
vec.28  data  tibasic.am.toggle     ; Toggle AutoUnpack in Run TI-Basic dialog
vec.29  data  cmdb.cfg.fname        ; Configure filename
vec.30  data  fm.lineterm           ; Toggle line term on/off in Save/Print
vec.31  data  tv.autoinsert.toggle  ; Toggle auto insert mode for editor buffer
vec.32  data  tv.clock.toggle       ; Toggle clock display on/off
*--------------------------------------------------------------
* ROM 3: Vectors 33-48 (extension island, bankx.exttab)
*           Referenced from other banks as bankx.exttab+offset
*--------------------------------------------------------------
        aorg  bankx.exttab
extvec.33 data  tv.linelen.toggle   ; Toggle line length display on/off
extvec.34 data  cmdb.cmd.insert     ; Insert character in CMDB command line
extvec.35 data  cmdb.cmd.delete     ; Delete character in CMDB command line
extvec.36 data  dialog              ; Dialog initialisation code
extvec.37 data  dialog.find         ; Dialog "Find"
extvec.38 data  dialog.delete       ; Dialog "Delete file"
extvec.39 data  dialog.cart.fg99    ; Dialog "FinalGROM 99 Cartridge"
extvec.40 data  cpu.crash           ;
extvec.41 data  cpu.crash           ;
extvec.42 data  cpu.crash           ;
extvec.43 data  cpu.crash           ;
extvec.44 data  cpu.crash           ;
extvec.45 data  cpu.crash           ;
extvec.46 data  cpu.crash           ;
extvec.47 data  cpu.crash           ;
extvec.48 data  cpu.crash           ;

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        aorg >7fea
        stri 'ROM#3'

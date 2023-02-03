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
vec.1   data  dialog.help           ; Dialog "About"
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
vec.15  data  dialog.editor         ; Dialog "Configure editor"
vec.16  data  dialog.goto           ; Dialog "Go to line"
vec.17  data  dialog.font           ; Dialog "Configure font"
vec.18  data  error.display         ; Show error message
vec.19  data  pane.show_hintx       ; Show or hide hint (register version)
vec.20  data  pane.cmdb.show        ; Show command buffer pane (=dialog)
vec.21  data  pane.cmdb.hide        ; Hide command buffer pane
vec.22  data  pane.cmdb.draw        ; Draw content in command
vec.23  data  tibasic.buildstr      ; Build TI Basic session identifier string
vec.24  data  cmdb.refresh          ;
vec.25  data  cmdb.cmd.clear        ;
vec.26  data  cmdb.cmd.getlength    ;
vec.27  data  cmdb.cmd.preset       ;
vec.28  data  cmdb.cmd.set          ;
vec.29  data  dialog.hearts.tat     ; Dump color for hearts in TI-Basic dialog
vec.30  data  dialog.menu           ; Dialog "Main Menu"
vec.31  data  tibasic.am.toggle     ; Toggle AutoUnpack in Run TI-Basic dialog
vec.32  data  fm.fastmode           ; Toggle FastMode on/off in Load dialog
*--------------------------------------------------------------
* ROM 3: Vectors 33-64
*--------------------------------------------------------------
vec.33  data  cmdb.cfg.fname        ; Configure filename
vec.34  data  cpu.crash             ;
vec.35  data  cpu.crash             ;
vec.36  data  cpu.crash             ;
vec.37  data  cpu.crash             ;
vec.38  data  cpu.crash             ;
vec.39  data  cpu.crash             ;
vec.40  data  cpu.crash             ;
vec.41  data  cpu.crash             ;
vec.42  data  cpu.crash             ;
vec.43  data  cpu.crash             ;
vec.44  data  cpu.crash             ;
vec.45  data  cpu.crash             ;
vec.46  data  cpu.crash             ;
vec.47  data  cpu.crash             ;
vec.48  data  cpu.crash             ;
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
*--------------------------------------------------------------
* ROM 3: Vectors 65-96
*--------------------------------------------------------------
vec.65  data  cpu.crash             ;
vec.66  data  cpu.crash             ;
vec.67  data  cpu.crash             ;
vec.68  data  cpu.crash             ;
vec.69  data  cpu.crash             ;
vec.70  data  cpu.crash             ;
vec.71  data  cpu.crash             ;
vec.72  data  cpu.crash             ;
vec.73  data  cpu.crash             ;
vec.74  data  cpu.crash             ;
vec.75  data  cpu.crash             ;
vec.76  data  cpu.crash             ;
vec.77  data  cpu.crash             ;
vec.78  data  cpu.crash             ;
vec.79  data  cpu.crash             ;
vec.80  data  cpu.crash             ;
vec.81  data  cpu.crash             ;
vec.82  data  cpu.crash             ;
vec.83  data  cpu.crash             ;
vec.84  data  cpu.crash             ;
vec.85  data  cpu.crash             ;
vec.86  data  cpu.crash             ;
vec.87  data  cpu.crash             ;
vec.88  data  cpu.crash             ;
vec.89  data  cpu.crash             ;
vec.90  data  cpu.crash             ;
vec.91  data  cpu.crash             ;
vec.92  data  cpu.crash             ;
vec.93  data  cpu.crash             ;
vec.94  data  cpu.crash             ;
vec.95  data  cpu.crash             ;
vec.96  data  cpu.crash             ;

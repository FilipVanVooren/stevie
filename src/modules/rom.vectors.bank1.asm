* FILE......: rom.vectors.bank1.asm
* Purpose...: Bank 1 vectors for trampoline function

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
vec.1   data  mem.sams.setup.stevie ; 
vec.2   data  cpu.crash             ; 
vec.3   data  cpu.crash             ; 
vec.4   data  cpu.crash             ; 
vec.5   data  cpu.crash             ; 
vec.6   data  cpu.crash             ; 
vec.7   data  cpu.crash             ; 
vec.8   data  cpu.crash             ; 
vec.9   data  cpu.crash             ; 
vec.10  data  edb.line.pack.fb      ; 
vec.11  data  edb.line.unpack.fb    ; 
vec.12  data  edb.clear.sams        ; 
vec.13  data  cpu.crash             ; 
vec.14  data  cpu.crash             ; 
vec.15  data  edkey.action.cmdb.show
vec.16  data  cpu.crash             ; 
vec.17  data  cpu.crash             ; 
vec.18  data  cpu.crash             ; 
vec.19  data  cmdb.cmd.clear        ; 
vec.20  data  fb.refresh            ; 
vec.21  data  fb.vdpdump            ; 
vec.22  data  fb.row2line           ; 
vec.23  data  cpu.crash             ; 
vec.24  data  cpu.crash             ; 
vec.25  data  cpu.crash             ; 
vec.26  data  cpu.crash             ; 
vec.27  data  pane.errline.hide     ; 
vec.28  data  pane.cursor.blink     ; 
vec.29  data  pane.cursor.hide      ; 
vec.30  data  pane.errline.show     ;
vec.31  data  pane.action.colorscheme.load
vec.32  data  pane.action.colorscheme.statlines

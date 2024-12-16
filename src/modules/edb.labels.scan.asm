* FILE......: edb.labels.scan.asm
* Purpose...: Scan source code in editor buffer for labels

***************************************************************
* edb.labels.scan
* Scan labels in source code currently in editor buffer
***************************************************************
*  bl   @edb.labels.scan
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edb.labels.scan
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------        
        ; Show busy indicator
        ;------------------------------------------------------ 
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /            
        
        bl    @putat
              byte pane.botrow,0
              data txt.labelscan    ; Display "Scanning labels..."        
        ;------------------------------------------------------        
        ; Loop over lines in editor buffer
        ;------------------------------------------------------
        clr   @fh.records           ; Current line
edb.labels.scan.line
        ;------------------------------------------------------
        ; Unpack line to ram buffer
        ;------------------------------------------------------
edb.labels.scan.unpack_line:
        mov   @fh.records,@parm1    ; Unpack current line
        clr   @parm2
        clr   @parm3

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in frame buffer
                                    ; | i  parm3    = Column offset
                                    ; / o  outparm1 = Length of line
        ;------------------------------------------------------
        ; Update line counter
        ;------------------------------------------------------
        inc   @fh.records           

        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020

        c     @fh.records,@edb.lines ; All lines scanned ?                                
        jne   edb.labels.scan.line   ; Not yet, next line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.labels.scan.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

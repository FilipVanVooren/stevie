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
*--------------------------------------------------------------
* Memory usage
*
* 1. Using some memory locations foreseen for file I/O.
*    Is ok, because we know we're not saving/reading file while
*    scanning editor buffer in memory.
*
* 2. Using framebuffer as work buffer for label scan.
*    Enable reuse of existing unpack to framebuffer function.
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
              data txt.labelscan    ; Show "Scanning labels in source code..."        
        ;------------------------------------------------------        
        ; Loop over lines in editor buffer
        ;------------------------------------------------------
        clr   @fh.records           ; Current line
edb.labels.scan.line
        ;------------------------------------------------------
        ; Unpack current line to frame buffer
        ;------------------------------------------------------
edb.labels.scan.unpack_line:
        mov   @fh.records,@parm1    ; Unpack current line to frame buffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in frame buffer
                                    ; | i  parm3    = Column offset
                                    ; / o  outparm1 = Length of line
        ;------------------------------------------------------
        ; Update line counter
        ;------------------------------------------------------
        inc   @fh.records           ; Increase line counter

        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020

        c     @fh.records,@edb.lines ; All lines scanned ?                                
        jne   edb.labels.scan.line   ; Not yet, next line
        ;------------------------------------------------------
        ; restore 1st line in frame buffer before exit
        ;------------------------------------------------------
        mov   @fb.topline,@parm1    ; Line to restore in frame buffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  @parm1   = Line to unpack
                                    ; | i  @parm2   = Target row in frame buffer
                                    ; | i  @parm3   = Column offset
                                    ; / o  @outparm1 = Length of line                
                                    
        seto  @fb.dirty             ; Trigger frame buffer refresh
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

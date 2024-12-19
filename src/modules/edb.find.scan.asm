* FILE......: edb.find.scan.asm
* Purpose...: Scan source code for search string
***************************************************************
* edb.find.scan
* Scan source code for search string
***************************************************************
*  bl   @edb.find.scan
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
* 2. Using framebuffer as work buffer for unpacking line before scan.
*    Enable reuse of existing unpack to framebuffer function.
********|*****|*********************|**************************
edb.find.scan
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
        ; Initialisation
        ;------------------------------------------------------ 
        bl    @cpym2m
              data cmdb.cmdall,edb.srch.str,80
                                    ; Set search string

        clr   @edb.srch.matches     ; Reset matches counter
        clr   @edb.srch.startln     ; 1st line to search
        mov   @edb.lines,@edb.srch.endln
                                    ; Last line to search                
        ;------------------------------------------------------        
        ; Show busy indicator
        ;------------------------------------------------------ 
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /            
        
        bl    @putat
              byte pane.botrow,0
              data txt.searching    ; Show "Searching..."

        mov   @edb.srch.startln,@fh.records           
                                    ; Counter current line
        ;------------------------------------------------------        
        ; Loop over lines in editor buffer
        ;------------------------------------------------------
edb.find.scan.line:
              nop        
        ;------------------------------------------------------
        ; Unpack current line to framebuffer
        ;------------------------------------------------------
edb.find.scan.unpack_line:
        mov   @fh.records,@parm1    ; Unpack current line to framebuffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in framebuffer
                                    ; | i  parm3    = Column offset
                                    ; / o  outparm1 = Length of line

        mov   @outparm1,@edb.srch.worklen
                                    ; Save length of unpacked line
        ;------------------------------------------------------
        ; Compare search string with unpacked line
        ;------------------------------------------------------
edb.find.scan.compare_line:
        nop
        ;------------------------------------------------------
        ; Prepare for processing Next line
        ;------------------------------------------------------
edb.find.scan.nextline:        
        inc   @fh.records           ; Increase line counter

        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020

        c     @fh.records,@edb.srch.endln
                                    ; All lines scanned ?                                

        jne   edb.find.scan.line    ; Not yet, process next line
        ;------------------------------------------------------
        ; Scan completed. Restore 1st line in framebuffer
        ;------------------------------------------------------
edb.find.scan.done:        
        mov   @fb.topline,@parm1    ; Line to restore in framebuffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  @parm1    = Line to unpack
                                    ; | i  @parm2    = Target row in framebuffer
                                    ; | i  @parm3    = Column offset
                                    ; / o  @outparm1 = Length of line                
                                    
        seto  @fb.dirty             ; Trigger frame buffer refresh

        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.find.scan.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

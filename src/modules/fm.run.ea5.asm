* FILE......: fm.run.ea5.asm
* Purpose...: File Manager - Run EA5 program image

***************************************************************
* fm.run.ea5
* Run EA5 program image
***************************************************************
* bl  @fm.run.ea5
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.run.ea5:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push @parm1       
        ;-------------------------------------------------------        
        ; Exit early if editor buffer is dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp1       ; Get dirty flag
        jeq   !                     ; Load file unless dirty
        seto  @outparm1             ; \ Editor buffer dirty, set flag
        jmp   fm.run.ea5.exit       ; / and exit early 
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
!       mov   @fb.scrrows.max,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
        bl    @scroff               ; Turn off screen

        li    tmp0,vdp.fb.toprow.sit - 80
                                    ; VDP target address (1nd row on screen!)
        li    tmp1,32               ; Character to fill
        ai    tmp2,80               ; Consider 1st row        
        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy
        ;-------------------------------------------------------
        ; Reload colorscheme
        ;-------------------------------------------------------
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3

        seto  @parm1                ; \ Do not turn screen off while reloading
                                    ; / color scheme

        seto  @parm2                ; Skip marked lines colorization
        clr   @parm3                ; Colorize all panes

        clr   @tv.error.visible     ; No error message/pane

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF                                    
                                    ; | i  @parm3 = Only colorize CMDB pane 
                                    ; /             if >FFFF

        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
        bl    @tv.reset             ; Reset editor       
        ;-------------------------------------------------------
        ; Load EA5 program image into memory
        ;-------------------------------------------------------
        bl    @fh.file.load.ea5     ; Load EA5 memory image into memory
                                    ; \ i  @parm1    = Pointer to length
                                    ; |                prefixed  file descriptor
                                    ; | o  @outparm1 = Entrypoint in EA5 program
                                    ; /                or >FFFF if load failed

        mov   @outparm1,tmp0        ; \  
        ci    tmp0,>ffff            ; | Exit early with error if load failed
        jeq   fm.run.ea5.error      ; / 
        mov   tmp0,@parm1           ; Set entrypoint                

        bl    @mem.run.ea5          ; Run EA5 memory image
                                    ; \ i  @parm1 = Entrypoint in EA5 program
                                    ; / 
        jmp   fm.run.ea5.exit
        ;-------------------------------------------------------
        ; EA5 program image could not be loaded into memory
        ;-------------------------------------------------------
fm.run.ea5.error:
        bl    @fb.cursor.top        ; Goto top of file
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.run.ea5.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

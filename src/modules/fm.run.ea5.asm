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
        ; Load EA5 program image into memory
        ;-------------------------------------------------------
!       bl    @fh.file.load.ea5     ; Load EA5 binary image into memory
                                    ; \ i  @parm1    = Pointer to length prefixed 
                                    ; |                file descriptor
                                    ; | o  @outparm1 = Entrypoint in EA5 program
                                    ; /                or >FFFF if load failed

        mov   @outparm1,tmp0        ; \  
        ci    tmp0,>ffff            ; | Exit early with error if file load failed
        jeq   fm.run.ea5.error      ; / 
        mov   tmp0,@parm1           ; Set entrypoint                

        bl    @mem.ea5.run          ; Run previously loaded EA5 memory image
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

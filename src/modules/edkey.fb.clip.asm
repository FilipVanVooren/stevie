* FILE......: edkey.fb.clip.asm
* Purpose...: Clipboard File related actions in frame buffer pane.

*---------------------------------------------------------------
* Save clipboards
*---------------------------------------------------------------
* b   @edkey.action.fb.clip.save.[1-3]
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edkey.action.fb.clip.save.1:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        li    tmp0,clip1
        jmp   !
edkey.action.fb.clip.save.2:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        li    tmp0,clip2
        jmp   !
edkey.action.fb.clip.save.3:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        li    tmp0,clip3
        ;-------------------------------------------------------
        ; Save block to clipboard
        ;-------------------------------------------------------
!       mov   tmp0,@parm1        
        bl    @edb.block.clip       ; Save block to clipboard
                                    ; \ i  @parm1 = Suffix clipboard filename
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.fb.clip.save.exit:
        mov   *stack+,tmp0          ; Pop tmp0

        mov   @fb.topline,@parm1    ; Get topline
        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer

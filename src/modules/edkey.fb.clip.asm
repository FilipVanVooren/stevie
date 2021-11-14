* FILE......: edkey.fb.clip.asm
* Purpose...: Clipboard File related actions in frame buffer pane.

*---------------------------------------------------------------
* Save clipboards
*---------------------------------------------------------------
* b   @edkey.action.fb.clip.save.[0-9]
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edkey.action.fb.clip.save.0:
        li    tmp0,clip0
        jmp   !
edkey.action.fb.clip.save.1:
        li    tmp0,clip1
        jmp   !
edkey.action.fb.clip.save.2:
        li    tmp0,clip2
        jmp   !
edkey.action.fb.clip.save.3:
        li    tmp0,clip3
        jmp   !
edkey.action.fb.clip.save.4:
        li    tmp0,clip4
        jmp   !
edkey.action.fb.clip.save.5:
        li    tmp0,clip5
        jmp   !
edkey.action.fb.clip.save.6:
        li    tmp0,clip6
        jmp   !
edkey.action.fb.clip.save.7:
        li    tmp0,clip7
        jmp   !
edkey.action.fb.clip.save.8:
        li    tmp0,clip8
        jmp   !
edkey.action.fb.clip.save.9:
        li    tmp0,clip9
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
        b     @edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
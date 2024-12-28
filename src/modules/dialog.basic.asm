* basic......: dialog.basic.asm
* Purpose....: Dialog "Basic"

***************************************************************
* dialog.basic
* Open Dialog "Basic"
***************************************************************
* bl @dialog.basic
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.basic:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.basic
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.basic
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.basic
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.basic
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.basic
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.hint.basic2  ; \ Display extra hint
        mov   tmp0,@cmdb.panhint2   ; / 

        mov   @tib.autounpk,tmp0    ; Get 'AutoUnpack' flag
        jeq   !
        ;-------------------------------------------------------
        ; Flag is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.basic2
        jmp   dialog.basic.done
        ;-------------------------------------------------------
        ; Flag is off
        ;-------------------------------------------------------
!       mov   @tib.session,tmp0     ; Already did session before?
        jeq   dialog.basic.amonly   ; No, only AutoUnpack

        li    tmp0,txt.keys.basic1  ; Add "Unpack" option to keylist
        jmp   dialog.basic.done
        ;-------------------------------------------------------
        ; AutoUnpack option only
        ;-------------------------------------------------------
dialog.basic.amonly:
        li    tmp0,txt.keys.basic   ; Only AutoUnpack
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.basic.done:
        mov   tmp0,@cmdb.pankeys    ; Save keylist in status line
        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.basic.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

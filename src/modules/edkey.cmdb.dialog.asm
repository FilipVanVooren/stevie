* FILE......: edkey.cmdb.dialog.asm
* Purpose...: Dialog specific actions in command buffer pane.

***************************************************************
* edkey.action.cmdb.proceed
* Proceed with action
***************************************************************
* b   @edkey.action.cmdb.proceed
*--------------------------------------------------------------
* INPUT
* @cmdb.action.ptr = Pointer to keyboard action
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.cmdb.proceed:
        ;-------------------------------------------------------
        ; Intialisation
        ;-------------------------------------------------------
        clr   @edb.dirty            ; Clear editor buffer dirty flag
        bl    @pane.cursor.blink    ; Show cursor again
        bl    @cmdb.cmd.clear       ; Clear current command
        mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
        ;-------------------------------------------------------
        ; Asserts
        ;-------------------------------------------------------
        ci    tmp0,>2000
        jlt   !                     ; Invalid address, crash

        ci    tmp0,>7fff
        jgt   !                     ; Invalid address, crash
        ;------------------------------------------------------
        ; All Asserts passed
        ;------------------------------------------------------
        b     *tmp0                 ; Execute action
        ;------------------------------------------------------
        ; Asserts failed
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.proceed.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




***************************************************************
* edkey.action.cmdb.fastmode.toggle
* Toggle fastmode on/off
***************************************************************
* b   @edkey.action.cmdb.proceed
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.cmdb.fastmode.toggle:
       bl    @fm.fastmode           ; Toggle fast mode.
       seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
       b     @hook.keyscan.bounce   ; Back to editor main             




***************************************************************
* dialog.close
* Close dialog
***************************************************************
* b   @edkey.action.cmdb.close.dialog
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.cmdb.close.dialog:
        ;------------------------------------------------------
        ; Close dialog
        ;------------------------------------------------------        
        clr   @cmdb.dialog          ; Reset dialog ID
        bl    @pane.cursor.blink    ; Show cursor
        bl    @pane.cmdb.hide       ; Hide command buffer pane
        seto  @fb.status.dirty      ; Trigger status lines update        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.close.dialog.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

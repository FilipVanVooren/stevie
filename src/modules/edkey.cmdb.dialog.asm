* FILE......: edkey.cmdb.dialog.asm
* Purpose...: Dialog specific actions in command buffer pane.



*---------------------------------------------------------------
* Proceed with action
*---------------------------------------------------------------
edkey.action.cmdb.proceed:
        ;-------------------------------------------------------
        ; Intialisation
        ;-------------------------------------------------------
        clr   @edb.dirty            ; Clear editor buffer dirty flag
        bl    @pane.cursor.blink    ; Show cursor again
        bl    @cmdb.cmd.clear       ; Clear current command
        mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
        ;-------------------------------------------------------
        ; Sanity checks
        ;-------------------------------------------------------
        ci    tmp0,>2000
        jlt   !                     ; Invalid address, crash

        ci    tmp0,>7fff
        jgt   !                     ; Invalid address, crash
        ;------------------------------------------------------
        ; All sanity checks passed
        ;------------------------------------------------------
        b     *tmp0                 ; Execute action
        ;------------------------------------------------------
        ; Sanity checks failed
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.proceed.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Toggle fastmode on/off
*---------------------------------------------------------------
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
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.close.dialog.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

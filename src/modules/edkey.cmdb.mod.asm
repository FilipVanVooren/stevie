* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.


*---------------------------------------------------------------
* Process character
********|*****|*********************|**************************
edkey.action.cmdb.char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        li    tmp0,cmdb.cmd         ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  tmp1,*tmp0            ; Add character
        li    tmp1,>0100
        ab    tmp1,@cmdb.cmdlen     ; Adjust command length        
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edkey.action.cmdb.enter:
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane
        li    tmp0,cmdb.cmdlen      ; Length-prefixed command string
        bl    @fm.loadfile        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.enter.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 

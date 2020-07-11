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
        ; Get length of null terminated string
        ;-------------------------------------------------------
        bl    @string.getlen0      ; Get length
              data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
                                   ; | i  p1    = Termination character
                                   ; / o  waux1 = Length of string
        mov   @waux1,tmp0          
        sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Save length of string
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

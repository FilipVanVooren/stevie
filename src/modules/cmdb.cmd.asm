* FILE......: cmdb.cmd.asm
* Purpose...: Stevie Editor - Command line

***************************************************************
* cmdb.cmd.clear
* Clear current command
***************************************************************
* bl @cmdb.cmd.clear
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.clear:
        .pushregs 0                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Clear command
        ;------------------------------------------------------
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80

        clr   @cmdb.column          ; Reset column
        ;------------------------------------------------------
        ; Put cursor at beginning of line
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,tmp0   
        inct  tmp0                  ; Skip ">" prompt
        mov   tmp0,@cmdb.cursor     ; Position cursor

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.clear.exit:
        .popregs 0                  ; Pop registers and return to caller        


***************************************************************
* cmdb.cmdb.getlength
* Get length of current command
***************************************************************
* bl @cmdb.cmd.getlength
*--------------------------------------------------------------
* INPUT
* @cmdb.cmd
*--------------------------------------------------------------
* OUTPUT
* @outparm1
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.getlength:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Get length of null terminated string
        ;-------------------------------------------------------
        bl    @string.getlenc      ; Get length of C-style string
              data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
                                   ; | i  p1    = Termination character
                                   ; / o  waux1 = Length of string
        mov   @waux1,@outparm1     ; Save length of string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.getlength.exit:        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* cmdb.cmd.insert
* Insert character at current cursor position
***************************************************************
* bl @cmdb.cmd.insert
*--------------------------------------------------------------
* INPUT
* @cmdb.column = Current column in command buffer
* @parm1       = MSB character to insert
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
*--------------------------------------------------------------
* Made by copilot. Model
* MAI-Code-1-Flash
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.insert:
        .pushregs 3
        ;-------------------------------------------------------
        ; Get current command length and stop if maxed out
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; Get line length
        mov   @outparm1,tmp3        ; tmp3 = original length
        ci    tmp3,80               ; Command buffer full?
        jeq   cmdb.cmd.insert.exit  ; Yes, exit without changing anything
        ;-------------------------------------------------------
        ; At end-of-line, append character
        ;-------------------------------------------------------
        c     @cmdb.column,tmp3     ; Current column == EOL?
        jeq   cmdb.cmd.insert.append ; Yes, append at end of line
        ;-------------------------------------------------------
        ; Shift trailing text right by one position
        ;-------------------------------------------------------
        mov   tmp3,tmp2             ; tmp2 = original length
        s     @cmdb.column,tmp2     ; tmp2 = length - column
        li    tmp0,cmdb.cmd
        a     tmp3,tmp0             ; tmp0 = command + length
        dec   tmp0                  ; tmp0 = command + length - 1
        li    tmp1,cmdb.cmd
        a     tmp3,tmp1             ; tmp1 = command + length
cmdb.cmd.insert.shift:
        movb  *tmp0,*tmp1           ; Shift tail one character to the right
        dec   tmp0                  ; Source--
        dec   tmp1                  ; Target--
        dec   tmp2                  ; Counter--
        jne   cmdb.cmd.insert.shift ; Keep shifting until old terminator is moved
        ;-------------------------------------------------------
        ; Insert new character at current column
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmd
        a     @cmdb.column,tmp0     ; tmp0 = current insertion point
        movb  @parm1,*tmp0          ; Write new character into command buffer
        ;-------------------------------------------------------
        ; Update length prefix and cursor position
        ;-------------------------------------------------------
        inc   tmp3                  ; New length = old length + 1
        sla   tmp3,8                ; Move to MSB 
        movb  tmp3,@cmdb.cmdlen     ; Update command buffer length prefix
        inc   @cmdb.column          ; Cursor moves right one column
        inc   @cmdb.cursor          ; Screen cursor moves right one column
        jmp   cmdb.cmd.insert.exit  ; Done
        ;-------------------------------------------------------
        ; Append character at end of line
        ;-------------------------------------------------------
cmdb.cmd.insert.append:
        li    tmp0,cmdb.cmd
        a     @cmdb.column,tmp0     ; tmp0 = end of command buffer
        movb  @parm1,*tmp0          ; Append character
        inc   tmp3                  ; New length = old length + 1
        sla   tmp3,8                ; Move to MSB 
        movb  tmp3,@cmdb.cmdlen     ; Update command buffer length prefix
        inc   @cmdb.column          ; Cursor moves right one column
        inc   @cmdb.cursor          ; Screen cursor moves right one column
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
cmdb.cmd.insert.exit:
        .popregs 3



***************************************************************
* cmdb.cmd.delete
* Delete character at current cursor position
***************************************************************
* bl @cmdb.cmd.delete
*--------------------------------------------------------------
* INPUT
* @cmdb.column = Current column in command buffer
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
*--------------------------------------------------------------
* Made by copilot. Model
* MAI-Code-1-Flash
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.delete:
        .pushregs 3
        ;-------------------------------------------------------
        ; Get current command length and abort if empty/EOL
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; Get line length
        mov   @outparm1,tmp3        ; tmp3 = current length
        jeq   cmdb.cmd.delete.exit  ; Empty line, nothing to delete
        c     @cmdb.column,tmp3     ; At EOL or beyond?
        jhe   cmdb.cmd.delete.exit  ; Yes, nothing to delete
        ;-------------------------------------------------------
        ; Boundary case: deleting the only remaining character
        ;-------------------------------------------------------
        mov   tmp3,tmp2             ; tmp2 = current length
        s     @cmdb.column,tmp2     ; tmp2 = length - column
        ci    tmp2,1                ; One character left to delete?
        jeq   cmdb.cmd.delete.tail  ; Yes, collapse to empty string directly
        ;-------------------------------------------------------
        ; Shift trailing text left by one position
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmd
        a     @cmdb.column,tmp0     ; tmp0 = current deletion point
        li    tmp1,cmdb.cmd
        a     @cmdb.column,tmp1     ; tmp1 = current deletion point
        inc   tmp1                  ; tmp1 = next char to shift left
        dec   tmp2                  ; Remove one character to delete
cmdb.cmd.delete.shift:
        movb  *tmp1+,*tmp0+         ; Shift tail one character to the left
        dec   tmp2                  ; Counter--
        jne   cmdb.cmd.delete.shift ; Keep shifting until tail is collapsed
        ;-------------------------------------------------------
        ; Write zero terminator at the new end of string
        ;-------------------------------------------------------
        clr   tmp1                  ; tmp1 = zero terminator
        movb  tmp1,*tmp0            ; Terminate updated command string
        ;-------------------------------------------------------
        ; Update command length prefix
        ;-------------------------------------------------------
        dec   tmp3                  ; New length = old length - 1
        sla   tmp3,8                ; Move to MSB 
        movb  tmp3,@cmdb.cmdlen     ; Update command buffer length prefix
        jmp   cmdb.cmd.delete.exit
        ;-------------------------------------------------------
        ; Boundary case: deleting only remaining character
        ;-------------------------------------------------------
cmdb.cmd.delete.tail:
        li    tmp0,cmdb.cmd
        a     @cmdb.column,tmp0     ; tmp0 = current deletion point
        clr   tmp1                  ; tmp1 = zero terminator
        movb  tmp1,*tmp0            ; Terminate updated command string
        dec   tmp3                  ; New length = old length - 1
        sla   tmp3,8                ; Move to MSB 
        movb  tmp3,@cmdb.cmdlen     ; Update command buffer length prefix
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
cmdb.cmd.delete.exit:
        .popregs 3



***************************************************************
* cmdb.cmd.cursor_eol
* Set cursor at end of line
***************************************************************
* bl @cmdb.cmd.cursor_eol
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* @cmdb.cursor = New cursor position
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.cursor_eol:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;---------------------------------------------------------------
        ; Position cursor at end of input line
        ;---------------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; \ Get length of command line input
                                    ; | i   @cmdb.cmd = Pointer to prompt
                                    ; / o   @outparm1 = Length of prompt

        mov   @outparm1,tmp0        ; Length of prompt
        mov   tmp0,@cmdb.column     ; Save column position
        ;---------------------------------------------------------------
        ; Cursor position! Not the same as cmdb column, has offset
        ;---------------------------------------------------------------                
        ai    tmp0,3                ; Add offset + cursor after last char
        sla   tmp0,8                ; LSB TO MSB
        movb  tmp0,@cmdb.cursor + 1 ; Set cursor position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.cursor_eol.exit:
        .popregs 0                  ; Pop registers and return to caller        

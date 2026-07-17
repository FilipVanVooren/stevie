* FILE......: edk.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.

***************************************************************
* edk.act.cmdb.clear
* Clear current command
***************************************************************
* b  @edk.act.cmdb.clear
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
edk.act.cmdb.clear:
        ;-------------------------------------------------------
        ; Clear current command
        ;-------------------------------------------------------
        bl    @cmdb.cmd.clear       ; Clear current command
        bl    @cmdb.refresh_prompt  ; Draw command line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.clear.exit:
        b     @edk.act.cmdb.home
                                    ; Reposition cursor


***************************************************************
* edk.act.cmdb.del_char
* Delete character at current command cursor position
***************************************************************
* b  @edk.act.cmdb.del_char
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
edk.act.cmdb.del_char:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Delete character under the cursor
        ;-------------------------------------------------------
        bl    @cmdb.cmd.delete      ; Delete character at current column
        bl    @cmdb.refresh_prompt  ; Redraw command buffer prompt
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.del_char.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
        

***************************************************************
* edk.act.cmdb.char
* Add character to command line
***************************************************************
* b  @edk.act.cmdb.char
*--------------------------------------------------------------
* INPUT
* tmp1 
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
edk.act.cmdb.char:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Asserts
        ;-------------------------------------------------------
        mov   @keycode1,tmp0        ; Get keycode
        ci    tmp0,32               ; Keycode < ASCII 32 ?
        jlt   edk.act.cmdb.char.exit
                                    ; Yes, skip

        ci    tmp0,126              ; Keycode > ASCII 126 ?
        jgt   edk.act.cmdb.char.exit
                                    ; Yes, skip

        ;-------------------------------------------------------
        ; Convert keycode to command character format
        ;-------------------------------------------------------
        mov   tmp0,tmp1             ; \
        sla   tmp1,8                ; / Move keycode to MSB
        mov   tmp1,@parm1           ; Pass character through @parm1
        ;-------------------------------------------------------
        ; Insert or append character at cursor position
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; Get line length
        c     @cmdb.column,@outparm1 ; In the middle of the string?
        jlt   !                     ; Yes, insert at current column
        ;-------------------------------------------------------
        ; Append at current end-of-line
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmd         ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  @parm1,*tmp0          ; Add character
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor

        bl    @cmdb.cmd.getlength   ; Get length of current command
                                    ; \ i  @cmdb.cmd = Command string
                                    ; / o  @outparm1 = Length of command

        mov   @outparm1,tmp0        ; Get command line 
        inc   tmp0                  ; New length
        sla   tmp0,8                ; Move to MSB 
        movb  tmp0,@cmdb.cmdlen     ; Set length-prefix of command line string
        jmp   edk.act.cmdb.char.redraw
        ;-------------------------------------------------------
        ; Insert character in the middle of string
        ;-------------------------------------------------------
!       bl    @cmdb.cmd.insert      ; Insert character at current column
        ;-------------------------------------------------------
        ; Refresh display and cursor
        ;-------------------------------------------------------
edk.act.cmdb.char.redraw:
        bl    @vdp.cursor.tat       ; Update cursor
        bl    @cmdb.refresh_prompt  ; Draw command line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.char.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

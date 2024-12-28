* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.

***************************************************************
* edkey.action.cmdb.clear
* Clear current command
***************************************************************
* b  @edkey.action.cmdb.clear
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
edkey.action.cmdb.clear:
        ;-------------------------------------------------------
        ; Clear current command
        ;-------------------------------------------------------
        bl    @cmdb.cmd.clear       ; Clear current command
        bl    @cmdb.refresh_prompt  ; Draw command line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.clear.exit:
        b     @edkey.action.cmdb.home
                                    ; Reposition cursor
        





***************************************************************
* edkey.action.cmdb.char
* Add character to command line
***************************************************************
* b  @edkey.action.cmdb.char
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
edkey.action.cmdb.char:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Asserts
        ;-------------------------------------------------------
        mov   @keycode1,tmp0        ; Get keycode
        ci    tmp0,32               ; Keycode < ASCII 32 ?
        jlt   edkey.action.cmdb.char.exit
                                    ; Yes, skip

        ci    tmp0,126              ; Keycode > ASCII 126 ?
        jgt   edkey.action.cmdb.char.exit
                                    ; Yes, skip

        ;-------------------------------------------------------
        ; Add character
        ;-------------------------------------------------------
        mov   tmp0,tmp1             ; \ 
        sla   tmp1,8                ; / Move keycode to MSB 

        li    tmp0,cmdb.cmd         ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  tmp1,*tmp0            ; Add character
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor

        bl    @cmdb.cmd.getlength   ; Get length of current command
                                    ; \ i  @cmdb.cmd = Command string
                                    ; / o  @outparm1 = Length of command

        mov   @outparm1,tmp0        ; Get command line 
        sla   tmp0,8                ; Move to MSB 
        movb  tmp0,@cmdb.cmdlen     ; Set length-prefix of command line string

        bl    @cmdb.refresh_prompt  ; Draw command line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.char.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

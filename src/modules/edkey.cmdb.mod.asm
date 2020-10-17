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
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
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
        ;-------------------------------------------------------
        ; Sanity checks
        ;-------------------------------------------------------
        movb  tmp1,tmp0             ; Get keycode
        srl   tmp0,8                ; MSB to LSB

        ci    tmp0,32               ; Keycode < ASCII 32 ?
        jlt   edkey.action.cmdb.char.exit
                                    ; Yes, skip

        ci    tmp0,126              ; Keycode > ASCII 126 ?
        jgt   edkey.action.cmdb.char.exit
                                    ; Yes, skip
        ;-------------------------------------------------------
        ; Add character
        ;-------------------------------------------------------
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        li    tmp0,cmdb.cmd         ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  tmp1,*tmp0            ; Add character
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor

        bl    @cmdb.cmd.getlength   ; Get length of current command
                                    ; \ i  @cmdb.cmd = Command string
                                    ; / o  @outparm1 = Length of command
        ;-------------------------------------------------------
        ; Addjust length
        ;-------------------------------------------------------
        mov   @outparm1,tmp0
        sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
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
        ; Show Load or Save dialog depending on current mode
        ;-------------------------------------------------------        
edkey.action.cmdb.enter.loadsave:
        b     @edkey.action.cmdb.loadsave
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.enter.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

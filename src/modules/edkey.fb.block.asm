* FILE......: edkey.fb.block.asm
* Purpose...: Mark lines for block operations

*---------------------------------------------------------------
* Mark line M1
********|*****|*********************|**************************
edkey.action.block.mark.m1:
        bl    @edb.block.mark.m1    ; Set M1 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main
        


*---------------------------------------------------------------
* Mark line M2
********|*****|*********************|**************************
edkey.action.block.mark.m2:
        bl    @edb.block.mark.m2    ; Set M2 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Mark line M1 or M2
********|*****|*********************|**************************
edkey.action.block.mark:
        bl    @edb.block.mark       ; Set M1/M2 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Reset block markers M1/M2
********|*****|*********************|**************************
edkey.action.block.reset:
        bl    @pane.errline.hide    ; Hide error line if visible
        bl    @edb.block.reset      ; Reset block markers M1/M2
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Copy code block
********|*****|*********************|**************************
edkey.action.block.copy:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Exit early if nothing to do
        ;-------------------------------------------------------
        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edkey.action.block.copy.exit
                                    ; Yes, exit early
        ;-------------------------------------------------------
        ; Init
        ;-------------------------------------------------------
        mov   @wyx,tmp0             ; Get cursor position
        andi  tmp0,>ff00            ; Move cursor home (X=00)
        mov   tmp0,@fb.yxsave       ; Backup cursor position
        ;-------------------------------------------------------
        ; Copy 
        ;-------------------------------------------------------
        bl    @pane.errline.hide    ; Hide error line if visible

        clr   @parm1                ; Set message to "Copying block..."
        bl    @edb.block.copy       ; Copy code block
                                    ; \ i  @parm1    = Message flag
                                    ; / o  @outparm1 = >ffff if success

        c     @outparm1,@w$0000     ; Copy skipped?        
        jeq   edkey.action.block.copy.exit
                                    ; If yes, exit early

        mov   @fb.yxsave,@parm1
        bl    @fb.restore           ; Restore frame buffer layout
                                    ; \ i  @parm1 = cursor YX position
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.copy.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        b     @hook.keyscan.bounce  ; Back to editor main                                    




*---------------------------------------------------------------
* Delete code block
********|*****|*********************|**************************
edkey.action.block.delete:
        ;-------------------------------------------------------
        ; Exit early if nothing to do
        ;-------------------------------------------------------
        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edkey.action.block.delete.exit
                                    ; Yes, exit early
        ;-------------------------------------------------------
        ; Delete
        ;-------------------------------------------------------
        bl    @pane.errline.hide    ; Hide error message if visible

        clr   @parm1                ; Display message "Deleting block...."
        bl    @edb.block.delete     ; Delete code block
                                    ; \ i  @parm1    = Display message Yes/No
                                    ; / o  @outparm1 = >ffff if success
        ;-------------------------------------------------------
        ; Reposition in frame buffer
        ;-------------------------------------------------------
        c     @outparm1,@w$0000     ; Delete skipped?        
        jeq   edkey.action.block.delete.exit
                                    ; If yes, exit early        

        mov   @fb.topline,@parm1
        b     @_edkey.goto.fb.toprow
                                    ; Position on top row in frame buffer
                                    ; \ i  @parm1 = Line to display as top row
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.delete.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Move code block
********|*****|*********************|**************************
edkey.action.block.move:
        ;-------------------------------------------------------
        ; Exit early if nothing to do
        ;-------------------------------------------------------
        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edkey.action.block.move.exit
                                    ; Yes, exit early
        ;-------------------------------------------------------
        ; Delete
        ;-------------------------------------------------------
        bl    @pane.errline.hide    ; Hide error message if visible

        seto  @parm1                ; Set message to "Moving block..."
        bl    @edb.block.copy       ; Copy code block
                                    ; \ i  @parm1    = Message flag
                                    ; / o  @outparm1 = >ffff if success

        seto  @parm1                ; Don't display delete message
        bl    @edb.block.delete     ; Delete code block
                                    ; \ i  @parm1    = Display message Yes/No
                                    ; / o  @outparm1 = >ffff if success
        ;-------------------------------------------------------
        ; Reposition in frame buffer
        ;-------------------------------------------------------
        c     @outparm1,@w$0000     ; Delete skipped?        
        jeq   edkey.action.block.delete.exit
                                    ; If yes, exit early        

        mov   @fb.topline,@parm1
        b     @_edkey.goto.fb.toprow
                                    ; Position on top row in frame buffer
                                    ; \ i  @parm1 = Line to display as top row
                                    ; /        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.move.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Goto marker M1
********|*****|*********************|**************************
edkey.action.block.goto.m1:
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   edkey.action.block.goto.m1.exit
                                    ; Yes, exit early
        ;-------------------------------------------------------
        ; Goto marker M1
        ;-------------------------------------------------------
        mov   @edb.block.m1,@parm1   
        dec   @parm1                ; Base 0 offset 

        b     @edkey.action.goto    ; Goto specified line in editor bufer
                                    ; \ i @parm1 = Target line in EB
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.goto.m1.exit:  
        b     @hook.keyscan.bounce  ; Back to editor main
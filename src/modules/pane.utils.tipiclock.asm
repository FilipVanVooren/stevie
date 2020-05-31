* FILE......: pane.utils.tipiclock.asm
* Purpose...: Stevie Editor - TIPI Clock

*//////////////////////////////////////////////////////////////
*              Stevie Editor - TIPI Clock
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.action.tipi.clock
* Read tipi clock and display in bottom line
***************************************************************
* bl  @pane.action.tipi.clock
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.action.tipi.clock:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Read DV80 file
        ;-------------------------------------------------------
        li    tmp0,fdname.clock    
        mov   tm0,@parm1            ; Pointer to length-prefixed 'PI.CLOCK'

        li    tmp0,_pane.action.tipi.clock.callback.noop
        mov   tmp0,@parm2           ; Register callback 1
        mov   tmp0,@parm3           ; Register callback 2
        mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)

        li    tmp0,_pane.action.tipi.clock.callback.datetime
        mov   tmp0,@parm4           ; Register callback 3

        bl    @fh.file.read.sams    ; Read specified file with SAMS support
                                    ; \ i  parm1 = Pointer to length prefixed 
                                    ; |            file descriptor
                                    ; | i  parm2 = Pointer to callback
                                    ; |            "loading indicator 1"
                                    ; | i  parm3 = Pointer to callback
                                    ; |            "loading indicator 2"
                                    ; | i  parm4 = Pointer to callback
                                    ; |            "loading indicator 3"
                                    ; | i  parm5 = Pointer to callback 
                                    ; /            "File I/O error handler"

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.tipi.clock.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* _pane.action.tipi.clock.callback.noop
* Dummy callback function
***************************************************************
* bl @_pane.action.tipi.clock.callback.noop
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from _pane.action.tipi.clock
*--------------------------------------------------------------
_pane.action.tipi.clock.loadfile.callback.noop:
        bl    *r11                  ; Return to caller


***************************************************************
* _pane.action.tipi.clock.callback.datetime
* Display clock in bottom status line
***************************************************************
* bl @_pane.action.tipi.clock.callback.datetime
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from _pane.action.tipi.clock
*--------------------------------------------------------------
_pane.action.tipi.clock.loadfile.callback.datetime:
        bl    *r11                  ; Return to caller

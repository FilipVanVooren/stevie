* FILE......: edkey.cmdb.mov.asm
* Purpose...: Actions for movement keys in command buffer pane.

*---------------------------------------------------------------
* Cursor left
********|*****|*********************|**************************
edkey.action.cmdb.left:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0       
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        mov   @cmdb.column,tmp0     ; \ Left boundary (X=3) reached 
        ci    tmp0,3                ; /
        jeq   !                     ; yes, skip further processing
        ;-------------------------------------------------------
        ; Update cursor position
        ;-------------------------------------------------------
        dec   @cmdb.column          ; Column-- in command buffer
        dec   @cmdb.cursor          ; Column-- CMDB cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor right
********|*****|*********************|**************************
edkey.action.cmdb.right:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; \ Get length of command line input
                                    ; | i   @cmdb.cmd = Pointer to prompt
                                    ; / o   @outparm1 = Length of prompt

        mov   @outparm1,tmp0        ; \
        inct  tmp0                  ; / Add offset (X+3) 
        c     @cmdb.column,tmp0     ; Right boundary reached? 
        jgt   !                     ; column > length line + offset? 
        ;-------------------------------------------------------
        ; Update cursor position
        ;-------------------------------------------------------
        inc   @cmdb.column          ; Column++ in command buffer
        inc   @cmdb.cursor          ; Column++ CMDB cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor home
********|*****|*********************|**************************
edkey.action.cmdb.home:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Update cursor position
        ;-------------------------------------------------------
        li    tmp0,3                ; X=3
        mov   tmp0,@cmdb.column     ; First column
        movb  @cmdb.cursor,tmp0     ; Get CMDB cursor Y position
        mov   tmp0,@cmdb.cursor     ; Set new YX position for cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0        
        b     @edkey.keyscan.hook.debounce 
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor end of line
********|*****|*********************|**************************
edkey.action.cmdb.end:
        ;-------------------------------------------------------
        ; Update cursor position
        ;-------------------------------------------------------
        bl    @cmdb.cmd.cursor_eol  ; Repositon cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
        b     @edkey.keyscan.hook.debounce 
                                    ; Back to editor main

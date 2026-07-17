* FILE......: edk.fb.mov.hscroll.asm
* Purpose...: Horizontal scroll current page in editor buffer

*---------------------------------------------------------------
* Scroll left
*---------------------------------------------------------------
edk.act.scroll.left: 
        mov   @fb.vwco,tmp0
        ci    tmp0,16
        jgt   !
        ;-------------------------------------------------------
        ; Reset View Window Column Offset
        ;-------------------------------------------------------
        clr   tmp0                  ; Reset view window column offset
        clr   @parm1        
        jmp   _edk.act.scroll  ; Scroll
        ;-------------------------------------------------------
        ; Scroll left
        ;-------------------------------------------------------
!       ai    tmp0,-16              ; Scroll left
        mov   tmp0,@parm1           ; View Window Column offset

        li    tmp0,16               ; Temporary constant
        c     @fb.column,@w$0040    ; column > 64 ?
        jlt   _edk.act.scroll
        ;-------------------------------------------------------
        ; Update cursor X position
        ;-------------------------------------------------------
        a     tmp0,@fb.column       ; Column in screen buffer
        a     tmp0,@wyx             ; VDP Cursor
        a     tmp0,@fb.current
        jmp   _edk.act.scroll  ; Call internal scroll method


*---------------------------------------------------------------
* Scroll right
*---------------------------------------------------------------
edk.act.scroll.right:
        mov   @fb.vwco,tmp0
        ci    tmp0,175
        jlt   !
        ;-------------------------------------------------------
        ; Reset View Window Column Offset
        ;-------------------------------------------------------
        clr   tmp0                  ; Reset view window column offset
        clr   @parm1
        jmp   _edk.act.scroll  ; Scroll
        ;-------------------------------------------------------
        ; Scroll right
        ;-------------------------------------------------------
!       ai    tmp0,16               ; Scroll right
        mov   tmp0,@parm1           ; View Window Column offset

        li    tmp0,16               ; Temporary constant
        c     @fb.column,tmp0
        jlt   _edk.act.scroll
        ;-------------------------------------------------------
        ; Update cursor X position
        ;-------------------------------------------------------
        s     tmp0,@fb.column       ; Column in screen buffer
        s     tmp0,@wyx             ; VDP Cursor
        s     tmp0,@fb.current

*---------------------------------------------------------------
* Internal scroll method
*---------------------------------------------------------------
_edk.act.scroll:
        ;-------------------------------------------------------
        ; Scroll
        ;-------------------------------------------------------
        bl    @fb.hscroll           ; \ Horizontal scroll frame buffer window
                                    ; / @parm1 = View Window Column offset
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
_edk.act.scroll.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

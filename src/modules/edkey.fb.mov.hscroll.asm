* FILE......: edkey.fb.mov.hscroll.asm
* Purpose...: Horizontal scroll current page in editor buffer

*---------------------------------------------------------------
* Scroll right
*---------------------------------------------------------------
edkey.action.scroll.right:
        mov   @fb.vwco,tmp0
        ci    tmp0,240
        jlt   !

        ;-------------------------------------------------------
        ; Reset View Window Column Offset
        ;-------------------------------------------------------
        clr   tmp0                  ; Reset view window column offset
        jmp   edkey.action.scroll.right.vwco
!       ai    tmp0,20               ; Scroll right
        ;-------------------------------------------------------
        ; Set view window column offset
        ;-------------------------------------------------------
edkey.action.scroll.right.vwco:
        mov   tmp0,@fb.vwco         ; Save value

        seto  @fb.status.dirty      ; Trigger refresh of status lines
        seto  @fb.dirty             ; Trigger refresh

        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.scroll.right.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

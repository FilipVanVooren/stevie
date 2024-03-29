* FILE......: edkey.fb.tabs.asm
* Purpose...: Actions for moving to tab positions in frame buffer pane.

*---------------------------------------------------------------
* Cursor on previous tab
*---------------------------------------------------------------
edkey.action.fb.tab.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        bl    @fb.tab.prev          ; Jump to previous tab position on line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edkey.action.fb.tab.prev.exit:
        mov   *stack+,r11           ; Pop r11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor on next tab
*---------------------------------------------------------------
edkey.action.fb.tab.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        bl    @fb.tab.next          ; Jump to next tab position on line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edkey.action.fb.tab.next.exit:
        mov   *stack+,r11           ; Pop r11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

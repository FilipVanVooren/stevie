* FILE......: edkey.fb.tabs.asm
* Purpose...: Actions for moving to tab positions in frame buffer pane.

*---------------------------------------------------------------
* Cursor on next tab
*---------------------------------------------------------------
edkey.action.fb.tab.next:
         bl  @fb.tab.next           ; Jump to next tab position on line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edkey.action.fb.tab.next.exit:
        jmp  $

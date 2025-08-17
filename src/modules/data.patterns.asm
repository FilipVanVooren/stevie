* FILE......: data.patterns.asm
* Purpose...: Character definitions sprites & characters

;--------------------------------------------------------------
; Sprite patterns
;--------------------------------------------------------------
cursors:
        byte  >1c,>1c,>1c,>1c,>1c,>1c,>1c,>00 ; Cursor
        byte  >00,>01,>03,>07,>07,>03,>01,>00 ; Current line indicator    <
        byte  >1c,>08,>00,>00,>00,>00,>00,>00 ; Current column indicator  v

;--------------------------------------------------------------
; Character patterns
;--------------------------------------------------------------
patterns:
        data  >0000,>0000,>ff00,>0000 ; 01. Single line (top)
        data  >F0F0,>C0C0,>C0C0,>F0F0 ; 02. Marker [
        data  >3C3C,>0C0C,>0C0C,>3C3C ; 03. Marker ]
        
patterns.box:
        data  >0000,>0000,>ff80,>8080 ; 04. Top left corner
        data  >0000,>0000,>ff04,>ff04 ; 05. Top right corner
        data  >8080,>8080,>8080,>8080 ; 06. Left vertical single line
        data  >0404,>0404,>0404,>0404 ; 07. Right vertical single line
        data  >8080,>8080,>8080,>ff00 ; 08. Bottom left corner
        data  >0404,>0404,>0404,>ff00 ; 09. Bottom right corner
        data  >0000,>0000,>0000,>ff00 ; 10. Single line (bottom)
        data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner


patterns.cr:
        data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
        data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow


alphalock:
        data  >ffc0,>8894,>9c94,>c0ff ; 14. alpha lock down - char1
        data  >fc0c,>4444,>4474,>0cfc ; 15. alpha lock down - char2


vertline:
        data  >1010,>1010,>1010,>1010 ; 16. Vertical line
        data  >0000,>0030,>3030,>3030 ; 17. Tab indicator


low.digits:                           ; digits 1-4 (18-21)
        byte >00,>00,>00,>10,>30,>10,>10,>38
        byte >00,>00,>00,>38,>08,>38,>20,>38
        byte >00,>00,>00,>38,>08,>38,>08,>38
        byte >00,>00,>00,>28,>28,>38,>08,>08
                                      ; digits 5-8 (22-25)
        byte >00,>00,>00,>38,>20,>38,>08,>38
        byte >00,>00,>00,>38,>20,>38,>28,>38
        byte >00,>00,>00,>38,>08,>10,>20,>20
        byte >00,>00,>00,>38,>28,>38,>28,>38

cursor: data  >007f,>7f7f,>7f7f,>7f7f ; 26. Cursor
arrow:  data  >0000,>0010,>08fc,>0810 ; 27. Arrow
hline:  data  >00ff,>0000,>0000,>0000 ; 28. Key marker
lock:   data  >0070,>8888,>F8F8,>D8F8 ; 29. Lock
        data  >0000,>0000,>0000,>0000 ; 30. FREE

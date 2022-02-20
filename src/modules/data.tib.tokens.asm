* FILE......: data.tib.tokens.asm
* Purpose...: TI Basic tokens


***************************************************************
*                      TI Basic tokens
***************************************************************

;-----------------------------------------------------------------------
; Command tokens
;-----------------------------------------------------------------------
tk.00   byte   >00,3,'R','U','N'
        even
tk.01   byte   >01,3,'N','E','W'
        even
tk.02   byte   >02,3,'C','O','N'
        even
tk.02l  byte   >02,8,'C','O','N','T','I','N','U','E'
        even
tk.03   byte   >03,4,'L','I','S','T'
        even
tk.04   byte   >04,3,'B','Y','E'
        even
tk.05   byte   >05,3,'N','U','M'
        even
tk.05l  byte   >05,6,'N','U','M','B','E','R'
        even
tk.06   byte   >06,3,'O','L','D'
        even
tk.07   byte   >07,3,'R','E','S'
        even
tk.07l  byte   >07,10,'R','E','S','E','Q','U','E','N','C','E'
        even
tk.08   byte   >08,4,'S','A','V','E'
        even
tk.09   byte   >09,4,'E','D','I','T'
        even
;-----------------------------------------------------------------------
; Program tokens
;-----------------------------------------------------------------------
tk.81   byte   >81,5,' ','E','L','S','E'
        even
tk.84   byte   >84,2,'I','F'
        even
tk.85   byte   >85,2,'G','O'
        even
tk.86   byte   >86,4,'G','O','T','O'
        even
tk.87   byte   >87,5,'G','O','S','U','B'
        even
tk.88   byte   >88,6,'R','E','T','U','R','N'
        even
tk.89   byte   >89,3,'D','E','F'
        even
tk.8a   byte   >8A,3,'D','I','M'
        even
tk.8b   byte   >8B,3,'E','N','D'
        even
tk.8c   byte   >8C,3,'F','O','R'
        even
tk.8d   byte   >8D,3,'L','E','T'
        even
tk.8e   byte   >8E,5,'B','R','E','A','K'
        even
tk.8f   byte   >8F,7,'U','N','B','R','E','A','K'
        even
tk.90   byte   >90,5,'T','R','A','C','E'
        even
tk.91   byte   >91,7,'U','N','T','R','A','C','E'
        even
tk.92   byte   >92,5,'I','N','P','U','T'
        even
tk.93   byte   >93,4,'D','A','T','A'
        even
tk.94   byte   >94,7,'R','E','S','T','O','R','E'
        even
tk.95   byte   >95,9,'R','A','N','D','O','M','I','Z','E'
        even
tk.96   byte   >96,4,'N','E','X','T'
        even
tk.97   byte   >97,4,'R','E','A','D'
        even
tk.98   byte   >98,4,'S','T','O','P'
        even
tk.99   byte   >99,6,'D','E','L','E','T','E'
        even
tk.9a   byte   >9A,3,'R','E','M'
        even
tk.9b   byte   >9B,2,'O','N'
        even
tk.9c   byte   >9C,5,'P','R','I','N','T'
        even
tk.9d   byte   >9D,4,'C','A','L','L'
        even
tk.9e   byte   >9E,6,'O','P','T','I','O','N'
        even
tk.9f   byte   >9F,4,'O','P','E','N'
        even
tk.a0   byte   >A0,5,'C','L','O','S','E'
        even
tk.a1   byte   >A1,3,'S','U','B'
        even
tk.a2   byte   >A2,7,'D','I','S','P','L','A','Y'
        even
tk.b0   byte   >B0,5,' ','T','H','E','N'
        even
tk.b1   byte   >B1,3,' ','T','O'
        even
tk.b2   byte   >B2,5,' ','S','T','E','P'
        even
tk.b3   byte   >B3,1,','
        even
tk.b4   byte   >B4,1,';'
        even
tk.b5   byte   >B5,1,':'
        even
tk.b6   byte   >B6,1,')'
        even
tk.b7   byte   >B7,1,'('
        even
tk.b8   byte   >B8,1,'&'
        even
tk.be   byte   >BE,1,'='
        even
tk.bf   byte   >BF,1,'<'
        even
tk.c0   byte   >C0,1,'>'
        even
tk.c1   byte   >C1,1,'+'
        even
tk.c2   byte   >C2,1,'-'
        even
tk.c3   byte   >C3,1,'*'
        even
tk.c4   byte   >C4,1,'/'
        even
tk.c5   byte   >C5,1,'^'
        even
tk.c7   byte   >C7,1,34                ; Quote character
        even
tk.c8   byte   >C8,1,' '
        even
tk.c9   byte   >C9,1,' '
        even
tk.ca   byte   >CA,3,'E','O','F'
        even
tk.cb   byte   >CB,3,'A','B','S'
        even
tk.cc   byte   >CC,3,'A','T','N'
        even
tk.cd   byte   >CD,3,'C','O','S'
        even
tk.ce   byte   >CE,3,'E','X','P'
        even
tk.cf   byte   >CF,3,'I','N','T'
        even
tk.d0   byte   >D0,3,'L','O','G'
        even
tk.d1   byte   >D1,3,'S','G','N'
        even
tk.d2   byte   >D2,3,'S','I','N'
        even
tk.d3   byte   >D3,3,'S','Q','R'
        even
tk.d4   byte   >D4,3,'T','A','N'
        even
tk.d5   byte   >D5,3,'L','E','N'
        even
tk.d6   byte   >D6,4,'C','H','R','$'
        even
tk.d7   byte   >D7,3,'R','N','D'
        even
tk.d8   byte   >D8,4,'S','E','G','$'
        even
tk.d9   byte   >D9,3,'P','O','S'
        even
tk.da   byte   >DA,3,'V','A','L'
        even
tk.db   byte   >DB,4,'S','T','R','$'
        even
tk.dc   byte   >DC,3,'A','S','C'
        even
tk.de   byte   >DE,3,'R','E','C'
        even
tk.f1   byte   >F1,4,'B','A','S','E'
        even
tk.f3   byte   >F3,8,'V','A','R','I','A','B','L','E'
        even
tk.f4   byte   >F4,8,'R','E','L','A','T','I','V','E'
        even
tk.f5   byte   >F5,8,'I','N','T','E','R','N','A','L'
        even
tk.f6   byte   >F6,10,'S','E','Q','U','E','N','T','I','A','L'
        even
tk.f7   byte   >F7,6,'O','U','T','P','U','T'
        even
tk.f8   byte   >F8,6,'U','P','D','A','T','E'
        even
tk.f9   byte   >F9,6,'A','P','P','E','N','D'
        even
tk.fa   byte   >FA,6,'F','I','X','E','D',' '
        even
tk.fb   byte   >FB,9,'P','E','R','M','A','N','E','N','T'
        even
tk.fc   byte   >FC,3,'T','A','B'
        even
tk.fd   byte   >FD,1,'#'
        even
tk.noop byte   >FF,1,'?'
        even
;-----------------------------------------------------------------------
; Token index command mode
;-----------------------------------------------------------------------
tki.00  data   tk.00               ; RUN
tki.01  data   tk.01               ; NEW
tki.02  data   tk.02               ; CON
tki.02l data   tk.02l              ; CONTINUE
tki.03  data   tk.03               ; LIST
tki.04  data   tk.04               ; BYE
tki.05  data   tk.05               ; NUM
tki.05l data   tk.05l              ; NUMBER
tki.06  data   tk.06               ; OLD
tki.07  data   tk.07               ; RES
tki.07l data   tk.07l              ; RESEQUENCE
tki.08  data   tk.08               ; SAVE
tki.09  data   tk.09               ; EDIT
;-----------------------------------------------------------------------
; Token index program statement
;-----------------------------------------------------------------------
tki.80  data   tk.noop             ;
tki.81  data   tk.81               ; ELSE
tki.82  data   tk.noop             ;
tki.83  data   tk.noop             ;
tki.84  data   tk.84               ; IF
tki.85  data   tk.85               ; GO
tki.86  data   tk.86               ; GOTO
tki.87  data   tk.87               ; GOSUB
tki.88  data   tk.88               ; RETURN
tki.89  data   tk.89               ; DEF
tki.8a  data   tk.8a               ; DIM
tki.8b  data   tk.8b               ; END
tki.8c  data   tk.8c               ; FOR
tki.8d  data   tk.8d               ; LET
tki.8e  data   tk.8e               ; BREAK
tki.8f  data   tk.8f               ; UNBREAK
tki.90  data   tk.90               ; TRACE
tki.91  data   tk.91               ; UNTRACE
tki.92  data   tk.92               ; INPUT
tki.93  data   tk.93               ; DATA
tki.94  data   tk.94               ; RESTORE
tki.95  data   tk.95               ; RANDOMIZE
tki.96  data   tk.96               ; NEXT
tki.97  data   tk.97               ; READ
tki.98  data   tk.98               ; STOP
tki.99  data   tk.99               ; DELETE
tki.9a  data   tk.9a               ; REM
tki.9b  data   tk.9b               ; ON
tki.9c  data   tk.9c               ; PRINT
tki.9d  data   tk.9d               ; CALL
tki.9e  data   tk.9e               ; OPTION
tki.9f  data   tk.9f               ; OPEN
tki.a0  data   tk.a0               ; CLOSE
tki.a1  data   tk.a1               ; SUB
tki.a2  data   tk.a2               ; DISPLAY
tki.a3  data   tk.noop             ;
tki.a4  data   tk.noop             ;
tki.a5  data   tk.noop             ;
tki.a6  data   tk.noop             ;
tki.a7  data   tk.noop             ;
tki.a8  data   tk.noop             ;
tki.a9  data   tk.noop             ;
tki.aa  data   tk.noop             ;
tki.ab  data   tk.noop             ;
tki.ac  data   tk.noop             ;
tki.ad  data   tk.noop             ;
tki.ae  data   tk.noop             ;
tki.af  data   tk.noop             ;
tki.b0  data   tk.b0               ; THEN
tki.b1  data   tk.b1               ; TO
tki.b2  data   tk.b2               ; STEP
tki.b3  data   tk.b3               ; ,
tki.b4  data   tk.b4               ; ;
tki.b5  data   tk.b5               ; :
tki.b6  data   tk.b6               ; )
tki.b7  data   tk.b7               ; (
tki.b8  data   tk.b8               ; &
tki.b9  data   tk.noop             ;
tki.ba  data   tk.noop             ;
tki.bb  data   tk.noop             ;
tki.bc  data   tk.noop             ;
tki.bd  data   tk.noop             ;
tki.be  data   tk.be               ; =
tki.bf  data   tk.bf               ; <
tki.c0  data   tk.c0               ; >
tki.c1  data   tk.c1               ; +
tki.c2  data   tk.c2               ; -
tki.c3  data   tk.c3               ; *
tki.c4  data   tk.c4               ; /
tki.c5  data   tk.c5               ; ^
tki.c6  data   tk.noop             ;
tki.c7  data   tk.c7               ; Quoted string
tki.c8  data   tk.c8               ; Unquoted string
tki.c9  data   tk.c9               ; Line number
tki.ca  data   tk.ca               ; EOF
tki.cb  data   tk.cb               ; ABS
tki.cc  data   tk.cc               ; ATN
tki.cd  data   tk.cd               ; COS
tki.ce  data   tk.ce               ; EXP
tki.cf  data   tk.cf               ; INT
tki.d0  data   tk.d0               ; LOG
tki.d1  data   tk.d1               ; SGN
tki.d2  data   tk.d2               ; SIN
tki.d3  data   tk.d3               ; SQR
tki.d4  data   tk.d4               ; TAN
tki.d5  data   tk.d5               ; LEN
tki.d6  data   tk.d6               ; CHAR$
tki.d7  data   tk.d7               ; RND
tki.d8  data   tk.d8               ; SEG$
tki.d9  data   tk.d9               ; POS
tki.da  data   tk.da               ; VAL
tki.db  data   tk.db               ; STR$
tki.dc  data   tk.dc               ; ASC
tki.dd  data   tk.noop             ;
tki.de  data   tk.de               ; REC
tki.df  data   tk.noop             ;
tki.e0  data   tk.noop             ;
tki.e1  data   tk.noop             ;
tki.e2  data   tk.noop             ;
tki.e3  data   tk.noop             ;
tki.e4  data   tk.noop             ;
tki.e5  data   tk.noop             ;
tki.e6  data   tk.noop             ;
tki.e7  data   tk.noop             ;
tki.e8  data   tk.noop             ;
tki.e9  data   tk.noop             ;
tki.ea  data   tk.noop             ;
tki.eb  data   tk.noop             ;
tki.ec  data   tk.noop             ;
tki.ed  data   tk.noop             ;
tki.ee  data   tk.noop             ;
tki.ef  data   tk.noop             ;
tki.f0  data   tk.noop             ;
tki.f1  data   tk.f1               ; BASE
tki.f2  data   tk.noop             ;
tki.f3  data   tk.f3               ; VARIABLE
tki.f4  data   tk.f4               ; RELATIVE
tki.f5  data   tk.f5               ; INTERNAL
tki.f6  data   tk.f6               ; SEQUENTIAL
tki.f7  data   tk.f7               ; OUTPUT
tki.f8  data   tk.f8               ; UPDATE
tki.f9  data   tk.f9               ; APPEND
tki.fa  data   tk.fa               ; FIXED
tki.fb  data   tk.fb               ; PERMANENT
tki.fc  data   tk.fc               ; TAB
tki.fd  data   tk.fd               ; #
tki.fe  data   tk.noop             ;
tki.ff  data   tk.noop             ; <NOOP>

tib.tokenindex equ tki.80
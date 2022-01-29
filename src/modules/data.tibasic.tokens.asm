* FILE......: data.tibasic.tokens.asm
* Purpose...: TI Basic tokens


***************************************************************
*                      TI Basic tokens
***************************************************************

;-----------------------------------------------------------------------
; Command mode tokens
;-----------------------------------------------------------------------
tk.00   byte   >00,3,'R','U','N'
tk.01   byte   >01,3,'N','E','W'
tk.02   byte   >02,3,'C','O','N'
tk.02l  byte   >02,8,'C','O','N','T','I','N','U','E'
tk.03   byte   >03,4,'L','I','S','T'
tk.04   byte   >04,3,'B','Y','E'
tk.05   byte   >05,3,'N','U','M'
tk.05l  byte   >05,6,'N','U','M','B','E','R'
tk.06   byte   >06,3,'O','L','D'
tk.07   byte   >07,3,'R','E','S'
tk.07l  byte   >07,10,'R','E','S','E','Q','U','E','N','C','E'
tk.08   byte   >08,4,'S','A','V','E'
tk.09   byte   >09,4,'E','D','I','T'


;-----------------------------------------------------------------------
; Program statement tokens
;-----------------------------------------------------------------------
tk.81   byte   >81,4,'E','L','S','E'
tk.84   byte   >84,2,'I','F'
tk.85   byte   >85,2,'G','O'
tk.86   byte   >86,4,'G','O','T','O'
tk.87   byte   >87,5,'G','O','S','U','B'
tk.88   byte   >88,6,'R','E','T','U','R','N'
tk.89   byte   >89,3,'D','E','F'
tk.8a   byte   >8A,3,'D','I','M'
tk.8b   byte   >8B,3,'E','N','D'
tk.8c   byte   >8C,3,'F','O','R'
tk.8d   byte   >8D,3,'L','E','T'
tk.8e   byte   >8E,5,'B','R','E','A','K'
tk.8f   byte   >8F,7,'U','N','B','R','E','A','K'
tk.90   byte   >90,5,'T','R','A','C','E'
tk.91   byte   >91,7,'U','N','T','R','A','C','E'
tk.92   byte   >92,5,'I','N','P','U','T'
tk.93   byte   >93,4,'D','A','T','A'
tk.94   byte   >94,7,'R','E','S','T','O','R','E'
tk.95   byte   >95,9,'R','A','N','D','O','M','I','Z','E'
tk.96   byte   >96,4,'N','E','X','T'
tk.97   byte   >97,4,'R','E','A','D'
tk.98   byte   >98,4,'S','T','O','P'
tk.99   byte   >99,6,'D','E','L','E','T','E'
tk.9a   byte   >9A,3,'R','E','M'
tk.9b   byte   >9B,2,'O','N'
tk.9c   byte   >9C,5,'P','R','I','N','T'
tk.9d   byte   >9D,4,'C','A','L','L'
tk.9e   byte   >9E,6,'O','P','T','I','O','N'
tk.9f   byte   >9F,4,'O','P','E','N'
tk.a0   byte   >A0,5,'C','L','O','S','E'
tk.a1   byte   >A1,3,'S','U','B'
tk.a2   byte   >A2,7,'D','I','S','P','L','A','Y'
tk.b0   byte   >B0,4,'T','H','E','N'
tk.b1   byte   >B1,2,'T','O'
tk.b2   byte   >B2,4,'S','T','E','P'
tk.b3   byte   >B3,1,','
tk.b4   byte   >B4,1,';'
tk.b5   byte   >B5,1,':'
tk.b6   byte   >B6,1,')'
tk.b7   byte   >B7,1,'('
tk.b8   byte   >B8,1,'&'
tk.be   byte   >BE,1,'='
tk.bf   byte   >BF,1,'<'
tk.c0   byte   >C0,1,'>'
tk.c1   byte   >C1,1,'+'
tk.c2   byte   >C2,1,'-'
tk.c3   byte   >C3,1,'*'
tk.c4   byte   >C4,1,'/'
tk.c5   byte   >C5,1,'^'
tk.c7   byte   >C7,1,'*'
tk.c8   byte   >C8,0,'#'
tk.c9   byte   >C9,0,''
tk.ca   byte   >CA,3,'E','O','F'
tk.cb   byte   >CB,3,'A','B','S'
tk.cc   byte   >CC,3,'A','T','N'
tk.cd   byte   >CD,3,'C','O','S'
tk.ce   byte   >CE,3,'E','X','P'
tk.cf   byte   >CF,3,'I','N','T'
tk.d0   byte   >D0,3,'L','O','G'
tk.d1   byte   >D1,3,'S','G','N'
tk.d2   byte   >D2,3,'S','I','N'
tk.d3   byte   >D3,3,'S','Q','R'
tk.d4   byte   >D4,3,'T','A','N'
tk.d5   byte   >D5,3,'L','E','N'
tk.d6   byte   >D6,4,'C','H','R','$'
tk.d7   byte   >D7,3,'R','N','D'
tk.d8   byte   >D8,4,'S','E','G','$'
tk.d9   byte   >D9,3,'P','O','S'
tk.da   byte   >DA,3,'V','A','L'
tk.db   byte   >DB,4,'S','T','R','$'
tk.dc   byte   >DC,3,'A','S','C'
tk.de   byte   >DE,3,'R','E','C'
tk.f1   byte   >F1,4,'B','A','S','E'
tk.f3   byte   >F3,8,'V','A','R','I','A','B','L','E'
tk.f4   byte   >F4,8,'R','E','L','A','T','I','V','E'
tk.f5   byte   >F5,8,'I','N','T','E','R','N','A','L'
tk.f6   byte   >F6,10,'S','E','Q','U','E','N','T','I','A','L'
tk.f7   byte   >F7,6,'O','U','T','P','U','T'
tk.f8   byte   >F8,6,'U','P','D','A','T','E'
tk.f9   byte   >F9,6,'A','P','P','E','N','D'
tk.fa   byte   >FA,5,'F','I','X','E','D'
tk.fb   byte   >FB,9,'P','E','R','M','A','N','E','N','T'
tk.fc   byte   >FC,3,'T','A','B'
tk.fd   byte   >FD,1,'#'


;-----------------------------------------------------------------------
; Token index
;-----------------------------------------------------------------------
tki.00  byte   >00,tk.00
tki.01  byte   >01,tk.01
tki.02  byte   >02,tk.02
tki.02l byte   >02,tk.02l
tki.03  byte   >03,tk.03
tki.04  byte   >04,tk.04
tki.05  byte   >05,tk.05
tki.05l byte   >05,tk.05l
tki.06  byte   >06,tk.06
tki.07  byte   >07,tk.07
tki.08  byte   >08,tk.08
tki.09  byte   >09,tk.09
tki.81  byte   >81,tk.81
tki.84  byte   >84,tk.84
tki.85  byte   >85,tk.85
tki.86  byte   >86,tk.86
tki.87  byte   >87,tk.87
tki.88  byte   >88,tk.88
tki.89  byte   >89,tk.89
tki.8a  byte   >8A,tk.8a
tki.8b  byte   >8B,tk.8b
tki.8c  byte   >8C,tk.8c
tki.8d  byte   >8D,tk.8d
tki.8e  byte   >8E,tk.8e
tki.8f  byte   >8F,tk.8f
tki.90  byte   >90,tk.90
tki.91  byte   >91,tk.91
tki.92  byte   >92,tk.92
tki.93  byte   >93,tk.93
tki.94  byte   >94,tk.94
tki.95  byte   >95,tk.95
tki.96  byte   >96,tk.96
tki.97  byte   >97,tk.97
tki.98  byte   >98,tk.98
tki.99  byte   >99,tk.99
tki.9a  byte   >9A,tk.9a
tki.9b  byte   >9B,tk.9b
tki.9c  byte   >9C,tk.9c
tki.9d  byte   >9D,tk.9d
tki.9e  byte   >9E,tk.9e
tki.9f  byte   >9F,tk.9f
tki.a0  byte   >A0,tk.a0
tki.a1  byte   >A1,tk.a1
tki.a2  byte   >A2,tk.a2
tki.b0  byte   >B0,tk.b0
tki.b1  byte   >B1,tk.b1
tki.b2  byte   >B2,tk.b2
tki.b3  byte   >B3,tk.b3
tki.b4  byte   >B4,tk.b4
tki.b5  byte   >B5,tk.b5
tki.b6  byte   >B6,tk.b6
tki.b7  byte   >B7,tk.b7
tki.b8  byte   >B8,tk.b8
tki.be  byte   >BE,tk.be
tki.bf  byte   >BF,tk.bf
tki.c0  byte   >C0,tk.c0
tki.c1  byte   >C1,tk.c1
tki.c2  byte   >C2,tk.c2
tki.c3  byte   >C3,tk.c3
tki.c4  byte   >C4,tk.c4
tki.c5  byte   >C5,tk.c5
tki.c7  byte   >C7,tk.c7
tki.c8  byte   >C8,tk.c8
tki.c9  byte   >C9,tk.c9
tki.ca  byte   >CA,tk.ca
tki.cb  byte   >CB,tk.cb
tki.cc  byte   >CC,tk.cc
tki.cd  byte   >CD,tk.cd
tki.ce  byte   >CE,tk.ce
tki.cf  byte   >CF,tk.cf
tki.d0  byte   >D0,tk.d0
tki.d1  byte   >D1,tk.d1
tki.d2  byte   >D2,tk.d2
tki.d3  byte   >D3,tk.d3
tki.d4  byte   >D4,tk.d4
tki.d5  byte   >D5,tk.d5
tki.d6  byte   >D6,tk.d6
tki.d7  byte   >D7,tk.d7
tki.d8  byte   >D8,tk.d8
tki.d9  byte   >D9,tk.d9
tki.da  byte   >DA,tk.da
tki.db  byte   >DB,tk.db
tki.dc  byte   >DC,tk.dc
tki.de  byte   >DE,tk.de
tki.f1  byte   >F1,tk.f1
tki.f3  byte   >F3,tk.f3
tki.f4  byte   >F4,tk.f4
tki.f5  byte   >F5,tk.f5
tki.f6  byte   >F6,tk.f6
tki.f7  byte   >F7,tk.f7
tki.f8  byte   >F8,tk.f8
tki.f9  byte   >F9,tk.f9
tki.fa  byte   >FA,tk.fa
tki.fb  byte   >FB,tk.fb
tki.fc  byte   >FC,tk.fc
tki.fd  byte   >FD,tk.fd
;-----------------------------------------------------------------------
; Master token index
;-----------------------------------------------------------------------
token.index:
        byte   >00,>09,tki.00
        byte   >81,>9f,tki.81
        data   >a0,>cf,tki.a0
        data   >d0,>fd,tki.d0
        data   eol
* FILE......: jbasic.asm
* Purpose...: Stevie Editor - Jackalope Basic interpreter

* Author: Alex Johnson (compuwiz@gmail.com)

**************************************************************************************************

* To add a new keyword, add to STABLE or FTABLE, reduce TSYS, insert at end of either statement or
*    function tokens, and insert in same position in keyword table and either KEYWRD or KEYARG
* Statement address table
STABLE DATA SSYS
       DATA SCLR
       DATA SNEW
       DATA SLIST
       DATA SRUN
       DATA SGOTO
       DATA SGOSUB
       DATA SRETUR
       DATA SEND
       DATA SIF
       DATA SFOR
       DATA SNEXT
       DATA SPRINT
       DATA SINPUT
       DATA SGET
       DATA SDPOKE
       DATA SVPOKE
       DATA SPOKE
       DATA SLOAD
       DATA SSAVE
       DATA SREM
       DATA SWAIT
       DATA SCHAR
       DATA SCLEAR
       DATA SCOLOR
       DATA SLOCAT
       DATA SSCREE
       DATA SINIT
       DATA SMAGNI
       DATA SSPRIT
       DATA SJOYST
       DATA SSOUND
       DATA SNOISE
       DATA SLET    ; represents 27 tokens: A-Z, @
* numeric, expression, NOT, DPEEK(, VPEEK(, PEEK(, RND, LEN(, STR$(, VAL(, ASC( are part of LET
       DATA SINCRE  ; represents 26 tokens: A-Z
       DATA SDECRE  ; represents 26 tokens: A-Z
* Function address table
FTABLE DATA FEQUAL
       DATA FUNEQU
       DATA FGREQU
       DATA FLTEQU
       DATA FGREAT
       DATA FLESST
       DATA FADD
       DATA FSUB
       DATA FMULT
       DATA FDIV
       DATA FMOD
       DATA FPOWER
       DATA FBWAND
       DATA FBWXOR
       DATA FBWOR
       DATA FSHIFT
* Statement token values
TSYS   EQU >71
TCLR   EQU TSYS+1
TNEW   EQU TCLR+1
TLIST  EQU TNEW+1
TRUN   EQU TLIST+1
TGOTO  EQU TRUN+1
TGOSUB EQU TGOTO+1
TRETUR EQU TGOSUB+1
TEND   EQU TRETUR+1
TIF    EQU TEND+1
TFOR   EQU TIF+1
TNEXT  EQU TFOR+1
TPRINT EQU TNEXT+1
TINPUT EQU TPRINT+1
TGET   EQU TINPUT+1
TDPOKE EQU TGET+1
TVPOKE EQU TDPOKE+1
TPOKE  EQU TVPOKE+1
TLOAD  EQU TPOKE+1
TSAVE  EQU TLOAD+1
TREM   EQU TSAVE+1
TWAIT  EQU TREM+1
TCHAR  EQU TWAIT+1
TCLEAR EQU TCHAR+1
TCOLOR EQU TCLEAR+1
TLOCAT EQU TCOLOR+1
TSCREE EQU TLOCAT+1
TINIT  EQU TSCREE+1
TMAGNI EQU TINIT+1
TSPRIT EQU TMAGNI+1
TJOYST EQU TSPRIT+1
TSOUND EQU TJOYST+1
TNOISE EQU TSOUND+1
VARAT  EQU 26   ; position of @ in TLET and also number of variables
TDEC   EQU >0100-VARAT   ; special token placeholder for 26 variables
TINC   EQU TDEC-VARAT    ; special token placeholder for 26 variables
TLET   EQU TINC-VARAT-1  ; special token placeholder for 26 variables and @
*                         TLET+VARAT overloaded to call SLET but also handle @=, @+, @-
* Function token values
TEQUAL EQU TNOISE+1
TUNEQU EQU TEQUAL+1
TGTEQU EQU TUNEQU+1
TLTEQU EQU TGTEQU+1
TGREAT EQU TLTEQU+1
TLESST EQU TGREAT+1
TADD   EQU TLESST+1
TSUB   EQU TADD+1
TMULT  EQU TSUB+1
TDIV   EQU TMULT+1
TMOD   EQU TDIV+1
TPOWER EQU TMOD+1
TBWAND EQU TPOWER+1
TBWXOR EQU TBWAND+1
TBWOR  EQU TBWXOR+1
TSHIFT EQU TBWOR+1
* Other token values
TTO    EQU TSHIFT+1  ; part of FOR, LIST
TTHEN  EQU TTO+1     ; part of IF
TSTEP  EQU TTHEN+1   ; part of FOR
TCHR   EQU TSTEP+1   ; part of PRINT
TNOT   EQU TCHR+1    ; part of LET
TDPEEK EQU TNOT+1    ; part of LET
TVPEEK EQU TDPEEK+1  ; part of LET
TPEEK  EQU TVPEEK+1  ; part of LET
TRND   EQU TPEEK+1   ; part of LET
TLEN   EQU TRND+1    ; part of LET
TSTR   EQU TLEN+1    ; part of PRINT
TVAL   EQU TSTR+1    ; part of LET
TASC   EQU TVAL+1    ; part of LET
TADDR  EQU TASC+1
TCONST EQU TADDR+1
TLAST  EQU TCONST
* Keyword table
* Statement keywords: should use -'text' but Asm994a has a bug with -
*                     so must use explicit inversion of last character
*                     if R14 LT then NEG R14
KSYS   TEXT 'SY'     ; -'SYS'
       BYTE >FF-'S'
KCLR   TEXT 'CL'     ; -'CLR'
       BYTE >FF-'R'
KNEW   TEXT 'NE'     ; -'NEW'
       BYTE >FF-'W'
KLIST  TEXT 'LIS'    ; -'LIST'
       BYTE >FF-'T'
KRUN   TEXT 'RU'     ; -'RUN'
       BYTE >FF-'N'
KGOTO  TEXT 'GOT'    ; -'GOTO'
       BYTE >FF-'O'
KGOSUB TEXT 'GOSU'   ; -'GOSUB'
       BYTE >FF-'B'
KRETUR TEXT 'RETUR'  ; -'RETURN'
       BYTE >FF-'N'
KEND   TEXT 'EN'     ; -'END'
       BYTE >FF-'D'
KIF    TEXT 'I'      ; -'IF'
       BYTE >FF-'F'
KFOR   TEXT 'FO'     ; -'FOR'
       BYTE >FF-'R'
KNEXT  TEXT 'NEX'    ; -'NEXT'
       BYTE >FF-'T'
KPRINT TEXT 'PRIN'   ; -'PRINT'
       BYTE >FF-'T'
KINPUT TEXT 'INPU'   ; -'INPUT'
       BYTE >FF-'T'
KGET   TEXT 'GE'     ; -'GET'
       BYTE >FF-'T'
KDPOKE TEXT 'DPOK'   ; -'DPOKE'
       BYTE >FF-'E'
KVPOKE TEXT 'VPOK'   ; -'VPOKE'
       BYTE >FF-'E'
KPOKE  TEXT 'POK'    ; -'POKE'
       BYTE >FF-'E'
KLOAD  TEXT 'LOA'    ; -'LOAD'
       BYTE >FF-'D'
KSAVE  TEXT 'SAV'    ; -'SAVE'
       BYTE >FF-'E'
KREM   TEXT 'RE'     ; -'REM'
       BYTE >FF-'M'
KWAIT  TEXT 'WAI'    ; -'WAIT'
       BYTE >FF-'T'
KCHAR  TEXT 'CHA'    ; -'CHAR'
       BYTE >FF-'R'
KCLEAR TEXT 'CLEA'   ; -'CLEAR'
       BYTE >FF-'R'
KCOLOR TEXT 'COLO'   ; -'COLOR'
       BYTE >FF-'R'
KLOCAT TEXT 'LOCAT'  ; -'LOCATE'
       BYTE >FF-'E'
KSCREE TEXT 'SCREE'  ; -'SCREEN'
       BYTE >FF-'N'
KINIT  TEXT 'INI'   ; -'INIT'
       BYTE >FF-'T'
KMAGNI TEXT 'MAGNIF'  ; -'MAGNIFY'
       BYTE >FF-'Y'
KSPRIT TEXT 'SPRIT'  ; -'SPRITE'
       BYTE >FF-'E'
KJOYST TEXT 'JOYSTIC'  ; -'JOYSTICK'
       BYTE >FF-'K'
KSOUND TEXT 'SOUN'   ; -'SOUND'
       BYTE >FF-'D'
KNOISE TEXT 'NOIS'   ; -'NOISE'
       BYTE >FF-'E'
* Function keywords
KEQUAL TEXT ''       ; -'='
       BYTE >FF-'='
KUNEQU TEXT '<'      ; -'<>'
       BYTE >FF-'>'
KGTEQU TEXT '>'      ; -'>='
       BYTE >FF-'='
KLTEQU TEXT '<'      ; -'<='
       BYTE >FF-'='
KGREAT TEXT ''       ; -'>'
       BYTE >FF-'>'
KLESST TEXT ''       ; -'<'
       BYTE >FF-'<'
KADD   TEXT ''       ; -'+'
       BYTE >FF-'+'
KSUB   TEXT ''       ; -'-'
       BYTE >FF-'-'
KMULT  TEXT ''       ; -'*'
       BYTE >FF-'*'
KDIV   TEXT ''       ; -'/'
       BYTE >FF-'/'
KMOD   TEXT ''       ; -'%'
       BYTE >FF-'%'
KPOWER TEXT ''       ; -'^'
       BYTE >FF-'^'
KBWAND TEXT 'AN'     ; -'AND'
       BYTE >FF-'d'
KBWXOR TEXT 'XO'     ; -'XOR'
       BYTE >FF-'r'
KBWOR  TEXT 'O'      ; -'OR'
       BYTE >FF-'R'
KSHIFT TEXT 'SHIF'   ; -'SHIFT'
       BYTE >FF-'T'
* Other keywords
KTO    TEXT 'T'      ; -'TO'
       BYTE >FF-'O'
KTHEN  TEXT 'THE'    ; -'THEN'
       BYTE >FF-'N'
KSTEP  TEXT 'STE'    ; -'STEP'
       BYTE >FF-'P'
KCHR   TEXT 'CHR$'   ; -'CHR$(
       BYTE >FF-'('
KNOT   TEXT 'NO'     ; -'NOT'
       BYTE >FF-'T'
KDPEEK TEXT 'DPEEK'  ; -'DPEEK('
       BYTE >FF-'('
KVPEEK TEXT 'VPEEK'  ; -'VPEEK('
       BYTE >FF-'('
KPEEK  TEXT 'PEEK'   ; -'PEEK('
       BYTE >FF-'('
KRND   TEXT 'RN'     ; -'RND'
       BYTE >FF-'D'
KLEN   TEXT 'LEN'    ; -'LEN('
       BYTE >FF-'('
KSTR   TEXT 'STR$'   ; -'STR$('
       BYTE >FF-'('
KVAL   TEXT 'VAL'    ; -'VAL('
       BYTE >FF-'('
KASC   TEXT 'ASC'    ; -'ASC('
       BYTE >FF-'('
KADDR  BYTE >FF-'@'  ; -'@'
       BYTE 0
       EVEN
KEYWRD DATA KSYS,KCLR,KNEW,KLIST,KRUN,KGOTO,KGOSUB,KRETUR,KEND
       DATA KIF,KFOR,KNEXT,KPRINT,KINPUT,KGET,KDPOKE,KVPOKE
       DATA KPOKE,KLOAD,KSAVE,KREM,KWAIT,KCHAR,KCLEAR,KCOLOR
       DATA KLOCAT,KSCREE,KINIT,KMAGNI,KSPRIT,KJOYST,KSOUND,KNOISE
KEYARG DATA KEQUAL,KUNEQU,KGTEQU,KLTEQU,KGREAT,KLESST
       DATA KADD,KSUB,KMULT,KDIV,KMOD,KPOWER
       DATA KBWAND,KBWXOR,KBWOR,KSHIFT,KTO,KTHEN,KSTEP
       DATA KCHR,KNOT,KDPEEK,KVPEEK,KPEEK,KRND,KLEN,KSTR,KVAL,KASC,KADDR
KEYEND

R0 EQU 0
R1 EQU 1
R2 EQU 2
R3 EQU 3
R4 EQU 4
R5 EQU 5
R6 EQU 6
R7 EQU 7
R8 EQU 8
R9 EQU 9
R10 EQU 10
R11 EQU 11
R12 EQU 12
R13 EQU 13
R14 EQU 14
R15 EQU 15

* start EXECUTION --------------------------------------
GETSTT CI R14,TSYS*>0100
       JL GETSTE          ; 00-70: unassigned (error)
       CI R14,TDEC*>0100
       JL GETST1
       LI R11,SDECRE      ; E6-FF -> E6: decrement
       JMP DOSTMT
GETST1 CI R14,TINC*>0100
       JL GETST2
       LI R11,SINCRE      ; CC-E5 -> CC: increment
       JMP DOSTMT
GETST2 CI R14,TLET*>0100
       JL GETST3
       LI R11,SLET        ; B2-CB -> B2: let
       JMP DOSTMT
*      fall through       ; 71-B1: literal statements
* look up statement address from table
GETST3 LI R15,TSYS*>0100
       MOV R14,R12        ; never operate on R14 since the low byte must remain 00 at all times
       SB R15,R12         ; R14=R14-R15 (current token minus first token)
       SWPB R12           ; put result in lower byte
       A R12,R12          ; double result (2 bytes per table entry)
       MOV @STABLE(R12),R11  ; R11=*(STABLE+2*R12) (address of statement is R12th word in statement table)
DOSTMT B *R11             ; all statements will branch to NXTSTT at the end so no need for BL
GETSTE B @SYNERR
* all statements branch here
NXTSTT BL @CHKCLR         ; check if CLEAR/FN4/break key is pressed
       JNE NXTST0
       LI R3,BREAK        ; CLEAR/FN4/break key pressed
       BL @PRTNEG
       B @NXTCMD
NXTST0 BL @CHKEND         ; check if EOS/EOL (GETVC includes implicit CHRGET)
       JEQ GETSTE         ; if 0/not at end marker then syntax error
       CI R14,':'*>0100
       JNE NXTST1
       BL @CHRGET         ; advance past colon
       JMP GETSTT
* if not colon then must be null for end of line
NXTST1 MOV @CURLIN,R10    ; R10 points to current line table entry's line number location
       C R10,@LINTOP
       JEQ NXTST2         ; if already at top, don't update
       AI R10,LTESIZ      ; move to start of next entry
       MOV R10,@CURLIN
NXTST2 INCT R10           ; R10 points to current line table entry's pointer location
       MOV *R10,R10       ; update TXTPTR to new line pointer value
       DEC R10            ; backup for CHRGET
       BL @CHRGET         ; preload character for GETSTT (skipping leading spaces)
       C @CURLIN,@LINTOP  ; see if program ended
       JNE GETSTT         ; if not (current <> top) then get next statement
NXTRDY LI R3,READY
       BL @PRTNEG         ; print READY message
NXTCMD BL @LINGET         ; wait for something to be typed
       CLR R14
       MOVB R14,@LINBUF(R9)  ; insert null at end of input
       LI R1,CENTER
       BL @CHROUT         ; print blank line
       MOV R9,R9          ; set flags based on input length
       JEQ NXTCMD         ; wait for something to be typed
* fall through to tokenize an input line
* 1. default line number -1, process line number if present (stash in TEMPF4 until done)
* 2. process statement
* 3. process other text until : or null, if : then 2, if null then done
TOKIZE SETO R12           ; default line number is -1
       LI R10,LINBUF-1    ; work on line input buffer
       BL @CHRGET         ; advance to first non-space character
       MOV R10,R5
       BL @ATOI           ; get the number if present
* must set R9 after ATOI since ATOI clobbers them
       LI R9,VDPBUF       ; output tokenized line into VDP buffer (not needed for screen work during this stage)
       C R5,R10
       JEQ TOKSTT
       MOV R8,R12         ; use the new line number
       JLT TOKER1         ; if negative line number entered then SYNTAX ERROR
       MOV R5,R10         ; continue tokenizing after line number
       MOVB *R10,R14      ; this code skips one optional space after the line number
       CI R14,CSPACE
       JNE TOKSTT
       INC R10
TOKSTT MOVB *R10,R14      ; advance to the next character (do not use CHRGET since it skips spaces)
       JEQ TOKDEL         ; if end of line encountered and nothing but space so far then delete line
TOKST0 CLR R15            ; entry point for "THEN statement" to avoid deleting line if statement is empty
       CI R14,CSPACE
       JNE TOKST1
       MOVB R14,*R9+      ; copy spaces
       INC R10
       JMP TOKSTT         ; then look for arguments
TOKST1 CLR R0             ; setup "saw LET keyword" flag
       CLR @TEMPF2        ; setup "statement is LET" flag
       CLR @TEMPF3        ; setup "last token was LET" flag
       CI R14,'?'*>0100
       JNE TOKL
       LI R6,TPRINT       ; ? becomes PRINT token
       MOV R10,R4
       INC R4             ; advance to next input buffer location
       JMP TOKST7         ; save character and check for arguments
TOKER1 JMP TOKERR         ; tokenize routine too large, need intermediate jump point
TOKL   MOV R10,R4         ; special case LET statement because it is not in the keyword table
       INC R4
       CI R14,'L'*>0100
       JNE TOKST2
       MOVB *R4+,R15
       CI R15,'E'*>0100
       JNE TOKST2
       MOVB *R4+,R15
       CI R15,'T'*>0100
       JNE TOKST2
       MOV R4,R10         ; keyword=LET, advance input pointer to end of word
       DEC R10            ; backup so CHRGET works properly
       BL @CHRGET         ; keyword=LET, advance input pointer skipping spaces
       DEC R0             ; mark LET flag
TOKST2 LI R7,'A'
       CI R14,'Z'*>0100
       JH TOKERR          ; if above Z then SYNTAX ERROR
       CI R14,'@'*>0100
       JL TOKERR          ; if below @ then SYNTAX ERROR
       JEQ TOKADR         ; if exactly @ then special case for address
       INC R10          **
       MOV R14,R8
       SWPB R8
       S R7,R8            ; R8 contains variable index
       MOVB *R10,R15      ; peek at next character
       CI R15,'-'*>0100
       JEQ TOKDEC         ; if letter- then DECREMENT token
       CI R15,'+'*>0100
       JEQ TOKINC         ; if letter+ then INCREMENT token
       CI R15,'='*>0100
       JEQ TOKLET         ; if letter= then LET token
       DEC R10            ; otherwise backup to start of word and look for a statement keyword
       CLR R6             ; R6 is index into keyword table
       LI R5,KEYWRD       ; R5 is pointer into keyword table (R5=KEYWRD+2*R6, inc R6, inct R5)
TOKST3 MOV R10,R4         ; work from a copy so we can repeat comparisons
       MOV *R5,R3         ; get the pointer out of the table
TOKST4 MOVB *R3,R15
       JLT TOKST6         ; if negative then this is the last letter of a keyword
       CB *R4+,*R3+
       JEQ TOKST4         ; if same then do another comparison
TOKST5 INC R6             ; if not same then advance to next word
       INCT R5            ; advance to next pointer
       CI R5,KEYARG
       JEQ TOKERR         ; if past last statement then SYNTAX ERROR
       JMP TOKST3         ; if more keywords then check the next one
TOKST6 INV R15            ; flip last character to compare
       CB *R4+,R15
       JNE TOKST5
* keyword matched on keyword number R6!
       AI R6,TSYS
TOKST7 MOV R0,R0          ; set flags
       JLT TOKERR         ; if "saw LET keyword" flag is negative then SYNTAX ERROR
       SWPB R6            ; R6 now contains the token value in high byte
       MOVB R6,*R9+       ; insert token into tokenized line and advance tokenized line pointer
       MOV R4,R10         ; advance input buffer
* insert special case for REM here
       CI R6,TREM*>0100
       JNE TOKARG         ; else look for arguments
TOKREM MOVB *R10+,*R9+    ; if REM then copy until null
       JNE TOKREM
       DEC R10
       CLR R14
       B @TOKEND          ; reached end of line (R10/R14 need to be on the null)
       JMP TOKARG        
TOKADR LI R6,TLET+26
       INC R0             ; unmark "saw LET keyword" flag
       MOV R10,R4
       INC R4
       JMP TOKST7         ; finish up like any other statement
TOKDEC LI R6,TDEC
       JMP TOKVAR
TOKINC LI R6,TINC
       JMP TOKVAR
TOKLET LI R6,TLET
       DEC @TEMPF2        ; set "current statement is LET" flag
       DEC @TEMPF3        ; set "last token was LET" flag
       INC R0             ; unmark "saw LET keyword" flag
TOKVAR A R8,R6            ; add the variable index to the base token for LET/INC/DEC
       MOV R10,R4
       INC R4
       JMP TOKST7         ; finish up like any other statement
TOKDEL MOV R12,R2         ; line number in arg
       BL @FINDLN         ; search for the line number in the line table
       C R2,*R9           ; check if this line exists
       JNE TOKDE2         ; if not then no need to delete
       MOV @LINTOP,R3     ; stop address
       MOV R9,R8
       AI R8,LTESIZ       ; advance to next entry
TOKDE1 MOV *R8+,*R9+      ; copy line number
       MOV *R8+,*R9+      ; copy code pointer
       C R8,R3            ; done when source is higher than old LINTOP, ie old LINTOP was copied
       JLE TOKDE1
       AI R3,-LTESIZ      ; move LINTOP down by 1 table entry
       MOV R3,@LINTOP     ; save result
TOKDE2 B @NXTCMD          ; when done deleting get a new command
TOKERR B @SYNERR

TOKARG 
TOKAR0 MOVB *R10,R14
       JNE TOKAR1
       MOVB R14,*R9+      ; copy null
       JMP TOKEND         ; done with line
TOKAR1 CI R14,':'*>0100
       JNE TOKAR2
       MOVB *R10+,*R9+    ; copy colon and advance
       B @TOKSTT          ; look for next statement (too far to jump)
TOKAR2 CI R14,CSPACE
       JNE TOKAR3
       MOVB *R10+,*R9+    ; copy space
       JMP TOKARG         ; look for next arg
TOKAR3 LI R15,'"'*>0100
       CB R14,R15
       JNE TOKAR4
TOKQU1 MOVB *R10+,*R9+    ; copy character
       MOVB *R10,R14      ; read next character
       JEQ TOKQU2
       CB R14,R15
       JNE TOKQU1         ; if not closing quote or end of line then repeat
TOKQU2 DEC R9             ; back up to last character
       MOVB *R9,R8        ; re-read
       INV R8             ; flip
       MOVB R8,*R9+       ; write back and advance
       CB *R10,R15        ; was last character a quote?
       JNE TOKARG         ; if not then it was a null, do not increment line pointer
       INC R10            ; move past closing quote
       JMP TOKARG         ; look for next arg
TOKAR4 CI R14,'0'*>0100
       JL TOKAR5
       CI R14,'9'*>0100
       JH TOKAR5
* this is a TCONST
TOKNUM MOV R9,R15         ; preserve tokenized line pointer across call to ATOI
       MOV R10,R5
       BL @ATOI           ; read number at R5 into R8 (destroys R0-9)
       MOV R15,R9         ; reinstate pointer
       LI R15,TCONST*>0100
       MOVB R15,*R9+      ; TCONST
       MOVB R8,*R9+       ; constant high byte
       SWPB R8
       MOVB R8,*R9+       ; constant low byte
       MOV R5,R10         ; advance to end of number
       CLR @TEMPF3        ; clear "last token was LET" flag
       JMP TOKAR0         ; look for next arg
TOKAR5 CI R14,'-'*>0100
       JNE TOKAR7
       MOVB @TEMPF2,@TEMPF2  ; check "current statement is LET" flag
       JEQ TOKNUM         ; all other statements, this must be a negative constant
       MOVB @TEMPF3,@TEMPF3  ; check "last token was LET" flag
       JEQ TOKAR7         ; any other token, this must be an operator
       INC R10
       MOVB *R10,R15      ; peek ahead at next character
       CI R15,'0'*>0100
       JL TOKAR6          ; if not a digit, this must be an operator
       CI R15,'9'*>0100
       JH TOKAR6          ; if not a digit, this must be an operator
       DEC R10            ; backup to the negative sign
       JMP TOKNUM         ; treat as a negative constant
TOKAR6 DEC R10            ; fixup pointer from peeking ahead

* if we get this far it is time to check if this is a keyword (including operator symbols)
TOKAR7 LI R6,TEQUAL-TSYS  ; R6 is index into keyword table
       LI R5,KEYARG       ; R5 is pointer into keyword table (R5=KEYWRD+2*R6, inc R6, inct R5)
TOKFN1 MOV R10,R4         ; work from a copy so we can repeat comparisons
       MOV *R5,R3         ; get the pointer out of the table
TOKFN2 MOVB *R3,R15
       JLT TOKFN4         ; if negative then this is the last letter of a keyword
       CB *R4+,*R3+
       JEQ TOKFN2         ; if same then do another comparison
TOKFN3 INC R6             ; if not same then advance to next word
       INCT R5            ; advance to next pointer
       CI R5,KEYEND
       JEQ TOKSAV         ; if past last keyword then copy character
       JMP TOKFN1         ; if more keywords then check the next one
TOKFN4 INV R15            ; flip last character to compare
       CB *R4+,R15
       JNE TOKFN3
* keyword matched on keyword number R6!
       AI R6,TSYS
       SWPB R6            ; R6 now contains the token value in high byte
       MOVB R6,*R9+       ; insert token into tokenized line and advance tokenized line pointer
       CLR @TEMPF3        ; clear "last token was LET" flag
       CI R6,TSUB*>0100
       JNE TOKFN5         ; if token is not operator minus then skip setting the flag
       DEC @TEMPF3        ; set "last token was LET or operator minus" flag
TOKFN5 MOV R4,R10         ; advance input buffer
       CI R6,TTHEN*>0100
       JNE TOKARG         ; normal argument, look for next arg
       DEC R10            ; backup so CHRGET works
       BL @CHRGET         ; skip spaces
       CI R14,'9'*>0100
       JLE TOKNUM         ; THEN argument is a number
       B @TOKST0          ; THEN argument is a statement
TOKSAV CLR @TEMPF3        ; clear "last token was TLET or TSUB" flag
       MOVB *R10+,*R9+    ; copy character
       JMP TOKAR0         ; look for next arg

* R9 contains end of tokenized string, length=R9-VDPBUF, save *(LINTOP+2)+length for next LINTOP addr
* check if new LINTOP addr is positive for Out Of Memory Error
* then copy from VDPBUF to *(LINTOP+2)
* then look for line number in lintab
* if -1 then execute
* if not found then insert by copying lintab up 4 bytes and updating LINTOP
* write to lintab, go back to NXTCMD to get another input
* R3=old LINTOP
* R7=new code end pointer, R8=tokenized length, R9=tokenized end pointer
TOKEND LI R7,VDPBUF       ; calculate length and end pointers
       MOV R7,R5
       MOV R9,R8
       S R7,R8
       MOV R8,@TEMPF1     ; stash line length for later use in line table entry
       MOV @LINTOP,R7
       MOV R7,R3
       INCT R7
       MOV *R7,R7
       MOV R7,R6
       A R8,R7
       C R7,@MEMTOP       ; address lower than or equal to MEMTOP then good, otherwise out of memory
       JL TOKND0
       B @OOMERR
TOKND0 INC R8             ; add 1 because we have to stop when reaching 0 and won't copy the last byte
TOKND1 MOVB *R5+,*R6+     ; R5=tokenized line pointer, R6=code pointer
       DEC R8             ; count down bytes
       JNE TOKND1         ; copy again unless a null was copied
       MOV R12,R12        ; set flags
       JLT TOKIMM         ; execute line as immediate without changing line table
       MOV R12,R2         ; line number to arg
       BL @FINDLN         ; search for the line number in the line table
       C R2,*R9
       JEQ TOKREP         ; if new line number was found in the line table no need to make space for it
       MOV @LINTOP,R4
       CI R4,>4000
       JNE TOKND2         ; if old LINTOP is not >4000 then good, otherwise out of memory
TOKOOM B @OOMERR
* move (LINTOP+4 downto R9) up one line table entry
TOKND2 C *R4+,*R4+        ; shorthand to quickly add 4 to R4 (include the code pointer and length)
TOKND3 MOV *R4,@LTESIZ(R4)
       DECT R4
       C R4,R9
       JHE TOKND3         ; less or equal because decrement happens after copy
       MOV @LINTOP,R1
       AI R1,LTESIZ
       MOV R1,@LINTOP     ; advance LINTOP 1 entry because we inserted an entry
       MOV R1,@CURLIN     ; if we added a line CURLIN was on LINTOP until we moved it, so update
* replace current line table entry with new line info
TOKREP MOV R2,*R9+        ; set line number of entry
       MOV @LINTOP,R1     ; new LINTOP
       INCT R1            ; point at the code pointer of LINTOP
       MOV *R1,*R9+       ; set code pointer of entry
       MOV R7,*R1         ; set new code pointer of LINTOP
       MOV @TEMPF1,*R9    ; set line length of entry
       B @NXTCMD          ; go back to get a new input line
* execute immediate
TOKIMM MOV R3,@CURLIN     ; set current line to the -1 line after the program (same as LINTOP)
       INCT R3            ; advance to code pointer
       MOV *R3,R10        ; set TXTPTR
       DEC R10            ; backup for CHRGET
       BL @CHRGET         ; preload character for GETSTT (skipping leading spaces)
       B @GETSTT          ; start executing

       
* All Statements
* switch to new workspace pointer and call machine language at addr
SSYS   BL @GETVC
       LI R4,SYSWS
       BLWP R4            ; R4=workspace pointer, R5=branch target set by GETVC
       B @NXTSTT
* set all variables to 0
SCLR   SETO R2         ; Default MEMTOP
       BL @CHRGET
       BL @CHKEND
       JNE SCLRDO      ; if no argument do CLR with the default MEMTOP
       DEC R10         ; backup one character so GETVC can see it
       BL @GETVC
       INV R5          ; invert value gives correct MEMTOP (-value + 1)
       MOV R5,R2
       MOV @LINTOP,R3  ; check next free address (*[LINTOP+2]) is not higher than new MEMTOP
       INCT R3
       C R2,*R3
       JLE TOKOOM      ; if lower or equal then out of memory error and do not change MEMTOP
SCLRDO MOV R2,@MEMTOP  ; set new MEMTOP
       CLR R0
       LI R1,NXTLBL-VARS
CLRVAR MOV R0,@VARS-2(R1)
       DECT R1
       JNE CLRVAR
*       BL @CHRGET
       B @NXTSTT
* clear all program lines
SNEW   CLR R14
       LI R10,TXTBOT
       LI R2,LINBOT
       SETO R3
       MOV R14,*R10    ; put terminator at start of program lines
       MOV R2,@CURLIN
       MOV R2,@LINTOP  ; point current line pointer and top of line pointers to bottom
       MOV R3,*R2      ; -1 for first line number (interactive)
       MOV R10,@2(R2)  ; TXTBOT for first code pointer
       MOV R14,@4(R2)  ; zero length of line -1
       B @NXTSTT
* display all or part of program code to screen
SLIST  CLR R2          ; default start line number 0
       LI R8,32767     ; default end line number 32767
       BL @CHRGET
       BL @CHKEND
       JNE LISTDO      ; if no arguments then start listing (default form = all lines)
       CI R14,TTO*>0100  ; was TSUB but tokenizer couldn't produce desired lines
       JEQ LISTEB      ; if leading -/TO then skip to getting end line number
       DEC R10         ; backup one character so GETVC can see it
       BL @GETVC
       MOV R5,R2       ; set start line number to first argument
       MOV R5,R8       ; set end line number to first argument
       BL @CHKEND
       JNE LISTDO      ; if no more arguments then start listing (single line)
       CI R14,TTO*>0100  ; was TSUB but tokenizer couldn't produce desired lines
       BL @CHRGET      ; check next character after -/TO
       BL @CHKEND
       JEQ LISTEA      ; if -/TO end then back up and get end line liumber
       LI R8,32767     ; if start-/TO then use default end line number
       JMP LISTDO      ; and start listing (start-)
* if this isn't the end then there is an end line
LISTEA DEC R10         ; backup one character so GETVC can see it
LISTEB BL @GETVC
       MOV R5,R8       ; set end line number to second argument and fall through to start listing (-end or start-end)
* do the actual listing, only after we get the list arguments, R2=start, R8=end
LISTDO MOV R10,*R13    ; backup current program location to stack
       MOV R2,@TEMPF4  ; save start/end line numbers since all the registers are in use
       MOV R8,@TEMPF5
       LI R8,LINBOT    ; start at first line
LISTL  BL @CHKCLR      ; check if CLEAR/FN4/break key is pressed
       JNE LISTL1
       LI R3,BREAK     ; CLEAR/FN4/break key pressed
       BL @PRTNEG
       B @NXTCMD
LISTL1 MOV *R8+,R5     ; get line number
       MOV *R8+,R10    ; set TXTPTR to this line
       INCT R8         ; skip line length
       MOV R5,R5       ; set flags
       JLT LISTD1      ; if negative line number then list is done
       C R5,@TEMPF4
       JLT LISTL       ; if current line number < start line number then go to next line
       C R5,@TEMPF5
       JGT LISTD1      ; if current line number > end line number then list is done
       BL @PRTNUM      ; convert the number to a string and print it
       LI R1,CSPACE    ; print a space and fall through to printing the contents of the line
       BL @CHROUT
LISTC  MOVB *R10+,R14  ; get the character
       JEQ LIST0       ; if end of line
       CI R14,TDEC*>0100
       JHE LIST1       ; if variable decrement
       CI R14,TINC*>0100
       JHE LIST2       ; if variable increment
       CI R14,TLET*>0100
       JHE LIST3       ; if LET
       CI R14,TCONST*>0100
       JEQ LIST4       ; if number constant
       CI R14,TSYS*>0100
       JHE LIST5       ; if other token
       CI R14,'"'*>0100
       JEQ LIST6       ; if quote mode
       MOV R14,R1      ; otherwise print the character exactly and move to next character
       BL @CHROUT
       JMP LISTC
LISTD1 JMP LISTDN      ; intermediate hop because SLIST is too long
LIST0  MOV R8,R12      ; preserve R8/9 across CHROUT of tab and enter
       MOV R9,R15
       LI R1,CENTER    ; print newline and go to next line
       BL @CHROUT
       MOV R15,R9
       MOV R12,R8
       JMP LISTL
LIST1  LI R15,TDEC*>0100
       MOV R14,R1
       SB R15,R1       ; R1h contains variable number
       AI R1,'A'*>0100  ; R1h contains variable letter
       BL @CHROUT      ; print it
       LI R1,'-'*>0100  ; print minus sign
       BL @CHROUT
       JMP LISTC       ; go to the next character
LIST2  LI R15,TINC*>0100
       MOV R14,R1
       SB R15,R1       ; R1h contains variable number
       AI R1,'A'*>0100  ; R1h contains variable letter
       BL @CHROUT      ; print it
       LI R1,'+'*>0100  ; print plus sign
       BL @CHROUT
       JMP LISTC       ; go to the next character
LIST3  LI R15,TLET*>0100
       MOV R14,R1
       SB R15,R1       ; R1h contains variable number
       CI R1,VARAT*>0100
       JNE LIST3B
       LI R1,'@'*>0100  ; force @ to print
       BL @CHROUT      ; print it
       JMP LISTC       ; don't print equals sign when displaying address LET
LIST3B AI R1,'A'*>0100  ; R1h containst variable letter
       BL @CHROUT      ; print it
       LI R1,'='*>0100  ; print equals sign
       BL @CHROUT
       JMP LISTC       ; go to the next character
LIST4  MOVB *R10+,R5    ; get high byte
       MOVB *R10+,R4    ; get low byte
       SWPB R4         ; put low byte in position
       SOC R4,R5       ; combine high and low into R5
       BL @PRTNUM      ; print it
       JMP LISTC       ; go to the next character
LIST5  LI R15,TSYS*>0100
       MOV R14,R9
       SB R15,R9       ; R9 is token number
       SWPB R9         ; move number from byte to word form
       A R9,R9         ; R9 is token offset in bytes
       MOV @KEYWRD(R9),R3  ; R3 is address of token text
       BL @PRTNEG      ; print this token
       CI R14,TREM*>0100
       JNE LISTC       ; if not REM then go to the next character, else print rest of line literally
LIST5L MOVB *R10+,R14  ; get next character of REM line
       JEQ LIST0       ; if end of line reached then go to the next line
       MOV R14,R1      ; print character literally
       BL @CHROUT
       JMP LIST5L      ; go to the next character
LIST6  MOV R14,R1      ; print the quote
       BL @CHROUT
       MOV R10,R3
       BL @PRTNEG      ; print the string up to the inverted character (inclusive)
       LI R1,'"'*>0100  ; print another quote
       BL @CHROUT
       MOV R3,R10      ; set listing position to character after end of string
       JMP LISTC       ; go to the next character
LISTDN MOV *R13,R10    ; restore program location from stack (didn't advance TOS so don't need to rewind)
       MOVB *R10,R14   ; restore current character for NXTSTT
       B @NXTSTT
* RUN/GOTO/GOSUB - use R0 for "save return on stack", src2 (R3/4/5) for destination,
* R2 is copy of R5, R9 for line table pointer, R11/12 for return addresses
* get argument (optional for RUN), find line (skipped if RUN without arg), set line pointer
* start program (at start or optionally at line number) (same as goto)
SRUN   CLR R0
       LI R13,STACK    ; RUN clears execution stack (GOTO/GOSUB do not)
       BL @CHRGET      ; look at next character
       BL @CHKEND
       JEQ RUN1
       LI R9,LINBOT    ; default args
       MOV *R9,R15     ; check if there is a program (first line number negative means no)
       JLT RUN2        ; if no program then just go back to interactive mode
       MOV R9,R15
       INCT R15
       MOV *R15,R15
       JMP GOSUB2
RUN1   DEC R10         ; need to back up if there is an argument to GETVC can see it
       JMP GOSUB1
RUN2   B @NXTRDY
* move execution to line number
SGOTO  CLR R0
       JMP GOSUB1
* save return pointer then move execution to line number
SGOSUB SETO R0
GOSUB1 BL @GETVC
       MOV R5,R2
       BL @CHKEND      ; check next character is end of statement or end of line
       JEQ GOSUBE      ; if not end of statement then SYNTAX ERROR
       BL @FINDLN
       C R2,*R9
       JNE GOUSER      ; if found line not desired line then UNDEFINED STATEMENT
       MOV R0,R0
       JEQ GOSUB2      ; skip saving on stack for all but GOSUB
       CI R13,STACK+STKSIZ-GSBSIZ
       JH GOOOM        ; if stack pointer is less than (GOSUB stack entry size) bytes from top then OUT OF MEMORY
       MOV @CURLIN,*R13+
       MOV R10,*R13+
       LI R0,TGOSUB
       MOV R0,*R13+    ; save {CURLIN,TXTPTR,TGOSUB} to stack
GOSUB2 MOV R9,@CURLIN  ; set CURLIN to point to desired line in line table
       MOV R15,R10     ; set TXTPTR to point to desired line text
       MOVB *R10,R14   ; preload first character for GETSTT
       B @GETSTT       ; since we know the new TXTPTR is not the end of line or statement, use GETSTT rather than NXTSTT
GOSUBE B @SYNERR
GOOOM  B @OOMERR
GOUSER LI R3,USMSG
       B @ERROR

* move execution to saved return pointer
* use temporary pointer to rewind the stack
* once we find the GOSUB token move everything down to replace the removed entry
SRETUR MOV R13,R15
       DECT R15
RETUR1 CI R15,STACK
       JLE RWGERR      ; if reached or passed stack base then RETURN WITHOUT GOSUB ERROR
       MOV *R15,R9     ; load from memory once
       CI R9,TGOSUB
       JEQ RETUR2      ; if GOSUB token process it
       CI R9,TFOR
       JNE RWGERR      ; if stack contains not a GOSUB or FOR then stack is corrupt
       AI R15,-12      ; if it is a FOR then back up 12 bytes (amount a FOR places on the stack)
       JMP RETUR1
RETUR2 DECT R15
       MOV *R15,R10    ; next item is TXTPTR
       DECT R15
       MOV *R15,@CURLIN  ; bottom item is CURLIN
* now we have to copy up
       AI R13,-GSBSIZ  ; move STKPTR down (GOSUB stack entry size) bytes
RETUR3 MOV @GSBSIZ(R15),*R15+  ; copy (GOSUB stack entry size) bytes above to here and advance the copy pointer
       C R15,R13
       JLE RETUR3      ; if not above the top of stack then copy more
       MOVB *R10,R14   ; prime next character
       B @NXTSTT
RWGERR LI R3,RWGMSG
       B @ERROR
* stop program, return to interactive mode
SEND   MOV @LINTOP,@CURLIN  ; CURLIN=LINTOP
*       CLR R10         ; wipe out TXTPTR (not needed)
       CLR R14         ; prep NXTSTT
       B @NXTRDY
* evaluate condition and maybe continue or jump to next line number
* Note: IF A THEN ... supported here but not in tokenizer
SIF    BL @CHRGET      ; fetch 1st parameter after the statement token
       CI R14,TNOT*>0100
       JNE IF1
* NOT numeric
       BL @GETVC
       MOV R5,R8
       INV R8
       JMP IFEVAL
IF1    CI R14,TSUB*>0100
       JNE IF2
* -numeric
       BL @GETVC
       MOV R5,R8
       NEG R8
       JMP IFEVAL
IF2    DEC R10        ; back up TXTPTR so GETVC can see the current token
       BL @GETVC
       CI R14,TTHEN*>0100
       JNE IFEXPR
* numeric
       MOV R5,R8
       JMP IFEVAL
* numeric operator numeric
IFEXPR MOV R5,R2
       MOV R14,R4
       SWPB R4         ; change from byte to word format
       LI R3,TSHIFT
       C R4,R3
       JH GOSUBE       ; operator is outside (higher) of function range
       LI R3,TEQUAL
       C R4,R3
       JL GOSUBE       ; operator is outside (lower) of function range
       S R3,R4         ; R4 = this token - first function token
       A R4,R4         ; double to reflect bytes in table entries
       MOV @FTABLE(R4),@TEMPF1  ; lookup function address and save in temp (R11/12 will be clobbered by GETVC)
       BL @GETVC       ; get final argument
       CI R14,TTHEN*>0100
       JNE GOSUBE      ; THEN keyword is expected but missing
       MOV @TEMPF1,R11
       BL *R11         ; call calculated function address
* R8 now contains the value to check, =0 condition false, <>0 condition true
IFEVAL MOV R8,R8       ; set flags
       JNE IFTRUE
       B @SREM         ; treat rest of line as comment to advance to next line
IFTRUE BL @CHRGET      ; advance past THEN keyword
       CI R14,TCONST*>0100
       JEQ IFLINE
       CI R14,TSYS*>0100
       JL IFLINE
* THEN statement(s)
       B @GETSTT       ; use GET instead of NXT since not at EOS/EOL character
* THEN line number
IFLINE DEC R10         ; back up one character so GETVC can see the current one
       B @SGOTO        ; treat rest of line as the argument of a GOTO to change lines
* initiate a new loop condition
* use temporary pointer to rewind the stack
* once we find the FOR token for this variable replace it, if we don't find then add at top
SFOR   BL @GETVC       ; get index variable
       MOV R3,R3       ; set flags
       JLT FORSYN      ; if constant then SYNTAX ERROR
       MOV R4,R7       ; move the variable address into result register position
       MOV R13,R15     ; work with a temporary copy of STKPTR
       DECT R15
FOR1   CI R15,STACK
       JLE FORTOS      ; if at or below stack base then add FOR at top of stack
       MOV *R15,R9     ; load from memory once
       CI R9,TFOR
       JEQ FOR2        ; if FOR token process it
       CI R9,TGOSUB
       JNE RWGERR      ; if stack contains not a GOSUB or FOR then stack is corrupt
       AI R15,-GSBSIZ  ; if it is a GOSUB then back up (GOSUB stack entry size) bytes
       JMP FOR1
FOR2   DECT R15        ; next on stack after FOR token is variable address
       C *R15,R7
       JEQ FORARG      ; now go get arguments for FOR entry
       AI R15,2-FORSIZ  ; if not correct FOR variable then back up (amount of FOR entry still on stack)
       JMP FOR1        ; continue to try to find the right one
FORTOS CI R13,STACK+STKSIZ-FORSIZ
       JH FOROOM       ; if stack pointer is less than (FOR entry size) bytes from top then OUT OF MEMORY
       MOV R13,R15     ; start back at top of stack
       AI R15,4-FORSIZ  ; advance so next subtraction puts us back at top of stack
FORARG AI R15,FORSIZ-4  ; back up so stack writes will exactly replace this entry
* code to read rest of line, set initial variable value, and update stack
       CI R14,TEQUAL*>0100
       JNE FORSYN      ; if = after variable missing then SYNTAX ERROR
       BL @GETVC       ; get the initial value
       MOV R5,*R7      ; update variable in memory to initial value
       CI R14,TTO*>0100
       JNE FORSYN      ; if TO after initial value missing then SYNTAX ERROR
       BL @GETVC       ; get TO value
       MOV R5,R2       ; move TO value into arg1 register position
       LI R5,1         ; set default STEP value
       CI R14,TSTEP*>0100
       JNE FORINS      ; if no STEP argument then insert this FOR on the stack
       BL @GETVC       ; get STEP value into arg2 register position
FORINS MOV @CURLIN,*R15+  ; write stack with {CURLIN, TXTPTR, STEP val, TO val, var addr, TFOR}
       MOV R10,*R15+
       MOV R5,*R15+
       MOV R2,*R15+
       MOV R7,*R15+
       LI R0,TFOR
       MOV R0,*R15+
       C R15,R13
       JLE FORRET      ; if temporary stack position is not higher that STKPTR then keep STKPTR
       MOV R15,R13     ; if higher then use the temporary value as the new one
FORRET B @NXTSTT
FORSYN B @SYNERR
FOROOM B @OOMERR
* check condition and maybe repeat
SNEXT  MOV R13,R15     ; work with a temporary copy of STKPTR
       DECT R15
NEXT1  CI R15,STACK
       JLE NEXTER      ; if at or below stack base then NEXT WITHOUT FOR ERROR
       MOV *R15,R9     ; load from memory once
       CI R9,TFOR
       JEQ NEXT2       ; if FOR token process it
       CI R9,TGOSUB
       JNE NEXTER      ; if stack contains not a GOSUB or FOR then stack is corrupt
       AI R15,-GSBSIZ  ; if it is a GOSUB then back up (GOSUB stack entry size)
       JMP NEXT1
NEXT2  DECT R15
       MOV *R15,R7     ; next on stack after FOR token is variable address
       DECT R15
       MOV *R15,R2     ; recover TO value
       DECT R15
       MOV *R15,R5     ; recover STEP value, don't take out CURLIN and TXTPTR until we know we have to
       MOV *R7,R8      ; retrieve loop variable value
       A R5,R8         ; update it
       MOV R8,*R7      ; store it back
       MOVB R5,R5      ; set flags
       JLT NEXTM
* positive step
       C R8,R2
       JGT NEXTDN      ; if positive step and current > TO then remove FOR from stack
       JMP NEXTND      ; else not done so use return to the stacked location
* negative step
NEXTM  C R8,R2
       JLT NEXTDN      ; if positive step and current < TO then remove FOR from stack
       JMP NEXTND      ; else not done so use return to the stacked location
NEXTND DECT R15
       MOV *R15,R10    ; recover TXTPTR from stack
       DECT R15
       MOV *R15,@CURLIN  ; recover CURLIN and do not update STKPTR since we aren't done with this FOR loop
       MOVB *R10,R14    ; prepare for NXTSTT
       B @NXTSTT
* now we have to copy up to remove the finished FOR entry from the stack
NEXTDN AI R13,-FORSIZ  ; move STKPTR down (FOR stack entry size)
NEXT3  MOV @FORSIZ(R15),*R15+  ; copy (FOR stack entry size) bytes above to here and advance the copy pointer
       C R15,R13
       JLE NEXT3       ; if not above the top of stack then copy more
       BL @CHRGET      ; advance off NEXT token to prepare for next statement
       B @NXTSTT
NEXTER LI R3,NWFMSG
       B @ERROR
* output numbers or strings
SPRINT MOVB R10,@ENDLIN  ; any non-zero default
PRINTR BL @CHRGET
       CLR R1
       CI R14,'"'*>0100
       JNE PRINT1
* literal string
       INC R10         ; move to next character after quote
       MOV R10,R3      ; start string here
       BL @PRTNEG      ; print a string ending with a negated end character
       MOV R3,R10      ; update TXTPTR from end of string (pointing to next after inverted character)
       DEC R10         ; backup so CHRGET takes the first character after the inverted
       JMP SPRINT      ; look for next argument
PRINT1 CI R14,TSTR*>0100
       JNE PRINT2
* string at STR$(var or value)
       BL @GETVC       ; next argument in token stream should be variable or value
       CI R14,')'*>0100
       JNE PRINTE
       MOV R5,R3
       BL @PRTNEG      ; print string pointed to by the value of the argument to STR$
       JMP SPRINT      ; look for next argument
PRINT2 CI R14,TCHR*>0100
       JNE PRINT3
* single character CHR$(var or value)
       BL @GETVC      ; next argument in token stream should be variable or value
       CI R14,')'*>0100
       JNE PRINTE
       MOV R5,R1
       SWPB R1
       BL @CHROUT     ; print the character identified by the value of the argument to CHR$
       JMP SPRINT     ; look for next argument
PRINT3 CI R14,','*>0100
       JNE PRINT5
       LI R1,CRIGHT
       BL @CHROUT     ; print tab character to advance to next tab stop on comma
       JMP SPRINT     ; look for next argument
PRINT5 CI R14,';'*>0100
       JNE PRINT6
       CLR R0
       MOVB R0,@ENDLIN  ; clear end-of-line flag
       JMP PRINTR     ; look for next argument without reseting end of line flag
PRINT6 MOV R14,R14
       JEQ PRIEND     ; null=end of line
       CI R14,':'*>0100
       JEQ PRIEND     ; colon=end of statement
       DEC R10        ; back up one character so GETVC can see the current one
       BL @GETVC      ; must be variable, numeric constant, or syntax error
       DEC R10        ; move TXTPTR back since GETVC advances it automatically
       BL @PRTNUM     ; wasn't syntax error so print number
       JMP SPRINT     ; look for next argument
PRIEND MOVB @ENDLIN,R15  ; set flags
       JEQ PRIRET
       LI R1,CENTER    ; print enter if last printed item was not semicolon
       BL @CHROUT
PRIRET B @NXTSTT
PRINTE B @SYNERR
* input a line until ENTER, store as string in address
SINPUT BL @GETVC
       BL @LINGET
       MOV R9,R9      ; set flags
       JEQ INPNUL
INPCPY MOVB *R7+,*R5+  ; copy from LINBUF to arg.value
       DEC R9
       JNE INPCPY     ; repeat until no characters
       DEC R5         ; backup to last character copied
       MOVB *R5,R8
       INV R8
       MOVB R8,*R5    ; invert it to terminate string
       B @NXTSTT
INPNUL SETO R8        ; if length was 0 put an inverted null in the string
       MOVB R8,*R5
       B @NXTSTT
* get a key, place in variable/location
SGET   BL @GETVC
       MOV R3,R6
       MOV R4,R7
       JEQ GETERR    ; if constant then syntax error
       CLR R8
       CLR @KEYDEV   ; scan from full keyboard
*       LIMI 0        ; INTERRUPT: interrupt can't be enabled when scanning keys
       BLWP @KSCAN
*       LIMI 2        ; INTERRUPT
       MOVB @KEYKEY,R8
       CI R8,>FF00
       JNE GETNEW
       CLR R8        ; replace FF with 00 (standard BASIC no key return value for GET)
       JMP GETUPD
GETNEW MOV @GPLSTS,R15  ; retrieve status register
       ANDI R15,>2000  ; new key condition bit mask
       JEQ GETUPD
       CLR R8        ; not new key, clear key pressed
GETUPD SWPB R8
       MOV R8,*R7
       B @NXTSTT
GETERR B @SYNERR
* set one byte in CPU memory to the LSB of argument
* set multiple bytes in CPU memory to string literal
SPOKE  BL @GETVC     ; get arg2
       MOV R5,R1     ; arg1addr=arg2val
       CI R14,','*>0100
       JNE POKESE    ; if next character (already loaded by GETVC) <> , then error else advance TXTPTR
       BL @CHRGET
       CI R14,'"'*>0100
       JNE POKE2
* string literal
       INC R10       ; move past quote
POKE1  MOVB *R10+,*R1+  ; copy character (including inverted terminator)
       JGT POKE1
       MOVB *R10,R14  ; prime character for NXTSTT
       JMP POKE3
POKE2  DEC R10       ; put back character so GETVC can see it
       BL @GETVC     ; get arg2
       SWPB R5       ; put LSB into MSB for byte operations
       MOVB R5,*R1   ; put LSB(arg2val) into address(arg1addr)
POKE3  B @NXTSTT
POKESE B @SYNERR
POKEIQ B @IQERR
* set one word in CPU memory to the argument
SDPOKE BL @GETVC     ; get arg2
       MOV R5,R1     ; arg1addr=arg2val
       SRC R5,1      ; test if even/odd
       JOC POKEIQ    ; if odd then ILLEGAL QUANTITY
       CI R14,','*>0100
       JNE POKESE    ; if next character (already loaded by GETVC) <> , then error else advance TXTPTR
       BL @GETVC     ; get arg2
       MOV R5,*R1    ; put arg2val into address(arg1addr)
       B @NXTSTT
* set one byte in VDP memory to the LSB of argument
SVPOKE BL @GETVC     ; get arg2
       CI R5,>4000
       JHE POKEIQ    ; if addr>16k then illegal quantity
       MOV R5,R0     ; VDPaddr=arg2val
       CI R14,','*>0100
       JNE POKESE    ; if next character (already loaded by GETVC) <> , then error else advance TXTPTR
       BL @GETVC     ; get arg2
       SWPB R5       ; put LSB into MSB for byte operations
       MOVB R5,R1
       BL @VSBW      ; put arg2val into VDP address
       B @NXTSTT

* load"filename" : load BASIC program to file
* dload"filename",start : copy file to CPU memory
* vload"filename",start : copy file to video memory
SLOAD  CLR R15       ; LOAD flag
       CLR @TEMPF2   ; clear program/data flag to DATA
       CLR @TEMPF3   ; clear load address
       BL @LSOPT     ; get filename and open file
       JNE LDHDR     ; if no more options then load the file header
       CI R14,','*>0100
       JNE POKESE    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; modifies R3,4,5 to get start address in R5
       MOV R5,@TEMPF3  ; address in TEMPF3
* perform initial read of first record
LDHDR  CLR @GPLSTS   ; always clear status before calling DSRLNK
       BLWP @DSRLNK  ; invoke device driver to read record 0
       LI R0,VDPPAB+1
       BL @VSBR      ; read device driver flags after operation
       ANDI R1,>7000  ; only look at status bits
       JNE LOADIO    ; if non-zero then report FILE IO error (other error)
* check file header
       LI R4,VDPPAB+PABSIZ  ; buffer pointer
       LI R5,>80     ; buffer left
       LI R7,15*2+BASWP  ; address of R15
       LI R8,2       ; 2 bytes for 'JB'
       BL @DSKIN
       CI R15,'J'*>0100+'B'  ; header of BASIC program files
       JEQ LOADJB    ; if JB header
       CI R15,'J'*>0100+'D'  ; header of data files
       JNE LOADIO    ; if proper header not present then report FILE IO error (wrong file type)
* data file
       LI R7,TEMPF3  ; address of TEMPF3
       MOV *R7,R0    ; check the value stored there
       JEQ LDDAT1    ; if value is zero use TEMPF3 to capture the file address
       CLR R7        ; else discard data read by writing it to ROM so TEMPF3 stays the address used
LDDAT1 LI R8,2       ; 2 bytes for start address
       BL @DSKIN
       LI R7,3*2+BASWP  ; address of R3
       LI R8,2       ; 2 bytes for file length
       BL @DSKIN
       CI R3,1
       JLT LOADIO    ; if data length < 1 then FILE I/O ERROR (file corrupt)
       MOV R3,R0     ; make a temporary copy for checks
       MOV @TEMPF3,R7  ; address in R7
       CI R7,>4000
       JL LDMEM
       CI R7,>A000
       JHE LDMEM
* load VDP
       A R7,R0
       JLT LOADIO    ; if start + length wraps 16k ( >= >8000 ) then FILE I/O ERROR (file corrupt)
       AI R7,-16384  ; adjust start address
* do loads in chunks using VDPBUF as intermediate space
LDVDP1 MOV R5,R8     ; R8 = min(buff_left,file_len)
       C R5,R3
       JL LDVDP2
       MOV R3,R8
LDVDP2 MOV R7,@TEMPF3  ; save working VDP address since DSKIN will need the CPU buffer location
       MOV R8,R15    ; make a copy of R8 since DSKIN will clear it
       S R8,R3       ; file_len left after write
       LI R7,VDPBUF  ; CPU buffer location
       BL @DSKIN     ; read record
       MOV @TEMPF3,R0  ; copy CPU buffer to VDP
       LI R1,VDPBUF
       MOV R15,R2
       BL @VMBW
       MOV R0,R7     ; R0 not modified so still contains TEMPF3/old R7
       A R15,R7      ; new R7 adds file length read
       MOV R3,R3     ; set flags on file length remaining to read
       JNE LDVDP1    ; if more data, repeat
       JMP LOADCL    ; else close file
LDMEM  A R7,R0
       JEQ LDMEM1    ; okay if last byte included (R0=0)
       C R0,R7
       JL LOADIO     ; if data start + data length wraps (is lower than data start) then ILLEGAL QUANTITY
LDMEM1 MOV R3,R8     ; full length of file in load length
       BL @DSKIN
       JMP LOADCL

LOADIO B @DSKERR
LOADSE LI R3,SYNMSG
       JMP LOADER
LOADIQ LI R3,IQMSG
LOADER LI R0,VDPPAB
       LI R1,DSRCLS
       BL @VSBW
       BLWP @DSRLNK  ; close open file (don't care about checking for errors on close)
       B @ERROR

* put code here for reading line table entry linenum, line table entry linelen, line string including null
* stop after reading linenum=-1 and setting lineptr
* set linelen=0, close file
LOADJB DEC @TEMPF2   ; set program/data flag to PROGRAM
       MOV @TEMPF3,@TEMPF3  ; set flags to check load address
       JNE LOADIO    ; if non-zero then report FILE IO error (incorrect file type for options)
       LI R7,TXTBOT
       MOV R7,@TEMPF1  ; setup for first line table entry pointer
       LI R7,LINBOT  ; setup for first line table entry
       MOV R7,R15
LOADBA LI R8,2       ; 2 bytes for line number
       BL @DSKIN     ; read line table entry line number
       MOV @TEMPF1,*R7+  ; write line table entry pointer
       SETO R8
       C *R15,R8
       JEQ LOADDN    ; if line table entry line number is -1 then done loading
       LI R8,2       ; 2 bytes for line length
       BL @DSKIN     ; read line table entry length
       MOV @2(R15),R7  ; actual line entry pointer for string
       MOV @4(R15),R8  ; actual line entry length for string
       BL @DSKIN     ; read string into memory
       MOV R7,@TEMPF1  ; set next line table entry pointer
       AI R15,LTESIZ  ; set pointer to next entry
       MOV R15,R7
       JMP LOADBA    ; repeat on next line table entry
LOADDN CLR R8
       MOV R8,@4(R15)  ; clear line table entry length of -1 line
       MOV R15,@LINTOP  ; make -1 line the top of the line table
LOADCL BL @CLOSE     ; close file and clear OPENED flag
       MOV @TEMPF2,R15  ; check program/data flag
       JEQ LOADRT
       B @SEND       ; DATA = do not try to continue running if the line table changed
LOADRT DEC R10       ; PROGRAM = backup so CHRGET works
       BL @CHRGET    ; prime NXTSTT with character
       B @NXTSTT

* save"filename" : save BASIC program to file
* save"filename",start,length : copy data memory to file
* save"filename",start,length : copy video memory to file (start in >4000->8FFF)
SSAVE  SETO R15      ; SAVE flag
       BL @LSOPT     ; get filename and open file, returns with CHKEND condition set
       JNE SAVBAS    ; if no more options then save BASIC program
       CI R14,','*>0100
       JNE LOADSE    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; modifies R3,4,5 to get start address in R5
       MOV R5,@TEMPF3    ; address in TEMPF3
       CI R14,','*>0100
       JNE LOADSE    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; modifies R3,4,5 to get length in R5
       MOV R5,R3     ; length in R3
       CI R3,>1
       JLT LOADIQ    ; if data length 0 or negative then ILLEGAL QUANTITY
       MOV @TEMPF3,R4
       A R4,R5
       JEQ SSAVE0    ; okay if last byte included (R5=0)
       C R5,R4
       JL LOADIQ     ; if data start + data length wraps (is lower than data start) then ILLEGAL QUANTITY
SSAVE0 MOV R4,R4     ; set flags on load address
       JLT SSAVE1    ; >= >8000 then not in VDP
       CI R4,>4000
       JL SSAVE1     ; < >4000 then not in VDP
       MOV R5,R5     ; set flags on final address
       JLT LOADIQ    ; if in VDP and start + length wraps 16k (>= >8000) then ILLEGAL QUANTITY
* write common header for data files
SSAVE1 LI R4,VDPPAB+PABSIZ  ; buffer pointer
       LI R5,128     ; buffer remaining
       LI R15,'J'*>0100+'D'  ; header of BASIC data files
       LI R7,15*2+BASWP  ; address of R15
       LI R8,2       ; 2 bytes for 'JD'
       BL @DSKOUT
       MOV @TEMPF3,R15   ; start address
       LI R7,15*2+BASWP  ; address of R15
       LI R8,2       ; 2 bytes for address
       BL @DSKOUT
       LI R7,3*2+BASWP  ; address of R3
       LI R8,2       ; 2 bytes for length
       BL @DSKOUT
       MOV @TEMPF3,R7    ; address in R7
*       DEC R10       ; backup so the CHRGET in SAVCLS won't miss the next character (GETVC already advanced)
* identify which memory flow to use
       CI R7,>4000
       JL SAVMEM
       CI R7,>A000
       JHE SAVMEM
* save VDP
       AI R7,-16384  ; adjust start address
* do saves in chunks using VDPBUF as intermediate space
SAVVD1 MOV R5,R8     ; R8 = min(buff_left,file_len)
       C R5,R3
       JL SAVVD2
       MOV R3,R8
SAVVD2 S R8,R3       ; file_len left after write
       MOV R7,R0     ; copy VDP to CPU buffer
       A R8,R7       ; identify next VDP address
       MOV R7,R15    ; save that next VDP address
       LI R1,VDPBUF
       MOV R8,R2
       BL @VMBR
       LI R7,VDPBUF  ; CPU buffer is to be written to disk
       BL @DSKOUT    ; write record
       MOV R15,R7    ; recover next VDP address
       MOV R3,R3     ; set flags for remaining file length to write
       JNE SAVVD1    ; if more data, repeat
       JMP SAVDON    ; else finish last record and close file
SAVMEM MOV R3,R8     ; full length of file in save length
       BL @DSKOUT
       JMP SAVDON

SAVBAS LI R4,VDPPAB+PABSIZ  ; buffer pointer
       LI R5,128     ; buffer remaining
       LI R15,'J'*>0100+'B'  ; header of BASIC program files
       LI R7,15*2+BASWP  ; address of R15
       LI R8,2       ; 2 bytes for 'JB'
       BL @DSKOUT
       LI R7,LINBOT  ; setup for first line table entry
* put code here for writing line table entry linenum, line table entry linelen, line string including null
* stop after writing linenum=-1
* clear remainder of record and write final record, close file
SAVBA1 MOV *R7,R15   ; save line number for later
       LI R8,2       ; 2 bytes for line number
       BL @DSKOUT    ; write line number
       CI R15,>FFFF
       JEQ SAVDON    ; if line number written was -1 then close out file
       MOV *R7+,@TEMPF2  ; TEMPF2=line string pointer
       MOV *R7,R15    ; R15=line length
       LI R8,2       ; 2 bytes for line length
       BL @DSKOUT    ; write line length
       MOV R7,@TEMPF1  ; save line table pointer pointing to next line table entry
       MOV @TEMPF2,R7  ; point to line string
       MOV R15,R8    ; set line length
       BL @DSKOUT    ; write line string
       MOV @TEMPF1,R7  ; recover line table pointer
       JMP SAVBA1    ; repeat on next line table entry

* common routine to finish saving and close file
SAVDON MOV R4,R0
       CLR R1
       MOV R5,R2
       CI R5,128
       JEQ SAVCLS    ; if buffer full then skip clearing buffer
       BL @VMBS      ; clear remainder of buffer
       BLWP @DSRLNK  ; write last record
SAVCLS BL @CLOSE     ; close file and clear OPENED flag
*       BL @CHRGET    ; prime NXTSTT with character
       MOVB *R10,R14  ; prime NXTSTT with character
       B @NXTSTT
SAVEIO B @DSKERR
*SAVEIQ B @IQERR not referenced
SAVESE LI R3,SYNMSG
SAVEER LI R0,VDPPAB
       LI R1,DSRCLS
       BL @VSBW
       BLWP @DSRLNK  ; close open file (don't care about checking for errors on close)
       B @ERROR

* get LOAD/SAVE options #1 (filename), setup PAB, and open file
* Note: use R15 to identify LOAD(0) vs SAVE(-1)
* get filename into PAB
LSOPT  MOV R11,@TEMPF4  ; stash return address so subroutines can be used (can't use R12 b/c GETVC does)
       CLR R1        ; can't use R0 as index register
       BL @CHRGET
       CI R14,'"'*>0100
       JEQ LSPREQ
       CI R14,TSTR*>0100
       JNE SAVESE    ; if not followed by quote or STR$( then SYNTAX ERROR
       BL @GETVC
       CI R14,')'*>0100
       JNE SAVESE    ; if not followed by ) then SYNTAX ERROR
* pre-STR$ flow
       SETO R2       ; set flag to STR$ flow
       MOV R5,R0     ; use R0 for string pointer
       JMP LSOPT1    ; jump to common copy routine
LSPREQ INC R10       ; move past the quotation mark
       MOV R10,R0    ; use R0 for string pointer
       CLR R2        ; set flag to quote flow
*common copy flow
LSOPT1 MOVB *R0+,@PABNAM(R1)
       JLT LSOPT2
       INC R1
       JMP LSOPT1
LSOPT2 MOVB @PABNAM(R1),R14  ; invert last character of string literal
       INV R14
       MOVB R14,@PABNAM(R1)
       CLR R14       ; cleanup, INV left FF in low byte of R14...never allowed!
       INC R1
       MOV R1,@PABFNL-1  ; write (screen offset=0 and) filename length byte
*common finish
       MOVB R2,R2    ; set flags to flow
       JNE LSPAB
* post-quote flow
       DEC R0        ; backup for quote version to use CHRGET
       MOV R0,R10    ; only quote flow needs to change R10
* update rest of PAB
LSPAB  LWPI CPUPAB   ; make registers point to PAB for speed
       LI R0,DSROPN+>0B   ; OPEN, clear error, FIXED, OUTPUT, RELATIVE *** different between LOAD/SAVE
       MOV @2*15+BASWP,@2*15+BASWP  ; set flags based on original R15
       JNE LSPAB1
       INCT R0       ; change OUTPUT to INPUT for LOAD
LSPAB1 LI R1,VDPPAB+PABSIZ  ; VDP buffer address
       LI R2,>8080   ; 128 byte records
       CLR R3        ; record number 0
       LWPI BASWP    ; point registers back to normal workspace
* copy PAB
       LI R0,VDPPAB
       LI R1,CPUPAB
       LI R2,PABSIZ
       BL @VMBW      ; copy CPU PAB to VDP PAB
       AI R0,PABFNL-CPUPAB  ; compute VDP address of filename length position
       MOV R0,@DSRNAM  ; tell the device driver where to find the filename
* perform OPEN
       CLR @GPLSTS   ; always clear status before calling DSRLNK
       BLWP @DSRLNK  ; invoke device driver to open file
       SETO R0
       MOVB R0,@OPENED  ; flag that a file is open
       LI R0,VDPPAB+1
       BL @VSBR      ; read device driver flags after operation
       ANDI R1,>7000  ; only look at status bits
       JNE SAVEIO    ; if non-zero then report FILE IO error (other error)
       MOVB @GPLSTS,R1  ; read GPL status byte
       ANDI R1,>2000  ; only look at status bit
       JNE SAVEIO    ; if DSR status bit set then report FILE IO error (bad device name)
       LI R0,VDPPAB
       LI R1,DSRWR  *** different between LOAD/SAVE
       MOV R15,R15   ; set flags
       JNE LSPAB2
       LI R1,DSRRD
LSPAB2 BL @VSBW      ; update VDP PAB operation to READ/WRITE
       CLR R3        ; placeholder for file length
       LI R4,VDPPAB+PABSIZ  ; buffer pointer
       LI R5,>80     ; buffer left
       MOV @TEMPF4,R12  ; recover saved return address, but don't use R11 since CHRGET/CHKEND will
       BL @CHRGET    ; read next character
       BL @CHKEND    ; determine if it is a null, set R15 to 1 if null
       B *R12

* skip to next line number
* function to advance line pointer and check for end of program
SREM   MOVB *R10+,R14  ; advance TXTPTR (okay to not use CHRGET since we also skip spaces this way)
       JNE SREM        ; until end of line marker
       DEC R10         ; rewind to the null at end of line (skipped by autoincrement)
       CLR R14         ; since we know character is null no need to MOVB *R10,R14 (faster)
       B @NXTSTT
LETIQ  B @IQERR
* change a variable or address
SLET   MOV R14,R6
       SWPB R6
       LI R15,TLET
       S R15,R6        ; R6 contains variable number
       CI R6,VARAT
       JNE LETVAR
       BL @GETVC       ; determine address
       MOV R5,R7       ; R7 contains address
       SRC R5,1        ; test if even/odd
       JOC LETIQ       ; if odd then ILLEGAL QUANTITY
       MOV *R7,R8      ; R8 contains value
       CI R14,TEQUAL*>0100  ; no need to CHRGET because GETVC does it automatically
       JEQ LETCON      ; if equal sign continue with LET as normal
       CI R14,TADD*>0100
       JNE ADRDEC      ; if not plus sign check for minus sign
       INC R8          ; plus sign: increment and done
       B @LETRET
ADRDEC CI R14,TSUB*>0100
       JNE LET2C       ; if not equal, plus, or minus then SYNTAX ERROR
       DEC R8          ; minus sign: decrement and done
       B @LETRET
LETVAR LI R15,VARS
       MOV R6,R7
       A R7,R7         ; double variable number = offset of variable
       A R15,R7        ; R7 contains address
LETCON BL @CHRGET      ; fetch 1st parameter after the statement token
       CI R14,TRND*>0100
       JNE LET1
* RND
       MOV @RAND1,R9
       MOV @RAND2,R15
       MOV R9,R8
       SLA R8,5
       XOR R9,R8
       MOV R8,R9
       SRL R8,3
       XOR R9,R8
       XOR R15,R8
       MOV R15,R9
       SRL R15,1
       XOR R8,R15
       MOV R15,R8
       MOV R15,@RAND2
       MOV R9,@RAND1
       B @LETRET       ; need to use branch because LET is too long to jump across
LET1   CI R14,TNOT*>0100
       JNE LET2
* NOT numeric
       BL @GETVC
       MOV R5,R8
       INV R8
       DEC R10         ; roll back TXTPTR off of end marker so LETRET can fix it 
       B @LETRET       ; need to use branch because LET is too long to jump across
LET2   CI R14,TSUB*>0100
       JNE LET2B
* -numeric (could be done by making first argument 0 and jumping to the two operand function,
*           but it is faster and easier to just negate the argument presented)
       BL @GETVC
       MOV R5,R8
       NEG R8
       DEC R10         ; roll back TXTPTR off of end marker so LETRET can fix it 
       B @LETRET       ; need to use branch because LET is too long to jump across
LET2B  CI R14,TPEEK*>0100
       JNE LET2D
* PEEK(numeric)
       BL @GETVC
       CI R14,')'*>0100
LET2C  JNE LETSE       ; if no closing ) then syntax error
       CLR R8
       MOVB *R5,R8     ; read byte
       SWPB R8         ; put in LSB
       JMP LETRET
LET2D  CI R14,TDPEEK*>0100
       JNE LET3
* DPEEK(numeric)
       BL @GETVC
       CI R14,')'*>0100
LETSE  JNE LETSYN      ; if no closing ) then syntax error
       MOV *R5,R8      ; read word
       SRC R5,1        ; test if even/odd
       JOC LETIQ       ; if odd then illegal quantity error
       JMP LETRET
LET3   CI R14,TVPEEK*>0100
       JNE LET4
* VPEEK(numeric)
       BL @GETVC
       CI R14,')'*>0100
       JNE LETSYN      ; if no closing ) then syntax error
       CI R5,>4000
       JHE LETIQ       ; if address too large then illegal quantity error
       MOV R5,R0
       BL @VSBR        ; read byte from VDP RAM
       CLR R8
       MOVB R1,R8      ; put byte in result register
       SWPB R8         ; put in LSB
       JMP LETRET
LET4   CI R14,TLEN*>0100
       JNE LET4B
* LEN(numeric)
       BL @GETVC
       CI R14,')'*>0100
       JNE LETSYN      ; if no closing ) then syntax error
       CLR R8
       LI R6,>8000
LET4A  INC R8
       CB *R5+,R6
       JL LET4A       ; if character is lower than 128 check next character
       JMP LETRET
LET4B  CI R14,TVAL*>0100
       JNE LET4C
* VAL(numeric)
       BL @GETVC
       CI R14,')'*>0100
       JNE LETSYN      ; if no closing ) then syntax error
       BL @ATOI        ; convert string at R5 to number in R8
       JMP LETRET
LET4C  CI R14,TASC*>0100
       JNE LET5
* ASC("string literal")
       BL @CHRGET
       CI R14,'"'*>0100
       JNE LETSYN      ; if no quote then syntax error
       INC R10         ; don't use CHRGET since spaces matter
       MOVB *R10,R8    ; read first character of string literal
       MOVB *R10,R14   ; keep a copy since R8 will be modified
       CI R8,>8000
       JL LET4D
       INV R8          ; if negative, invert
LET4D  SWPB R8         ; put result in low byte
       ANDI R8,>00FF   ; mask off high byte
       MOVB R14,R14    ; check if end of string
LET4E  JLT LET4F       ; if it was negative then finish up
       INC R10
       MOVB *R10,R14   ; advance one character in the string
       JMP LET4E
LET4F  BL @CHRGET      ; get next character, skipping spaces
       CI R14,')'*>0100
       JNE LETSYN      ; if no closing ) then syntax error
       JMP LETRET
* numeric
LET5   DEC R10         ; put back token so GETVC sees it
       BL @GETVC
       MOV R3,R0
       MOV R4,R1
       MOV R5,R2
       BL @CHKEND      ; check if EOS/EOL (GETVC includes implicit CHRGET)
       JEQ LET6
       DEC R10         ; roll back TXTPTR off of end marker so LETRET can fix it
       MOV R2,R8       ; make single argument's value the result value
       JMP LETRET
* numeric operator numeric
LET6   CLR R4          ; clear R4 so byte operations work
       MOVB *R10,R4    ; CHKEND cleared R14 so fetch it again
       SWPB R4         ; change from byte to word format
       LI R3,TSHIFT
       C R4,R3
       JH LETSYN       ; operator is outside (higher) of function range
       LI R3,TEQUAL
       C R4,R3
       JL LETSYN       ; operator is outside (lower) of function range
       S R3,R4         ; R4 = this token - first function token
       A R4,R4         ; double to reflect bytes in table entries
       MOV @FTABLE(R4),@TEMPF1  ; lookup function address and save in temp (R11/12 will be clobbered by GETVC)
       BL @GETVC       ; get final argument
       DEC R10         ; roll back TXTPTR off of end marker so LETRET can fix it
       MOV @TEMPF1,R11
       BL *R11         ; call calculated function address
LETRET MOV R8,*R7      ; save result value in result address
       BL @CHRGET      ; all statements must advance
       B @NXTSTT
LETSYN B @SYNERR
* increment a variable or address
SINCRE CLR R9
       LI R15,TINC
       JMP INCDEC
* decrement a variable or address
SDECRE SETO R9
       LI R15,TDEC
INCDEC MOV R14,R6
       SWPB R6
       BL @CHRGET   ; preload next token for NXTSTT
       S R15,R6     ; R6 contains variable number
       LI R15,VARS
       MOV R6,R7
       A R7,R7      ; double to reflect variables stored as words
       A R15,R7     ; R7 contains address
       MOV R9,R9    ; set status
       JLT DODECR
       INC *R7      ; do increment
       JMP DECRET
DODECR DEC *R7      ; do decrement
DECRET MOV *R7,R8   ; R8 contains result value
       B @NXTSTT
* wait for <argument> rasterline events
* check VDPSTA at >8802 until bit 0 (highest) is set (value is negative)
SWAIT  BL @GETVC
       MOV R5,R5
       JEQ WAITR    ; if already 0 exit immediately
WAIT1  MOVB @VDPSTA,R1  ; get VDP status byte
       JLT WAIT2    ; if top bit set then screen updated
       JMP WAIT1    ; repeat waiting until event
WAIT2  DEC R5       ; reduce wait count by 1
       JNE WAIT1    ; repeat waiting until count reaches 0
WAITR  B @NXTSTT
* redefine character arg1 to arg2 string literal
SCHAR  BL @GETVC
       CI R5,>01FF
       JH NOTHEX     ; argument 0-511, else ILLEGAL QUANTITY
* 0-255 are screen characters, 256-511 are sprite characters !ONLY IF! the sprite table is remapped
       CI R14,','*>0100
       JNE LETSYN   ; if next character is not , then SYNTAX ERROR
       BL @CHRGET
       CI R14,'"'*>0100
       JNE LETSYN   ; if next character is not " then SYNTAX ERROR
       SLA R5,3     ; character offset is 8*character number
       AI R5,>0800  ; VDP offset is character offset plus pattern table base address
       MOV R5,R0    ; R0 = address in VDP
       CLR R3       ; use R3 as pixel row counter
       CLR R2       ; use R2 as end of string flag
       LI R6,'F'*>0100  ; ASCII F
       LI R7,'A'*>0100  ; ASCII A
       LI R8,>C900  ; negative (ASCII A-10)
       LI R9,'9'*>0100  ; ASCII 9
       LI R5,'0'*>0100  ; ASCII 0
       LI R4,>D000  ; negative (ASCII 0)
* R0 = address in VDP, R1 = converted value from hex
CHARL1 BL @CHRGET   ; get next character of string
       CB R14,R6
       JH NOTHEX    ; if > F then not a hex digit
       CB R14,R7
       JL NOTL1     ; if < A then not a letter
       AB R8,R14    ; value = letter - ('A'-10)
       JMP HEXDN1
NOTL1  CB R14,R9
       JH NOTHEX    ; if > 9 then not a hex digit
       CB R14,R5
       JL NOTHEX    ; if < 0 then not a hex digit
       AB R4,R14    ; value = digit - '0'
HEXDN1 MOVB R14,R1
       BL @CHRGET   ; get next character of string
       JLT INVL2
CHARL2 CB R14,R6
       JH NOTHEX    ; if > F then not a hex digit
       CB R14,R7
       JL NOTL2     ; if < A then not a letter
       AB R8,R14    ; value = letter - ('A'-10)
       JMP HEXDN2
NOTL2  CB R14,R9
       JH NOTHEX    ; if > 9 then not a hex digit
       CB R14,R5
       JL NOTHEX    ; if < 0 then not a hex digit
       AB R4,R14    ; value = digit - '0'
HEXDN2 SLA R1,4     ; shift 1 nybble
       ANDI R14,>0F00  ; clear any bits not in the nybble of interest
       SOCB R14,R1  ; combine nybbles
* not worth saving a few cycles by using the VDP address autoincrement feature by decomposing VSBW/VMBW inline
       BL @VSBW     ; write the byte to VDP
       INC R0       ; advance VDP address to next byte
       INC R3       ; move to next row
       MOVB R2,R2   ; set flags for end of string
       JNE EOS
       CI R3,8
       JL CHARL1    ; if more rows and not end of string, go get the next character
CHARDN BL @CHRGET   ; prime character for NXTSTT
       B @NXTSTT
NOTHEX B @IQERR     ; ILLEGAL QUANTITY
INVL2  SETO R2
       INV R14      ; remember to clear R14 at the end of each loop
       JMP CHARL2
EOS    CI R3,8
       JEQ CHARDN   ; if 8 bytes written then done
       CLR R1
       BL @VSBW     ; write a 0 for the next row since string has no more data
       INC R0       ; advance VDP address to next byte
       INC R3       ; move to next row
       JMP EOS      ; repeat always
* clear the screen
SCLEAR CLR R0       ; at top of screen
       LI R1,CSPACE  ; space
       LI R2,>0300  ; size of screen
       BL @VMBS     ; clear screen
       MOV R0,@CURSOR  ; set cursor position to top left corner of screen
       BL @CHRGET   ; preload next token for NXTSTT
       B @NXTSTT
* change color of set arg1 to foreground arg2 and background arg3
SCOLOR BL @GETVC    ; arg1 is character set number
       MOV R5,R0
       CI R14,','*>0100
       JNE LOCSYN   ; if no comma then SYNTAX ERROR
       BL @GETVC    ; arg2 is foreground
       MOV R5,R1
       CLR R5       ; default background is clear
       BL @CHKEND
       JNE COLOR1   ; if no futher arguments then change color
       CI R14,','*>0100
       JNE LOCSYN   ; if no comma then SYNTAX ERROR
       BL @GETVC    ; optional arg3 is background
COLOR1 CI R0,31
       JH LOCIQ     ; if arg1 > 31 or negative then ILLEGAL QUANTITY
       CI R1,15
       JH LOCIQ     ; if arg2 > 15 or negative then ILLEGAL QUANTITY
       CI R5,15
       JH LOCIQ     ; if arg3 > 15 or negative then ILLEGAL QUANTITY
       AI R0,>0380  ; set color memory address by adding color memory base to set number
       SLA R1,4     ; foreground is high nybble
       SOC R5,R1    ; combine background into low nybble
       SWPB R1      ; move to high byte
       BL @VSBW     ; set byte in color memory
       B @NXTSTT
* cursor location = row, column (row  ; columns/row + column)
SLOCAT BL @GETVC
       CI R5,23
       JH LOCIQ     ; legal rows 0-23
       LI R1,>0020  ; 32 columns per row
       MPY R5,R1
       MOV R3,R0
       MOV R4,R1
       CI R14,','*>0100
       JNE LOCSYN
       BL @GETVC
       CI R5,31
       JH LOCIQ     ; legal columns 0-31
       A R5,R2
       MOV R2,@CURSOR
       B @NXTSTT
LOCSYN B @SYNERR
LOCIQ  B @IQERR
* change screen backround color to 0-15
SSCREE BL @GETVC
       CI R5,>000F
       JH LOCIQ      ; if color > 15 or negative then ILLEGAL QUANTITY
       MOV R5,R0
*       SLA R0,4     ; populate bits 7:4 for foreground (don't care except in 40 column text mode), background bits 3:0
       ORI R0,>0700  ; select register 7 for screen colors
       BL @VDPREG    ; update VDP register
       B @NXTSTT
* re-initialize all video and audio settings in case the program left them in a bad state
SINIT  BL @VDPINI
       LI R0,>8400   ; sound register
       LI R1,>9F00   ; voice 0, volume off
       MOVB R1,*R0
       LI R1,>BF00   ; voice 1, volume off
       MOVB R1,*R0
       LI R1,>DF00   ; voice 2, volume off
       MOVB R1,*R0
       LI R1,>FF00   ; noise, volume off
       MOVB R1,*R0
       BL @CHRGET
       B @NXTSTT
* set/clear sprite magnify and size control register bits
* get arg, and with 3, or with >E0, call wrreg
SMAGNI BL @GETVC
       CI R5,3
       JH LOCIQ      ; if argument >3 or negative then ILLEGAL QUANTITY
       MOV R5,R0
       ANDI R0,>0003  ; use only low 2 bits
       ORI R0,>01E0  ; set register 1 bits
       BL @VDPREG    ; update VDP register
       SWPB R0       ; move data to high byte
       MOVB R0,@SHDWR1  ; always write to shadow register for VDP register 1
       B @NXTSTT
* variable number of arguments so handle each in order
* sprite #, y, x, character, color
SSPRIT BL @GETVC     ; get sprite number
       CI R5,15
       JH LOCIQ      ; if sprite >15 or negative then ILLEGAL QUANTITY
       MOV R5,R0
       SLA R0,2      ; each sprite takes 4 bytes
       AI R0,>0300   ; start relative to sprite attribute list #0, y position
       CI R14,','*>0100
       JNE LOCSYN    ; if no , then SYNTAX ERROR
       BL @GETVC     ; get y value
       CI R5,>00FF
       JH LOCIQ      ; if y >255 or negative then ILLEGAL QUANTITY
       MOV R5,R1
       SWPB R1       ; VDP uses high byte
       BL @VSBW      ; write one byte, doesn't increment pointer
       BL @CHKEND    ; check if last argument
       JNE SPRRET    ; END=1, goto done
       CI R14,','*>0100
       JNE LOCSYN    ; if no , then SYNTAX ERROR
       BL @GETVC     ; get x value
       CI R5,>00FF
       JH LOCIQ      ; if x >255 or negative then ILLEGAL QUANTITY
       MOV R5,R1
       INC R0        ; increment pointer
       SWPB R1       ; VDP uses high byte
       BL @VSBW      ; write one byte, doesn't increment pointer
       BL @CHKEND    ; check if last argument
       JNE SPRRET    ; END=1, goto done
       CI R14,','*>0100
       JNE LOCSYN    ; if no , then SYNTAX ERROR
       BL @GETVC     ; get character definition
       MOV R5,R1
       ANDI R1,>00FF  ; use only low 8 bits of character number so 0-255 or 256-512 are both acceptable
       INC R0        ; increment pointer
       SWPB R1       ; VDP uses high byte
       BL @VSBW      ; write one byte, doesn't increment pointer
       BL @CHKEND    ; check if last argument
       JNE SPRRET    ; END=1, goto done
       CI R14,','*>0100
       JNE LOCSYN    ; if no , then SYNTAX ERROR
       BL @GETVC     ; get early clock and color
       CI R5,>001F
       JH LOCIQ      ; if higher than 31 or negative then ILLEGAL QUANTITY
       MOV R5,R1
       INC R0        ; increment pointer
       SWPB R1       ; VDP uses high byte
       BL @VSBW      ; write one byte
SPRRET B @NXTSTT
* Read joystick arg1 values into arg2, arg3, arg 4
SJOYST BL @GETVC     ; get first argument (which joystick)
       MOV R5,R5
       JEQ SNDIQ     ; if 0 then ILLEGAL QUANTITY
       LI R0,2
       C R5,R0
       JH SNDIQ      ; if >2 or negative then ILLEGAL QUANTITY
       AI R5,5       ; choose column (6=joy1, 7=joy2)
       SWPB R5       ; move to byte size
       MOV R5,R15    ; R15 = joystick device column number
       LI R12,>0024  ; R12 = set CRU to keyboard/joystick (required register number to use for CRU)
       LDCR R15,3    ; strobe relevant keyboard/joystick line
       LI R12,6      ; point to keyboard outputs
       CLR R9        ; erase destination
       STCR R9,8     ; shift 8 bits in from CRU

       CI R14,','*>0100
       JNE JOYERR    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; get second argument (Y position)
       MOV R3,R3     ; set flags based on constant/variable property
       JLT JOYERR    ; if constant then SYNTAX ERROR
       MOV R4,R1     ; save argument 2 location to R1
       CI R14,','*>0100
       JNE JOYERR    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; get third argument (X position)
       MOV R3,R3     ; set flags based on constant/variable property
       JLT JOYERR    ; if constant then SYNTAX ERROR
       MOV R4,R7     ; save argument 2 location to R7
       CI R14,','*>0100
       JNE JOYERR    ; if no comma then SYNTAX ERROR
       BL @GETVC     ; get fourth argument (fire position)
       MOV R3,R3     ; set flags based on constant/variable property
       JLT JOYERR    ; if constant then SYNTAX ERROR
* bits in R9 are 0 if switch closed, 1 if switch open
       CLR R2        ; set all outputs to 0
       CLR R5
       CLR R8
       SLA R9,4      ; check if up switch closed
       JOC JOY1
       DEC R2
JOY1   SLA R9,1      ; check if down switch closed
       JOC JOY2
       INC R2
JOY2   SLA R9,1      ; check if right switch closed
       JOC JOY3
       INC R8
JOY3   SLA R9,1      ; check if left switch closed
       JOC JOY4
       DEC R8
JOY4   SLA R9,1      ; check if button switch closed
       JOC JOYFIN
       DEC R5
JOYFIN MOV R2,*R1    ; save all outputs to their chosen variable address
       MOV R5,*R4
       MOV R8,*R7
       B @NXTSTT
JOYERR B @SYNERR
* Sound programs any voice (0-2) with frequency and volume
SSOUND BL @GETVC     ; get first argument (which voice)
       CI R5,2
       JH SNDIQ      ; if >2 or negative then ILLEGAL QUANTITY
       MOV R5,R0
       SLA R0,13     ; voice control in bits 14:13
       ORI R0,>8000  ; command bit 15 set
       MOV R0,R1     ; keep a copy of the voice register identifier
       ORI R1,>1000  ; set attenuation register bit
       CI R14,','*>0100
       JNE JOYERR    ; if missing comma then SYNTAX ERROR
       BL @GETVC     ; get second argument (frequency)
       CI R5,110
       JLT SNDIQ     ; if <110 then ILLEGAL QUANTITY
       LI R8,1
       LI R9,>B4F5   ; frequency base is 111861 Hz or >0001_B4F5
       DIV R5,R8     ; divide frequency base by requested frequency to get frequency divider in R8
* move low 4 bits to R0[11:8]
       MOV R8,R2     ; make a copy that can be destroyed
       SWPB R2       ; switch bits so low 4 are now in 11:8
       ANDI R2,>0F00  ; mask off all other bits
       SOCB R2,R0    ; OR the 4 bits into R0
* move bits 9:4 to R0[7:0]
       SRL R8,4      ; move to low 6 bits
       SOC R8,R0     ; OR the 8 bits into R0
       CI R14,','*>0100
       JNE JOYERR    ; if missing comma then SYNTAX ERROR
       BL @GETVC     ; get third argument (volume)
       LI R2,15
       C R5,R2
       JH SNDIQ      ; if >15 or negative then ILLEGAL QUANTITY
       S R5,R2       ; attenuation = 15 minus volume
*       SLA R2,8      ; move low nybble of low byte to low nybble of high byte
       SWPB R2
       SOCB R2,R1    ; OR the 4 bits into R1 high byte
* write 3 bytes to the sound chip bridge address
       MOVB R0,@SOUND  ; write first byte
       SWPB R0
       MOVB R0,@SOUND  ; write second byte
       SWPB R0       ; fixup R0 to original state and add delay before write
       MOVB R1,@SOUND  ; write third byte
       B @NXTSTT
SNDIQ  B @IQERR
* Noise programs voice 4 with frequency divider key and volume
SNOISE BL @GETVC     ; get first argument (frequency code)
       CI R5,7
       JH SNDIQ      ; if >7 or negative then ILLEGAL QUANTITY
       MOV R5,R0
       SWPB R0       ; put noise selector in high byte
       ORI R0,>E000  ; set the noise register address in
       CI R14,','*>0100
       JNE JOYERR    ; if missing comma then SYNTAX ERROR
       BL @GETVC     ; get second argument (volume)
       LI R2,15
       C R5,R2
       JH SNDIQ      ; if >15 or negative then ILLEGAL QUANTITY
       S R5,R2       ; attenuation = 15 minus volume
       ORI R2,>00F0  ; set the noise attenuation register address in
*       SOC R0,R2     ; combine (unnecessary but makes reading registers easier)
       MOVB R0,@SOUND  ; write first byte
*       SWPB R0
*       MOVB R0,@SOUND  ; write second byte
*       SWPB R0       ; fixup R0 to original state (unnecessary)
       SWPB R2
       MOVB R2,@SOUND  ; write second byte
       B @NXTSTT

* All Functions usable in expressions
* 2 ARGS here and below! uses signed comparison with JGT
FGREAT CLR R8
       C R2,R5
       JGT FCOMP1  ; uses signed comparison
       JMP FCOMP0
FLESST CLR R8
       C R2,R5
       JLT FCOMP1  ; uses signed comparison
       JMP FCOMP0
FEQUAL CLR R8
       C R2,R5
       JEQ FCOMP1
       JMP FCOMP0
FUNEQU CLR R8
       C R2,R5
       JNE FCOMP1
       JMP FCOMP0
FGREQU CLR R8
       C R2,R5
       JLT FCOMP0  ; uses signed comparison with JLT
       JMP FCOMP1
FLTEQU CLR R8
       C R2,R5
       JGT FCOMP0  ; uses signed comparison with JGT
FCOMP1 DEC R8
FCOMP0 B *R11
* R2+R5->R8
FADD   MOV R5,R8
       A R2,R8
       B *R11
* R2-R5->R8
FSUB   MOV R2,R8
       S R5,R8
       B *R11
* R2*R5->R9->R8
* uses R6 as sign bit
FMULT  CLR R6
       MOV R5,R8
       JGT FMULT1  ; multiplicand positive, check multiplier
       JEQ FMULTR  ; multiplicand zero, return zero
       NEG R8      ; make it positive
       INC R6      ; toggle sign flag
FMULT1 MOV R2,R2   ; set flags
       JGT FMULT2  ; multiplier positive, calculate
       JEQ FMULT2  ; multiplier zero, calculate
       NEG R2      ; make it positive
       DEC R6      ; toggle sign flag
FMULT2 MPY R2,R8   ; calculate
       MOV R8,R8   ; set flags
       JNE FMULTE  ; if not zero then overflow
       MOV R9,R8   ; take answer from lower half
*       JLT FMULTE  ; if negative then overflow??? NO, let user handle
       MOV R6,R6   ; set flags for sign
       JEQ FMULTR  ; if 0 then no sign change
       NEG R8      ; flip sign of answer
FMULTR B *R11
FMULTE B @IQERR
* R2/R5->R8rR9
* uses R6 as sign bit
FDIV   CLR R6
       CLR R8
       MOV R2,R9
       JGT FDIV1
       JEQ FDIV1
       NEG R9     ; dividend was negative so make positive and toggle sign flag
       INC R6
FDIV1  MOV R5,R5  ; set flags
       JGT FDIV2
       JEQ POWIQ  ; divide by zero not allowed
       NEG R5     ; divisor was negative so make it positive and toggle sign flag
       DEC R6
FDIV2  DIV R5,R8
       MOV R6,R6  ; set flags
       JEQ FDIVR
       NEG R8     ; odd number of negative signs so we flip the result's sign
FDIVR  B *R11
* R2/R5->R8rR9, remainder doesn't care about sign
FMOD   CLR R8
       MOV R2,R9
       ABS R9
       ABS R5
       JEQ POWIQ  ; divide by zero not allowed
       DIV R5,R8
       MOV R9,R8
       B *R11
* R2^R5->R8 (use R12 for temporary exponent count down)
* if exponent is 0 then return 1
* if exponent is 1 then return base
* if base is 0 then return 0
* if base is +/-1 then return base (after correct for sign)
* if exponent is negative then ?ILLEGAL QUANTITY ERROR
* if exponent is > 14 then ?OVERFLOW ERROR
* if base is > 181 then ?OVERFLOW ERROR
* finally do loop multiplies
FPOWER CLR R8
       MOV R5,R8
       JNE EXPNE0
       INC R8
       JMP POWRET  ; if exponent is 0 then return 1
EXPNE0 DEC R8
       JNE EXPNE1
       MOV R2,R8
       JMP POWRET  ; if exponent is 1 then return base
EXPNE1 MOV R2,R8
       JEQ POWRET  ; if base is 0 then return 0
       CI R8,1
       JEQ POWRET  ; if base is 1 then return base
       CI R8,-1
       JNE BASNM1
       MOV R5,R12
       ANDI R12,1
       JNE POWRET  ; if base is -1 and odd exponent then return base
       NEG R8
       JNE POWRET  ; if base is -1 and even exponent then return -base
BASNM1 MOV R5,R12
       JLT POWIQ   ; if exponent is negative then ?ILLEGAL QUANTITY ERROR
       CI R5,14
       JGT POWOF   ; if exponent is > 14 then ?OVERFLOW ERROR
       CI R2,181
       JGT POWOF   ; if base is > 181 then ?OVERFLOW ERROR
       DEC R12
       JEQ POWRET
POWLP  MPY R2,R8
       MOV R9,R8
       DEC R12
       JNE POWLP
POWRET B *R11
POWIQ  B @IQERR
POWOF  LI R3,OFMSG
       B @ERROR
* R2 AND R5->R8
FBWAND MOV R2,R8
       MOV R5,R9
       INV R9
       SZC R9,R8
       B *R11
* R2 OR R5->R8
FBWOR  MOV R5,R8
       SOC R2,R8
       B *R11
* R2 XOR R5->R8
FBWXOR MOV R5,R8
       XOR R2,R8
       B *R11
* R2 <<|>> R5->R8
* FSHIFT if R5 lower (than 0) then FBWSHR
* if R5 is 0 then return R2
* FBWSHL if R5 higher than 15 then return 0
* return SLA
* FBWSHR if R5 lower than -15 then return 0
* NEG R5
* return SRL
FSHIFT MOV R5,R0
       JLT FBWSHR
       JEQ FSHIF1
* R2 SHL R5->R8
FBWSHL CI R5,15
       JH FSHIF0
       MOV R2,R8
       SLA R8,0
       B *R11
* R2 SHR R5->R8
FBWSHR CI R5,-15
       JL FSHIF0
       MOV R2,R8
       NEG R0
       SRL R8,0
       B *R11
FSHIF1 MOV R2,R8
       B *R11
FSHIF0 CLR R8
       B *R11

* All Functions usable in PRINT
* generate a string based on value/variable and use its address
* FCHRST MOVB R2,@CHRSTR
*       B *R11
* identify next value as string address
* FSTRST
* end EXECUTION --------------------------------------

* start ERRORS ---------------------------------------
SYNERR LI R3,SYNMSG
       JMP ERROR
IQERR  LI R3,IQMSG
       JMP ERROR
OOMERR LI R3,OOMMSG
*       JMP ERROR    ; not needed, just fall through
* Error message - output return, '?', error pointed to by R3, 'ERROR IN LINE ', line number
* Then stop running
ERROR  LI R1,CENTER  ; return
       BL @CHROUT
       LI R1,'?'*>0100
       BL @CHROUT
       BL @PRTNEG    ; error pointed to by R3 that ends in an inverted character
       LI R3,ERRMSG
       BL @PRTNEG    ; 'ERROR'
       MOV @CURLIN,R4  ; pointer to entry in line table
       MOV *R4,R5    ; actual line number from table
       JLT ERREND    ; if negative line then skip printing line number
       LI R3,ERRLIN
       BL @PRTNEG    ; ' IN LINE '
       BL @PRTNUM    ; line number
ERREND B @SEND       ; do END statement to stop execution immediately

ERRMSG TEXT 'ERRO'
       BYTE >FF-'R'
ERRLIN TEXT ' IN LINE'
       BYTE >DF
* Must use hardcoded byte since Win994a does not parse expressions containing a space character
* even if it is inside single quotes. Can use >FF - >20 or just hardcode the calculation result.
*       BYTE >FF-' '
SYNMSG TEXT 'SYNTAX'
       BYTE >DF
IQMSG  TEXT 'ILLEGAL QUANITITY'
       BYTE >DF
FIOMSG TEXT 'FILE I/O'
       BYTE >DF
OFMSG  TEXT 'OVERFLOW'
       BYTE >DF
USMSG  TEXT 'LINE NOT FOUND'  ; was UNDEFINED STATEMENT
       BYTE >DF
RWGMSG TEXT 'RETURN WITHOUT GOSUB'
       BYTE >DF
NWFMSG TEXT 'NEXT WITHOUT FOR'
       BYTE >DF
OOMMSG TEXT 'OUT OF MEMORY'
       BYTE >DF
       EVEN
* end ERRORS -----------------------------------------

* GetVariableOrConstant - check next token, if var or const then populate R3-5, else Syntax Error
* updates R10(TXTPTR) and R14 as if CHRGET was called at the end
GETVC  MOV R11,R12  ; save return address so CHRGET can be used
       CLR R3
       BL @CHRGET   ; skip spaces
       CI R14,TCONST*>0100
       JNE GETVC0
       CLR R4       ; must first clear before doing byte operations or low byte contains garbage
       CLR R5
       INC R10      ; move past TCONST token
       MOVB *R10+,R5  ; must read one byte at a time since word read will ignore LSB of address
       MOVB *R10+,R4
       SWPB R4
       SOC R4,R5    ; R5 contains value       
       CLR R4       ; R4 contains 0 (no address)
       MOV R4,R3    ; 
       DEC R3       ; R3 contains -1 (constant)
       DEC R10      ; backup so CHRGET finds next character
       JMP GETVC2
GETVC0 CI R14,TADDR*>0100
       JNE GETVC1
       CI R13,STACK+STKSIZ-2
       JH OOMERR    ; if stack pointer is less than (1 register) bytes from top then OUT OF MEMORY
       MOV R12,*R13+  ; save original return address
       BL @GETVC    ; recurse to get value
       LI R3,'@'    ; register/constant identifier
       MOV R5,R4    ; old value becomes new address
       SRC R5,1     ; test if even/odd
       JOC IQERR   ; if odd then illegal quantity error
       MOV *R4,R5   ; R5 contains ultimate value
       DECT R13     ; back up to recover R12
       MOV *R13,R12
       DEC R10      ; backup so CHRGET finds next character
       JMP GETVC2
GETVC1 CI R14,'Z'*>0100
       JH GETVCE
       CI R14,'A'*>0100
       JL GETVCE
       MOV R14,R3   ; don't modify R14
       AI R3,-'A'*>0100
       SWPB R3      ; correct for using high byte
       MOV R3,R4
       A R4,R4      ; double variable number since each uses 2 bytes
       AI R4,VARS
       MOV *R4,R5   ; R5 contains value
GETVC2 BL @CHRGET   ; skip spaces
       B *R12
GETVCE B @SYNERR
* FindLineNumber - search for line number in R2
* return line table pointer in R9 and code pointer in R15
FINDLN LI R9,LINBOT
FINDL1 MOV *R9+,R15
       JLT FINDL2   ; if line table entry is negative then no more lines to search
       C R2,R15
       JLE FINDL2   ; if desired line is <= line table entry then we either found the line number or went too far
*       INCT R9      ; skip to next entry in table
       C *R9+,*R9+  ; shorthand to add 4 to R9, skip to next entry in table (b/c we already did *R9+, only need 4 more bytes)
       JMP FINDL1
FINDL2 MOV *R9,R15  ; preload the text pointer before changing R9
       DECT R9      ; backup from using autoincrement the last time
       B *R11
* CheckEndOfLineOrStatement: 0/EQ=not end, 1/NE=end
CHKEND MOVB R14,R14  ; set flags
       JEQ CHKEN1
       CI R14,':'*>0100
       JEQ CHKEN1
       ANDI R15,0   ; return 0/EQUAL status if not end marker (CLR does not affect flags)
       B *R11
CHKEN1 ORI R15,>FFFF  ; return -1/NOT-EQUAL status if end marker (SETO does not affect flags)
       B *R11

* Get a line in the line input buffer
* string in LINBUF is not invert-terminated but has a length returned in R9
* (INPUT will do its own inverting)
* R0-2=used by subroutines, R3-5=avoid for SINPUT, R6=starting CURSOR, R7=pointer to string, R8=key, R9=length, R15=keyboard status
LINGET MOV R11,R12    ; backup return address so BL can be used
       CLR R9         ; count of characters entered is 0
       MOV @CURSOR,R6  ; save starting CURSOR position
       LI R7,LINBUF   ; line input buffer
       LI R1,CCURSR   ; cursor character
       BL @CHROUT
       DEC @CURSOR    ; backup to cursor character position
LINKEY CLR R8
       CLR @KEYDEV    ; scan from full keyboard
*       LIMI 0         ; INTERRUPT: interrupts cannot be enabled while scanning keys
       BLWP @KSCAN
*       LIMI 2         ; INTERRUPT
       MOVB @KEYKEY,R8
       CI R8,>FF00
       JEQ LINKEY     ; if no key try again
       MOV @GPLSTS,R15  ; retrieve status register
       ANDI R15,>2000  ; new key condition bit mask
       JEQ LINKEY     ; if not new key try again
       CI R8,CCLEAR
       JEQ LINKEY     ; if CLEAR try again
       CI R8,CLEFT
       JNE LINKE1
* left arrow/delete
       MOV R9,R9      ; set flags
       JEQ LINKEY     ; if no characters entered then ignore
       DEC R9         ; decrease character count
       LI R1,CSPACE
       BL @CHROUT     ; remove cursor character
       DECT @CURSOR   ; backup to character before the erased cursor
       LI R1,CCURSR
       BL @CHROUT     ; display new cursor location
       DEC @CURSOR    ; backup to cursor character position
       JMP LINKEY
LINKE1 CI R8,CENTER
       JNE LINKE2
* enter
LINENT LI R1,CSPACE
       BL @CHROUT     ; remove cursor character
       DEC @CURSOR    ; backup to the erased cursor for next output
       MOV R9,R2      ; length of entered text (DANGER: 0 characters possible)
       JEQ LINRET     ; if length 0 skip copying string
       MOV R6,R0
       MOV R7,R1
       BL @VMBR       ; copy string from VDP RAM to CPU RAM
LINRET B *R12         ; return without printing enter (allow caller to do this if desired)
* any other key
LINKE2 CI R8,CSPACE
       JHE LINKE3
       LI R8,CSPACE   ; if unassigned control character treat as space
LINKE3 CI R9,LINSIZ
       JEQ LINENT     ; if buffer full then treat any character as enter
       INC R9         ; increase character count
       MOV R8,R1
       BL @CHROUT     ; display character for key press
       LI R1,CCURSR
       BL @CHROUT     ; display cursor in new position
       DEC @CURSOR    ; backup to cursor character position
       MOVB @SCROLL,R1
       JEQ LINKEY     ; if no scroll then get another key
       AI R6,-32      ; move start position back 1 row
       JMP LINKEY     ; after adjusting start position for scroll get another key

* Output character in R1hi and advance cursor, if past end of screen then scroll line
* Special treatment of backspace[8] (left arrow), tab[9] (comma in PRINT, right arrow), and enter[13]
* Changes R0,R1,R2
CHROUT MOV R11,@TEMPF1  ; preserve return address
       CLR R0
       MOVB R0,@SCROLL  ; indicate no scroll as default
       MOV @CURSOR,R0
       LI R2,>0800
       CB R2,R1
       JNE CHROU2
       MOV R0,R0      ; backspace
       JEQ CHROUR     ; do nothing if at top left of screen
       DEC R0         ; backup one character
       LI R1,CSPACE   ; space over cursor position
       BL @VSBW
       JMP CHROUR
CHROU2 LI R2,CRIGHT
       CB R2,R1
       JNE CHROU3
       LI R2,>0008    ; tab: horizontal scroll to next position divisible by 8
       JMP HSCRLL
CHROU3 LI R2,CENTER
       CB R2,R1
       JNE CHROU4
       LI R2,>0020    ; enter: horizontal scroll to next position divisible by 32
HSCRLL MOV R8,@TEMPF2  ; temporarily stash R8/R9 so they can be used for division
       MOV R9,@TEMPF3
       MOV R0,R9      ; move right by R2 positions
       CLR R8
       DIV R2,R8
       INC R8
       MOV R8,R0
       MOV R2,R8
       MPY R0,R8
       MOV R9,R0
       MOV @TEMPF3,R9  ; recover R8/R9
       MOV @TEMPF2,R8
       JMP VSCRLL
CHROU4 BL @VSBW       ; any other character gets displayed
       INC R0
VSCRLL CI R0,>0300    ; if off screen then scroll screen up one line
       JL CHROUR
       SETO R0
       MOVB R0,@SCROLL  ; mark that screen scrolled
       LI R0,>0020    ; VDP start on line 1
       LI R1,VDPBUF   ; RAM buffer
       LI R2,VDPSIZ   ; amount to transfer
       BL @VMBR       ; block copy VDP to RAM (modifies R1,R2 so need to re-init)
       CLR R0         ; VDP start on line 0
       LI R1,VDPBUF   ; RAM buffer
       LI R2,VDPSIZ   ; amount to transfer
       BL @VMBW       ; block copy RAM to VDP
       LI R0,VDPSIZ   ; VDP destination
       LI R1,CSPACE   ; space character
       LI R2,>0020    ; number of characters
       BL @VMBS       ; block write spaces
       LI R0,VDPSIZ   ; move cursor to first byte of last line
CHROUR MOV R0,@CURSOR
       MOV @TEMPF1,R11  ; restore return address
       B *R11

* CLOSE closes the open file in VDPPAB
CLOSE  MOV R11,R12   ; stash return address so VSBW can be used
       LI R0,VDPPAB
       LI R1,DSRCLS  ; set opcode=CLOSE
       BL @VSBW      ; update VDP PAB operation to CLOSE
       BLWP @DSRLNK  ; invoke device driver to close file (don't care about checking for errors on close)
       CLR R0
       MOVB R0,@OPENED  ; flag that a file is NOT open
       B *R12

* DSKIN reads a byte from the file buffer, if buffer empty reads next record before returning byte
* if PAB error on record read then return EOF indicator to caller
* caller must do first record read and set buffer pointer to after header
* R0,1,2 used by VMBR, R3=file length (reserved), R4=buffer pointer, R5=buffer remaining, R6=read length
* R7=CPU address (input), R8=length (input), R9=EOF (output)
DSKIN  MOV R11,R12    ; protect return address from calls to VMBR/VSBR
DSKIN1 MOV R8,R6      ; write_len = length
       C R8,R5
       JLE DSKIN2
       MOV R5,R6      ; if length > buff_left then read_len = buff_left
       SETO R9        ; return end of file reached
DSKIN2 MOV R4,R0      ; VDP address = buff_ptr
       MOV R7,R1      ; CPU address = address
       MOV R6,R2      ; copy length = read_len
       BL @VMBR       ; move from VDP to CPU
       A R6,R7        ; address += read_len
       S R6,R8        ; length -= read_len
       A R6,R4        ; buff_ptr += read_len
       S R6,R5        ; buff_left -= read_len
       JNE DSKIN3     ; if buff_left <> 0 skip
       CLR @GPLSTS    ; always clear status before calling DSRLNK
       BLWP @DSRLNK   ; read next record
       LI R0,VDPPAB+1
       BL @VSBR       ; read device driver flags after operation
       ANDI R1,>7000  ; only look at status bits
       JNE DSKERR     ; if non-zero then report FILE IO error (other error)
       LI R4,VDPPAB+PABSIZ  ; reset to start of file buffer
       LI R5,128      ; reset remaining buffer to size of records
DSKIN3 MOV R8,R8      ; set flags
       JNE DSKIN1     ; if length <> 0 then read remainder from next record
       B *R12

* close any open file, then report FILE IO error
DSKERR LI R0,VDPPAB
       LI R1,DSRCLS
       BL @VSBW
       BLWP @DSRLNK  ; close open file (don't care about checking for errors on close)
       LI R3,FIOMSG
       B @ERROR

* DSKOUT writes a data chunk to the file buffer
* caller must set PAB for writes and prepare file length/buffer offset/buffer left before first call
* caller must write final record, update the file length in record 0, and close file after last call
* R0,1,2 used by VMBW, R3=file length, R4=buffer pointer, R5=buffer remaining, R6=write length
* R7=CPU address (input), R8=length (input)
DSKOUT MOV R11,R12    ; protect return address from calls to VMBW/VSBR
*       A R8,R3        ; file_len += length DO NOT TRACK file_len, LEAVE TO CALLER
DSKO1  MOV R8,R6      ; write_len = length
       C R8,R5
       JLE DSKO2
       MOV R5,R6      ; if length > buff_left then write_len = buff_left
DSKO2  MOV R4,R0      ; VDP address = buff_ptr
       MOV R7,R1      ; CPU address = address
       MOV R6,R2      ; copy length = write_len
       BL @VMBW       ; move from CPU to VDP
       A R6,R7        ; address += write_len
       S R6,R8        ; length -= write_len
       A R6,R4        ; buff_ptr += write_len
       S R6,R5        ; buff_left -= write_len
       JNE DSKO3      ; if buff_left <> 0 skip
       CLR @GPLSTS   ; always clear status before calling DSRLNK
       BLWP @DSRLNK   ; write full record
       LI R0,VDPPAB+1
       BL @VSBR       ; read device driver flags after operation
       ANDI R1,>7000  ; only look at status bits
       JNE DSKERR     ; if non-zero then report FILE IO error (other error)
       LI R4,VDPPAB+PABSIZ  ; reset to start of file buffer
       LI R5,128      ; reset remaining buffer to size of records
DSKO3  MOV R8,R8      ; set flags
       JNE DSKO1      ; if length <> 0 then copy remainder into new record
       B *R12

* ATOI convert string to integer (used in VAL and tokenization)
* R5 contains pointer to string (caller responsible for advancing TXTPTR if applicable)
* R0=10, R1=character, R2=char copy, R3='9', R4='0', R6=negative, R8=value, R9=clobbered by multiply
* R7 must be preserved for LET destination address
ATOI   CLR R8
       CLR R1
       CLR R6
       LI R0,10
       LI R4,'0'*>0100
       LI R3,'9'*>0100
       MOVB *R5+,R1
       CI R1,'-'*>0100
       JNE ATOI1    ; if not minus treat as digit
       INV R6       ; use R6 as negative flag (when negative)
       MOVB *R5+,R1
ATOI1  MOV R1,R2
       JLT ATOI5    ; two jumps for last character is faster than two not taken jumps for the rest
ATOI4  CB R1,R4
       JL ATOI2     ; character <'0' then end of number
       CB R1,R3
       JH ATOI2     ; character >'9' then end of number
       SB R4,R1     ; character = character - '0'
       SWPB R1      ; digit is character byte
       MPY R0,R8    ; value = value  ; 10
       MOV R9,R8
       A R1,R8
       SWPB R1      ; make sure low byte of R7 is clear for future iterations
       MOVB R2,R2
       JLT ATOI2    ; if character was inverted then end of number
       MOVB *R5+,R1  ; fetch next digit
       JMP ATOI1
ATOI2  MOVB R6,R6
       JEQ ATOI3
       NEG R8       ; negate result
ATOI3  DEC R5       ; move back to last character of number (or initial character if no number)
       B *R11
ATOI5  INV R1       ; invert last character
       ANDI R1,>FF00  ; clear the low byte FF to 00
       JMP ATOI4
* ITOA convert integer to temporary string (used in PRINT)
* R5 contains value
* R0=character 0, R1=10, R2/R3=don't care/place value, R4/R5=division result, R6=leading 0 flag, R7=pointer to temporary string area (LINBUF)
ITOA   CLR R6        ; suppress leading 0s
       LI R0,'0'*>0100  ; default output
       LI R1,10      ; scale value for digits
       LI R7,LINBUF  ; output location
       LI R3,10000   ; current digit place value
       MOV R5,R5     ; set flags
       JNE ITOA1
       MOVB R0,R4    ; set up to write a zero digit
       JMP ITOA4     ; finish up
ITOA1  JGT ITOA2
       LI R4,'-'*>0100
       MOVB R4,*R7+  ; store minus sign
       NEG R5        ; negate value and continue
ITOA2  CLR R4        ; set top 16 bits of 32 bit dividend to 0
       DIV R3,R4     ; R4=digit, R5=remainder (new value next iteration)
       XOR R4,R6     ; set EQ flag and adjust leading 0 flag at the same time
       JEQ ITOA3     ; if 0 skip output
       SWPB R4
       AB R0,R4      ; adjust for ASCII
       MOVB R4,*R7+  ; store digit character
       SETO R6       ; make sure zero flag can't match any future digit value
ITOA3  CLR R2        ; set top 16 bits of 32 bit dividend to 0
       DIV R1,R2     ; position value / 10
       MOV R2,R3     ; result is new place value
       JNE ITOA2     ; last iteration is 1/10 which sets result in R2 to 0
       DEC R7        ; backup to last character
ITOA4  INV R4        ; invert last character written
       MOVB R4,*R7   ; write it again
       LI R7,LINBUF  ; reset to start of temp string space
       B *R11

* PRTNUM print number by calling ITOA (number in R5) then PRTNEG (pointer in R3)
PRTNUM MOV R11,R15   ; backup return address since ITOA/PRTNEG will use R11 and R12
       BL @ITOA
       MOV R7,R3
       BL @PRTNEG
       B *R15

* print string until a negative character, invert and print it
* R3=pointer; changes R1=last character
PRTNEG MOV R11,R12
       CLR R1
       MOVB *R3,R1
       CI R1,>FF00
       JEQ PRTNER    ; if first character is inverted null then skip printing
       CLR R4
PRTNE1 MOVB *R3+,R1
       JLT PRTNE2
       BL @CHROUT
       JMP PRTNE1
PRTNE2 INV R1
       BL @CHROUT
PRTNER B *R12

* start INIT -----------------------------------------
* Routines to be copied to CPU scratchpad memory for speed
* requires 14 bytes
INITAT INC R10         ; advance TXTPTR
       MOVB *R10,R14   ; get byte in high part of R14
       CB R14,@SPACE
       JEQ INITAT      ; skip spaces
       B *R11          ; return

* Init memory
INIT   LWPI BASWP      ; start using BASIC workspace pointer
       LI R13,STACK    ; STKPTR = &STACK, top of stack
       MOV R13,R0
       LI R1,LINBOT-STACK  ; total bytes to clear
       CLR R2          ; clear to 0
INIT1  MOV R2,*R0+     ; clear a word at a time
       DECT R1         ; count down two bytes (one word)
       JNE INIT1       ; Clear all memory from STACK to before LINBOT
       LI R0,LINBOT
       LI R3,LINBOT+2
       MOV R0,@CURLIN  ; CURLIN = &LINBOT, current line is first line
       MOV R0,@LINTOP  ; LINTOP = &LINBOT, top line is first line
       MOV R2,@CURSOR  ; CURSOR = 0, cursor is at top left of screen
       MOV R0,@RAND1
       MOV R10,@RAND2  ; Random seed is non-zero
       MOV R2,@TXTBOT  ; TXTBOT = 0, no program code
       LI R1,>4000-LINBOT  ; total bytes to clear
       SETO R2         ; clear to -1
       MOV R2,@MEMTOP  ; MEMTOP = >FFFF, memory top is last byte of RAM (no strings)
INIT2  MOV R2,*R0+     ; clear a word at a time
       DECT R1         ; count down two bytes (one word)
       JNE INIT2       ; Set -1 for entire line table
       LI R10,TXTBOT   ; TXTPTR = &TXTBOT
       MOV R10,*R3     ; go back and set TXTBOT for first line table entry's code pointer
       CLR R14
       MOV *R10,R14    ; prepare first character of program
* Init routines
       LI R0,CHRGET
       LI R1,INITAT
       LI R2,CHRSIZ    ; total bytes to copy
INIT3  MOV *R1+,*R0+   ; copy a word at a time
       DECT R2         ; count down two bytes (one word)
       JNE INIT3       ; Copy all memory from INITAT to before INIT (CHRGET routine) into scratchpad for speed
* Init screen
       BL @VDPINI
       LI R3,HELLO
       BL @PRTNEG
* the end of init
       CLR R14          ; make sure low byte is empty so we can always use word compares
       MOVB *R10,R14    ; prefetch character for GETSTT
       LIMI 0           ; disable interrupts
*       LIMI 2           ; INTERRUPT: enable interrupts (required for sound, sprite motion, and timer counters)
       B @NXTSTT        ; start fetching statements from test
* normally branch to main loop, but for testing freeze here
HELLO  TEXT 'JACKALOPE BASIC V1'
       BYTE >0D
       TEXT '24576 BASIC BYTES FREE'
       BYTE >F2
BREAK  BYTE >0D
       TEXT 'BREAK'     ; fall through to also print READY
READY  BYTE >0D
       TEXT 'READY.'
       BYTE >F2
       EVEN

VDPINI MOV R11,R12     ; save return address so VDPREG can be called
* set default register values
       LI R0,>0000     ; VDP register 0, not in bitmap mode
       BL @VDPREG      ; update VDP register
       LI R0,>01E0     ; VDP register 1, 16K VRAM, blank disable, interrupt enable, not text mode, not multicolor mode, standard sprite size, no sprite magnification
       BL @VDPREG      ; update VDP register
       SWPB R0
       MOVB R0,@SHDWR1   ; always write to shadow register for VDP register 1
       LI R0,>0200     ; VDP register 2, screen at                  >0000 to >02FF
       BL @VDPREG      ; update VDP register
       LI R0,>030E     ; VDP register 3, color table at             >0380 to >039F
       BL @VDPREG      ; update VDP register
       LI R0,>0401     ; VDP register 4, pattern table at           >0800 to >0FFF
       BL @VDPREG      ; update VDP register
       LI R0,>0506     ; VDP register 5, sprite attribute list at   >0300 to >037F
       BL @VDPREG      ; update VDP register
       LI R0,>0602     ; VDP register 6, sprite descriptor table at >1000 to >17FF
       BL @VDPREG      ; update VDP register
*       LI R0,>0754     ; VDP register 7, foreground light blue, background dark blue
       LI R0,>0717     ; VDP register 7, foreground black, background cyan
       BL @VDPREG      ; update VDP register
* turn off all sprites
       LI R0,>300      ; sprite 0 y-position
       LI R1,>D000     ; (high byte) disable this and future sprites
       BL @VSBW        ; update VDP RAM
* clear screen
       CLR R0
       LI R1,CSPACE
       LI R2,768
       BL @VMBS
* set default color table (only sets 4-15 where characters 30-95 are defined)
*       LI R1,>5000     ; 5000=light blue on transparent (screen background is dark blue)
       LI R1,>1000     ; 1000=black on transparent (screen background is cyan)
       LI R0,>0384     ; start at character set 4 with space
       LI R2,12        ; stop at character set 15 with cursor
       BL @VMBS
* load upper/lower case font from GROM to VDP RAM (don't change any other characters)
       CLR R0
       LI R4,>4E       ; Load GROM index address for upper/lower case font into r4
       MOVB R4,@GRMWA  ; Setup GROM source byte 1 for reading
       SWPB R4
       MOVB R4,@GRMWA  ; Setup GROM source byte 2 for reading
       MOVB @GRMRD,R5  ; Read font table address byte 1
       SWPB R5 
       MOVB @GRMRD,R5  ; Read font table address byte 2
       SWPB R5 
       MOVB R5,@GRMWA
       SWPB R5
       MOVB R5,@GRMWA  ; Setup GROM address for reading
       LI R4,>0900     ; VDP destination is pattern #32(space) address
       ORI R4,>4000    ; set memory access flag
       SWPB R4
       MOVB R4,@VDPWA  ; write VDP low address byte
       SWPB R4
       MOVB R4,@VDPWA  ; write VDP high address byte
       LI R6,96*7      ; Get number of bytes to copy (characters  ; 7 rows, top row is blank)
       LI R5,>0101     ; every 8th bit used to mark when to inject a spacer row in the character definition
* Copy from GROM to VRAM
FONT1  SRC R5,1        ; rotate low bit into carry
       JNC FONT2
       MOVB R0,@VDPWD  ; on carry insert a blank row in the character definition
       JMP FONT1       ; skip to next iteration
FONT2  MOVB @GRMRD,R4  ; read next row of character from GRAM
       MOVB R4,@VDPWD  ; write it to VRAM
       DEC R6          ; count down number of bytes to copy
       JNE FONT1
* load bonus characters
       SETO R1
       LI R0,127*8+>0800  ; start at character 30 to include cursor character
       LI R2,8        ; stop at character 31 to include edge character
       BL @VMBS
       B *R12
* end INIT -----------------------------------------

* start VIDEO -----------------------------------------
hb$00  BYTE >00       ; Byte 0
SPACE  BYTE >20       ; Byte 32 (also the ASCII space)
B46    BYTE >2E       ; Byte value 46 (also the ASCII period)
B170   BYTE 170       ; Byte value 170
       EVEN
* Utility addresses
KSCAN  DATA UTILWS,KSCAN1  ; UTILWS is only temporary to pass to GPLWS without overwriting R13-15
DSRLNK DATA UTILWS,DSR
SUBLNK DATA UTILWS,SUB

* Video Single Byte Read
* In: R0=VDP address; Out: R1=data
VSBR   SWPB R0
       MOVB R0,@VDPWA  ; write low address byte
       SWPB R0
       MOVB R0,@VDPWA  ; write high address byte
       NOP             ; delay
       MOVB @VDPRD,R1  ; read data
       B *R11

* Video Single Byte Write 
* In: R0=VDP address, R1=data
VSBW   ORI  R0,>4000   ; set memory flag
       SWPB R0
       MOVB R0,@VDPWA  ; write low address byte
       SWPB R0
       MOVB R0,@VDPWA  ; write high address byte
       ANDI R0,>3FFF   ; undo changes to R0
       MOVB R1,@VDPWD  ; write data
       B *R11

* Video Multiple Byte Read
* In: R0=VDP base address, R1=CPU base address, R2=length; modified R1, R2
VMBR   SWPB R0
       MOVB R0,@VDPWA  ; write low address byte
       SWPB R0
       MOVB R0,@VDPWA  ; write high address byte
       NOP             ; delay
VMBR2  MOVB @VDPRD,*R1+  ; write data to CPU and advance source pointer
       DEC  R2         ; count down
       JNE  VMBR2      ; repeat until no bytes to copy
       B *R11

* Video Multiple Byte Write (write different bytes)
* In: R0=VDP base address, R1=CPU base address, R2=length; modified R1, R2
VMBW   ORI  R0,>4000   ; set memory flag
       SWPB R0
       MOVB R0,@VDPWA  ; write low address byte
       SWPB R0
       MOVB R0,@VDPWA  ; write high address byte
       ANDI R0,>3FFF   ; undo changes to R0
VMBW2  MOVB *R1+,@VDPWD  ; write data to VDP and advance source pointer
       DEC  R2         ; count down
       JNE  VMBW2      ; repeat until no bytes to copy
       B *R11

* Video Multiple Byte Stream (write same byte multiple times)
* In: R0=VDP base address, R1=data, R2=length; modified R2
VMBS   ORI  R0,>4000   ; set memory flag
       SWPB R0
       MOVB R0,@VDPWA  ; write low address byte
       SWPB R0
       MOVB R0,@VDPWA  ; write high address byte
       ANDI R0,>3FFF   ; undo changes to R0
VMBS2  MOVB R1,@VDPWD  ; write data
       DEC  R2         ; count down
       JNE  VMBS2      ; repeat until no bytes to copy
       B *R11

* Video Write to Register 
* In: R0={'10, register[5:0], data}
VDPREG ORI  R0,>8000   ; set register flag
       SWPB R0
       MOVB R0,@VDPWA  ; write data
       SWPB R0
       MOVB R0,@VDPWA  ; write register
       ANDI R0,>3FFF   ; undo changes to R0
       B *R11

* Keyboard Scan
* SCAN uses R0,1,2,3,4,5,6,7,8,9,11,12,13,14,15 (really needs BLWP!)
KSCAN1 LWPI GPLWS
       MOV  R11,@UTILWS+22
       BL   @SCAN
       LWPI UTILWS
       MOV  R11,@>83F6
       RTWP

* SUBLNK routine
SUB    LI   R5,10
       JMP  DSR0
* DSRLNK routine
DSR    LI   R5,8
DSR0   SZCB @SPACE,R15
       MOV  @DSRNAM,R0
       MOV  R0,R7
       MOVB @DSRWS0,@VDPWA
       NOP
       MOVB R0,@VDPWA
       AI   R0,-8
       MOVB @VDPRD,R1
       MOVB R1,R3
       JEQ  DSR9
       SRL  R3,8
       SETO R4
       LI   R2,DSRWRK
DSR1   INC  R4
       CI   R4,7
       JH   DSR9
       C    R4,R3
       JEQ  DSR2
       MOVB @VDPRD,R1
       MOVB R1,*R2+
       CB   R1,@B46
       JNE  DSR1
DSR2   CLR  @CRULST
       MOV  R4,@DSRSIZ
       INC  R4
       A    R4,@DSRNAM
       LWPI GPLWS
       CLR  R1
DSR2A  LI   R12,>0F00
DSR3   SBZ  0
DSR3A  AI   R12,>0100
       CLR  @CRULST
       CI   R12,>2000
       JEQ  DSR8
CRUOK  MOV  R12,@CRULST
       SBO  0
       LI   R2,>4000
       CB   *R2,@B170
       JNE  DSR3
       A    @DSRWS5,R2
       JMP  DSR5
DSR4   MOV  @SAVADD,R2
       SBO  0
DSR5   MOV  *R2,R2
       JEQ  DSR3
       MOV  R2,@SAVADD
       INCT R2
       MOV  *R2+,R9
       MOVB @DSRSIZ+1,R5
       JEQ  DSR7
       CB   R5,*R2+
       JNE  DSR4
       SRL  R5,8
       LI   R6,DSRWRK
DSR6   CB   *R6+,*R2+
       JNE  DSR4
       DEC  R5
       JNE  DSR6
DSR7   INC  R1
       BL   *R9
       JMP  DSR4
       SBZ  0
       LWPI UTILWS
       MOV  R7,@DSRNAM
       MOVB @DSRWS0,@VDPWA
       MOVB R0,@VDPWA
       MOVB @VDPRD,R1
       SRL  R1,13
       JNE  DSR10
       RTWP
DSR8   LWPI UTILWS
       MOV  R7,@DSRNAM
DSR9   CLR  R1
DSR10  SWPB R1
       MOVB R1,*R13
       SOCB @SPACE,R15
       RTWP
* end VIDEO -----------------------------------------

* GROM addresses >0000 - >1FFF
SCAN   EQU >02B2  ; >000E is an indirect that just consumes time
CHKCLR EQU >04B2  ; uses R12 only

* CPU scratchpad RAM >8300 - >83FF
BASWP  EQU >8300      ; workspace for BASIC interpretter
CURLIN EQU BASWP+32   ; Save pointer into current line pointer table entry when reading each line (for skipping false IFs)
LINTOP EQU CURLIN+2   ; Pointer to end of line pointers in low memory (word where -1 is found)
MEMTOP EQU LINTOP+2   ; Pointer to end of line strings in high memory (above this usable for strings)
CURSOR EQU MEMTOP+2   ; Cursor position in VDP RAM
RAND1  EQU CURSOR+2   ; Random number
RAND2  EQU RAND1+2    ; Used to generate random number
CHRGET EQU RAND2+2    ; CHRGET routine (for speed)
CHRSIZ EQU INIT-INITAT  ; number of bytes in CHRGET routine
TEMPF1 EQU CHRGET+CHRSIZ  ; fast temp #1 (used in CHROUT and CHKEND and TOKEND and SLOAD/SSAVE)
TEMPF2 EQU TEMPF1+2   ; fast temp #2 (used in CHROUT and TOKARG and SLOAD/SSAVE)
TEMPF3 EQU TEMPF2+2   ; fast temp #3 (used in CHROUT and TOKIZE and SLOAD/SSAVE)
TEMPF4 EQU TEMPF3+2   ; fast temp #4 (used in TOKIZE and SLIST and LSOPT)
TEMPF5 EQU TEMPF4+2   ; fast temp #5 (used in SLIST)
ENDLIN EQU TEMPF5+2   ; End of line flag for SPRINT
NXTPAD EQU ENDLIN+1   ; next scratchpad address (for adding more high speed storage locations)
* 43-53 available (8.5 words/17 bytes)
KEYDEV EQU >8374      ; keyboard device to check (byte)
KEYKEY EQU >8375      ; key pressed (byte)
GPLSTS EQU >837C      ; keyboard and DSR status (byte)
* 80-BF GPL stack not available because of SCAN
GPLWS  EQU >83E0      ; GPL workspace registers

* Low expansion RAM >2000 - >3FFF
STKSIZ EQU >0100      ; size of BASIC stack
GSBSIZ EQU 6          ; size of a GOSUB entry on the stack
FORSIZ EQU 12         ; size of a FOR entry on the stack
LINSIZ EQU >0100      ; size of line input buffer
VDPSIZ EQU >02E0      ; Size of screen minus 1 line (768-32)
STACK  EQU >2000      ; BASIC stack for FOR/NEXT and GOSUB/RETURN statements
LINBUF EQU STACK+STKSIZ  ; Line input buffer (overlap middle of VDPBUF)
VDPBUF EQU LINBUF+LINSIZ  ; Room to save screen minus 1 line, also used for tokenization of input line
       EVEN           ; any workspace register set must be aligned
SYSWS  EQU VDPBUF+VDPSIZ  ; workspace for SYS statement
VARS   EQU SYSWS+32   ; 26 words for variables A-Z
SCROLL EQU VARS+52    ; indicator that last CHROUT resulted in screen scrolling (0=no, -1=yes)
OPENED EQU SCROLL+1   ; indicator that a file is open (0=no, -1=yes)
       EVEN           ; any workspace register set must be aligned
UTILWS EQU OPENED+1   ; workspace for utility routines (only for KSCAN, DSRLNK)
DSRWRK EQU UTILWS+32  ; DSR workspace array (80 bytes)
PABSIZ EQU 26         ; size of PAB
CPUPAB EQU DSRWRK+80  ; File handle assembly point for LOAD/SAVE in CPU RAM
PABADR EQU CPUPAB+2   ; Buffer address in VDP RAM for LOAD/SAVE
PABLEN EQU CPUPAB+6   ; Data length for LOAD/SAVE
PABFNL EQU CPUPAB+9   ; Filename length
PABNAM EQU CPUPAB+10  ; Filename
VDPPAB EQU 14142      ; Actual file handle for LOAD/SAVE in VDP RAM
FILBUF EQU VDPPAB+PABSIZ  ; File buffer for LOAD/SAVE in VDP RAM (just below floppy drive controller reserved space)
NXTLBL EQU CPUPAB+PABSIZ  ; Placeholder for next available address in low memory
LTESIZ EQU 6          ; Line table entry size (6 bytes/3 words)
LINBOT EQU >25C0      ; Equate to start of line pointers in low memory
* Line pointer table entry = WORD line number (-1 is end), WORD pointer (next free byte at end), WORD length (0 at end)
* Starting at >25C0 leaves room for 1120 lines

* High expansion RAM >A000 - >FFFF
TXTBOT EQU >A000      ; Equate to start of lines in high memory

* Hardware bridge register addresses
VDPWA  EQU >8C02      ; VDP RAM write address
VDPRD  EQU >8800      ; VDP RAM read data
VDPWD  EQU >8C00      ; VDP RAM write data
VDPSTA EQU >8802      ; VDP RAM status
SHDWR1 EQU >83D4      ; VDP register 1 shadow (always update)
SOUND  EQU >8400      ; Sound chip register bridge address
* GROM registers
GRMWA  EQU >9C02      ; GROM/GRAM write address
GRMRA  EQU >9802      ; GROM/GRAM read address
GRMRD  EQU >9800      ; GROM/GRAM read data
GRMWD  EQU >9C00      ; GROM/GRAM write data
* Utility constants
DSRSIZ EQU >8354      ; Name length
DSRNAM EQU >8356      ; DSR address
CRULST EQU >83D0      ; CRU list
SAVADD EQU >83D2      ; Save address
DSRWS5 EQU UTILWS+10  ; DSR register 5
DSRWS0 EQU UTILWS+1   ; DSR register 0 low byte
DSROPN EQU >0000      ; OPEN
DSRCLS EQU >0100      ; CLOSE
DSRRD  EQU >0200      ; READ
DSRWR  EQU >0300      ; WRITE

* character codes/joystick
CCLEAR EQU >0200      ; clear (FN+4) [break]
CLEFT  EQU >0800      ; left arrow [delete]
CRIGHT EQU >0900      ; right arrow [tab]
CENTER EQU >0D00      ; enter
CSPACE EQU >2000      ; space
CCURSR EQU >7F00      ; cursor
*JOYB   EQU >0100      ; joystick button
*JOYL   EQU >0200      ; joystick left
*JOYR   EQU >0400      ; joystick right
*JOYD   EQU >0800      ; joystick down
*JOYU   EQU >1000      ; joystick up
* FILE......: rom.header.asm
* Purpose...: Cartridge header

*--------------------------------------------------------------
* Cartridge header
********|*****|*********************|**************************
        byte  >aa                   ; 0  Standard header                   >6000
        byte  >01                   ; 1  Version number
        byte  >02                   ; 2  Number of programs (optional)     >6002
        byte  0                     ; 3  Reserved ('R' = adv. mode FG99)

        data  >0000                 ; 4  \ Pointer to power-up list        >6004
                                    ; 5  /

        ; 
        ; Change to rom.program1 to add the menu option STEVIE x.x.x RESET MEM"
        ; That option can be used in the case where we jump to TI Basic, but
        ; resuming fails afterwards (e.g. memory overwritten by ext. program).
        ;
        ; If resume fails, you can only reset the TI-99/4a by turning of
        ; the memory expansion, it's not sufficient to reset the console.
        ;
        ; Change to rom.program2 to skip menu option "STEVIE x.x.x RESET MEM"
        ;
        data  rom.program1          ; 6  \ Pointer to program list         >6006
                                    ; 7  /

        data  >0000                 ; 8  \ Pointer to DSR list             >6008
                                    ; 9  /

        data  >0000                 ; 10 \ Pointer to subprogram list      >600a
                                    ; 11 /

        ;-----------------------------------------------------------------------
        ; Program list entry
        ;-----------------------------------------------------------------------
rom.program1:
        data  rom.program2          ; 12 \ Next program list entry         >600c
                                    ; 13 / (no more items following)

        data  kickstart.code1       ; 14 \ Program address                 >600e
                                    ; 15 /

        stri 'STEVIE 1.7.6 MEMRESET'
        even

        ;-----------------------------------------------------------------------
        ; Program list entry
        ;-----------------------------------------------------------------------
rom.program2:
        data  >0000                 ; 12 \ Next program list entry         >600c
                                    ; 13 / (no more items following)

        data  kickstart.resume      ; 14 \ Program address                 >600e
                                    ; 15 /

        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor
            stri 'STEVIE 1.7.6'
        .endif

        .ifeq vdpmode, 3081         ; F18a 30x80 character cursor
            stri 'STEVIE 1.7.6'     
        .endif

        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor
            stri 'STEVIE 1.7.6'
        .endif

        .ifeq vdpmode, 2481         ; F18a 24x80 character cursor
            stri 'STEVIE 1.7.6'                   
        .endif

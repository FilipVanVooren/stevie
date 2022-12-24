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
        ; Change to rom.program1 to add the menu option STEVIE RESET.
        ; That option can be used in the case where we jump to TI Basic, 
        ; but resume fails afterwards (because of memory being overwritten).
        ;
        ; If resume fails, you can only reset the TI-99/4a by turning of
        ; the memory expansion, it's not sufficient to reset the console.
        ;
        ; Not sure how many people will use the TI Basic sessions to begin with,
        ; so am turning the menu option off. Having a single menu option on a 
        ; FG99 cartridge is better because you don't have to go through the
        ; TI Selection screen when loaded (e.g. from ForceCommand).
        ;
        data  rom.program2          ; 6  \ Pointer to program list         >6006
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

        stri 'STEVIE RESET'

        ;-----------------------------------------------------------------------
        ; Program list entry
        ;-----------------------------------------------------------------------
rom.program2:
        data  >0000                 ; 12 \ Next program list entry         >600c
                                    ; 13 / (no more items following)

        data  kickstart.resume      ; 14 \ Program address                 >600e
                                    ; 15 /

        .ifeq full_f18a_support,1
            stri 'STEVIE 1.3N'
        .else
            stri 'STEVIE 1.3N-24'
        .endif

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
        data  >0000                 ; 12 \ Next program list entry         >600c
                                    ; 13 / (no more items following)

        data  kickstart.resume      ; 14 \ Program address                 >600e
                                    ; 15 /

        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor
            stri 'STEVIE 1.9.6-24'
        .endif

        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor
            stri 'STEVIE 1.9.6-30'
        .endif

        .ifeq vdpmode, 4880         ; PICO9918 48x80 character cursor
            stri 'STEVIE 1.9.6-48'                   
        .endif

        .ifeq vdpmode, 6080         ; PICO9918 60x80 character cursor
            stri 'STEVIE 1.9.6-60'                   
        .endif        

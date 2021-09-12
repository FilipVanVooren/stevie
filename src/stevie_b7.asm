***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b7.asm               ; Version %%build_date%%
*
* Bank 7 "Jonas"
*
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options        
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
                                    ; grows from high to low.
***************************************************************
* BANK 7
********|*****|*********************|**************************
bankid  equ   bank7.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header        

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Copy spectra2 library into cartridge space
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6046
        bl    @cpu.crash            ; Should never get here

        copy  "%%spectra2%%/runlib.asm"
        copy  "data.constants.asm"  ; Need some constants for SAMS layout
        ;-----------------------------------------------------------------------
        ; Stubs using trampoline
        ;-----------------------------------------------------------------------        
        copy  "rom.stubs.bank7.asm" ; Stubs for functions in other banks      
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;----------------------------------------------------------------------- 
        .ifgt $, >7fbf
              .error 'Aborted. Bank 7 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Vector table
        ;----------------------------------------------------------------------- 
        aorg  >7fc0
        copy  "rom.vectors.bank7.asm"
                                    ; Vector table bank 7

*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table

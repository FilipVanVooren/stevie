***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: reident.asm                 ; Version %%build_date%%
*
* Only for debugging
* Generate list file with contents of resident modules in
* LOW MEMEXP >2000 - >3fff
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "data.keymap.keys.asm"; Equates for keyboard mapping

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
                                    ; grows from high to low.
***************************************************************
* BANK 0
********|*****|*********************|**************************
bankid  equ   bank0.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Code data: Relocated code
********|*****|*********************|**************************
reloc.resident:
        ;------------------------------------------------------
        ; Resident libraries
        ;------------------------------------------------------
        aorg  >2000                 ; Relocate to >2000
        copy  "%%spectra2%%/runlib.asm"
        copy  "ram.resident.asm"        
        ;------------------------------------------------------
        ; Activate bank 1 and branch to >6046
        ;------------------------------------------------------
main:        
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Memory full check
        ;------------------------------------------------------
        .print "***** Relocated libraries @ >2000 - ", $, "(dec)"

        .ifgt $, >3fff
              .error '***** Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif     
*--------------------------------------------------------------
* Video mode configuration for SP2
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


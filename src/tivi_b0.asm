***************************************************************
*                          TiVi Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: tivi_b0.asm                 ; Version %%build_date%%


***************************************************************
* BANK 0 - Spectra2 library
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 0

        copy  "header.asm"
        copy  "kickstart.asm"
        #string 'bank 0'        
        copy  "%%spectra2%%/runlib.asm"

*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprpdt  equ   >1800                 ; VDP sprite pattern table
sprsat  equ   >2000                 ; VDP sprite attribute table

main    jmp   $

        .ifgt $, >7fff
              .error 'Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif
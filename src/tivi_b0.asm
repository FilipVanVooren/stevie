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
        save  >6000,>7fff           ; Save bank 0 (1st bank)
        copy  "equates.asm"         ; Equates TiVi configuration
        copy  "kickstart.asm"       ; Cartridge header
***************************************************************
* Copy runtime library to destination >2000 - >3fff
********|*****|*********************|**************************
kickstart.init:
        li    r0,reloc+2            ; Start of code to relocate
        li    r1,>2000
        li    r2,896                ; Copy 7K (512 * 4 * word size)
kickstart.loop:        
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        dec   r2
        jne   kickstart.loop      
        b     @runlib               ; Start spectra2 library        
***************************************************************
* TiVi entry point after spectra2 initialisation
********|*****|*********************|**************************
        aorg  kickstart.code2
main    clr   @>6002                ; Jump to bank 1 (2nd bank)
                                    ;--------------------------
                                    ; Should not get here
                                    ;--------------------------
        li    r0,main                                    
        mov   r0,@>ffce             ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system           
***************************************************************
* Spectra2 library
********|*****|*********************|**************************
reloc   nop                         ; Anchor for copy command
        xorg >2000                  ; Relocate all spectra2 code to >2000
        copy  "%%spectra2%%/runlib.asm"

        .ifgt $, >7fff
              .error 'Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif


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
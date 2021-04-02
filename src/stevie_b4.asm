***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b4.asm               ; Version %%build_date%%
*
* Bank 4 "Janine"
*
***************************************************************
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
                                    ; grows downwards to >2000
***************************************************************
* BANK 4
********|*****|*********************|**************************
bankid  equ   bank4                 ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6030
        clr   @bank0                ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Satisfy assembler, must know SP2 in low MEMEXP
********|*****|*********************|**************************
        aorg  >2000                 
        copy  "%%spectra2%%/runlib.asm"
                                    ; Relocated spectra2 in low MEMEXP, was
                                    ; copied to >2000 from ROM in bank 0
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------
        data >dead,>beef,>dead,>beef     
        .print "***** PC relocated SP2 library @ >2000 - ", $, "(dec)"                                    
***************************************************************
* Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
********|*****|*********************|**************************
        aorg  >3000
        ;------------------------------------------------------
        ; Activate bank 1 and branch to >6036
        ;------------------------------------------------------
        clr   @bank1                ; Activate bank 1 "James"
        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Resident Stevie modules: >3000 - >3fff
        ;------------------------------------------------------
        copy  "ram.resident.3000.asm"        
***************************************************************
* Step 4: Include main editor modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6036
        bl    @cpu.crash            ; Should never get here
        ;-----------------------------------------------------------------------
        ; Logic for Framebuffer (2)
        ;-----------------------------------------------------------------------    
        copy  "fb.utils.asm"        ; Framebuffer utilities
        copy  "fb.null2char.asm"    ; Replace null characters in framebuffer row
        copy  "fb.tab.next.asm"     ; Move cursor to next tab position
        ;-----------------------------------------------------------------------
        ; Stubs using trampoline
        ;-----------------------------------------------------------------------        
        copy  "rom.stubs.bank4.asm" ; Stubs for functions in other banks      
        ;-----------------------------------------------------------------------
        ; Bank specific vector table
        ;----------------------------------------------------------------------- 
        .ifgt $, >7f9b
              .error 'Aborted. Bank 3 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif
        ;-------------------------------------------------------
        ; Vector table bank 4: >7f9c - >7fff
        ;-------------------------------------------------------
        copy  "rom.vectors.bank4.asm"

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

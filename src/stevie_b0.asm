***************************************************************
*                         Stevie Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: stevie_b0.asm               ; Version %%build_date%%


***************************************************************
* BANK 0 - Spectra2 library
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 0 (1st bank)
        copy  "equates.asm"         ; Equates TiVi configuration
        copy  "kickstart.asm"       ; Cartridge header
***************************************************************
* Copy SP2 ROM to >2000 - >2fff
********|*****|*********************|**************************
kickstart.init:
        li    r0,reloc.sp2+2        ; Start of code to relocate
        li    r1,>2000
        li    r2,512                ; Copy 4K (256 * 4 words)
kickstart.copy.sp2:        
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        dec   r2
        jne   kickstart.copy.sp2
***************************************************************
* Copy Stevie ROM to >3000 - >3fff
********|*****|*********************|**************************
        li    r0,main+2             ; Start of code to relocate
        li    r1,>3000
        li    r2,512                ; Copy 4K (256 * 4 words)
kickstart.copy.stevie:        
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        mov   *r0+,*r1+        
        dec   r2
        jne   kickstart.copy.stevie
***************************************************************
* Trigger SP2 initialisation
********|*****|*********************|**************************
        b     @runlib               ; Start spectra2 library        
        ;------------------------------------------------------
        ; Assert. Should not get here! Crash and burn!
        ;------------------------------------------------------
        li    r0,main              
        mov   r0,@>ffce             ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system           
***************************************************************
* SP2 relocated code >2000 - >2fff (4K maximum)
********|*****|*********************|**************************
reloc.sp2:
        nop                         ; Anchor for copy ROM command
        xorg >2000                  ; Relocate SP2 code to >2000
        copy  "%%spectra2%%/runlib.asm"
                                    ; Spectra 2
        copy  "data.constants.asm"  ; Data segment - Constants  

        ;---------------------------------------;
        ; TO DO FILL up to >6fff with blanks!!! ;
        ;---------------------------------------;

***************************************************************
* Stevie relocated code >3000 - >3fff (4K maximum)
********|*****|*********************|**************************
main:
        nop                         ; Anchor for copy ROM command     
        xorg  >3000                 ; Relocate Stevie modules to >3000
        ;------------------------------------------------------
        ; Activate bank 1
        ;------------------------------------------------------
        clr   @>6002                ; Activate bank 1 (2nd bank!)
        b     @kickstart.code2      ; Jump to entry routine

        copy  "fh.read.sams.asm"    ; File handler read file
        copy  "mem.asm"             ; Memory Management

        .ifgt $, >7fff
              .error 'Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif

; >>>>>>>>>>>>>>>> NEEED TO FIX THIS FIRST!!! >>>>>>>>>>>>>>>>>>>>>>>>>><

idx.entry.update:
        nop

idx.pointer.get:
        nop        

; >>>>>>>>>>>>>>>> NEEED TO FIX THIS FIRST!!! >>>>>>>>>>>>>>>>>>>>>>>>>><

module.end: 
        data >dead,>beef,>dead,>beef

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
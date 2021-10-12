***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b0.asm               ; Version %%build_date%%
*
* Bank 0 "Jill"
* Setup resident SP2/Stevie modules and start SP2 kernel
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
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Copy resident modules from ROM to RAM >2000 - >3fff
********|*****|*********************|**************************
        li    r0,reloc.resident     ; Start of code to relocate
        li    r1,>2000
        li    r2,512                ; Copy 8K (512 * 16 bytes)
        bl    @kickstart.copy       ; Copy memory
***************************************************************
* Step 4: Start SP2 kernel (runs in low MEMEXP)
********|*****|*********************|**************************
        b     @runlib               ; Start spectra2 library        
                                    ; "main" in low MEMEXP is automatically
                                    ; called by SP2 runlib.
        ;------------------------------------------------------
        ; Assert. Should not get here! Crash and burn!
        ;------------------------------------------------------
        li    r0,$                  ; Current location
        mov   r0,@>ffce             ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system           
***************************************************************
* Copy routine 
********|*****|*********************|**************************
kickstart.copy:
        ;------------------------------------------------------
        ; Copy memory to destination
        ; r0 = Source CPU address
        ; r1 = Target CPU address
        ; r2 = Bytes to copy/16
        ;------------------------------------------------------
!       mov   *r0+,*r1+             ; Copy word 1
        mov   *r0+,*r1+             ; Copy word 2
        mov   *r0+,*r1+             ; Copy word 3
        mov   *r0+,*r1+             ; Copy word 4
        mov   *r0+,*r1+             ; Copy word 5
        mov   *r0+,*r1+             ; Copy word 6
        mov   *r0+,*r1+             ; Copy word 7
        mov   *r0+,*r1+             ; Copy word 8
        dec   r2
        jne   -!                    ; Loop until done
        b     *r11                  ; Return to caller

***************************************************************
* Code data: Relocated code
********|*****|*********************|**************************
reloc.resident:
        ;------------------------------------------------------
        ; Resident libraries
        ;------------------------------------------------------
        xorg  >2000                 ; Relocate to >2000
        copy  "runlib.asm"
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
spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table        
sprpdt  equ   >2800                 ; VDP sprite pattern table


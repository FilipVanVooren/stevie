***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2022 // Filip van Vooren
***************************************************************
* File: stevie_b0.asm               ; Version %%build_date%%
*
* Bank 0 "Jill"
* Setup resident SP2/Stevie modules and start SP2 kernel
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank ordster "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "data.keymap.keys.asm"; Equates for keyboard mapping

***************************************************************
* BANK 0
********|*****|*********************|**************************
bankid  equ   bank0.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>8000           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Setup SAMS banks (inline code because no SP2 yet!)
********|*****|*********************|**************************
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper                
        sbo   0                     ; Enable access to SAMS registers
        clr   r0                    ; \ Page 0 in >2000 - >2fff
        movb  r0,@>4004             ; / 

        li    r0,>0100              ; \ Page 1 in >3000 - >3fff
        movb  r0,@>4006             ; / 

        li    r0,>0400              ; \ Page 4 in >a000 - >afff
        movb  r0,@>4014             ; / 

        li    r0,>2000              ; \ Page 20 in >b000 - >bfff
        movb  r0,@>4016             ; / 

        li    r0,>4000              ; \ Page 40 in >c000 - >bfff
        movb  r0,@>4018             ; / 

        li    r0,>0500              ; \ Page 5 in >d000 - >dfff
        movb  r0,@>401a             ; / 

        li    r0,>0600              ; \ Page 6 in >ec000 - >efff
        movb  r0,@>401c             ; / 

        li    r0,>0700              ; \ Page 7 in >f000 - >ffff
        movb  r0,@>401e             ; / 

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper

***************************************************************
* Step 3: Copy resident modules from ROM to RAM >2000 - >3fff
********|*****|*********************|**************************
        li    r0,reloc.resident     ; Start of code to relocate
        li    r1,>2000
        li    r2,512                ; Copy 8K (512 * 16 bytes)
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
***************************************************************
* Step 4: Start SP2 kernel (runs in low MEMEXP)
********|*****|*********************|**************************
        b     @runlib               ; Start spectra2 library        
                                    ; "main" in low MEMEXP is automatically
                                    ; called by SP2 runlib.
        ;------------------------------------------------------
        ; Assert. Should not get here!
        ;------------------------------------------------------
        li    r0,$                  ; Current location
        mov   r0,@>ffce             ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system           

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
        ; Stevie main entry point
        ;------------------------------------------------------
main:        
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine >6046
        ;------------------------------------------------------
        ; Memory full check
        ;------------------------------------------------------
        .print "***** Relocated libraries @ >2000 - ", $, "(dec)"

        .ifgt $, >3fff
              .error '***** Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
        .endif     
        ;-----------------------------------------------------------------------
        ; Show bank in CPU crash screen
        ;-----------------------------------------------------------------------         
cpu.crash.showbank:
        aorg >7fb0
        bl    @putat
              byte 3,20
              data cpu.crash.showbank.bankstr
        jmp   $
cpu.crash.showbank.bankstr:
        #string 'ROM#0'
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
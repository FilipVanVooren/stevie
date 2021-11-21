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
* Framebuffer methods delegated from bank 1
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options        
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "data.keymap.keys.asm"; Equates for keyboard mapping        
s
***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >af00             ; SP2 stack >ae00 - >aeff
                                    ; grows from high to low.
***************************************************************
* BANK 4
********|*****|*********************|**************************
bankid  equ   bank4.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>8000           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header        

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Satisfy assembler, must know relocated code
********|*****|*********************|**************************
        aorg  >2000                 ; Relocate to >2000
        copy  "runlib.asm"
        copy  "ram.resident.asm"        
        ;------------------------------------------------------
        ; Activate bank 1 and branch to  >6036
        ;------------------------------------------------------
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
***************************************************************
* Step 3: Include main editor modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6046
        bl    @cpu.crash            ; Should never get here
        ;-----------------------------------------------------------------------
        ; Logic for Framebuffer (2)
        ;-----------------------------------------------------------------------    
        copy  "fb.utils.asm"        ; Framebuffer utilities
        copy  "fb.null2char.asm"    ; Replace null characters in framebuffer row
        copy  "fb.tab.next.asm"     ; Move cursor to next tab position
        copy  "fb.ruler.asm"        ; Setup ruler with tab positions in memory                
        copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer        
        copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT        
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------        
        copy  "rom.stubs.bank4.asm" ; Stubs for functions in other banks      
        ;-----------------------------------------------------------------------
        ; Program data
        ;----------------------------------------------------------------------- 
        ; Not applicable
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;----------------------------------------------------------------------- 
        .ifgt $, >7faf
              .error 'Aborted. Bank 2 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------         
cpu.crash.showbank:
        aorg >7fb0
        bl    @putat
              byte 3,20
              data cpu.crash.showbank.bankstr
        jmp   $
cpu.crash.showbank.bankstr:
        #string 'ROM#4'
        ;-----------------------------------------------------------------------
        ; Vector table
        ;----------------------------------------------------------------------- 
        aorg  >7fc0
        copy  "rom.vectors.bank4.asm"
                                    ; Vector table bank 4

*--------------------------------------------------------------
* Video mode configuration
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

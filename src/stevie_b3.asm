***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b3.asm               ; Version %%build_date%%
*
* Bank 3 "John"
* Dialogs & Command Buffer pane
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
* BANK 3
********|*****|*********************|**************************
bankid  equ   bank3.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Satisfy assembler, must know relocated code
********|*****|*********************|**************************
        xorg  >2000                 ; Relocate to >2000
        copy  "%%spectra2%%/runlib.asm"
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
        ; Include files - Shared code
        ;-----------------------------------------------------------------------         

        ;-----------------------------------------------------------------------
        ; Include files - Dialogs
        ;-----------------------------------------------------------------------         
        copy  "dialog.menu.asm"     ; Dialog "Stevie Menu"
        copy  "dialog.about.asm"    ; Dialog "About"
        copy  "dialog.file.asm"     ; Dialog "File"
        copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
        copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
        copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
        copy  "dialog.basic.asm"    ; Dialog "Basic"
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------        
        copy  "pane.utils.hint.asm" ; Show hint in pane        
        copy  "pane.cmdb.show.asm"  ; Show command buffer pane
        copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
        copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
        copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
        copy  "cmdb.cmd.asm"        ; Command line handling 
        ;-----------------------------------------------------------------------
        ; Toggle fastmode in Load/Save DV80 dialogs
        ;-----------------------------------------------------------------------        
        copy  "fm.fastmode.asm"     ; Turn fastmode on/off for file operation 
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------        
        copy  "rom.stubs.bank3.asm" ; Stubs for functions in other banks 
        ;-----------------------------------------------------------------------
        ; Basic interpreter handling
        ;-----------------------------------------------------------------------         
        copy  "run.tibasic.asm"     ; Run TI Basic in GPL Interpreter        
        ;-----------------------------------------------------------------------
        ; Data
        ;-----------------------------------------------------------------------         
        copy  "data.strings.bank3.asm" ; Strings used in bank 3
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;----------------------------------------------------------------------- 
        .ifgt $, >7e00
              .error 'Aborted. Bank 3 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Scratchpad memory dump
        ;----------------------------------------------------------------------- 
        aorg >7e00
        copy  "data.scrpad.asm"     ; Required for TI Basic
        ;-----------------------------------------------------------------------
        ; Vector table
        ;----------------------------------------------------------------------- 
        aorg  >7fc0
        copy  "rom.vectors.bank3.asm"
                                    ; Vector table bank 3


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
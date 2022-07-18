***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2022 // Filip van Vooren
***************************************************************
* File: stevie_b3.asm
*
* Bank 3 "John"
* Dialogs & Command Buffer pane
***************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "equates.c99.asm"     ; Equates related to classic99 emulator
        copy  "equates.tib.asm"     ; Equates related to TI Basic session
        copy  "equates.keys.asm"    ; Equates for keyboard mapping

****************************************************s***********
* BANK 3
********|*****|*********************|**************************
bankid  equ   bank3.rom             ; Set bank identifier to current bank
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
        ; Include files - Shared code
        ;-----------------------------------------------------------------------

        ;-----------------------------------------------------------------------
        ; Include files - Dialogs
        ;-----------------------------------------------------------------------
        copy  "dialog.menu.asm"      ; Dialog "Stevie Menu"
        copy  "dialog.help.asm"      ; Dialog "Help"
        copy  "dialog.file.asm"      ; Dialog "File"
        copy  "dialog.cartridge.asm" ; Dialog "Cartridge"
        copy  "dialog.load.asm"      ; Dialog "Load file"
        copy  "dialog.save.asm"      ; Dialog "Save file"
        copy  "dialog.print.asm"     ; Dialog "Print file"
        copy  "dialog.append.asm"    ; Dialog "Append file"
        copy  "dialog.insert.asm"    ; Dialog "Insert file at line"
        copy  "dialog.config.asm"    ; Dialog "Configure"
        copy  "dialog.clipdev.asm"   ; Dialog "Configure clipboard"
        copy  "dialog.editor.asm"    ; Dialog "Configure editor"
        copy  "dialog.clipboard.asm" ; Dialog "Copy from clipboard"
        copy  "dialog.unsaved.asm"   ; Dialog "Unsaved changes"
        copy  "dialog.basic.asm"     ; Dialog "Basic"
        copy  "dialog.shortcuts.asm" ; Dialog "Shortcuts"
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------
        copy  "pane.utils.hint.asm" ; Show hint in pane
        copy  "pane.cmdb.show.asm"  ; Show command buffer pane
        copy  "pane.cmdb.hide.asm"  ; Hide command buffer pane
        copy  "pane.cmdb.draw.asm"  ; Draw command buffer pane contents
        copy  "error.display.asm"   ; Show error message
        copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
        copy  "cmdb.cmd.asm"        ; Command line handling
        copy  "cmdb.cmd.set.asm"    ; Set command line to preset value
        copy  "cmdb.cmd.preset.asm" ; Preset shortcuts in dialogs
        ;-----------------------------------------------------------------------
        ; Dialog toggles
        ;-----------------------------------------------------------------------
        copy  "fm.fastmode.asm"     ; Toggle fastmode on/off for file operation
        copy  "tib.dialog.helper.asm"
                                    ; Helper functions for TI Basic dialog
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank3.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.dialogs.asm"        ; Strings used in bank 3
        copy  "data.keymap.presets.asm" ; Shortcut presets in dialogs
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f00
              .error 'Aborted. Bank 3 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------
        copy  "rom.crash.asm"
        ;-----------------------------------------------------------------------
        ; Vector table
        ;-----------------------------------------------------------------------
        copy  "rom.vectors.bank3.asm"
                                    ; Vector table bank 3
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

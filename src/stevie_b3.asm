********************************************************************************
*   Stevie
*   Modern Programming Editor for the Texas Instruments TI-99/4a Home Computer.
*   Copyright (C) 2018-2023 / Filip van Vooren
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <https://www.gnu.org/licenses/>.
********************************************************************************
* File: stevie_b3.asm
*
* Bank 3 "John"
* Dialogs & Command Buffer pane
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.vdp.asm"     ; VDP configuration (F18a/9938/...)
        copy  "equates.asm"         ; Stevie main configuration
        copy  "equates.c99.asm"     ; Classic99 emulator configuration
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
        copy  "rom.resident.asm"
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
        ; Dialogs (1)
        ;-----------------------------------------------------------------------
        copy  "dialog.menu.asm"         ; Dialog "Stevie Menu"
        copy  "dialog.file.asm"         ; Dialog "File"
        copy  "dialog.cartridge.asm"    ; Dialog "Cartridge"
        copy  "dialog.help.asm"         ; Dialog "Help"        
        copy  "dialog.load.asm"         ; Dialog "Load file"
        copy  "dialog.save.asm"         ; Dialog "Save file"
        copy  "dialog.print.asm"        ; Dialog "Print file"
        copy  "dialog.append.asm"       ; Dialog "Append file"
        copy  "dialog.insert.asm"       ; Dialog "Insert file at line"
        copy  "dialog.cfg.asm"          ; Dialog "Configure"
        copy  "dialog.cfg.clip.asm"     ; Dialog "Configure clipboard"
        copy  "dialog.cfg.mc.asm"       ; Dialog "Configure Master Catalog"
        copy  "dialog.font.asm"         ; Dialog "Configure font"
        copy  "dialog.clipboard.asm"    ; Dialog "Copy from clipboard"
        copy  "dialog.unsaved.asm"      ; Dialog "Unsaved changes"
        copy  "dialog.basic.asm"        ; Dialog "Basic"
        copy  "dialog.shortcuts.asm"    ; Dialog "Shortcuts"
        copy  "dialog.goto.asm"         ; Dialog "Goto"
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------
        copy  "pane.utils.hint.asm"     ; Show hint in pane
        copy  "pane.utils.dialog.asm"   ; Dialog utility functions        
        copy  "pane.cmdb.show.asm"      ; Show command buffer pane
        copy  "pane.cmdb.hide.asm"      ; Hide command buffer pane
        copy  "pane.cmdb.draw.asm"      ; Draw command buffer pane contents
        copy  "error.display.asm"       ; Show error message
        copy  "cmdb.refresh.asm"        ; Refresh command buffer contents
        copy  "cmdb.cmd.asm"            ; Command line handling
        copy  "cmdb.cmd.set.asm"        ; Set command line to preset value
        copy  "cmdb.cmd.preset.asm"     ; Preset shortcuts in dialogs
        copy  "cmdb.cfg.fname.asm"      ; Configure filename
        ;-----------------------------------------------------------------------
        ; Dialog toggles
        ;-----------------------------------------------------------------------
        copy  "fm.fastmode.asm"         ; Toggle Fastmode IO for file operation
        copy  "fm.lineterm.asm"         ; Toggle line termination mode
        copy  "tib.dialog.helper.asm"   ; Helper functions for TI Basic dialog
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank3.asm"     ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"     ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.dialogs.asm"        ; Dialog strings used in bank 3
        copy  "data.keymap.presets.asm" ; Shortcut presets in dialogs
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f00
              .error 'Aborted. Bank 3 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------
        copy  "rom.crash.asm"
        ;-----------------------------------------------------------------------
        ; Table for VDP modes
        ;-----------------------------------------------------------------------
        copy  "data.vdpmodes.asm"   ; Table for VDP modes        
        ;-----------------------------------------------------------------------
        ; Vector table
        ;-----------------------------------------------------------------------
        copy  "rom.vectors.bank3.asm"
                                    ; Vector table bank 3

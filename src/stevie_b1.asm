********************************************************************************
*   Stevie
*   Modern Programming Editor for the Texas Instruments TI-99/4a Home Computer.
*   Copyright (C) 2018-2022 / Filip van Vooren
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
* File: stevie_b1.asm
*
* Bank 1 "James"
* Editor core
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "equates.c99.asm"     ; Equates related to classic99 emulator
        copy  "equates.keys.asm"    ; Equates for keyboard mapping

***************************************************************
* BANK 1
********|*****|*********************|**************************
bankid  equ   bank1.rom             ; Set bank identifier to current bank
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
        b     @main.stevie          ; Start editor
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"                    ; Main file (entrypoint)
        ;-----------------------------------------------------------------------
        ; Low-level modules
        ;-----------------------------------------------------------------------
        copy  "mem.sams.setup.asm"          ; SAMS memory setup for Stevie
        ;-----------------------------------------------------------------------
        ; Keyboard actions
        ;-----------------------------------------------------------------------
        copy  "edkey.key.hook.asm"          ; SP2 user hook: keyboard scanning
        copy  "edkey.key.process.asm"       ; Process keyboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Framebuffer (1)
        ;-----------------------------------------------------------------------
        copy  "edkey.fb.mov.leftright.asm"  ; Move left / right / home / end
        copy  "edkey.fb.mov.word.asm"       ; Move previous / next word
        copy  "edkey.fb.mov.hscroll.asm"    ; Scroll left / right
        copy  "edkey.fb.mov.updown.asm"     ; Move line up / down
        copy  "edkey.fb.mov.paging.asm"     ; Move page up / down
        copy  "edkey.fb.mov.topbot.asm"     ; Move file top / bottom
        copy  "edkey.fb.goto.asm"           ; Goto line in editor buffer
        copy  "edkey.fb.del.asm"            ; Delete characters or lines
        copy  "edkey.fb.ins.asm"            ; Insert characters or lines
        copy  "edkey.fb.mod.asm"            ; Actions for modifier keys
        copy  "edkey.fb.ruler.asm"          ; Toggle ruler on/off
        copy  "edkey.fb.misc.asm"           ; Miscelanneous actions
        copy  "edkey.fb.file.decinc.asm"    ; Filename increase/decrease suffix
        copy  "edkey.fb.file.load.asm"      ; Load file into editor
        copy  "edkey.fb.file.predef.asm"    ; Load predefined file into editor
        copy  "edkey.fb.block.asm"          ; Actions block move/copy/delete...
        copy  "edkey.fb.tabs.asm"           ; tab-key related actions
        copy  "edkey.fb.clip.asm"           ; Clipboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Command Buffer
        ;-----------------------------------------------------------------------
        copy  "edkey.cmdb.mov.asm"          ; Actions for movement keys
        copy  "edkey.cmdb.mod.asm"          ; Actions for modifier keys
        copy  "edkey.cmdb.misc.asm"         ; Miscelanneous actions
        copy  "edkey.cmdb.file.new.asm"     ; New file
        copy  "edkey.cmdb.file.load.asm"    ; Open file
        copy  "edkey.cmdb.file.insert.asm"  ; Insert file
        copy  "edkey.cmdb.file.append.asm"  ; Append file
        copy  "edkey.cmdb.file.clip.asm"    ; Copy clipboard to line
        copy  "edkey.cmdb.file.clipdev.asm" ; Configure clipboard device
        copy  "edkey.cmdb.file.save.asm"    ; Save file
        copy  "edkey.cmdb.file.print.asm"   ; Print file
        copy  "edkey.cmdb.dialog.asm"       ; Dialog specific actions
        copy  "edkey.cmdb.shortcuts.asm"    ; Shortcuts menu actions
        copy  "edkey.cmdb.goto.asm"         ; Goto line
        copy  "edkey.cmdb.font.asm"         ; Set font
        copy  "cmdb.dialog.close.asm"       ; Close dialog
        ;-----------------------------------------------------------------------
        ; Logic for Editor Buffer
        ;-----------------------------------------------------------------------
        copy  "edb.line.pack.fb.asm"        ; Pack line into editor buffer
        copy  "edb.line.unpack.fb.asm"      ; Unpack line from editor buffer
        ;-----------------------------------------------------------------------
        ; Background tasks
        ;-----------------------------------------------------------------------
        copy  "task.vdp.panes.asm"          ; Draw editor panes in VDP
        ;-----------------------------------------------------------------------
        ; Screen pane utilities
        ;-----------------------------------------------------------------------
        copy  "pane.utils.colorscheme.asm"  ; Colorscheme handling in panes
        copy  "pane.cursor.asm"             ; Cursor utility functions
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------
        copy  "colors.line.set.asm"         ; Set color combination for line
        copy  "pane.topline.asm"            ; Top line
        copy  "pane.errline.asm"            ; Error line
        copy  "pane.botline.asm"            ; Bottom line
        copy  "pane.vdpdump.asm"            ; Dump panes to VDP memory
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank1.asm"         ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"         ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.keymap.actions.asm"     ; Keyboard actions
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f4f
              .error 'Aborted. Bank 1 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------
        copy  "rom.crash.asm"
        ;-----------------------------------------------------------------------
        ; Vector table
        ;-----------------------------------------------------------------------
        copy  "rom.vectors.bank1.asm"
                                    ; Vector table bank 1
*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
spfont  equ   nofont                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table

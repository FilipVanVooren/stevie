********************************************************************************
*   Stevie
*   Modern Programming Editor for the Texas Instruments TI-99/4a Home Computer.
*   Copyright (C) 2018-2024 / Filip van Vooren
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
        copy  "equ.rom.build.asm"   ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        ;-----------------------------------------------------------------------
        ; Equates
        ;-----------------------------------------------------------------------    
        copy  "equ.vdp.asm"         ; VDP configuration (F18a/9938/...)
        copy  "equ.asm"             ; Stevie main configuration
        copy  "equ.c99.asm"         ; Classic99 emulator configuration
        copy  "equ.keys.asm"        ; Equates for keyboard mapping

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
        copy  "edkey.fb.mov.paging.asm"     ; Move page up / down
        copy  "edkey.fb.mov.topbot.asm"     ; Move file top / bottom
        copy  "edkey.fb.goto.asm"           ; Goto line in editor buffer
        copy  "edkey.fb.del.asm"            ; Delete characters or lines
        copy  "edkey.fb.ins.asm"            ; Insert characters or lines
        copy  "edkey.fb.mod.asm"            ; Actions for modifier keys
        copy  "edkey.fb.ruler.asm"          ; Toggle ruler on/off
        copy  "edkey.fb.misc.asm"           ; Miscelanneous actions
        copy  "edkey.fb.file.prev.asm"      ; Previous file in catalog file list
        copy  "edkey.fb.file.next.asm"      ; Next file in catalog file list
        copy  "edkey.fb.file.load.asm"      ; Load file into editor
        copy  "edkey.fb.block.asm"          ; Actions block move/copy/delete...
        copy  "edkey.fb.tabs.asm"           ; tab-key related actions
        copy  "edkey.fb.clip.asm"           ; Clipboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Command Buffer
        ;-----------------------------------------------------------------------
        copy  "edkey.cmdb.mov.asm"          ; Actions for movement keys
        copy  "edkey.cmdb.mod.asm"          ; Actions for modifier keys
        copy  "edkey.cmdb.misc.asm"         ; Miscelanneous actions
        copy  "edkey.cmdb.cfg.clip.asm"     ; Configure clipboard
        copy  "edkey.cmdb.file.new.asm"     ; New file
        copy  "edkey.cmdb.file.load.asm"    ; Open file
        copy  "edkey.cmdb.file.insert.asm"  ; Insert file
        copy  "edkey.cmdb.file.append.asm"  ; Append file
        copy  "edkey.cmdb.file.clip.asm"    ; Copy clipboard to line
        copy  "edkey.cmdb.file.save.asm"    ; Save file
        copy  "edkey.cmdb.file.print.asm"   ; Print file
        copy  "edkey.cmdb.file.dir.asm"     ; Drive/Directory listing
        copy  "edkey.cmdb.pick.prev.asm"    ; Pick previous file in catalog
        copy  "edkey.cmdb.pick.next.asm"    ; Pick next file in catalog
        copy  "edkey.cmdb.dialog.asm"       ; Dialog specific actions
        copy  "edkey.cmdb.shortcuts.asm"    ; Shortcuts menu actions
        copy  "edkey.cmdb.goto.asm"         ; Goto line
        copy  "edkey.cmdb.font.asm"         ; Set font
        copy  "edkey.cmdb.filebrowser.prev.asm"
                                            ; Previous page in filebrowser
        copy  "edkey.cmdb.filebrowser.next.asm"
                                            ; Next page in filebrowser
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
        copy  "pane.colorscheme.cycle.asm"  ; Cycle through color schemes
        copy  "pane.colorscheme.load.asm"   ; Load color scheme
        copy  "pane.colorscheme.status.asm" ; Set colors on status lines
        copy  "pane.cursor.asm"             ; Cursor utility functions
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------
        copy  "pane.vdpdump.asm"            ; Dump panes to VDP memory
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank1.asm"         ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"         ; Stubs to include in all banks
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.keymap.actions.asm"     ; Keyboard actions
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f00
              .error 'Aborted. Bank 1 cartridge program too large!'
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
        copy  "rom.vectors.bank1.asm"
                                    ; Vector table bank 1

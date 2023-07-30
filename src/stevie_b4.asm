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
* File: stevie_b4.asm
*
* Bank 4 "Janine"
* Delegated Frame Buffer methods & Pane utilities
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "equ.rom.build.asm"   ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equ.vdp.asm"         ; VDP configuration (F18a/9938/...)
        copy  "equ.asm"             ; Stevie main configuration
        copy  "equ.c99.asm"         ; Classic99 emulator configuration
        copy  "equ.tib.asm"         ; Equates related to TI Basic session
        copy  "equ.keys.asm"        ; Equates for keyboard mapping

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
        ; Logic for Framebuffer
        ;-----------------------------------------------------------------------
        copy  "fb.cursor.top.asm"   ; Cursor top of file
        copy  "fb.cursor.topscr.asm"; Cursor top of screen
        copy  "fb.cursor.bot.asm"   ; Cursor bottom of file        
        copy  "fb.cursor.botscr.asm"; Cursor bottom of screen        
        copy  "fb.cursor.up.asm"    ; Cursor up
        copy  "fb.cursor.down.asm"  ; Cursor down
        copy  "fb.cursor.home.asm"  ; Cursor home        
        copy  "fb.insert.line.asm"  ; Insert new line
        copy  "fb.insert.char.asm"  ; Insert character
        copy  "fb.replace.char.asm" ; Replace character
        copy  "fb.null2char.asm"    ; Replace null characters in framebuffer row
        copy  "fb.tab.prev.asm"     ; Move cursor to previous tab position
        copy  "fb.tab.next.asm"     ; Move cursor to next tab position
        copy  "fb.goto.toprow.asm"  ; Refresh FB with top-row and row offset
        copy  "fb.ruler.asm"        ; Setup ruler with tab positions in memory
        copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer
        copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
        copy  "fb.scan.fname.asm"   ; Scan line for device & filename
        copy  "fb.hscroll.asm"      ; Horizontal scroll frame buffer
        copy  "fb.restore.asm"      ; Restore framebuffer to normal opr.
        copy  "fb.refresh.asm"      ; Refresh framebuffer
        copy  "fb.get.nonblank.asm" ; Get column of first non-blank char
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------
        copy  "pane.topline.asm"      ; Top line
        copy  "pane.botline.asm"      ; Bottom line
        copy  "pane.botline.busy.asm" ; Bottom line busy indicator        
        copy  "pane.errline.asm"      ; Error line        
        copy  "pane.utils.hint.asm"   ; Show hint in pane
        ;-----------------------------------------------------------------------
        ; Dialogs (2)
        ;-----------------------------------------------------------------------                
        copy  "dialog.help.content.asm" ; Draw help dialog content
        copy  "dialog.fbrowser.asm"     ; File browser
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank4.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        ;
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f00
              .error 'Aborted. Bank 4 cartridge program too large!'
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
        copy  "rom.vectors.bank4.asm"
                                    ; Vector table bank 4

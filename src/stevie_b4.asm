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
* File: stevie_b4.asm
*
* Bank 4 "Janine"
* Framebuffer methods
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "equates.c99.asm"     ; Equates related to classic99 emulator
        copy  "equates.tib.asm"     ; Equates related to TI Basic session
        copy  "equates.keys.asm"    ; Equates for keyboard mapping

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
        copy  "fb.cursor.up.asm"    ; Cursor up
        copy  "fb.cursor.down.asm"  ; Cursor down
        copy  "fb.cursor.home.asm"  ; Cursor home
        copy  "fb.insert.line.asm"  ; Insert new line
        copy  "fb.null2char.asm"    ; Replace null characters in framebuffer row
        copy  "fb.tab.prev.asm"     ; Move cursor to previous tab position
        copy  "fb.tab.next.asm"     ; Move cursor to next tab position
        copy  "fb.ruler.asm"        ; Setup ruler with tab positions in memory
        copy  "fb.colorlines.asm"   ; Colorize lines in framebuffer
        copy  "fb.vdpdump.asm"      ; Dump framebuffer to VDP SIT
        copy  "fb.scan.fname.asm"   ; Scan line for device & filename
        copy  "fb.hscroll.asm"      ; Horizontal scroll frame buffer
        copy  "fb.restore.asm"      ; Restore framebuffer to normal opr.
        copy  "fb.refresh.asm"      ; Refresh framebuffer
        copy  "fb.get.nonblank.asm" ; Get column of first non-blank char
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank4.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
                                    ; Not applicable
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f4f
              .error 'Aborted. Bank 4 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------
        copy  "rom.crash.asm"
        ;-----------------------------------------------------------------------
        ; Vector table
        ;-----------------------------------------------------------------------
        copy  "rom.vectors.bank4.asm"
                                    ; Vector table bank 4
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

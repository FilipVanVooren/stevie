********************************************************************************
*   Stevie
*   Modern Programming Editor for the Texas Instruments TI-99/4a Home Computer.
*   Copyright (C) 2018-2025 / Filip van Vooren
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
* File: stevie_b6.asm
*
* Bank 6 "Jenifer"
* VDP utility functions and fonts
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
* BANK 6
********|*****|*********************|**************************
bankid  equ   bank6.rom             ; Set bank identifier to current bank
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
        ; Patterns
        ;------------------------------------------------------------------------
        copy  "vdp.dump.patterns.asm"        ; Dump patterns to VDP
        copy  "vdp.dump.font.asm"            ; Dump font to VDP
        copy  "vdp.colors.line.asm"          ; Set color combination for line
        copy  "vdp.cursor.tat.asm"           ; VDP cursor handling
        copy  "vdp.cursor.tat.fb.asm"        ; VDP cursor framebuffer
        copy  "vdp.cursor.tat.cmdb.asm"      ; VDP cursor CMDB
        copy  "vdp.cursor.tat.cmdb.hide.asm" ; VDP cursor CMDB
        copy  "tv.set.font.asm"              ; Set current font
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank6.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.patterns.asm"    ; Pattern definitions
        ;-----------------------------------------------------------------------
        ; Fonts
        ;-----------------------------------------------------------------------        
font1   bcopy "FONTX.bin"            ; Default font as of Stevie 1.4A
font2   bcopy "FONT7.bin"            ; Default font (Stevie 1.0 - 1.3Q)
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f50
              .error 'Aborted. Bank 6 cartridge program too large!'
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
        copy  "rom.vectors.bank6.asm"
                                    ; Vector table bank 6

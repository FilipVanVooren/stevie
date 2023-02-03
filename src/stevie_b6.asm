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
* File: stevie_b6.asm
*
* Bank 6 "Jenifer"
* VDP utility functions and fonts
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.vdp.asm"     ; VDP configuration (F18a/9938/...)
        copy  "equates.asm"         ; Stevie main configuration
        copy  "equates.c99.asm"     ; Classic99 emulator configuration
        copy  "equates.tib.asm"     ; Equates related to TI Basic session
        copy  "equates.keys.asm"    ; Equates for keyboard mapping

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
        ;-----------------------------------------------------------------------
        copy  "vdp.dump.patterns.asm" ; Dump patterns to VDP
        copy  "vdp.dump.font.asm"     ; Dump font to VDP
        copy  "tv.set.font.asm"       ; Set current font
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank6.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.patterns.asm"    ; Pattern definitions sprites & chars        
        ;-----------------------------------------------------------------------
        ; Fonts
        ;-----------------------------------------------------------------------        
font1   bcopy "FONTX.bin"            ; Default font as of Stevie 1.4A

font2   bcopy "FONT7.bin"            ; \ Default font (Stevie 1.0 - 1.3Q)
                                     ; / Harry's Extended Basic GEM 2.9 font 7

font3   byte  >00                    ; \ Push font one pixel down
        bcopy "FONT14.bin"           ; / Harry's Extended Basic GEM 2.9 font 14

font4   aorg  font3 + 784            ; \
        byte  >00                    ; | Push font one pixel down 
        bcopy "FONT40.bin"           ; / Harry's Extended Basic GEM 2.9 font 40

font5   aorg  font4 + 784            ; \
        bcopy "FONT60.bin"           ; / Harry's Extended Basic GEM 2.9 font 60
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f00
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

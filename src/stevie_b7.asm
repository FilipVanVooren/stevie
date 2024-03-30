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
* File: stevie_b7.asm
*
* Bank 7 "Jonas"
* SAMS and TI Basic support routines
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
* BANK 7
********|*****|*********************|**************************
bankid  equ   bank7.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>8000           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  >6038
        clr   @bank7.rom            ; Switch to bank 7 "Jonas"
        b     @tib.run.return.mon   ; Resume Stevie session

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
        ; SAMS support routines and utilities
        ;-----------------------------------------------------------------------
        copy  "magic.asm"                  ; Magic string handling
        copy  "mem.sams.layout.asm"        ; Setup SAMS banks from cart space
        copy  "tv.reset.asm"               ; Reset editor (clear buffers)
        ;-----------------------------------------------------------------------
        ; TI Basic sessions
        ;-----------------------------------------------------------------------
        copy  "tib.session.run.asm"        ; Run TI Basic session
        copy  "tib.session.isr.asm"        ; TI Basic integration hook
        copy  "tib.session.return.asm"     ; Return to Stevie
        ;-----------------------------------------------------------------------
        ; TI Basic program uncruncher
        ;-----------------------------------------------------------------------
        copy  "tib.uncrunch.helper.asm"    ; Helper functions for uncrunching
        copy  "tib.uncrunch.asm"           ; Uncrunch TI Basic program
        copy  "tib.uncrunch.prep.asm"      ; Prepare for uncrunching
        copy  "tib.uncrunch.prg.asm"       ; Uncrunch tokenized program code
        copy  "tib.uncrunch.token.asm"     ; Decode statement token
        copy  "tib.uncrunch.line.pack.asm" ; Pack line to editor buffer
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank7.asm"        ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"        ; Stubs to include in all banks
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.sams.layout.asm"       ; SAMS bank layout for multi-purpose
        copy  "data.tib.tokens.asm"        ; TI Basic tokens
        ;-----------------------------------------------------------------------
        ; Scratchpad memory dump
        ;-----------------------------------------------------------------------
        aorg >7e00
        copy  "data.scrpad.asm"            ; Required for TI Basic
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f00
              .error 'Aborted. Bank 7 cartridge program too large!'
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
        copy  "rom.vectors.bank7.asm"    ; Vector table bank 7

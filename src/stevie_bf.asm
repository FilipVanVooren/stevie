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
* File: stevie_bf.asm
*
* Bank F "Sarah"
* ROM bank with spectra2 library running in ROM address space
********************************************************************************
        ;-----------------------------------------------------------------------
        ; Equates
        ;-----------------------------------------------------------------------           
        copy  "equ.rom.build.asm"   ; Cartridge build options
        copy  "equ.romseq.asm"      ; ROM bank order "non-inverted"
        copy  "equ.vdp.asm"         ; VDP configuration (F18a/9938/...)
        copy  "equ.asm"             ; Stevie main configuration
        copy  "equ.c99.asm"         ; Classic99 emulator configuration
        copy  "equ.tib.asm"         ; Equates related to TI Basic session
        copy  "equ.keys.asm"        ; Equates for keyboard mapping
        ;-----------------------------------------------------------------------
        ; Macros 
        ;-----------------------------------------------------------------------    
        copy  "macros/pushregs.mac" ; Push registers macro
        copy  "macros/popregs.mac"  ; Pop registers macro   
***************************************************************
* BANK F
********|*****|*********************|**************************
bankid  equ   bankf.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>8000           ; Save bank
***************************************************************
* Step 2: Satisfy assembler, must know relocated code
********|*****|*********************|**************************
        aorg  >2000                 ; Relocate to >2000
        copy  "runlib.asm"
        copy  "ram.resident.asm"   
        ;------------------------------------------------------
        ; Activate bank 1
        ;------------------------------------------------------
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
***************************************************************
* Step 1: Include main editor modules
********|*****|*********************|**************************
main:
        aorg  kickstart.code2       ; >6000
        bl    @cpu.crash            ; Should never get here
        ;-----------------------------------------------------------------------
        ; Dialogs
        ;-----------------------------------------------------------------------             
        copy  "dialog.help.content.asm"  ; Draw help dialog content
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bankf.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------

  .ifeq vdpmode, 2480
        copy  "data.help.2480.asm"  ; Help dialog content 24x80 mode version
  .endif
  .ifeq vdpmode, 3080
        copy  "data.help.3080.asm"  ; Help dialog content 30x80 mode version
  .endif
  .ifeq vdpmode, 4880
        copy  "data.help.4880.asm"  ; Help dialog content 48x80 mode version
  .endif
  .ifeq vdpmode, 6080
        copy  "data.help.6080.asm"  ; Help dialog content 60x80 mode version
  .endif

        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f50
              .error 'Aborted. Bank F cartridge program too large!'
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
        copy  "rom.vectors.bankf.asm"
                                    ; Vector table bank f

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
* File: stevie_b2.asm
*
* Bank 2 "Jacky"
* File load/save operations, labels
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
* BANK 2
********|*****|*********************|**************************
bankid  equ   bank2.rom             ; Set bank identifier to current bank
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
* Step 3: Include modules
********|*****|*********************|**************************
main:
        aorg  kickstart.code2       ; >6046
        bl    @cpu.crash            ; Should never get here
        ;-----------------------------------------------------------------------
        ; File handling
        ;-----------------------------------------------------------------------
        copy  "fio_memprep.asm"          ; Spectra2 file memory prepare
        copy  "fh.file.read.mem.asm"     ; Read file into memory
        copy  "fh.file.read.edb.asm"     ; Read file to editor buffer
        copy  "fh.file.write.edb.asm"    ; Write editor buffer to file
        copy  "fh.file.load.bin.asm"     ; Load binary image into memory
        copy  "fh.file.load.ea5.asm"     ; Load EA5 program image into memory
        copy  "fh.file.delete.asm"       ; Delete file
        copy  "fm.loadfile.asm"          ; Load DV80 file into editor buffer
        copy  "fm.insertfile.asm"        ; Insert DV80 file into editor buffer
        copy  "fm.savefile.asm"          ; Save DV80 file from editor buffer
        copy  "fm.newfile.asm"           ; New DV80 file in editor buffer
        copy  "fm.run.ea5.asm"           ; Run EA5 program image
        copy  "fm.clock.read.asm"        ; Read Date/Time from clock device
        copy  "fm.callbacks.edb.asm"     ; Callbacks for editor buffer file IO
        copy  "fm.callbacks.dir.asm"     ; Callbacks for drive/directory file IO
        copy  "fm.callbacks.ea5.asm"     ; Callbacks for EA5 file IO
        copy  "fm.callbacks.clock.asm"   ; Callbacks for reading date/time
        copy  "fm.browse.fname.set.asm"  ; Create string with device/filename
        copy  "fm.browse.fname.prev.asm" ; Pick prev filename in filename list
        copy  "fm.browse.fname.next.asm" ; Pick next filename in filename list
        copy  "fm.browse.updir.asm"      ; Directory up
        copy  "fm.directory.asm"         ; File manager drive/directory listing
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank2.asm" ; Bank specific stubs
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.pab.tpl.asm"    ; PAB templates        
        copy  "data.devices.asm"    ; Device names
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifge $, >7f50
              .error 'Aborted. Bank 2 cartridge program too large!'
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
        copy  "rom.vectors.bank2.asm"
                                    ; Vector table bank 2

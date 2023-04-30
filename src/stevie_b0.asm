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
* File: stevie_b0.asm
*
* Bank 0 "Jill"
* Setup resident SP2/Stevie modules and start SP2 kernel
********************************************************************************
        copy  "buildinfo.asm"       ; "build/.buildinfo/buildinfo.asm"
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank ordster "non-inverted"
        ;-----------------------------------------------------------------------
        ; Equates
        ;-----------------------------------------------------------------------            
        copy  "equates.vdp.asm"     ; VDP configuration (F18a/9938/...)
        copy  "equates.asm"         ; Stevie main configuration
        copy  "equates.c99.asm"     ; Classic99 emulator configuration
        copy  "equates.keys.asm"    ; Equates for keyboard mapping


***************************************************************
* BANK 0
********|*****|*********************|**************************
bankid  equ   bank1.rom             ; Set bank identifier to bank 1!
                                    ; We never want to return to bank 0, after
                                    ; doing trampoline call, from low memexp.

        aorg  >6000
        save  >6000,>8000           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 7 (Resume Stevie session)
********|*****|*********************|**************************
resume.stevie:
        aorg  >6038
        clr   @bank7.rom            ; Switch to bank 7 "Jill"

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
new.stevie:
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Setup SAMS banks (inline code because no SP2 yet!)
********|*****|*********************|**************************
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
        sbo   0                     ; Enable access to SAMS registers
        li    r0,>0200              ; \ Page 2 in >2000 - >2fff
        movb  r0,@>4004             ; /

        li    r0,>0300              ; \ Page 3 in >3000 - >3fff
        movb  r0,@>4006             ; /

        li    r0,>0400              ; \ Page 4 in >a000 - >afff
        movb  r0,@>4014             ; /

        li    r0,>2000              ; \ Page 20 in >b000 - >bfff
        movb  r0,@>4016             ; /

        li    r0,>4000              ; \ Page 40 in >c000 - >bfff
        movb  r0,@>4018             ; /

        li    r0,>0500              ; \ Page 5 in >d000 - >dfff
        movb  r0,@>401a             ; /

        li    r0,>0600              ; \ Page 6 in >ec000 - >efff
        movb  r0,@>401c             ; /

        li    r0,>0700              ; \ Page 7 in >f000 - >ffff
        movb  r0,@>401e             ; /

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper

***************************************************************
* Step 3: Copy resident modules from ROM to RAM >2000 - >3fff
********|*****|*********************|**************************
        li    r0,reloc.resident     ; Start of code to relocate
        li    r1,>2000
        li    r2,512                ; Copy 8K (320 * 16 bytes)
        ;------------------------------------------------------
        ; Copy memory to destination
        ; r0 = Source CPU address
        ; r1 = Target CPU address
        ; r2 = Bytes to copy/16
        ;------------------------------------------------------
!       mov   *r0+,*r1+             ; Copy word 1
        mov   *r0+,*r1+             ; Copy word 2
        mov   *r0+,*r1+             ; Copy word 3
        mov   *r0+,*r1+             ; Copy word 4
        mov   *r0+,*r1+             ; Copy word 5
        mov   *r0+,*r1+             ; Copy word 6
        mov   *r0+,*r1+             ; Copy word 7
        mov   *r0+,*r1+             ; Copy word 8
        dec   r2
        jne   -!                    ; Loop until done
***************************************************************
* Step 4: Start SP2 kernel (runs in low MEMEXP)
********|*****|*********************|**************************
        b     @runlib               ; \ Start spectra2 library
                                    ; | "main" in low MEMEXP is automatically
                                    ; / called by SP2 runlib.
        ;------------------------------------------------------
        ; Assert. Should not get here!
        ;------------------------------------------------------
        li    r0,$                  ; Current location
        mov   r0,@>ffce             ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system

        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bankx.asm" ; Stubs to include in all banks

***************************************************************
* Code data: Relocated code
********|*****|*********************|**************************
reloc.resident:
        ;------------------------------------------------------
        ; Resident libraries
        ;------------------------------------------------------
        xorg  >2000                 ; Relocate to >2000
        copy  "runlib.asm"
        copy  "rom.resident.asm"    ; Resident modules relocated to RAM
        ;------------------------------------------------------
        ; Stevie main entry point
        ;------------------------------------------------------
main:
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine >6046
        ;------------------------------------------------------
        ; Memory full check
        ;------------------------------------------------------
        .ifgt $, >3e40              ; >3e40 in low memexp, maps to >7f00 in
                                    ; cartridge space where rom.crash.asm has
                                    ; its aorg. So may not go beyond >3e40!

              .error '***** Aborted. Bank 0 cartridge program too large!'
        .else
              data $                ; Bank 0 ROM size OK.
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
        copy  "rom.vectors.bank0.asm"
                                    ; Vector table bank 0

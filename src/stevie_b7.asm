***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2022 // Filip van Vooren
***************************************************************
* File: stevie_b7.asm               ; Version %%build_date%%
*
* Bank 7 "Jonas"
* SAMS and TI Basic support routines
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "data.keymap.keys.asm"; Equates for keyboard mapping

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
        copy  "magic.asm"                ; Magic string handling
        copy  "mem.sams.layout.asm"      ; Setup SAMS banks from cart space
        ;-----------------------------------------------------------------------
        ; TI Basic sessions
        ;-----------------------------------------------------------------------
        copy  "tib.session.asm"          ; Run TI Basic session
        ;-----------------------------------------------------------------------
        ; TI Basic program uncruncher
        ;-----------------------------------------------------------------------
        copy  "tib.uncrunch.helper.asm"  ; Helper functions for uncrunching
        copy  "tib.uncrunch.asm"         ; Uncrunch TI Basic program
        copy  "tib.uncrunch.prep.asm"    ; Prepare for uncrunching
        copy  "tib.uncrunch.prg.asm"     ; Uncrunch tokenized program code
        copy  "tib.uncrunch.token.asm"   ; Decode statement token
        copy  "tib.uncrunch.line.pack.asm"
                                         ; Pack uncrunched line to editor buffer
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank7.asm"      ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"      ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;-----------------------------------------------------------------------
        copy  "data.sams.layout.asm"     ; SAMS bank layout for multi-purpose
        copy  "data.tib.tokens.asm"      ; TI Basic tokens
        ;-----------------------------------------------------------------------
        ; Scratchpad memory dump
        ;-----------------------------------------------------------------------
        aorg >7e00
        copy  "data.scrpad.asm"          ; Required for TI Basic
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;-----------------------------------------------------------------------
        .ifgt $, >7f00
              .error 'Aborted. Bank 7 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------
        copy "rom.crash.asm"
        ;-----------------------------------------------------------------------
        ; Vector table
        ;-----------------------------------------------------------------------
        copy  "rom.vectors.bank7.asm"    ; Vector table bank 7

*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table

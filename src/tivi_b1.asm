***************************************************************
*                          TiVi Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: tivi_b1.asm                 ; Version %%build_date%%


***************************************************************
* BANK 1 - TiVi support modules
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 1
        copy  "equates.asm"         ; Equates TiVi configuration
        copy  "kickstart.asm"       ; Cartridge header

        aorg  >2000                 
        copy  "%%spectra2%%/runlib.asm"
                                    ; Relocated spectra2 in low memory expansion
                                    ; was loaded into RAM from bank 0.
                                    ; 
                                    ; Only including it here, so that all
                                    ; references get satisfied during assembly.
***************************************************************
* TiVi entry point after spectra2 initialisation
********|*****|*********************|**************************
        aorg  kickstart.code2
main    clr   @>6002                ; Jump to bank 1
        b     @main.tivi            ; Start editor

        copy  "main.asm"            ; Main file (entrypoint)
        copy  "edkey.asm"           ; Actions
        copy  "edkey.mov.asm"       ; Actions for movement keys
        copy  "edkey.mod.asm"       ; Actions for modifier keys
        copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
        copy  "edkey.file.asm"      ; Actions for file related keys
        copy  "tivi.asm"            ; Main editor configuration
        copy  "mem.asm"             ; Memory Management
        copy  "fb.asm"              ; Framebuffer
        copy  "idx.asm"             ; Index management
        copy  "edb.asm"             ; Editor Buffer
        copy  "cmdb.asm"            ; Command Buffer
        copy  "fh.read.sams.asm"    ; File handler read file
        copy  "fm.load.asm"         ; File manager loadfile
        copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning        
        copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
        copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
        copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
        copy  "pane.botline.asm"    ; Pane status bottom line
        copy  "data.asm"            ; Data segment

        .ifgt $, >7fff
              .error 'Aborted. Bank 1 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif

*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprpdt  equ   >1800                 ; VDP sprite pattern table
sprsat  equ   >2000                 ; VDP sprite attribute table
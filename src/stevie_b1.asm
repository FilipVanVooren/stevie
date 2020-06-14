***************************************************************
*                          Stevie Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: stevie_b1.asm                 ; Version %%build_date%%


***************************************************************
* BANK 1 - Stevie support modules
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 1
        copy  "equates.asm"         ; Equates stevie configuration
        copy  "kickstart.asm"       ; Cartridge header

        aorg  >2000                 
        copy  "%%spectra2%%/runlib.asm"
                                    ; Relocated spectra2 in low memory expansion
                                    ; Is copied to RAM from bank 0.
                                    ; 
                                    ; Including it here too, so that all
                                    ; references get satisfied during assembly.
***************************************************************
* stevie entry point after spectra2 initialisation
********|*****|*********************|**************************
        aorg  kickstart.code2
main:   
        clr   @>6002                ; Jump to bank 1
        b     @main.stevie          ; Start editor
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"            ; Main file (entrypoint)
        copy  "edkey.asm"           ; Keyboard actions
        copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys 
        copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
        copy  "edkey.fb.misc.asm"   ; fb pane   - Actions for miscelanneous keys
        copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
        copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
        copy  "stevie.asm"          ; Main editor configuration
        copy  "mem.asm"             ; Memory Management
        copy  "fb.asm"              ; Framebuffer
        copy  "idx.asm"             ; Index management
        copy  "idx.delete.asm"      ; Index management - delete slot
        copy  "idx.insert.asm"      ; Index management - insert slot
        copy  "edb.asm"             ; Editor Buffer
        copy  "cmdb.asm"            ; Command Buffer
        copy  "fh.read.sams.asm"    ; File handler read file
        copy  "fm.load.asm"         ; File manager loadfile
        copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning        
        copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
        copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
        copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
   
        copy  "pane.utils.colorscheme.asm"
                                    ; Colorscheme handling in panges 
        copy  "pane.utils.tipiclock.asm"
                                    ; Colorscheme    

        copy  "pane.cmdb.asm"       ; Command buffer pane
        copy  "pane.botline.asm"    ; Status line pane
        copy  "data.constants.asm"  ; Data segment - Constants
        copy  "data.strings.asm"    ; Data segment - Strings
        copy  "data.keymap.asm"     ; Data segment - Keyboard mapping

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
spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table
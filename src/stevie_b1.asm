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
        ;----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"            ; Main file (entrypoint)

        ;-----------------------------------------------------------------------
        ; Keyboard actions
        ;-----------------------------------------------------------------------
        copy  "edkey.asm"           ; Keyboard actions
        copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys 
        copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
        copy  "edkey.fb.misc.asm"   ; fb pane   - Miscelanneous actions
        copy  "edkey.fb.file.asm"   ; fb pane   - File related actions
        copy  "edkey.cmdb.mov.asm"  ; cmdb pane - Actions for movement keys 
        copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
        copy  "edkey.cmdb.misc.asm" ; cmdb pane - Miscelanneous actions
        copy  "edkey.cmdb.file.asm" ; cmdb pane - File related actions
        ;-----------------------------------------------------------------------
        ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
        ;-----------------------------------------------------------------------
        copy  "tv.asm"              ; Main editor configuration        
        copy  "mem.asm"             ; Memory Management
        copy  "fb.asm"              ; Framebuffer
        copy  "idx.asm"             ; Index management
        copy  "idx.delete.asm"      ; Index management - delete slot
        copy  "idx.insert.asm"      ; Index management - insert slot
        copy  "edb.asm"             ; Editor Buffer
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------
        copy  "cmdb.asm"            ; Command buffer shared code
        copy  "cmdb.cmd.asm"        ; Command line handling
        copy  "errline.asm"         ; Error line
        ;-----------------------------------------------------------------------
        ; File handling
        ;-----------------------------------------------------------------------
        copy  "fh.read.sams.asm"    ; File handler read file
        copy  "fm.load.asm"         ; File manager load file into editor
        copy  "fm.browse.asm"       ; File manager browse support routines
        ;-----------------------------------------------------------------------
        ; User hook, background tasks
        ;-----------------------------------------------------------------------
        copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning        
        copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
        copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
        copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
        copy  "task.oneshot.asm"    ; Task - One shot
        ;-----------------------------------------------------------------------
        ; Screen pane utilities
        ;-----------------------------------------------------------------------
        copy  "pane.utils.asm"      ; Pane utility functions
        copy  "pane.utils.colorscheme.asm"
                                    ; Colorscheme handling in panes 
        copy  "pane.utils.tipiclock.asm"
                                    ; TIPI clock
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------   
        copy  "pane.cmdb.asm"       ; Command buffer
        copy  "pane.errline.asm"    ; Error line
        copy  "pane.botline.asm"    ; Status line
        ;-----------------------------------------------------------------------
        ; Dialogs
        ;-----------------------------------------------------------------------   
        copy  "dialog.file.load.asm"
                                    ; Dialog "Load DV80 file"
        ;-----------------------------------------------------------------------
        ; Program data
        ;----------------------------------------------------------------------- 
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
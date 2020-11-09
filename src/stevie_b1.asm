***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: stevie_b1.asm               ; Version %%build_date%%

        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff 
                                    ; and grows downwards

***************************************************************
* BANK 1 - Stevie main editor modules
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 1
*--------------------------------------------------------------
* Cartridge header
********|*****|*********************|**************************
        byte  >aa,1,1,0,0,0
        data  $+10
        byte  0,0,0,0,0,0,0,0
        data  0                     ; No more items following
        data  kickstart.code1

        .ifdef debug
              #string 'STEVIE V0.1E'
        .else
              #string 'STEVIE V0.1E'
        .endif

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6030
        clr   @>6000                ; Switch to bank 0
***************************************************************
* Step 2: Satisfy assembler, must know SP2 in low MEMEXP
********|*****|*********************|**************************
        aorg  >2000                 
        copy  "%%spectra2%%/runlib.asm"
                                    ; Relocated spectra2 in low MEMEXP, was
                                    ; copied to >2000 from ROM in bank 0
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------
        data >dead,>beef,>dead,>beef     
        .print "***** PC relocated SP2 library @ >2000 - ", $, "(dec)"                                    
***************************************************************
* Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
********|*****|*********************|**************************
        aorg  >3000
        ;------------------------------------------------------
        ; Activate bank 1
        ;------------------------------------------------------
        clr   @>6002                ; Activate bank 1 (2nd bank!)
        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Resident Stevie modules >3000 - >3fff
        ;------------------------------------------------------
        copy  "fb.asm"              ; Framebuffer         
        copy  "edb.asm"             ; Editor Buffer    
        ;------------------------------------------------------
        ; Resident Stevie modules >3000 - >3fff
        ;------------------------------------------------------
        copy  "data.constants.asm"  ; Data Constants
        copy  "data.strings.asm"    ; Data segment - Strings
        copy  "data.keymap.asm"     ; Data segment - Keyboard mapping        
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------        
        data  >dead,>beef,>dead,>beef
        .print "***** PC resident stevie modules @ >3000 - ", $, "(dec)"
***************************************************************
* Step 4: Include main editor modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6036
        b     @main.stevie          ; Start editor 
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"            ; Main file (entrypoint)
        ;-----------------------------------------------------------------------
        ; Keyboard actions
        ;-----------------------------------------------------------------------
        copy  "edkey.key.process.asm"    
                                    ; Process keyboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Framebuffer              
        ;-----------------------------------------------------------------------
        copy  "edkey.fb.mov.leftright.asm" 
                                         ; Move left / right / home / end
        copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
        copy  "edkey.fb.mov.updown.asm"  ; Move line up / down        
        copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
        copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
        copy  "edkey.fb.del.asm"         ; Delete characters or lines
        copy  "edkey.fb.ins.asm"         ; Insert characters or lines
        copy  "edkey.fb.mod.asm"         ; Actions for modifier keys        
        copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
        copy  "edkey.fb.file.asm"        ; File related actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Command Buffer    
        ;-----------------------------------------------------------------------
        copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys 
        copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
        copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
        copy  "edkey.cmdb.file.asm"      ; File related actions
        copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
        ;-----------------------------------------------------------------------
        ; Logic for Editor configuration and SAMS memory
        ;-----------------------------------------------------------------------
        copy  "tv.asm"              ; Main editor configuration        
        copy  "mem.asm"             ; SAMS Memory Management
        ;-----------------------------------------------------------------------
        ; Logic for Framebuffer
        ;-----------------------------------------------------------------------        
        copy  "fb.util.asm"         ; Framebuffer utilities
        copy  "fb.refresh.asm"      ; Framebuffer refresh
        ;-----------------------------------------------------------------------
        ; Logic for Index management
        ;-----------------------------------------------------------------------
        copy  "idx.asm"             ; Index management
        copy  "idx.update.asm"      ; Index management - Update entry
        copy  "idx.pointer.asm"     ; Index management - Get pointer to line
        copy  "idx.delete.asm"      ; Index management - delete slot
        copy  "idx.insert.asm"      ; Index management - insert slot
        ;-----------------------------------------------------------------------
        ; Logic for Editor Buffer
        ;-----------------------------------------------------------------------
        copy  "edb.line.pack.asm"   ; Pack line into editor buffer
        copy  "edb.line.unpack.asm" ; Unpack line from editor buffer
        copy  "edb.line.getlen.asm" ; Get line length
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------
        copy  "cmdb.asm"            ; Command buffer shared code
        copy  "cmdb.cmd.asm"        ; Command line handling
        copy  "errline.asm"         ; Error line
        ;-----------------------------------------------------------------------
        ; File handling
        ;-----------------------------------------------------------------------
        copy  "fh.read.edb.asm"     ; Read file to editor buffer
        copy  "fh.write.edb.asm"    ; Write editor buffer to file
        copy  "fm.load.asm"         ; Load DV80 file into editor buffer
        copy  "fm.save.asm"         ; Save DV80 file from editor buffer
        copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------   
        copy  "pane.cmdb.asm"       ; Command buffer        
        copy  "pane.errline.asm"    ; Error line
        copy  "pane.botline.asm"    ; Status line
        ;-----------------------------------------------------------------------
        ; Dialogs
        ;-----------------------------------------------------------------------   
        copy  "dialog.about.asm"    ; Dialog "About"
        copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
        copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
        copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"                                    
        ;-----------------------------------------------------------------------
        ; Program data
        ;----------------------------------------------------------------------- 
        copy  "data.keymap.actions.asm"
                                    ; Data segment - Keyboard actions
        .ifgt $, >7fff
              ;.error 'Aborted. Bank 1 cartridge program too large!'
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

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
        copy  "header.asm"
        copy  "kickstart.asm"       ; Kickstart code
        #string 'bank 1'        

        xorg  >2000                 ; Relocate support modules to >2000->3fff        
        copy  "editor.asm"          ; Main editor
        copy  "edkey.asm"           ; Actions
        copy  "edkey.mov.asm"       ; Actions for movement keys
        copy  "edkey.mod.asm"       ; Actions for modifier keys
        copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
        copy  "edkey.file.asm"      ; Actions for file related keys
        copy  "mem.asm"             ; mem      - Memory Management
        copy  "fb.asm"              ; fb       - Framebuffer
        copy  "idx.asm"             ; idx      - Index management
        copy  "edb.asm"             ; edb      - Editor Buffer
        copy  "cmdb.asm"            ; cmdb     - Command Buffer
        copy  "tfh.read.sams.asm"   ; tfh.sams - File handler read file (SAMS)                                
        copy  "fm.load.asm"         ; fm.load  - File manager loadfile
        copy  "tasks.asm"           ; tsk      - Tasks
        copy  "data.asm"            ; data     - Data segment

        .ifgt $, >7fff
              .error 'Aborted. Bank 1 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif
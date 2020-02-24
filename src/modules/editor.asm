* FILE......: editor.asm
* Purpose...: TiVi Editor - Main editor module

*//////////////////////////////////////////////////////////////
*            TiVi Editor - Main editor module
*//////////////////////////////////////////////////////////////

*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprpdt  equ   >1800                 ; VDP sprite pattern table
sprsat  equ   >2000                 ; VDP sprite attribute table



***************************************************************
* main
* Initialize editor
***************************************************************
* b   @main.tivi
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* -
*--------------------------------------------------------------
* Notes
* Main entry point for TiVi editor 
***************************************************************


***************************************************************
* Main
********|*****|*********************|**************************
main.tivi:
        coc   @wbit1,config         ; F18a detected?
        jeq   main.continue
        blwp  @0                    ; Exit for now if no F18a detected

main.continue:
        bl    @scroff               ; Turn screen off
        bl    @f18unl               ; Unlock the F18a
        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40
        ;------------------------------------------------------
        ; Initialize VDP SIT
        ;------------------------------------------------------
        bl    @filv
              data >0000,32,31*80   ; Clear VDP SIT 
        bl    @scron                ; Turn screen on
        ;------------------------------------------------------
        ; Initialize low + high memory expansion
        ;------------------------------------------------------
        bl    @film
              data >2200,00,8*1024-256*2
                                    ; Clear part of 8k low-memory

        bl    @film
              data >a000,00,24*1024 ; Clear 24k high-memory
        ;------------------------------------------------------
        ; Load SAMS default memory layout
        ;------------------------------------------------------
        bl    @mem.setup.sams.layout
                                    ; Initialize SAMS layout
        ;------------------------------------------------------
        ; Setup cursor, screen, etc.
        ;------------------------------------------------------
        bl    @smag1x               ; Sprite magnification 1x
        bl    @s8x8                 ; Small sprite

        bl    @cpym2m
              data romsat,ramsat,4  ; Load sprite SAT

        mov   @romsat+2,@fb.curshape
                                    ; Save cursor shape & color

        bl    @cpym2v
              data sprpdt,cursors,3*8
                                    ; Load sprite cursor patterns
                                    
        bl    @cpym2v
              data >1008,lines,16   ; Load line patterns
*--------------------------------------------------------------
* Initialize 
*--------------------------------------------------------------
        bl    @cmdb.init            ; Initialize command buffer
        bl    @edb.init             ; Initialize editor buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer
        ;-------------------------------------------------------
        ; Setup editor tasks & hook
        ;-------------------------------------------------------
        li    tmp0,>0200
        mov   tmp0,@btihi           ; Highest slot in use
 
        bl    @at
        data  >0100                 ; Cursor YX position = >0000

        li    tmp0,timers
        mov   tmp0,@wtitab

        bl    @mkslot
              data >0001,task0      ; Task 0 - Update screen
              data >0101,task1      ; Task 1 - Update cursor position
              data >020f,task2,eol  ; Task 2 - Toggle cursor shape

        bl    @mkhook
              data editor           ; Setup user hook

        b     @tmgr                 ; Start timers and kthread



* FILE......: main.asm
* Purpose...: TiVi Editor - Main editor module

*//////////////////////////////////////////////////////////////
*            TiVi Editor - Main editor module
*//////////////////////////////////////////////////////////////


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
        ; Initialize high memory expansion
        ;------------------------------------------------------
        bl    @film
              data >a000,00,24*1024 ; Clear 24k high-memory
        ;------------------------------------------------------
        ; Setup SAMS windows
        ;------------------------------------------------------
        bl    @mem.sams.layout      ; Initialize SAMS layout
        ;------------------------------------------------------
        ; Setup cursor, screen, etc.
        ;------------------------------------------------------
        bl    @smag1x               ; Sprite magnification 1x
        bl    @s8x8                 ; Small sprite

        bl    @cpym2m
              data romsat,ramsat,4  ; Load sprite SAT

        mov   @romsat+2,@tv.curshape
                                    ; Save cursor shape & color

        bl    @cpym2v
              data sprpdt,cursors,3*8
                                    ; Load sprite cursor patterns
                                    
        bl    @cpym2v
              data >1008,patterns,11*8  
                                    ; Load character patterns
*--------------------------------------------------------------
* Initialize 
*--------------------------------------------------------------
        bl    @tivi.init            ; Initialize TiVi editor config
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
              data  >0100           ; Cursor YX position = >0000

        li    tmp0,timers
        mov   tmp0,@wtitab        

        bl    @mkslot
              data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
              data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
              data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
              data eol

        bl    @mkhook
              data hook.keyscan     ; Setup user hook

        b     @tmgr                 ; Start timers and kthread



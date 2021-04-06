* FILE......: main.asm
* Purpose...: Stevie Editor - Main editor module

***************************************************************
* main
* Initialize editor
***************************************************************
* b   @main.stevie
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
* Main entry point for stevie editor 
***************************************************************


***************************************************************
* Main
********|*****|*********************|**************************
main.stevie:
        coc   @wbit1,config         ; F18a detected?
        jeq   main.continue
        blwp  @0                    ; Exit for now if no F18a detected

main.continue:
        ;------------------------------------------------------
        ; Setup F18A VDP
        ;------------------------------------------------------
        bl    @scroff               ; Turn screen off

        bl    @f18unl               ; Unlock the F18a
        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        BL    @putvr                ; Set VDP TAT base address for position
              data >0360            ; based attributes (>40 * >60 = >1800)
        ;------------------------------------------------------
        ; Clear screen (VDP SIT)
        ;------------------------------------------------------
        bl    @filv
              data >0000,32,vdp.sit.size.80x30
                                    ; Clear screen
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
              data romsat,ramsat,10 ; Load sprite SAT

        mov   @romsat+2,@tv.curshape
                                    ; Save cursor shape & color

        bl    @cpym2v
              data sprpdt,cursors,4*8
                                    ; Load sprite cursor patterns
                                    
        bl    @cpym2v
              data >1008,patterns,17*8  
                                    ; Load character patterns
*--------------------------------------------------------------
* Initialize 
*--------------------------------------------------------------
        bl    @tv.init              ; Initialize editor configuration
        bl    @tv.reset             ; Reset editor
        bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
        ;------------------------------------------------------
        ; Load colorscheme amd turn on screen
        ;------------------------------------------------------
        bl    @pane.action.colorscheme.Load
                                    ; Load color scheme and turn on screen
        ;-------------------------------------------------------
        ; Setup editor tasks & hook
        ;-------------------------------------------------------
        li    tmp0,>0300
        mov   tmp0,@btihi           ; Highest slot in use
 
        bl    @at
              data  >0000           ; Cursor YX position = >0000

        li    tmp0,timers
        mov   tmp0,@wtitab        

        bl    @mkslot
              data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
              data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
              data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
              data >0330,task.oneshot      ; Task 3 - One shot task
              data eol

        bl    @mkhook
              data hook.keyscan     ; Setup user hook

        b     @tmgr                 ; Start timers and kthread
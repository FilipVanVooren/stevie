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
        nop                         ; Ignore for now if no f18a detected

main.continue:
        ;------------------------------------------------------
        ; Setup F18A VDP
        ;------------------------------------------------------
        bl    @mute                 ; Turn sound generators off
        bl    @scroff               ; Turn screen off

        bl    @f18unl               ; Unlock the F18a

        .ifeq device.f18a,1

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        BL    @putvr                ; Set VDP TAT base address for position
              data >0360            ; based attributes (>40 * >60 = >1800)
        ;------------------------------------------------------
        ; Clear screen (VDP SIT)
        ;------------------------------------------------------
        bl    @filv
              data >0000,32,vdp.sit.size
                                    ; Clear screen
        ;------------------------------------------------------
        ; Initialize high memory expansion
        ;------------------------------------------------------
        bl    @film
              data >a000,00,20000   ; Clear a000-eedf
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
              data romsat,ramsat,14 ; Load sprite SAT

        mov   @romsat+2,@tv.curshape
                                    ; Save cursor shape & color

        bl    @vdp.patterns.dump    ; Load sprite and character patterns                                    
*--------------------------------------------------------------
* Initialize 
*--------------------------------------------------------------
        bl    @tv.init              ; Initialize editor configuration
        bl    @tv.reset             ; Reset editor
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

      .ifeq device.f18a,1

        bl    @mkslot
              data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
              data >0102,task.vdp.copy.sat ; Task 1 - Update VDP cursor position
              data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
              data >0360,task.oneshot      ; Task 3 - One shot task
              data eol

      .else 

        bl    @mkslot
              data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
              data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape              
              data >0350,task.oneshot      ; Task 3 - One shot task
              data eol

      .endif


        bl    @mkhook
              data hook.keyscan     ; Setup user hook

        b     @tmgr                 ; Start timers and kthread
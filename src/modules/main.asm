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
        jeq   main.continue         ; Yes, we're good. Initialize
        ;------------------------------------------------------
        ; Show "F18A NOT FOUND" message
        ;------------------------------------------------------
        bl    @putstr
              data txt.nof18a       ; Show message
        jmp   $                     ; Halt here

main.continue:
        ; data  c99_ovrd            ; classic99: Put CPU in overdrive mode

        ;------------------------------------------------------
        ; Setup F18A VDP
        ;------------------------------------------------------
        bl    @mute                 ; Turn sound generators off
        bl    @scroff               ; Turn screen off
        ;------------------------------------------------------
        ; Clear VDP memory >0000 - >0fff
        ;------------------------------------------------------
        bl    @filv
              data >0000,32,>0960   ; Clear screen area

        bl    @filv
              data >0960,00,>06a0   ; Clear area for record buffer + PAB, etc.
        ;------------------------------------------------------
        ; Initialize high memory expansion
        ;------------------------------------------------------
        bl    @film
              data >a000,00,>4f00   ; Clear a000-eeef
        ;------------------------------------------------------
        ; Setup cursor, screen, etc.
        ;------------------------------------------------------
        bl    @f18unl               ; Unlock the F18a
                
        .ifge vdpmode, 3080

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        bl    @smag1x               ; Sprite magnification 1x
        bl    @s8x8                 ; Small sprite

        bl    @cpym2m
              data romsat,ramsat,14 ; Load sprite SAT

        mov   @romsat+2,@tv.curshape
                                    ; Save cursor shape & color

        bl    @vdp.dump.patterns    ; Dump sprite and character patterns to VDP

        clr   @parm1                ; Pick font 0
        bl    @tv.set.font          ; Set current font (dumps font to VDP)
                                    ; \ i  @parm1       = Font index (0-5)
                                    ; / o  @tv.font.ptr = Pointer to font
*--------------------------------------------------------------
* Initialize
*--------------------------------------------------------------
        bl    @mem.sams.setup.stevie
                                    ; Load SAMS pages for stevie

        bl    @tv.init              ; Initialize editor configuration
        bl    @tv.reset             ; Reset editor

        bl    @dialog               ; Setup memory for dialogs stringa
        ;------------------------------------------------------
        ; Load colorscheme and turn on screen
        ;------------------------------------------------------
        clr   @parm1                ; Screen off while reloading color scheme
        clr   @parm2                ; Don't skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF

        ;-------------------------------------------------------
        ; Setup editor tasks
        ;-------------------------------------------------------
        bl    @at
              data  >0000           ; Cursor YX position = >0000

        li    tmp0,timers           ; \ Set pointer to timers table
        mov   tmp0,@wtitab          ; /

      .ifeq  spritecursor,1

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
              data >0360,task.oneshot      ; Task 3 - One shot task
              data eol

      .endif

        li    tmp0,>0300            ; \ Set highest slot to use in MSB.
        mov   tmp0,@btihi           ; / Tell Task Scheduler
        ;-------------------------------------------------------
        ; Setup keyboard scanning and start kernel/timers
        ;-------------------------------------------------------
        bl    @mkhook
              data edkey.keyscan.hook
                                    ; Setup keyboard scanning hook
        ;-------------------------------------------------------
        ; Initialisation complete
        ;-------------------------------------------------------
        li    tmp0,>37D7            ; \ Silence classic99 debugger console,
        mov   tmp0,@>8370           ; | otherwise message flood with text
        clr   tmp0                  ; / "VDP disk buffer header corrupted at PC"
        ;-------------------------------------------------------
        ; Start kernel
        ;-------------------------------------------------------
        b     @tmgr                 ; Run kernel and timers


txt.nof18a stri 'NO F18A OR PICO9918 FOUND. CANNOT RUN.'

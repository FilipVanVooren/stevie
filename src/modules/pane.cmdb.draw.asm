* FILE......: pane.cmdb.draw.asm
* Purpose...: Stevie Editor - Command Buffer pane

***************************************************************
* pane.cmdb.draw
* Draw content in command buffer pane
***************************************************************
* bl  @pane.cmdb.draw
*--------------------------------------------------------------
* INPUT
* @cmdb.panhead  = Pointer to string with dialog header
* @cmdb.paninfo  = Pointer to string with info message or >0000
*                  if input prompt required
* @cmdb.panhint  = Pointer to string with hint message
* @cmdb.pankeys  = Pointer to string with key shortcuts for dialog
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.cmdb.draw:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Command buffer header line
        ;------------------------------------------------------
        mov   @cmdb.panhead,@parm1  ; Get string to display
        li    tmp0,80
        mov   tmp0,@parm2           ; Set requested length
        li    tmp0,1
        mov   tmp0,@parm3           ; Set character to fill
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill character
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string

        bl    @cpym2m
              data txt.stevie,rambuf+61,20
                                    ;
                                    ; Add Stevie banner
                                    ;

        mov   @cmdb.yxtop,@wyx      ; \
        mov   @outparm1,tmp1        ; | Display pane header
        bl    @xutst0               ; /
        ;------------------------------------------------------
        ; Check dialog id
        ;------------------------------------------------------
        clr   @waux1                ; Default is show prompt

        mov   @cmdb.dialog,tmp0
        ci    tmp0,99               ; \ Hide prompt and no keyboard
        jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 99
        seto  @waux1                ; /
        ;------------------------------------------------------
        ; Show info message instead of prompt
        ;------------------------------------------------------
        mov   @cmdb.paninfo,tmp1    ; Null pointer?
        jeq   pane.cmdb.draw.clear  ; Yes, display normal prompt

        mov   @cmdb.paninfo,@parm1  ; Get string to display
        li    tmp0,80
        mov   tmp0,@parm2           ; Set requested length
        li    tmp0,32
        mov   tmp0,@parm3           ; Set character to fill
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill character
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string

        bl    @at
              byte pane.botrow-3,0  ; Position cursor

        mov   @outparm1,tmp1        ; \ Display pane header
        bl    @xutst0               ; /
        ;------------------------------------------------------
        ; Clear lines after prompt in command buffer
        ;------------------------------------------------------
pane.cmdb.draw.clear:
        bl    @hchar
              byte pane.botrow-2,0,32,80
              data EOL              ; Remove key markers
        ;------------------------------------------------------
        ; Show key markers ?
        ;------------------------------------------------------
        mov   @cmdb.panmarkers,tmp0
        jeq   pane.cmdb.draw.hint   ; no, skip key markers
        ;------------------------------------------------------
        ; Loop over key marker list
        ;------------------------------------------------------
pane.cmdb.draw.marker.loop:
        movb  *tmp0+,tmp1           ; Get X position
        srl   tmp1,8                ; Right align
        ci    tmp1,>00ff            ; End of list reached?
        jeq   pane.cmdb.draw.hint   ; Yes, exit loop

        ori   tmp1,(pane.botrow - 2) * 256
                                    ; y=bottom row - 3, x=(key marker position)
        mov   tmp1,@wyx             ; Set cursor position

        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        bl    @putstr
              data txt.keymarker    ; Show key marker

        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; Show marker
        ;------------------------------------------------------
        jmp   pane.cmdb.draw.marker.loop
                                    ; Next iteration
        ;------------------------------------------------------
        ; Display pane hint in command buffer
        ;------------------------------------------------------
pane.cmdb.draw.hint:
        li    tmp0,pane.botrow - 1  ; \
        sla   tmp0,8                ; / Y=bottom row - 1, X=0
        mov   tmp0,@parm1           ; Set parameter
        mov   @cmdb.panhint,@parm2  ; Pane hint to display

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = Pointer to string with hint
                                    ; / i  parm2 = YX position
        ;------------------------------------------------------
        ; Display keys in status line
        ;------------------------------------------------------
        li    tmp0,pane.botrow      ; \
        sla   tmp0,8                ; / Y=bottom row, X=0
        mov   tmp0,@parm1           ; Set parameter
        mov   @cmdb.pankeys,@parm2  ; Pane hint to display

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = Pointer to string with hint
                                    ; / i  parm2 = YX position
        ;------------------------------------------------------
        ; ALPHA-Lock key down?
        ;------------------------------------------------------
        coc   @wbit10,config
        jeq   pane.cmdb.draw.alpha.down
        ;------------------------------------------------------
        ; AlPHA-Lock is up
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,78,32,2
              data eol

        jmp   pane.cmdb.draw.promptcmd
        ;------------------------------------------------------
        ; AlPHA-Lock is down
        ;------------------------------------------------------
pane.cmdb.draw.alpha.down:
        bl    @putat
              byte   pane.botrow,78
              data   txt.alpha.down
        ;------------------------------------------------------
        ; Command buffer content
        ;------------------------------------------------------
pane.cmdb.draw.promptcmd:
        mov   @waux1,tmp0           ; Flag set?
        jne   pane.cmdb.draw.hearts ; Yes, so skip refresh
        bl    @cmdb.refresh         ; Refresh command buffer content
        ;------------------------------------------------------
        ; Set color for hearts in TI-Basic dialog
        ;------------------------------------------------------
pane.cmdb.draw.hearts:
        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.basic  ; TI Basic dialog active?
        jne   pane.cmdb.draw.exit   ; No, so exit early
        bl    @tibasic.hearts.tat   ; Set color for hearts
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.draw.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

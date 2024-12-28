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
        li    tmp0,79
        mov   tmp0,@parm2           ; Set requested length
        li    tmp0,1
        mov   tmp0,@parm3           ; Set character to fill
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill character
                                    ; | i  @parm4 = Pointer to work buffer
                                    ; / o  @outparm1 = Pointer to padded string

        bl    @cpym2m               ; \
              data txt.stevie       ; |  Add Stevie banner as overlay
              data rambuf+64        ; | 
              data 23               ; /
                                                                        
        mov   @cmdb.yxtop,@wyx      ; \
        mov   @outparm1,tmp1        ; | Display pane header
        bl    @xutst0               ; /

        bl    @vchar
              byte pane.botrow - cmdb.rows + 1 ; Y-position         \
              byte 0                           ; X-position         |   LEFT 
              byte 6                           ; Vertical line char |
              byte cmdb.rows - 2               ; Y-repeat           /              
              byte pane.botrow - cmdb.rows + 1 ; Y-position         \
              byte 79                          ; X-position         |   RIGHT
              byte 7                           ; Vertical line char |
              byte cmdb.rows - 2               ; Y-repeat           /
              data EOL

        bl    @hchar
              byte pane.botrow-5,1,32,78 ; Clear message or command line prompt
              byte pane.botrow-4,1,32,78 ; Clear markers
              byte pane.botrow-3,1,32,78 ; Clear pane hint
              byte pane.botrow-2,1,32,78 ; Clear extra pane hint
              byte pane.botrow-1,0,8,1   ; Draw bottom left corner
              byte pane.botrow-1,1,10,78 ; Draw horizontal line
              byte pane.botrow-1,79,9,1  ; Draw bottom right corner
              data EOL              
        ;------------------------------------------------------
        ; Check dialog id
        ;------------------------------------------------------
        clr   @waux1                ; Default is show prompt
        mov   @cmdb.dialog,tmp0
        ci    tmp0,99                ; \ Hide prompt and no keyboard
        jle   pane.cmdb.draw.markers ; | buffer input if dialog ID > 99
        seto  @waux1                 ; /
        ;------------------------------------------------------
        ; Show info message instead of prompt
        ;------------------------------------------------------
        mov   @cmdb.paninfo,tmp1     ; Null pointer?
        jeq   pane.cmdb.draw.markers ; Yes, skip info message

        mov   @cmdb.paninfo,@parm1  ; Get string to display
        li    tmp0,76
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
              byte pane.botrow-5,2  ; Position cursor

        mov   @outparm1,tmp1        ; \ Display info message (=menu row)
        bl    @xutst0               ; /                                                                               
        ;------------------------------------------------------
        ; Show key markers ?
        ;------------------------------------------------------
pane.cmdb.draw.markers:
        mov   @cmdb.panmarkers,tmp0 ; Show markers?
        jeq   pane.cmdb.draw.hint   ; no, skip
        ;------------------------------------------------------
        ; Loop over key marker list
        ;------------------------------------------------------
pane.cmdb.draw.marker.loop:
        movb  *tmp0+,tmp1           ; Get X position
        srl   tmp1,8                ; Right align
        ci    tmp1,>00ff            ; End of list reached?
        jeq   pane.cmdb.draw.hint   ; Yes, exit loop

        inct  tmp1                  ; x = x + 2 
        ori   tmp1,(pane.botrow - 4) * 256
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
        mov   @cmdb.panhint,@parm2  ; Pane hint to display
        jeq   pane.cmdb.draw.extrahint
                                    ; No pane hint to display

        li    tmp0,pane.botrow - 2  ; \
        sla   tmp0,8                ; | Y=bottom row - 2
        ori   tmp0,2                ; | X=2
        mov   tmp0,@parm1           ; / Set parameter

        li    tmp0,76               ; \ Set pad length
        mov   tmp0,@parm3           ; /         

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = YX position
                                    ; | i  parm2 = Pointer to string with hint
                                    ; / i  parm3 = Pad length
        ;------------------------------------------------------
        ; Display extra pane hint in command buffer
        ;------------------------------------------------------
pane.cmdb.draw.extrahint:
        mov   @cmdb.panhint2,@parm2 ; Extra pane hint to display
        jeq   pane.cmdb.draw.keys   ; No extra pane hint to display

        li    tmp0,pane.botrow - 3  ; \
        sla   tmp0,8                ; | Y=bottom row - 3
        ori   tmp0,2                ; | X=2        
        mov   tmp0,@parm1           ; / Set parameter
        mov   @cmdb.panhint2,@parm2 ; Extra pane hint to display

        li    tmp0,76               ; \ Set pad length
        mov   tmp0,@parm3           ; / 

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = YX position
                                    ; | i  parm2 = Pointer to string with hint
                                    ; / i  parm3 = Pad length
        ;------------------------------------------------------
        ; Display keys in bottom status line
        ;------------------------------------------------------
pane.cmdb.draw.keys:
        li    tmp0,pane.botrow      ; \
        sla   tmp0,8                ; / Y=bottom row, X=0
        mov   tmp0,@parm1           ; Set parameter
        mov   @cmdb.pankeys,@parm2  ; Pane hint to display

        li    tmp0,60               ; \ Set pad length
        mov   tmp0,@parm3           ; / 

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = YX position
                                    ; | i  parm2 = Pointer to string with hint
                                    ; / i  parm3 = Pad length
        ;------------------------------------------------------
        ; ALPHA-Lock key down?
        ;------------------------------------------------------
        coc   @wbit10,config
        jeq   pane.cmdb.draw.alpha.down
        ;------------------------------------------------------
        ; AlPHA-Lock is up
        ;------------------------------------------------------
        bl    @putat
              byte   pane.botrow,78
              data   txt.ws2

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
        bl    @cmdb.refresh_prompt  ; Refresh command buffer content
        ;------------------------------------------------------
        ; Set color for hearts in TI-Basic dialog
        ;------------------------------------------------------
pane.cmdb.draw.hearts:
        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.basic  ; TI Basic dialog active?
        jne   pane.cmdb.draw.exit   ; No, so exit early

        li    tmp0,11               ; 1st Heart after string "Session: 1"
        mov   tmp0,@parm1           ; Set parameter

        ;bl    @dialog.hearts.tat    ; Dump colors for hearts
        ;                            ; \ i  @parm1 = Start column (pos 1st heart)
        ;                            ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.draw.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

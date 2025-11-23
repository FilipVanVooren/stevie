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
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3                
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
              data rambuf + 64      ; | 
              data 23               ; /
                                                                        
        mov   @cmdb.yxtop,@wyx      ; \
        mov   @outparm1,tmp1        ; | Display pane header
        bl    @xutst0               ; /

        bl    @vchar
              byte pane.botrow - cmdb.rows + 1 ; Y-position         \
              byte 0                           ; X-position         |   LEFT VERT BAR
              byte 6                           ; Vertical line char |
              byte cmdb.rows - 2               ; Y-repeat           /

              byte pane.botrow - cmdb.rows + 1 ; Y-position         \
              byte 1                           ; X-position         |   Clear left-over
              byte 32                          ; Vertical line char |   garbage
              byte cmdb.rows - 2               ; Y-repeat           /

              byte pane.botrow - cmdb.rows + 1 ; Y-position         \
              byte 79                          ; X-position         |   RIGHT VERT BAR
              byte 7                           ; Vertical line char |
              byte cmdb.rows - 2               ; Y-repeat           /
              data EOL

        bl    @hchar
              byte pane.botrow-1,0,8,1   ; Draw bottom left corner
              byte pane.botrow-1,1,10,78 ; Draw horizontal line
              byte pane.botrow-1,79,9,1  ; Draw bottom right corner
              data EOL              
        ;------------------------------------------------------
        ; Skip input prompt on menu dialogs
        ;------------------------------------------------------
        clr   @waux1                ; Default is show prompt
        mov   @cmdb.dialog,tmp0
        ci    tmp0,99                  ; \ Hide prompt and no keyboard
        jle   pane.cmdb.draw.nomarkers ; | buffer input if dialog ID > 99
        seto  @waux1                   ; /
        ;------------------------------------------------------
        ; Show menu entries
        ;------------------------------------------------------
        mov   @cmdb.paninfo,tmp1     ; Null pointer?
        jeq   pane.cmdb.draw.markers ; Yes, skip menu/info message

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
                                    ; | i  @parm4 = Pointer to work buffer
                                    ; / o  @outparm1 = Pointer to padded string

        bl    @at
              byte pane.botrow-5,2  ; Position cursor
        mov   @outparm1,tmp1        ; \ Display menu row
        bl    @xutst0               ; /                                                                               
        ;------------------------------------------------------
        ; Show menu key markers ?
        ;------------------------------------------------------
pane.cmdb.draw.markers:
        mov   @cmdb.panmarkers,tmp0 ; Show markers?
        jeq   pane.cmdb.draw.hint   ; no, skip
        ;------------------------------------------------------
        ; Prepare memory for menu key markers (including color)
        ;------------------------------------------------------
        bl    @film
              data rambuf,>00,80    ; Prepare space for markers 
                                    ; \ PNT max 80 chars (70 used)
                                    ; / 

        li    tmp0,rambuf + 80      ; Target address in RAM
        mov   @tv.cmdb.color,tmp1   ; Set color
        li    tmp2,80               ; Number of bytes to fill  

        bl    @xfilm                ; Set menu color for TAT
                                    ; \ i  tmp0 = Target address
                                    ; | i  tmp1 = Word to set
                                    ; / i  tmp2 = TAT max 80 chars (76 used)

        mov   @cmdb.panmarkers,tmp0 ; Get pointer to marker positions
        li    tmp2,>1c00            ; Set Marker char in MSB
        mov   @tv.cmdb.hcolor,tmp3  ; Get color combination
        swpb  tmp3                  ; Color in MSB
        ;------------------------------------------------------
        ; Loop over markers
        ;------------------------------------------------------
pane.cmdb.draw.marker.loop:
        movb  *tmp0+,tmp1           ; Get X position
        srl   tmp1,8                ; Right align
        ci    tmp1,>00ff            ; End of list reached?
        jeq   pane.cmdb.draw.render ; Yes, exit loop
        inc  tmp1                   ; Base 1 because of length-byte prefix
                                   
        movb  tmp2,@rambuf(tmp1)    ; Set marker char
        movb  tmp3,@rambuf+80(tmp1) ; Set color
        jmp   pane.cmdb.draw.marker.loop
                                    ; Next iteration
        ;------------------------------------------------------
        ; Render markers
        ;------------------------------------------------------
pane.cmdb.draw.render:
        li    tmp1,>4C00            ; \ Decimal 76 in MSB
        movb  tmp1,@rambuf          ; / Set length byte prefix for PNT string

        bl    @putat
              byte pane.botrow-4,2  ; Render markers
              data rambuf

        bl    @cpym2v               ; Highlight Menu Marker keys              
              data vdp.tat.base + vdp.tat.size - (6 * 80) + 2
                                    ; \ i  p0 = Destination in VDP memory
              data rambuf + 81      ; | i  p1 = Source in CPU memory
              data 76               ; / i  p2 = Number of bytes to copy

        jmp   pane.cmdb.draw.hint
        ;------------------------------------------------------
        ; Remove markers
        ;------------------------------------------------------
pane.cmdb.draw.nomarkers:
        bl    @hchar
              byte pane.botrow-4,2,32,76
              data EOL              ; Remove markers
        ;------------------------------------------------------
        ; Display pane hint in command buffer (botrow-2)
        ;------------------------------------------------------
pane.cmdb.draw.hint:
        mov   @cmdb.panhint,@parm2  ; Pane hint to display
        jeq   pane.cmdb.draw.hint2  ; No pane hint to display

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
        ; Display 2nd pane hint in command buffer (botrow-3)
        ;------------------------------------------------------
pane.cmdb.draw.hint2:
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

        li    tmp0,78               ; \ Set pad length
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
        ; Command line
        ;------------------------------------------------------
pane.cmdb.draw.promptcmd:
        mov   @waux1,tmp0           ; Flag set?
        jne   pane.cmdb.draw.exit   ; Yes, skip command line
        bl    @cmdb.refresh_prompt  ; Refresh command line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.draw.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

* FILE......: pane.cmdb.draw.asm
* Purpose...: Stevie Editor - Command Buffer pane

***************************************************************
* pane.cmdb.draw
* Draw Stevie Command Buffer in pane
***************************************************************
* bl  @pane.cmdb.draw
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

        bl    @at 
              byte pane.botrow-3,0  ; Position cursor

        movb  *tmp1,@cmdb.cmdlen    ; \  Deref & set length of message
        movb  *tmp1,tmp2            ; |
        srl   tmp2,8                ; |  
        bl    @xutst0               ; /  Display info message
        ;------------------------------------------------------
        ; Clear lines after prompt in command buffer
        ;------------------------------------------------------
pane.cmdb.draw.clear:        
        mov   @cmdb.cmdlen,tmp0     ; \
        srl   tmp0,8                ; | Set cursor after command prompt
        a     @cmdb.yxprompt,tmp0   ; |
        mov   tmp0,@wyx             ; /

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.                              
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        li    tmp1,32

        mov   @cmdb.cmdlen,tmp2     ; \
        srl   tmp2,8                ; | Determine number of bytes to fill.
        neg   tmp2                  ; | Based on command & prompt length
        ai    tmp2,2*80 - 1         ; /

        bl    @xfilv                ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
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
        jne   pane.cmdb.draw.exit   ; Yes, so exit early
        bl    @cmdb.refresh         ; Refresh command buffer content
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.draw.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

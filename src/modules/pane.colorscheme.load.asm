* FILE......: pane.colorscheme.load.asm
* Purpose...: Load color scheme

***************************************************************
* pane.colorscheme.load
* Load color scheme
***************************************************************
* bl  @pane.colorscheme.load
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into color scheme table
* @parm1          = Skip screen off if >FFFF
* @parm2          = Skip colorizing marked lines if >FFFF
* @parm3          = Only colorize CMDB pane if >FFFF
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.colorscheme.load:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push parm1
        dect  stack
        mov   @parm2,*stack         ; Push parm2
        dect  stack
        mov   @parm3,*stack         ; Push parm3
        ;-------------------------------------------------------
        ; Turn screen off
        ;-------------------------------------------------------
        mov   @parm1,tmp0
        ci    tmp0,>ffff            ; Skip flag set?
        jeq   !                     ; Yes, so skip screen off
        bl    @scroff               ; Turn screen off
        ;-------------------------------------------------------
        ; Calculate index into colorscheme table
        ;-------------------------------------------------------
!       bl    @pane.colorscheme.address 
                                      ; Get address of current color scheme
                                      ; \ i  @tv.colorscheme = Index entry
                                      ; / o  outparm1 = Address color scheme
        mov   @outparm1,tmp0
        ;-------------------------------------------------------
        ; ABCD) Get FG/BG colors framebuffer and topline
        ;-------------------------------------------------------
        mov   *tmp0+,tmp1           ; Get colors ABCD
        mov   tmp1,@tv.color        ; Save colors ABCD
        ;-------------------------------------------------------
        ; EFGH) Get cursor color CMDB & framebuffer
        ;-------------------------------------------------------
        mov   *tmp0,tmp1            ; Get colors EFGH
        andi  tmp1,>00ff            ; Only keep LSB (GH)
        mov   tmp1,@tv.curcolor     ; Save cursor color
        ;-------------------------------------------------------
        ; EFGH) Get FG/BG color CMDB pane
        ;-------------------------------------------------------
        mov   *tmp0+,tmp1           ; Get colors EFGH again
        andi  tmp1,>ff00            ; Only keep MSB (EF)
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@tv.cmdb.color   ; Save CMDB pane color
        ;-------------------------------------------------------
        ; IJKL) Get busy and marker colors
        ;-------------------------------------------------------
        mov   *tmp0,tmp1            ; Get colors IJKL
        srl   tmp1,8                ; \ Right align IJ and
        mov   tmp1,@tv.busycolor    ; / save to @tv.busycolor
        mov   *tmp0+,tmp1           ; Get colors IJKL again
        andi  tmp1,>00ff            ; \ save KL to @tv.markcolor
        mov   tmp1,@tv.markcolor    ; /
        ;-------------------------------------------------------
        ; MNOP) Colors CMDB header line
        ;-------------------------------------------------------
        mov   *tmp0,tmp1            ; Get colors MNOP
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@tv.cmdb.hcolor  ; Save CMDB header color
        ;-------------------------------------------------------
        ; MNOP) Get ruler and line/col counters color
        ;-------------------------------------------------------
        mov   *tmp0+,tmp1           ; Get colors MNOP again
        andi  tmp1,>000f            ; Only keep P
        sla   tmp1,4                ; Make it a FG/BG combination
        mov   tmp1,@tv.rulercolor   ; Save ruler color
        ;-------------------------------------------------------
        ; QRST) Colors bottom line
        ;-------------------------------------------------------
        mov   *tmp0+,tmp1           ; Get colors QRST
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@tv.botcolor     ; Save bottom line color
        ;-------------------------------------------------------
        ; Check if only CMDB needs to be colorized
        ;-------------------------------------------------------
        c     @parm3,@w$ffff        ; Only colorize CMDB pane ?
        jeq   pane.colorscheme.cmdbpane
                                    ; Yes, shortcut jump to CMDB pane
        ;-------------------------------------------------------
        ; MNOP) Write sprite color of line and column indicators to SAT
        ;-------------------------------------------------------
        ; Deprecated - not used anymore
        ;-------------------------------------------------------
        ; Dump colors to VDP register 7 (text mode)
        ;-------------------------------------------------------
        mov   @tv.color,tmp0        ; Get work copy of colors ABCD
        srl   tmp0,8                ; MSB to LSB
        ori   tmp0,>0700            ; VDP register #7
        bl    @putvrx               ; Write VDP register
        ;-------------------------------------------------------
        ; Dump colors for frame buffer pane (TAT)
        ;-------------------------------------------------------
        mov   @tv.ruler.visible,tmp0
        jeq   pane.colorscheme.fbdump.noruler
        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.help   ; Help dialog active?
        jeq   pane.colorscheme.fbdump.noruler
                                    ; Yes, skip ruler
        ;-------------------------------------------------------
        ; Ruler visible on screen (TAT)
        ;-------------------------------------------------------
        li    tmp0,vdp.fb.toprow.tat
        ai    tmp0,160              ; Skip 2 top rows
        li    tmp2,(pane.botrow-2)*80
                                    ; Number of bytes to fill
        jmp   pane.colorscheme.checkcmdb
        ;-------------------------------------------------------
        ; No ruler visible on screen (TAT)
        ;-------------------------------------------------------
pane.colorscheme.fbdump.noruler:
        li    tmp0,vdp.fb.toprow.tat
                                    ; VDP start address (frame buffer area)
        li    tmp2,(pane.botrow-1)*80
                                    ; Number of bytes to fill
        ;-------------------------------------------------------
        ; Adjust bottom of frame buffer if CMDB visible
        ;-------------------------------------------------------
pane.colorscheme.checkcmdb:
        mov   @cmdb.visible,@cmdb.visible
        jeq   pane.colorscheme.fbdump
                                    ; Not visible, skip adjustment
        ai    tmp2,-320             ; CMDB adjustment
        ;-------------------------------------------------------
        ; Dump colors to VDP (TAT)
        ;-------------------------------------------------------
pane.colorscheme.fbdump:
        mov   @tv.color,tmp1        ; Get work copy of colors ABCD
        srl   tmp1,8                ; MSB to LSB (frame buffer colors)
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Colorize marked lines
        ;-------------------------------------------------------
        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.help   ; Help dialog active?
        jeq   pane.colorscheme.cmdbpane
                                    ; Yes, skip marked lines
        mov   @parm2,tmp0
        ci    tmp0,>ffff            ; Skip colorize flag is on?
        jeq   pane.colorscheme.cmdbpane
        ;-------------------------------------------------------
        ; Dump colors for frame buffer (TAT)
        ;-------------------------------------------------------
        clr   @parm1                ; Clear force refresh flag
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        
        bl    @fb.colorlines        ; Colorize lines
                                    ; \ i  @parm1       = Force refresh if >ffff
                                    ; / i  @fb.colorize = Colorize if >ffff
        ;-------------------------------------------------------
        ; Dump colors for CMDB header line (TAT)
        ;-------------------------------------------------------
pane.colorscheme.cmdbpane:
        mov   @cmdb.visible,tmp0
        jeq   pane.colorscheme.errpane
                                    ; Skip if CMDB pane is hidden
        mov   @cmdb.vdptop,tmp0     ; Get VDP start address
        mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
        li    tmp2,1*64             ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Dump colors for CMDB Stevie logo (TAT)
        ;-------------------------------------------------------
        mov   @cmdb.vdptop,tmp0     ; Get VDP start address
        ai    tmp0,63               ; Add offset for logo
        mov   @tv.cmdb.hcolor,tmp1  ;
        movb  @tv.cmdb.hcolor+1,tmp1
                                    ; Copy same value into MSB
        srl   tmp1,4                ;
        andi  tmp1,>00ff            ; Only keep LSB
        li    tmp2,17               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Row 1-5: Dump colors for CMDB pane content (TAT)
        ;-------------------------------------------------------
        mov   @cmdb.vdptop,tmp0     ; \ CMDB PANE: All rows
        ai    tmp0,80               ; / VDP start address (CMDB top line + 1)
        mov   @tv.cmdb.hcolor,tmp1  ; Same color as header line
        li    tmp2,(cmdb.rows-1)*80 ; Number of bytes to fill 
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Row 1: Dump colors for CMDB pane content (TAT)
        ;-------------------------------------------------------
        mov   @cmdb.vdptop,tmp0     ; \ CMDB PANE: Row 1
        ai    tmp0,82               ; / VDP start address (CMDB top line + 1)
        mov   @tv.cmdb.color,tmp1   ; Get work copy fg/bg color
        li    tmp2,76               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Row 4: Dump colors for CMDB pane content (TAT)
        ;-------------------------------------------------------
        mov   @cmdb.vdptop,tmp0     ; \ CMDB PANE: Row 4
        ai    tmp0,4 * 80 + 2       ; / VDP start address (CMDB top line + 4)
        mov   @tv.cmdb.color,tmp1   ; Get work copy fg/bg color
        li    tmp2,76               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        bl    @pane.cmdb.draw       ; Draw CMDB pane  
        ;-------------------------------------------------------
        ; Exit early if only CMDB needed to be colorized
        ;-------------------------------------------------------
        mov   @parm3,tmp0
        ci    tmp0,>ffff            ; Only colorize CMDB pane ?
        jeq   pane.colorscheme.cursorcolor.cmdb
                                    ; Yes, shortcut to CMDB cursor color
        ;-------------------------------------------------------
        ; Dump colors for error pane (TAT)
        ;-------------------------------------------------------
pane.colorscheme.errpane:
        mov   @tv.error.visible,tmp0
        jeq   pane.colorscheme.topline
                                    ; Skip if error pane is hidden
        li    tmp1,>00f6            ; White on dark red
        mov   tmp1,@parm1           ; Pass color combination
        bl    @pane.errline.drawcolor
                                    ; Draw color on rows in error pane
                                    ; \ i  @tv.error.rows = Number of rows
                                    ; / i  @parm1         = Color combination
        ;-------------------------------------------------------
        ; Dump colors for top line (TAT)
        ;-------------------------------------------------------
pane.colorscheme.topline:
        mov   @tv.color,tmp1
        andi  tmp1,>00ff            ; Only keep LSB (status line colors)
        mov   tmp1,@parm1           ; Set color combination
        clr   @parm2                ; Top row on screen
        bl    @vdp.colors.line      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;-------------------------------------------------------
        ; Dump colors for bottom line (TAT)
        ;-------------------------------------------------------
        mov   @tv.botcolor,@parm1   ; Get color combination
        li    tmp1,pane.botrow
        mov   tmp1,@parm2           ; Bottom row on screen        
        bl    @vdp.colors.line      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;-------------------------------------------------------
        ; Dump colors for ruler if visible (TAT)
        ;-------------------------------------------------------
pane.colorscheme.ruler:
        mov   @cmdb.dialog,tmp1
        ci    tmp1,id.dialog.help   ; Help dialog active?
        jeq   pane.colorscheme.cursorcolor
                                    ; Yes, skip ruler

        mov   @tv.ruler.visible,tmp1
        jeq   pane.colorscheme.cursorcolor

        bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
        bl    @cpym2v
              data vdp.fb.toprow.tat
              data fb.ruler.tat
              data 80               ; Show ruler colors
        ;-------------------------------------------------------
        ; Dump cursor FG color
        ;-------------------------------------------------------
pane.colorscheme.cursorcolor:
        mov   @tv.pane.focus,tmp0   ; Get pane with focus
        ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
        jeq   pane.colorscheme.cursorcolor.fb
                                    ; Yes, set cursor color
pane.colorscheme.cursorcolor.cmdb:
        mov   @tv.curcolor,tmp0     ; Get cursor color
        andi  tmp0,>f0              ; Only keep high-nibble -> Word 2 (G)
        sla   tmp0,4                ; Move to MSB
        jmp   !
pane.colorscheme.cursorcolor.fb:
        mov   @tv.curcolor,tmp0     ; Get cursor color
        andi  tmp0,>0f              ; Only keep low-nibble -> Word 2 (H)
        sla   tmp0,8                ; Move to MSB
!       movb  tmp0,@tv.curshape+1   ; Save cursor color
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.colorscheme.load.exit:
        bl    @scron                ; Turn screen on
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

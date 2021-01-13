* FILE......: pane.topline.asm
* Purpose...: Pane "status top line"

***************************************************************
* pane.topline.draw
* Draw top line
***************************************************************
* bl  @pane.topline.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.topline:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Show separators
        ;------------------------------------------------------
        bl    @hchar
              byte 0,50,16,1        ; Vertical line 1
              byte 0,70,16,1        ; Vertical line 2
              data eol        
        ;------------------------------------------------------
        ; Show buffer number
        ;------------------------------------------------------
        bl    @putat 
              byte  0,0
              data  txt.bufnum
        ;------------------------------------------------------
        ; Show current file
        ;------------------------------------------------------ 
        mov   @edb.filename.ptr,@parm1  
                                    ; Get string to display
        li    tmp0,47
        mov   tmp0,@parm2           ; Set requested length
        li    tmp0,32
        mov   tmp0,@parm3           ; Set character to fill
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string


        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill characgter
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string        

        bl    @setx
              data 3                ; Position cursor
      
        mov   @outparm1,tmp1        ; \ Display padded filename
        bl    @xutst0               ; / 
        ;------------------------------------------------------
        ; Show M1 marker
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0    ; \  
        inc   tmp0                  ; | Exit early if M1 unset (>ffff)
        jeq   pane.topline.exit     ; /

        bl    @putat
              byte 0,52
              data txt.m1           ; Show M1 marker message

        mov   @edb.block.m1,@parm1
        bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
                                    ; \ i @parm1           = uint16
                                    ; / o @unpacked.string = Output string

        li    tmp0,>0500
        movb  tmp0,@unpacked.string ; Set string length to 5 (padding)

        bl    @putat
              byte 0,55
              data unpacked.string  ; Show M1 value
        ;------------------------------------------------------
        ; Show M2 marker
        ;------------------------------------------------------
        mov   @edb.block.m2,tmp0    ; \  
        inc   tmp0                  ; | Exit early if M2 unset (>ffff)
        jeq   pane.topline.exit     ; /

        bl    @putat
              byte 0,62
              data txt.m2           ; Show M2 marker message

        mov   @edb.block.m2,@parm1
        bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
                                    ; \ i @parm1           = uint16
                                    ; / o @unpacked.string = Output string


        li    tmp0,>0500
        movb  tmp0,@unpacked.string ; Set string length to 5 (padding)

        bl    @putat
              byte 0,65
              data unpacked.string  ; Show M2 value
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.topline.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
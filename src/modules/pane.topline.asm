* FILE......: pane.topline.asm
* Purpose...: Pane top line of screen

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
        bl    @setx
              data 3                ; Position cursor

        mov   @edb.filename.ptr,tmp1
                                    ; Get string to display
        bl    @xutst0               ; Display string
        ;------------------------------------------------------
        ; Show M1 marker
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0    ; M1 set?
        jeq   pane.topline.exit

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
        mov   @edb.block.m2,tmp0    ; M2 set?
        jeq   pane.topline.exit

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

        bl    @putat
              byte pane.botrow,0
              data txt.keys.block   ; Show block shortcuts
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.topline.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
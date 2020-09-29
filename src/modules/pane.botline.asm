* FILE......: pane.botline.asm
* Purpose...: Stevie Editor - Pane status bottom line

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Pane status bottom line
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.botline.draw
* Draw Stevie status bottom line
***************************************************************
* bl  @pane.botline.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.botline.draw:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   @wyx,@fb.yxsave
        ;------------------------------------------------------
        ; Show separators
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,44,14,1       ; Vertical line 1
              byte pane.botrow,60,14,1       ; Vertical line 2
              byte pane.botrow,71,14,1       ; Vertical line 3
              data eol
        ;------------------------------------------------------
        ; Show buffer number
        ;------------------------------------------------------
pane.botline.bufnum:
        bl    @putat 
              byte  pane.botrow,0
              data  txt.bufnum
        ;------------------------------------------------------
        ; Show current file
        ;------------------------------------------------------
pane.botline.show_file:        
        bl    @at
              byte  pane.botrow,3   ; Position cursor
        mov   @edb.filename.ptr,tmp1
                                    ; Get string to display
        bl    @xutst0               ; Display string
        ;------------------------------------------------------
        ; Show text editing mode
        ;------------------------------------------------------
pane.botline.show_mode:
        mov   @edb.insmode,tmp0
        jne   pane.botline.show_mode.insert
        ;------------------------------------------------------
        ; Overwrite mode
        ;------------------------------------------------------
pane.botline.show_mode.overwrite:
        bl    @putat
              byte  pane.botrow,46
              data  txt.ovrwrite
        jmp   pane.botline.show_changed
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
pane.botline.show_mode.insert:
        bl    @putat
              byte  pane.botrow,46
              data  txt.insert
        ;------------------------------------------------------
        ; Show if text was changed in editor buffer
        ;------------------------------------------------------        
pane.botline.show_changed:
        mov   @edb.dirty,tmp0
        jeq   pane.botline.show_linecol
        ;------------------------------------------------------
        ; Show "*"
        ;------------------------------------------------------        
        bl    @putat
              byte pane.botrow,50
              data txt.star
        jmp   pane.botline.show_linecol
        ;------------------------------------------------------
        ; Show "line,column"
        ;------------------------------------------------------        
pane.botline.show_linecol:
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        inc   @outparm1
        ;------------------------------------------------------
        ; Show line
        ;------------------------------------------------------
        bl    @putnum
              byte  pane.botrow,62  ; YX
              data  outparm1,rambuf
              byte  48              ; ASCII offset 
              byte  32              ; Padding character
        ;------------------------------------------------------
        ; Show comma
        ;------------------------------------------------------
        bl    @putat
              byte  pane.botrow,67
              data  txt.delim
        ;------------------------------------------------------
        ; Show column
        ;------------------------------------------------------
        bl    @film
              data rambuf+6,32,12   ; Clear work buffer with space character

        mov   @fb.column,@waux1
        inc   @waux1                ; Offset 1

        bl    @mknum                ; Convert unsigned number to string
              data  waux1,rambuf
              byte  48              ; ASCII offset
              byte  32              ; Fill character

        bl    @trimnum              ; Trim number to the left
              data  rambuf,rambuf+6,32

        li    tmp0,>0200
        movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars 
                                
        bl    @putat
              byte pane.botrow,68
              data rambuf+6         ; Show column
        ;------------------------------------------------------
        ; Show lines in buffer unless on last line in file
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        c     @edb.lines,@outparm1
        jne   pane.botline.show_lines_in_buffer

        bl    @putat
              byte pane.botrow,73
              data txt.bottom

        jmp   pane.botline.exit
        ;------------------------------------------------------
        ; Show lines in buffer
        ;------------------------------------------------------
pane.botline.show_lines_in_buffer:
        mov   @edb.lines,@waux1
        inc   @waux1                ; Offset 1

        bl    @putnum
              byte pane.botrow,73   ; YX
              data waux1,rambuf
              byte 48
              byte 32
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.exit:
        mov   @fb.yxsave,@wyx
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
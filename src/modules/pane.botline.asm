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
              byte pane.botrow,42,16,1       ; Vertical line 1
              byte pane.botrow,50,16,1       ; Vertical line 2
              byte pane.botrow,71,16,1       ; Vertical line 3
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
              byte  pane.botrow,44
              data  txt.ovrwrite
        jmp   pane.botline.show_changed
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
pane.botline.show_mode.insert:
        bl    @putat
              byte  pane.botrow,44
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
              byte pane.botrow,48
              data txt.star
        jmp   pane.botline.show_linecol
        ;------------------------------------------------------
        ; Show "line,column"
        ;------------------------------------------------------        
pane.botline.show_linecol:
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inc   @outparm1             ; Add base 1
        ;------------------------------------------------------
        ; Show line
        ;------------------------------------------------------
        bl    @putnum
              byte  pane.botrow,59  ; YX
              data  outparm1,rambuf
              byte  48              ; ASCII offset 
              byte  32              ; Padding character
        ;------------------------------------------------------
        ; Show comma
        ;------------------------------------------------------
        bl    @putat
              byte  pane.botrow,64
              data  txt.delim
        ;------------------------------------------------------
        ; Show column 
        ;------------------------------------------------------
        bl    @film
              data rambuf+5,32,12   ; Clear work buffer with space character

        mov   @fb.column,@waux1
        inc   @waux1                ; Offset 1

        bl    @mknum                ; Convert unsigned number to string
              data  waux1,rambuf
              byte  48              ; ASCII offset
              byte  32              ; Fill character

        bl    @trimnum              ; Trim number to the left
              data  rambuf,rambuf+5,32

        li    tmp0,>0600            ; "Fix" number length to clear junk chars  
        movb  tmp0,@rambuf+5        ; Set length byte

        ;------------------------------------------------------
        ; Decide if row length is to be shown
        ;------------------------------------------------------
        mov   @fb.column,tmp0       ; \ Base 1 for comparison
        inc   tmp0                  ; /
        c     tmp0,@fb.row.length   ; Check if cursor on last column on row
        jlt   pane.botline.show_linecol.linelen
        jmp   pane.botline.show_linecol.colstring
                                    ; Yes, skip showing row length        
        ;------------------------------------------------------
        ; Add '/' delimiter and length of line to string
        ;------------------------------------------------------        
pane.botline.show_linecol.linelen:
        mov   @fb.column,tmp0       ; \ 
        li    tmp1,rambuf+7         ; | Determine column position for '-' char
        ci    tmp0,9                ; | based on number of digits in cursor X
        jlt   !                     ; | column.
        inc   tmp1                  ; /

!       li    tmp0,>2d00            ; \ ASCII 2d '-'
        movb  tmp0,*tmp1+           ; / Add delimiter to string

        mov   tmp1,@waux1           ; Backup position in ram buffer

        bl    @mknum
              data  fb.row.length,rambuf
              byte  48              ; ASCII offset 
              byte  32              ; Padding character

        mov   @waux1,tmp1           ; Restore position in ram buffer

        mov   @fb.row.length,tmp0   ; \ Get length of line
        ci    tmp0,10               ; / 
        jlt   pane.botline.show_line.1digit
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------           
        ci    tmp0,80
        jle   pane.botline.show_line.2digits
        ;------------------------------------------------------
        ; Sanity checks failed
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;------------------------------------------------------
        ; Show length of line (2 digits)
        ;------------------------------------------------------   
pane.botline.show_line.2digits:
        li    tmp0,rambuf+3
        movb  *tmp0+,*tmp1+         ; 1st digit row length
        jmp   pane.botline.show_line.rest
        ;------------------------------------------------------
        ; Show length of line (1 digits)
        ;------------------------------------------------------   
pane.botline.show_line.1digit:
        li    tmp0,rambuf+4
pane.botline.show_line.rest:
        movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
        movb  @rambuf+0,*tmp1+      ; Append a whitespace character
        movb  @rambuf+0,*tmp1+      ; Append a whitespace character
        ;------------------------------------------------------
        ; Show column string
        ;------------------------------------------------------
pane.botline.show_linecol.colstring:
        bl    @putat
              byte pane.botrow,65
              data rambuf+5         ; Show string
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
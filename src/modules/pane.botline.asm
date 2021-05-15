* FILE......: pane.botline.asm
* Purpose...: Pane "status bottom line"

***************************************************************
* pane.botline
* Draw Stevie bottom line
***************************************************************
* bl  @pane.botline
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.botline:
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
              byte pane.botrow,50,16,1       ; Vertical line 1
              byte pane.botrow,71,16,1       ; Vertical line 2
              data eol
        ;------------------------------------------------------
        ; Show block shortcuts if set
        ;------------------------------------------------------
        mov   @edb.block.m2,tmp0    ; \  
        inc   tmp0                  ; | Skip if M2 unset (>ffff)
                                    ; /
        jeq   pane.botline.show_keys

        bl    @putat
              byte pane.botrow,0
              data txt.keys.block   ; Show block shortcuts

        jmp   pane.botline.show_mode  
        ;------------------------------------------------------
        ; Show default message
        ;------------------------------------------------------
pane.botline.show_keys:        
        bl    @putat
              byte pane.botrow,0
              data txt.stevie       ; Show stevie version

        bl    @hchar
              byte pane.botrow,14,16,1       
              data eol              ; Vertical line 3

        bl    @putat
              byte pane.botrow,16
              data txt.keys.default ; Show default shortcuts
        ;------------------------------------------------------
        ; Show text editing mode
        ;------------------------------------------------------
pane.botline.show_mode:
        mov   @edb.insmode,tmp0
        jne   pane.botline.show_mode.insert
        ;------------------------------------------------------
        ; Overwrite mode
        ;------------------------------------------------------
        bl    @putat
              byte  pane.botrow,52
              data  txt.ovrwrite
        jmp   pane.botline.show_changed
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
pane.botline.show_mode.insert:
        bl    @putat
              byte  pane.botrow,52
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
              byte pane.botrow,56
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
        ; Add ',' delimiter and length of line to string
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
        ; Assert
        ;------------------------------------------------------           
        ci    tmp0,80
        jle   pane.botline.show_line.2digits
        ;------------------------------------------------------
        ; Asserts failed
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
              byte pane.botrow,72
              data txt.bottom

        jmp   pane.botline.exit
        ;------------------------------------------------------
        ; Show lines in buffer
        ;------------------------------------------------------
pane.botline.show_lines_in_buffer:
        mov   @edb.lines,@waux1

        bl    @putnum
              byte pane.botrow,72   ; YX
              data waux1,rambuf
              byte 48
              byte 32
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.exit:
        mov   *stack+,@wyx          ; Pop cursor position        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
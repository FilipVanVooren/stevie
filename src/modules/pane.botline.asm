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
* tmp0, tmp1
********|*****|*********************|**************************
pane.botline:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Prepare for special message
        ;------------------------------------------------------
pane.botline.mc:        
        abs   @tv.specmsg.ptr       ; \ 
                                    ; / Check if special message set
                                       
        jeq   pane.botline.shortcuts
                                    ; No, skip message

        mov   @tv.cmdb.hcolor,@parm1
                                    ; Get color combination of CMDB header line

        li    tmp0,pane.botrow-1    ; \
        mov   tmp0,@parm2           ; / Set row on physical screen

        bl    @vdp.colors.line      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen

        bl    @at
              byte pane.botrow-1,0  ; Cursor YX position                                    
        ;------------------------------------------------------
        ; Pad message to 80 characters
        ;------------------------------------------------------
        mov   @tv.specmsg.ptr,@parm1
                                    ; Pointer to length-prefixed string
        mov   @const.80,@parm2      ; Requested length
        mov   @const.32,@parm3      ; Fill with white space
        li    tmp0,rambuf           ; \
        mov   tmp0,@parm4           ; / Pointer to work buffer

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill character
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string
        ;------------------------------------------------------
        ; Show special message
        ;------------------------------------------------------
        mov   @outparm1,tmp1        ; Pointer to padded string

        bl    @xutst0               ; Display string
                                    ; \ i  tmp1 = Pointer to string
                                    ; / i  @wyx = Cursor position at
        ;------------------------------------------------------
        ; Show block shortcuts if set
        ;------------------------------------------------------
pane.botline.shortcuts:        
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
        mov   @tib.session,tmp0     ; Active TI Basic session?
        jeq   !
        ;------------------------------------------------------
        ; Show TI Basic session ID
        ;------------------------------------------------------
        bl    @putat
              byte pane.botrow,0
              data txt.keys.defaultb
                                    ; Show defaults + TI Basic

        mov   @tib.session,tmp0     ; Get Session ID
        ai    tmp0,>0130            ; \ Turn into string with
                                    ; | length-byte prefix and
                                    ; / ASCII offset 48 (>30)

        mov   tmp0,@rambuf          ; Copy to ram buffer for display

        bl    @putat                ; \
              byte pane.botrow,41   ; | Display session-ID string
              data rambuf           ; / Y=bottom row, X=41
        ;------------------------------------------------------
        ; Show default keys
        ;------------------------------------------------------
!       bl    @putat
              byte pane.botrow,0
              data txt.keys.default ; Show default keys
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
              byte  pane.botrow,54
              data  txt.ovrwrite
        jmp   pane.botline.show_dirty
        ;------------------------------------------------------
        ; Insert mode
        ;------------------------------------------------------
pane.botline.show_mode.insert:
        mov   @edb.autoinsert,tmp0
        jeq   pane.botline.show_mode.insert.noauto
        ;------------------------------------------------------
        ; Auto-Insert
        ;------------------------------------------------------
        bl    @putat
              byte  pane.botrow,54
              data  txt.autoinsert
        jmp   pane.botline.show_dirty
        ;------------------------------------------------------
        ; No Auto-Insert
        ;------------------------------------------------------
pane.botline.show_mode.insert.noauto:
        bl    @putat
              byte  pane.botrow,54
              data  txt.insert
        ;------------------------------------------------------
        ; Show if text was changed in editor buffer
        ;------------------------------------------------------        
pane.botline.show_dirty:
        mov   @edb.dirty,tmp0 
        jeq   pane.botline.nochange
        ;------------------------------------------------------
        ; Show "*" 
        ;------------------------------------------------------        
        bl    @putat
              byte pane.botrow,58
              data txt.star
        jmp   pane.botline.show_linecol
        ;------------------------------------------------------
        ; Show " " 
        ;------------------------------------------------------        
pane.botline.nochange:        
        bl    @putat
              byte pane.botrow,58
              data txt.ws1          ; Single white space      
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

        mov   @fb.column,tmp0       ; Get column
        a     @fb.vwco,tmp0         ; Add view window column offset
        inc   tmp0                  ; Offset 1
        mov   tmp0,@waux1           ; Save in temporary

        bl    @mknum                ; Convert unsigned number to string
              data  waux1,rambuf    ; \
              byte  48              ; | ASCII offset
              byte  32              ; / Fill character

        bl    @trimnum              ; Trim number to the left
              data  rambuf,rambuf+5,32

        li    tmp0,>0600            ; "Fix" number length to clear junk chars
        movb  tmp0,@rambuf+5        ; Set length byte

        ;------------------------------------------------------
        ; Decide if row length is to be shown
        ;------------------------------------------------------
        mov   @fb.column,tmp0       ; \ Base 1 for comparison
        a     @fb.vwco,tmp0         ; | Add view window column offset
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
        a     @fb.vwco,tmp0         ; | Add view window column offset
        li    tmp1,rambuf+7         ; | Determine column position for '/' char
        ci    tmp0,9                ; | based on number of digits in cursor X
        jlt   !                     ; | column.
        inc   tmp1                  ; /

!       li    tmp0,>2f00            ; \ ASCII '/'
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
        ci    tmp0,99
        jle   pane.botline.show_line.2digits
        ;------------------------------------------------------
        ; Show length of line (3 digits)
        ;------------------------------------------------------
pane.botline.show_line.3digits:
        li    tmp0,rambuf+2
        movb  *tmp0+,*tmp1+         ; 1st digit row length
        movb  *tmp0+,*tmp1+         ; 2nd digit row length
        jmp   pane.botline.show_line.rest
        ;------------------------------------------------------
        ; Show length of line (2 digits)
        ;------------------------------------------------------
pane.botline.show_line.2digits:
        li    tmp0,rambuf+3
        movb  *tmp0+,*tmp1+         ; 1st digit row length
        jmp   pane.botline.show_line.rest
        ;------------------------------------------------------
        ; Show length of line (1 digit)
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
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

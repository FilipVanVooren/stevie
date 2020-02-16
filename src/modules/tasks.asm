* FILE......: tasks.asm
* Purpose...: TiVi Editor - Tasks module

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

****************************************************************
* Editor - spectra2 user hook
****************************************************************
editor  coc   @wbit11,config        ; ANYKEY pressed ?
        jne   ed_clear_kbbuffer     ; No, clear buffer and exit
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @waux1,@waux2         ; Still pressing previous key?
        jeq   ed_wait
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
ed_new_key
        mov   @waux1,@waux2         ; Save as previous key
        b     @edkey                ; Process key
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
ed_clear_kbbuffer
        clr   @waux1
        clr   @waux2
*--------------------------------------------------------------
* Delay to avoid key bouncing
*-------------------------------------------------------------- 
ed_wait
        li    tmp0,1800             ; Key delay to avoid bouncing keys
        ;------------------------------------------------------
        ; Delay loop
        ;------------------------------------------------------
ed_wait_loop
        dec   tmp0
        jne   ed_wait_loop
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
ed_exit b     @hookok               ; Return






***************************************************************
* Task 0 - Copy frame buffer to VDP
***************************************************************
task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
        jeq   task0.exit            ; No, skip update
        ;------------------------------------------------------ 
        ; Determine how many rows to copy 
        ;------------------------------------------------------
        c     @edb.lines,@fb.screenrows
        jlt   task0.setrows.small
        mov   @fb.screenrows,tmp1   ; Lines to copy
        jmp   task0.copy.framebuffer
        ;------------------------------------------------------
        ; Less lines in editor buffer as rows in frame buffer 
        ;------------------------------------------------------
task0.setrows.small:
        mov   @edb.lines,tmp1       ; Lines to copy
        inc   tmp1
        ;------------------------------------------------------
        ; Determine area to copy
        ;------------------------------------------------------
task0.copy.framebuffer:
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
        clr   tmp0                  ; VDP target address
        mov   @fb.top.ptr,tmp1      ; RAM Source address
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
        bl    @xpym2v               ; Copy to VDP
                                    ; tmp0 = VDP target address
                                    ; tmp1 = RAM source address
                                    ; tmp2 = Bytes to copy
        clr   @fb.dirty             ; Reset frame buffer dirty flag
        ;-------------------------------------------------------
        ; Draw EOF marker at end-of-file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
        inc   tmp0                  ; Y++
        c     @fb.screenrows,tmp0   ; Hide if last line on screen
        jle   task0.exit
        ;-------------------------------------------------------
        ; Draw EOF marker 
        ;-------------------------------------------------------
task0.draw_marker:
        mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
        sla   tmp0,8                ; X=0
        mov   tmp0,@wyx             ; Set VDP cursor
        bl    @putstr
              data txt_marker       ; Display *EOF*
        ;-------------------------------------------------------
        ; Draw empty line after (and below) EOF marker
        ;-------------------------------------------------------
        bl    @setx   
              data  5               ; Cursor after *EOF* string

        mov   @wyx,tmp0
        srl   tmp0,8                ; Right justify                
        inc   tmp0                  ; One time adjust
        c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
        jeq   !
        li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
        jmp   task0.draw_marker.line
!       li    tmp2,colrow-5         ; Repeat count for 1 line
        ;-------------------------------------------------------
        ; Draw empty line
        ;-------------------------------------------------------
task0.draw_marker.line:        
        dec   tmp0                  ; One time adjust
        bl    @yx2pnt               ; Set VDP address in tmp0
        li    tmp1,32               ; Character to write (whitespace)
        bl    @xfilv                ; Write characters
        mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
*--------------------------------------------------------------
* Task 0 - Exit
*--------------------------------------------------------------
task0.exit:
        b     @slotok



***************************************************************
* Task 1 - Copy SAT to VDP
***************************************************************
task1   soc   @wbit0,config          ; Sprite adjustment on
        bl    @yx2px                 ; Calculate pixel position, result in tmp0
        mov   tmp0,@ramsat           ; Set cursor YX
        jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task



***************************************************************
* Task 2 - Update cursor shape (blink)
***************************************************************
task2   inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   task2.cur_visible
        clr   @ramsat+2              ; Hide cursor
        jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task

task2.cur_visible:
        mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
        jeq   task2.cur_visible.overwrite_mode
        ;------------------------------------------------------
        ; Cursor in insert mode
        ;------------------------------------------------------
task2.cur_visible.insert_mode:
        li    tmp0,>0008
        jmp   task2.cur_visible.cursorshape
        ;------------------------------------------------------
        ; Cursor in overwrite mode
        ;------------------------------------------------------
task2.cur_visible.overwrite_mode:
        li    tmp0,>0208
        ;------------------------------------------------------
        ; Set cursor shape
        ;------------------------------------------------------
task2.cur_visible.cursorshape:
        mov   tmp0,@fb.curshape
        mov   tmp0,@ramsat+2




*--------------------------------------------------------------
* Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
*--------------------------------------------------------------
task.sub_copy_ramsat:
        bl    @cpym2v
              data sprsat,ramsat,4   ; Update sprite

        mov   @wyx,@fb.yxsave

        ;-------------------------------------------------------
        ; Draw border line
        ;-------------------------------------------------------
        bl    @hchar
              byte 28,0,1,80
              data EOL
        ;------------------------------------------------------
        ; Show buffer number
        ;------------------------------------------------------
        bl    @putat 
              byte  29,0
              data  txt_bufnum
        ;------------------------------------------------------
        ; Show current file
        ;------------------------------------------------------
        bl    @at
              byte  29,3             ; Position cursor

        mov   @edb.filename.ptr,tmp1 ; Get string to display
        bl    @xutst0                ; Display string
        ;------------------------------------------------------
        ; Show text editing mode
        ;------------------------------------------------------
task.botline.show_mode:
        mov   @edb.insmode,tmp0
        jne   task.botline.show_mode.insert
        ;------------------------------------------------------
        ; Overwrite mode
        ;------------------------------------------------------
task.botline.show_mode.overwrite:
        bl    @putat
              byte  29,50
              data  txt_ovrwrite
        jmp   task.botline.show_changed
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
task.botline.show_mode.insert:
        bl    @putat
              byte  29,50
              data  txt_insert
        ;------------------------------------------------------
        ; Show if text was changed in editor buffer
        ;------------------------------------------------------        
task.botline.show_changed:
        mov   @edb.dirty,tmp0
        jeq   task.botline.show_changed.clear
        ;------------------------------------------------------
        ; Show "*"
        ;------------------------------------------------------        
        bl    @putat
              byte 29,54
              data txt_star
        jmp   task.botline.show_linecol
        ;------------------------------------------------------
        ; Show "line,column"
        ;------------------------------------------------------        
task.botline.show_changed.clear:        
        nop
task.botline.show_linecol:
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        inc   @outparm1
        ;------------------------------------------------------
        ; Show line
        ;------------------------------------------------------
        bl    @putnum
              byte  29,64            ; YX
              data  outparm1,rambuf
              byte  48               ; ASCII offset 
              byte  32               ; Padding character
        ;------------------------------------------------------
        ; Show comma
        ;------------------------------------------------------
        bl    @putat
              byte  29,69
              data  txt_delim
        ;------------------------------------------------------
        ; Show column
        ;------------------------------------------------------
        bl    @film
              data rambuf+6,32,12    ; Clear work buffer with space character

        mov   @fb.column,@waux1
        inc   @waux1                 ; Offset 1

        bl    @mknum                 ; Convert unsigned number to string
              data  waux1,rambuf
              byte  48               ; ASCII offset
              byte  32               ; Fill character

        bl    @trimnum               ; Trim number to the left
              data  rambuf,rambuf+6,32

        li    tmp0,>0200
        movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars 
                                
        bl    @putat
              byte 29,70
              data rambuf+6          ; Show column
        ;------------------------------------------------------
        ; Show lines in buffer unless on last line in file
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        c     @edb.lines,@outparm1
        jne   task.botline.show_lines_in_buffer

        bl    @putat
              byte 29,75
              data txt_bottom

        jmp   task.botline.exit
        ;------------------------------------------------------
        ; Show lines in buffer
        ;------------------------------------------------------
task.botline.show_lines_in_buffer:
        mov   @edb.lines,@waux1
        inc   @waux1                 ; Offset 1
        bl    @putnum
              byte 29,75             ; YX
              data waux1,rambuf
              byte 48
              byte 32
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.botline.exit
        mov   @fb.yxsave,@wyx
        b     @slotok                ; Exit running task

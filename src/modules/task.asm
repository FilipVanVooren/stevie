* FILE......: task.asm
* Purpose...: TiVi Editor - Code shared between tasks

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Code shared between tasks
*//////////////////////////////////////////////////////////////


*--------------------------------------------------------------
* Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
*--------------------------------------------------------------
task.sub_copy_ramsat:
        dect  stack
        mov   tmp0,*stack            ; Push tmp0

        bl    @cpym2v                ; Copy sprite SAT to VDP
              data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
                                     ; | i  tmp1 = ROM/RAM source
                                     ; / i  tmp2 = Number of bytes to write

        mov   @wyx,@fb.yxsave
        ;------------------------------------------------------
        ; Show buffer number
        ;------------------------------------------------------
task.botline.bufnum:
        bl    @putat 
              byte  29,0
              data  txt.bufnum
        ;------------------------------------------------------
        ; Show current file
        ;------------------------------------------------------
task.botline.show_file:        
        bl    @at
              byte  29,3             ; Position cursor
        mov   @edb.filename.ptr,tmp1 ; Get string to display
        bl    @xutst0                ; Display string

        bl    @at
              byte  29,35            ; Position cursor

        mov   @edb.filetype.ptr,tmp1 ; Get string to display
        bl    @xutst0                ; Display Filetype string
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
              data  txt.ovrwrite
        jmp   task.botline.show_changed
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
task.botline.show_mode.insert:
        bl    @putat
              byte  29,50
              data  txt.insert
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
              data txt.star
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
              data  txt.delim
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
              data txt.bottom

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
task.botline.exit:
        mov   @fb.yxsave,@wyx
        mov   *stack+,tmp0           ; Pop tmp0
        b     @slotok                ; Exit running task

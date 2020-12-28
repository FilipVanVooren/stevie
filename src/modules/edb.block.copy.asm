* FILE......: edb.block.copy.asm
* Purpose...: Copy code block

***************************************************************
* edb.block.copy
* Copy code block
***************************************************************
*  bl   @edb.block.copy
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.block.copy:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------        
        ; Sanity checks
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0    ; M1 unset?
        jeq   edb.block.copy.exit   ; Yes, exit early

        mov   @edb.block.m2,tmp1    ; M2 unset?
        jeq   edb.block.copy.exit   ; Yes, exit early

        c     tmp0,tmp1             ; M1 > M2 
        jgt   edb.block.copy.exit   ; Yes, exit early
        ;------------------------------------------------------
        ; Display "Copying...."
        ;------------------------------------------------------
        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 

        bl    @hchar
              byte pane.botrow,0,32,50
              data eol              ; Remove markers and block shortcuts

        bl    @putat
              byte pane.botrow,0
              data txt.block.copy   ; Display "Copying block...."     
        ;------------------------------------------------------
        ; Prepare for copy 
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp1
        mov   @edb.block.m2,tmp2
        s     tmp1,tmp2
        inc   tmp2                  ; One time adjustment
        ;------------------------------------------------------
        ; Get current line position in editor buffer
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @edb.block.m1,tmp0    ; Source line for copy (start with M1)
        ;------------------------------------------------------
        ; Copy code block
        ;------------------------------------------------------
edb.block.copy.loop:
        mov   @outparm1,@parm1      ; Target line for insert (current line)
        mov   @edb.lines,@parm2     ; Last line to reorganize         

        bl    @idx.entry.insert     ; Reorganize index, insert new line
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg

        mov   @parm1,@parm2         ; Target line for copy (current line)
        mov   tmp0,@parm1           ; Source line for copy (started from M1)

    ;    bl    @edb.line.copy        ; Copy line 
                                    ; \ i  @parm1 = Source line in editor buffer
                                    ; / i  @parm2 = Target line in editor buffer

        inc   @edb.lines            ; One line added to editor buffer
        inc   tmp0                  ; M1++
        dec   tmp2                  ; Update ooop counter
        jgt   edb.block.copy.loop   ; Next line
        ;------------------------------------------------------
        ; Copy loop completed
        ;------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        seto  @fb.dirty        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.copy.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
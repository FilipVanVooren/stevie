* FILE......: edb.block.copy.asm
* Purpose...: Copy code block

***************************************************************
* edb.block.copy
* Copy code block
***************************************************************
*  bl   @edb.block.copy
*--------------------------------------------------------------
* INPUT
* @edb.block.m1 = Marker M1 line
* @edb.block.m2 = Marker M2 line
*
* @parm1 = Message flag
*          (>0000 = Display message "Copying block...")
*          (>ffff = Display message "Moving block....")
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = success (>ffff), no action (>0000)
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* For simplicity reasons we're assuming base 1 during copy
* (first line starts at 1 instead of 0). 
* Makes it easier when comparing values.
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
        dect  stack
        mov   @parm1,*stack         ; Push parm1
        clr   @outparm1             ; No action (>0000)
        ;------------------------------------------------------        
        ; Asserts
        ;------------------------------------------------------        
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   edb.block.copy.exit   ; Yes, exit early

        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edb.block.copy.exit   ; Yes, exit early

        c     @edb.block.m1,@edb.block.m2
                                    ; M1 > M2 ?
        jgt   edb.block.copy.exit   ; Yes, exit early
        ;------------------------------------------------------
        ; Get current line position in editor buffer
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @outparm1,tmp0        ; \ 
        inc   tmp0                  ; | Base 1 for current line in editor buffer
        mov   tmp0,@edb.block.var   ; / and store for later use
        ;------------------------------------------------------
        ; Show error and exit if M1 < current line < M2
        ;------------------------------------------------------
        c     @outparm1,tmp0        ; Current line < M1 ?
        jlt   !                     ; Yes, skip check

        c     @outparm1,tmp1        ; Current line > M2 ?
        jgt   !                     ; Yes, skip check

        bl    @cpym2m
              data txt.block.inside,tv.error.msg,53

        bl    @pane.errline.show    ; Show error line

        clr   @outparm1             ; No action (>0000)
        jmp   edb.block.copy.exit   ; Exit early
        ;------------------------------------------------------
        ; Display message Copy/Move
        ;------------------------------------------------------
!       mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.colorscheme.botline
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 

        bl    @hchar
              byte pane.botrow,0,32,55
              data eol              ; Remove markers and block shortcuts
        ;------------------------------------------------------
        ; Check message to display
        ;------------------------------------------------------
        mov   *stack,tmp0           ; \ Fetch @parm1 from stack, but don't pop!
                                    ; / @parm1 = >0000 ?
        jne   edb.block.copy.msg2   ; Yes, display "Moving" message

        bl    @putat
              byte pane.botrow,0
              data txt.block.copy   ; Display "Copying block...."     
        jmp   edb.block.copy.prep

edb.block.copy.msg2:
        bl    @putat
              byte pane.botrow,0
              data txt.block.move   ; Display "Moving block...."     
        ;------------------------------------------------------
        ; Prepare for copy 
        ;------------------------------------------------------
edb.block.copy.prep:        
        mov   @edb.block.m1,tmp0    ; M1
        mov   @edb.block.m2,tmp2    ; \
        s     tmp0,tmp2             ; | Loop counter = M2-M1
        inc   tmp2                  ; /

        mov   @edb.block.var,tmp1   ; Current line in editor buffer
        ;------------------------------------------------------
        ; Copy code block
        ;------------------------------------------------------
edb.block.copy.loop:
        mov   tmp1,@parm1           ; Target line for insert (current line)
        dec   @parm1                ; Base 0 offset for index required
        mov   @edb.lines,@parm2     ; Last line to reorganize         

        bl    @idx.entry.insert     ; Reorganize index, insert new line
                                    ; \ i  @parm1 = Line for insert
                                    ; / i  @parm2 = Last line to reorg
        ;------------------------------------------------------
        ; Increase M1-M2 block if target line before M1
        ;------------------------------------------------------
        c     tmp1,@edb.block.m1
        jgt   edb.block.copy.loop.docopy
        jeq   edb.block.copy.loop.docopy

        inc   @edb.block.m1         ; M1++
        inc   @edb.block.m2         ; M2++    
        inc   tmp0                  ; Increase source line number too!    
        ;------------------------------------------------------
        ; Copy line
        ;------------------------------------------------------
edb.block.copy.loop.docopy:
        mov   tmp0,@parm1           ; Source line for copy
        mov   tmp1,@parm2           ; Target line for copy

        bl    @edb.line.copy        ; Copy line 
                                    ; \ i  @parm1 = Source line in editor buffer
                                    ; / i  @parm2 = Target line in editor buffer
        ;------------------------------------------------------
        ; Housekeeping for next copy
        ;------------------------------------------------------
        inc   @edb.lines            ; One line added to editor buffer
        inc   tmp0                  ; Next source line
        inc   tmp1                  ; Next target line
        dec   tmp2                  ; Update ĺoop counter
        jgt   edb.block.copy.loop   ; Next line
        ;------------------------------------------------------
        ; Copy loop completed
        ;------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        seto  @fb.dirty             ; Frame buffer dirty
        seto  @outparm1             ; Copy completed
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.copy.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller       

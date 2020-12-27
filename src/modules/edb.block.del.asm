* FILE......: edb.block.del.asm
* Purpose...: Delete code block

***************************************************************
* edb.block.delete
* Delete code block
***************************************************************
*  bl   @edb.block.delete
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
edb.block.delete:
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
        jeq   edb.block.delete.exit ; Yes, exit early

        mov   @edb.block.m2,tmp1    ; M2 unset?
        jeq   edb.block.delete.exit ; Yes, exit early

        c     tmp0,tmp1             ; M1 > M2 
        jgt   edb.block.delete.exit ; Yes, exit early
        ;------------------------------------------------------
        ; Display "Deleting...."
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
              data txt.block.del    ; Display "Deleting block...."     
        ;------------------------------------------------------
        ; Prepare for delete
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0    ; Get M1
        dec   tmp0                  ; Base 0 offset        

        mov   @edb.block.m2,tmp1    ; Get M2
        dec   tmp1                  ; Base 0 offset        

        mov   tmp0,@parm1           ; Delete line on M1
        mov   @edb.lines,@parm2     ; Last line to reorganize         
        dec   @parm2                ; Base 0 offset

        mov   tmp1,tmp2             ; \ Setup loop counter
        s     tmp0,tmp2             ; /
        inc   tmp2                  ; Base 1         
        ;------------------------------------------------------
        ; Delete block
        ;------------------------------------------------------
edb.block.delete.loop:          
        bl    @idx.entry.delete     ; Reorganize index
                                    ; \ i  parm1 = Line in editor buffer
                                    ; / i  parm2 = Last line for index reorg

        dec   @edb.lines            ; \ One line removed from editor buffer
        dec   @parm2                ; /

        dec   tmp2
        jgt   edb.block.delete.loop ; Next line    

        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;------------------------------------------------------
        ; Set topline for framebuffer refresh
        ;------------------------------------------------------
        c     @fb.topline,@edb.lines
                                    ; Beyond editor buffer?
        jgt   !                     ; Yes, goto line 1

        mov   @fb.topline,@parm1    ; Set line to start with
        jmp   edb.block.delete.fb.refresh
!       clr   @parm1                ; Set line to start with
        ;------------------------------------------------------
        ; Refresh framebuffer and reset block markers
        ;------------------------------------------------------
edb.block.delete.fb.refresh:        
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        bl    @edb.block.reset      ; Reset block markers M1/M2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.delete.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11  
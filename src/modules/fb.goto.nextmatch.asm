* FILE......: fb.goto.nextmatch.asm
* Purpose...: Goto next search match


***************************************************************
* fb.goto.nextmatch
* Refresh frame buffer with next search match
* Align variables in editor buffer to match with that position.
****************************************************************
* bl @fb.goto.nextmatch
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fb.goto.nextmatch:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        abs   @edb.srch.matches      ; \ Exit early if no matches
        jeq   fb.goto.nextmatch.exit ; / 
        ;-------------------------------------------------------
        ; Goto next match
        ;-------------------------------------------------------
        mov   @edb.srch.matches,tmp0  ; \ 
        dec   tmp0                    ; | Already at last entry?
        c     @edb.srch.curmatch,tmp0 ; / 
        jlt   !                       ; Not yet, keep going
        jmp   fg.goto.nextmatch.first ; Yes, show first entry

!       inc   @edb.srch.curmatch      ; Next entry        
        jmp   fg.goto.nextmatch.goto  ; No, show next match
        ;-------------------------------------------------------
        ; First match
        ;-------------------------------------------------------
fg.goto.nextmatch.first:
        clr   @edb.srch.curmatch    ; 1st entry
        ;-------------------------------------------------------
        ; Goto line in editor buffer
        ;-------------------------------------------------------
fg.goto.nextmatch.goto:        
        mov   @edb.srch.curmatch,tmp0 
                                    ; Get index entry
        sla   tmp0,1                ; Make word offset
        mov   @edb.srch.idx.rtop(tmp0),@parm1
                                    ; Goto matched line
        clr   @parm2                ; No row offset in frame buffer

        bl    @fb.goto.toprow       ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

        srl   tmp0,1                ; Make byte offset again
        movb  @edb.srch.idx.ctop(tmp0),tmp0
                                    ; \ Get column from index
        srl   tmp0,8                ; | MSB to LSB        
        mov   tmp0,@fb.column       ; / Set column on 1st letter current match
        
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        seto  @fb.dirty             ; Trigger screen refresh
        seto  @fb.status.dirty      ; Trigger refresh of status line

        movb  @fb.column+1,@wyx+1   ; Set cursor on column
        ;-------------------------------------------------------
        ; Refresh colors if block marker M1 is set
        ;-------------------------------------------------------        
        mov   @edb.block.m1,tmp0    ; \ Block marker M1 set?
        ci    tmp0,>ffff            ; /
        jeq   fb.goto.nextmatch.exit
        seto  @fb.colorize          ; Color refresh required
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.goto.nextmatch.exit:
        mov   *stack+,tmp0          ; Pop tmp0    
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return                

* FILE......: tib.uncrunch.prg.asm
* Purpose...: Uncrunch tokenized program code

***************************************************************
* tib.uncrunch.prg
* Uncrunch tokenized program code
***************************************************************
* bl   @tibasic.uncrunch.prg
*--------------------------------------------------------------
* INPUT
* @parm1 = TI Basic session to uncrunch (1-5)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
*--------------------------------------------------------------
* Remarks
*
* Pointers:
* @tib.scrpad.ptr = Scratchpad address in SAMS page >ff
* @tib.stab.ptr   = SAMS page layout table of TI Basic session
*
* Pointers to tables in VRAM:
* @tib.lnt.top.ptr  = Top of line number table
* @tib.lnt.bot.ptr  = Bottom of line number table
* @tib.symt.top.ptr = Top of symbol table
* @tib.symt.bot.ptr = Bottom of symbol table
* @tib.strs.top.ptr = Top of string space
* @tib.strs.bot.ptr = Bottom of string space
*
* Variables
* @tib.var1  = TI Basic Session
* @tib.var2  = Saved VRAM address
* @tib.var3  = SAMS page ID mapped to VRAM address
* @tib.var4  = Line number in program
* @tib.var5  = Pointer to statement (VRAM)
* @tib.var6  = Current position (addr) in uncrunch area
* @tib.var7  = **free**
* @tib.var8  = Basic statement length in bytes
* @tib.var9  = Target line number in editor buffer
* @tib.lines = Number of lines in TI Basic program
*
* Register usage
* tmp0  = (Mapped) address of line number or statement in VDP
* tmp1  = Token to process
* tmp2  = Statement length
* tmp3  = Lines to process counter
*
* tmp0,tmp1,tmp2 also used as work registers at times
********|*****|*********************|**************************
tib.uncrunch.prg:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------
        ; Exit early if no TI Basic program
        ;------------------------------------------------------
        c     @tib.lnt.top.ptr,@tib.lnt.bot.ptr
                                    ; Line number table is empty?
        jne   !                     ; No, keep on processing
        b     @tib.uncrunch.prg.exit
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
!       mov   @tib.lnt.top.ptr,tmp0 ; Get top of line number table
        ai    tmp0,-3               ; One time adjustment
        mov   tmp0,@tib.var2        ; Save VRAM address

        clr   @tib.var9             ; 1st line in editor buffer
        mov   @tib.lines,tmp3       ; Set lines to process counter
        ;------------------------------------------------------
        ; Loop over program listing
        ;------------------------------------------------------
tib.uncrunch.prg.lnt.loop:
        mov   @tib.var2,tmp0        ; Get VRAM address

        bl    @_v2sams              ; Get SAMS page mapped to VRAM address
                                    ; \ i  tmp0 = VRAM address
                                    ; |
                                    ; | o  @tib.var3 = SAMS page ID mapped to
                                    ; |    VRAM address.
                                    ; /
        ;------------------------------------------------------
        ; 1. Get line number
        ;------------------------------------------------------
        ori   tmp0,>f000            ; \ Use mapped address in >f000->ffff window
                                    ; | instead of VRAM address.
                                    ; |
                                    ; / Example: >f7b3 maps to >37b3.

        movb  *tmp0+,@tib.var4      ; Line number MSB
        movb  *tmp0+,@tib.var4+1    ; Line number LSB
        ;------------------------------------------------------
        ; 1a. Get Pointer to statement (VRAM)
        ;------------------------------------------------------
        movb  *tmp0+,@tib.var5      ; Pointer to statement MSB
        movb  *tmp0+,@tib.var5+1    ; Pointer to statement LSB

        a     @w$0004,@tib.var2     ; Sync VRAM address with mapped address in
                                    ; tmp0 for steps 1 and 1a.
        ;------------------------------------------------------
        ; 2. Put line number in uncrunch area
        ;------------------------------------------------------
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3

        bl    @mknum                ; Convert unsigned number to string
              data tib.var4         ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        clr   @fb.uncrunch.area     ; \
        clr   @fb.uncrunch.area+2   ; | Clear length-byte and line number space
        clr   @fb.uncrunch.area+4   ; /

        bl    @at
              byte pane.botrow,28   ; Position cursor

        bl    @trimnum              ; Trim line number and move to uncrunch area
              data rambuf           ; \ i  p1 = Source
              data fb.uncrunch.area ; | i  p2 = Destination
              data 32               ; / i  p3 = Padding character to scan

        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; 2a. Put space character following line number
        ;------------------------------------------------------

        ; Temporary re-use of tmp0 as work register for operations.

        movb  @fb.uncrunch.area,tmp0
                                    ; Get length of trimmed number into MSB
        srl   tmp0,8                ; Move to LSB
        ai    tmp0,fb.uncrunch.area+1
                                    ; Add base address and length byte

        li    tmp1,>2000            ; \ Put white space character (ASCII 32)
        movb  tmp1,*tmp0+           ; / following line number.
        mov   tmp0,@tib.var6        ; Save position in uncrunch area

        ab    @w$0100,@fb.uncrunch.area
                                    ; Increase length-byte in uncrunch area
        ;------------------------------------------------------
        ; 3. Prepare for uncrunching program statement
        ;------------------------------------------------------
        mov   @tib.var5,tmp0        ; Get pointer to statement
        dec   tmp0                  ; Goto statement length prefix

        bl    @_v2sams              ; Get SAMS page mapped to VRAM address
                                    ; \ i  tmp0 = VRAM address
                                    ; |
                                    ; | o  @tib.var3 = SAMS page ID mapped to
                                    ; |    VRAM address.
                                    ; /

        ori   tmp0,>f000            ; \ Use mapped address in >f000->ffff window
                                    ; | instead of VRAM address.
                                    ; |
                                    ; / Example: >f7b3 maps to >37b3.

        movb  *tmp0+,tmp1           ; \ Get statement length in bytes
        srl   tmp1,8                ; / MSB to LSB

        mov   tmp1,@tib.var8        ; Save statement length
        mov   tmp1,tmp2             ; Set statement length in work register
        ;------------------------------------------------------
        ; 4. Uncrunch program statement to uncrunch area
        ;------------------------------------------------------
tib.uncrunch.prg.statement.loop:
        movb  *tmp0,tmp1            ; Get token into MSB
        srl   tmp1,8                ; Move token to LSB
        jeq   tib.uncrnch.prg.copy.statement
                                    ; Skip to (5) if termination token >00

        ci    tmp1,>80              ; Is a valid token?
        jlt   tib.uncrunch.prg.statement.loop.nontoken
                                    ; Skip decode for non-token

        mov   tmp0,@parm2           ; Mapped position in crunched statement
        mov   tmp1,@parm1           ; Token to process

        bl    @tib.uncrunch.token   ; Decode statement token to uncrunch area
                                    ; \ i  @parm1 = Token to process
                                    ; |
                                    ; | i  @parm2 = Mapped position (addr) in
                                    ; |    crunched statement.
                                    ; |
                                    ; | o  @outparm1 = New position (addr) in
                                    ; |    crunched statement.
                                    ; |
                                    ; | o  @outparm2 = Bytes processed in
                                    ; |    crunched statement.
                                    ; |
                                    ; | o  @tib.var6 = Position (addr) in
                                    ; /    uncrunch area.

        mov   @outparm1,tmp0        ; Forward in crunched statement

        s     @outparm2,tmp2        ; Update statement length
        jgt   tib.uncrunch.prg.statement.loop
                                    ; Process next token(s) unless done

        jeq   tib.uncrnch.prg.copy.statement
                                    ; Continue with (5)

        jlt   tib.uncrnch.prg.statement.loop.panic
                                    ; Assert
        ;------------------------------------------------------
        ; 4a. Non-token without decode
        ;------------------------------------------------------
tib.uncrunch.prg.statement.loop.nontoken:
        mov   @tib.var6,tmp1        ; Get position (addr) in uncrunch area
        movb  *tmp0+,*tmp1+         ; Copy non-token to uncrunch area

        mov   tmp1,@tib.var6        ; Save position in uncrunch area
        ab    @w$0100,@fb.uncrunch.area
                                    ; Increase length-byte in uncrunch area

        dec   tmp2                  ; update statement length
        jlt   tib.uncrnch.prg.statement.loop.panic
                                    ; Assert

        jgt   tib.uncrunch.prg.statement.loop
                                    ; Process next token(s) unless done
        jeq   tib.uncrnch.prg.copy.statement
        ;------------------------------------------------------
        ; CPU crash
        ;------------------------------------------------------
tib.uncrnch.prg.statement.loop.panic:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; 5. Copy uncrunched statement to editor buffer
        ;------------------------------------------------------
tib.uncrnch.prg.copy.statement:
        mov   @tib.var9,@parm1      ; Get editor buffer line number to store
                                    ; statement in.

        bl    @tib.uncrunch.line.pack
                                    ; Pack uncrunched line to editor buffer
                                    ; \ i  @fb.uncrunch.area = Pointer to
                                    ; |    buffer having uncrushed statement
                                    ; |
                                    ; | i  @parm1 = Line number in editor buffer
                                    ; /

        inc   @tib.var9             ; Next line
        inc   @edb.lines            ; Update Line counter
        ;------------------------------------------------------
        ; 6. Next entry in line number table
        ;------------------------------------------------------
        dec   tmp3                  ; Last line processed?
        jeq   tib.uncrunch.prg.done ; yes, prepare for exit

        s     @w$0008,@tib.var2     ; Next entry in VRAM line number table
        jmp   tib.uncrunch.prg.lnt.loop
        ;------------------------------------------------------
        ; 7. Finished processing program
        ;------------------------------------------------------
tib.uncrunch.prg.done:
        seto  @fb.dirty             ; Refresh screen buffer
        seto  @edb.dirty            ; Update screen with editor buffer when done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.prg.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

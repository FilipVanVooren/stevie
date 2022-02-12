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
* tmp0
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
* (Temporary) variables
* @tib.var1  = Copy of @parm1
* @tib.var2  = Address of SAMS page layout table entry mapped to VRAM address
* @tib.var3  = SAMS page ID mapped to VRAM address
* @tib.var4  = Line number
* @tib.var5  = Pointer to statement
* @tib.lines = Number of lines in TI Basic program
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
        jeq   tib.uncrunch.prg.exit ; Line number table is empty
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @tib.lnt.top.ptr,tmp0 ; Get top of line number table

        bl    @_v2sams              ; Get SAMS page mapped to VRAM address
                                    ; \ i  tmp0      = VRAM address
                                    ; | o  @tib.var2 = Address SAMS page layout
                                    ; |    table entry mapped to VRAM address.
                                    ; | o  @tib.var3 = SAMS page ID mapped to
                                    ; /    VRAM address.

        ori   tmp0,>f000            ; \ Use mapped address in >f000->ffff region
                                    ; | instead of VRAM address.
                                    ; / Example: >f7b3 maps to >37b3.

        ai    tmp0,-3               ; What is this?
        ;------------------------------------------------------
        ; Get number of lines in program
        ;------------------------------------------------------
        mov   @tib.lines,tmp2       ; Set loop counter
        clr   tmp3                  ; 1st line in editor buffer
        ;------------------------------------------------------
        ; (1) Loop over line number table
        ;------------------------------------------------------
tib.uncrunch.prg.lnt.loop:
        ;------------------------------------------------------
        ; Get line number
        ;------------------------------------------------------
        movb  *tmp0+,@tib.var4      ; Line number MSB
        movb  *tmp0+,@tib.var4+1    ; Line number LSB
        ;------------------------------------------------------
        ; Get Pointer to statement
        ;------------------------------------------------------
        movb  *tmp0+,@tib.var5      ; Pointer to statement MSB
        movb  *tmp0,@tib.var5+1     ; Pointer to statement LSB
        ;------------------------------------------------------
        ; Convert line number to string
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
              data  tib.var4,rambuf
              byte  48              ; ASCII offset
              byte  32              ; Padding character

        clr   @fb.uncrunch.area
        clr   @fb.uncrunch.area+2
        clr   @fb.uncrunch.area+4

        bl    @trimnum              ; Trim number in frame buffer uncrunch area
              data  rambuf,fb.uncrunch.area,32


        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; Uncrunch program statement
        ;------------------------------------------------------
        mov   tmp3,@parm1           ; Get line number for editor buffer

        bl    @tib.uncrunch.line.pack
                                    ; Pack uncrunched line to editor buffer
                                    ; \ i  @fb.uncrunch.area = Pointer to
                                    ; |    buffer having uncrushed statement
                                    ; |
                                    ; | i  @parm1 = Line number in editor buffer
                                    ; /
        ;------------------------------------------------------
        ; Next entry in line number table
        ;------------------------------------------------------
        dec   tmp2                  ; Last line processed?
        jeq   tib.uncrunch.prg.exit ; yes, exit

        ai    tmp0,-7

        ; Need to deal with split line-number-table entries.
        ; Need something like an underflow memory area where a split LNT entry
        ; is copied to. This area needs to be checked and filled accordingly.
        ;
        ;     if tmp0 < f000 then
        ;          copy split LNT entry to underflow RAM area.
        ;          tmp0 = underflow RAM Area
        ;          process next entry
        ;          set tmp0 back to regular LNT
        ;
        ; Can also happen for the 1st entry in LNT. So move check to subroutine
        ; for reuse,

        inc   tmp3                  ; Next line
        inc   @edb.lines            ; Line counter

        jmp   tib.uncrunch.prg.lnt.loop


tib.uncrunch.prg.done:
        ;------------------------------------------------------
        ; Finished processing program
        ;------------------------------------------------------
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

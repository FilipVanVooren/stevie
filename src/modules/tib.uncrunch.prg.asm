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
* @tib.var1 = Copy @parm1
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
* Temporary variables
* @tib.var1 = Copy of @parm1
* @tib.var2 = Address of SAMS page layout table entry mapped to VRAM address
* @tib.var3 = SAMS page ID mapped to VRAM address
********|*****|*********************|**************************
tib.uncrunch.prg:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
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

        ai    tmp0,-3
        ;------------------------------------------------------
        ; Calculate number of lines in program
        ;------------------------------------------------------
        li    tmp2,100              ; Hard coded for now
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

        bl    @mknum                ; Convert unsigned number to string
              data  tib.var4,rambuf
              byte  48              ; ASCII offset
              byte  32              ; Padding character

        bl    @trimnum              ; Trim number to the left
              data  rambuf,rambuf+5,32

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; Next line in line number table
        ;------------------------------------------------------
        ai    tmp0,-7
        dec   tmp2
        jgt   tib.uncrunch.prg.lnt.loop

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.prg.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

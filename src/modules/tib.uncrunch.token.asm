* FILE......: tib.uncrunch.token.asm
* Purpose...: Decode token to uncrunch area


***************************************************************
* tib.uncrunch.token
* Decode token to uncrunch area
***************************************************************
* bl   @tib.uncrunch.token
*--------------------------------------------------------------
* INPUT
* @parm1     = token to process
* @tib.var6  = Byte offset in uncrunch area
* @tib.var7  = Statement length in bytes
*
* OUTPUT
* @outparm1  = Number of bytes processed
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
*
* Variables
* @tib.var1  = Copy of @parm1
* @tib.var2  = Address of SAMS page layout table entry mapped to VRAM address
* @tib.var3  = SAMS page ID mapped to VRAM address
* @tib.var4  = Line number
* @tib.var5  = Pointer to statement (VRAM)
* @tib.var6  = Byte offset in uncrunch area
* @tib.var7  = Statement length in bytes
* @tib.lines = Number of lines in TI Basic program
********|*****|*********************|**************************
tib.uncrunch.token:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Decode token
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get token

        ai    tmp0,->0080           ; Token range >80 - >ff
        sla   tmp0,1                ; Make it a word offset

        mov   @tib.tokenindex(tmp0),tmp1
                                    ; Get pointer to token definition

        ; 1. Get length of token text
        ; 2. Copy token text to uncrunch area
        ; 3. Adjust position in uncrunch area
        ; 4. Do token specific stuff, e.g. quoted string
        ; 6. Set outparm1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.token.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

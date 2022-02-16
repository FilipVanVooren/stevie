* FILE......: tib.uncrunch.token.asm
* Purpose...: Decode token to uncrunch area


***************************************************************
* tib.uncrunch.token
* Decode token to uncrunch area
***************************************************************
* bl   @tib.uncrunch.token
*--------------------------------------------------------------
* INPUT
* @parm1 = Token to process
* @parm2 = Position (addr) in crunched statement
*
* OUTPUT
* @outparm1  = New position (addr) in crunched statement
* @outparm2  = Token length
* @outparm3  = Length of decoded keyword
* @tib.var6  = Current position (addr) in uncrunch area
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
*
* Variables
* @tib.var1  = TI Basic Session
* @tib.var2  = Address of SAMS page layout table entry mapped to VRAM address
* @tib.var3  = SAMS page ID mapped to VRAM address
* @tib.var4  = Line number
* @tib.var5  = Pointer to statement (VRAM)
* @tib.var6  = Current position (addr) in uncrunch area
* @tib.var7  = Current position (addr) in line number table
* @tib.var8  = Statement length in bytes
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
        ; Initialisation
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get token
        mov   @parm2,@outparm1      ; Position (addr) in crunched statement
        clr   @outparm2             ; Token length
        clr   @outparm3             ; Bytes processed
        ;------------------------------------------------------
        ; 1. Decide how to process token
        ;------------------------------------------------------
        ci    tmp0,>c7              ; Quoted string?
        jeq   tib.uncrunch.token.quoted

        ci    tmp0,>c8              ; Unquoted string?
        jeq   tib.uncrunch.token.unquoted

        ci    tmp0,>c9              ; line number?
        jeq   tib.uncrunch.token.linenum
        ;------------------------------------------------------
        ; 2. Decode token range >80 - >ff in lookup table
        ;------------------------------------------------------
tib.uncrunch.token.lookup:
        ai    tmp0,->0080           ; Token range >80 - >ff
        sla   tmp0,1                ; Make it a word offset
        mov   @tib.tokenindex(tmp0),tmp0
                                    ; Get pointer to token definition
        inc   tmp0                  ; Skip token identifier

        movb  *tmp0+,tmp2           ; Get length of decoded keyword
        srl   tmp2,8                ; MSB to LSB

        mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area

        mov   tmp2,@outparm3        ; Set number of bytes processed
        a     tmp2,@tib.var6        ; Set current pos (addr) in uncrunch area

        bl    @xpym2m               ; Copy keyword to uncrunch area
                                    ; i  tmp0 = Source address
                                    ; i  tmp1 = Destination address
                                    ; i  tmp2 = Number of bytes to copy

        inc   @outparm1             ; New pos (addr) in crunched statement
        inc   @outparm2             ; Token length = 1
        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 3. Special handling >c7:  Decode quoted string
        ;------------------------------------------------------
tib.uncrunch.token.quoted:
        li    tmp0,>2022            ; ASCII WS in MSB, " in LSB
        mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
        mov   tmp0,*tmp1+           ; Write WS and 1st double quote


        swpb  tmp0
        movb  tmp0,*tmp1+           ; Write 2nd double quote
        mov   tmp1,@tib.var6        ; Set current pos (addr) in uncrunch area

        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 4. Special handling >c8: Decode unquoted string
        ;------------------------------------------------------
tib.uncrunch.token.unquoted:
        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 5. Special handling >c9: Decode line number
        ;------------------------------------------------------
tib.uncrunch.token.linenum:
        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 6. Update uncrunched statement length
        ;------------------------------------------------------
tib.uncrunch.token.setlen:
        mov   @outparm2,tmp0        ; Get length processed
        sla   tmp0,8                ; LSB to MSB
        ab    tmp0,@fb.uncrunch.area
                                    ; Update length byte
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.token.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

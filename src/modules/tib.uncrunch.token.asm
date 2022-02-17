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
* @outparm2  = Bytes processed in crunched statement
* @tib.var6  = Current position (addr) in uncrunch area
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
* Remarks
* For TI Basic statement decode see:
* https://www.unige.ch/medecine/nouspikel/ti99/basic.htm#statements
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
* @tib.var9  = Temporary use
* @tib.var10 = Temporary use
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
        clr   @outparm2             ; Bytes processed in crunched statement
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
        a     tmp2,@tib.var6        ; Set current pos (addr) in uncrunch area

        mov   tmp2, @outparm2       ; Bytes processed in crunched statement

        bl    @xpym2m               ; Copy keyword to uncrunch area
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Destination address
                                    ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; 2a. Update variables related to crunched statement
        ;------------------------------------------------------
        inc   @outparm1             ; New pos (addr) in crunched statement
        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 3. Special handling >c7:  Decode quoted string
        ;------------------------------------------------------
tib.uncrunch.token.quoted:
        li    tmp0,>2022            ; ASCII blank in MSB, " in LSB
        mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area

        movb  tmp0,*tmp1+           ; Write blank
        swpb  tmp0
        movb  tmp0,*tmp1+           ; Write 1st double quote

        mov   @parm2,tmp0           ; Get position (addr) in crunched statement
        inc   tmp0                  ; Skip token
        movb  *tmp0+,tmp2           ; Get length byte following >C7 token
        srl   tmp2,8                ; MSB to LSB

        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        bl    @xpym2m               ; Copy string from crunched statement to
                                    ; uncrunch area.
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Destination address
                                    ; / i  tmp2 = Number of bytes to copy

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0

        li    tmp0,>2200            ; " in MSB
        a     tmp2,tmp1             ; Forward in uncrunch area
        movb  tmp0,*tmp1+           ; Write 2nd double quote
        mov   tmp1,@tib.var6        ; Set current pos (addr) in uncrunch area
        ;------------------------------------------------------
        ; 3a. Update variables related to crunched statement
        ;------------------------------------------------------
        mov   tmp2,tmp0             ; Amount of bytes copied to uncrunch area
        ai    tmp0,3                ; Including blank and double quotes
        mov   tmp0,@outparm2        ; Bytes processed in crunched statement

        a     @parm2,tmp0           ; Add original position in crunched staement
        mov   tmp0,@outparm1        ; New pos (addr) in crunched statement
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
        li    tmp0,>2000            ; ASCII blank in MSB
        mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
        movb  tmp0,*tmp1+           ; Write blank
        inc   @tib.var6             ; Set current pos (addr) in uncrunch area

        mov   @parm2,tmp0           ; Get position (addr) in crunched statement
        inc   tmp0                  ; Skip token

        movb  *tmp0+,tmp1           ; Get MSB of line number into MSB
        srl   tmp1,8                ; MSB to LSB
        movb  *tmp0+,tmp1           ; Get LSB of line number into MSB
        swpb  tmp1                  ; Put it in the right order
        mov   tmp1,@tib.var9        ; Put line number word in temporary variable
        ;------------------------------------------------------
        ; 5a. Convert line number (word) to string
        ;------------------------------------------------------
        bl    @mknum                ; Convert unsigned number to string
              data  tib.var9        ; \ i  p1    = Source
              data  rambuf          ; | i  p2    = Destination
              byte  48              ; | i  p3MSB = ASCII offset
              byte  32              ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number, remove leading spaces
              data  rambuf          ; \ i  p1 = Source
              data  rambuf+5        ; | i  p2 = Destination
              data  32              ; / i  p3 = Padding character to look for
        ;------------------------------------------------------
        ; 5b. Copy decoded line number to uncrunch area
        ;------------------------------------------------------
        li    tmp0,rambuf+6         ; Start of line number string
        mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area

        movb  @rambuf+5,tmp2        ; Get string length
        srl   tmp2,8                ; MSB to LSB

        mov   tmp2,@outparm2        ; \ Set bytes processed
        inc   @outparm2             ; / Include leading blank character
        a     @outparm2,@tib.var6   ; Set current pos (addr) in uncrunch area

        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        bl    @xpym2m               ; Copy string from crunched statement to
                                    ; uncrunch area.
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Destination address
                                    ; / i  tmp2 = Number of bytes to copy

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; 5c. Update variables related to crunched statement
        ;------------------------------------------------------
        inct  @outparm1             ; New pos (addr) in crunched statement
        jmp   tib.uncrunch.token.setlen
        ;------------------------------------------------------
        ; 6. Update uncrunched statement length byte
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

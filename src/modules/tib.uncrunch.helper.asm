* FILE......: tib.uncrunch.helper asm
* Purpose...: Helper functions used for uncrunching


***************************************************************
* _v2sams
* Convert VDP address to SAMS page equivalent and get SAMS page
***************************************************************
* bl   _v2sams
*--------------------------------------------------------------
* INPUT
* tmp0 = VRAM address in range >0000 - >3fff
*
* OUTPUT
* @tib.var3 = SAMS page ID mapped to VRAM address
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
*--------------------------------------------------------------
* Remarks
* Converts the VDP address to index into SAMS page layout table
* mem.sams.layout.basic(X) and get SAMS page.
*
* Index offset in SAMS page layout table:
* VRAM 0000-0fff = 6   \
* VRAM 1000-1fff = 8   |  Offset of slots with SAMS pages having
* VRAM 2000-2fff = 10  |  the 16K VDP dump of TI basic session.
* VRAM 3000-3fff = 12  /
********|*****|*********************|**************************
_v2sams:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Calculate index in SAMS page table
        ;------------------------------------------------------
        andi  tmp0,>f000            ; Only keep high-nibble of MSB

        srl   tmp0,11               ; Move high-nibble to LSB and multiply by 2
        a     @tib.stab.ptr,tmp0    ; Add pointer base address

        ;
        ; In the SAMS page layout table of the TI Basic session, the 16K VDP
        ; memory dump page starts at the 4th word. So need to add fixed offset.
        ;
        ai    tmp0,6                ; Add fixed offset
        mov   *tmp0,tmp0            ; Get SAMS page number
        ;------------------------------------------------------
        ; Check if SAMS page needs to be switched
        ;------------------------------------------------------
        c     tmp0,@tib.var3        ; SAMS page has changed?
        jeq   _v2sams.exit          ; No, exit early

        mov   tmp0,@tib.var3        ; Set new SAMS page
        srl   tmp0,8                ; MSB to LSB
        li    tmp1,>f000            ; Memory address to map to

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_v2sams.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

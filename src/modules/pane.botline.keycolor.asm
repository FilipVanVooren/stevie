* FILE......: pane.botline.keycolor.asm
* Purpose...: Colorize key markers on bottom line using cmdb.keycolors array

***************************************************************
* pane.botline.keycolor
* Colorize key markers in bottom line using pointer at @cmdb.keycolors
***************************************************************
* bl  @pane.botline.keycolor
*--------------------------------------------------------------
* INPUT
* @cmdb.keycolors = Pointer to byte array with marker positions
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0 = pointer to keycolors array
* tmp1 = Color combination bottom bar (QR) / Byte array byte
* tmp2 = Repeat count
* tmp3 = Color combination for key marker (ST)
* tmp4 = Copy of tmp1
*--------------------------------------------------------------
* Notes
* 
********|*****|*********************|**************************
pane.botline.keycolor:
        .pushregs 4                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)
        ;------------------------------------------------------
        ; Get pointer to key color array
        ;------------------------------------------------------
        mov   @cmdb.keycolors,tmp0         ; tmp0 = pointer to byte array (X,count,...,>ff)
        jeq   pane.botline.keycolor.prexit ; Exit early on null pointer
        ;------------------------------------------------------
        ; Ensure we have current color scheme data available
        ; This fills @outparm1..@outparm5 where outparm5 contains QRST
        ;------------------------------------------------------
        bl    @pane.colorscheme.index 
                                    ; \ Compose final TAT bytes from QRST: 
                                    ; | Normal Colors: FG=Q (high nibble of high byte), BG=R (low nibble of high byte)
                                    ; / Key Colorso: FG=S (high nibble of low byte), BG=T (low nibble of low byte)
        
        mov   @outparm5,tmp1        ; tmp1 = QRST
        srl   tmp1,8                ; QR to low byte
        ;------------------------------------------------------
        ; Fill RAMBUF with normal bottom-line color combination
        ;------------------------------------------------------
        li    tmp0,rambuf           ; Address of RAM work buffer
        mov   tmp4,tmp1             ; Fill byte = default bottom-line color
        li    tmp2,80               ; Bottom line is 80 chars wide
        bl    @xfilm                ; Fill RAM buffer with normal color
                                    ; i \  tmp0 = RAM start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;------------------------------------------------------
        ; Prepare for settings key colors
        ;------------------------------------------------------
        mov   @cmdb.keycolors,tmp0  ; Reset pointer to keycolor list
        mov   @outparm5,tmp3        ; tmp3 = QRST
        sla   tmp3,8                ; Move ST to high byte
        ;------------------------------------------------------
        ; Loop through array of (X,repeat) pairs
        ; Each entry: X pos (byte), repeat count (byte). Terminator: >ff
        ;------------------------------------------------------
pane.botline.keycolor.loop:
        movb  *tmp0+,tmp1           ; Read X position (byte)
        srl   tmp1,8                ; Move to LSB
        ci    tmp1,>ff              ; Check sentinel
        jeq   pane.botline.keycolor.dump
        mov   tmp1,tmp4             ; Backup x-position
        movb  *tmp0+,tmp2           ; Read repeat count (byte)
        srl   tmp2,8                ; Move to LSB (repeat count)
        ;------------------------------------------------------
        ; Apply custom key color to RAMBUF
        ;------------------------------------------------------
pane.botline.keycolor.apply:
        movb  tmp3,@rambuf(tmp4)    ; Set color byte in work buffer
        inc   tmp4                  ; Next column
        dec   tmp2                  ; Repeat count--
        jne   pane.botline.keycolor.apply
        jmp   pane.botline.keycolor.loop
        ;------------------------------------------------------
        ; Copy the processed 80-char RAM buffer to VDP TAT area
        ;------------------------------------------------------
pane.botline.keycolor.dump:
        bl    @cpym2v               ; \ Copy 80-byte RAM buffer to TAT
              data vdp.botrow.tat   ; | i  p1 = destination VDP address
              data rambuf           ; | i  p2 = source RAM address
              data 80               ; / i  p3 = number of bytes to copy
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
pane.botline.keycolor.prexit:
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.keycolor.exit:
        .popregs 4                 ; Pop registers and return to caller

* FILE......: pane.cmdb.statlines.asm
* Purpose...: Stevie Editor - Command Buffer status lines

***************************************************************
* pane.cmdb.statlines
* Setup CMDB status lines to be included in multiple CMDB panes
***************************************************************
* bl  @pane.cmdb.statlines
*--------------------------------------------------------------
* INPUT
* @tv.devpath      = Pointer to string with device path
* @tv.sams.maxpage = Number of SAMS pages in system
* @tv.sams.hipage  = Highest page in use
*--------------------------------------------------------------
* OUTPUT
* @ram.msg1 = SAMS free status line
* @ram.msg2 = Device path status line
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.cmdb.statlines:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Initialsiation
        ;-------------------------------------------------------
        bl    @film
              data ram.msg1,0,160   ; Clear both status lines

        li    tmp0,>4c00            ; MSB = 76
        movb  tmp0,@ram.msg1        ; Set line 1 length 
        movb  tmp0,@ram.msg2        ; Set line 2 length 

        li    tmp0,ram.msg1
        mov   tmp0,@cmdb.panhint    ; Show status line 1
        li    tmp0,ram.msg2
        mov   tmp0,@cmdb.panhint2   ; Show status line 2

        li    tmp0,txt.keys.menu
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor

        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @hchar
              byte 0,0,32,80
              data eol              ; Remove leftover junk from previous dialog

        mov   *stack+,@wyx          ; Restore cursor position
        ;-------------------------------------------------------
        ; Print SAMS pages free
        ;-------------------------------------------------------
        li    tmp0,tv.sams.maxpage  ; Calculate number of free pages
        s     @edb.sams.hipage,tmp0 ;

        mov   tmp0,@rambuf          ; Number of pages free

        bl    @cpym2m
              data txt.hint.sams+1,ram.msg1+1,14

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data rambuf           ; \ i  p1    = Source
              data rambuf+2         ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf+2,ram.msg1+6,32

        li    tmp0,>2000            ; \ MSB = ASCII 32 (hex 20) space char
        movb  tmp0,@ram.msg1 + 6    ; | Overwrite length-byte prefix in 
                                    ; / number with colon
        ;-------------------------------------------------------
        ; Show path
        ;-------------------------------------------------------
        movb  @tv.devpath,tmp0         ; Path set?
        srl   tmp0,8                   ; Check length byte
        jeq   pane.cmdb.statlines.exit ; Nothing set, skip

        bl    @cpym2m               ; Copy 'SAMS' text
              data txt.hint.path+1,ram.msg2+1,5

        bl    @cpym2m               ; Copy device path
              data tv.devpath,ram.msg2+6,60

        li    tmp0,>2000            ; \ Overwrite length byte with whitespace
        movb  tmp0,@ram.msg2+6      ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.cmdb.statlines.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

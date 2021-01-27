* FILE......: dialog.about.asm
* Purpose...: Stevie Editor - About dialog

*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
dialog.about:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.about
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        bl    @dialog.about.content ; display content in modal dialog

        li    tmp0,txt.head.about
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.about
        mov   tmp0,@cmdb.paninfo    ; Info line

        li    tmp0,txt.hint.about
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.about.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
               





***************************************************************
* dialog.about.content
* Show content in modal dialog
***************************************************************
* bl  @dialog.about.content
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
dialog.about.content:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
         
        clr   tmp0                  ; VDP target address (1nd row on screen!)
        li    tmp1,32               ; Character to fill

        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy
        ;------------------------------------------------------
        ; Show About dialog
        ;------------------------------------------------------
        bl    @hchar
              byte 0,22,16,1
              byte 0,57,16,1
              data EOL

        bl    @putat      
              byte   0,1
              data   txt.about.program

        bl    @putat      
              byte   0,26
              data   txt.about.author

        bl    @putat      
              byte   0,59
              data   txt.about.build
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.about.content.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2                
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return


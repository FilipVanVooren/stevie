* FILE......: dialog.about.asm
* Purpose...: Stevie Editor - About dialog

*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
edkey.action.about:
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.about
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        bl    @dialog.about.content ; display content in modal dialog

        li    tmp0,txt.head.about
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.about
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane                





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

        mov   @wyx,@fb.yxsave       ; Save cursor
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
        bl    @pane.cursor.hide     ; Hide cursor

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
!       bl    @hchar
              byte 2,20,3,40
              byte 12,20,3,40          
              data EOL

        bl    @putat      
              byte   4,33
              data   txt.about.program
        bl    @putat      
              byte   6,22
              data   txt.about.purpose
        bl    @putat      
              byte   7,25
              data   txt.about.author
        bl    @putat      
              byte   9,26
              data   txt.about.website
        bl    @putat      
              byte   11,29
              data   txt.about.build

        bl    @putat      
              byte   14,3
              data   txt.about.msg1
        bl    @putat      
              byte   15,3
              data   txt.about.msg2
        bl    @putat      
              byte   16,3
              data   txt.about.msg3
        bl    @putat      
              byte   14,50
              data   txt.about.msg4
        bl    @putat      
              byte   15,50
              data   txt.about.msg5
        bl    @putat      
              byte   16,50
              data   txt.about.msg6

        bl    @putat      
              byte   18,10
              data   txt.about.msg7
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_dialog.about.content.exit:
        mov   @fb.yxsave,@wyx
        mov   *stack+,tmp2          ; Pop tmp2                
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return


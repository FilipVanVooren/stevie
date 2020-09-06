* FILE......: pane.welcome.asm
* Purpose...: Stevie Editor - Welcome pane

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Welcome pane
*//////////////////////////////////////////////////////////////

***************************************************************
* dialog.welcome
* Show welcome / about dialog
***************************************************************
* bl  @dialog.welcome
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
dialog.welcome:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        mov   @wyx,@fb.yxsave       ; Save cursor

        mov   @tv.pane.welcome,tmp0 ; Get welcome pane mode
        ci    tmp0,>ffff            ; Startup phase?
        jeq   !                     ; Yes, then do not erase screen
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
        ; Show Welcome dialog
        ;------------------------------------------------------
!       bl    @hchar
              byte 2,20,3,40
              byte 12,20,3,40          
              data EOL

        bl    @putat      
              byte   4,33
              data   txt.wp.program
        bl    @putat      
              byte   6,22
              data   txt.wp.purpose
        bl    @putat      
              byte   7,25
              data   txt.wp.author
        bl    @putat      
              byte   9,26
              data   txt.wp.website
        bl    @putat      
              byte   10,30
              data   txt.wp.build

        bl    @putat      
              byte   14,3
              data   txt.wp.msg1
        bl    @putat      
              byte   15,3
              data   txt.wp.msg2
        bl    @putat      
              byte   16,3
              data   txt.wp.msg3
        bl    @putat      
              byte   14,50
              data   txt.wp.msg4
        bl    @putat      
              byte   15,50
              data   txt.wp.msg5
        bl    @putat      
              byte   16,50
              data   txt.wp.msg6

        bl    @putat      
              byte   18,10
              data   txt.wp.msg7

        bl    @putat      
              byte   20,22
              data   txt.wp.msg8
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.welcome.exit:
        mov   @fb.yxsave,@wyx
        mov   *stack+,tmp2          ; Pop tmp2                
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
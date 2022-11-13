* FILE......: pane.welcome.asm
* Purpose...: Show welcome message

***************************************************************
* pane.welcome.oneshot
* Show welcome message
***************************************************************
* bl @pane.welcome.oneshot
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.welcome.oneshot:
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
        ;------------------------------------------------------
        ; Show welcome message
        ;------------------------------------------------------             

     .ifeq full_f18a_support,1

        bl    @at                   ; Set cursor position
              byte 12,17            ; Y=12, X=17

    .else

        bl    @at                   ; Set cursor position
              byte 8,17             ; Y=8, X=17

    .endif

        li    tmp1,txt.welcome
        li    tmp2,5                ; Display 5 rows

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

        clr   @tv.task.oneshot      ; Reset oneshot task  
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
pane.welcome.oneshot.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

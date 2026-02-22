* FILE......: tv.asm
* Purpose...: Initialize editor

***************************************************************
* tv.init
* Initialize editor settings
***************************************************************
* bl @tv.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
***************************************************************
tv.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,1                ; \ Set default color scheme
        mov   tmp0,@tv.colorscheme  ; /

        clr   @tv.task.oneshot      ; Reset pointer to oneshot task
        soc   @wbit10,config        ; Assume ALPHA LOCK is down

        li    tmp0,fj.bottom
        mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack

        clr   @tv.specmsg.ptr       ; No special message        
        ;------------------------------------------------------
        ; Set defaults
        ;------------------------------------------------------
        bl    @cpym2m
              data def.printer.fname,tv.printer.fname,7

        bl    @cpym2m
              data def.clip.fname.a,tv.clip.fname,10

        bl    @cpym2m
              data def.device,tv.devpath,6

        clr   @edb.autoinsert       ; Set AutoInsert off by default
        clr   @tv.show.linelen      ; Show line length off by default
        clr   @tv.skip.browser      ; Reset "skip filebrowser" flag

        li    tmp0,13               ; \
        mov   tmp0,@tv.lineterm     ; | MSB = 00 Line termination mode off
                                    ; / LSB = 13 Carriage return
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.init.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

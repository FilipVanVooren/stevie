* basic......: dialog.asm
* Purpose....: Dialog initialisation

***************************************************************
* dialog
* Dialog initialisation code
***************************************************************
* bl @dialog
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Copy dialog strings to RAM
        ;-------------------------------------------------------
        bl    @cpym2m
              data txt.hint.memstat,ram.msg1,80

        bl    @cpym2m
              data txt.hint.lineterm,ram.msg2,42
        ;-------------------------------------------------------
        ; Poke VDP resolution to dialog string
        ;-------------------------------------------------------
        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor/rulers

        bl    @cpym2m
              data dialog.text.24,ram.msg1+53,2

        .endif

        .ifeq vdpmode, 2481         ; F18a 24x80 character cursor

        bl    @cpym2m
              data dialog.text.24,ram.msg1+53,2

        bl    @cpym2m
              data dialog.text.textmode,ram.msg1+69,10

        .endif

        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor/rulers

        bl    @cpym2m
              data dialog.text.30,ram.msg1+53,2

        .endif

        .ifeq vdpmode, 3081         ; F18a 30x80 character cursor

        bl    @cpym2m
              data dialog.text.30,ram.msg1+53,2

        bl    @cpym2m
              data dialog.text.textmode,ram.msg1+69,10

        .endif

        bl    @cpym2m
              data dialog.text.80,ram.msg1+62,2
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


;--------------------------------------------------------------
; Dialog strings (no length byte prefix)
;--------------------------------------------------------------
dialog.text.24        text '24'
dialog.text.30        text '30'
dialog.text.80        text '80'
dialog.text.textmode  text ', textmode'

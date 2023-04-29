* FILE......: task.vdp.cursor.sprite.asm
* Purpose...: VDP sprite cursor shape (sprite version)

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Update cursor shape
        ;------------------------------------------------------
        bl    @vdp.cursor.sprite    ; Update cursor shape
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task

* FILE......: task.vdp.cursor.char.asm
* Purpose...: VDP cursor shape (character version)

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Update cursor shape
        ;------------------------------------------------------
        bl    @vdp.cursor.char      ; Update cursor shape
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task

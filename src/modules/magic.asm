* FILE......: magic.asm
* Purpose...: Handle magic strings

***************************************************************
* magic.set
* Set magic string in core memory
***************************************************************
* bl @magic.set
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Set the bytes 'DEAD994ABEEF' in core memory.
* If the sequence is set then Stevie knows its safe to resume
* without initializing.
********|*****|*********************|**************************
magic.set:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set magic string
        ;------------------------------------------------------
        mov   @magic.string+0,@magic.str.w1
        mov   @magic.string+2,@magic.str.w2
        mov   @magic.string+4,@magic.str.w3
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
magic.set.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* magic.clear
* Clear magic string in core memory
***************************************************************
* bl @magic.set
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Clear the bytes 'DEAD994ABEEF' in core memory.
* Indicate it's unsafe to resume Stevie and initialization
* is necessary.
********|*****|*********************|**************************
magic.clear:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Clear magic string
        ;------------------------------------------------------
        clr   @magic.str.w1
        clr   @magic.str.w2
        clr   @magic.str.w3
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
magic.clear.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* magic.check
* Check if magic string is set
***************************************************************
* bl @magic.set
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* r0 = >ffff Magic string set
* r0 = >0000 Magic string not set
*--------------------------------------------------------------
* Register usage
* r0
*--------------------------------------------------------------
* Clear the bytes 'DEAD994ABEEF' in core memory.
* Indicate it's unsafe to resume Stevie and initialization
* is necessary.
********|*****|*********************|**************************
magic.check:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Check magic string
        ;------------------------------------------------------
        clr   r0                    ; Reset flag

        c     @magic.str.w1,@magic.string
        jne   magic.check.exit
        c     @magic.str.w2,@magic.string+2
        jne   magic.check.exit
        c     @magic.str.w3,@magic.string+4
        jne   magic.check.exit

        seto  r0                    ; Yes, magic string is set
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
magic.check.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



magic.string  byte >de,>ad,>99,>4a,>be,>ef
                                    ; DEAD 994A BEEF
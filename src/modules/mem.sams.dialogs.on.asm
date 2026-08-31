* FILE......: mem.sams.dialogs.on.asm
* Purpose...: Activate SAMS pages that have dialogs data

***************************************************************
* mem.sams.dialogs.on
* Activate SAMS page #2 (>b000) and SAMS page #3 (>c000)
***************************************************************
* bl  @mem.sams.dialogs.on
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
mem.sams.dialogs.on:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;------------------------------------------------------
        bl    @sams.page.set        ; Set SAMS page
              data >0002,>b000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address

        bl    @sams.page.set        ; Set SAMS page
              data >0003,>c000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.dialogs.on.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

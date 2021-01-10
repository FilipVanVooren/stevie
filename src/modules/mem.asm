* FILE......: mem.asm
* Purpose...: Stevie Editor - Memory management (SAMS)

***************************************************************
* mem.sams.layout
* Setup SAMS memory pages for Stevie
***************************************************************
* bl  @mem.sams.layout
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
mem.sams.layout:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @sams.layout
              data mem.sams.layout.data

        bl    @sams.layout.copy
              data tv.sams.2000     ; Get SAMS windows

        mov   @tv.sams.c000,@edb.sams.page
        mov   @edb.sams.page,@edb.sams.hipage                  
                                    ; Track editor buffer SAMS page
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.layout.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
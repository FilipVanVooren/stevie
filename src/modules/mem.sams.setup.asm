* FILE......: mem.sams.setup.asm
* Purpose...: SAMS Memory setup for Stevie

***************************************************************
* mem.sams.setup.stevie
* Setup SAMS memory pages for Stevie
***************************************************************
* bl  @mem.sams.setup.stevie
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
mem.sams.setup.stevie:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @mem.sams.set.boot    ; Set SAMS banks in boot for Stevie

        bl    @sams.layout.copy
              data tv.sams.2000     ; Copy SAMS bank ID to shadow table.

        mov   @tv.sams.c000,@edb.sams.page
        mov   @edb.sams.page,@edb.sams.hipage                  
                                    ; Track editor buffer SAMS page
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.setup.stevie.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
* FILE......: fb.calc.scrrows.asm
* Purpose...: Calculate number of available rows in frame buffer

***************************************************************
* fb.calc.scrrows 
* Calculate number of available rows in frame buffer
***************************************************************
* bl @fb.calc.scrrows
*--------------------------------------------------------------
* INPUT
* @tv.ruler.visible = Ruler visible on screen flag
* @edb.special.file = Special file flag (e.g. Master Catalog)
* @tv.error.visible = Error area visible on screen flag
*--------------------------------------------------------------
* OUTPUT
* @fb.scrrows = Number of available rows in frame buffer
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
fb.calc.scrrows:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @fb.scrrows.max,@fb.scrrows 
                                    ; Set maximum number of available rows
        ;------------------------------------------------------
        ; (1) Handle ruler visible on screen
        ;------------------------------------------------------
fb.calc.scrrows.handle.ruler:
        abs   @tv.ruler.visible     ; Ruler visible?
        jeq   fb.calc.scrrows.handle.mc
        dec   @fb.scrrows           ; Yes, adjust rows
        ;------------------------------------------------------
        ; (2) Handle Master Catalog
        ;------------------------------------------------------
fb.calc.scrrows.handle.mc:
        c     @edb.special.file,@const.0
        jeq   fb.calc.scrrows.handle.errors
        dec   @fb.scrrows           ; Yes, adjust rows
        ;------------------------------------------------------
        ; (3) Handle error area
        ;------------------------------------------------------
fb.calc.scrrows.handle.errors:
        abs   @tv.error.visible     ; Error area visible?
        jeq   fb.calc.scrrows.exit
        s     @tv.error.rows,@fb.scrrows
                                    ; Yes, adjust rows
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.calc.scrrows.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

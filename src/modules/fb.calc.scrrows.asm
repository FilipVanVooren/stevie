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
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
fb.calc.scrrows:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @fb.scrrows.max,tmp0  ; Get maximum number of available rows
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
        mov   @edb.special.file,tmp0 
        ci    tmp0,id.special.mastcat 
        jeq   fb.calc.scrrows.handle.errors
        dec   @fb.scrrows           ; Yes, adjust rows
        ;------------------------------------------------------
        ; (3) Handle error area
        ;------------------------------------------------------
fb.calc.scrrows.handle.errors:
        abs   @tv.error.visible     ; Error area visible?
        jeq   fb.calc.scrrows.exit
        dec   @fb.scrrows           ; Yes, adjust rows
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.calc.scrrows.exit:
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

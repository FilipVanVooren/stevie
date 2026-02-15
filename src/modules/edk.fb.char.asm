* FILE......: edk.fb.char
* Purpose...: Add character 

***************************************************************
* edk.fb.char
* Add character
***************************************************************
* bl  @ed.fb.char
*--------------------------------------------------------------
* INPUT
* tmp0 = Keycode (MSB)
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
edk.fb.char:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Asserts
        ;-------------------------------------------------------
        ci    tmp0,>2000            ; Keycode < ASCII 32 ?
        jlt   edk.fb.char.exit      ; Yes, skip
        ci    tmp0,>7e00            ; Keycode > ASCII 126 ?
        jgt   edk.fb.char.exit      ; Yes, skip
        ;-------------------------------------------------------
        ; Save cursor YX
        ;-------------------------------------------------------
        mov   @fb.row,tmp1          ; \
        sla   tmp1,8                ; | Row to MSB
        mov   @fb.column,tmp2       ; | Column to LSB        
        soc   tmp1,tmp2             ; | Overlay 
        mov   tmp2,@fb.prevcursor   ; / Save cursor YX
        ;-------------------------------------------------------
        ; Setup
        ;-------------------------------------------------------
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        mov   tmp0,@parm1           ; Store character for insert
        mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
        jeq   edk.fb.char.overwrite
        ;-------------------------------------------------------
        ; Insert mode
        ;-------------------------------------------------------
        bl    @fb.insert.char       ; Insert character
                                    ; \ i  @parm1 = MSB character to insert
                                    ; |             LSB = 0 move cursor right
                                    ; /             LSB > 0 do not move cursor

        jmp   edk.fb.char.drawcursor
        ;-------------------------------------------------------
        ; Overwrite mode - Write character
        ;-------------------------------------------------------
edk.fb.char.overwrite:
        bl    @fb.replace.char      ; Replace (overwrite) character
                                    ; \ i  @parm1 = MSB character to replace
                                    ; /        
        ;-------------------------------------------------------
        ; Draw cursor (TAT)
        ;-------------------------------------------------------
edk.fb.char.drawcursor:
        bl    @vdp.cursor.tat       ; Draw cursor at current position
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.fb.char.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

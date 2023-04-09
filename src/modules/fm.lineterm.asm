* FILE......: fm.lineterm
* Purpose...: Toggle line termination mode

***************************************************************
* fm.lineterm
* Toggle line termination mode
***************************************************************
* bl  @fm.lineterm
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.lineterm:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Toggle line termination mode
        ;-------------------------------------------------------
        mov   @cmdb.dialog,tmp1     ; Get ID of current dialog

        mov   @edb.lineterm,tmp0    ; Get line termination mode + char
        inv   tmp0                  ; Toggle on/off (MSB is of interest)
        movb  @edb.lineterm+1,@tmp0lb
                                    ; Restore line termination character (LSB)
        mov   tmp0,@edb.lineterm    ; Save variable
        ;-------------------------------------------------------
        ; Set keylist in status line
        ;-------------------------------------------------------        
        srl   tmp0,8                ; \
        jeq   !                     ; / Line termination mode is off
        ;-------------------------------------------------------
        ; Line termination mode is on
        ;-------------------------------------------------------
        li    tmp0,ram.msg2         ; 
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display

        li    tmp2,id.dialog.save   ; \
        c     tmp1,tmp2             ; |  Save dialog?
        jeq   fm.lineterm.on.1      ; /

        li    tmp2,id.dialog.print  ; \
        c     tmp1,tmp2             ; |  Print dialog?
        jeq   fm.lineterm.on.2      ; / 
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------  
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; Line termination mode is off
        ;-------------------------------------------------------
!       clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp2,id.dialog.save   ; \
        c     tmp1,tmp2             ; |  Save dialog?
        jeq   fm.lineterm.off.1     ; /

        li    tmp2,id.dialog.print  ; \
        c     tmp1,tmp2             ; |  Print dialog?
        jeq   fm.lineterm.off.2     ; / 
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------  
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Keylist line termination off
        ;------------------------------------------------------  
fm.lineterm.off.1:
        li    tmp0,txt.keys.save1
        jmp   fm.lineterm.keylist
fm.lineterm.off.2:
        li    tmp0,txt.keys.print1
        jmp   fm.lineterm.keylist
        ;------------------------------------------------------
        ; Keylist line termination on
        ;------------------------------------------------------  
fm.lineterm.on.1:
        li    tmp0,txt.keys.save2
        jmp   fm.lineterm.keylist
fm.lineterm.on.2:
        li    tmp0,txt.keys.print2
        jmp   fm.lineterm.keylist
        ;------------------------------------------------------
        ; Set keylist
        ;------------------------------------------------------ 
fm.lineterm.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fm.lineterm.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

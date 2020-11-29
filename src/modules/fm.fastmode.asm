* FILE......: fm.fastmode.asm
* Purpose...: Turn fastmode on/off for file operation

***************************************************************
* fm.fastmode
* Turn on fast mode for supported devices
***************************************************************
* bl  @fm.fastmode
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.fastmode:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   @fh.offsetopcode,tmp0
        jeq   !
        ;------------------------------------------------------
        ; Turn fast mode off
        ;------------------------------------------------------        
        clr   @fh.offsetopcode      ; Data buffer in VDP RAM
        li    tmp0,txt.keys.load
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        jmp   fm.fastmode.exit
        ;------------------------------------------------------
        ; Turn fast mode on
        ;------------------------------------------------------        
!       li    tmp0,>40              ; Data buffer in CPU RAM
        mov   tmp0,@fh.offsetopcode
        li    tmp0,txt.keys.load2
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.fastmode.exit:
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

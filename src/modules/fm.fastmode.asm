* FILE......: fm.fastmode.asm
* Purpose...: Toggle "fast-mode IO" for file operation

***************************************************************
* fm.fastmode
* Toggle "fast-mode IO" for file operation
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
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.fastmode:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Toggle fastmode
        ;------------------------------------------------------   
        mov   @cmdb.dialog,tmp1     ; Get ID of current dialog
        mov   @fh.offsetopcode,tmp0 ; Get file opcode offset
        jeq   fm.fastmode.on        ; Toggle on if offset is 0
        ;------------------------------------------------------
        ; Turn fast mode off
        ;------------------------------------------------------        
fm.fastmode.off:        
        clr   @fh.offsetopcode      ; Data buffer in VDP RAM

        li    tmp2,id.dialog.open
        c     tmp1,tmp2
        jeq   fm.fastmode.off.1

        li    tmp2,id.dialog.insert
        c     tmp1,tmp2
        jeq   fm.fastmode.off.2

        li    tmp2,id.dialog.append
        c     tmp1,tmp2
        jeq   fm.fastmode.off.4
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------  
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Keylist fastmode off
        ;------------------------------------------------------  
fm.fastmode.off.1:
        li    tmp0,txt.keys.open
        jmp   fm.fastmode.keylist
fm.fastmode.off.2:
        li    tmp0,txt.keys.insert
        jmp   fm.fastmode.keylist
fm.fastmode.off.4:
        li    tmp0,txt.keys.append
        jmp   fm.fastmode.keylist
        ;------------------------------------------------------
        ; Turn fast mode on
        ;------------------------------------------------------        
fm.fastmode.on:        
        li    tmp0,>40              ; Data buffer in CPU RAM
        mov   tmp0,@fh.offsetopcode

        li    tmp2,id.dialog.open
        c     tmp1,tmp2
        jeq   fm.fastmode.on.1

        li    tmp2,id.dialog.insert
        c     tmp1,tmp2
        jeq   fm.fastmode.on.2

        li    tmp2,id.dialog.append
        c     tmp1,tmp2
        jeq   fm.fastmode.on.4
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------  
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Keylist fastmode on
        ;------------------------------------------------------  
fm.fastmode.on.1:
        li    tmp0,txt.keys.open2
        jmp   fm.fastmode.keylist
fm.fastmode.on.2:
        li    tmp0,txt.keys.insert2
        jmp   fm.fastmode.keylist
fm.fastmode.on.4:                
        li    tmp0,txt.keys.append2
        ;------------------------------------------------------
        ; Set keylist
        ;------------------------------------------------------ 
fm.fastmode.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.fastmode.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

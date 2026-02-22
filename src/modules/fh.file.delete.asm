* FILE......: fh.file.delete.asm
* Purpose...: Delete file

***************************************************************
* fh.file.delete
* Delete a file
***************************************************************
*  bl   @fh.file.delete
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
* parm2 = Pointer to callback function "Before deleting file"
* parm3 = Pointer to callback function "File deleted"
* parm4 = Pointer to callback function "File I/O error"
*
* OUTPUT
* outparm1 = >0000 delete success, >FFFF delete failed
*
* Callbacks can be skipped by passing >0000 as pointer.
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
*--------------------------------------------------------------
* Remarks
* None
********|*****|*********************|**************************
fh.file.delete:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        dect  stack
        mov   @parm4,*stack         ; Push @parm4
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------  
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents                           
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.others ; Other file operation 
        mov   tmp0,@fh.fopmode       ; Set file operations mode

        mov   @parm1,@fh.fname.ptr   ; Pointer to file descriptor
        mov   @parm2,@fh.callback1   ; Callback function "Before deleting file"
        mov   @parm3,@fh.callback2   ; Callback function "File deleted"
        mov   @parm4,@fh.callback3   ; Callback function "File I/O error"

        li    tmp0,fh.file.pab.header.delete
        mov   tmp0,@fh.pabtpl.ptr    ; Set pointer to PAB template in ROM/RAM        
        clr   @fh.ftype.init         ; File type/mode (in LSB)        
        ;------------------------------------------------------
        ; Asserts
        ;------------------------------------------------------
fh.file.delete.assert1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.delete.assert2
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.delete.crash  ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.delete.crash  ; Yes, crash!

fh.file.delete.assert2
        mov   @fh.callback2,tmp0
        jeq   fh.file.delete.assert3
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.delete.crash  ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.delete.crash  ; Yes, crash!

fh.file.delete.assert3:
        mov   @fh.callback3,tmp0
        jeq   fh.file.delete.delete1
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.delete.crash  ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.delete.crash  ; Yes, crash!

        jmp   fh.file.delete.delete1  ; Prepare for deleteing file
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
fh.file.delete.crash:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before delete file"
        ;------------------------------------------------------
fh.file.delete.delete1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.delete.pabheader
                                    ; Skip callback
        bl    *tmp0                 ; Run callback function

        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.delete.pabheader:        
        li    tmp0,fh.vpab          ; VDP destination
        mov   @fh.pabtpl.ptr,tmp1   ; PAB header source address
        li    tmp2,9                ; 9 bytes to copy
        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy                          
        ;------------------------------------------------------
        ; Append file descriptor to PAB header in VDP
        ;------------------------------------------------------
        li    tmp0,fh.vpab + 9      ; VDP destination        
        mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
        movb  *tmp1,tmp2            ; Get file descriptor length
        srl   tmp2,8                ; Right justify
        inc   tmp2                  ; Include length byte as well
        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; Step 1: delete file
        ;------------------------------------------------------
        bl    @file.delete          ; Delete file
              data fh.vpab          ; \ i  p1 = Address of PAB in VRAM
                                    ; /
        ;------------------------------------------------------
        ; File error occured?
        ;------------------------------------------------------ 
        coc   @wbit2,tmp2            ; Condition bit set?
        jne   fh.file.delete.success ; No, condition bit clear, proceed
        ;------------------------------------------------------
        ; Yes, file error occured, process VDP PAB status byte
        ;------------------------------------------------------ 
        bl    @vgetb                ; Read PAB status byte from VDP
              data fh.vpab + 1      ; \ i p1   = Address PAB status byte in VRAM
                                    ; / o tmp0 = PAB status byte (LSB)
        ;------------------------------------------------------
        ; Get relevant bits from status byte
        ;------------------------------------------------------ 
        andi  tmp0,>00e0             ; Mask to LSB, only bits 5-7 relevant
        srl   tmp0,5                 ; Right justify bits
        mov   tmp0,@fh.pabstat       ; Save PAB status byte
        ci    tmp0,io.err.bad_open_attribute 
        jeq   fh.file.delete.success ; Not considered an error, proceed
        jmp   fh.file.delete.error   ; Handle file I/O error
        ;------------------------------------------------------
        ; Step 3: Processing complete, call callback
        ;------------------------------------------------------ 
fh.file.delete.success:
        clr   @outparm1             ; Clear delete failed flag, can be trashed
        mov   @fh.callback2,tmp0    ; Get pointer to Callback "File deletee"
        jeq   fh.file.delete.exit   ; Skip callback
        bl    *tmp0                 ; Run callback function
        clr   @outparm1             ; Clear delete failed flag
        jmp   fh.file.delete.exit   ; Exit normally
        ;------------------------------------------------------
        ; Callback "File I/O error"
        ;------------------------------------------------------
fh.file.delete.error:
        li    tmp0,id.file.deletefile 
        mov   tmp0,@fh.workmode     ; Work mode (used in callbacks)

        seto  @outparm1             ; Set delete failed flag, can be trashed
        mov   @fh.callback3,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.delete.exit   ; Skip callback if not set

        bl    *tmp0                 ; Run callback function
        seto  @outparm1             ; Set delete failed flag
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.delete.exit:
        bl    @film
              data >83a0,>00,96     ; Clear any garbage left-over by DSR calls.
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   

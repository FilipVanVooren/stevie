* FILE......: fh.file.load.bin.asm
* Purpose...: Load binary file into memory

***************************************************************
* fh.file.load.bin
* Load binary file into memory
***************************************************************
*  bl   @fh.file.load.bin
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
* parm2 = Pointer to callback function "Before loading image"
* parm3 = Pointer to callback function "Image loaded"
* parm4 = Pointer to callback function "File I/O error"
* parm5 = VDP destination address to load file into
* parm6 = RAM destination address to copy file into
* parm7 = Maximum number of bytes to load
*
* Callbacks can be skipped by passing >0000 as pointer.
* Copy to RAM can be skipped by passing >FFFF in parm6.
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
fh.file.load.bin:
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
        dect  stack
        mov   @parm5,*stack         ; Push @parm5
        dect  stack
        mov   @parm6,*stack         ; Push @parm6
        dect  stack
        mov   @parm7,*stack         ; Push @parm7
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------  
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents                           
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.readfile
                                    ; Going to read a file
        mov   tmp0,@fh.fopmode      ; Set file operations mode

        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
        mov   @parm2,@fh.callback1  ; Callback function "Before loading image"
        mov   @parm3,@fh.callback2  ; Callback function "Binary image loaded"
        mov   @parm4,@fh.callback3  ; Callback function "File I/O error"

        li    tmp0,fh.file.pab.header.binimage
        mov   tmp0,@fh.pabtpl.ptr   ; Set pointer to PAB template in ROM/RAM
        
        clr   @fh.ftype.init        ; File type/mode (in LSB)        
        ;------------------------------------------------------
        ; Loading file in destination memory
        ;------------------------------------------------------
fh.file.load.bin.newfile:
        seto  @fh.temp1             ; Set flag "load file"
        clr   @fh.temp3             ; Not used
        ;------------------------------------------------------
        ; Asserts
        ;------------------------------------------------------
fh.file.load.bin.assert1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.load.bin.assert2
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.load.bin.crsh ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.load.bin.crsh ; Yes, crash!

fh.file.load.bin.assert2
        mov   @fh.callback2,tmp0
        jeq   fh.file.load.bin.assert3
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.load.bin.crsh ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.load.bin.crsh ; Yes, crash!

fh.file.load.bin.assert3:
        mov   @fh.callback3,tmp0
        jeq   fh.file.load.bin.load1
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.load.bin.crsh ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.load.bin.crsh ; Yes, crash!

        jmp   fh.file.load.bin.load1 ; Prepare for loading file
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
fh.file.load.bin.crsh:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before load binary image"
        ;------------------------------------------------------
fh.file.load.bin.load1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.load.bin.pabheader
                                    ; Skip callback
        bl    *tmp0                 ; Run callback function
        ;------------------------------------------------------
        ; Clear VRAM destination area
        ;------------------------------------------------------
        mov   @parm5,tmp0           ; VDP destination address
        clr   tmp1                  ; Clear byte to write
        mov   @parm7,tmp2           ; Number of bytes to clear
        bl    @xfilv                ; Fill VDP memory block
                                    ; \ i  tmp0 = VDP destination address
                                    ; | i  tmp1 = Byte to write
                                    ; / i  tmp2 = Number of bytes to write
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.load.bin.pabheader:        
        li    tmp0,fh.vpab          ; VDP destination
        mov   @fh.pabtpl.ptr,tmp1   ; PAB header source address
        li    tmp2,9                ; 9 bytes to copy
        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; Set file VRAM destination address in PAB
        ;------------------------------------------------------
        li    tmp0,fh.vpab + 2      ; Set pointer to file destination address in PAB
        li    tmp1,parm5            ; Get pointer to VDP destination address
        li    tmp2,2                ; 2 bytes to copy
        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination        
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy (2)
        ;------------------------------------------------------
        ; Set max number of bytes to read in PAB
        ;------------------------------------------------------
        li    tmp0,fh.vpab + 6      ; Set pointer to file destination address in PAB
        li    tmp1,parm7            ; Get max number of bytes to read
        li    tmp2,2                ; 2 bytes to copy
        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination        
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy (2)                                    
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
        ; Step 1: Load binary image into VDP memory
        ;------------------------------------------------------
        bl    @file.load            ; Read binary image
              data fh.vpab          ; \ i  p1 = Address of PAB in VRAM
                                    ; /
        ;------------------------------------------------------
        ; File error occured?
        ;------------------------------------------------------ 
        bl    @vgetb                ; Read PAB status byte from VDP
              data fh.vpab + 1      ; \ i p1   = Address of PAB status byte in VRAM
                                    ; / o tmp0 = PAB status byte (LSB)

        mov   tmp0,@fh.pabstat         ; Save VDP PAB status byte
        jeq   fh.file.load.bin.vdp2cpu ; No error, proceed
        ci    tmp0,>000d               ; Ignore?
        jne   fh.file.load.bin.error   ; handle error if not zero
        ;------------------------------------------------------
        ; Step 2: Copy loaded data from VDP to RAM if requested
        ;------------------------------------------------------ 
fh.file.load.bin.vdp2cpu:        
        mov   @parm6,tmp1           ; Get RAM destination address
        ci    tmp1,>ffff            ; "skip copy to RAM" ?
        jeq   fh.file.load.bin.success
                                    ; Skip copy to RAM
        ;------------------------------------------------------
        ; Copy binary image from VDP to RAM
        ;------------------------------------------------------
        mov   @parm5,tmp0           ; VDP source address
        mov   @parm6,tmp1           ; RAM target address
        mov   @parm7,tmp2           ; Number of bytes to copy         
        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy
        ;------------------------------------------------------
        ; Step 3: Processing complete, call callback
        ;------------------------------------------------------ 
fh.file.load.bin.success:
        mov   @fh.callback2,tmp0    ; Get pointer to Callback "Binary image loaded"
        jeq   fh.file.load.bin.exit ; Skip callback
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.load.bin.exit ; Exit normally
        ;------------------------------------------------------
        ; Callback "File I/O error"
        ;------------------------------------------------------
fh.file.load.bin.error:        
        mov   @fh.callback3,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.load.bin.exit 
                                    ; Skip callback
        bl    *tmp0                 ; Run callback function  
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.load.bin.exit:
        clr   @fh.fopmode           ; Set FOP mode to idle operation

        bl    @film
              data >83a0,>00,96     ; Clear any garbage left-over by DSR calls.

        mov   @parm7,*stack+        ; Pop @parm7
        mov   @parm6,*stack+        ; Pop @parm6
        mov   @parm5,*stack+        ; Pop @parm5
        mov   @parm4,*stack+        ; Pop @parm4
        mov   @parm3,*stack+        ; Pop @parm3
        mov   @parm2,*stack+        ; Pop @parm2
        mov   @parm1,*stack+        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   

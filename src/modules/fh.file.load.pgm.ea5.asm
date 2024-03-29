* FILE......: fh.file.load.pgm.ea5.asm
* Purpose...: Load Editor/Assembler program into memory

***************************************************************
* fh.file.load.pgm.ea5
* Load Editor/Assembler EA5 program image into memory
***************************************************************
*  bl   @fh.file.load.pgm.ea5
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
* parm2 = Pointer to callback function "Before loading image"
* parm3 = Pointer to callback function "Read line from file"
* parm4 = Pointer to callback function "Close file"
* parm5 = Pointer to callback function "File I/O error"
* parm6 = Pointer to callback function "Memory full"
* parm7 = Destination RAM address
* parm8 = PAB template header address
* parm9 = File type/mode (in LSB), becomes PAB byte 1
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
* Load EA5 program image into memory
********|*****|*********************|**************************
fh.file.load.pgm.ea5:
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
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------  
        clr   @fh.records           ; Reset records counter
        clr   @fh.counter           ; Clear internal counter
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents                           
        ;------------------------------------------------------
        ; Save parameters / callback functions
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.readfile
                                    ; Going to read a file
        mov   tmp0,@fh.fopmode      ; Set file operations mode

        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
        mov   @parm2,@fh.callback1  ; Callback function "Open file"
        mov   @parm3,@fh.callback2  ; Callback function "Read image segment"
        mov   @parm4,@fh.callback3  ; Callback function "Close file"
        mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
        mov   @parm6,@fh.callback5  ; Callback function "Memory full error"
        mov   @parm7,@fh.ram.ptr    ; Set pointer to RAM destination
        mov   @parm8,@fh.pabtpl.ptr ; Set pointer to PAB template in ROM/RAM
        mov   @parm9,@fh.ftype.init ; File type/mode (in LSB)
        ;------------------------------------------------------
        ; Loading file in destination memory
        ;------------------------------------------------------
fh.file.load.pgm.ea5.newfile:
        seto  @fh.temp1             ; Set flag "load file"
        clr   @fh.temp3             ; Not used
        ;------------------------------------------------------
        ; Asserts
        ;------------------------------------------------------
fh.file.load.pgm.ea5.assert1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.load.pgm.ea5.assert2
        ci    tmp0,>6000                ; Insane address ?
        jlt   fh.file.load.pgm.ea5.crsh ; Yes, crash!
        ci    tmp0,>7fff                ; Insane address ?
        jgt   fh.file.load.pgm.ea5.crsh ; Yes, crash!

fh.file.load.pgm.ea5.assert2
        mov   @fh.callback2,tmp0
        jeq   fh.file.load.pgm.ea5.assert3
        ci    tmp0,>6000                 ; Insane address ?
        jlt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!
        ci    tmp0,>7fff                 ; Insane address ?
        jgt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!

fh.file.load.pgm.ea5.assert3:
        mov   @fh.callback3,tmp0
        jeq   fh.file.load.pgm.ea5.assert4
        ci    tmp0,>6000                 ; Insane address ?
        jlt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!
        ci    tmp0,>7fff                 ; Insane address ?
        jgt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!

fh.file.load.pgm.ea5.assert4:         
        mov   @fh.callback4,tmp0
        jeq   fh.file.load.pgm.ea5.assert5
        ci    tmp0,>6000                 ; Insane address ?
        jlt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!
        ci    tmp0,>7fff                 ; Insane address ?
        jgt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!

fh.file.load.pgm.ea5.assert5:
        mov   @fh.callback5,tmp0
        jeq   fh.file.load.pgm.ea5.load1
        ci    tmp0,>6000                 ; Insane address ?
        jlt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!
        ci    tmp0,>7fff                 ; Insane address ?
        jgt   fh.file.load.pgm.ea5.crsh  ; Yes, crash!

        jmp   fh.file.load.pgm.ea5.load1 ; All checks passed, continue
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
fh.file.load.pgm.ea5.crsh:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before Open file"
        ;------------------------------------------------------
fh.file.load.pgm.ea5.load1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.load.pgm.ea5.pabheader
                                    ; Skip callback
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.load.pgm.ea5.pabheader:        
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
        ; Load file
        ;------------------------------------------------------
        li    r0,fh.vpab            ; Address of PAB in VRAM
        mov   @fh.ftype.init,r1     ; File type/mode (in LSB)

        bl    @xfile.open           ; Open file (register version)
                                    ; \ i  r0 = Address of PAB in VRAM
                                    ; / i  r1 = File type/mode (in lSB)
                                    
        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.load.pgm.ea5.segment        
        b     @fh.file.load.pgm.ea5.error  
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Step 2: Read image segment
        ;------------------------------------------------------
fh.file.load.pgm.ea5.segment:        
        inc   @fh.records           ; Update counter        
        clr   @fh.reclen            ; Reset record length
        ;------------------------------------------------------
        ; 2b: Read image segment
        ;------------------------------------------------------
!       bl    @file.record.read     ; Read image segment
              data fh.vpab          ; \ i  p0 file  = Address of PAB in VDP RAM 
                                    ; |           (without +9 offset!)
                                    ; | o  tmp0 = Status byte
                                    ; | o  tmp1 = Bytes read
                                    ; | o  tmp2 = Status register contents 
                                    ; /           upon DSRLNK return

        mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
        mov   tmp1,@fh.reclen       ; Save bytes read
        mov   tmp2,@fh.ioresult     ; Save status register contents
        ;------------------------------------------------------
        ; 2d: Check if a file error occured
        ;------------------------------------------------------
fh.file.load.pgm.ea5.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.load.pgm.ea5.process
                                    ; No, goto (3)
        b     @fh.file.load.pgm.ea5.error  
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; 3: Process segment
        ;------------------------------------------------------
fh.file.load.pgm.ea5.process:
        li    tmp0,fh.vrecbuf       ; VDP source address
        mov   @fh.ram.ptr,tmp1      ; RAM target address
        mov   @fh.reclen,tmp2       ; Number of bytes to copy        
        ;------------------------------------------------------
        ; 3b: Copy segment from VDP to CPU memory
        ;------------------------------------------------------
fh.file.load.pgm.ea5.vdp2cpu:        
        ; 
        ; Executed for devices that need their disk buffer in VDP memory
        ; (TI Disk Controller, tipi, nanopeb, ...).
        ; 
        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy                                                                            
        ;------------------------------------------------------
        ; Step 5: Callback "Read image segment from file"
        ;------------------------------------------------------
fh.file.load.pgm.ea5.display:
        mov   @fh.callback2,tmp0    ; Get pointer to callback
        jeq   fh.file.load.pgm.ea5.next 
                                    ; Skip callback        
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; 5a: Prepare for next sgment
        ;------------------------------------------------------
fh.file.load.pgm.ea5.next:
        inc   @fh.line              ; lines/records++
        ;------------------------------------------------------
        ; 5c: Next segment
        ;------------------------------------------------------
fh.file.load.pgm.ea5.next.do_it:
        b     @fh.file.load.pgm.ea5.segment
                                    ; Next segment
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
fh.file.load.pgm.ea5.error:        
        mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   fh.file.load.pgm.ea5.eof  
                                    ; All good. File closed by DSRLNK
        ;------------------------------------------------------
        ; File error occured
        ;------------------------------------------------------ 
        bl    @file.close           ; Close file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
                                    ; /
        ;------------------------------------------------------
        ; Callback "File I/O error"
        ;------------------------------------------------------
        mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.load.pgm.ea5.exit 
                                    ; Skip callback
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.load.pgm.ea5.exit
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
fh.file.load.pgm.ea5.eof:
        bl    @file.close           ; Close file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
                                    ; /
        ;------------------------------------------------------
        ; Callback "Close file"
        ;------------------------------------------------------
fh.file.load.pgm.ea5.eof.callback:
        mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
        jeq   fh.file.load.pgm.ea5.exit ; Skip callback
        bl    *tmp0                 ; Run callback function                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.load.pgm.ea5.exit:
        clr   @fh.fopmode           ; Set FOP mode to idle operation

        bl    @film
              data >83a0,>00,96     ; Clear any garbage left-over by DSR calls.

        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   

* FILE......: fh.file.load.ea5.asm
* Purpose...: Load binary image into memory

***************************************************************
* fh.file.load.ea5
* Load binary image into memory
***************************************************************
*  bl   @fh.file.load.ea5
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
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
fh.file.load.ea5:
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
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents                           
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.readfile
                                    ; Going to read a file
        mov   tmp0,@fh.fopmode      ; Set file operations mode
        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor

        li    tmp0,fh.file.pab.header.binimage
        mov   tmp0,@fh.pabtpl.ptr   ; Set pointer to PAB template in ROM/RAM
        
        clr   @fh.ftype.init        ; File type/mode (in LSB)
        ;------------------------------------------------------
        ; Loading file in destination memory
        ;------------------------------------------------------
fh.file.load.ea5.newfile:
        seto  @fh.temp1             ; Set flag "load file"
        clr   @fh.temp3             ; Not used
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.load.ea5.pabheader:        
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
        ; Reset the F18a
        ;------------------------------------------------------ 
        bl    @f18rst               ; Reset and lock the F18A
        bl    @vidtab               ; Load video mode table into VDP
              data tibasic.32x24    ; Equate selected video mode table
        bl    @scroff               ; Turn off screen
        ;------------------------------------------------------
        ; Clear 32K memory expansion range before loading
        ;------------------------------------------------------        
        bl    @film
              data >2000,>00,8192   ; Clear >2000 - >3fff
        bl    @film
              data >a000,>00,24576  ; Clear >2000 - >3fff
        ;------------------------------------------------------
        ; Clear VDP memory before loading
        ;------------------------------------------------------ 
        bl    @filv
              data >0000,>00,8192   ; Clear VDP memory >0000 - >1fff                                    
        ;------------------------------------------------------
        ; Inline setup memory paging for SAMS
        ;------------------------------------------------------
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
        sbo   0                     ; Enable access to SAMS registers
        li    r0,>0200              ; \ Page 2 in >2000 - >2fff
        movb  r0,@>4004             ; /
        li    r0,>0300              ; \ Page 3 in >3000 - >3fff
        movb  r0,@>4006             ; /
        li    r0,>0A00              ; \ Page A in >a000 - >afff
        movb  r0,@>4014             ; /
        li    r0,>0B00              ; \ Page B in >b000 - >bfff
        movb  r0,@>4016             ; /
        li    r0,>0C00              ; \ Page C in >c000 - >bfff
        movb  r0,@>4018             ; /
        li    r0,>0D00              ; \ Page D in >d000 - >dfff
        movb  r0,@>401a             ; /
        li    r0,>0E00              ; \ Page E in >e000 - >efff
        movb  r0,@>401c             ; /
        li    r0,>0F00              ; \ Page F in >f000 - >ffff
        movb  r0,@>401e             ; /
        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Load binary image
        ;------------------------------------------------------
        li    r0,fh.vpab            ; Address of PAB in VRAM
        bl    @xfile.load           ; Read binary image (register version)
                                    ; \ i  r0 = Address of PAB in VRAM
                                    ; | o  tmp0 = Status byte
                                    ; | o  tmp1 = Bytes read
                                    ; | o  tmp2 = Status register contents 
                                    ; /           upon DSRLNK return

        jmp  $
        mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
        mov   tmp1,@fh.reclen       ; Save bytes read
        mov   tmp2,@fh.ioresult     ; Save status register contents

        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.load.ea5.check_fioerr
        jmp   fh.file.load.ea5.error
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Check if a file error occured
        ;------------------------------------------------------
fh.file.load.ea5.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.load.ea5.process
                                    ; No, goto (3)
        jmp   fh.file.load.ea5.error
        ;------------------------------------------------------
        ; 3: Process segment
        ;------------------------------------------------------
fh.file.load.ea5.process:
        li    tmp0,fh.vrecbuf       ; VDP source address
        mov   @fh.ram.ptr,tmp1      ; RAM target address
        mov   @fh.reclen,tmp2       ; Number of bytes to copy        
        ;------------------------------------------------------
        ; 3b: Copy segment from VDP to CPU memory
        ;------------------------------------------------------
fh.file.load.ea5.vdp2cpu:        
        ; 
        ; Executed for devices that need their disk buffer in VDP memory
        ; (TI Disk Controller, tipi, nanopeb, ...).
        ; 
        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy                                                                              
        jmp   fh.file.load.ea5.exit
        ;------------------------------------------------------
        ; 3bc: Error handling
        ;------------------------------------------------------
fh.file.load.ea5.error:
        bl    @cpu.crash          ; Crash the CPU
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.load.ea5.exit:
        clr   @fh.fopmode           ; Set FOP mode to idle operation

        bl    @film
              data >83a0,>00,96     ; Clear any garbage left-over by DSR calls.

        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   

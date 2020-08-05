* FILE......: fh.write.edb.asm
* Purpose...: File write module

*//////////////////////////////////////////////////////////////
*               Write editor buffer to file
*//////////////////////////////////////////////////////////////


***************************************************************
* fh.file.write.edb
* Write editor buffer to file
***************************************************************
*  bl   @fh.file.write.edb
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed file descriptor
* parm2 = Pointer to callback function "Before Open file"
* parm3 = Pointer to callback function "Write line to file"
* parm4 = Pointer to callback function "Close file"
* parm5 = Pointer to callback function "File I/O error"
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fh.file.write.edb:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------   
        clr   @fh.records           ; Reset records counter
        clr   @fh.counter           ; Clear internal counter
        clr   @fh.kilobytes         ; \ Clear kilobytes processed
        clr   @fh.kilobytes.prev    ; /
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents
       
        mov   @edb.top.ptr,tmp0
        bl    @xsams.page.get       ; Get SAMS page
                                    ; \ i  tmp0  = Memory address
                                    ; | o  waux1 = SAMS page number
                                    ; / o  waux2 = Address of SAMS register
        ;------------------------------------------------------
        ; Save parameters / callback functions
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.writefile
                                    ; We are going to write to a file
        mov   tmp0,@fh.fopmode      ; Set file operations mode

        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
        mov   @parm2,@fh.callback1  ; Callback function "Open file"
        mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
        mov   @parm4,@fh.callback3  ; Callback function "Close" file"
        mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        mov   @fh.callback1,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.write.crash   ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.write.crash   ; Yes, crash!

        mov   @fh.callback2,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.write.crash   ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.write.crash   ; Yes, crash!

        mov   @fh.callback3,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.write.crash   ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.write.crash   ; Yes, crash!
         
        jmp   fh.file.write.edb.save1
                                    ; All checks passed, continue.
                                    ;-------------------------- 
                                    ; Check failed, crash CPU!
                                    ;--------------------------
fh.file.write.crash:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before Open file"
        ;------------------------------------------------------
fh.file.write.edb.save1:        
        mov   @fh.callback1,tmp0
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.write.edb.pabheader:        
        bl    @cpym2v
              data fh.vpab,fh.file.pab.header,9
                                    ; Copy PAB header to VDP
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
                                    ; / i  tmp2 = Nimber of bytes to copy
        ;------------------------------------------------------
        ; Load GPL scratchpad layout
        ;------------------------------------------------------
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        bl    @file.open
              data fh.vpab          ; Pass file descriptor to DSRLNK

        clr   tmp2   ; UGLY UGLY CHECK ME CHECK ME

        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.write.edb.record
        b     @fh.file.write.edb.error  
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Step 1: Write file record
        ;------------------------------------------------------
fh.file.write.edb.record:        
        inc   @fh.records           ; Update counter
        c     @fh.records,@edb.lines
        jeq   fh.file.write.edb.eof ; Exit when all records processed
        ;------------------------------------------------------
        ; 1a: Load spectra scratchpad layout
        ;------------------------------------------------------
        bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / @scrpad.backup2 to >8300
        ;------------------------------------------------------
        ; 1b: Unpack current line to framebuffer
        ;------------------------------------------------------
        mov   @fh.records,@parm1    ; Line to unpack
        clr   @parm2                ; First row in frame buffer

        bl    @edb.line.unpack      ; Unpack line
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in frame buffer
                                    ; / o  outparm1 = Length of line
        ;------------------------------------------------------        
        ; 1c: Copy unpacked line to VDP memory
        ;------------------------------------------------------
        li    tmp0,fh.vrecbuf       ; VDP target address
        li    tmp1,fb.top           ; Top of frame buffer in CPU memory

        mov   @outparm1,tmp2        ; Length of line
        mov   tmp2,@fh.reclen       ; Set record length

        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = CPU source address
                                    ; / i  tmp2 = Number of bytes to copy  
        ;------------------------------------------------------
        ; 1d: Calculate kilobytes processed
        ;------------------------------------------------------
        a     @fh.reclen,@fh.counter
                                    ; Add record length to counter
        mov   @fh.counter,tmp1      ;
        ci    tmp1,1024             ; 1 KB boundary reached ?
        jlt   !                     ; Not yet, goto (1e)
        inc   @fh.kilobytes
        ai    tmp1,-1024            ; Remove KB portion, only keep bytes
        mov   tmp1,@fh.counter      ; Update counter        
        ;------------------------------------------------------
        ; 1e: Load spectra scratchpad layout
        ;------------------------------------------------------
!       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / @scrpad.backup2 to >8300
        ;------------------------------------------------------
        ; 1f: Check if a file error occured
        ;------------------------------------------------------
fh.file.write.edb.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.write.edb.display
                                    ; No, goto (2)
        b     @fh.file.write.edb.error  
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; Step 2: Callback "Write line to  file"
        ;------------------------------------------------------
fh.file.write.edb.display:
        mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Step 3: Next record. Load GPL scratchpad layout.
        ;------------------------------------------------------
fh.file.write.edb.next:        
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->xxxx, xxxx->8300        

        b     @fh.file.write.edb.record
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
fh.file.write.edb.error:        
        mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   fh.file.write.edb.eof 
                                    ; All good. File closed by DSRLNK
        ;------------------------------------------------------
        ; File error occured
        ;------------------------------------------------------ 
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300

        bl    @mem.sams.layout      ; Restore SAMS windows
        ;------------------------------------------------------
        ; Callback "File I/O error"
        ;------------------------------------------------------
        mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.write.edb.exit
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
fh.file.write.edb.eof:        
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300

        bl    @mem.sams.layout      ; Restore SAMS windows
        ;------------------------------------------------------
        ; Callback "Close file"
        ;------------------------------------------------------
        mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
        bl    *tmp0                 ; Run callback function
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.write.edb.exit:
        clr   @fh.fopmode           ; Set FOP mode to idle operation                                    
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
* FILE......: fh.read.sams.asm
* Purpose...: File reader module (SAMS implementation)

*//////////////////////////////////////////////////////////////
*                  Read file into editor buffer
*//////////////////////////////////////////////////////////////


***************************************************************
* fh.file.read.sams
* Read file into editor buffer with SAMS support
***************************************************************
*  bl   @fh.file.read.sams
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed file descriptor
* parm2 = Pointer to callback function "loading indicator 1"
* parm3 = Pointer to callback function "loading indicator 2"
* parm4 = Pointer to callback function "loading indicator 3"
* parm5 = Pointer to callback function "File I/O error handler"
* parm6 = Not used yet (starting line in file)
* parm7 = Not used yet (starting line in editor buffer)
* parm8 = Not used yet (number of lines to read)
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
********|*****|*********************|**************************
fh.file.read.sams:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @fh.rleonload         ; No RLE compression!        
        clr   @fh.records           ; Reset records counter
        clr   @fh.counter           ; Clear internal counter
        clr   @fh.kilobytes         ; Clear kilobytes processed
        clr   tmp4                  ; Clear kilobytes processed display counter        
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents

        li    tmp0,3
        mov   tmp0,@fh.sams.page    ; Set current SAMS page
        mov   tmp0,@fh.sams.hpage   ; Set highest SAMS page in use
        ;------------------------------------------------------
        ; Save parameters / callback functions
        ;------------------------------------------------------
        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
        mov   @parm2,@fh.callback1  ; Loading indicator 1
        mov   @parm3,@fh.callback2  ; Loading indicator 2
        mov   @parm4,@fh.callback3  ; Loading indicator 3
        mov   @parm5,@fh.callback4  ; File I/O error handler
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        mov   @fh.callback1,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

        mov   @fh.callback2,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

        mov   @fh.callback3,tmp0
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!

        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!
         
        jmp   fh.file.read.sams.load1
                                    ; All checks passed, continue.
                                    ;-------------------------- 
                                    ; Check failed, crash CPU!
                                    ;--------------------------
fh.file.read.crash:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Show "loading indicator 1"
        ;------------------------------------------------------
fh.file.read.sams.load1:        
        mov   @fh.callback1,tmp0
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.read.sams.pabheader:        
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
        bl    @xpym2v               ; Append file descriptor to VDP PAB
        ;------------------------------------------------------
        ; Load GPL scratchpad layout
        ;------------------------------------------------------
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->2100, 2000->8300
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        bl    @file.open
              data fh.vpab          ; Pass file descriptor to DSRLNK
        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.read.sams.record
        b     @fh.file.read.sams.error  
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Step 1: Read file record
        ;------------------------------------------------------
fh.file.read.sams.record:        
        inc   @fh.records           ; Update counter        
        clr   @fh.reclen            ; Reset record length

        bl    @file.record.read     ; Read file record
              data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM 
                                    ; |           (without +9 offset!)
                                    ; | o  tmp0 = Status byte
                                    ; | o  tmp1 = Bytes read
                                    ; | o  tmp2 = Status register contents 
                                    ; /           upon DSRLNK return

        mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
        mov   tmp1,@fh.reclen       ; Save bytes read
        mov   tmp2,@fh.ioresult     ; Save status register contents
        ;------------------------------------------------------
        ; 1a: Calculate kilobytes processed
        ;------------------------------------------------------
        a     tmp1,@fh.counter    
        a     @fh.counter,tmp1
        ci    tmp1,1024
        jlt   !
        inc   @fh.kilobytes
        ai    tmp1,-1024            ; Remove KB portion and keep bytes
        mov   tmp1,@fh.counter
        ;------------------------------------------------------
        ; 1b: Load spectra scratchpad layout
        ;------------------------------------------------------
!       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300
        ;------------------------------------------------------
        ; 1c: Check if a file error occured
        ;------------------------------------------------------
fh.file.read.sams.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.read.sams.check_setpage 
                                    ; No, goto (1d)
        b     @fh.file.read.sams.error  
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; 1d: Check if SAMS page needs to be set
        ;------------------------------------------------------ 
fh.file.read.sams.check_setpage:        
        mov   @edb.next_free.ptr,tmp0
        bl    @xsams.page.get       ; Get SAMS page
                                    ; \ i  tmp0  = Memory address
                                    ; | o  waux1 = SAMS page number
                                    ; / o  waux2 = Address of SAMS register

        mov   @waux1,tmp0           ; Save SAMS page number
        c     tmp0,@fh.sams.page   ; Compare page with current SAMS page
        jeq   fh.file.read.sams.nocompression
                                    ; Same, skip to (2)
        ;------------------------------------------------------
        ; 1e: Increase SAMS page if necessary
        ;------------------------------------------------------ 
        c     tmp0,@fh.sams.hpage   ; Compare page with highest SAMS page
        jgt   fh.file.read.sams.switch
                                    ; Switch page
        ai    tmp0,5                ; Next range >b000 - ffff
        ;------------------------------------------------------
        ; 1f: Switch to SAMS page
        ;------------------------------------------------------ 
fh.file.read.sams.switch:        
        mov   @edb.next_free.ptr,tmp1
                                    ; Beginning of line

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        mov   tmp0,@fh.sams.page    ; Save current SAMS page 

        c     tmp0,@fh.sams.hpage   ; Current SAMS page > highest SAMS page?
        jle   fh.file.read.sams.nocompression
                                    ; No, skip to (2)
        mov   tmp0,@fh.sams.hpage   ; Update highest SAMS page
        ;------------------------------------------------------
        ; Step 2: Process line (without RLE compression)
        ;------------------------------------------------------
fh.file.read.sams.nocompression:
        li    tmp0,fh.vrecbuf       ; VDP source address
        mov   @edb.next_free.ptr,tmp1
                                    ; RAM target in editor buffer

        mov   tmp1,@parm2           ; Needed in step 4b (index update)

        mov   @fh.reclen,tmp2       ; Number of bytes to copy        
        jeq   fh.file.read.sams.prepindex.emptyline
                                    ; Handle empty line
        ;------------------------------------------------------
        ; 2a: Copy line from VDP to CPU editor buffer
        ;------------------------------------------------------         
                                    ; Save line prefix                                             
        movb  tmp2,*tmp1+           ; \ MSB to line prefix
        swpb  tmp2                  ; |
        movb  tmp2,*tmp1+           ; | LSB to line prefix
        swpb  tmp2                  ; / 
        
        inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
        a     tmp2,@edb.next_free.ptr
                                    ; Add line length 
        ;------------------------------------------------------
        ; 2b: Handle line split accross 2 consecutive SAMS pages
        ;------------------------------------------------------ 
        mov   tmp0,tmp3             ; Backup tmp0
        mov   tmp1,tmp4             ; Backup tmp1

        mov   tmp1,tmp0             ; Get pointer to beginning of line
        srl   tmp0,12               ; Only keep high-nibble

        mov   @edb.next_free.ptr,tmp1
                                    ; Get pointer to next line (aka end of line)
        srl   tmp1,12               ; Only keep high-nibble

        c     tmp0,tmp1             ; Are they in the same segment?
        jeq   !                     ; Yes, skip setting SAMS page

        mov   @fh.sams.page,tmp0    ; Get current SAMS page
        inc   tmp0                  ; Increase SAMS page
        mov   @edb.next_free.ptr,tmp1
                                    ; Get pointer to next line (aka end of line)

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address         

!       mov   tmp4,tmp1             ; Restore tmp1
        mov   tmp3,tmp0             ; Restore tmp0
        ;------------------------------------------------------
        ; 2c: Do actual copy
        ;------------------------------------------------------         
        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy
                                        
        jmp   fh.file.read.sams.prepindex
                                    ; Prepare for updating index
        ;------------------------------------------------------
        ; Step 4: Update index
        ;------------------------------------------------------
fh.file.read.sams.prepindex:
        mov   @edb.lines,@parm1     ; parm1 = Line number
                                    ; parm2 = Must allready be set!
        mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
                                    
        jmp   fh.file.read.sams.updindex
                                    ; Update index
        ;------------------------------------------------------
        ; 4a: Special handling for empty line
        ;------------------------------------------------------
fh.file.read.sams.prepindex.emptyline:
        mov   @fh.records,@parm1    ; parm1 = Line number
        dec   @parm1                ;         Adjust for base 0 index
        clr   @parm2                ; parm2 = Pointer to >0000
        seto  @parm3                ; parm3 = SAMS not used >FFFF
        ;------------------------------------------------------
        ; 4b: Do actual index update
        ;------------------------------------------------------                                    
fh.file.read.sams.updindex:                
        bl    @idx.entry.update     ; Update index 
                                    ; \ i  parm1    = Line num in editor buffer
                                    ; | i  parm2    = Pointer to line in editor 
                                    ; |               buffer 
                                    ; | i  parm3    = SAMS page
                                    ; | o  outparm1 = Pointer to updated index
                                    ; /               entry

        inc   @edb.lines            ; lines=lines+1                
        ;------------------------------------------------------
        ; Step 5: Display results
        ;------------------------------------------------------
fh.file.read.sams.display:
        mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Step 6: Check if reaching memory high-limit >ffa0
        ;------------------------------------------------------
fh.file.read.sams.checkmem:
        mov   @edb.next_free.ptr,tmp0
        ci    tmp0,>ffa0
        jle   fh.file.read.sams.next
        ;------------------------------------------------------
        ; 6a: Address range b000-ffff full, switch SAMS pages
        ;------------------------------------------------------
        li    tmp0,edb.top+2        ; Reset to top of editor buffer
        mov   tmp0,@edb.next_free.ptr
                                    
        jmp   fh.file.read.sams.next   
        ;------------------------------------------------------
        ; 6b: Next record
        ;------------------------------------------------------
fh.file.read.sams.next:        
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->2100, 2000->8300        
        

        ;-------------------------------------------------------
        ; ** TEMPORARY FIX for 4KB INDEX LIMIT **
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        ci    tmp0,2047
        jeq   fh.file.read.sams.eof

        b     @fh.file.read.sams.record
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
fh.file.read.sams.error:        
        mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   fh.file.read.sams.eof 
                                    ; All good. File closed by DSRLNK
        ;------------------------------------------------------
        ; File error occured
        ;------------------------------------------------------ 
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300

        bl    @mem.setup.sams.layout
                                    ; Restore SAMS default memory layout               

        mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.read.sams.exit
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
fh.file.read.sams.eof:        
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300

        bl    @mem.setup.sams.layout
                                    ; Restore SAMS default memory layout                                                                                  
        ;------------------------------------------------------
        ; Show "loading indicator 3" (final)
        ;------------------------------------------------------
        seto  @edb.dirty            ; Text changed in editor buffer!            

        mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
        bl    *tmp0                 ; Run callback function                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.read.sams.exit:
        b     @poprt                ; Return to caller






***************************************************************
* PAB for accessing DV/80 file
********|*****|*********************|**************************
fh.file.pab.header:
        byte  io.op.open            ;  0    - OPEN
        byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
        data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
        byte  80                    ;  4    - Record length (80 chars max)
        byte  00                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed recs)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
        ;------------------------------------------------------
        ; File descriptor part (variable length)
        ;------------------------------------------------------        
        ; byte  12                  ;  9    - File descriptor length
        ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor 
                                    ;         (Device + '.' + File name)          
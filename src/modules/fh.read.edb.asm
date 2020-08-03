* FILE......: fh.read.edb.asm
* Purpose...: File reader module

*//////////////////////////////////////////////////////////////
*                  Read file into editor buffer
*//////////////////////////////////////////////////////////////


***************************************************************
* fh.file.read.edb
* Read file into editor buffer
***************************************************************
*  bl   @fh.file.read.edb
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed file descriptor
* parm2 = Pointer to callback function "Before Open file"
* parm3 = Pointer to callback function "Read line from file"
* parm4 = Pointer to callback function "Close file"
* parm5 = Pointer to callback function "File I/O error"
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fh.file.read.edb:
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

        mov   @waux1,@fh.sams.page  ; Set current SAMS page
        mov   @waux1,@fh.sams.hipage
                                    ; Set highest SAMS page in use
        ;------------------------------------------------------
        ; Save parameters / callback functions
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.readfile
                                    ; We are going to read a file
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
         
        jmp   fh.file.read.edb.load1
                                    ; All checks passed, continue.
                                    ;-------------------------- 
                                    ; Check failed, crash CPU!
                                    ;--------------------------
fh.file.read.crash:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before Open file"
        ;------------------------------------------------------
fh.file.read.edb.load1:        
        mov   @fh.callback1,tmp0
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
fh.file.read.edb.pabheader:        
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
              data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        bl    @file.open
              data fh.vpab          ; Pass file descriptor to DSRLNK
        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.read.edb.record
        b     @fh.file.read.edb.error  
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Step 1: Read file record
        ;------------------------------------------------------
fh.file.read.edb.record:        
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
!       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / @scrpad.backup2 to >8300
        ;------------------------------------------------------
        ; 1c: Check if a file error occured
        ;------------------------------------------------------
fh.file.read.edb.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.read.edb.check_setpage 
                                    ; No, goto (1d)
        b     @fh.file.read.edb.error  
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; 1d: Check if SAMS page needs to be set
        ;------------------------------------------------------ 
fh.file.read.edb.check_setpage:        
        mov   @edb.next_free.ptr,tmp0
                                    ;--------------------------
                                    ; Sanity check
                                    ;-------------------------- 
        ci    tmp0,edb.top + edb.size
                                    ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!
                                    ;--------------------------
                                    ; Check overflow
                                    ;-------------------------- 
        andi  tmp0,>0fff            ; Get rid off highest nibble        
        a     @fh.reclen,tmp0       ; Add length of line just read
        inct  tmp0                  ; +2 for line prefix
        ci    tmp0,>1000 - 16       ; 4K boundary reached?
        jlt   fh.file.read.edb.process_line
                                    ; Not yet so skip SAMS page switch
        ;------------------------------------------------------
        ; 1e: Increase SAMS page
        ;------------------------------------------------------ 
        inc   @fh.sams.page         ; Next SAMS page
        mov   @fh.sams.page,@fh.sams.hipage
                                    ; Set highest SAMS page
        mov   @edb.top.ptr,@edb.next_free.ptr
                                    ; Start at top of SAMS page again
        ;------------------------------------------------------
        ; 1f: Switch to SAMS page
        ;------------------------------------------------------ 
        mov   @fh.sams.page,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Step 2: Process line
        ;------------------------------------------------------
fh.file.read.edb.process_line:
        li    tmp0,fh.vrecbuf       ; VDP source address
        mov   @edb.next_free.ptr,tmp1
                                    ; RAM target in editor buffer

        mov   tmp1,@parm2           ; Needed in step 4b (index update)

        mov   @fh.reclen,tmp2       ; Number of bytes to copy        
        jeq   fh.file.read.edb.prepindex.emptyline
                                    ; Handle empty line
        ;------------------------------------------------------
        ; 2a: Copy line from VDP to CPU editor buffer
        ;------------------------------------------------------         
                                    ; Put line length word before string
        movb  tmp2,*tmp1+           ; \ MSB to line prefix
        swpb  tmp2                  ; |
        movb  tmp2,*tmp1+           ; | LSB to line prefix
        swpb  tmp2                  ; / 
        
        inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
        a     tmp2,@edb.next_free.ptr
                                    ; Add line length         

        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy                                        
        ;------------------------------------------------------
        ; 2b: Align pointer to multiple of 16 memory address
        ;------------------------------------------------------ 
        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; Step 3: Update index
        ;------------------------------------------------------
fh.file.read.edb.prepindex:
        mov   @edb.lines,@parm1     ; parm1 = Line number
                                    ; parm2 = Must allready be set!
        mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
                                    
        jmp   fh.file.read.edb.updindex
                                    ; Update index
        ;------------------------------------------------------
        ; 3a: Special handling for empty line
        ;------------------------------------------------------
fh.file.read.edb.prepindex.emptyline:
        mov   @fh.records,@parm1    ; parm1 = Line number
        dec   @parm1                ;         Adjust for base 0 index
        clr   @parm2                ; parm2 = Pointer to >0000
        seto  @parm3                ; parm3 = SAMS not used >FFFF
        ;------------------------------------------------------
        ; 3b: Do actual index update
        ;------------------------------------------------------                                    
fh.file.read.edb.updindex:                
        bl    @idx.entry.update     ; Update index 
                                    ; \ i  parm1    = Line num in editor buffer
                                    ; | i  parm2    = Pointer to line in editor 
                                    ; |               buffer 
                                    ; | i  parm3    = SAMS page
                                    ; | o  outparm1 = Pointer to updated index
                                    ; /               entry

        inc   @edb.lines            ; lines=lines+1                
        ;------------------------------------------------------
        ; Step 4: Callback "Read line from file"
        ;------------------------------------------------------
fh.file.read.edb.display:
        mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; 4a: Next record
        ;------------------------------------------------------
fh.file.read.edb.next:        
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->xxxx, xxxx->8300        

        b     @fh.file.read.edb.record
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
fh.file.read.edb.error:        
        mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   fh.file.read.edb.eof 
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
        jmp   fh.file.read.edb.exit
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
fh.file.read.edb.eof:        
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
fh.file.read.edb.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


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
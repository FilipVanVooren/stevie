* FILE......: fh.file.read.edb.asm
* Purpose...: File reader module

***************************************************************
* fh.file.read.edb
* Read or insert file into editor buffer
***************************************************************
*  bl   @fh.file.read.edb
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
* parm2 = Pointer to callback function "Before Open file"
* parm3 = Pointer to callback function "Read line from file"
* parm4 = Pointer to callback function "Close file"
* parm5 = Pointer to callback function "File I/O error"
* parm6 = Pointer to callback function "Memory full"
* parm7 = Line number to insert file at or >FFFF if new file.
* parm8 = Work mode
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
* @fh.temp1 =  >ffff if loading new file into editor buffer
*              >0000 if inserting file at line in editor buffer
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
        dect  stack
        mov   tmp3,*stack           ; Push tmp3

        dect  stack
        mov   @fh.offsetopcode,*stack
                                    ; Push FastMode IO status          
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------  
        clr   @fh.records           ; Reset records counter
        clr   @fh.counter           ; Clear internal counter
        clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
        clr   @fh.ioresult          ; Clear status register contents
       
        mov   @edb.top.ptr,tmp0
        bl    @xsams.page.get       ; Get SAMS page
                                    ; \ i  tmp0  = Memory address
                                    ; | o  waux1 = SAMS page number
                                    ; / o  waux2 = Address of SAMS register
                                    
        mov   @edb.sams.hipage,tmp0 ; \
        mov   tmp0,@fh.sams.hipage  ; | Set current SAMS page to highest page 
                                    ; / used by Editor Buffer

        mov   tmp0,@tv.sams.c000    ; Sync SAMS window. Important!                                    

        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address                                    
        ;------------------------------------------------------
        ; Save parameters / callback functions
        ;------------------------------------------------------
        li    tmp0,fh.fopmode.readfile
                                    ; We are going to read a file
        mov   tmp0,@fh.fopmode      ; Set file operations mode

        mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
        mov   @parm2,@fh.callback1  ; Callback function "Open file"
        mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
        mov   @parm4,@fh.callback3  ; Callback function "Close file"
        mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
        mov   @parm6,@fh.callback5  ; Callback function "Memory full error"
        mov   @parm8,@fh.workmode   ; Work mode (used in callbacks)
        ;------------------------------------------------------
        ; Determine if inserting file or loading new file
        ;------------------------------------------------------
        mov   @parm7,tmp0
        ci    tmp0,>ffff            ; Load file?
        jeq   fh.file.read.edb.newfile

        clr   @fh.temp1             ; Set flag "insert file"
        clr   @fh.temp2             ; Not used
        clr   @fh.temp3             ; Not used

        mov   tmp0,@fh.line         ; Line to insert file at
        jmp   fh.file.read.edb.assert1
        ;------------------------------------------------------
        ; Loading new file into editor buffer
        ;------------------------------------------------------
fh.file.read.edb.newfile:
        clr   @fh.line              ; New file 
        seto  @fh.temp1             ; Set flag "load file"
        clr   @fh.temp2             ; Not used
        clr   @fh.temp3             ; Not used
        ;------------------------------------------------------
        ; Asserts
        ;------------------------------------------------------
fh.file.read.edb.assert1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.read.edb.assert2
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

fh.file.read.edb.assert2
        mov   @fh.callback2,tmp0
        jeq   fh.file.read.edb.assert3
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

fh.file.read.edb.assert3:
        mov   @fh.callback3,tmp0
        jeq   fh.file.read.edb.assert4
        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

fh.file.read.edb.assert4:         
        mov   @fh.callback4,tmp0
        jeq   fh.file.read.edb.assert5

        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

fh.file.read.edb.assert5:
        mov   @fh.callback5,tmp0
        jeq   fh.file.read.edb.load1

        ci    tmp0,>6000            ; Insane address ?
        jlt   fh.file.read.crash    ; Yes, crash!
        ci    tmp0,>7fff            ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!

        jmp   fh.file.read.edb.load1
                                    ; All checks passed, continue
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
fh.file.read.crash:                                    
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Callback "Before Open file"
        ;------------------------------------------------------
fh.file.read.edb.load1:        
        mov   @fh.callback1,tmp0
        jeq   fh.file.read.edb.pabheader
                                    ; Skip callback
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

        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
fh.file.read.edb.open:
        bl    @file.open            ; Open file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
              data io.seq.inp.dis.var
                                    ; / i  p1 = File type/mode
                                    
        coc   @wbit2,tmp2           ; Equal bit set?
        jne   fh.file.read.edb.check_setpage
                                    ; No error, continue processing file (1a)
        ;------------------------------------------------------
        ; File error. Check FastMode IO on unsupported device
        ;------------------------------------------------------
        abs   @fh.offsetopcode      ; FastMode IO on ?
        jeq   fh.file.read.edb.err  ; Is off, do not retry open
        clr   @fh.offsetopcode      ; Turn FastMode IO off
        ;------------------------------------------------------
        ; File error while FastMode IO is on, retry
        ;------------------------------------------------------
        jmp   fh.file.read.edb.open ; Retry
        ;------------------------------------------------------
        ; Need to error out, no retry possible.
        ;------------------------------------------------------
fh.file.read.edb.err:
        b     @fh.file.read.edb.error  
                                    ; IO error occured
        ;------------------------------------------------------
        ; 1a: Check if SAMS page needs to be increased
        ;------------------------------------------------------ 
fh.file.read.edb.check_setpage:
        mov   @edb.next_free.ptr,tmp0
                                    ;--------------------------
                                    ; Assert
                                    ;-------------------------- 
        ci    tmp0,edb.top + edb.size
                                    ; Insane address ?
        jgt   fh.file.read.crash    ; Yes, crash!
                                    ;--------------------------
                                    ; Check for page overflow
                                    ;-------------------------- 
        andi  tmp0,>0fff            ; Get rid of highest nibble        
        ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
        ci    tmp0,>1000 - 16       ; 4K boundary reached?
        jlt   fh.file.read.edb.record
                                    ; Not yet so skip SAMS page switch
        ;------------------------------------------------------
        ; 1b: Increase SAMS page
        ;------------------------------------------------------ 
        inc   @fh.sams.hipage       ; Set highest SAMS page
        mov   @edb.top.ptr,@edb.next_free.ptr
                                    ; Start at top of SAMS page again
        ;------------------------------------------------------
        ; 1c: Switch to SAMS page
        ;------------------------------------------------------ 
        mov   @fh.sams.hipage,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        mov   @fh.sams.hipage,@tv.sams.c000
                                    ; Sync SAMS window. Important!                                    
        ;------------------------------------------------------
        ; 1d: Fill new SAMS page with garbage (debug only)
        ;------------------------------------------------------ 
        ; bl  @film
        ;     data >c000,>99,4092
        ;------------------------------------------------------
        ; Step 2: Read file record
        ;------------------------------------------------------
fh.file.read.edb.record:        
        inc   @fh.records           ; Update counter        
        clr   @fh.reclen            ; Reset record length

        abs   @fh.offsetopcode
        jeq   !                     ; Skip CPU buffer logic if offset = 0
        ;------------------------------------------------------
        ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
        ;------------------------------------------------------
        mov   @edb.next_free.ptr,tmp1
        inct  tmp1
        li    tmp0,fh.vpab + 2

        ori   tmp0,>4000            ; Prepare VDP address for write
        swpb  tmp0                  ; \
        movb  tmp0,@vdpa            ; | Set VDP write address
        swpb  tmp0                  ; | inlined @vdwa call
        movb  tmp0,@vdpa            ; / 

        movb  tmp1,*r15             ; Write MSB
        swpb  tmp1
        movb  tmp1,*r15             ; Write LSB
        ;------------------------------------------------------
        ; 2b: Read file record
        ;------------------------------------------------------
!       bl    @file.record.read     ; Read file record
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
        ; 2c: Calculate kilobytes processed
        ;------------------------------------------------------
        a     tmp1,@fh.counter      ; Add record length to counter
        mov   @fh.counter,tmp1      ;
        ci    tmp1,1024             ; 1 KB boundary reached ?
        jlt   fh.file.read.edb.check_fioerr
                                    ; Not yet, goto (2d)
        inc   @fh.kilobytes
        ai    tmp1,-1024            ; Remove KB portion, only keep bytes
        mov   tmp1,@fh.counter      ; Update counter
        ;------------------------------------------------------
        ; 2d: Check if a file error occured
        ;------------------------------------------------------
fh.file.read.edb.check_fioerr:     
        mov   @fh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   fh.file.read.edb.insertline
                                    ; No, goto (2e)
        b     @fh.file.read.edb.error  
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; 2e: Check if we need to insert index entry
        ;------------------------------------------------------ 
fh.file.read.edb.insertline:
        mov   @fh.temp1,tmp0        ; \ Is flag "new file" set?
        ci    tmp0,>ffff            ; /
        jeq   fh.file.read.edb.process_line
                                    ; Flag is set, so just load file
        ;------------------------------------------------------
        ; 2f: Insert new index entry (index reorg)
        ;------------------------------------------------------ 
        mov   @fh.line,@parm1      
        mov   @edb.lines,@parm2
        bl    @idx.entry.insert     ; Reorganize index
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg
        ;------------------------------------------------------
        ; Step 3: Process line
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
        ; 3a: Set length of line in CPU editor buffer
        ;------------------------------------------------------
        clr   *tmp1                 ; Clear word before string
        inc   tmp1                  ; Adjust position for length byte string
        movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
       
        inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
        a     tmp2,@edb.next_free.ptr
                                    ; Add line length 

        abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
        jne   fh.file.read.edb.preppointer         
        ;------------------------------------------------------
        ; 3b: Copy line from VDP to CPU editor buffer
        ;------------------------------------------------------
fh.file.read.edb.vdp2cpu:        
        ; 
        ; Executed for devices that need their disk buffer in VDP memory
        ; (TI Disk Controller, tipi, nanopeb, ...).
        ; 
        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ i  tmp0 = VDP source address
                                    ; | i  tmp1 = RAM target address
                                    ; / i  tmp2 = Bytes to copy                                                                            
        ;------------------------------------------------------
        ; 3c: Align pointer for next line
        ;------------------------------------------------------ 
fh.file.read.edb.preppointer:        
        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; Step 4: Update index
        ;------------------------------------------------------
fh.file.read.edb.prepindex:
        mov   @fh.line,@parm1       ; parm1 = Line number
                                    ; parm2 = Must allready be set!
        mov   @fh.sams.hipage,@parm3
                                    ; parm3 = SAMS page number
                                    
        jmp   fh.file.read.edb.updindex
                                    ; Update index
        ;------------------------------------------------------
        ; 4a: Special handling for empty line
        ;------------------------------------------------------
fh.file.read.edb.prepindex.emptyline:
        mov   @fh.line,@parm1       ; parm1 = Line number
        clr   @parm2                ; parm2 = Pointer to >0000
        seto  @parm3                ; parm3 = SAMS not used >FFFF
        ;------------------------------------------------------
        ; 4b: Do actual index update
        ;------------------------------------------------------                                    
fh.file.read.edb.updindex:                
        bl    @idx.entry.update     ; Update index 
                                    ; \ i  parm1    = Line num in editor buffer
                                    ; | i  parm2    = Pointer to line in EB
                                    ; | i  parm3    = SAMS page
                                    ; | o  outparm1 = Pointer to updated index
                                    ; /               entry     
        ;------------------------------------------------------
        ; Step 5: Callback "Read line from file"
        ;------------------------------------------------------
fh.file.read.edb.display:
        mov   @fh.callback2,tmp0    ; Get pointer to Callback
                                    ;   "Read line from file"
        jeq   fh.file.read.edb.next
                                    ; Skip callback        
        bl    *tmp0                 ; Run callback function                                    
        ;------------------------------------------------------
        ; 5a: Prepare for next record
        ;------------------------------------------------------
fh.file.read.edb.next:
        inc   @fh.line              ; lines++
        inc   @edb.lines            ; total lines++

        mov   @edb.lines,tmp0
        ci    tmp0,10200            ; Maximum line in index reached?
        jle   fh.file.read.edb.check.interrupt
                                    ; Not yet, next record
        ;------------------------------------------------------
        ; 5b: Index memory full. Close file and exit
        ;------------------------------------------------------
        bl    @file.close           ; Close file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
                                    ; /

        bl    @mem.sams.setup.stevie
                                    ; Restore SAMS windows
        ;------------------------------------------------------
        ; Callback "Memory full error"
        ;------------------------------------------------------
        mov   @fh.callback5,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.read.edb.exit ; Skip callback
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.read.edb.exit
        ;------------------------------------------------------
        ; 5c: Check for keyboard interrupt <FCTN-4>
        ;------------------------------------------------------
fh.file.read.edb.check.interrupt:
        bl    @>0020                ; Check keyboard. Destroys r12
        jne   !                     ; No FCTN-4 pressed
        ;------------------------------------------------------
        ; Interrupt occured
        ;------------------------------------------------------
        li    tmp0,id.file.interrupt ; \ Set flag "keyboard interrupt" occured
        mov   tmp0,@fh.workmode      ; /

        mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.read.edb.exit ; Skip callback
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.read.edb.exit
        ;------------------------------------------------------
        ; 5d: Next record
        ;------------------------------------------------------
!       b     @fh.file.read.edb.check_setpage
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
fh.file.read.edb.error:        
        mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
        ;------------------------------------------------------
        ; File error occured
        ;------------------------------------------------------ 
        bl    @file.close           ; Close file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
                                    ; /

        bl    @mem.sams.setup.stevie
                                    ; Restore SAMS windows
        ;------------------------------------------------------
        ; Callback "File I/O error"
        ;------------------------------------------------------
        mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
        jeq   fh.file.read.edb.exit ; Skip callback
        bl    *tmp0                 ; Run callback function  
        jmp   fh.file.read.edb.exit
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
fh.file.read.edb.eof:
        bl    @file.close           ; Close file
              data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
                                    ; /

        bl    @mem.sams.setup.stevie
                                    ; Restore SAMS windows
        ;------------------------------------------------------
        ; Callback "Close file"
        ;------------------------------------------------------
        mov   @fh.temp1,tmp0        ; Insert file or load file?
        ci    tmp0,>ffff
        jne   fh.file.read.edb.eof.callback
                                    ; Insert file, skip to callback
        dec   @edb.lines            ; Load file, one-time adjustment

fh.file.read.edb.eof.callback:
        mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
        jeq   fh.file.read.edb.exit ; Skip callback
        bl    *tmp0                 ; Run callback function                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.read.edb.exit:
        mov   @fh.sams.hipage,@edb.sams.hipage 
                                    ; Set highest SAMS page in use
        clr   @fh.fopmode           ; Set FOP mode to idle operation

        bl    @film
              data >83a0,>00,96     ; Clear any garbage left-over by DSR calls.


        mov   *stack+,@fh.offsetopcode
                                    ; Pop @fh.offsetopcode                                
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

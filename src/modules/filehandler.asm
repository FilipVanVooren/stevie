* FILE......: filehandler.asm
* Purpose...: File handling module

*//////////////////////////////////////////////////////////////
*                     Load and save files
*//////////////////////////////////////////////////////////////


***************************************************************
* tfh.file.read
* Read file into editor buffer
***************************************************************
*  bl   @tfh.file.read
*--------------------------------------------------------------
* INPUT
* parm1 = pointer to length-prefixed file descriptor
* parm2 = RLE compression on (>FFFF) or off (>0000) 
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
*--------------------------------------------------------------
* The frame buffer is temporarily used for compressing the line
* before it is moved to the editor buffer
********|*****|*********************|**************************
tfh.file.read:
        dect  stack
        mov   r11,*stack            ; Save return address
        mov   @parm2,@tfh.rleonload ; Save RLE compression wanted status
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @tfh.records          ; Reset records counter
        clr   @tfh.counter          ; Clear internal counter
        clr   @tfh.kilobytes        ; Clear kilobytes processed
        clr   tmp4                  ; Clear kilobytes processed display counter        
        clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
        clr   @tfh.ioresult         ; Clear status register contents
        ;------------------------------------------------------
        ; Show loading indicators and file descriptor
        ;------------------------------------------------------
        bl    @hchar
              byte 29,0,32,80
              data EOL
        
        bl    @putat
              byte 29,0
              data txt_loading      ; Display "Loading...."

        c     @tfh.rleonload,@w$ffff
        jne   !                                           
        bl    @putat
              byte 29,68
              data txt_rle          ; Display "RLE"

!       bl    @at
              byte 29,11            ; Cursor YX position
        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename
        ;------------------------------------------------------
        ; Copy PAB header to VDP
        ;------------------------------------------------------
        bl    @cpym2v
              data tfh.vpab,tfh.file.pab.header,9
                                    ; Copy PAB header to VDP
        ;------------------------------------------------------
        ; Append file descriptor to PAB header in VDP
        ;------------------------------------------------------
        li    tmp0,tfh.vpab + 9     ; VDP destination        
        mov   @parm1,tmp1           ; Get pointer to file descriptor
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
              data tfh.vpab         ; Pass file descriptor to DSRLNK
        coc   @wbit2,tmp2           ; Equal bit set?
        jne   tfh.file.read.record
        b     @tfh.file.read.error  ; Yes, IO error occured
        ;------------------------------------------------------
        ; Step 1: Read file record
        ;------------------------------------------------------
tfh.file.read.record:        
        inc   @tfh.records          ; Update counter        
        clr   @tfh.reclen           ; Reset record length

        bl    @file.record.read     ; Read file record
              data tfh.vpab         ; \ .  p0   = Address of PAB in VDP RAM (without +9 offset!)
                                    ; | o  tmp0 = Status byte
                                    ; | o  tmp1 = Bytes read
                                    ; / o  tmp2 = Status register contents upon DSRLNK return

        mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
        mov   tmp1,@tfh.reclen      ; Save bytes read
        mov   tmp2,@tfh.ioresult    ; Save status register contents
        ;------------------------------------------------------
        ; 1a: Calculate kilobytes processed
        ;------------------------------------------------------
        a     tmp1,@tfh.counter    
        a     @tfh.counter,tmp1
        ci    tmp1,1024
        jlt   !
        inc   @tfh.kilobytes
        ai    tmp1,-1024            ; Remove KB portion and keep bytes
        mov   tmp1,@tfh.counter
        ;------------------------------------------------------
        ; 1b: Load spectra scratchpad layout
        ;------------------------------------------------------
!       bl    @cpu.scrpad.backup    ; Backup GPL layout to >2000
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300
        ;------------------------------------------------------
        ; 1c: Check if a file error occured
        ;------------------------------------------------------
tfh.file.read.check:     
        mov   @tfh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jne   !                     ; No, goto (1d)
        b     @tfh.file.read.error  ; Yes, so handle file error
        ;------------------------------------------------------
        ; 1d: Decide on copy line from VDP buffer to editor
        ;     buffer (RLE off) or RAM buffer (RLE on)
        ;------------------------------------------------------
!       c     @tfh.rleonload,@w$ffff
                                    ; RLE compression on?
        jeq   tfh.file.read.compression
                                    ; Yes, do RLE compression
        ;------------------------------------------------------
        ; Step 2: Process line without doing RLE compression
        ;------------------------------------------------------
tfh.file.read.nocompression:        
        li    tmp0,tfh.vrecbuf      ; VDP source address
        mov   @edb.next_free.ptr,tmp1
                                    ; RAM target in editor buffer

        mov   tmp1,@parm2           ; Needed in step 4b (index update)

        mov   @tfh.reclen,tmp2      ; Number of bytes to copy        
        jeq   tfh.file.read.prepindex.emptyline
                                    ; Handle empty line
        ;------------------------------------------------------
        ; 2a: Copy line from VDP to CPU editor buffer
        ;------------------------------------------------------         
        mov   tmp0,tmp3             ; Backup tmp0
        mov   tmp1,tmp4             ; Backup tmp1
        mov   @edb.samspage,tmp0    ; Current SAMS page
        bl    @xsams.page           ; Switch to SAMS page
                                    ; \ . tmp0 = SAMS page
                                    ; / . tmp1 = Memory address        
        mov   tmp4,tmp1             ; Restore tmp1
        mov   tmp3,tmp0             ; Restore tmp0

                                    ; Save line prefix                                             
        movb  tmp2,*tmp1+           ; \ MSB to line prefix
        swpb  tmp2                  ; |
        movb  tmp2,*tmp1+           ; | LSB to line prefix
        swpb  tmp2                  ; / 
        
        inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
        a     tmp2,@edb.next_free.ptr
                                    ; Add line length 

        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ .  tmp0 = VDP source address
                                    ; | .  tmp1 = RAM target address
                                    ; / .  tmp2 = Bytes to copy
                                        
        jmp   tfh.file.read.prepindex
                                    ; Prepare for updating index
        ;------------------------------------------------------
        ; Step 3: Process line and do RLE compression
        ;------------------------------------------------------
tfh.file.read.compression:         
        li    tmp0,tfh.vrecbuf      ; VDP source address        
        li    tmp1,fb.top           ; RAM target address 
        mov   @tfh.reclen,tmp2      ; Number of bytes to copy        
        jeq   tfh.file.read.prepindex.emptyline
                                    ; Handle empty line

        bl    @xpyv2m               ; Copy memory block from VDP to CPU
                                    ; \ .  tmp0 = VDP source address
                                    ; | .  tmp1 = RAM target address
                                    ; / .  tmp2 = Bytes to copy

        ;------------------------------------------------------
        ; 3a: RLE compression on line
        ;------------------------------------------------------
        li    tmp0,fb.top           ; RAM source of uncompressed line
        li    tmp1,fb.top+160       ; RAM target for compressed line
        mov   @tfh.reclen,tmp2      ; Length of string

        bl    @xcpu2rle             ; RLE compression
                                    ; \ .  tmp0  = ROM/RAM source address
                                    ; | .  tmp1  = RAM target address
                                    ; | .  tmp2  = Length uncompressed data
                                    ; / o  waux1 = Length RLE encoded string
        ;------------------------------------------------------
        ; 3b: Set line prefix
        ;------------------------------------------------------                
        mov   @edb.next_free.ptr,tmp1
                                    ; RAM target address
        mov   tmp1,@parm2           ; Pointer to line in editor buffer
        mov   @waux1,tmp2           ; Length of RLE compressed string        
        swpb  tmp2                  ; 
        movb  tmp2,*tmp1+           ; Length byte to line prefix

        mov   @tfh.reclen,tmp2      ; Length of uncompressed string
        swpb  tmp2 
        movb  tmp2,*tmp1+           ; Length byte to line prefix
        inct  @edb.next_free.ptr    ; Keep pointer synced
        ;------------------------------------------------------
        ; 3c: Copy compressed line to editor buffer
        ;------------------------------------------------------
        li    tmp0,fb.top+160       ; RAM source address        
        mov   @waux1,tmp2           ; Length of RLE compressed string                

        bl    @xpym2m               ; Copy memory block from CPU to CPU
                                    ; \ .  tmp0 = RAM source address
                                    ; | .  tmp1 = RAM target address
                                    ; / .  tmp2 = Bytes to copy

        a     @waux1,@edb.next_free.ptr
                                    ; Update pointer to next free line
        ;------------------------------------------------------
        ; Step 4: Update index
        ;------------------------------------------------------
tfh.file.read.prepindex:
        mov   @edb.lines,@parm1     ; parm1 = Line number
                                    ; parm2 = Must allready be set!
        jmp   tfh.file.read.updindex
                                    ; Update index
        ;------------------------------------------------------
        ; 4a: Special handling for empty line
        ;------------------------------------------------------
tfh.file.read.prepindex.emptyline:
        mov   @tfh.records,@parm1   ; parm1 = Line number
        dec   @parm1                ;         Adjust for base 0 index
        clr   @parm2                ; parm2 = Pointer to >0000
        ;------------------------------------------------------
        ; 4b: Do actual index update
        ;------------------------------------------------------
tfh.file.read.updindex:
        clr   @parm3
        bl    @idx.entry.update     ; Update index 
                                    ; \ .  parm1    = Line number in editor buffer
                                    ; | .  parm2    = Pointer to line in editor buffer 
                                    ; | .  parm3    = SAMS page
                                    ; / o  outparm1 = Pointer to updated index entry

        inc   @edb.lines            ; lines=lines+1                
        ;------------------------------------------------------
        ; Step 5: Display results
        ;------------------------------------------------------
tfh.file.read.display:
        bl    @putnum
              byte 29,73            ; Show lines read
              data edb.lines,rambuf,>3020

        c     @tfh.kilobytes,tmp4
        jeq   tfh.file.read.checkmem

        mov   @tfh.kilobytes,tmp4   ; Save for compare

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data tfh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt_kb           ; Show "kb" string

******************************************************
* Stop reading file if high memory expansion gets full
******************************************************
tfh.file.read.checkmem:
        mov   @edb.next_free.ptr,tmp0
        ci    tmp0,>ffa0
        jle   tfh.file.read.next

        li    tmp0,8
        mov   tmp0,@edb.samspage    ; Next SAMS page
        li    tmp0,edb.top
        mov   tmp0,@edb.next_free.ptr
        jmp   tfh.file.read.next   

        jmp   tfh.file.read.eof     ; NO SAMS SUPPORT FOR NOW
        ;------------------------------------------------------
        ; Next SAMS page
        ;------------------------------------------------------
        inc   @edb.next_free.page   ; Next SAMS page
        li    tmp0,edb.top
        mov   tmp0,@edb.next_free.ptr
                                    ; Reset to top of editor buffer
        ;------------------------------------------------------
        ; Next record
        ;------------------------------------------------------
tfh.file.read.next:        
        bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->2100, 2000->8300        

        b     @tfh.file.read.record
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
tfh.file.read.error:        
        mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   tfh.file.read.eof
                                    ; All good. File closed by DSRLNK
        ;------------------------------------------------------
        ; File error occured
        ;------------------------------------------------------     
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @crash                ; / Crash and halt system
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
tfh.file.read.eof:        
        bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300
        ;------------------------------------------------------
        ; Display final results
        ;------------------------------------------------------
        bl    @hchar
              byte 29,0,32,10       ; Erase loading indicator
              data EOL

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data tfh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt_kb           ; Show "kb" string

        bl    @putnum
              byte 29,73            ; Show lines read
              data tfh.records,rambuf,>3020

        seto  @edb.dirty            ; Text changed in editor buffer!
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
tfh.file.read_exit:
        b     @poprt                ; Return to caller


***************************************************************
* PAB for accessing DV/80 file
********|*****|*********************|**************************
tfh.file.pab.header:
        byte  io.op.open            ;  0    - OPEN
        byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
        data  tfh.vrecbuf           ;  2-3  - Record buffer in VDP memory
        byte  80                    ;  4    - Record length (80 characters maximum)
        byte  00                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed records)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
        ;------------------------------------------------------
        ; File descriptor part (variable length)
        ;------------------------------------------------------        
        ; byte  12                  ;  9    - File descriptor length
        ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor (Device + '.' + File name) 
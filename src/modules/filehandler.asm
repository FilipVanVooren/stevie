* FILE......: filehandler.asm
* Purpose...: File handling module

*//////////////////////////////////////////////////////////////
*                     Load and save files
*//////////////////////////////////////////////////////////////

;--------------------------------------------------------------
; VDP space for PAB and file buffer
;--------------------------------------------------------------
vpab    equ   >0300                 ; VDP PAB    @>0300
vrecbuf equ   >0400                 ; VDP Buffer @>0400


***************************************************************
* tfh.file.dv80.read
* Read DIS/VAR 80 file into editor buffer
***************************************************************
*  bl   @tfh.file.dv80.read
*--------------------------------------------------------------
* INPUT
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
* Memory usage
********@*****@*********************@**************************
tfh.file.dv80.read:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @tfh.records          ; Reset records counter
        clr   @tfh.counter          ; Clear internal counter
        clr   @tfh.kilobytes        ; Clear kilobytes processed
        clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
        clr   @tfh.ioresult         ; Clear status register contents

        bl    @cpym2v
              data vpab,pab,25      ; Copy PAB to VDP
        ;------------------------------------------------------
        ; Load GPL scratchpad layout
        ;------------------------------------------------------
        bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->2100, 2000->8300
        ;------------------------------------------------------
        ; Open DV/80 file
        ;------------------------------------------------------
        bl    @file.open
              data vpab             ; Pass file descriptor to DSRLNK
        coc   @wbit2,tmp2           ; Equal bit set?
        jeq   tfh.file.dv80.read.error
                                    ; Yes, IO error occured
        ;------------------------------------------------------
        ; Read DV/80 file record
        ;------------------------------------------------------
tfh.file.dv80.read.record:        
        inc   @tfh.records          ; Update counter        
        clr   @tfh.reclen           ; Reset record length

        bl    @file.record.read     ; Read record
              data vpab             ; tmp0=Status byte
                                    ; tmp1=Bytes read
                                    ; tmp2=Status register contents upon DSRLNK return

        mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
        mov   tmp1,@tfh.reclen      ; Save bytes read
        mov   tmp2,@tfh.ioresult    ; Save status register contents
        ;------------------------------------------------------
        ; Calculate kilobytes processed
        ;------------------------------------------------------
        a     tmp1,@tfh.counter    
        a     @tfh.counter,tmp1
        ci    tmp1,1024
        jlt   tfh.file.dv80.read.display
        inc   @tfh.kilobytes
        ai    tmp1,-1024            ; Remove KB portion and keep bytes
        mov   tmp1,@tfh.counter
        ;------------------------------------------------------
        ; Load spectra scratchpad layout
        ;------------------------------------------------------
tfh.file.dv80.read.display:
        bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
        bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300
        ;------------------------------------------------------
        ; Display results
        ;------------------------------------------------------
        bl    @putnum
              byte 10,0
              data tfh.records,rambuf,>3020

        bl    @putnum
              byte 10,7
              data tfh.reclen,rambuf,>3020

        bl    @putnum
              byte 10,14
              data tfh.kilobytes,rambuf,>3020
        ;------------------------------------------------------
        ; Check if a file error occured
        ;------------------------------------------------------
tfh.file.dv80.read.check:     
        mov   @tfh.ioresult,tmp2   
        coc   @wbit2,tmp2           ; IO error occured?
        jeq   tfh.file.dv80.read.error
                                    ; Yes, so handle file error
        ;------------------------------------------------------
        ; Copy record to CPU memory
        ;------------------------------------------------------
;       li    tmp0,vrecbuf          ; VDP source address
;       mov   tmp4,tmp1             ; RAM target address 
;       mov   @reclen,tmp2          ; Number of bytes to copy
;       bl    @xpyv2m               ; Copy memory
        ;------------------------------------------------------
        ; Load GPL scratchpad layout again
        ;------------------------------------------------------
        bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data scrpad.backup2   ; / 8300->2100, 2000->8300        

        jmp   tfh.file.dv80.read.record
                                    ; Next record
        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
tfh.file.dv80.read.error:        
        mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   tfh.file.dv80.read.eof
                                    ; All good. File closed by DSRLNK 
        b     @crash_handler        ; A File error occured. System crashed
        ;------------------------------------------------------
        ; End-Of-File reached
        ;------------------------------------------------------     
tfh.file.dv80.read.eof:        
        bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data scrpad.backup2   ; / >2100->8300
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
tfh.file.dv80.read_exit:
        b     @poprt                ; Return to caller
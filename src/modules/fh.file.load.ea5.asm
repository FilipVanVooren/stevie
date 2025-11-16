* FILE......: fh.file.load.ea5.asm
* Purpose...: Load binary file into memory

***************************************************************
* fh.file.load.ea5
* Load binary file into memory
***************************************************************
*  bl   @fh.file.load.ea5
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed filename descriptor
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Entry point address of EA5 program image or
*            >FFFF if load failed
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
        dect  stack
        mov   @parm1,*stack         ; Push @parm1    
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------ 
        clr   @fh.ea5.startaddr     ; Clear EA5 start address

        bl    @hchar
              byte 0,70,32,10       ; Remove any left-over junk on top line
              data eol            
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /
        ;------------------------------------------------------
        ; Step 1: Set parameters
        ;------------------------------------------------------ 
fh.file.load.ea5.parm:        
        li    tmp0,fm.load.ea5.cb.indicator1
        mov   tmp0,@parm2           ; Set callback "before loading image"
        li    tmp0,fm.load.ea5.cb.indicator2
        mov   tmp0,@parm3           ; Set callback "image loaded"
        li    tmp0,fm.load.ea5.cb.fioerr
        mov   tmp0,@parm4           ; Set callback "File I/O error"

        li    tmp0,fh.ea5.vdpbuf    ; \ Set VDP destination address
        mov   tmp0,@parm5           ; / 
        seto  @parm6                ; Skip VRAM to RAM copy (>FFFF)

        li    tmp0,8192
        mov   tmp0,@parm7           ; Set maxmimum number of bytes to load
        ;-------------------------------------------------------
        ; Step 2: Load EA5 image chunk into memory
        ;-------------------------------------------------------
fh.file.load.ea5.load:        
        bl    @fh.file.load.bin     ; Load binary image into memory
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "before loading image"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "image loaded"
                                    ; | i  @parm4 = Pointer to callback
                                    ; |             "File I/O error"
                                    ; | i  @parm5 = VDP destination address
                                    ; | i  @parm6 = RAM destination address
                                    ; |             (>FFFF to skip)
                                    ; | i  @parm7 = Maximum number of bytes to load
                                    ; | o  @outparm1 = >0000 success, >FFFF failed
                                    ; /

        mov   @outparm1,tmp0        ; \
        ci    tmp0,>ffff            ; | Exit early if file could not be loaded
        jeq   fh.file.load.ea5.exit ; /

        bl    @cpyv2m               ; Copy EA5 image chunk header from VDP to RAM
              data fh.ea5.vdpbuf    ; \ i  p1 = Source VDP address
              data rambuf           ; | i  p2 = Destination RAM address
              data 6                ; / i  p3 = Number of bytes to copy
        
        mov   @rambuf,@fh.ea5.nextflag
                                    ; Next EA5 image chunk neeeded flag

        li    tmp0,fh.ea5.vdpbuf+6  ; Get VRAM source address for copy  
        mov   tmp0,@fh.ea5.vdpsrc   ; Store VDP source address
        mov   @rambuf+4,tmp1        ; Get RAM destination for copy        
        mov   tmp1,@fh.ea5.ramtgt   ; Store RAM target address        
        mov   @rambuf+2,tmp2        ; Get number of bytes to copy        
        mov   tmp2,@fh.ea5.size     ; Store chunk size
        ;-------------------------------------------------------
        ; Step 2: Copy EA5 image chunk from VRAM to RAM
        ;-------------------------------------------------------
        andi  tmp1,>F000            ; Get SAMS destination bank
        srl   tmp1,4                ; MSB hi-niblle to MSB low-nibble
        ;-------------------------------------------------------
        ; Page-in target SAMS banks for EA5 image load
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address
        sbo   0                     ; Enable access to SAMS registers
        mov   tmp1,@>4018           ; Set page for >c000 - >cfff
        ai    tmp1,>0100            ; Next SAMS bank
        mov   tmp1,@>401A           ; Set page for >d000 - >dfff
        ai    tmp1,>0100            ; Next SAMS bank
        mov   tmp1,@>401C           ; Set page for >e000 - >efff
        sbz   0                     ; Disable access to SAMS registers
        ;-------------------------------------------------------
        ; Copy chunk from VRAM to RAM
        ;------------------------------------------------------- 
        mov   @fh.ea5.ramtgt,tmp1   ; Get RAM target address
        andi  tmp1,>0FFF            ; Get offset in SAMS window >c000 - >dfff
        ori   tmp1,>C000            ; Form full SAMS window address
        
        bl    @xpyv2m               ; Copy EA5 image chunk from VDP to RAM
                                    ; \ i  tmp0  = Source VDP address
                                    ; | i  tmp1  = Destination RAM address
                                    ; | i  tmp2  = Number of bytes to copy
                                    ; /
        ;-------------------------------------------------------
        ; Set EA5 program start address (if not already set)
        ;------------------------------------------------------- 
        mov   @fh.ea5.startaddr,tmp0
        jne   fh.file.load.ea5.next ; Already set, skip
        mov   @fh.ea5.ramtgt,@fh.ea5.startaddr
                                    ; Set start address
        ;-------------------------------------------------------
        ; Step 3: Prepare for loeading next EA5 image chunk
        ;-------------------------------------------------------
fh.file.load.ea5.next:        
        mov   @fh.ea5.nextflag,tmp0 ; \ Additional chunk needed?
        ci    tmp0,>ffff            ; /
        jne   !                     ; No all of EA5 image loaded
        ;-------------------------------------------------------
        ; Increment last character of filename
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Get pointer to filename descriptor
        mov   *tmp0,tmp1            ; \ Get length of filename
        srl   tmp1,8                ; / 
        a     tmp1,tmp0             ; Point to last character of filename
        movb  *tmp0,tmp1            ; Get last character
        ai    tmp1,>0100            ; Increment last character
        movb  tmp1,*tmp0            ; Store back last character
        jmp   fh.file.load.ea5.parm ; Yes, load next chunk
        ;-------------------------------------------------------
        ; Step 4: Page-in SAMS banks used in Stevie
        ;-------------------------------------------------------
!       li    r12,>1e00             ; SAMS CRU address
        sbo   0                     ; Enable access to SAMS registers
        mov   @tv.sams.c000,tmp1    ; Get current SAMS bank for >c000 - >cfff
        swpb  tmp1                  ; LSB to MSB
        mov   tmp1,@>4018           ; Set SAMS bank
        mov   @tv.sams.d000,tmp1    ; Get current SAMS bank for >d000 - >dfff
        swpb  tmp1                  ; LSB to MSB
        mov   tmp1,@>401A           ; Set SAMS bank
        mov   @tv.sams.e000,tmp1    ; Get current SAMS bank for >e000 - >efff
        swpb  tmp1                  ; LSB to MSB
        mov   tmp1,@>401C           ; Set SAMS bank
        sbz   0                     ; Disable access to SAMS registers
        ;-------------------------------------------------------
        ; Step 5: Return start address of EA5 program image
        ;-------------------------------------------------------        
        mov   @fh.ea5.startaddr,@outparm1
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fh.file.load.ea5.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   

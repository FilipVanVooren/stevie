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
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3        
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------  

        ;-------------------------------------------------------
        ; Load EA5 program image into memory
        ;-------------------------------------------------------
        clr   @parm2                ; Clear callback "before loading image"
        clr   @parm3                ; Clear callback "image loaded"
        clr   @parm4                ; Clear callback "File I/O error"

        li    tmp0,>2000
        mov   tmp0,@parm5           ; Set VDP destination address to >2000

        seto  @parm6                ; Set RAM destination address to skip RAM loading

        li    tmp0,8192
        mov   tmp0,@parm7           ; Set maxmimum number of bytes to load
        ;-------------------------------------------------------
        ; Load EA5 image chunk into memory
        ;-------------------------------------------------------
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
                                    ; /

        jmp $
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

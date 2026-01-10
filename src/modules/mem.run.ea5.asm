***************************************************************
* mem.run.ea5
* Run previously loaded EA5 memory image
***************************************************************
* INPUT
* parm1  = Pointer to start address in RAM
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r1, r2, r3
*--------------------------------------------------------------
* Remarks
********|*****|*********************|**************************
mem.run.ea5:
        ;-------------------------------------------------------
        ; Prepare for running EA5 binary image
        ;------------------------------------------------------- 
        mov   @parm1,r1             ; \ Get entrypoint address in RAM
                                    ; / Store in R1 for now, final is R0
        bl    @scroff               ; Turn off screen
        ;-------------------------------------------------------
        ; Reset F18A and set video mode
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data edasm.32x24      ; Equate selected video mode table

        bl    @filv
              data >0000,>20,768    ; Clear screen with whitespaces

        bl    @filv
              data >0300,>00,>3700  ; Clear rest of VRAM

        bl    @filv
              data >0380,>13,32     ; Load color table (black on green)

        bl    @cpym2v               ; Copy patterns to VRAM
              data >0850            ; \ i  p1 = VRAM target address
              data copyright        ; | i  p2 = Source address in ROM
              data 8                ; / i  p3 = Number of bytes to copy

        bl    @cpym2v               ; Copy patterns to VRAM
              data >08F0            ; \ i  p1 = VRAM target address
              data ea5.cursors      ; | i  p2 = Source address in ROM
              data 16               ; / i  p3 = Number of bytes to copy

        bl    @ldfnt                ; Load font from ROM
              data >0900,fnopt3     ; \ i  p1 = VRAM target address
                                    ; | i  p2 = Font options 
                                    ; /    (upper/lower case font)

        bl    @filv
              data >0300,>D0,2      ; No sprites 

        bl    @file.vmem            ; Setup VDP memory for file I/O                                 

        bl    @scron                ; Turn on screen
        ;-------------------------------------------------------
        ; Set SAMS banks to defaults. We're on our own now
        ;-------------------------------------------------------
        li    r0,mem.sams.layout.legacy
        bl    @_mem.sams.set.banks  ; Page-in defaults
        ;-------------------------------------------------------
        ; Setup scratchpad memory (inline memory copy)
        ;-------------------------------------------------------
        mov   r1,r0                 ; parm1 (R1) to R0 for later use
        li    r1,scrpad.edasm + 8   ; Source address
        li    r2,>8308              ; Target address
        li    r3,248                ; Number of bytes to copy
!       mov   *r1+,*r2+             ; Copy word from ROM to scratchpad RAM
        dect  r3                    ; Next iteration
        jne   -!                    ; Done? Not yet, repeat
        ;-------------------------------------------------------
        ; Put remaining words in place and activate WS
        ;-------------------------------------------------------
        mov   r0,@>83E0             ; Put parm1 (entrypoint) in workspace
        mov   @scrpad.edasm + 0,@>8300
        mov   @scrpad.edasm + 2,@>8302
        mov   @scrpad.edasm + 4,@>8304           
        mov   @scrpad.edasm + 6,@>8306                             
        ;-------------------------------------------------------
        ; Start external program
        ;-------------------------------------------------------
        lwpi  >83E0                 ; Activate WS in scratchpad            
        limi  0                     ; Disable interrupts             
        bl    *r0                   ; Run!
        ;-------------------------------------------------------
        ; Return from external program
        ;-------------------------------------------------------
        ;
        ; We assume everything can be broken after retuning from
        ; an external program (scratchpad, SAMS, VRAM, VDP regs, ...)
        ;
        ; Poke small assembly program to scratchpad for 
        ; jumping to bank 0 address >6040
        ; 
        lwpi  >8300                 ; Activate primary scratchpad
        mov   @loader,r0            ; 
        mov   @loader+2,r1          ;
        mov   @loader+4,r2          ; 
        mov   @loader+6,r3          ;
        b     @>8300                ; Run loader
        ;-------------------------------------------------------
        ; Loader code
        ;-------------------------------------------------------
loader: data  >0720                 ; \ seto @>6000  ; Activate bank 0
        data  >6000                 ; / 
        data  >0460                 ; \ b @6040      ; Stevie cold start
        data  >6040                 ; / 

* FILE......: tib.session.isr.asm
* Purpose...: TI Basic integration hook


***************************************************************
* isr
* TI Basic integration hook
***************************************************************
* Called from console rom at >0ab6
* See TI Intern page 32 (german) for details
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r7, 12
********|*****|*********************|**************************
isr:
        limi  0                     ; \ Turn off interrupts
                                    ; / Prevent ISR reentry

        mov   r7,@rambuf            ; Backup R7
        mov   r12,@rambuf+2         ; Backup R12
        ;--------------------------------------------------------------
        ; Exit ISR if TI-Basic is busy running a program
        ;--------------------------------------------------------------
        mov   @>8344,r7             ; Busy running program?
        ci    r7,>0100
        jne   isr.showid            ; No, TI-Basic is in command line mode.
        ;--------------------------------------------------------------
        ; TI-Basic program running
        ;--------------------------------------------------------------
        jmp   isr.exit              ; Exit
        ;--------------------------------------------------------------
        ; Show TI-Basic session ID and scan crunch buffer
        ;--------------------------------------------------------------
isr.showid:
        mov   @>83b4,r7             ; Get counter
        ci    r7,>003c              ; Counter limit reached ?
        jlt   isr.counter           ; Not yet, skip showing Session ID
        clr   @>83b4                ; Reset counter
        ;--------------------------------------------------------------
        ; Setup VDP write address for column 30
        ;--------------------------------------------------------------
        li    r7,>401e              ; \
        swpb  r7                    ; | >1c is the VDP column position
        movb  r7,@vdpa              ; | where bytes should be written
        swpb  r7                    ; |
        movb  r7,@vdpa              ; /
        ;-------------------------------------------------------
        ; Write session ID
        ;-------------------------------------------------------
        li    r7,>83df              ; Char '#' and char >df
        movb  r7,@vdpw              ; Write byte
        swpb  r7
        movb  r7,@vdpw              ; Write byte
        jmp   isr.scan.crunchbuf    ; Go scan crunch buffer
        ;-------------------------------------------------------
        ; Increase counter
        ;-------------------------------------------------------
isr.counter:
        inc   @>83b4                ; Increase counter
        ;-------------------------------------------------------
        ; Hotkey pressed?
        ;-------------------------------------------------------
isr.hotkey:
        mov   @>8374,r7             ; \ Get keyboard scancode from @>8375
        andi  r7,>00ff              ; / LSB only
        ci    r7,>0f                ; Hotkey fctn + '9' pressed?
        jne   isr.exit              ; No, normal exit
        b     @tib.run.return       ; Yes, return to Stevie
        ;-------------------------------------------------------
        ; Return from ISR
        ;-------------------------------------------------------
isr.exit:
        mov   @rambuf+2,r12         ; Restore R12
        mov   @rambuf,r7            ; Restore R7
        b     *r11                  ; Return from ISR



***************************************************************
* isr.scan.crunbuf
* Scan the VDP crunch buffer for file commands NEW/OLD/SAVE
***************************************************************
* Called from isr
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r7, r10
*
* Memory usage
* >ffd0 - >ffff  TI Basic program filename
********|*****|*********************|**************************
isr.scan.crunchbuf:
        ;-------------------------------------------------------
        ; Read token at VDP >0320
        ;-------------------------------------------------------
        li    r7,>0320              ; \
        swpb  r7                    ; |  Setup VDP read address
        movb  r7,@vdpa              ; |
        swpb  r7                    ; |
        movb  r7,@vdpa              ; /

        movb  @vdpr,r7              ; Read MSB
        swpb  r7
        movb  @vdpr,r7              ; Read LSB
        swpb  r7                    ; Restore order
        ;-------------------------------------------------------
        ; Scan for OLD
        ;-------------------------------------------------------
isr.scan.old:
        cb    r7,@data.tk.old       ; OLD?
        jne   isr.scan.save         ; No, check if other token
        jmp   isr.scan.copy         ; Copy parameter to high-memory
        ;-------------------------------------------------------
        ; Scan for SAVE
        ;-------------------------------------------------------
isr.scan.save:
        cb    r7,@data.tk.save      ; SAVE?
        jne   isr.scan.new          ; No, check if other token
        jmp   isr.scan.copy         ; Copy parameter to high-memory
        ;-------------------------------------------------------
        ; Scan for NEW
        ;-------------------------------------------------------
isr.scan.new:
        cb    r7,@data.tk.new       ; NEW?
        jne   isr.scan.exit         ; Exit crunch buffer scan
        ;-------------------------------------------------------
        ; Clear TI Basic auxiliary memory buffer
        ;-------------------------------------------------------
        li    r7,tib.aux
!       clr   *r7+                  ; \
        ci    r7,tib.aux.end        ; | Clear memory
        jle   -!                    ; /
        jmp   isr.scan.exit         ; Exit
        ;-------------------------------------------------------
        ; Copy TI Basic program filename to high memory
        ;-------------------------------------------------------
isr.scan.copy:
        clr   r7                    ;
        li    r10,tib.aux.fname     ; Target address in high memory
isr.scan.copy.loop:
        movb  @vdpr,r7              ; Read LSB
        movb  r7,*r10+              ; Copy byte to RAM
        jne   isr.scan.copy.loop    ; Copy until termination token found
        ;-------------------------------------------------------
        ; TI Basic program filename copied
        ;-------------------------------------------------------
isr.scan.exit:
        jmp   isr.hotkey            ; Continue processing isr



***************************************************************
* Tokens TI Basic commands
********|*****|*********************|**************************
data.tk.new   byte >01              ; NEW
data.tk.old   byte >06              ; OLD
data.tk.save  byte >08              ; SAVE
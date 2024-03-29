
***************************************************************
* _mem.sams.set.banks
* Setup SAMS memory banks
***************************************************************
* INPUT
* r0
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS standard layout without using any library calls
* or stack. Must run without dependencies.
* This is the same order as when using SAMS transparent mode.
********|*****|*********************|**************************
_mem.sams.set.banks:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address
        sbo   0                     ; Enable access to SAMS registers

        mov   *r0+,@>4004           ; Set page for >2000 - >2fff
        mov   *r0+,@>4006           ; Set page for >3000 - >3fff
        mov   *r0+,@>4014           ; Set page for >a000 - >afff
        mov   *r0+,@>4016           ; Set page for >b000 - >bfff
        mov   *r0+,@>4018           ; Set page for >c000 - >cfff
        mov   *r0+,@>401a           ; Set page for >d000 - >dfff
        mov   *r0+,@>401c           ; Set page for >e000 - >efff
        mov   *r0+,@>401e           ; Set page for >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.banks.exit:
        b     *r11                  ; Return




***************************************************************
* mem.sams.set.legacy
* Setup SAMS memory banks to legacy layout and exit to monitor
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS standard layout without using any library calls
* or stack. Must run without dependencies.
* This is the same order as when using SAMS transparent mode.
*
* We never do a normal return from this routine, instead we
* activate bank 0 in the cartridge space and return to monitor.
********|*****|*********************|**************************
mem.sams.set.legacy:
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
                                    ; \ We keep the mapper off while
                                    ; | running TI Basic or other external
                                    ; / programs.        
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.legacy
        bl    @_mem.sams.set.banks  ; Set SAMS banks
        ;-------------------------------------------------------
        ; Poke exit routine into scratchpad memory
        ;-------------------------------------------------------        
        mov   @mem.sams.set.legacy.code,@>8300
        mov   @mem.sams.set.legacy.code+2,@>8302
        mov   @mem.sams.set.legacy.code+4,@>8304
        mov   @mem.sams.set.legacy.code+6,@>8306
        mov   @mem.sams.set.legacy.code+8,@>8308
        b     @>8300                ; Run code. Bye bye.
        ;-------------------------------------------------------
        ; Assembly language code for returning to monitor
        ;-------------------------------------------------------        
mem.sams.set.legacy.code:
        data  >04e0,bank0.rom       ; Activate bank 0
        data  >0420,>0000           ; blwp @0



***************************************************************
* mem.sams.set.boot
* Setup SAMS memory banks for stevie startup
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS layout for stevie without using any library calls
* or stack. Must run without dependencies.
********|*****|*********************|**************************
mem.sams.set.boot:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.boot
        jmp   _mem.sams.set.banks   ; Set SAMS banks



***************************************************************
* mem.sams.set.external
* Setup SAMS memory banks for calling external program
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r12
*--------------------------------------------------------------
* Remarks
* Main purpose is for doing a VDP dump of the Stevie screen
* before an external program is called.
* 
* It's expected that for the external program itself a separate
* SAMS layout is used, for example TI basic session 1, ...
********|*****|*********************|**************************
mem.sams.set.external:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.external
        jmp   _mem.sams.set.banks   ; Set SAMS banks




***************************************************************
* mem.sams.set.basic1
* Setup SAMS memory banks for TI Basic session 1
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
*--------------------------------------------------------------
* Remarks
* Purpose is to handle backup/restore all the VDP memory
* used by this TI Basic session.
********|*****|*********************|**************************
mem.sams.set.basic1:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.basic1
        mov   r0,@tib.samstab.ptr
        jmp   _mem.sams.set.banks   ; Set SAMS banks



***************************************************************
* mem.sams.set.basic2
* Setup SAMS memory banks for TI Basic session 2
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
*--------------------------------------------------------------
* Remarks
* Purpose is to handle backup/restore all the VDP memory
* used by this TI Basic session.
********|*****|*********************|**************************
mem.sams.set.basic2:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.basic2
        mov   r0,@tib.samstab.ptr        
        jmp   _mem.sams.set.banks   ; Set SAMS banks



***************************************************************
* mem.sams.set.basic3
* Setup SAMS memory banks for TI Basic session 3
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
*--------------------------------------------------------------
* Remarks
* Purpose is to handle backup/restore all the VDP memory
* used by this TI Basic session.
********|*****|*********************|**************************
mem.sams.set.basic3:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r0,mem.sams.layout.basic3
        mov   r0,@tib.samstab.ptr        
        jmp   _mem.sams.set.banks   ; Set SAMS banks


***************************************************************
* mem.sams.set.stevie
* Setup SAMS memory banks for stevie
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS layout for stevie without using any library calls
* or stack. Must run without dependencies.
*
* Expects @tv.sams.xxxx variables to be set in advance with
* routine "sams.layout.copy".
*
* Also the SAMS bank with the @tv.sams.xxxx variable must already
* be active and may not switch to another bank.
* 
* Is used for settings SAMS banks as they were before an 
* external program environment was called (e.g. TI Basic).
********|*****|*********************|**************************
mem.sams.set.stevie:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address       
        sbo   0                     ; Enable access to SAMS registers

        sbo   1                     ; Enable SAMS mapper
                                    ; \ Mapper must be on while setting SAMS
                                    ; | registers with values in @tv.sams.xxxx
                                    ; | Obviously, this requires the SAMS banks
                                    ; | with the @tv.sams.xxxx variables not 
                                    ; / to change.

        mov   @tv.sams.2000,r0      ; \
        swpb  r0                    ; | Set page for >2000 - >2fff        
        mov   r0,@>4004             ; / 

        mov   @tv.sams.3000,r0      ; \
        swpb  r0                    ; | Set page for >3000 - >3fff
        mov   r0,@>4006             ; / 

        mov   @tv.sams.a000,r0      ; \
        swpb  r0                    ; | Set page for >a000 - >afff
        mov   r0,@>4014             ; / 

        mov   @tv.sams.b000,r0      ; \
        swpb  r0                    ; | Set page for >b000 - >bfff
        mov   r0,@>4016             ; / 

        mov   @tv.sams.c000,r0      ; \
        swpb  r0                    ; | Set page for >c000 - >cfff
        mov   r0,@>4018             ; / 

        mov   @tv.sams.d000,r0      ; \
        swpb  r0                    ; | Set page for >d000 - >dfff
        mov   r0,@>401a             ; / 

        mov   @tv.sams.e000,r0      ; \
        swpb  r0                    ; | Set page for >e000 - >efff
        mov   r0,@>401c             ; / 

        mov   @tv.sams.f000,r0      ; \
        swpb  r0                    ; | Set page for >f000 - >ffff
        mov   r0,@>401e             ; / 

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.stevie.exit:
        b     *r11                  ; Return

***************************************************************
* mem.sams.set.legacy  
* Setup SAMS memory banks to legacy layout matching monitor
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
********|*****|*********************|**************************
mem.sams.set.legacy:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
                                    ; \ We keep the mapper off while
                                    ; | running TI Basic or other external
                                    ; / programs.

        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.legacy+0,@>4004  ; Set page for >2000 - >2fff
        mov   @mem.sams.layout.legacy+2,@>4006  ; Set page for >3000 - >3fff
        mov   @mem.sams.layout.legacy+4,@>4014  ; Set page for >a000 - >afff
        mov   @mem.sams.layout.legacy+6,@>4016  ; Set page for >b000 - >bfff
        mov   @mem.sams.layout.legacy+8,@>4018  ; Set page for >c000 - >cfff
        mov   @mem.sams.layout.legacy+10,@>401a ; Set page for >d000 - >dfff
        mov   @mem.sams.layout.legacy+12,@>401c ; Set page for >e000 - >efff
        mov   @mem.sams.layout.legacy+14,@>401e ; Set page for >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.legacy.exit:
        b     *r11                  ; Return


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
* r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS layout for stevie without using any library calls
* or stack. Must run without dependencies.
********|*****|*********************|**************************
mem.sams.set.boot:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address       
        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.boot+0,@>4004  ; Set page for >2000 - >2fff
        mov   @mem.sams.layout.boot+2,@>4006  ; Set page for >3000 - >3fff
        mov   @mem.sams.layout.boot+4,@>4014  ; Set page for >a000 - >afff
        mov   @mem.sams.layout.boot+6,@>4016  ; Set page for >b000 - >bfff
        mov   @mem.sams.layout.boot+8,@>4018  ; Set page for >c000 - >cfff
        mov   @mem.sams.layout.boot+10,@>401a ; Set page for >d000 - >dfff
        mov   @mem.sams.layout.boot+12,@>401c ; Set page for >e000 - >efff
        mov   @mem.sams.layout.boot+14,@>401e ; Set page for >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.stevie.boot:
        b     *r11                  ; Return


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
* tmp0, r12
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
        li    r12,>1e00             ; SAMS CRU address
        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.external+0,@>4004  ; Set page for >2000 - >2fff
        mov   @mem.sams.layout.external+2,@>4006  ; Set page for >3000 - >3fff
        mov   @mem.sams.layout.external+4,@>4014  ; Set page for >a000 - >afff
        mov   @mem.sams.layout.external+6,@>4016  ; Set page for >b000 - >bfff
        mov   @mem.sams.layout.external+8,@>4018  ; Set page for >c000 - >cfff
        mov   @mem.sams.layout.external+10,@>401a ; Set page for >d000 - >dfff
        mov   @mem.sams.layout.external+12,@>401c ; Set page for >e000 - >efff
        mov   @mem.sams.layout.external+14,@>401e ; Set page for >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     *r11                  ; Return to caller


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
        li    r12,>1e00             ; SAMS CRU address
        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.basic1+0,@>4004  ; Set page for >2000 - >2fff
        mov   @mem.sams.layout.basic1+2,@>4006  ; Set page for >3000 - >3fff
        mov   @mem.sams.layout.basic1+4,@>4014  ; Set page for >a000 - >afff
        mov   @mem.sams.layout.basic1+6,@>4016  ; Set page for >b000 - >bfff
        mov   @mem.sams.layout.basic1+8,@>4018  ; Set page for >c000 - >cfff
        mov   @mem.sams.layout.basic1+10,@>401a ; Set page for >d000 - >dfff
        mov   @mem.sams.layout.basic1+12,@>401c ; Set page for >e000 - >efff
        mov   @mem.sams.layout.basic1+14,@>401e ; Set page for >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     *r11                  ; Return to caller


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




***************************************************************
* SAMS legacy page layout table (as in SAMS transparent mode)
*--------------------------------------------------------------
mem.sams.layout.legacy:
        data  >0200                 ; >2000-2fff, SAMS page >02
        data  >0300                 ; >3000-3fff, SAMS page >03
        data  >0a00                 ; >a000-afff, SAMS page >0a
        data  >0b00                 ; >b000-bfff, SAMS page >0b
        data  >0c00                 ; >c000-cfff, SAMS page >0c
        data  >0d00                 ; >d000-dfff, SAMS page >0d
        data  >0e00                 ; >e000-efff, SAMS page >0e
        data  >0f00                 ; >f000-ffff, SAMS page >0f        


***************************************************************
* SAMS page layout table for Stevie boot
*--------------------------------------------------------------
mem.sams.layout.boot:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04
        data  >2000                 ; >b000-bfff, SAMS page >20
                                    ; \ 
                                    ; | Index can allocate
                                    ; | pages >20 to >3f.                                    
                                    ; /
        data  >4000                 ; >c000-cfff, SAMS page >40
                                    ; \
                                    ; | Editor buffer can allocate
                                    ; | pages >40 to >ff.
                                    ; /
        data  >0500                 ; >d000-dfff, SAMS page >05
        data  >0600                 ; >e000-efff, SAMS page >06
        data  >0700                 ; >f000-ffff, SAMS page >07     



***************************************************************
* SAMS page layout table before calling external progam
*--------------------------------------------------------------
mem.sams.layout.external:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1000                 ; >b000-efff, SAMS page >10
        data  >1100                 ; \ 
        data  >1200                 ; | Stevie session
        data  >1300                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07


***************************************************************
* SAMS page layout table for TI Basic session 1
*--------------------------------------------------------------
mem.sams.layout.basic1:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1400                 ; >b000-efff, SAMS page >10
        data  >1500                 ; \ 
        data  >1600                 ; | TI Basic session 1
        data  >1700                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07                    
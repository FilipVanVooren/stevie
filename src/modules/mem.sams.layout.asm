***************************************************************
* mem.sams.set.layout
* Setup SAMS memory banks from cartridge space
***************************************************************
* INPUT
* tmp0 = Pointer to table with SAMS banks
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
********|*****|*********************|**************************
mem.sams.set.layout:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   r12,*stack            ; Push r12

        ; Need to set SAMS banks via inline code, because we're 
        ; calling this routine when there is no access to SAMS 
        ; banks where SP2 resident code is located.

        ;------------------------------------------------------
        ; Set SAMS registers
        ;------------------------------------------------------
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper                
        sbo   0                     ; Enable access to SAMS registers

        mov  *tmp0+,@>4004          ; Set page for >2000 - >2fff
        mov  *tmp0+,@>4006          ; Set page for >3000 - >3fff
        mov  *tmp0+,@>4014          ; Set page for >a000 - >afff
        mov  *tmp0+,@>4016          ; Set page for >b000 - >bfff
        mov  *tmp0+,@>4018          ; Set page for >c000 - >cfff
        mov  *tmp0+,@>401a          ; Set page for >d000 - >dfff
        mov  *tmp0+,@>401c          ; Set page for >e000 - >efff
        mov  *tmp0+,@>401e          ; Set page for >f000 - >ffff     

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.layout.exit:
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* mem.sams.set.standard
* Setup SAMS memory banks to standard layout for monitor
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
* or stack. Must run without dependencies
********|*****|*********************|**************************
mem.sams.set.standard:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper                
        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.standard+0,@>4004  ; Page 2 in >2000 - >2fff
        mov   @mem.sams.layout.standard+2,@>4006  ; Page 3 in >3000 - >3fff
        mov   @mem.sams.layout.standard+4,@>4014  ; Page A in >a000 - >afff
        mov   @mem.sams.layout.standard+6,@>4016  ; Page B in >b000 - >bfff
        mov   @mem.sams.layout.standard+8,@>4018  ; Page C in >c000 - >cfff
        mov   @mem.sams.layout.standard+10,@>401a ; Page D in >d000 - >dfff
        mov   @mem.sams.layout.standard+12,@>401c ; Page E in >e000 - >efff
        mov   @mem.sams.layout.standard+14,@>401e ; Page f in >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.standard.exit:
        b     *r11                  ; Return

; TODO 
; Rename "standard" to "legacy". Is a better wording


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
* r12
*--------------------------------------------------------------
* Remarks
* Setup SAMS layout for stevie without using any library calls
* or stack. Must run without dependencies
********|*****|*********************|**************************
mem.sams.set.stevie:
        ;-------------------------------------------------------
        ; Setup SAMS banks using inline code
        ;------------------------------------------------------- 
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper                
        sbo   0                     ; Enable access to SAMS registers

        mov   @mem.sams.layout.stevie+0,@>4004  ; Page 2 in >2000 - >2fff
        mov   @mem.sams.layout.stevie+2,@>4006  ; Page 3 in >3000 - >3fff
        mov   @mem.sams.layout.stevie+4,@>4014  ; Page A in >a000 - >afff
        mov   @mem.sams.layout.stevie+6,@>4016  ; Page B in >b000 - >bfff
        mov   @mem.sams.layout.stevie+8,@>4018  ; Page C in >c000 - >cfff
        mov   @mem.sams.layout.stevie+10,@>401a ; Page D in >d000 - >dfff
        mov   @mem.sams.layout.stevie+12,@>401c ; Page E in >e000 - >efff
        mov   @mem.sams.layout.stevie+14,@>401e ; Page f in >f000 - >ffff

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.stevie.exit:
        b     *r11                  ; Return




***************************************************************
* mem.sams.set.external
* Setup SAMS memory banks to external layout
***************************************************************
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
********|*****|*********************|**************************
mem.sams.set.external:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Set SAMS layout
        ;------------------------------------------------------
        li    tmp0,mem.sams.layout.external
        bl    @mem.sams.set.layout
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.set.external.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* SAMS standard page layout table
*--------------------------------------------------------------
mem.sams.layout.standard:
        data  >0200                 ; >2000-2fff, SAMS page >02
        data  >0300                 ; >3000-3fff, SAMS page >03
        data  >0a00                 ; >a000-afff, SAMS page >0a
        data  >0b00                 ; >b000-bfff, SAMS page >0b
        data  >0c00                 ; >c000-cfff, SAMS page >0c
        data  >0d00                 ; >d000-dfff, SAMS page >0d
        data  >0e00                 ; >e000-efff, SAMS page >0e
        data  >0f00                 ; >f000-ffff, SAMS page >0f        


***************************************************************
* SAMS page layout table for Stevie
*--------------------------------------------------------------
mem.sams.layout.stevie:
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
* SAMS page layout table for calling external progam
*--------------------------------------------------------------
mem.sams.layout.external:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1000                 ; >b000-efff, SAMS page >10
        data  >1100                 ; \ 
        data  >1200                 ; | TI Basic can allocate
        data  >1300                 ; | pages >10 to >1f.
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07        
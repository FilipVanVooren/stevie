* FILE......: edb.find.asm
* Purpose...: Initialize memory used for editor buffer find functionality
***************************************************************
* edb.find.init
* Scan source code for search string
***************************************************************
*  bl   @edb.find.init
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4, r1
********|*****|*********************|**************************
edb.find.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------        
        ; Initialisation
        ;------------------------------------------------------ 
        bl    @film
              data edb.srch.idx.rtop
              data >ff
              data edb.srch.idx.rsize + edb.srch.idx.csize
                                    ; Clear search results index for rows and
                                    ; columns. Using >ff as "unset" value

        clr   @edb.srch.offset      ; Reset offset into search results row index
        clr   @edb.srch.matches     ; Reset matches counter
        clr   @edb.srch.curmatch    ; Reset current match
        clr   @edb.srch.startln     ; 1st line to search
        mov   @edb.lines,@edb.srch.endln
                                    ; Last line to search
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.find.init.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                                           

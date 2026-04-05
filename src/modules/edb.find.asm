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
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
edb.find.init:
        .pushregs 2                 ; Push registers and return address on stack
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
        .popregs 2                  ; Pop registers and return to caller        

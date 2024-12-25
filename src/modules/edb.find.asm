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


***************************************************************
* edb.find.search.search
* Prepare for doing search operation
***************************************************************
*  bl   @edb.find.search
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
********|*****|*********************|**************************
edb.find.search:
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
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        bl    @putat
              byte 0,67
              data txt.find.hits    ; Show 'Hits:'

        bl    @pane.cmdb.hide       ; Hide CMDB pane

        seto  @fb.dirty             ; Refresh frame buffer
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        bl    @fb.calc.scrrows      ; Calculate number of rows 
                                    ; \ i  @tv.ruler.visible = Ruler visible
                                    ; | i  @edb.special.file = Special file flag
                                    ; / i  @tv.error.visible = Error visible

        mov   @fb.scrrows,@parm1
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /                                    
        ;-------------------------------------------------------
        ; Perform search operation
        ;-------------------------------------------------------
        bl    @edb.find.scan        ; Perform search operation
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.find.search.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller     

txt.find.hits stri 'Hits:'
              even

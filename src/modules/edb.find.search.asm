* FILE......: edb.find.search.asm
* Purpose...: Editor buffer find functionality
                              
                        
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
              byte 0,69
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
        ;-------------------------------------------------------
        ; Show 1st search result
        ;-------------------------------------------------------
        bl    @hchar
              byte 0,69,32,22
              data eol              ; Remove "Hits: ....."

        mov   @edb.srch.matches,@edb.srch.curmatch
                                    ; \ Wrap around and goto 1st 
        bl    @fb.goto.nextmatch    ; / match in file.
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

txt.find.hits stri 'Hits:    0'
              even

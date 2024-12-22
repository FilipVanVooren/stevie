* FILE......: edb.find.scan.asm
* Purpose...: Scan source code for search string
***************************************************************
* edb.find.scan
* Scan source code for search string
***************************************************************
*  bl   @edb.find.scan
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
*--------------------------------------------------------------
* Memory usage
*
* 1. Using some memory locations foreseen for file I/O.
*    Is ok, because we know we're not saving/reading file while
*    scanning editor buffer in memory.
*
* 2. Using framebuffer as work buffer for unpacking line before 
*    scan. Enable reuse of existing unpack to framebuffer func.
********|*****|*********************|**************************
edb.find.scan
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
        mov   tmp4,*stack           ; Push tmp4        
        ;------------------------------------------------------        
        ; Initialisation
        ;------------------------------------------------------ 
        bl    @cpym2m
              data cmdb.cmdall,edb.srch.str,80
                                    ; Set search string

        bl    @film
              data edb.srch.idx.top,>ff,2000
                                    ; Clear search results index
                                    ; Using >ff as "unset" value

        movb  @cmdb.cmdlen,tmp0     ; \ Get length of search string
        srl   tmp0,8                ; | MSB to LSB
        mov   tmp0,@edb.srch.strlen ; / Save search string length

        clr   @edb.srch.matches     ; Reset matches counter
        clr   @edb.srch.offset      ; Reset offset into search results index
        clr   @edb.srch.startln     ; 1st line to search
        mov   @edb.lines,@edb.srch.endln
                                    ; Last line to search                

        c     @edb.block.m1,@w$ffff  ; Marker M1 unset?
        jeq   edb.find.scan.showbusy ; Unset skip block marker
        ;------------------------------------------------------        
        ; Use block markers M1-M2 as search range
        ;------------------------------------------------------
        mov   @edb.block.m1,@edb.srch.startln
        mov   @edb.block.m2,@edb.srch.endln
        ;------------------------------------------------------        
        ; Show busy indicator
        ;------------------------------------------------------
edb.find.scan.showbusy:         
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /            
        
        bl    @putat
              byte pane.botrow,0
              data txt.searching    ; Show "Searching..."

        mov   @edb.srch.startln,@fh.records           
                                    ; Counter current line
        ;------------------------------------------------------        
        ; Loop over lines in editor buffer
        ;------------------------------------------------------
edb.find.scan.edbuffer:
        clr   tmp4                  ; Reset offset into search results index
        ;------------------------------------------------------
        ; Unpack current line to framebuffer
        ;------------------------------------------------------
edb.find.scan.unpack_line:
        mov   @fh.records,@parm1    ; Unpack current line to framebuffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in framebuffer
                                    ; | i  parm3    = Column offset
                                    ; / o  outparm1 = Length of line

        mov   @outparm1,tmp2        ; Store copy of linelength for later use
        ;------------------------------------------------------
        ; Skip if unpacked line shorter than search string
        ;------------------------------------------------------
        c     @edb.srch.strlen,tmp2  ; Compare lengths of line and search string
        jgt   edb.find.scan.nextline ; Yes, take shortcut
        ;------------------------------------------------------
        ; Prepare for string compare
        ;------------------------------------------------------
        li    tmp0,edb.srch.str + 1  ; Reset source for compare (skip len byte)
        mov   @fb.top.ptr,tmp1       ; Destination for compare (unpacked line)
        mov   tmp2,@edb.srch.worklen ; Length of unpacked line
        clr   tmp3                   ; Character match counter
        ;------------------------------------------------------
        ; Loop over characters in unpacked line and compare
        ;------------------------------------------------------
edb.find.scan.compare:
        cb    *tmp0+,*tmp1+          ; Compare characters in MSB
        jne   edb.find.scan.compare.nomatch
                                     ; Characters do not match. Next try.
        ;------------------------------------------------------
        ; Character matches
        ;------------------------------------------------------        
        inc   tmp3                  ; Update character match counter
        c     tmp3,@edb.srch.strlen ; Last character in search string?
        jne   edb.find.scan.compare.nextchar
                                    ; Not yet, prepare for scanning next char
        ;------------------------------------------------------
        ; Search string found
        ;------------------------------------------------------
        mov   @edb.srch.offset,tmp4 
        mov   @fh.records,@edb.srch.idx.top(tmp4)
                                    ; Save line number in search results index
        inct  @edb.srch.offset      ; Next index entry
        inc   @edb.srch.matches     ; Update search string match counter
        li    tmp0,edb.srch.str + 1 ; Reset source for compare (skip len byte)
        jmp   edb.find.scan.compare.nextchar
        ;------------------------------------------------------
        ; Search string not found. Next try on remaining chars on line
        ;------------------------------------------------------
edb.find.scan.compare.nomatch        
        li    tmp0,edb.srch.str + 1 ; Reset source for compare (skip len byte)
        ;------------------------------------------------------
        ; Prepare for processing next character
        ;------------------------------------------------------        
edb.find.scan.compare.nextchar:
        dec   tmp2                  ; Update character counter
        jgt   edb.find.scan.compare ; Line not completely scanned
        ;------------------------------------------------------
        ; Prepare for processing Next line
        ;------------------------------------------------------
edb.find.scan.nextline:        
        inc   @fh.records           ; Increase line counter

        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020

        c     @fh.records,@edb.srch.endln
                                    ; All lines scanned ?                                

        jne   edb.find.scan.unpack_line
                                    ; Not yet, process next line
        ;------------------------------------------------------
        ; Scan completed. Restore 1st line in framebuffer
        ;------------------------------------------------------
edb.find.scan.done:        
        mov   @fb.topline,@parm1    ; Line to restore in framebuffer
        clr   @parm2                ; Top row
        clr   @parm3                ; No column offset

        bl    @edb.line.unpack      ; Unpack line from editor buffer
                                    ; \ i  @parm1    = Line to unpack
                                    ; | i  @parm2    = Target row in framebuffer
                                    ; | i  @parm3    = Column offset
                                    ; / o  @outparm1 = Length of line                
                                    
        seto  @fb.dirty             ; Trigger frame buffer refresh

        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.find.scan.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

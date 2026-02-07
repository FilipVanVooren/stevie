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
* tmp0, tmp1, tmp2, tmp3, tmp4, r1
*--------------------------------------------------------------
* Memory usage
*
* 1. Using some memory locations foreseen for file I/O.
*    Is ok, because we know we're not saving/reading file while
*    scanning editor buffer in memory.
*
* 2. Using framebuffer as work buffer for unpacking line before 
*    scan. Enable reuse of existing unpack to framebuffer func.
*
* Register usage
* tmp0 = Pointer to current character in search string
* tmp1 = Pointer to current character in unpacked line in framebuffer
* tmp2 = Loop counter for character in unpacked line (=line length at start)
* tmp3 = Matching character counter
* tmp4 = Character counter in unpacked line
* r1   = Additional temp variable
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
        dect  stack
        mov   r1,*stack             ; Push r1
        ;------------------------------------------------------        
        ; Initialisation
        ;------------------------------------------------------ 
        bl    @edb.find.init        ; Initialize memory for find functionality

        bl    @cpym2m
              data cmdb.cmdall,edb.srch.str,80
                                    ; Set search string to input value

        movb  @cmdb.cmdlen,tmp0     ; \ Get length of search string
        srl   tmp0,8                ; | MSB to LSB
        mov   tmp0,@edb.srch.strlen ; / Save search string length

        jgt   !                     ; Continue if length search string > 0
        b     @edb.find.scan.exit   ; Exit early on empty search string

!       c     @edb.block.m1,@w$ffff   ; Marker M1 unset?
        jeq   edb.find.scan.showbusy  ; Unset skip block marker
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

        bl    @putat                
              byte pane.botrow,13
              data edb.srch.str     ; Show search string
                                    

        mov   @edb.srch.startln,@fh.records           
                                    ; Counter current line
        ;------------------------------------------------------
        ; Loop over lines in editor buffer, Unpack current line
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
        clr   tmp3                   ; Reset character match counter
        clr   tmp4                   ; Reset character counter
        clr   @edb.srch.matchcol     ; Update start column of possible match
        ;------------------------------------------------------
        ; Loop over characters in unpacked line and compare
        ;------------------------------------------------------
edb.find.scan.compare:
        cb    *tmp0+,*tmp1+         ; Compare characters in MSB
        jne   edb.find.scan.compare.nomatch
                                    ; Characters do not match. Next try.
        ;------------------------------------------------------
        ; Character matches
        ;------------------------------------------------------        
        inc   tmp3                  ; Update character match counter
        inc   tmp4                  ; Update character counter
        c     tmp3,@edb.srch.strlen ; Last character in search string?
        jne   edb.find.scan.compare.nextchar
                                    ; Not yet, prepare for scanning next char
        ;------------------------------------------------------
        ; Search string found. Update search results index (rows + cols)
        ;------------------------------------------------------
        mov   @edb.srch.offset,r1   ; Restore offset in row index
        mov   @fh.records,@edb.srch.idx.rtop(r1)
                                    ; \ Save linenumber to search results
                                    ; | index for rows
        inct  @edb.srch.offset      ; / Next entry in search results row index

        mov   @edb.srch.matches,r1  ; \ Restore offset in column index
                                    ; / Using matches as byte offset in index
        movb  @edb.srch.matchcol+1,@edb.srch.idx.ctop(r1)
                                    ; \ Save column (LSB) to search results
                                    ; | index for columns
        inc   @edb.srch.matches     ; / Update search string match counter

        bl    @putnum
              byte 0,74             ; Show number of matches
              data edb.srch.matches,rambuf,>3020
        ;------------------------------------------------------
        ; Check if match buffer is full
        ;------------------------------------------------------
        li    tmp0,512               ; \ 512 matches reached?
        c     @edb.srch.matches,tmp0 ; / 
        jeq   edb.find.scan.bufffull ; Buffer is full, halt scan

        li    tmp0,edb.srch.str + 1  ; Reset source for compare (skip len byte)
        jmp   edb.find.scan.compare.nextchar
        ;------------------------------------------------------
        ; Buffer is full
        ;------------------------------------------------------
edb.find.scan.bufffull:
        li   tmp0,txt.memfull.load  ; \ Set 'index full' message
        mov  tmp0,@waux1            ; / 
        jmp  edb.find.scan.done     ; We're done
        ;------------------------------------------------------
        ; Search string not found. Next try on remaining chars on line
        ;------------------------------------------------------
edb.find.scan.compare.nomatch        
        li    tmp0,edb.srch.str + 1   ; Reset source for compare (skip len byte)
        clr   tmp3                    ; Reset character match counter
        inc   tmp4                    ; Update character counter
        mov   tmp4,@edb.srch.matchcol ; \ Update start column of possible match
                                      ; | Start column is updated only if there
                                      ; / is NO matching character.
        ;------------------------------------------------------
        ; Prepare for processing next character
        ;------------------------------------------------------        
edb.find.scan.compare.nextchar:
        dec   tmp2                  ; Update loop counter
        jgt   edb.find.scan.compare ; Line not completely scanned
        ;------------------------------------------------------
        ; Prepare for processing Next line
        ;------------------------------------------------------
edb.find.scan.nextline:        
        inc   @fh.records           ; Increase line counter
        abs   @fh.records           ; \  Display line counter
        jop   edb.find.scan.show    ; /  update sporadically
        jmp   edb.find.scan.checkcomplete        
        ;------------------------------------------------------
        ; Show line counter
        ;------------------------------------------------------
edb.find.scan.show:
        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Check for keyboard interrupt <FCTN-4>
        ;------------------------------------------------------
        bl    @>0020                ; Check keyboard. Destroys r12
        jne   edb.find.scan.checkcomplete
                                    ; No FCTN-4 pressed
        ;------------------------------------------------------
        ; Interrupt occured
        ;------------------------------------------------------
        li    tmp0,txt.abort.search ; \ 
        mov   tmp0,@waux1           ; / Set Search aborted message
        jmp   edb.find.scan.done    ; Exit scan
        ;------------------------------------------------------
        ; Check if scan is complete
        ;------------------------------------------------------
edb.find.scan.checkcomplete:
        c     @fh.records,@edb.srch.endln
                                    ; All lines scanned ?                                

        jne   edb.find.scan.unpack_line
                                    ; Not yet, process next line

        li   tmp0,txt.done.search   ; \ 
        mov  tmp0,@waux1            ; / Set Search completed message        
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

        bl    @pane.botline.busy.off ; \ Put busyline indicator off
                                     ; /
        ;------------------------------------------------------
        ; Scan completed. Display final message (set in @waux1)
        ;------------------------------------------------------ 
        bl    @hchar
              byte 0,50,32,20       
              data EOL              ; Erase any previous message
              
        bl    @at
              byte 0,52             ; Position cursor

        mov   @waux1,tmp1           ; Message to display

        bl    @xutst0               ; Display string
                                    ; \ i  tmp1 = Pointer to string
                                    ; / i  @wyx = Cursor position at
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------          
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.find.scan.exit:
        mov   *stack+,r1            ; Pop r1
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

txt.abort.search   stri 'Search aborted'
                   even
txt.done.search    stri 'Search completed'
                   even

* FILE......: idx.asm
* Purpose...: Index management

***************************************************************
*  Size of index page is 4K and allows indexing of 2048 lines
*  per page.
* 
*  Each index slot (word) has the format:
*    +-----+-----+
*    | MSB | LSB |   
*    +-----|-----+   LSB = Pointer offset 00-ff.
*                      
*  MSB = SAMS Page 00-ff
*        Allows addressing of up to 256 4K SAMS pages (1024 KB)
*    
*  LSB = Pointer offset in range 00-ff
*
*        To calculate pointer to line in Editor buffer:
*        Pointer address = edb.top + (LSB * 16)
*
*        Note that the editor buffer itself resides in own 4K memory range
*        starting at edb.top
*
*        All support routines must assure that length-prefixed string in
*        Editor buffer always start on a 16 byte boundary for being
*        accessible via index.
***************************************************************


***************************************************************
* idx.init
* Initialize index
***************************************************************
* bl @idx.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
idx.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,idx.top
        mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure

        mov   @tv.sams.b000,tmp0    
        mov   tmp0,@idx.sams.page   ; Set current SAMS page
        mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
        ;------------------------------------------------------
        ; Clear all index pages
        ;------------------------------------------------------
        ai    tmp0,4                ; \ Let's clear all index pages
        mov   tmp0,@idx.sams.hipage ; / 

        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continuous memory region                

        bl    @film
              data idx.top,>00,idx.size * 5
                                    ; Clear index

        bl    @_idx.sams.mapcolumn.off 
                                    ; Restore memory window layout

        mov   @idx.sams.lopage,@idx.sams.hipage 
                                    ; Reset last SAMS page                                    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.init.exit:        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* bl @_idx.sams.mapcolumn.on
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside idx module
********|*****|*********************|**************************
_idx.sams.mapcolumn.on:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
*--------------------------------------------------------------
* Map index pages into memory window  (b000-ffff)
*--------------------------------------------------------------
        mov   @idx.sams.lopage,tmp0 ; Get lowest index page
        li    tmp1,idx.top          
        li    tmp2,5                ; Set loop counter. all pages of index
        ;-------------------------------------------------------
        ; Loop over banks
        ;------------------------------------------------------- 
!       bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory address

        inc   tmp0                  ; Next SAMS index page
        ai    tmp1,>1000            ; Next memory region
        dec   tmp2                  ; Update loop counter
        jgt   -!                    ; Next iteration
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
_idx.sams.mapcolumn.on.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller       


***************************************************************
* _idx.sams.mapcolumn.off
* Restore normal SAMS layout again (single index page)
***************************************************************
* bl @_idx.sams.mapcolumn.off
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside idx module
********|*****|*********************|**************************
_idx.sams.mapcolumn.off:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
*--------------------------------------------------------------
* Map index pages into memory window  (b000-????)
*--------------------------------------------------------------
        li    tmp1,idx.top
        li    tmp2,5                ; Always 5 pages
        li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
        ;-------------------------------------------------------
        ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
        ;------------------------------------------------------- 
!       mov   *tmp3+,tmp0           ; Get SAMS page

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory address

        ai    tmp1,>1000            ; Next memory region
        dec   tmp2                  ; Update loop counter
        jgt   -!                    ; Next iteration
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
_idx.sams.mapcolumn.off.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller



***************************************************************
* _idx.samspage.get
* Get SAMS page for index
***************************************************************
* bl @_idx.samspage.get
*--------------------------------------------------------------
* INPUT
* tmp0 = Line number
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Offset for index entry in index SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside idx module.
*  Activates SAMS page containing required index slot entry.
********|*****|*********************|**************************
_idx.samspage.get:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Determine SAMS index page
        ;------------------------------------------------------
        mov   tmp0,tmp2             ; Line number
        clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
        li    tmp0,2048             ; Index entries in 4K SAMS page

        div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
                                    ; | tmp1 = quotient  (SAMS page offset)
                                    ; / tmp2 = remainder

        sla   tmp2,1                ; line number * 2                                    
        mov   tmp2,@outparm1        ; Offset index entry

        a     @idx.sams.lopage,tmp1 ; Add SAMS page base
        c     tmp1,@idx.sams.page   ; Page already active?

        jeq   _idx.samspage.get.exit
                                    ; Yes, so exit
        ;------------------------------------------------------
        ; Activate SAMS index page
        ;------------------------------------------------------
        mov   tmp1,@idx.sams.page   ; Set current SAMS page
        mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie

        mov   tmp1,tmp0             ; Destination SAMS page
        li    tmp1,>b000            ; Memory window for index page

        bl    @xsams.page.set       ; Switch to SAMS page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Check if new highest SAMS index page
        ;------------------------------------------------------
        c     tmp0,@idx.sams.hipage ; New highest page?        
        jle   _idx.samspage.get.exit 
                                    ; No, exit
        mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_idx.samspage.get.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
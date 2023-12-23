* FILE......: fm.browse.asm
* Purpose...: File Manager - File browse support routines


*---------------------------------------------------------------
* Pick previous filename in catalog filename list
*---------------------------------------------------------------
* bl   @fm.browse.fname.prev
********|*****|*********************|**************************
fm.browse.fname.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;------------------------------------------------------
        ; Previous filename in catalog filename list
        ;------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0
        jeq   fm.browse.fname.prev.exit ; First file in catalog reached
        dec   @cat.shortcut.idx         ; Previous file in catalog
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.prev.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Pick next filename in catalog filename list
*---------------------------------------------------------------
* bl   @fm.browse.fname.next
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.browse.fname.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Next filename in catalog filename list
        ;------------------------------------------------------
        c     @cat.shortcut.idx,@cat.filecount
        jlt   !
        jmp   fm.browse.fname.next.exit   ; Last file reached
!       inc   @cat.shortcut.idx           ; Next file in catalog
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.next.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

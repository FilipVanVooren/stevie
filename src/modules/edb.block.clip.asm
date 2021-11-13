* FILE......: edb.block.clip.asm
* Purpose...: Save block to clipboard

***************************************************************
* edb.block.clip
* Save block to specified clipboard
***************************************************************
*  bl   @edb.block.clip
*--------------------------------------------------------------
* INPUT
* @edb.clip.filename = Device and filename of clipboard
* @edb.block.m1      = Marker M1 line
* @edb.block.m2      = Marker M2 line
* @parm1             = Suffix clipboard file (none, 0-9)
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
edb.block.clip:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------        
        ; Asserts
        ;------------------------------------------------------        
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   edb.block.clip.exit   ; Yes, exit early

        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edb.block.clip.exit   ; Yes, exit early

        c     @edb.block.m1,@edb.block.m2
                                    ; M1 > M2 ?
        jgt   edb.block.clip.exit   ; Yes, exit early
        ;------------------------------------------------------
        ; Generate clipboard device/file name
        ;------------------------------------------------------
        bl    @cpym2m
              data edb.clip.filename,heap.top,80

        mov   @parm1,tmp0           ; Check if suffix necessary
        jeq   edb.block.clip.save   ; No suffix, skip to save
        ;------------------------------------------------------
        ; Append suffix character to clipboard device/filename
        ;------------------------------------------------------
        mov   @edb.clip.filename,tmp0
        mov   tmp0,tmp1                                               
        srl   tmp0,8                ; Get string length
        ai    tmp0,heap.top         ; Add base
        inc   tmp0                  ; Consider length-prefix byte
        movb  @parm1,*tmp0          ; Append suffix 

        ai    tmp1,>0100            ; \ Update clipboard string length
        movb  tmp1,@heap.top        ; /
        ;------------------------------------------------------
        ; Save code block M1-M2 to clipboard
        ;------------------------------------------------------
edb.block.clip.save:
        li    tmp0,heap.top         ; \ Set pointer to clipboard filename
        mov   tmp0,@parm1           ; / 

        mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
        dec   @parm2                ; /

        mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
        bl    @fm.savefile          ; Save DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; |            device/filename string
                                    ; | i  parm2 = First line to save (base 0)
                                    ; | i  parm3 = Last line to save  (base 0)
                                    ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.clip.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
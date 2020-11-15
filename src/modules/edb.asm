* FILE......: edb.asm
* Purpose...: Stevie Editor - Editor Buffer module

***************************************************************
* edb.init
* Initialize Editor buffer
***************************************************************
* bl @edb.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
***************************************************************
edb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,edb.top          ; \
        mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
        mov   tmp0,@edb.next_free.ptr
                                    ; Set pointer to next free line

        seto  @edb.insmode          ; Turn on insert mode for this editor buffer

        li    tmp0,1
        mov   tmp0,@edb.lines       ; Lines=1

        seto  @edb.block.m1         ; Reset block start line marker
        seto  @edb.block.m2         ; Reset block end line marker

        li    tmp0,txt.newfile      ; "New file"
        mov   tmp0,@edb.filename.ptr

        li    tmp0,txt.filetype.none
        mov   tmp0,@edb.filetype.ptr

edb.init.exit:        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        





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
********|*****|*********************|**************************
edb.init:
        .pushregs 0                 ; Push registers and return address on stack
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

        seto  @edb.block.m1         ; Reset block start line
        seto  @edb.block.m2         ; Reset block end line

        mov   @tv.lineterm,@edb.lineterm
                                    ; Set line termination char from default

        li    tmp0,txt.newfile      ; "New file"
        mov   tmp0,@edb.filename.ptr

        clr   @fh.kilobytes         ; \ Clear kilobytes processed
        clr   @fh.kilobytes.prev    ; /

        li    tmp0,txt.filetype.none
        mov   tmp0,@edb.filetype.ptr
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.init.exit:        
        .popregs 0                  ; Pop registers and return to caller        

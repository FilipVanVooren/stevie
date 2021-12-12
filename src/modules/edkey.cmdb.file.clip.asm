* FILE......: edkey.cmdb.fíle.clip.asm
* Purpose...: Copy clipboard file to line

*---------------------------------------------------------------
* Copy clipboard file to line
*---------------------------------------------------------------
edkey.action.cmdb.clip.1
        li    tmp0,clip1
        jmp   edkey.action.cmdb.clip

edkey.action.cmdb.clip.2
        li    tmp0,clip2
        jmp   edkey.action.cmdb.clip

edkey.action.cmdb.clip.3
        li    tmp0,clip3
        jmp   edkey.action.cmdb.clip

edkey.action.cmdb.clip.4
        li    tmp0,clip4
        jmp   edkey.action.cmdb.clip

edkey.action.cmdb.clip.5
        li    tmp0,clip5
        jmp   edkey.action.cmdb.clip


edkey.action.cmdb.clip:
        mov   tmp0,@parm1           ; Get clipboard suffix 0-9

        bl    @film
              data cmdb.cmdall,>00,80

        bl    @cpym2m
              data tv.clip.fname,cmdb.cmdall,80
        ;------------------------------------------------------
        ; Append suffix character to clipboard device/filename
        ;------------------------------------------------------
        mov   @tv.clip.fname,tmp0
        mov   tmp0,tmp1                                               
        srl   tmp0,8                ; Get string length
        ai    tmp0,cmdb.cmdall      ; Add base
        inc   tmp0                  ; Consider length-prefix byte
        movb  @parm1,*tmp0          ; Append suffix 

        b     @edkey.action.cmdb.insert
                                    ; Insert file

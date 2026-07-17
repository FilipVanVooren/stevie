* FILE......: edk.cmdb.file.clip.asm
* Purpose...: Copy clipboard file to line

*---------------------------------------------------------------
* Copy clipboard file to line
*---------------------------------------------------------------
edk.act.cmdb.clip.1
        li    tmp0,clip1
        jmp   edk.act.cmdb.clip

edk.act.cmdb.clip.2
        li    tmp0,clip2
        jmp   edk.act.cmdb.clip

edk.act.cmdb.clip.3
        li    tmp0,clip3
        jmp   edk.act.cmdb.clip



edk.act.cmdb.clip:
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

        b     @edk.act.cmdb.insert
                                    ; Insert file

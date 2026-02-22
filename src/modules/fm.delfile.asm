* FILE......: fm.delfile.asm
* Purpose...: File Manager - Delete file from filesystem
***************************************************************
* fm.delfile
* Delete file from filesystem
***************************************************************
* bl  @fm.delfile
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
* parm2  = Pointer to callback function "Before deleting file"
* parm3  = Pointer to callback function "File deleted"
* parm4  = Pointer to callback function "File I/O error"
*--------------------------------------------------------------- 
* OUTPUT
* outparm1 = >0000 delete success, >FFFF delete failed
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.delfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        dect  stack
        mov   @parm4,*stack         ; Push @parm4
        ;-------------------------------------------------------
        ; Delete file
        ;-------------------------------------------------------
        clr   @parm2                      ; Clear callback 1
        
        li    tmp0,fm.delfile.callback2   ; Pointer to callback 2
        mov   tmp0,@parm3                 ; Register callback 2

        li    tmp0,fm.loadsave.cb.fioerr  ; Pointer to callback 3
        mov   tmp0,@parm4                 ; Register callback 3                

        bl    @fh.file.delete       ; Delete file from filesystem
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "Before deleting file"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "File deleted"
                                    ; | i  @parm4 = Pointer to callback
                                    ; /             "File I/O error"
        ;-------------------------------------------------------
        ; Refresh directory if delete was successful
        ;-------------------------------------------------------
        mov   @outparm1,tmp0        ; Check result of delete operation
        jne   fm.delfile.exit       ; Delete failed, exit
        ;-------------------------------------------------------
        ; Read directory and exit
        ;-------------------------------------------------------
fm.delfile.refreshdir:        
        li    tmp0,tv.devpath       ; \ 
        mov   tmp0,@parm1           ; | Pass directory path as parm1
        clr   @parm2                ; /
 
        seto  @parm3                ; Skip filebrowser after reading directory
        
        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; |          (ignored if parm1 set)
                                    ; / @parm3 = Skip filebrowser flag

*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.delfile.exit:
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

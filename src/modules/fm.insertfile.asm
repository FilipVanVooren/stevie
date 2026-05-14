* FILE......: fm.insertfile.asm
* Purpose...: File Manager - Insert (or append) file into editor buffer

***************************************************************
* fm.insertfile
* Insert (or append) file into editor buffer
***************************************************************
* bl  @fm.insertfile
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
* parm2  = Line number to load file at
* parm3  = Work mode
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fm.insertfile:
        .pushregs 2                 ; Push return address and registers on stack
        .pushparms 3                ; Push parameters p1-p3 on stack
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        mov   @parm2,@fh.line       ; Get line number
        mov   @parm3,@fh.workmode   ; Work mode

        li    tmp0,fm.loadsave.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadsave.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadsave.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadsave.cb.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        li    tmp0,fm.load.cb.memfull
        mov   tmp0,@parm6           ; Register callback 5

        bl    @fh.file.read.edb     ; Read file into editor buffer
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "Before Open file"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "Read line from file"
                                    ; | i  @parm4 = Pointer to callback
                                    ; |             "Close file"
                                    ; | i  @parm5 = Pointer to callback 
                                    ; |             "File I/O error"
                                    ; | i  @parm6 = Pointer to callback
                                    ; |             "Memory full error"
                                    ; | i  @fh.line = Line number to insert file at or >FFFF
                                    ; | i  @fh.workmode = Work mode (used in callbacks)
                                    ; /                                                                        
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.insertfile.exit:
        .popparms 3                 ; Pop parameters p3-p1 from stack
        .popregs 2                  ; Pop registers and return to caller                        

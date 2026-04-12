* FILE......: fm.newfile.asm
* Purpose...: File Manager - New file in editor buffer

***************************************************************
* fm.newfile
* New file in editor buffer, clear everything out
***************************************************************
* bl  @fm.newfile
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
fm.newfile:
        .pushregs 1                 ; Push return address and registers on stack
*--------------------------------------------------------------
* Put message
*--------------------------------------------------------------
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /
        bl    @putat
              byte pane.botrow,0
              data txt.clearmem     ; Display "Clearing memory...."         
*--------------------------------------------------------------
* Clear SAMS pages and exit editor
*--------------------------------------------------------------
        bl    @edb.clear.sams       ; Clear SAMS memory used by editor buffer
        bl    @tv.reset             ; Reset editor        
*--------------------------------------------------------------
* Remove message
*--------------------------------------------------------------
        bl    @hchar
              byte 0,0,32,80
              data EOL              ; Clear top row and hint on bottom row

        clr   @tv.specmsg.ptr       ; Remove any special message

        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /        
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.newfile.exit:
        .popregs 1                  ; Pop registers and return to caller                

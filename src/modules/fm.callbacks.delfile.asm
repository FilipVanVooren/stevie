* FILE......: fm.callbacks.delfile.asm
* Purpose...: File Manager - Callbacks for delete file operation

***************************************************************
* fm.delfile.callback2
* Callback function "File deleted"
***************************************************************
* bl  @fm.delfile.callback2
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback3
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.delfile.callback2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off ; Put busyline indicator off
        ;-------------------------------------------------------
        ; Show message 'File deleted'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.done.delete  ; File deleted message
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay                                    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.delfile.callback2.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

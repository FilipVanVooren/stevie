* FILE......: fm.callbacks.dir.asm
* Purpose...: File Manager - Callbacks for drive/directory listing

*---------------------------------------------------------------
* Callback function "Before open file"
* Open file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback1
*---------------------------------------------------------------
fm.dir.callback1:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback1.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Read line from file"
* Read line from file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback2
*---------------------------------------------------------------
fm.dir.callback2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback2.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Close file"
* Close file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback3
*---------------------------------------------------------------
fm.dir.callback3:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback3.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "File I/O error"
* File I/O error
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback4
*---------------------------------------------------------------
fm.dir.callback4:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback4.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Memory full"
* Memory full
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback5
*---------------------------------------------------------------
fm.dir.callback5:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback5.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: fm.callbacks.clock.asm
* Purpose...: File Manager - Callbacks for clock device

*---------------------------------------------------------------
* Callback function "Read Date/Time from clock device"
* After reading date/time from clock device
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback1
*---------------------------------------------------------------
fm.read.clock.cb.stopflag:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Stop after reading line from clock device
        ;------------------------------------------------------
        seto  @fh.circbreaker       ; Read single line only
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.read.clock.cb.stopflag.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

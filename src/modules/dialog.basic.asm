* basic......: dialog.basic.asm
* Purpose....: Dialog "Basic"

***************************************************************
* dialog.basic
* Open Dialog "Basic"
***************************************************************
* bl @dialog.basic
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
dialog.basic:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.basic
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.basic
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.basic
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.basic
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.basic2
        mov   tmp0,@cmdb.panhint2   ; Hint in bottom second line

        clr   @cmdb.panhint         ; Clear hint for bottom line
        li    tmp0,txt.keys.basic3  ; Default keylist, adjust later
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Exit early if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor locked?
        jne   dialog.basic.exit     ; Yes, exit
        ;-------------------------------------------------------
        ; Continue with dialog setup
        ;-------------------------------------------------------
        mov   @tib.session,tmp0     ; Already did session before?
        jeq   dialog.basic.autounpk ; No, skip extra hint handling
        ;-------------------------------------------------------
        ; Show extra hint for unpacking TI Basic program
        ;-------------------------------------------------------
        bl    @cpym2m               ; Copy hint string to RAM
              data txt.hint.basic,ram.msg1,70

        mov   @tib.session,tmp0     ; Get current TI Basic session
        ai    tmp0,48               ; Add ASCII offset 0
        swpb  tmp0                  ; \ Poke session number into message
        movb  tmp0,@ram.msg1+54     ; /
        ;-------------------------------------------------------
        ; Add current line in editor buffer to message
        ;-------------------------------------------------------
        mov   @fb.row,@parm1
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB
        inc   @outparm1             ; Add base 1

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data outparm1         ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        clr   @rambuf+6             ; Clear bytes 7-8 in ram buffer
        clr   @rambuf+8             ; Clear bytes 9-10 in ram buffer
        clr   @rambuf+10            ; Clear bytes 11-12 in ram buffer
        
        bl    @trimnum              ; Trim number string
              data rambuf           ; \ i  p1 = Source
              data rambuf + 6       ; | i  p2 = Destination
              data 32               ; / i  p3 = Padding character to scan

        bl    @cpym2m               ; Copy trimmed number to message
              data rambuf + 7,ram.msg1 + 64,5
        ;-------------------------------------------------------
        ; Add message to hint
        ;-------------------------------------------------------
        li    tmp0,ram.msg1         ; \ Display extra hint
        mov   tmp0,@cmdb.panhint    ; / "Press SPACE to unpack program from ..."
        ;-------------------------------------------------------
        ; AutoUnpack flag handling
        ;-------------------------------------------------------
dialog.basic.autounpk:
        mov   @tib.autounpk,tmp0    ; Get 'AutoUnpack' flag
        jeq   !
        ;-------------------------------------------------------
        ; Flag is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.basic2
        jmp   dialog.basic.done
        ;-------------------------------------------------------
        ; Flag is off
        ;-------------------------------------------------------
!       mov   @tib.session,tmp0     ; Already did session before?
        jeq   dialog.basic.amonly   ; No, only AutoUnpack

        li    tmp0,txt.keys.basic1  ; Add "Unpack" option to keylist
        jmp   dialog.basic.done
        ;-------------------------------------------------------
        ; AutoUnpack option only
        ;-------------------------------------------------------
dialog.basic.amonly:
        li    tmp0,txt.keys.basic   ; Only AutoUnpack
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.basic.done:
        mov   tmp0,@cmdb.pankeys    ; Save keylist in status line
        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.basic.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

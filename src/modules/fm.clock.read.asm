* FILE......: fm.readclock.asm
* Purpose...: File Manager - Catalog drive/directory


***************************************************************
* fm.clock.read
* Read date & time from clock device
***************************************************************
* bl  @fm.clock.read
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------- 
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fm.clock.read:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        dect  stack
        mov   @parm4,*stack         ; Push @parm4
        dect  stack
        mov   @parm5,*stack         ; Push @parm5
        dect  stack
        mov   @parm6,*stack         ; Push @parm6
        dect  stack
        mov   @parm7,*stack         ; Push @parm7
        dect  stack
        mov   @parm8,*stack         ; Push @parm8     
        dect  stack
        mov   @parm9,*stack         ; Push @parm9
        ;-------------------------------------------------------
        ; Read clock data into memory
        ;-------------------------------------------------------
        li    tmp0,def.clock        ; \ Pointer to clock device string
        mov   tmp0,@parm1           ; / 
        clr   @parm2                ; Callback function "Before open file"

        li    tmp0,fm.clock.read.cb.stopflag
        mov   tmp0,@parm3           ; Callback function "Read line from file"
        
        clr   @parm4                ; Callback function "Close file"
        clr   @parm5                ; Callback function "Memory full error"
        clr   @parm6                ; Callback function "Memory full"
        
        li    tmp0,fh.clock.datetime
        mov   tmp0,@parm7           ; Destination RAM memory address

        li    tmp0,fh.file.pab.clock
        mov   tmp0,@parm8           ; PAB Header template for reading clock

        li    tmp0,io.rel.inp.dis.var
        mov   tmp0,@parm9           ; File type/mode for reading catalog                
        ;-------------------------------------------------------
        ; Read data into memory
        ;-------------------------------------------------------
        bl    @fh.file.read.mem     ; Read file into memory
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
                                    ; | i  @parm7 = Destination RAM address
                                    ; | i  @parm8 = PAB template address in
                                    ; |             ROM/RAM 
                                    ; | i  @parm9 = File type/mode (in LSB), 
                                    ; /             becomes PAB byte 1
        ;-------------------------------------------------------
        ; Check if file was read successfully
        ;-------------------------------------------------------
        mov   @fh.clock.datetime,tmp0  ; Data read from clock device?
        jne   fm.readclock.exit        ; yes, exit
        bl    @fm.clock.off            ; No, turn clock off (reset clock data)

*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.readclock.exit:
        mov   *stack+,@parm9        ; Pop @parm9
        mov   *stack+,@parm8        ; Pop @parm8
        mov   *stack+,@parm7        ; Pop @parm7
        mov   *stack+,@parm6        ; Pop @parm6
        mov   *stack+,@parm5        ; Pop @parm5
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

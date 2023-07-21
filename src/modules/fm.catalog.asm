* FILE......: fm.catalog.asm
* Purpose...: File Manager - Catalog drive/directory


***************************************************************
* fm.catalog
* Catalog drive/directory
***************************************************************
* bl  @fm.catalog
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
*--------------------------------------------------------------- 
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.catalog:
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
        ; Read catalog into memory
        ;-------------------------------------------------------
        li    tmp0,fm.cat.callback1 ; Callback function "Before open file"
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.cat.callback2 ; Callback function "Read line from file"
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.cat.callback3 ; Callback function "Close file"
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.cat.callback4 ; Callback function "File I/O error"
        mov   tmp0,@parm5           ; Register callback 4

        li    tmp0,fm.cat.callback5 ; Callback function "Memory full"
        mov   tmp0,@parm6           ; Register callback 5

        li    tmp0,>e000
        mov   tmp0,@parm7           ; Destination RAM memory address

        li    tmp0,fh.file.pab.header.cat
        mov   tmp0,@parm8           ; PAB Header template for reading catalog        

        li    tmp0,io.rel.inp.int.fix
        mov   tmp0,@parm9           ; File type/mode for reading catalog

        li    tmp0,myfile
        mov   tmp0,@parm1

        bl    @fh.file.read.mem     ; Read file into editor buffer
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
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.catalog.exit:
        mov   *stack+,@parm9        ; Pop @parm9
        mov   *stack+,@parm8        ; Pop @parm8
        mov   *stack+,@parm7        ; Pop @parm7
        mov   *stack+,@parm6        ; Pop @parm6
        mov   *stack+,@parm5        ; Pop @parm5
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

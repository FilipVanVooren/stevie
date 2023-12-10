* FILE......: fm.directory.asm
* Purpose...: File Manager - Catalog drive/directory


***************************************************************
* fm.directory
* Catalog drive/directory
***************************************************************
* bl  @fm.catalog
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing device
*          or >0000 if using parm2.
* parm2  = Index in device list (ignored if parm1 set)
*--------------------------------------------------------------- 
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.directory:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
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
        ;------------------------------------------------------
        ; Clear catalog space
        ;------------------------------------------------------
        bl    @film
              data cat.top,>00,cat.size
                                    ; Clear it all the way
        ;-------------------------------------------------------
        ; Process parameters
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Use parameter 2?
        jne   fm.directory.read     ; No, skip

        mov   @parm2,tmp0           ; Get index
        sla   tmp0,1                ; Word align
        mov   @device.list(tmp0),@parm1
                                    ; Set device string
        ;-------------------------------------------------------
        ; Read drive/directory catalog into memory
        ;-------------------------------------------------------
fm.directory.read:        
        li    tmp0,fm.dir.callback1 ; Callback function "Before open file"
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.dir.callback2 ; Callback function "Read line from file"
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.dir.callback3 ; Callback function "Close file"
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.dir.callback4 ; Callback function "File I/O error"
        mov   tmp0,@parm5           ; Register callback 4

        li    tmp0,fm.dir.callback5 ; Callback function "Memory full"
        mov   tmp0,@parm6           ; Register callback 5

        li    tmp0,rambuf
        mov   tmp0,@parm7           ; Destination RAM memory address

        li    tmp0,fh.file.pab.header.cat
        mov   tmp0,@parm8           ; PAB Header template for reading catalog        

        li    tmp0,io.rel.inp.int.fix
        mov   tmp0,@parm9           ; File type/mode for reading catalog

        mov   @parm1,tmp0           ; Get device name
        li    tmp1,cat.device
        
        movb  *tmp0,tmp2            ; \ Get number of bytes to copy
        srl   tmp2,8                ; | including length byte itself.
        inc   tmp2                  ; /

        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy

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
        ; Generate string list with filesizes
        ;-------------------------------------------------------
        li    tmp0,cat.fslist       ; Set pointer to filesize list
        li    tmp1,cat.sizelist     ; Set pointer to filesize string list
        mov   @cat.filecount,tmp2   ; Number of files to process
        jeq   fm.directory.browser  ; Skip to browser if no files to process

        mov   tmp0,@cat.var1        ; Save pointer to filesize list
        mov   tmp1,@cat.var2        ; Save pointer to filesize string list
        mov   tmp2,@cat.var3        ; Set loop counter
        ;-------------------------------------------------------
        ; Loop over files
        ;-------------------------------------------------------
        ; @cat.var1 = Pointer to filesize list
        ; @cat.var2 = Pointer to filesize string list
        ; @cat.var3 = Loop counter
        ; @cat.var4 = File size (word)
        ;-------------------------------------------------------
fm.directory.fsloop:
        mov   @cat.var1,tmp0        ; Get pointer to filesize list        
        movb  *tmp0,tmp1            ; Get file size
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@cat.var4        ; Save word aligned file size
        inc   @cat.var1             ; Advance pointer
        ;-------------------------------------------------------
        ; Convert unsigned number to string and trim
        ;-------------------------------------------------------
        bl    @mknum                ; Convert unsigned number to string
              data  cat.var4        ; \ i  p1    = Source
              data  rambuf          ; | i  p2    = Destination
              byte  48              ; | i  p3MSB = ASCII offset
              byte  32              ; / i  p3LSB = Padding character
        ;-------------------------------------------------------
        ; Copy number string to destination in file size list
        ;-------------------------------------------------------        
        li    tmp0,rambuf+2         ; Memory source address
        mov   @cat.var2,tmp1        ; Memory destination address
        li    tmp2,>0300            ; \ Length of number
        movb  tmp2,*tmp1+           ; / Set length byte prefix at destination

        li    tmp2,3                ; Number of bytes to copy                                
        a     tmp2,@cat.var2        ; Advance pointer in filesize string list
        inc   @cat.var2             ; Include length byte
        
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;-------------------------------------------------------
        ; Prepare for next file
        ;-------------------------------------------------------
        dec   @cat.var3             ; Adjust file counter
        jgt   fm.directory.fsloop   ; Next file

        ;-------------------------------------------------------
        ; Generate string list with file types
        ;-------------------------------------------------------
        li    tmp0,cat.ftlist       ; Set pointer to filetype list
        li    tmp1,cat.sizelist     ; Set pointer to filetype string list
        mov   @cat.filecount,tmp2   ; Number of files to process
        jeq   fm.directory.browser  ; Skip to browser if no files to process

        mov   tmp0,@cat.var1        ; Save pointer to filetype list
        mov   tmp1,@cat.var2        ; Save pointer to filetype string list
        mov   tmp2,@cat.var3        ; Set loop counter
        ;-------------------------------------------------------
        ; Loop over files
        ;-------------------------------------------------------
        ; @cat.var1 = Pointer to filetype list
        ; @cat.var2 = Pointer to filetype string list
        ; @cat.var3 = Loop counter
        ; @cat.var4 = File size (word)
        ;-------------------------------------------------------
fm.directory.ftloop:
        mov   @cat.var1,tmp0        ; Get pointer to filetype list        
        movb  *tmp0,tmp1            ; Get file size
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@cat.var4        ; Save word aligned file size
        inc   @cat.var1             ; Advance pointer
        ;-------------------------------------------------------
        ; Convert unsigned number to string and trim
        ;-------------------------------------------------------
        bl    @mknum                ; Convert unsigned number to string
              data  cat.var4        ; \ i  p1    = Source
              data  rambuf          ; | i  p2    = Destination
              byte  48              ; | i  p3MSB = ASCII offset
              byte  32              ; / i  p3LSB = Padding character
        ;-------------------------------------------------------
        ; Copy number string to destination in file size list
        ;-------------------------------------------------------        
        li    tmp0,rambuf+2         ; Memory source address
        mov   @cat.var2,tmp1        ; Memory destination address
        li    tmp2,>0300            ; \ Length of number
        movb  tmp2,*tmp1+           ; / Set length byte prefix at destination

        li    tmp2,3                ; Number of bytes to copy                                
        a     tmp2,@cat.var2        ; Advance pointer in filesize string list
        inc   @cat.var2             ; Include length byte
        
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;-------------------------------------------------------
        ; Prepare for next file
        ;-------------------------------------------------------
        dec   @cat.var3             ; Adjust file counter
        jgt   fm.directory.fsloop   ; Next file

*--------------------------------------------------------------
* Show filebrowser
*--------------------------------------------------------------        
fm.directory.browser:
        bl    @pane.filebrowser     ; Browse files

*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.directory.exit:
        mov   *stack+,@parm9        ; Pop @parm9
        mov   *stack+,@parm8        ; Pop @parm8
        mov   *stack+,@parm7        ; Pop @parm7
        mov   *stack+,@parm6        ; Pop @parm6
        mov   *stack+,@parm5        ; Pop @parm5
        mov   *stack+,@parm4        ; Pop @parm4
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

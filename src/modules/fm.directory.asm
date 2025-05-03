* FILE......: fm.directory.asm
* Purpose...: File Manager - Catalog drive/directory


***************************************************************
* fm.directory
* Catalog drive/directory
***************************************************************
* bl  @fm.directory
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
              data cat.top,>00,cat.size - 80
                                    ; Clear catalog area except current device
                                    ; @cat.device (is at end of memory area)
        ;------------------------------------------------------
        ; Remove filepicker color bar and old files from screen
        ;------------------------------------------------------
        bl    @pane.filebrowser.colbar.remove
                                    ; Remove filepicker color bar
                                    ; i \  @cat.barpos = YX position color bar
                                    ;   /                                

        bl    @filv
              data 80,32,(pane.botrow - cmdb.rows - 1) * 80
                                    ; Clear files list on screen

        li    tmp0,vdp.tat.base + 80
        mov   @tv.color,tmp1        ; \ Get color combination (only MSB counts)
        swpb  tmp1                  ; /        
        li    tmp2,(pane.botrow - cmdb.rows - 1) * 80

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill    
        ;-------------------------------------------------------
        ; Process parameters
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Use parameter 2?
        jne   fm.directory.checkdot ; No, skip

        mov   @parm2,tmp0           ; Get index
        sla   tmp0,1                ; Word align
        mov   @device.list(tmp0),@parm1
                                    ; Set device string
        ;-------------------------------------------------------
        ; Check if last character in device name is '.'
        ;-------------------------------------------------------
fm.directory.checkdot:
        mov   @parm1,tmp0           ; Get pointer to device name
        movb  *tmp0,tmp1            ; \ Get length byte
        srl   tmp1,8                ; / 
        a     tmp1,tmp0             ; Add length to pointer base
        movb  *tmp0,tmp0            ; Get byte at pointer
        srl   tmp0,8                ; MSB to LSB
        ci    tmp0,46               ; We have a dot
        jeq   fm.directory.read     ; Read device catalog
        b     @fm.directory.exit    ; No dot, exit early
        ;-------------------------------------------------------
        ; (1) Read drive/directory catalog into memory
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
        ;-------------------------------------------------------
        ; Setup path
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Get device name
        li    tmp1,cat.device
        
        movb  *tmp0,tmp2            ; \ Get number of bytes to copy
        srl   tmp2,8                ; | including length byte itself.
        inc   tmp2                  ; /

        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;-------------------------------------------------------
        ; Read catalog into memory
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
        ; (2) Generate string list with filesizes
        ;-------------------------------------------------------
        li    tmp0,cat.fslist       ; Set pointer to filesize list
        li    tmp1,cat.sizelist     ; Set pointer to filesize string list
        mov   @cat.filecount,tmp2   ; Number of files to process
        jne   !                     ; Have files to process, continue
        b     @fm.directory.browser ; Skip to browser, no files to process

!       mov   tmp0,@cat.var1        ; Save pointer to filesize list
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
        mov   *tmp0,tmp1            ; Get file size
        mov   tmp1,@cat.var4        ; Save word aligned file size
        inct  @cat.var1             ; Advance pointer
        ;-------------------------------------------------------
        ; Convert unsigned number to string and trim
        ;-------------------------------------------------------
        szc   @wbit0,config         ; Do not show number after conversion
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
        ; (3) Generate string list with file types
        ;-------------------------------------------------------
fm.directory.ftlist:
        li    tmp0,cat.ftlist       ; Set pointer to filetype list
        li    tmp1,cat.typelist     ; Set pointer to filetype string list
        mov   @cat.filecount,tmp2   ; Number of files to process
        mov   tmp0,@cat.var1        ; Save pointer to filetype list
        mov   tmp1,@cat.var2        ; Save pointer to filetype string list
        mov   tmp2,@cat.var3        ; Set loop counter
        li    tmp3,cat.rslist       ; Set pointer to recordsize list
        mov   tmp3,@cat.var4        ; Pointer to recordsize list
        li    tmp2,>2020            ; Whitespace
        li    tmp3,>0500            ; Fixed length prefix byte in MSB        
        ;-------------------------------------------------------
        ; Loop over files
        ;-------------------------------------------------------
        ; @cat.var1 = Pointer to filetype list
        ; @cat.var2 = Pointer to filetype string list
        ; @cat.var3 = Loop counter
        ; @cat.var4 = Pointer to recordsize list
        ; @cat.var5 = Record size (word)
        ; @cat.var6 = Filetype byte (word)
        ;-------------------------------------------------------
fm.directory.ftloop:
        mov   @cat.var1,tmp0        ; \
        movb  *tmp0,tmp0            ; / Get filetype byte
        abs   tmp0                  ; Ignore write-protection
        srl   tmp0,8                ; MSB to LSB
        mov   tmp0,@cat.var6        ; Save word aligned filetype byte

        sla   tmp0,2                ; \ Multiply by 4.
                                    ; | Each filetype string is 6 bytes
                                    ; / (1 length byte) + 5 text bytes
        ;-------------------------------------------------------
        ; Get filetype string and set length prefix
        ;-------------------------------------------------------
        mov   @cat.var2,tmp1                 ; Pointer to filetype string list
        mov   @txt.filetypes(tmp0),*tmp1     ; Write length prefix byte & char 1
        movb  tmp3,*tmp1                     ; Overwrite length prefix byte 
        inct  tmp1                           ; Skip 2 bytes
        mov   @txt.filetypes+2(tmp0),*tmp1+  ; Write char 2-3
        mov   tmp2,*tmp1                     ; Fill char 4-5 with whitespace
        ;-------------------------------------------------------
        ; Only set record length for filetype 1-4 (DF,DV,IF,IV)
        ;-------------------------------------------------------
        mov   @cat.var6,tmp0                 ; Get filetype byte
        jeq   fm.directory.ftloop.prepnext   ; Offset = ftype0 ? Yes, skip
        ci    tmp0,4                         ; Offset > ftype4 ?
        jgt   fm.directory.ftloop.prepnext   ; Yes, skip
        jmp   fm.directory.ftloop.recsize    ; Build record size string
        ;-------------------------------------------------------
        ; Skip record size for other filetypes
        ;-------------------------------------------------------
fm.directory.ftloop.prepnext:
        inct  tmp1                           ; Skip char 4-5        
        jmp   fm.directory.ftloop.next       ; Next iteration
        ;-------------------------------------------------------
        ; Build recordsize string
        ;-------------------------------------------------------
fm.directory.ftloop.recsize:        
        mov   @cat.var4,tmp0        ; Get pointer to record size
        movb  *tmp0,tmp0            ; Get record size
        srl   tmp0,8                ; MSB to LSB
        mov   tmp0,@cat.var5        ; Set record size

 ;       data  c99_dbg_tmp0          ; \ Print file type record size in tmp0 
 ;       data  >1001                 ; | in classic99 debugger console.
 ;       data  data.printf.recsize   ; | Needs debug opcodes enabled in 
 ;                                   ; / classic99.ini file. See c99 manual.

        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data cat.var5         ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        clr   @rambuf+6             ; Clear bytes 7-8 in ram buffer
        clr   @rambuf+8             ; Clear bytes 9-10 in ram buffer

        bl    @trimnum              ; Trim number string
              data rambuf           ; \ i  p1 = Source
              data rambuf + 6       ; | i  p2 = Destination
              data 32               ; / i  p3 = Padding character to scan

        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0     

        dec   tmp1                  ; Backoff to 3rd character (whitespace)
        movb  @rambuf+7,*tmp1+      ; Record size. Character 1
        movb  @rambuf+8,*tmp1+      ; Record size. Character 2
        movb  @rambuf+9,*tmp1+      ; Record size. Character 3
        ;-------------------------------------------------------
        ; Prepare for next file
        ;-------------------------------------------------------
fm.directory.ftloop.next:
        mov   tmp1,@cat.var2        ; Save pointer address for next string
        inc   @cat.var1             ; Next filetype byte
        inc   @cat.var4             ; Next recordsize byte
        dec   @cat.var3             ; Adjust file counter
        jgt   fm.directory.ftloop   ; Next file
*--------------------------------------------------------------
* Show filebrowser
*--------------------------------------------------------------        
fm.directory.browser:
        clr   @cat.shortcut.idx     ; 1st file/dir in list
        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename        

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


txt.ftype0    stri 'VOL'
txt.ftype1    stri 'DF '
txt.ftype2    stri 'DV '
txt.ftype3    stri 'IF '
txt.ftype4    stri 'IV '
txt.ftype5    stri 'PRG'
txt.ftype6    stri 'SUBDIR'
txt.filetypes equ  txt.ftype0

data.printf.recsize:
       text   'Catalog. File type record size: %u'
       byte   0

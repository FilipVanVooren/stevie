***************************************************************
* 
*                          TiVi Editor
*
*                (c)2018-2019 // Filip van Vooren
*
***************************************************************
* File: tivi.asm                    ; Version %%build_date%%
*--------------------------------------------------------------
* TI-99/4a Advanced Editor & IDE
*--------------------------------------------------------------
* 2018-11-01   Development started
********@*****@*********************@**************************
        save  >6000,>7fff
        aorg  >6000
*--------------------------------------------------------------
debug                  equ  1       ; Turn on debugging
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
skip_vdp_hchar          equ  1      ; Skip hchar, xhchar
skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
skip_vdp_boxes          equ  1      ; Skip filbox, putbox
skip_vdp_bitmap         equ  1      ; Skip bitmap functions
skip_vdp_viewport       equ  1      ; Skip viewport functions
skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
skip_sound_player       equ  1      ; Skip inclusion of sound player code
skip_tms52xx_detection  equ  1      ; Skip speech synthesizer detection
skip_tms52xx_player     equ  1      ; Skip inclusion of speech player code
skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
skip_random_generator   equ  1      ; Skip random functions 
skip_cpu_hexsupport     equ  1      ; Skip mkhex, puthex 
skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation

*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib

 .ifdef debug
        #string 'TIVI %%build_date%%'
 .else
        #string 'TIVI'
 .endif
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "%%spectra2%%/runlib.asm"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >f5                   ; Foreground/Background color for font.
spfbck  equ   >05                   ; Screen background color.
;spfclr  equ   >a1                   ; Foreground/Background color for font.
;spfbck  equ   >01                   ; Screen background color.

*--------------------------------------------------------------
* Scratchpad memory
*--------------------------------------------------------------
;           equ  >8342              ; >8342-834F **free***
parm1       equ  >8350              ; Function parameter 1
parm2       equ  >8352              ; Function parameter 2
parm3       equ  >8354              ; Function parameter 3
parm4       equ  >8356              ; Function parameter 4
parm5       equ  >8358              ; Function parameter 5
parm6       equ  >835a              ; Function parameter 6
parm7       equ  >835c              ; Function parameter 7
parm8       equ  >835e              ; Function parameter 8
outparm1    equ  >8360              ; Function output parameter 1
outparm2    equ  >8362              ; Function output parameter 2
outparm3    equ  >8364              ; Function output parameter 3
outparm4    equ  >8366              ; Function output parameter 4
outparm5    equ  >8368              ; Function output parameter 5
outparm6    equ  >836a              ; Function output parameter 6
outparm7    equ  >836c              ; Function output parameter 7
outparm8    equ  >836e              ; Function output parameter 8
timers      equ  >8370              ; Timer table
ramsat      equ  >8380              ; Sprite Attribute Table in RAM
rambuf      equ  >8390              ; RAM workbuffer 1


*--------------------------------------------------------------
* Frame buffer structure @ >2000
* Frame buffer itself    @ >3000 - >3fff
*--------------------------------------------------------------
fb.top.ptr      equ  >2000          ; Pointer to frame buffer
fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer 
fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
fb.top          equ  >3000          ; Frame buffer low memory 2400 bytes (80x30)
;                    >200c-20ff     ; ** FREE **


*--------------------------------------------------------------
* Editor buffer structure @ >2100
*--------------------------------------------------------------
edb.top.ptr     equ  >2100          ; Pointer to editor buffer
edb.index.ptr   equ  >2102          ; Pointer to index
edb.lines       equ  >2104          ; Total lines in editor buffer
edb.dirty       equ  >2108          ; Editor buffer dirty flag (Text changed!)
edb.next_free   equ  >210a          ; Pointer to next free line
edb.insmode     equ  >210c          ; Editor insert mode (>0000 overwrite / >ffff insert)
edb.top         equ  >a000          ; Editor buffer high memory 24576 bytes
;                    >2102-21ff     ; ** FREE **


*--------------------------------------------------------------
* Index @ >2200 - >2fff
*--------------------------------------------------------------
idx.top        equ  >2200           ; Top of index


*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprpdt  equ   >1800                 ; VDP sprite pattern table
sprsat  equ   >2000                 ; VDP sprite attribute table



***************************************************************
* Main
********@*****@*********************@**************************
main    coc   @wbit1,config         ; F18a detected?
        jeq   main.continue
        blwp  @0                    ; Exit for now if no F18a detected

main.continue:
        bl    @f18unl               ; Unlock the F18a
        bl    @putvr                ; Turn on 30 rows mode.
        data  >3140                 ; F18a VR49 (>31), bit 40

        ;------------------------------------------------------
        ; Initialize low + high memory expansion
        ;------------------------------------------------------
        bl    @film
              data >2000,00,8*1024  ; Clear 8k low-memory

        bl    @film
              data >a000,00,24*1024 ; Clear 24k high-memory
        ;------------------------------------------------------
        ; Setup cursor, screen, etc.
        ;------------------------------------------------------
        bl    @smag1x               ; Sprite magnification 1x
        bl    @s8x8                 ; Small sprite

        bl    @cpym2m
              data romsat,ramsat,4  ; Load sprite SAT

        mov   @romsat+2,@fb.curshape
                                    ; Save cursor shape & color

        bl    @cpym2v
              data sprpdt,cursors,3*8
                                    ; Load sprite cursor patterns

        bl    @putat
              byte 29,0
              data txt_title        ; Show TiVi banner

*--------------------------------------------------------------
* Initialize 
*--------------------------------------------------------------
        bl    @edb.init             ; Initialize editor buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer

        ;-------------------------------------------------------
        ; Setup editor tasks & hook
        ;-------------------------------------------------------
        li    tmp0,>0200
        mov   tmp0,@btihi           ; Highest slot in use
 
        bl    @at
        data  >0000                 ; Cursor YX position = >0000

        li    tmp0,timers
        mov   tmp0,@wtitab

        bl    @mkslot
              data >0001,task0      ; Task 0 - Update screen
              data >0101,task1      ; Task 1 - Update cursor position
              data >020f,task2,eol  ; Task 2 - Toggle cursor shape

        bl    @mkhook
              data editor           ; Setup user hook

        b     @tmgr                 ; Start timers and kthread


****************************************************************
* Editor - Main loop
****************************************************************
editor  coc   @wbit11,config        ; ANYKEY pressed ?
        jne   ed_clear_kbbuffer     ; No, clear buffer and exit
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @waux1,@waux2         ; Still pressing previous key?
        jeq   ed_wait
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
ed_new_key
        mov   @waux1,@waux2         ; Save as previous key
        jmp   ed_pk
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
ed_clear_kbbuffer
        clr   @waux1
        clr   @waux2
*--------------------------------------------------------------
* Delay to avoid key bouncing
*-------------------------------------------------------------- 
ed_wait
        li    tmp0,1800             ; Key delay to avoid bouncing keys
        ;------------------------------------------------------
        ; Delay loop
        ;------------------------------------------------------
ed_wait_loop
        dec   tmp0
        jne   ed_wait_loop
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
ed_exit b     @hookok               ; Return






***************************************************************
*              ed_pk - Editor Process Key module
***************************************************************
        copy  "ed_pk.asm"




***************************************************************
* Task 0 - Copy frame buffer to VDP
***************************************************************
task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
        jeq   task0.$$              ; No, skip update
        ;------------------------------------------------------ 
        ; Determine how many rows to copy 
        ;------------------------------------------------------
        c     @edb.lines,@fb.screenrows
        jlt   task0.setrows.small
        mov   @fb.screenrows,tmp1   ; Lines to copy
        jmp   task0.copy.framebuffer
        ;------------------------------------------------------
        ; Less lines in editor buffer as rows in frame buffer 
        ;------------------------------------------------------
task0.setrows.small:
        mov   @edb.lines,tmp1       ; Lines to copy
        inc   tmp1
        ;------------------------------------------------------
        ; Determine area to copy
        ;------------------------------------------------------
task0.copy.framebuffer:
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
        clr   tmp0                  ; VDP target address
        mov   @fb.top.ptr,tmp1      ; RAM Source address
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
        bl    @xpym2v               ; Copy to VDP
                                    ; tmp0 = VDP target address
                                    ; tmp1 = RAM source address
                                    ; tmp2 = Bytes to copy
        clr   @fb.dirty             ; Reset frame buffer dirty flag
        ;-------------------------------------------------------
        ; Draw EOF marker at end-of-file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
        inc   tmp0                  ; Y++
        c     @fb.screenrows,tmp0   ; Hide if last line on screen
        jle   task0.$$
        ;-------------------------------------------------------
        ; Draw EOF marker 
        ;-------------------------------------------------------
task0.draw_marker:
        mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
        sla   tmp0,8                ; X=0
        mov   tmp0,@wyx             ; Set VDP cursor
        bl    @putstr
              data txt_marker       ; Display *EOF*
        ;-------------------------------------------------------
        ; Draw empty line after (and below) EOF marker
        ;-------------------------------------------------------
        bl    @setx   
              data  5               ; Cursor after *EOF* string

        mov   @wyx,tmp0
        srl   tmp0,8                ; Right justify                
        inc   tmp0                  ; One time adjust
        c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
        jeq   !
        li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
        jmp   task0.draw_marker.line
!       li    tmp2,colrow-5         ; Repeat count for 1 line
        ;-------------------------------------------------------
        ; Draw empty line
        ;-------------------------------------------------------
task0.draw_marker.line:        
        dec   tmp0                  ; One time adjust
        bl    @yx2pnt               ; Set VDP address in tmp0
        li    tmp1,32               ; Character to write (whitespace)
        bl    @xfilv                ; Write characters
        mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
*--------------------------------------------------------------
* Task 0 - Exit
*--------------------------------------------------------------
task0.$$:
        b     @slotok



***************************************************************
* Task 1 - Copy SAT to VDP
***************************************************************
task1   soc   @wbit0,config          ; Sprite adjustment on
        bl    @yx2px                 ; Calculate pixel position, result in tmp0
        mov   tmp0,@ramsat           ; Set cursor YX
        jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task


***************************************************************
* Task 2 - Update cursor shape (blink)
***************************************************************
task2   inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   task2.cur_visible
        clr   @ramsat+2              ; Hide cursor
        jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task

task2.cur_visible:
        mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
        jeq   task2.cur_visible.overwrite_mode
        ;------------------------------------------------------
        ; Cursor in insert mode
        ;------------------------------------------------------
task2.cur_visible.insert_mode:
        li    tmp0,>000f
        jmp   task2.cur_visible.cursorshape
        ;------------------------------------------------------
        ; Cursor in overwrite mode
        ;------------------------------------------------------
task2.cur_visible.overwrite_mode:
        li    tmp0,>020f
        ;------------------------------------------------------
        ; Set cursor shape
        ;------------------------------------------------------
task2.cur_visible.cursorshape:
        mov   tmp0,@fb.curshape
        mov   tmp0,@ramsat+2







*--------------------------------------------------------------
* Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
*--------------------------------------------------------------
task.sub_copy_ramsat
        bl    @cpym2v
              data sprsat,ramsat,4   ; Update sprite

        mov   @wyx,@fb.yxsave
        ;------------------------------------------------------
        ; Show text editing mode
        ;------------------------------------------------------
task.botline.show_mode
        mov   @edb.insmode,tmp0
        jne   task.botline.show_mode.insert
        ;------------------------------------------------------
        ; Overwrite mode
        ;------------------------------------------------------
task.botline.show_mode.overwrite:
        bl    @putat
              byte  29,50
              data  txt_ovrwrite
        jmp   task.botline.show_linecol
        ;------------------------------------------------------
        ; Insert  mode
        ;------------------------------------------------------
task.botline.show_mode.insert
        bl    @putat
              byte  29,50
              data  txt_insert
        ;------------------------------------------------------
        ; Show "line,column"
        ;------------------------------------------------------
task.botline.show_linecol:
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        inc   @outparm1
        ;------------------------------------------------------
        ; Show line
        ;------------------------------------------------------
        bl    @putnum
              byte  29,64            ; YX
              data  outparm1,rambuf
              byte  48               ; ASCII offset 
              byte  32               ; Padding character
        ;------------------------------------------------------
        ; Show comma
        ;------------------------------------------------------
        bl    @putat
              byte  29,69
              data  txt_delim
        ;------------------------------------------------------
        ; Show column
        ;------------------------------------------------------
        bl    @film
              data rambuf+6,32,12    ; Clear work buffer with space character

        mov   @fb.column,@waux1
        inc   @waux1                 ; Offset 1

        bl    @mknum                 ; Convert unsigned number to string
              data  waux1,rambuf
              byte  48               ; ASCII offset
              byte  32               ; Fill character

        bl    @trimnum               ; Trim number to the left
              data  rambuf,rambuf+6,32

        li    tmp0,>0200
        movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars 
                                
        bl    @putat
              byte 29,70
              data rambuf+6          ; Show column
        ;------------------------------------------------------
        ; Show lines in buffer unless on last line in file
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line 
        c     @edb.lines,@outparm1
        jne   task.botline.show_lines_in_buffer

        bl    @putat
              byte 29,73
              data txt_bottom

        jmp   task.botline.$$
        ;------------------------------------------------------
        ; Show lines in buffer
        ;------------------------------------------------------
task.botline.show_lines_in_buffer:
        mov   @edb.lines,@waux1
        inc   @waux1                 ; Offset 1
        bl    @putnum
              byte 29,73             ; YX
              data waux1,rambuf
              byte 48
              byte 32
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.botline.$$
        mov   @fb.yxsave,@wyx
        b     @slotok                ; Exit running task

 

***************************************************************
*                  fb - Framebuffer module
***************************************************************
        copy  "fb.asm"


***************************************************************
*              idx - Index management module
***************************************************************
        copy  "idx.asm"


***************************************************************
*               edb - Editor Buffer module
***************************************************************
        copy  "edb.asm"


***************************************************************
*                      Constants
***************************************************************
romsat:
        data >0303,>000f              ; Cursor YX, shape and colour

cursors:
        data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
        data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
        data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode

***************************************************************
*                       Strings
***************************************************************
txt_title    #string 'TIVI %%build_date%%'
txt_delim    #string ','
txt_marker   #string '*EOF*'
txt_bottom   #string '  BOT'
txt_ovrwrite #string '   '
txt_insert   #string 'INS'
end          data    $ 

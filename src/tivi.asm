***************************************************************
* 
*                          TiVi Editor
*
*                (c)2018-2020 // Filip van Vooren
*
***************************************************************
* File: tivi.asm                    ; Version %%build_date%%
*--------------------------------------------------------------
* A 21th century Programming Editor for the 20th century 
* Texas Instruments TI-99/4a Home Computer.
*--------------------------------------------------------------
* TiVi memory layout.
* See file "modules/memory.asm" for further details.
*
* Mem range   Bytes    Hex    Purpose
* =========   =====    ===    ==================================
* 8300-83ff     256   >0100   scrpad spectra2 layout
* 2000-20ff     256   >0100   scrpad backup 1: GPL layout
* 2100-21ff     256   >0100   scrpad backup 2: paged out spectra2
* 2200-227f     128   >0080   TiVi editor structure
* 2280-22ff     128   >0080   TiVi frame buffer structure
* 2300-23ff     256   >0100   TiVi editor buffer structure
* 2400-24ff     256   >0100   TiVi file handling structure
* 2500-25ff     256   >0100   Free for future use
* 2600-264f      80   >0050   Free for future use
* 2650-2faf    2400   >0960   Frame buffer 80x30
* 2fb0-2fff     160   >00a0   Free for future use
* 3000-3fff    4096   >1000   Index 2048 lines
* a000-afff    4096   >1000   Shadow Index 2048 lines
* b000-ffff   20480   >5000   Editor buffer
*--------------------------------------------------------------
* Mem range  Bytes     SAMS   Purpose
* =========  =====     ====   =======
* 2000-2fff   4096     no     Scratchpad/GPL backup, TiVi structures
* 3000-3fff   4096     yes    Main index
* a000-afff   4096     yes    Shadow index
* b000-bfff   4096     yes    Editor buffer \
* c000-cfff   4096     yes    Editor buffer |  20kb continious 
* d000-dfff   4096     yes    Editor buffer |  address space.
* e000-efff   4096     yes    Editor buffer | 
* f000-ffff   4096     yes    Editor buffer /
*--------------------------------------------------------------
* TiVi VDP layout
*
* Mem range   Bytes    Hex    Purpose
* =========   =====   ====    =================================
* 0000-095f    2400   >0960   PNT - Pattern Name Table
* 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
* 0fc0                        PCT - Pattern Color Table         
* 1000                        PDT - Pattern Descriptor Table
* 1800                        SPT - Sprite Pattern Table
* 2000                        SAT - Sprite Attribute List 
*--------------------------------------------------------------
* EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
*--------------------------------------------------------------
debug                     equ  1    ; Turn on spectra2 debugging
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
skip_vdp_boxes            equ  1    ; Skip filbox, putbox
skip_vdp_bitmap           equ  1    ; Skip bitmap functions
skip_vdp_viewport         equ  1    ; Skip viewport functions
skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
skip_sound_player         equ  1    ; Skip inclusion of sound player code
skip_speech_detection     equ  1    ; Skip speech synthesizer detection
skip_speech_player        equ  1    ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
skip_random_generator     equ  1    ; Skip random functions 
skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
spfclr                    equ  >f4  ; Foreground/Background color for font.
spfbck                    equ  >04  ; Screen background color.
*--------------------------------------------------------------
* Scratchpad memory                 @>8300-83ff     (256 bytes)
*--------------------------------------------------------------
;               equ  >8342          ; >8342-834F **free***
parm1           equ  >8350          ; Function parameter 1
parm2           equ  >8352          ; Function parameter 2
parm3           equ  >8354          ; Function parameter 3
parm4           equ  >8356          ; Function parameter 4
parm5           equ  >8358          ; Function parameter 5
parm6           equ  >835a          ; Function parameter 6
parm7           equ  >835c          ; Function parameter 7
parm8           equ  >835e          ; Function parameter 8
outparm1        equ  >8360          ; Function output parameter 1
outparm2        equ  >8362          ; Function output parameter 2
outparm3        equ  >8364          ; Function output parameter 3
outparm4        equ  >8366          ; Function output parameter 4
outparm5        equ  >8368          ; Function output parameter 5
outparm6        equ  >836a          ; Function output parameter 6
outparm7        equ  >836c          ; Function output parameter 7
outparm8        equ  >836e          ; Function output parameter 8
timers          equ  >8370          ; Timer table
ramsat          equ  >8380          ; Sprite Attribute Table in RAM
rambuf          equ  >8390          ; RAM workbuffer 1
*--------------------------------------------------------------
* Scratchpad backup 1               @>2000-20ff     (256 bytes)
* Scratchpad backup 2               @>2100-21ff     (256 bytes)
*--------------------------------------------------------------
scrpad.backup1  equ  >2000          ; Backup GPL layout
scrpad.backup2  equ  >2100          ; Backup spectra2 layout
*--------------------------------------------------------------
* TiVi Editor shared structures     @>2200-227f     (128 bytes)
*--------------------------------------------------------------
tv.top          equ  >2200          ; Structure begin
tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9) 
tv.end          equ  tv.top + 18    ; End of structure
*--------------------------------------------------------------
* Frame buffer structure            @>2280-22ff     (128 bytes)
*--------------------------------------------------------------
fb.struct       equ  >2280          ; Structure begin
fb.top.ptr      equ  >2280          ; Pointer to frame buffer
fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching 
                                    ; line X in editor buffer).
fb.row          equ  fb.struct + 6  ; Current row in frame buffer
                                    ; (offset 0 .. @fb.scrrows)
fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer 
fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
fb.column       equ  fb.struct + 12 ; Current column in frame buffer
fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
fb.curshape     equ  fb.struct + 16 ; Cursor shape & colour
fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
fb.end          equ  fb.struct + 28 ; End of structure
*--------------------------------------------------------------
* Editor buffer structure           @>2300-23ff     (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >2300           ; Begin structure
edb.top.ptr       equ  >2300           ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
edb.rle           equ  edb.struct + 12 ; RLE compression activated
edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string 
                                       ; with current filename.
edb.sams.page     equ  edb.struct + 16 ; Current SAMS page
edb.end           equ  edb.struct + 18 ; End of structure
*--------------------------------------------------------------
* File handling structures          @>2400-24ff     (256 bytes)
*--------------------------------------------------------------
tfh.top         equ  >2400          ; TiVi file handling structures
dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes      
dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB,required by level 2 FIO
tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
tfh.records     equ  tfh.top + 46   ; File records counter
tfh.reclen      equ  tfh.top + 48   ; Current record length
tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
tfh.counter     equ  tfh.top + 52   ; Counter used in TiVi file operations
tfh.fname.ptr   equ  tfh.top + 54   ; Pointer to device and filename
tfh.sams.page   equ  tfh.top + 56   ; Current SAMS page during file operation
tfh.sams.hpage  equ  tfh.top + 58   ; Highest SAMS page used for file operation
tfh.callback1   equ  tfh.top + 60   ; Pointer to callback function 1
tfh.callback2   equ  tfh.top + 62   ; Pointer to callback function 2
tfh.callback3   equ  tfh.top + 64   ; Pointer to callback function 3
tfh.callback4   equ  tfh.top + 66   ; Pointer to callback function 4 
tfh.rleonload   equ  tfh.top + 68   ; RLE compression needed during file load
tfh.membuffer   equ  tfh.top + 70   ; 80 bytes file memory buffer 
tfh.end         equ  tfh.top + 150  ; End of structure

tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory
tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
*--------------------------------------------------------------
* Command buffer structure          @>2500-25ff     (256 bytes)
*--------------------------------------------------------------
cmdb.top        equ  >2500          ; TiVi command buffer structures
cmdb.visible    equ  cmdb.top + 2   ; Command buffer visible? (>ffff = visible)
cmdb.scrrows    equ  cmdb.top + 4   ; Current size of cmdb pane (in rows)
cmdb.default    equ  cmdb.top + 6   ; Default size of cmdb pane (in rows)
cmdb.end        equ  cmdb.top + 8   ; End of structure
*--------------------------------------------------------------
* Free for future use               @>2500-264f     (80 bytes)
*--------------------------------------------------------------
free.mem2       equ  >2600          ; >2600-264f    80 bytes
*--------------------------------------------------------------
* Frame buffer                      @>2650-2fff    (2480 bytes)
*--------------------------------------------------------------
fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
fb.size         equ  2480           ; Frame buffer size
*--------------------------------------------------------------
* Index                             @>3000-3fff    (4096 bytes)
*--------------------------------------------------------------
idx.top         equ  >3000          ; Top of index
idx.size        equ  4096           ; Index size
*--------------------------------------------------------------
* SAMS shadow index                 @>a000-afff    (4096 bytes)
*--------------------------------------------------------------
idx.shadow.top  equ  >a000          ; Top of shadow index
idx.shadow.size equ  4096           ; Shadow index size
*--------------------------------------------------------------
* Editor buffer                     @>b000-bfff    (4096 bytes)
*                                   @>c000-cfff    (4096 bytes)
*                                   @>d000-dfff    (4096 bytes)
*                                   @>e000-efff    (4096 bytes)
*                                   @>f000-ffff    (4096 bytes)
*--------------------------------------------------------------
edb.top         equ  >b000          ; Editor buffer high memory
edb.size        equ  20380          ; Editor buffer size
*--------------------------------------------------------------


*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
        save  >6000,>7fff
        aorg  >6000

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
*                     TiVi support modules
***************************************************************
        copy  "editor.asm"          ; Main editor
        copy  "edkey.asm"           ; Actions
        copy  "edkey.mov.asm"       ; Actions for movement keys
        copy  "edkey.mod.asm"       ; Actions for modifier keys
        copy  "edkey.misc.asm"      ; Actions for miscelanneous keys
        copy  "edkey.file.asm"      ; Actions for file related keys
        copy  "mem.asm"             ; mem      - Memory Management
        copy  "fb.asm"              ; fb       - Framebuffer
        copy  "idx.asm"             ; idx      - Index management
        copy  "edb.asm"             ; edb      - Editor Buffer
        copy  "cmdb.asm"            ; cmdb     - Command Buffer
        copy  "tfh.read.sams.asm"   ; tfh.sams - File handler read file (SAMS)                                
        copy  "fm.load.asm"         ; fm.load  - File manager loadfile
        copy  "tasks.asm"           ; tsk      - Tasks


***************************************************************
*                      Constants
***************************************************************
romsat:
        data >0303,>0008              ; Cursor YX, initial shape and colour

cursors:
        data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
        data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
        data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode

lines:
        data >0080,>0000,>ff00,>ff00  ; Ruler and double line        
        data >0000,>0000,>ff00,>ff00  ; Double line                

***************************************************************
*                       Strings
***************************************************************
txt_delim    #string ','
txt_marker   #string '*EOF*'
txt_bottom   #string '  BOT'
txt_ovrwrite #string 'OVR'
txt_insert   #string 'INS'
txt_star     #string '*'
txt_loading  #string 'Loading...'
txt_kb       #string 'kb'
txt_rle      #string 'RLE'
txt_lines    #string 'Lines'
txt_ioerr    #string '* I/O error occured. Could not load file.'
txt_bufnum   #string '#1'
txt_newfile  #string '[New file]'
txt_tivi     #string 'TiVi beta %%build_date%%'
end          data    $ 


fdname0      #string 'DSK1.INVADERS'
fdname1      #string 'DSK1.SPEECHDOCS'
fdname2      #string 'DSK1.XBEADOC'
fdname3      #string 'DSK3.XBEADOC'
fdname4      #string 'DSK3.C99MAN1'
fdname5      #string 'DSK3.C99MAN2'
fdname6      #string 'DSK3.C99MAN3'
fdname7      #string 'DSK3.C99SPECS'
fdname8      #string 'DSK3.RANDOM#C'
fdname9      #string 'DSK1.INVADERS'


***************************************************************
*                  Sanity check on ROM size
***************************************************************
 .ifgt $, >7fff
        .error 'Aborted. Cartridge program too large!'
 .else
         data $   ; ROM size OK.
 .endif
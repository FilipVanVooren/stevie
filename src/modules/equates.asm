***************************************************************
*                          TiVi Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: equates.asm                 ; Version %%build_date%%
*--------------------------------------------------------------
* TiVi memory layout
* See file "modules/mem.asm" for further details.
*
*
* LOW MEMORY EXPANSION (2000-3fff)
* 
* Mem range   Bytes    BANK   Purpose
* =========   =====    ====   ==================================
* 2000-2fff    4096           SP2 ROM code 
* 3000-3bff    3072           SP2 ROM code
* 3c00-3cff     256           Shared variables - *FREE*          
* 3d00-3dff     256           Shared variables - *FREE*
* 3e00-3eff     256           SP2/GPL scratchpad backup 1
* 3f00-3fff     256           SP2/GPL scratchpad backup 2
*
*
* CARTRIDGE SPACE (6000-7fff)
*
* Mem range   Bytes    BANK   Purpose
* =========   =====    ====   ==================================
* 6000-7fff    8192       0   SP2 ROM CODE + copy to RAM code
* 6000-7fff    8192       1   TiVi program code
*
*
* HIGH MEMORY EXPANSION (a000-ffff)
*
* Mem range   Bytes    BANK   Purpose
* =========   =====    ====   ==================================
* a000-a0ff     256           TiVI Editor shared structure
* a100-a1ff     256           Framebuffer structure
* a200-a2ff     256           Editor buffer structure
* a300-a3ff     256           Command buffer structure   
* a400-a4ff     256           File handle structure
* a500-afff    2792           *FREE*
*
* b000-bfff    4096           Command buffer
* c000-cfff    4096           Index
* d000-dfff    4096           Editor buffer page
* e000-efff    4096           *FREE*
* f000-ffff    4096           Shadow index
*
*
* VDP RAM
*
* Mem range   Bytes    Hex    Purpose
* =========   =====   =====   =================================
* 0000-095f    2400   >0960   PNT - Pattern Name Table
* 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
* 0fc0                        PCT - Pattern Color Table
* 1000                        PDT - Pattern Descriptor Table
* 1800                        SPT - Sprite Pattern Table
* 2000                        SAT - Sprite Attribute List
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
skip_vdp_boxes            equ  1       ; Skip filbox, putbox
skip_vdp_bitmap           equ  1       ; Skip bitmap functions
skip_vdp_viewport         equ  1       ; Skip viewport functions
skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
skip_sound_player         equ  1       ; Skip inclusion of sound player code
skip_speech_detection     equ  1       ; Skip speech synthesizer detection
skip_speech_player        equ  1       ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
skip_random_generator     equ  1       ; Skip random functions
skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
*--------------------------------------------------------------
* SPECTRA2 / TiVi startup options
*--------------------------------------------------------------
debug                     equ  1       ; Turn on spectra2 debugging
startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to 
                                       ; memory address @cpu.scrpad.tgt
startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
kickstart.code2           equ  >6050   ; Uniform aorg entry addr start of code
*--------------------------------------------------------------
* Scratchpad memory                 @>8300-83ff     (256 bytes)
*--------------------------------------------------------------
;                 equ  >8342           ; >8342-834F **free***
parm1             equ  >8350           ; Function parameter 1
parm2             equ  >8352           ; Function parameter 2
parm3             equ  >8354           ; Function parameter 3
parm4             equ  >8356           ; Function parameter 4
parm5             equ  >8358           ; Function parameter 5
parm6             equ  >835a           ; Function parameter 6
parm7             equ  >835c           ; Function parameter 7
parm8             equ  >835e           ; Function parameter 8
outparm1          equ  >8360           ; Function output parameter 1
outparm2          equ  >8362           ; Function output parameter 2
outparm3          equ  >8364           ; Function output parameter 3
outparm4          equ  >8366           ; Function output parameter 4
outparm5          equ  >8368           ; Function output parameter 5
outparm6          equ  >836a           ; Function output parameter 6
outparm7          equ  >836c           ; Function output parameter 7
outparm8          equ  >836e           ; Function output parameter 8
timers            equ  >8370           ; Timer table
ramsat            equ  >8380           ; Sprite Attribute Table in RAM
rambuf            equ  >8390           ; RAM workbuffer 1
*--------------------------------------------------------------
* Scratchpad backup 1               @>3e00-3eff     (256 bytes)
* Scratchpad backup 2               @>3f00-3fff     (256 bytes)
*--------------------------------------------------------------
cpu.scrpad.tgt    equ  >3e00           ; Destination cpu.scrpad.backup/restore
scrpad.backup1    equ  >3e00           ; Backup GPL layout
scrpad.backup2    equ  >3f00           ; Backup spectra2 layout
*--------------------------------------------------------------
* TiVi Editor shared structures     @>a000-a0ff     (256 bytes)
*--------------------------------------------------------------
tv.top            equ  >a000           ; Structure begin
tv.sams.2000      equ  tv.top + 0      ; SAMS shadow register memory >2000-2fff
tv.sams.3000      equ  tv.top + 2      ; SAMS shadow register memory >3000-3fff
tv.sams.a000      equ  tv.top + 4      ; SAMS shadow register memory >a000-afff
tv.sams.b000      equ  tv.top + 6      ; SAMS shadow register memory >b000-bfff
tv.sams.c000      equ  tv.top + 8      ; SAMS shadow register memory >c000-cfff
tv.sams.d000      equ  tv.top + 10     ; SAMS shadow register memory >d000-dfff
tv.sams.e000      equ  tv.top + 12     ; SAMS shadow register memory >e000-efff
tv.sams.f000      equ  tv.top + 14     ; SAMS shadow register memory >f000-ffff
tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-4)
tv.curshape       equ  tv.top + 20     ; Cursor shape and color
tv.pane.focus     equ  tv.top + 22     ; Identify pane that has focus
tv.end            equ  tv.top + 22     ; End of structure
pane.focus.fb     equ  0               ; Editor pane has focus
pane.focus.cmdb   equ  1               ; Command buffer pane has focus
*--------------------------------------------------------------
* Frame buffer structure            @>a100-a1ff     (256 bytes)
*--------------------------------------------------------------
fb.struct         equ  >a100           ; Structure begin
fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
                                       ; line X in editor buffer).
fb.row            equ  fb.struct + 6   ; Current row in frame buffer
                                       ; (offset 0 .. @fb.scrrows)
fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
fb.column         equ  fb.struct + 12  ; Current column in frame buffer
fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
fb.free           equ  fb.struct + 16  ; **** free ****
fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
fb.end            equ  fb.struct + 28  ; End of structure
*--------------------------------------------------------------
* Editor buffer structure           @>a200-a2ff     (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >a200           ; Begin structure
edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
edb.rle           equ  edb.struct + 12 ; RLE compression activated
edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
                                       ; with current filename.
edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
                                       ; with current file type.                                    
edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
edb.end           equ  edb.struct + 20 ; End of structure
*--------------------------------------------------------------
* Command buffer structure          @>a300-a3ff     (256 bytes)
*--------------------------------------------------------------
cmdb.struct       equ  >a300           ; Command Buffer structure
cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer
cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
cmdb.scrrows      equ  cmdb.struct + 4 ; Current size of cmdb pane (in rows)
cmdb.default      equ  cmdb.struct + 6 ; Default size of cmdb pane (in rows)
cmdb.cursor       equ  cmdb.struct + 8 ; Screen YX of cursor in cmdb pane
cmdb.yxsave       equ  cmdb.struct + 10; Copy of WYX
cmdb.yxtop        equ  cmdb.struct + 12; YX position of first row in cmdb pane
cmdb.lines        equ  cmdb.struct + 14; Total lines in editor buffer
cmdb.dirty        equ  cmdb.struct + 16; Editor buffer dirty (Text changed!)
cmdb.fb.yxsave    equ  cmdb.struct + 18; Copy of FB WYX when entering cmdb pane
cmdb.end          equ  cmdb.struct + 20; End of structure
*--------------------------------------------------------------
* File handle structure             @>a400-a4ff     (256 bytes)
*--------------------------------------------------------------
fh.struct         equ  >a400           ; TiVi file handling structures
dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
fh.records        equ  fh.struct + 46  ; File records counter
fh.reclen         equ  fh.struct + 48  ; Current record length
fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
fh.end            equ  fh.struct +150  ; End of structure
fh.vrecbuf        equ  >0960           ; VDP address record buffer
fh.vpab           equ  >0a60           ; VDP address PAB
*--------------------------------------------------------------
* Frame buffer                      @>a600-afff    (2560 bytes)
*--------------------------------------------------------------
fb.top            equ  >a600           ; Frame buffer (80x30)
fb.size           equ  80*30           ; Frame buffer size                                     
*--------------------------------------------------------------
* Command buffer                    @>b000-bfff    (4096 bytes)
*--------------------------------------------------------------
cmdb.top          equ  >b000           ; Top of command buffer
cmdb.size         equ  4096            ; Command buffer size
*--------------------------------------------------------------
* Index                             @>c000-cfff    (4096 bytes)
*--------------------------------------------------------------
idx.top           equ  >c000           ; Top of index
idx.size          equ  4096            ; Index size
*--------------------------------------------------------------
* Editor buffer                     @>d000-dfff    (4096 bytes)
*--------------------------------------------------------------
edb.top           equ  >d000           ; Editor buffer high memory
edb.size          equ  4096            ; Editor buffer size
*--------------------------------------------------------------
* SAMS shadow pages index           @>f000-ffff    (4096 bytes)
*--------------------------------------------------------------
idx.shadow.top    equ  >f000           ; Top of shadow index
idx.shadow.size   equ  4096            ; Shadow index size
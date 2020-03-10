***************************************************************
*                          TiVi Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: tivi.asm                    ; Version %%build_date%%
*--------------------------------------------------------------
* TiVi memory layout.
* See file "modules/memory.asm" for further details.
*
* Mem range   Bytes    Hex    Purpose
* =========   =====    ===    ==================================
* 2000-3fff   8192     no     TiVi program code
* 6000-7fff   8192     no     Spectra2 library program code (cartridge space)
* a000-afff   4096     no     Scratchpad/GPL backup, TiVi structures
* b000-bfff   4096     no     Command buffer
* c000-cfff   4096     yes    Main index
* d000-dfff   4096     yes    Shadow SAMS pages index
* e000-efff   4096     yes    Editor buffer 4k
* f000-ffff   4096     yes    Editor buffer 4k
*
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
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
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
* SPECTRA2 / TiVi startup options
*--------------------------------------------------------------
debug                     equ  1    ; Turn on spectra2 debugging
startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
kickstart.code1           equ  >6030; Uniform aorg entry address accross banks
kickstart.code2           equ  >6050; Uniform aorg entry address start of code
cpu.scrpad.tgt            equ  >a000; Destination cpu.scrpad.backup/restore

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
* Scratchpad backup 1               @>a000-a0ff     (256 bytes)
* Scratchpad backup 2               @>a100-a1ff     (256 bytes)
*--------------------------------------------------------------
scrpad.backup1  equ  >a000          ; Backup GPL layout
scrpad.backup2  equ  >a100          ; Backup spectra2 layout
*--------------------------------------------------------------
* TiVi Editor shared structures     @>a200-a27f     (128 bytes)
*--------------------------------------------------------------
tv.top          equ  >a200          ; Structure begin
tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
tv.colorscheme  equ  tv.top + 18    ; Current color scheme (0-4)
tv.end          equ  tv.top + 20    ; End of structure
*--------------------------------------------------------------
* Frame buffer structure            @>a280-a2ff     (128 bytes)
*--------------------------------------------------------------
fb.struct       equ  >a280          ; Structure begin
fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
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
* Editor buffer structure           @>a300-a3ff     (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >a300           ; Begin structure
edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
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
* File handling structures          @>a400-a4ff     (256 bytes)
*--------------------------------------------------------------
tfh.struct      equ  >a400           ; TiVi file handling structures
dsrlnk.dsrlws   equ  tfh.struct      ; Address of dsrlnk workspace 32 bytes
dsrlnk.namsto   equ  tfh.struct + 32 ; 8-byte RAM buffer for storing device name
file.pab.ptr    equ  tfh.struct + 40 ; Pointer to VDP PAB, needed by level 2 FIO
tfh.pabstat     equ  tfh.struct + 42 ; Copy of VDP PAB status byte
tfh.ioresult    equ  tfh.struct + 44 ; DSRLNK IO-status after file operation
tfh.records     equ  tfh.struct + 46 ; File records counter
tfh.reclen      equ  tfh.struct + 48 ; Current record length
tfh.kilobytes   equ  tfh.struct + 50 ; Kilobytes processed (read/written)
tfh.counter     equ  tfh.struct + 52 ; Counter used in TiVi file operations
tfh.fname.ptr   equ  tfh.struct + 54 ; Pointer to device and filename
tfh.sams.page   equ  tfh.struct + 56 ; Current SAMS page during file operation
tfh.sams.hpage  equ  tfh.struct + 58 ; Highest SAMS page used for file operation
tfh.callback1   equ  tfh.struct + 60 ; Pointer to callback function 1
tfh.callback2   equ  tfh.struct + 62 ; Pointer to callback function 2
tfh.callback3   equ  tfh.struct + 64 ; Pointer to callback function 3
tfh.callback4   equ  tfh.struct + 66 ; Pointer to callback function 4
tfh.rleonload   equ  tfh.struct + 68 ; RLE compression needed during file load
tfh.membuffer   equ  tfh.struct + 70 ; 80 bytes file memory buffer
tfh.end         equ  tfh.struct +150 ; End of structure
tfh.vrecbuf     equ  >0960           ; VDP address record buffer
tfh.vpab        equ  >0a60           ; VDP address PAB
*--------------------------------------------------------------
* Command buffer structure          @>a500-a5ff     (256 bytes)
*--------------------------------------------------------------
cmdb.struct     equ  >a500            ; Command Buffer structure
cmdb.top.ptr    equ  cmdb.struct      ; Pointer to command buffer
cmdb.visible    equ  cmdb.struct + 2  ; Command buffer visible? (>ffff=visible)
cmdb.scrrows    equ  cmdb.struct + 4  ; Current size of cmdb pane (in rows)
cmdb.default    equ  cmdb.struct + 6  ; Default size of cmdb pane (in rows)
cmdb.top_yx     equ  cmdb.struct + 8  ; Screen YX of 1st row in cmdb pane
cmdb.yxsave     equ  cmdb.struct + 10 ; Copy of WYX
cmdb.lines      equ  cmdb.struct + 12 ; Total lines in editor buffer
cmdb.dirty      equ  cmdb.struct + 14 ; Editor buffer dirty (Text changed!)
cmdb.end        equ  cmdb.struct + 16 ; End of structure
*--------------------------------------------------------------
* Free for future use               @>a600-a64f     (80 bytes)
*--------------------------------------------------------------
free.mem2       equ  >a600          ; >b600-b64f    80 bytes
*--------------------------------------------------------------
* Frame buffer                      @>a650-afff    (2480 bytes)
*--------------------------------------------------------------
fb.top          equ  >a650          ; Frame buffer low memory 2400 bytes (80x30)
fb.size         equ  2480           ; Frame buffer size
*--------------------------------------------------------------
* Command buffer                    @>b000-bfff    (4096 bytes)
*--------------------------------------------------------------
cmdb.top        equ  >b000          ; Top of command buffer
cmdb.size       equ  4096           ; Command buffer size
*--------------------------------------------------------------
* Index                             @>c000-cfff    (4096 bytes)
*--------------------------------------------------------------
idx.top         equ  >c000          ; Top of index
idx.size        equ  4096           ; Index size
*--------------------------------------------------------------
* SAMS shadow pages index           @>d000-dfff    (4096 bytes)
*--------------------------------------------------------------
idx.shadow.top  equ  >d000          ; Top of shadow index
idx.shadow.size equ  4096           ; Shadow index size
*--------------------------------------------------------------
* Editor buffer                     @>e000-efff    (4096 bytes)
*                                   @>f000-ffff    (4096 bytes)
*--------------------------------------------------------------
edb.top         equ  >e000          ; Editor buffer high memory
edb.size        equ  8192           ; Editor buffer size
*--------------------------------------------------------------

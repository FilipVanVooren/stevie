XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.360191
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200713-360191
0010               
0011               
0012               ***************************************************************
0013               * BANK 1 - Stevie support modules
0014               ********|*****|*********************|**************************
0015                       aorg  >6000
0016                       save  >6000,>7fff           ; Save bank 1
0017                       copy  "equates.asm"         ; Equates stevie configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.asm                 ; Version 200713-360191
0010               *--------------------------------------------------------------
0011               * stevie memory layout
0012               * See file "modules/mem.asm" for further details.
0013               *
0014               *
0015               * LOW MEMORY EXPANSION (2000-3fff)
0016               *
0017               * Mem range   Bytes    BANK   Purpose
0018               * =========   =====    ====   ==================================
0019               * 2000-2fff    4096           SP2 ROM code
0020               * 3000-3bff    3072           SP2 ROM code
0021               * 3c00-3cff     256           Shared variables - *FREE*
0022               * 3d00-3dff     256           Shared variables - *FREE*
0023               * 3e00-3eff     256           SP2/GPL scratchpad backup 1
0024               * 3f00-3fff     256           SP2/GPL scratchpad backup 2
0025               *
0026               *
0027               * CARTRIDGE SPACE (6000-7fff)
0028               *
0029               * Mem range   Bytes    BANK   Purpose
0030               * =========   =====    ====   ==================================
0031               * 6000-7fff    8192       0   SP2 ROM CODE + copy to RAM code
0032               * 6000-7fff    8192       1   stevie program code
0033               *
0034               *
0035               * HIGH MEMORY EXPANSION (a000-ffff)
0036               *
0037               * Mem range   Bytes    BANK   Purpose
0038               * =========   =====    ====   ==================================
0039               * a000-a0ff     256           Stevie Editor shared structure
0040               * a100-a1ff     256           Framebuffer structure
0041               * a200-a2ff     256           Editor buffer structure
0042               * a300-a3ff     256           Command buffer structure
0043               * a400-a4ff     256           File handle structure
0044               * a500-a5ff     256           Index structure
0045               * a600-af5f    2400           Frame buffer
0046               * af60-afff     ???           *FREE*
0047               *
0048               * b000-bfff    4096           Index buffer page
0049               * c000-cfff    4096           Editor buffer page
0050               * d000-dfff    4096           Command buffer
0051               * e000-efff    4096           *FREE*
0052               * f000-ffff    4096           *????*
0053               *
0054               *
0055               * VDP RAM
0056               *
0057               * Mem range   Bytes    Hex    Purpose
0058               * =========   =====   =====   =================================
0059               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0060               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0061               * 0fc0                        PCT - Pattern Color Table
0062               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0063               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0064               * 2180                        SAT - Sprite Attribute List
0065               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0066               *--------------------------------------------------------------
0067               * Skip unused spectra2 code modules for reduced code size
0068               *--------------------------------------------------------------
0069      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0070      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0071      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0072      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0073      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0074      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0075      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0076      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0077      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0078      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0079      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0080      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0081      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0082      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0083      0001     skip_random_generator     equ  1       ; Skip random functions
0084      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0085               *--------------------------------------------------------------
0086               * Stevie specific equates
0087               *--------------------------------------------------------------
0088      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0089      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0090               *--------------------------------------------------------------
0091               * SPECTRA2 / Stevie startup options
0092               *--------------------------------------------------------------
0093      0001     debug                     equ  1       ; Turn on spectra2 debugging
0094      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0095                                                      ; memory address @cpu.scrpad.tgt
0096      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0097      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0098      6050     kickstart.code2           equ  >6050   ; Uniform aorg entry addr start of code
0099               *--------------------------------------------------------------
0100               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0101               *--------------------------------------------------------------
0102               ;                 equ  >8342           ; >8342-834F **free***
0103      8350     parm1             equ  >8350           ; Function parameter 1
0104      8352     parm2             equ  >8352           ; Function parameter 2
0105      8354     parm3             equ  >8354           ; Function parameter 3
0106      8356     parm4             equ  >8356           ; Function parameter 4
0107      8358     parm5             equ  >8358           ; Function parameter 5
0108      835A     parm6             equ  >835a           ; Function parameter 6
0109      835C     parm7             equ  >835c           ; Function parameter 7
0110      835E     parm8             equ  >835e           ; Function parameter 8
0111      8360     outparm1          equ  >8360           ; Function output parameter 1
0112      8362     outparm2          equ  >8362           ; Function output parameter 2
0113      8364     outparm3          equ  >8364           ; Function output parameter 3
0114      8366     outparm4          equ  >8366           ; Function output parameter 4
0115      8368     outparm5          equ  >8368           ; Function output parameter 5
0116      836A     outparm6          equ  >836a           ; Function output parameter 6
0117      836C     outparm7          equ  >836c           ; Function output parameter 7
0118      836E     outparm8          equ  >836e           ; Function output parameter 8
0119      8370     timers            equ  >8370           ; Timer table
0120      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0121      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0122               *--------------------------------------------------------------
0123               * Scratchpad backup 1               @>3e00-3eff     (256 bytes)
0124               * Scratchpad backup 2               @>3f00-3fff     (256 bytes)
0125               *--------------------------------------------------------------
0126      3E00     cpu.scrpad.tgt    equ  >3e00           ; Destination cpu.scrpad.backup/restore
0127      3E00     scrpad.backup1    equ  >3e00           ; Backup GPL layout
0128      3F00     scrpad.backup2    equ  >3f00           ; Backup spectra2 layout
0129               *--------------------------------------------------------------
0130               * Stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0131               *--------------------------------------------------------------
0132      A000     tv.top            equ  >a000           ; Structure begin
0133      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0134      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0135      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0136      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0137      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0138      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0139      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0140      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0141      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0142      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0143      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0144      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0145      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0146      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0147      A01C     tv.error.visible  equ  tv.top + 28     ; Error pane visible
0148      A01E     tv.error.msg      equ  tv.top + 30     ; Error message (max. 160 characters)
0149      A0BE     tv.end            equ  tv.top + 190    ; End of structure
0150               *--------------------------------------------------------------
0151               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0152               *--------------------------------------------------------------
0153      A100     fb.struct         equ  >a100           ; Structure begin
0154      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0155      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0156      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0157                                                      ; line X in editor buffer).
0158      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0159                                                      ; (offset 0 .. @fb.scrrows)
0160      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0161      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0162      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0163      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0164      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0165      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0166      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0167      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0168      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0169      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0170      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0171               *--------------------------------------------------------------
0172               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0173               *--------------------------------------------------------------
0174      A200     edb.struct        equ  >a200           ; Begin structure
0175      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0176      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0177      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0178      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0179      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0180      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0181      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0182      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0183                                                      ; with current filename.
0184      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0185                                                      ; with current file type.
0186      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0187      A214     edb.end           equ  edb.struct + 20 ; End of structure
0188               *--------------------------------------------------------------
0189               * Command buffer structure          @>a300-a3ff     (256 bytes)
0190               *--------------------------------------------------------------
0191      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0192      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0193      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0194      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0195      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0196      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0197      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0198      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0199      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0200      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0201      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0202      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0203      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0204      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0205      A31A     cmdb.pantitle     equ  cmdb.struct + 26; Pointer to string with pane title
0206      A31C     cmdb.panhint      equ  cmdb.struct + 28; Pointer to string with pane hint
0207      A31E     cmdb.cmdlen       equ  cmdb.struct + 30; Length of current command (MSB byte!)
0208      A31F     cmdb.cmd          equ  cmdb.struct + 31; Current command (80 bytes max.)
0209      A36F     cmdb.end          equ  cmdb.struct +111; End of structure
0210               *--------------------------------------------------------------
0211               * File handle structure             @>a400-a4ff     (256 bytes)
0212               *--------------------------------------------------------------
0213      A400     fh.struct         equ  >a400           ; stevie file handling structures
0214      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0215      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0216      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0217      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0218      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0219      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0220      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0221      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0222      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0223      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0224      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0225      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0226      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0227      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0228      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0229      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0230      A444     fh.kilobytes.prev equ  fh.struct + 68  ; Kilobytes process (previous)
0231      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0232      A496     fh.end            equ  fh.struct +150  ; End of structure
0233      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0234      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0235               *--------------------------------------------------------------
0236               * Index structure                   @>a500-a5ff     (256 bytes)
0237               *--------------------------------------------------------------
0238      A500     idx.struct        equ  >a500           ; stevie index structure
0239      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0240      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0241      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0242               *--------------------------------------------------------------
0243               * Frame buffer                      @>a600-afff    (2560 bytes)
0244               *--------------------------------------------------------------
0245      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0246      0960     fb.size           equ  80*30           ; Frame buffer size
0247               *--------------------------------------------------------------
0248               * Index                             @>b000-bfff    (4096 bytes)
0249               *--------------------------------------------------------------
0250      B000     idx.top           equ  >b000           ; Top of index
0251      1000     idx.size          equ  4096            ; Index size
0252               *--------------------------------------------------------------
0253               * Editor buffer                     @>c000-cfff    (4096 bytes)
0254               *--------------------------------------------------------------
0255      C000     edb.top           equ  >c000           ; Editor buffer high memory
0256      1000     edb.size          equ  4096            ; Editor buffer size
0257               *--------------------------------------------------------------
0258               * Command buffer                    @>d000-dfff    (4096 bytes)
0259               *--------------------------------------------------------------
0260      D000     cmdb.top          equ  >d000           ; Top of command buffer
0261      1000     cmdb.size         equ  4096            ; Command buffer size
0262               *--------------------------------------------------------------
0263               * Heap                              @>e000-efff    (4096 bytes)
0264               *--------------------------------------------------------------
0265      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b1.asm.360191
0018                       copy  "kickstart.asm"       ; Cartridge header
**** **** ****     > kickstart.asm
0001               * FILE......: kickstart.asm
0002               * Purpose...: Bankswitch routine for starting stevie
0003               
0004               ***************************************************************
0005               * Stevie Cartridge Header & kickstart ROM bank 0
0006               ***************************************************************
0007               *
0008               *--------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * OUTPUT
0013               * none
0014               *--------------------------------------------------------------
0015               * Register usage
0016               * r0
0017               ***************************************************************
0018               
0019               *--------------------------------------------------------------
0020               * Cartridge header
0021               ********|*****|*********************|**************************
0022 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0023 6006 6010             data  $+10
0024 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0025 6010 0000             data  0                     ; No more items following
0026 6012 6030             data  kickstart.code1
0027               
0029               
0030 6014 1453             byte  20
0031 6015 ....             text  'STEVIE 200713-360191'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.360191
0019               
0020                       aorg  >2000
0021                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *              the Texas Instruments TI-99/4A Home Computer
0010               *
0011               *                      2010-2020 by Filip Van Vooren
0012               *
0013               *              https://github.com/FilipVanVooren/spectra2.git
0014               *******************************************************************************
0015               * This file: runlib.a99
0016               *******************************************************************************
0017               * Use following equates to skip/exclude support modules and to control startup
0018               * behaviour.
0019               *
0020               * == Memory
0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0028               *
0029               * == VDP
0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0043               *
0044               * == Sound & speech
0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0048               *
0049               * ==  Keyboard
0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0052               *
0053               * == Utilities
0054               * skip_random_generator     equ  1  ; Skip random generator functions
0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0061               * skip_cpu_strings          equ  1  ; Skip string support utilities
0062               
0063               * == Kernel/Multitasking
0064               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0065               * skip_mem_paging           equ  1  ; Skip support for memory paging
0066               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0067               *
0068               * == Startup behaviour
0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0071               *******************************************************************************
0072               
0073               *//////////////////////////////////////////////////////////////
0074               *                       RUNLIB SETUP
0075               *//////////////////////////////////////////////////////////////
0076               
0077                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
0002               * Purpose...: Equates for spectra2 memory layout
0003               
0004               ***************************************************************
0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0006               ********|*****|*********************|**************************
0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0022               ***************************************************************
0023      832A     by      equ   wyx                   ;      Cursor Y position
0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0026               ***************************************************************
**** **** ****     > runlib.asm
0078                       copy  "equ_registers.asm"        ; Equates runlib registers
**** **** ****     > equ_registers.asm
0001               * FILE......: registers.asm
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4      Temporary register/variable tmp0
0011               * R5      Temporary register/variable tmp1
0012               * R6      Temporary register/variable tmp2
0013               * R7      Temporary register/variable tmp3
0014               * R8      Temporary register/variable tmp4
0015               * R9      Stack pointer
0016               * R10     Highest slot in use + Timer counter
0017               * R11     Subroutine return address
0018               * R12     CRU
0019               * R13     Copy of VDP status byte and counter for sound player
0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0021               * R15     VDP read/write address
0022               *--------------------------------------------------------------
0023               * Special purpose registers
0024               * R0      shift count
0025               * R12     CRU
0026               * R13     WS     - when using LWPI, BLWP, RTWP
0027               * R14     PC     - when using LWPI, BLWP, RTWP
0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0029               ***************************************************************
0030               * Define registers
0031               ********|*****|*********************|**************************
0032      0000     r0      equ   0
0033      0001     r1      equ   1
0034      0002     r2      equ   2
0035      0003     r3      equ   3
0036      0004     r4      equ   4
0037      0005     r5      equ   5
0038      0006     r6      equ   6
0039      0007     r7      equ   7
0040      0008     r8      equ   8
0041      0009     r9      equ   9
0042      000A     r10     equ   10
0043      000B     r11     equ   11
0044      000C     r12     equ   12
0045      000D     r13     equ   13
0046      000E     r14     equ   14
0047      000F     r15     equ   15
0048               ***************************************************************
0049               * Define register equates
0050               ********|*****|*********************|**************************
0051      0002     config  equ   r2                    ; Config register
0052      0003     xconfig equ   r3                    ; Extended config register
0053      0004     tmp0    equ   r4                    ; Temp register 0
0054      0005     tmp1    equ   r5                    ; Temp register 1
0055      0006     tmp2    equ   r6                    ; Temp register 2
0056      0007     tmp3    equ   r7                    ; Temp register 3
0057      0008     tmp4    equ   r8                    ; Temp register 4
0058      0009     stack   equ   r9                    ; Stack pointer
0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0061               ***************************************************************
0062               * Define MSB/LSB equates for registers
0063               ********|*****|*********************|**************************
0064      8300     r0hb    equ   ws1                   ; HI byte R0
0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0096               ********|*****|*********************|**************************
0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0107               ********|*****|*********************|**************************
0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0112               ***************************************************************
**** **** ****     > runlib.asm
0079                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
0002               * Purpose...: Equates for hardware port addresses
0003               
0004               ***************************************************************
0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0006               ********|*****|*********************|**************************
0007      8400     sound   equ   >8400                 ; Sound generator address
0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0010      8802     vdps    equ   >8802                 ; VDP status register
0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0013      9802     grmra   equ   >9802                 ; GROM set read address
0014      9800     grmrd   equ   >9800                 ; GROM read byte
0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
**** **** ****     > runlib.asm
0080                       copy  "equ_param.asm"            ; Equates runlib parameters
**** **** ****     > equ_param.asm
0001               * FILE......: param.asm
0002               * Purpose...: Equates used for subroutine parameters
0003               
0004               ***************************************************************
0005               * Subroutine parameter equates
0006               ***************************************************************
0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0024               *--------------------------------------------------------------
0025               *   Speech player
0026               *--------------------------------------------------------------
0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
**** **** ****     > runlib.asm
0081               
0083                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 2000 C13B  30 swbnk   mov   *r11+,tmp0
0026 2002 C17B  30         mov   *r11+,tmp1
0027 2004 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 2006 C155  26         mov   *tmp1,tmp1
0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
0085               
0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
**** **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               ---------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 200A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 200C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 200E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2010 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2012 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 2014 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 2016 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 2018 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 201A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 201C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 201E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2020 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2022 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 2024 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 2026 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 2028 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 202A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 202C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 202E D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      200A     hb$00   equ   w$0000                ; >0000
0035      201C     hb$01   equ   w$0100                ; >0100
0036      201E     hb$02   equ   w$0200                ; >0200
0037      2020     hb$04   equ   w$0400                ; >0400
0038      2022     hb$08   equ   w$0800                ; >0800
0039      2024     hb$10   equ   w$1000                ; >1000
0040      2026     hb$20   equ   w$2000                ; >2000
0041      2028     hb$40   equ   w$4000                ; >4000
0042      202A     hb$80   equ   w$8000                ; >8000
0043      202E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      200A     lb$00   equ   w$0000                ; >0000
0048      200C     lb$01   equ   w$0001                ; >0001
0049      200E     lb$02   equ   w$0002                ; >0002
0050      2010     lb$04   equ   w$0004                ; >0004
0051      2012     lb$08   equ   w$0008                ; >0008
0052      2014     lb$10   equ   w$0010                ; >0010
0053      2016     lb$20   equ   w$0020                ; >0020
0054      2018     lb$40   equ   w$0040                ; >0040
0055      201A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0087                       copy  "equ_config.asm"           ; Equates for bits in config register
**** **** ****     > equ_config.asm
0001               * FILE......: equ_config.asm
0002               * Purpose...: Equates for bits in config register
0003               
0004               ***************************************************************
0005               * The config register equates
0006               *--------------------------------------------------------------
0007               * Configuration flags
0008               * ===================
0009               *
0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0019               * ; 06  Timer: Block user hook          1=yes          0=no
0020               * ; 05  Speech synthesizer present      1=yes          0=no
0021               * ; 04  Speech player: busy             1=yes          0=no
0022               * ; 03  Speech player: enabled          1=yes          0=no
0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0024               * ; 01  F18A present                    1=on           0=off
0025               * ; 00  Subroutine state flag           1=on           0=off
0026               ********|*****|*********************|**************************
0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
0032               
**** **** ****     > runlib.asm
0088                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
0001               * FILE......: cpu_crash.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               ***************************************************************
0006               * cpu.crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @cpu.crash
0009               *--------------------------------------------------------------
0010               * Crash and halt system. Upon crash entry register contents are
0011               * copied to the memory region >ffe0 - >fffe and displayed after
0012               * resetting the spectra2 runtime library, video modes, etc.
0013               *
0014               * Diagnostics
0015               * >ffce  caller address
0016               *
0017               * Register contents
0018               * >ffdc  wp
0019               * >ffde  st
0020               * >ffe0  r0
0021               * >ffe2  r1
0022               * >ffe4  r2  (config)
0023               * >ffe6  r3
0024               * >ffe8  r4  (tmp0)
0025               * >ffea  r5  (tmp1)
0026               * >ffec  r6  (tmp2)
0027               * >ffee  r7  (tmp3)
0028               * >fff0  r8  (tmp4)
0029               * >fff2  r9  (stack)
0030               * >fff4  r10
0031               * >fff6  r11
0032               * >fff8  r12
0033               * >fffa  r13
0034               * >fffc  r14
0035               * >fffe  r15
0036               ********|*****|*********************|**************************
0037               cpu.crash:
0038 2030 022B  22         ai    r11,-4                ; Remove opcode offset
     2032 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 2034 C800  38         mov   r0,@>ffe0
     2036 FFE0 
0043 2038 C801  38         mov   r1,@>ffe2
     203A FFE2 
0044 203C C802  38         mov   r2,@>ffe4
     203E FFE4 
0045 2040 C803  38         mov   r3,@>ffe6
     2042 FFE6 
0046 2044 C804  38         mov   r4,@>ffe8
     2046 FFE8 
0047 2048 C805  38         mov   r5,@>ffea
     204A FFEA 
0048 204C C806  38         mov   r6,@>ffec
     204E FFEC 
0049 2050 C807  38         mov   r7,@>ffee
     2052 FFEE 
0050 2054 C808  38         mov   r8,@>fff0
     2056 FFF0 
0051 2058 C809  38         mov   r9,@>fff2
     205A FFF2 
0052 205C C80A  38         mov   r10,@>fff4
     205E FFF4 
0053 2060 C80B  38         mov   r11,@>fff6
     2062 FFF6 
0054 2064 C80C  38         mov   r12,@>fff8
     2066 FFF8 
0055 2068 C80D  38         mov   r13,@>fffa
     206A FFFA 
0056 206C C80E  38         mov   r14,@>fffc
     206E FFFC 
0057 2070 C80F  38         mov   r15,@>ffff
     2072 FFFF 
0058 2074 02A0  12         stwp  r0
0059 2076 C800  38         mov   r0,@>ffdc
     2078 FFDC 
0060 207A 02C0  12         stst  r0
0061 207C C800  38         mov   r0,@>ffde
     207E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2080 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2082 8300 
0067 2084 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2086 8302 
0068 2088 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     208A 4A4A 
0069 208C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     208E 2E04 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2092 22F2 
0078 2094 21F2                   data graph1           ; Equate selected video mode table
0079               
0080 2096 06A0  32         bl    @ldfnt
     2098 235A 
0081 209A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     209C 000C 
0082               
0083 209E 06A0  32         bl    @filv
     20A0 2288 
0084 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0 
     20A6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 243C 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 2978 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 243C 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 2978 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 243C 
0113 20D4 0300                   byte 3,0
0114 20D6 21B2                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 243C 
0116 20DC 0400                   byte 4,0
0117 20DE 21B8                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 243C 
0119 20E4 1600                   byte 22,0
0120 20E6 21BE                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 243C 
0122 20EC 1700                   byte 23,0
0123 20EE 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 2680 
0128 20F4 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20F6 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20F8 FFDC 
0132 20FA 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20FC C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20FE 0649  14         dect  stack
0138 2100 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 2102 0649  14         dect  stack
0140 2104 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 2106 0649  14         dect  stack
0142 2108 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 210A C046  18         mov   tmp2,r1               ; Save register number
0148 210C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     210E 0001 
0149 2110 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2112 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 2114 06A0  32         bl    @mknum
     2116 2982 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 2696 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 2418 
0164 2128 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 2696 
0168 212E 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2130 0281  22         ci    r1,10
     2132 000A 
0172 2134 1102  14         jlt   !
0173 2136 0620  34         dec   @wyx                  ; x=x-1
     2138 832A 
0174               
0175 213A 06A0  32 !       bl    @putstr
     213C 2418 
0176 213E 21AE                   data cpu.crash.msg.r
0177               
0178 2140 06A0  32         bl    @mknum
     2142 2982 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 28F4 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 2696 
0194 2158 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr
     215C 2418 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 2696 
0201 2164 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2166 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2168 2418 
0205 216A 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 216C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 216E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2172 06A0  32         bl    @down                 ; y=y+1
     2174 2686 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2D12 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2182 1553             byte  21
0225 2183 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 2198 1543             byte  21
0230 2199 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21AE 0152             byte  1
0235 21AF ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21B0 013E             byte  1
0240 21B1 ....             text  '>'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21B2 042A             byte  4
0245 21B3 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B8 042A             byte  4
0250 21B9 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21BE 1B53             byte  27
0255 21BF ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21DA 1742             byte  23
0260 21DB ....             text  'Build-ID  200713-360191'
0261                       even
0262               
**** **** ****     > runlib.asm
0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21F2 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21F4 000E 
     21F6 0106 
     21F8 0204 
     21FA 0020 
0008               *
0009               * ; VDP#0 Control bits
0010               * ;      bit 6=0: M3 | Graphics 1 mode
0011               * ;      bit 7=0: Disable external VDP input
0012               * ; VDP#1 Control bits
0013               * ;      bit 0=1: 16K selection
0014               * ;      bit 1=1: Enable display
0015               * ;      bit 2=1: Enable VDP interrupt
0016               * ;      bit 3=0: M1 \ Graphics 1 mode
0017               * ;      bit 4=0: M2 /
0018               * ;      bit 5=0: reserved
0019               * ;      bit 6=1: 16x16 sprites
0020               * ;      bit 7=0: Sprite magnification (1x)
0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
0026               * ; VDP#7 Set screen background color
0027               
0028               
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 21FC 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21FE 000E 
     2200 0106 
     2202 00F4 
     2204 0028 
0033               *
0034               * ; VDP#0 Control bits
0035               * ;      bit 6=0: M3 | Graphics 1 mode
0036               * ;      bit 7=0: Disable external VDP input
0037               * ; VDP#1 Control bits
0038               * ;      bit 0=1: 16K selection
0039               * ;      bit 1=1: Enable display
0040               * ;      bit 2=1: Enable VDP interrupt
0041               * ;      bit 3=1: M1 \ TEXT MODE
0042               * ;      bit 4=0: M2 /
0043               * ;      bit 5=0: reserved
0044               * ;      bit 6=1: 16x16 sprites
0045               * ;      bit 7=0: Sprite magnification (1x)
0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0051               * ; VDP#7 Set foreground/background color
0052               ***************************************************************
0053               
0054               
0055               ***************************************************************
0056               * Textmode (80 columns, 24 rows) - F18A
0057               *--------------------------------------------------------------
0058 2206 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2208 003F 
     220A 0240 
     220C 03F4 
     220E 0050 
0059               *
0060               * ; VDP#0 Control bits
0061               * ;      bit 6=0: M3 | Graphics 1 mode
0062               * ;      bit 7=0: Disable external VDP input
0063               * ; VDP#1 Control bits
0064               * ;      bit 0=1: 16K selection
0065               * ;      bit 1=1: Enable display
0066               * ;      bit 2=1: Enable VDP interrupt
0067               * ;      bit 3=1: M1 \ TEXT MODE
0068               * ;      bit 4=0: M2 /
0069               * ;      bit 5=0: reserved
0070               * ;      bit 6=0: 8x8 sprites
0071               * ;      bit 7=0: Sprite magnification (1x)
0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0077               * ; VDP#7 Set foreground/background color
0078               ***************************************************************
0079               
0080               
0081               ***************************************************************
0082               * Textmode (80 columns, 30 rows) - F18A
0083               *--------------------------------------------------------------
0084 2210 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2212 003F 
     2214 0240 
     2216 03F4 
     2218 0050 
0085               *
0086               * ; VDP#0 Control bits
0087               * ;      bit 6=0: M3 | Graphics 1 mode
0088               * ;      bit 7=0: Disable external VDP input
0089               * ; VDP#1 Control bits
0090               * ;      bit 0=1: 16K selection
0091               * ;      bit 1=1: Enable display
0092               * ;      bit 2=1: Enable VDP interrupt
0093               * ;      bit 3=1: M1 \ TEXT MODE
0094               * ;      bit 4=0: M2 /
0095               * ;      bit 5=0: reserved
0096               * ;      bit 6=0: 8x8 sprites
0097               * ;      bit 7=0: Sprite magnification (1x)
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
**** **** ****     > basic_cpu_vdp.asm
0001               * FILE......: basic_cpu_vdp.asm
0002               * Purpose...: Basic CPU & VDP functions used by other modules
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Support Machine Code for copy & fill functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ; Machine code for tight loop.
0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
0011               *--------------------------------------------------------------
0012               *       DATA  >????                 ; \ mcloop  mov   ...
0013 221A 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 221C 16FD             data  >16fd                 ; |         jne   mcloop
0015 221E 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2220 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2222 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               *//////////////////////////////////////////////////////////////
0027               *                    STACK SUPPORT FUNCTIONS
0028               *//////////////////////////////////////////////////////////////
0029               
0030               ***************************************************************
0031               * POPR. - Pop registers & return to caller
0032               ***************************************************************
0033               *  B  @POPRG.
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  R11 must be at stack bottom
0037               ********|*****|*********************|**************************
0038 2224 C0F9  30 popr3   mov   *stack+,r3
0039 2226 C0B9  30 popr2   mov   *stack+,r2
0040 2228 C079  30 popr1   mov   *stack+,r1
0041 222A C039  30 popr0   mov   *stack+,r0
0042 222C C2F9  30 poprt   mov   *stack+,r11
0043 222E 045B  20         b     *r11
0044               
0045               
0046               
0047               *//////////////////////////////////////////////////////////////
0048               *                   MEMORY FILL FUNCTIONS
0049               *//////////////////////////////////////////////////////////////
0050               
0051               ***************************************************************
0052               * FILM - Fill CPU memory with byte
0053               ***************************************************************
0054               *  bl   @film
0055               *  data P0,P1,P2
0056               *--------------------------------------------------------------
0057               *  P0 = Memory start address
0058               *  P1 = Byte to fill
0059               *  P2 = Number of bytes to fill
0060               *--------------------------------------------------------------
0061               *  bl   @xfilm
0062               *
0063               *  TMP0 = Memory start address
0064               *  TMP1 = Byte to fill
0065               *  TMP2 = Number of bytes to fill
0066               ********|*****|*********************|**************************
0067 2230 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 2232 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 2234 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 2236 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 2238 1604  14         jne   filchk                ; No, continue checking
0075               
0076 223A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     223C FFCE 
0077 223E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2240 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 2242 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2244 830B 
     2246 830A 
0082               
0083 2248 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     224A 0001 
0084 224C 1602  14         jne   filchk2
0085 224E DD05  32         movb  tmp1,*tmp0+
0086 2250 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 2252 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2254 0002 
0091 2256 1603  14         jne   filchk3
0092 2258 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 225A DD05  32         movb  tmp1,*tmp0+
0094 225C 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 225E C1C4  18 filchk3 mov   tmp0,tmp3
0099 2260 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2262 0001 
0100 2264 1605  14         jne   fil16b
0101 2266 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 2268 0606  14         dec   tmp2
0103 226A 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     226C 0002 
0104 226E 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2270 C1C6  18 fil16b  mov   tmp2,tmp3
0109 2272 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2274 0001 
0110 2276 1301  14         jeq   dofill
0111 2278 0606  14         dec   tmp2                  ; Make TMP2 even
0112 227A CD05  34 dofill  mov   tmp1,*tmp0+
0113 227C 0646  14         dect  tmp2
0114 227E 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2280 C1C7  18         mov   tmp3,tmp3
0119 2282 1301  14         jeq   fil.$$
0120 2284 DD05  32         movb  tmp1,*tmp0+
0121 2286 045B  20 fil.$$  b     *r11
0122               
0123               
0124               ***************************************************************
0125               * FILV - Fill VRAM with byte
0126               ***************************************************************
0127               *  BL   @FILV
0128               *  DATA P0,P1,P2
0129               *--------------------------------------------------------------
0130               *  P0 = VDP start address
0131               *  P1 = Byte to fill
0132               *  P2 = Number of bytes to fill
0133               *--------------------------------------------------------------
0134               *  BL   @XFILV
0135               *
0136               *  TMP0 = VDP start address
0137               *  TMP1 = Byte to fill
0138               *  TMP2 = Number of bytes to fill
0139               ********|*****|*********************|**************************
0140 2288 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 228A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 228C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 228E 0264  22 xfilv   ori   tmp0,>4000
     2290 4000 
0147 2292 06C4  14         swpb  tmp0
0148 2294 D804  38         movb  tmp0,@vdpa
     2296 8C02 
0149 2298 06C4  14         swpb  tmp0
0150 229A D804  38         movb  tmp0,@vdpa
     229C 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 229E 020F  20         li    r15,vdpw              ; Set VDP write address
     22A0 8C00 
0155 22A2 06C5  14         swpb  tmp1
0156 22A4 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22A6 22AE 
     22A8 8320 
0157 22AA 0460  28         b     @mcloop               ; Write data to VDP
     22AC 8320 
0158               *--------------------------------------------------------------
0162 22AE D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0164               
0165               
0166               
0167               *//////////////////////////////////////////////////////////////
0168               *                  VDP LOW LEVEL FUNCTIONS
0169               *//////////////////////////////////////////////////////////////
0170               
0171               ***************************************************************
0172               * VDWA / VDRA - Setup VDP write or read address
0173               ***************************************************************
0174               *  BL   @VDWA
0175               *
0176               *  TMP0 = VDP destination address for write
0177               *--------------------------------------------------------------
0178               *  BL   @VDRA
0179               *
0180               *  TMP0 = VDP source address for read
0181               ********|*****|*********************|**************************
0182 22B0 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22B2 4000 
0183 22B4 06C4  14 vdra    swpb  tmp0
0184 22B6 D804  38         movb  tmp0,@vdpa
     22B8 8C02 
0185 22BA 06C4  14         swpb  tmp0
0186 22BC D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22BE 8C02 
0187 22C0 045B  20         b     *r11                  ; Exit
0188               
0189               ***************************************************************
0190               * VPUTB - VDP put single byte
0191               ***************************************************************
0192               *  BL @VPUTB
0193               *  DATA P0,P1
0194               *--------------------------------------------------------------
0195               *  P0 = VDP target address
0196               *  P1 = Byte to write
0197               ********|*****|*********************|**************************
0198 22C2 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22C4 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22C6 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22C8 4000 
0204 22CA 06C4  14         swpb  tmp0                  ; \
0205 22CC D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22CE 8C02 
0206 22D0 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22D2 D804  38         movb  tmp0,@vdpa            ; /
     22D4 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22D6 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22D8 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22DA 045B  20         b     *r11                  ; Exit
0214               
0215               
0216               ***************************************************************
0217               * VGETB - VDP get single byte
0218               ***************************************************************
0219               *  bl   @vgetb
0220               *  data p0
0221               *--------------------------------------------------------------
0222               *  P0 = VDP source address
0223               *--------------------------------------------------------------
0224               *  bl   @xvgetb
0225               *
0226               *  tmp0 = VDP source address
0227               *--------------------------------------------------------------
0228               *  Output:
0229               *  tmp0 MSB = >00
0230               *  tmp0 LSB = VDP byte read
0231               ********|*****|*********************|**************************
0232 22DC C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22DE 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22E0 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22E2 8C02 
0238 22E4 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22E6 D804  38         movb  tmp0,@vdpa            ; /
     22E8 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22EA D120  34         movb  @vdpr,tmp0            ; Read byte
     22EC 8800 
0244 22EE 0984  56         srl   tmp0,8                ; Right align
0245 22F0 045B  20         b     *r11                  ; Exit
0246               
0247               
0248               ***************************************************************
0249               * VIDTAB - Dump videomode table
0250               ***************************************************************
0251               *  BL   @VIDTAB
0252               *  DATA P0
0253               *--------------------------------------------------------------
0254               *  P0 = Address of video mode table
0255               *--------------------------------------------------------------
0256               *  BL   @XIDTAB
0257               *
0258               *  TMP0 = Address of video mode table
0259               *--------------------------------------------------------------
0260               *  Remarks
0261               *  TMP1 = MSB is the VDP target register
0262               *         LSB is the value to write
0263               ********|*****|*********************|**************************
0264 22F2 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22F4 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22F6 C144  18         mov   tmp0,tmp1
0270 22F8 05C5  14         inct  tmp1
0271 22FA D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22FC 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22FE FF00 
0273 2300 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 2302 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2304 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 2306 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2308 8000 
0279 230A 0206  20         li    tmp2,8
     230C 0008 
0280 230E D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2310 830B 
0281 2312 06C5  14         swpb  tmp1
0282 2314 D805  38         movb  tmp1,@vdpa
     2316 8C02 
0283 2318 06C5  14         swpb  tmp1
0284 231A D805  38         movb  tmp1,@vdpa
     231C 8C02 
0285 231E 0225  22         ai    tmp1,>0100
     2320 0100 
0286 2322 0606  14         dec   tmp2
0287 2324 16F4  14         jne   vidta1                ; Next register
0288 2326 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2328 833A 
0289 232A 045B  20         b     *r11
0290               
0291               
0292               ***************************************************************
0293               * PUTVR  - Put single VDP register
0294               ***************************************************************
0295               *  BL   @PUTVR
0296               *  DATA P0
0297               *--------------------------------------------------------------
0298               *  P0 = MSB is the VDP target register
0299               *       LSB is the value to write
0300               *--------------------------------------------------------------
0301               *  BL   @PUTVRX
0302               *
0303               *  TMP0 = MSB is the VDP target register
0304               *         LSB is the value to write
0305               ********|*****|*********************|**************************
0306 232C C13B  30 putvr   mov   *r11+,tmp0
0307 232E 0264  22 putvrx  ori   tmp0,>8000
     2330 8000 
0308 2332 06C4  14         swpb  tmp0
0309 2334 D804  38         movb  tmp0,@vdpa
     2336 8C02 
0310 2338 06C4  14         swpb  tmp0
0311 233A D804  38         movb  tmp0,@vdpa
     233C 8C02 
0312 233E 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2340 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 2342 C10E  18         mov   r14,tmp0
0322 2344 0984  56         srl   tmp0,8
0323 2346 06A0  32         bl    @putvrx               ; Write VR#0
     2348 232E 
0324 234A 0204  20         li    tmp0,>0100
     234C 0100 
0325 234E D820  54         movb  @r14lb,@tmp0lb
     2350 831D 
     2352 8309 
0326 2354 06A0  32         bl    @putvrx               ; Write VR#1
     2356 232E 
0327 2358 0458  20         b     *tmp4                 ; Exit
0328               
0329               
0330               ***************************************************************
0331               * LDFNT - Load TI-99/4A font from GROM into VDP
0332               ***************************************************************
0333               *  BL   @LDFNT
0334               *  DATA P0,P1
0335               *--------------------------------------------------------------
0336               *  P0 = VDP Target address
0337               *  P1 = Font options
0338               *--------------------------------------------------------------
0339               * Uses registers tmp0-tmp4
0340               ********|*****|*********************|**************************
0341 235A C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 235C 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 235E C11B  26         mov   *r11,tmp0             ; Get P0
0344 2360 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2362 7FFF 
0345 2364 2120  38         coc   @wbit0,tmp0
     2366 202A 
0346 2368 1604  14         jne   ldfnt1
0347 236A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     236C 8000 
0348 236E 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2370 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 2372 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2374 23DC 
0353 2376 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2378 9C02 
0354 237A 06C4  14         swpb  tmp0
0355 237C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     237E 9C02 
0356 2380 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2382 9800 
0357 2384 06C5  14         swpb  tmp1
0358 2386 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2388 9800 
0359 238A 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 238C D805  38         movb  tmp1,@grmwa
     238E 9C02 
0364 2390 06C5  14         swpb  tmp1
0365 2392 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     2394 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 2396 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 2398 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     239A 22B0 
0371 239C 05C8  14         inct  tmp4                  ; R11=R11+2
0372 239E C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 23A0 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23A2 7FFF 
0374 23A4 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23A6 23DE 
0375 23A8 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23AA 23E0 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 23AC 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 23AE 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 23B0 D120  34         movb  @grmrd,tmp0
     23B2 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 23B4 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23B6 202A 
0386 23B8 1603  14         jne   ldfnt3                ; No, so skip
0387 23BA D1C4  18         movb  tmp0,tmp3
0388 23BC 0917  56         srl   tmp3,1
0389 23BE E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23C0 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23C2 8C00 
0394 23C4 0606  14         dec   tmp2
0395 23C6 16F2  14         jne   ldfnt2
0396 23C8 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23CA 020F  20         li    r15,vdpw              ; Set VDP write address
     23CC 8C00 
0398 23CE 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23D0 7FFF 
0399 23D2 0458  20         b     *tmp4                 ; Exit
0400 23D4 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23D6 200A 
     23D8 8C00 
0401 23DA 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23DC 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23DE 0200 
     23E0 0000 
0406 23E2 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23E4 01C0 
     23E6 0101 
0407 23E8 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23EA 02A0 
     23EC 0101 
0408 23EE 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23F0 00E0 
     23F2 0101 
0409               
0410               
0411               
0412               ***************************************************************
0413               * YX2PNT - Get VDP PNT address for current YX cursor position
0414               ***************************************************************
0415               *  BL   @YX2PNT
0416               *--------------------------------------------------------------
0417               *  INPUT
0418               *  @WYX = Cursor YX position
0419               *--------------------------------------------------------------
0420               *  OUTPUT
0421               *  TMP0 = VDP address for entry in Pattern Name Table
0422               *--------------------------------------------------------------
0423               *  Register usage
0424               *  TMP0, R14, R15
0425               ********|*****|*********************|**************************
0426 23F4 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23F6 C3A0  34         mov   @wyx,r14              ; Get YX
     23F8 832A 
0428 23FA 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23FC 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23FE 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 2400 C3A0  34         mov   @wyx,r14              ; Get YX
     2402 832A 
0435 2404 024E  22         andi  r14,>00ff             ; Remove Y
     2406 00FF 
0436 2408 A3CE  18         a     r14,r15               ; pos = pos + X
0437 240A A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     240C 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 240E C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 2410 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 2412 020F  20         li    r15,vdpw              ; VDP write address
     2414 8C00 
0444 2416 045B  20         b     *r11
0445               
0446               
0447               
0448               ***************************************************************
0449               * Put length-byte prefixed string at current YX
0450               ***************************************************************
0451               *  BL   @PUTSTR
0452               *  DATA P0
0453               *
0454               *  P0 = Pointer to string
0455               *--------------------------------------------------------------
0456               *  REMARKS
0457               *  First byte of string must contain length
0458               ********|*****|*********************|**************************
0459 2418 C17B  30 putstr  mov   *r11+,tmp1
0460 241A D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 241C C1CB  18 xutstr  mov   r11,tmp3
0462 241E 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2420 23F4 
0463 2422 C2C7  18         mov   tmp3,r11
0464 2424 0986  56         srl   tmp2,8                ; Right justify length byte
0465               *--------------------------------------------------------------
0466               * Put string
0467               *--------------------------------------------------------------
0468 2426 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0469 2428 1305  14         jeq   !                     ; Yes, crash and burn
0470               
0471 242A 0286  22         ci    tmp2,255              ; Length > 255 ?
     242C 00FF 
0472 242E 1502  14         jgt   !                     ; Yes, crash and burn
0473               
0474 2430 0460  28         b     @xpym2v               ; Display string
     2432 244A 
0475               *--------------------------------------------------------------
0476               * Crash handler
0477               *--------------------------------------------------------------
0478 2434 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2436 FFCE 
0479 2438 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     243A 2030 
0480               
0481               
0482               
0483               ***************************************************************
0484               * Put length-byte prefixed string at YX
0485               ***************************************************************
0486               *  BL   @PUTAT
0487               *  DATA P0,P1
0488               *
0489               *  P0 = YX position
0490               *  P1 = Pointer to string
0491               *--------------------------------------------------------------
0492               *  REMARKS
0493               *  First byte of string must contain length
0494               ********|*****|*********************|**************************
0495 243C C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     243E 832A 
0496 2440 0460  28         b     @putstr
     2442 2418 
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
**** **** ****     > copy_cpu_vram.asm
0001               * FILE......: copy_cpu_vram.asm
0002               * Purpose...: CPU memory to VRAM copy support module
0003               
0004               ***************************************************************
0005               * CPYM2V - Copy CPU memory to VRAM
0006               ***************************************************************
0007               *  BL   @CPYM2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP start address
0011               *  P1 = RAM/ROM start address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYM2V
0015               *
0016               *  TMP0 = VDP start address
0017               *  TMP1 = RAM/ROM start address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 2444 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2446 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2448 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 244A 0264  22 xpym2v  ori   tmp0,>4000
     244C 4000 
0027 244E 06C4  14         swpb  tmp0
0028 2450 D804  38         movb  tmp0,@vdpa
     2452 8C02 
0029 2454 06C4  14         swpb  tmp0
0030 2456 D804  38         movb  tmp0,@vdpa
     2458 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 245A 020F  20         li    r15,vdpw              ; Set VDP write address
     245C 8C00 
0035 245E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2460 2468 
     2462 8320 
0036 2464 0460  28         b     @mcloop               ; Write data to VDP
     2466 8320 
0037 2468 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0095               
0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
**** **** ****     > copy_vram_cpu.asm
0001               * FILE......: copy_vram_cpu.asm
0002               * Purpose...: VRAM to CPU memory copy support module
0003               
0004               ***************************************************************
0005               * CPYV2M - Copy VRAM to CPU memory
0006               ***************************************************************
0007               *  BL   @CPYV2M
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP source address
0011               *  P1 = RAM target address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYV2M
0015               *
0016               *  TMP0 = VDP source address
0017               *  TMP1 = RAM target address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 246A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 246C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 246E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2470 06C4  14 xpyv2m  swpb  tmp0
0027 2472 D804  38         movb  tmp0,@vdpa
     2474 8C02 
0028 2476 06C4  14         swpb  tmp0
0029 2478 D804  38         movb  tmp0,@vdpa
     247A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 247C 020F  20         li    r15,vdpr              ; Set VDP read address
     247E 8800 
0034 2480 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2482 248A 
     2484 8320 
0035 2486 0460  28         b     @mcloop               ; Read data from VDP
     2488 8320 
0036 248A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0099               
0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
**** **** ****     > copy_cpu_cpu.asm
0001               * FILE......: copy_cpu_cpu.asm
0002               * Purpose...: CPU to CPU memory copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       CPU COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYM2M - Copy CPU memory to CPU memory
0010               ***************************************************************
0011               *  BL   @CPYM2M
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = Memory source address
0015               *  P1 = Memory target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @XPYM2M
0019               *
0020               *  TMP0 = Memory source address
0021               *  TMP1 = Memory target address
0022               *  TMP2 = Number of bytes to copy
0023               ********|*****|*********************|**************************
0024 248C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 248E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2490 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2492 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2494 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 2496 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2498 FFCE 
0034 249A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     249C 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 249E 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24A0 0001 
0039 24A2 1603  14         jne   cpym0                 ; No, continue checking
0040 24A4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24A6 04C6  14         clr   tmp2                  ; Reset counter
0042 24A8 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24AA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24AC 7FFF 
0047 24AE C1C4  18         mov   tmp0,tmp3
0048 24B0 0247  22         andi  tmp3,1
     24B2 0001 
0049 24B4 1618  14         jne   cpyodd                ; Odd source address handling
0050 24B6 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24B8 0247  22         andi  tmp3,1
     24BA 0001 
0052 24BC 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24BE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24C0 202A 
0057 24C2 1605  14         jne   cpym3
0058 24C4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24C6 24EC 
     24C8 8320 
0059 24CA 0460  28         b     @mcloop               ; Copy memory and exit
     24CC 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24CE C1C6  18 cpym3   mov   tmp2,tmp3
0064 24D0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24D2 0001 
0065 24D4 1301  14         jeq   cpym4
0066 24D6 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24D8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24DA 0646  14         dect  tmp2
0069 24DC 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24DE C1C7  18         mov   tmp3,tmp3
0074 24E0 1301  14         jeq   cpymz
0075 24E2 D554  38         movb  *tmp0,*tmp1
0076 24E4 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24E6 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24E8 8000 
0081 24EA 10E9  14         jmp   cpym2
0082 24EC DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0103               
0107               
0111               
0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
**** **** ****     > cpu_sams_support.asm
0001               * FILE......: cpu_sams_support.asm
0002               * Purpose...: Low level support for SAMS memory expansion card
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                SAMS Memory Expansion support
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ACCESS and MAPPING
0010               * (by the late Bruce Harisson):
0011               *
0012               * To use other than the default setup, you have to do two
0013               * things:
0014               *
0015               * 1. You have to "turn on" the card's memory in the
0016               *    >4000 block and write to the mapping registers there.
0017               *    (bl  @sams.page.set)
0018               *
0019               * 2. You have to "turn on" the mapper function to make what
0020               *    you've written into the >4000 block take effect.
0021               *    (bl  @sams.mapping.on)
0022               *--------------------------------------------------------------
0023               *  SAMS                          Default SAMS page
0024               *  Register     Memory bank      (system startup)
0025               *  =======      ===========      ================
0026               *  >4004        >2000-2fff          >002
0027               *  >4006        >3000-4fff          >003
0028               *  >4014        >a000-afff          >00a
0029               *  >4016        >b000-bfff          >00b
0030               *  >4018        >c000-cfff          >00c
0031               *  >401a        >d000-dfff          >00d
0032               *  >401c        >e000-efff          >00e
0033               *  >401e        >f000-ffff          >00f
0034               *  Others       Inactive
0035               *--------------------------------------------------------------
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * sams.page.get - Get SAMS page number for memory address
0042               ***************************************************************
0043               * bl   @sams.page.get
0044               *      data P0
0045               *--------------------------------------------------------------
0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
0047               *      register >4014 (bank >a000 - >afff)
0048               *--------------------------------------------------------------
0049               * bl   @xsams.page.get
0050               *
0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
0052               *        register >4014 (bank >a000 - >afff)
0053               *--------------------------------------------------------------
0054               * OUTPUT
0055               * waux1 = SAMS page number
0056               * waux2 = Address of affected SAMS register
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * r0, tmp0, r12
0060               ********|*****|*********************|**************************
0061               sams.page.get:
0062 24EE C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24F0 0649  14         dect  stack
0065 24F2 C64B  30         mov   r11,*stack            ; Push return address
0066 24F4 0649  14         dect  stack
0067 24F6 C640  30         mov   r0,*stack             ; Push r0
0068 24F8 0649  14         dect  stack
0069 24FA C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24FC 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24FE 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2500 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2502 4000 
0077 2504 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2506 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2508 020C  20         li    r12,>1e00             ; SAMS CRU address
     250A 1E00 
0082 250C 04C0  14         clr   r0
0083 250E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2510 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2512 D100  18         movb  r0,tmp0
0086 2514 0984  56         srl   tmp0,8                ; Right align
0087 2516 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2518 833C 
0088 251A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 251C C339  30         mov   *stack+,r12           ; Pop r12
0094 251E C039  30         mov   *stack+,r0            ; Pop r0
0095 2520 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2522 045B  20         b     *r11                  ; Return to caller
0097               
0098               
0099               
0100               
0101               ***************************************************************
0102               * sams.page.set - Set SAMS memory page
0103               ***************************************************************
0104               * bl   sams.page.set
0105               *      data P0,P1
0106               *--------------------------------------------------------------
0107               * P0 = SAMS page number
0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
0109               *      register >4014 (bank >a000 - >afff)
0110               *--------------------------------------------------------------
0111               * bl   @xsams.page.set
0112               *
0113               * tmp0 = SAMS page number
0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
0115               *        register >4014 (bank >a000 - >afff)
0116               *--------------------------------------------------------------
0117               * Register usage
0118               * r0, tmp0, tmp1, r12
0119               *--------------------------------------------------------------
0120               * SAMS page number should be in range 0-255 (>00 to >ff)
0121               *
0122               *  Page         Memory
0123               *  ====         ======
0124               *  >00             32K
0125               *  >1f            128K
0126               *  >3f            256K
0127               *  >7f            512K
0128               *  >ff           1024K
0129               ********|*****|*********************|**************************
0130               sams.page.set:
0131 2524 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2526 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2528 0649  14         dect  stack
0135 252A C64B  30         mov   r11,*stack            ; Push return address
0136 252C 0649  14         dect  stack
0137 252E C640  30         mov   r0,*stack             ; Push r0
0138 2530 0649  14         dect  stack
0139 2532 C64C  30         mov   r12,*stack            ; Push r12
0140 2534 0649  14         dect  stack
0141 2536 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2538 0649  14         dect  stack
0143 253A C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 253C 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 253E 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2540 0284  22         ci    tmp0,255              ; Crash if page > 255
     2542 00FF 
0153 2544 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2546 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2548 001E 
0158 254A 150A  14         jgt   !
0159 254C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     254E 0004 
0160 2550 1107  14         jlt   !
0161 2552 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2554 0012 
0162 2556 1508  14         jgt   sams.page.set.switch_page
0163 2558 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     255A 0006 
0164 255C 1501  14         jgt   !
0165 255E 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2560 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2562 FFCE 
0170 2564 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2566 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2568 020C  20         li    r12,>1e00             ; SAMS CRU address
     256A 1E00 
0176 256C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 256E 06C0  14         swpb  r0                    ; LSB to MSB
0178 2570 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2572 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2574 4000 
0180 2576 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2578 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 257A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 257C C339  30         mov   *stack+,r12           ; Pop r12
0188 257E C039  30         mov   *stack+,r0            ; Pop r0
0189 2580 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2582 045B  20         b     *r11                  ; Return to caller
0191               
0192               
0193               
0194               
0195               ***************************************************************
0196               * sams.mapping.on - Enable SAMS mapping mode
0197               ***************************************************************
0198               *  bl   @sams.mapping.on
0199               *--------------------------------------------------------------
0200               *  Register usage
0201               *  r12
0202               ********|*****|*********************|**************************
0203               sams.mapping.on:
0204 2584 020C  20         li    r12,>1e00             ; SAMS CRU address
     2586 1E00 
0205 2588 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 258A 045B  20         b     *r11                  ; Return to caller
0211               
0212               
0213               
0214               
0215               ***************************************************************
0216               * sams.mapping.off - Disable SAMS mapping mode
0217               ***************************************************************
0218               * bl  @sams.mapping.off
0219               *--------------------------------------------------------------
0220               * OUTPUT
0221               * none
0222               *--------------------------------------------------------------
0223               * Register usage
0224               * r12
0225               ********|*****|*********************|**************************
0226               sams.mapping.off:
0227 258C 020C  20         li    r12,>1e00             ; SAMS CRU address
     258E 1E00 
0228 2590 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 2592 045B  20         b     *r11                  ; Return to caller
0234               
0235               
0236               
0237               
0238               
0239               ***************************************************************
0240               * sams.layout
0241               * Setup SAMS memory banks
0242               ***************************************************************
0243               * bl  @sams.layout
0244               *     data P0
0245               *--------------------------------------------------------------
0246               * INPUT
0247               * P0 = Pointer to SAMS page layout table (16 words).
0248               *--------------------------------------------------------------
0249               * bl  @xsams.layout
0250               *
0251               * tmp0 = Pointer to SAMS page layout table (16 words).
0252               *--------------------------------------------------------------
0253               * OUTPUT
0254               * none
0255               *--------------------------------------------------------------
0256               * Register usage
0257               * tmp0, tmp1, tmp2, tmp3
0258               ********|*****|*********************|**************************
0259               sams.layout:
0260 2594 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 2596 0649  14         dect  stack
0263 2598 C64B  30         mov   r11,*stack            ; Save return address
0264 259A 0649  14         dect  stack
0265 259C C644  30         mov   tmp0,*stack           ; Save tmp0
0266 259E 0649  14         dect  stack
0267 25A0 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25A2 0649  14         dect  stack
0269 25A4 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25A6 0649  14         dect  stack
0271 25A8 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25AA 0206  20         li    tmp2,8                ; Set loop counter
     25AC 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25AE C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25B0 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25B2 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25B4 2528 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25B6 0606  14         dec   tmp2                  ; Next iteration
0288 25B8 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25BA 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25BC 2584 
0294                                                   ; / activating changes.
0295               
0296 25BE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25C0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25C2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25C4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25C6 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25C8 045B  20         b     *r11                  ; Return to caller
0302               
0303               
0304               
0305               ***************************************************************
0306               * sams.layout.reset
0307               * Reset SAMS memory banks to standard layout
0308               ***************************************************************
0309               * bl  @sams.layout.reset
0310               *--------------------------------------------------------------
0311               * OUTPUT
0312               * none
0313               *--------------------------------------------------------------
0314               * Register usage
0315               * none
0316               ********|*****|*********************|**************************
0317               sams.layout.reset:
0318 25CA 0649  14         dect  stack
0319 25CC C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25CE 06A0  32         bl    @sams.layout
     25D0 2594 
0324 25D2 25D8                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25D6 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25D8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25DA 0002 
0336 25DC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25DE 0003 
0337 25E0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25E2 000A 
0338 25E4 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25E6 000B 
0339 25E8 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25EA 000C 
0340 25EC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25EE 000D 
0341 25F0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25F2 000E 
0342 25F4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25F6 000F 
0343               
0344               
0345               
0346               ***************************************************************
0347               * sams.layout.copy
0348               * Copy SAMS memory layout
0349               ***************************************************************
0350               * bl  @sams.layout.copy
0351               *     data P0
0352               *--------------------------------------------------------------
0353               * P0 = Pointer to 8 words RAM buffer for results
0354               *--------------------------------------------------------------
0355               * OUTPUT
0356               * RAM buffer will have the SAMS page number for each range
0357               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0358               *--------------------------------------------------------------
0359               * Register usage
0360               * tmp0, tmp1, tmp2, tmp3
0361               ***************************************************************
0362               sams.layout.copy:
0363 25F8 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 25FA 0649  14         dect  stack
0366 25FC C64B  30         mov   r11,*stack            ; Push return address
0367 25FE 0649  14         dect  stack
0368 2600 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2602 0649  14         dect  stack
0370 2604 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2606 0649  14         dect  stack
0372 2608 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 260A 0649  14         dect  stack
0374 260C C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 260E 0205  20         li    tmp1,sams.layout.copy.data
     2610 2630 
0379 2612 0206  20         li    tmp2,8                ; Set loop counter
     2614 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2616 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2618 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     261A 24F0 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 261C CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     261E 833C 
0390               
0391 2620 0606  14         dec   tmp2                  ; Next iteration
0392 2622 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2624 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2626 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2628 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 262A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 262C C2F9  30         mov   *stack+,r11           ; Pop r11
0402 262E 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2630 2000             data  >2000                 ; >2000-2fff
0408 2632 3000             data  >3000                 ; >3000-3fff
0409 2634 A000             data  >a000                 ; >a000-afff
0410 2636 B000             data  >b000                 ; >b000-bfff
0411 2638 C000             data  >c000                 ; >c000-cfff
0412 263A D000             data  >d000                 ; >d000-dfff
0413 263C E000             data  >e000                 ; >e000-efff
0414 263E F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 2640 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2642 FFBF 
0010 2644 0460  28         b     @putv01
     2646 2340 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2648 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     264A 0040 
0018 264C 0460  28         b     @putv01
     264E 2340 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2650 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2652 FFDF 
0026 2654 0460  28         b     @putv01
     2656 2340 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2658 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     265A 0020 
0034 265C 0460  28         b     @putv01
     265E 2340 
**** **** ****     > runlib.asm
0119               
0121                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 2660 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2662 FFFE 
0011 2664 0460  28         b     @putv01
     2666 2340 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2668 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     266A 0001 
0019 266C 0460  28         b     @putv01
     266E 2340 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2670 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2672 FFFD 
0027 2674 0460  28         b     @putv01
     2676 2340 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2678 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     267A 0002 
0035 267C 0460  28         b     @putv01
     267E 2340 
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
**** **** ****     > vdp_cursor.asm
0001               * FILE......: vdp_cursor.asm
0002               * Purpose...: VDP cursor handling
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               VDP cursor movement functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * AT - Set cursor YX position
0011               ***************************************************************
0012               *  bl   @yx
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  INPUT
0016               *  P0 = New Cursor YX position
0017               ********|*****|*********************|**************************
0018 2680 C83B  50 at      mov   *r11+,@wyx
     2682 832A 
0019 2684 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2686 B820  54 down    ab    @hb$01,@wyx
     2688 201C 
     268A 832A 
0028 268C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 268E 7820  54 up      sb    @hb$01,@wyx
     2690 201C 
     2692 832A 
0037 2694 045B  20         b     *r11
0038               
0039               
0040               ***************************************************************
0041               * setx - Set cursor X position
0042               ***************************************************************
0043               *  bl   @setx
0044               *  data p0
0045               *--------------------------------------------------------------
0046               *  Register usage
0047               *  TMP0
0048               ********|*****|*********************|**************************
0049 2696 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2698 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     269A 832A 
0051 269C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     269E 832A 
0052 26A0 045B  20         b     *r11
**** **** ****     > runlib.asm
0127               
0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
**** **** ****     > vdp_yx2px_calc.asm
0001               * FILE......: vdp_yx2px_calc.asm
0002               * Purpose...: Calculate pixel position for YX coordinate
0003               
0004               ***************************************************************
0005               * YX2PX - Get pixel position for cursor YX position
0006               ***************************************************************
0007               *  BL   @YX2PX
0008               *
0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
0010               *--------------------------------------------------------------
0011               *  INPUT
0012               *  @WYX   = Cursor YX position
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y pixel position
0016               *  TMP0LB = X pixel position
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  This subroutine does not support multicolor mode
0020               ********|*****|*********************|**************************
0021 26A2 C120  34 yx2px   mov   @wyx,tmp0
     26A4 832A 
0022 26A6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26A8 06C4  14         swpb  tmp0                  ; Y<->X
0024 26AA 04C5  14         clr   tmp1                  ; Clear before copy
0025 26AC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26AE 20A0  38         coc   @wbit1,config         ; f18a present ?
     26B0 2028 
0030 26B2 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26B4 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26B6 833A 
     26B8 26E2 
0032 26BA 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26BC 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26BE B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26C0 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26C2 0500 
0037 26C4 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26C6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26C8 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26CA 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26CC D105  18         movb  tmp1,tmp0
0051 26CE 06C4  14         swpb  tmp0                  ; X<->Y
0052 26D0 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26D2 202A 
0053 26D4 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26D6 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26D8 201C 
0059 26DA 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26DC 202E 
0060 26DE 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26E0 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26E2 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0131               
0135               
0139               
0141                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
**** **** ****     > vdp_f18a_support.asm
0001               * FILE......: vdp_f18a_support.asm
0002               * Purpose...: VDP F18A Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * f18unl - Unlock F18A VDP
0010               ***************************************************************
0011               *  bl   @f18unl
0012               ********|*****|*********************|**************************
0013 26E4 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26E6 06A0  32         bl    @putvr                ; Write once
     26E8 232C 
0015 26EA 391C             data  >391c                 ; VR1/57, value 00011100
0016 26EC 06A0  32         bl    @putvr                ; Write twice
     26EE 232C 
0017 26F0 391C             data  >391c                 ; VR1/57, value 00011100
0018 26F2 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26F4 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26F6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26F8 232C 
0028 26FA 391C             data  >391c
0029 26FC 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********|*****|*********************|**************************
0040 26FE C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2700 06A0  32         bl    @cpym2v
     2702 2444 
0042 2704 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2706 2742 
     2708 0006 
0043 270A 06A0  32         bl    @putvr
     270C 232C 
0044 270E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2710 06A0  32         bl    @putvr
     2712 232C 
0046 2714 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2716 0204  20         li    tmp0,>3f00
     2718 3F00 
0052 271A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     271C 22B4 
0053 271E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2720 8800 
0054 2722 0984  56         srl   tmp0,8
0055 2724 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2726 8800 
0056 2728 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 272A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 272C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     272E BFFF 
0060 2730 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2732 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2734 4000 
0063               f18chk_exit:
0064 2736 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2738 2288 
0065 273A 3F00             data  >3f00,>00,6
     273C 0000 
     273E 0006 
0066 2740 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2742 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2744 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2746 0340             data  >0340                 ; 3f04   0340  idle
0074               
0075               
0076               ***************************************************************
0077               * f18rst - Reset f18a into standard settings
0078               ***************************************************************
0079               *  bl   @f18rst
0080               *--------------------------------------------------------------
0081               *  REMARKS
0082               *  This is used to leave the F18A mode and revert all settings
0083               *  that could lead to corruption when doing BLWP @0
0084               *
0085               *  There are some F18a settings that stay on when doing blwp @0
0086               *  and the TI title screen cannot recover from that.
0087               *
0088               *  It is your responsibility to set video mode tables should
0089               *  you want to continue instead of doing blwp @0 after your
0090               *  program cleanup
0091               ********|*****|*********************|**************************
0092 2748 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 274A 06A0  32         bl    @putvr
     274C 232C 
0097 274E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2750 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2752 232C 
0100 2754 391C             data  >391c                 ; Lock the F18a
0101 2756 0458  20         b     *tmp4                 ; Exit
0102               
0103               
0104               
0105               ***************************************************************
0106               * f18fwv - Get F18A Firmware Version
0107               ***************************************************************
0108               *  bl   @f18fwv
0109               *--------------------------------------------------------------
0110               *  REMARKS
0111               *  Successfully tested with F18A v1.8, note that this does not
0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
0113               *  firmware to begin with.
0114               *--------------------------------------------------------------
0115               *  TMP0 High nibble = major version
0116               *  TMP0 Low nibble  = minor version
0117               *
0118               *  Example: >0018     F18a Firmware v1.8
0119               ********|*****|*********************|**************************
0120 2758 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 275A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     275C 2028 
0122 275E 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2760 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2762 8802 
0127 2764 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2766 232C 
0128 2768 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 276A 04C4  14         clr   tmp0
0130 276C D120  34         movb  @vdps,tmp0
     276E 8802 
0131 2770 0984  56         srl   tmp0,8
0132 2772 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0143               
0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
**** **** ****     > vdp_hchar.asm
0001               * FILE......: vdp_hchar.a99
0002               * Purpose...: VDP hchar module
0003               
0004               ***************************************************************
0005               * Repeat characters horizontally at YX
0006               ***************************************************************
0007               *  BL    @HCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 2774 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2776 832A 
0018 2778 D17B  28         movb  *r11+,tmp1
0019 277A 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 277C D1BB  28         movb  *r11+,tmp2
0021 277E 0986  56         srl   tmp2,8                ; Repeat count
0022 2780 C1CB  18         mov   r11,tmp3
0023 2782 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2784 23F4 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2786 020B  20         li    r11,hchar1
     2788 278E 
0028 278A 0460  28         b     @xfilv                ; Draw
     278C 228E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 278E 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     2790 202C 
0033 2792 1302  14         jeq   hchar2                ; Yes, exit
0034 2794 C2C7  18         mov   tmp3,r11
0035 2796 10EE  14         jmp   hchar                 ; Next one
0036 2798 05C7  14 hchar2  inct  tmp3
0037 279A 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0147               
0151               
0155               
0159               
0163               
0167               
0171               
0175               
0177                       copy  "keyb_real.asm"            ; Real Keyboard support
**** **** ****     > keyb_real.asm
0001               * FILE......: keyb_real.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * REALKB - Scan keyboard in real mode
0010               ***************************************************************
0011               *  BL @REALKB
0012               *--------------------------------------------------------------
0013               *  Based on work done by Simon Koppelmann
0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
0015               ********|*****|*********************|**************************
0016 279C 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     279E 202A 
0017 27A0 020C  20         li    r12,>0024
     27A2 0024 
0018 27A4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27A6 2834 
0019 27A8 04C6  14         clr   tmp2
0020 27AA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27AC 04CC  14         clr   r12
0025 27AE 1F08  20         tb    >0008                 ; Shift-key ?
0026 27B0 1302  14         jeq   realk1                ; No
0027 27B2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27B4 2864 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27B6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27B8 1302  14         jeq   realk2                ; No
0033 27BA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27BC 2894 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27BE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27C0 1302  14         jeq   realk3                ; No
0039 27C2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27C4 28C4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27C6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27C8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27CA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27CC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27CE 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27D0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27D2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27D4 0006 
0052 27D6 0606  14 realk5  dec   tmp2
0053 27D8 020C  20         li    r12,>24               ; CRU address for P2-P4
     27DA 0024 
0054 27DC 06C6  14         swpb  tmp2
0055 27DE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27E0 06C6  14         swpb  tmp2
0057 27E2 020C  20         li    r12,6                 ; CRU read address
     27E4 0006 
0058 27E6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 27E8 0547  14         inv   tmp3                  ;
0060 27EA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     27EC FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 27EE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 27F0 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 27F2 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 27F4 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 27F6 0285  22         ci    tmp1,8
     27F8 0008 
0069 27FA 1AFA  14         jl    realk6
0070 27FC C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 27FE 1BEB  14         jh    realk5                ; No, next column
0072 2800 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2802 C206  18 realk8  mov   tmp2,tmp4
0077 2804 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2806 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2808 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 280A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 280C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 280E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 2810 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2812 202A 
0087 2814 1608  14         jne   realka                ; No, continue saving key
0088 2816 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2818 285E 
0089 281A 1A05  14         jl    realka
0090 281C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     281E 285C 
0091 2820 1B02  14         jh    realka                ; No, continue
0092 2822 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2824 E000 
0093 2826 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2828 833C 
0094 282A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     282C 2014 
0095 282E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     2830 8C00 
0096 2832 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2834 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2836 0000 
     2838 FF0D 
     283A 203D 
0099 283C ....             text  'xws29ol.'
0100 2844 ....             text  'ced38ik,'
0101 284C ....             text  'vrf47ujm'
0102 2854 ....             text  'btg56yhn'
0103 285C ....             text  'zqa10p;/'
0104 2864 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2866 0000 
     2868 FF0D 
     286A 202B 
0105 286C ....             text  'XWS@(OL>'
0106 2874 ....             text  'CED#*IK<'
0107 287C ....             text  'VRF$&UJM'
0108 2884 ....             text  'BTG%^YHN'
0109 288C ....             text  'ZQA!)P:-'
0110 2894 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     2896 0000 
     2898 FF0D 
     289A 2005 
0111 289C 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     289E 0804 
     28A0 0F27 
     28A2 C2B9 
0112 28A4 600B             data  >600b,>0907,>063f,>c1B8
     28A6 0907 
     28A8 063F 
     28AA C1B8 
0113 28AC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28AE 7B02 
     28B0 015F 
     28B2 C0C3 
0114 28B4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28B6 7D0E 
     28B8 0CC6 
     28BA BFC4 
0115 28BC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28BE 7C03 
     28C0 BC22 
     28C2 BDBA 
0116 28C4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28C6 0000 
     28C8 FF0D 
     28CA 209D 
0117 28CC 9897             data  >9897,>93b2,>9f8f,>8c9B
     28CE 93B2 
     28D0 9F8F 
     28D2 8C9B 
0118 28D4 8385             data  >8385,>84b3,>9e89,>8b80
     28D6 84B3 
     28D8 9E89 
     28DA 8B80 
0119 28DC 9692             data  >9692,>86b4,>b795,>8a8D
     28DE 86B4 
     28E0 B795 
     28E2 8A8D 
0120 28E4 8294             data  >8294,>87b5,>b698,>888E
     28E6 87B5 
     28E8 B698 
     28EA 888E 
0121 28EC 9A91             data  >9a91,>81b1,>b090,>9cBB
     28EE 81B1 
     28F0 B090 
     28F2 9CBB 
**** **** ****     > runlib.asm
0179               
0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
0001               * FILE......: cpu_hexsupport.asm
0002               * Purpose...: CPU create, display hex numbers module
0003               
0004               ***************************************************************
0005               * mkhex - Convert hex word to string
0006               ***************************************************************
0007               *  bl   @mkhex
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = Pointer to 16 bit word
0011               *  P1 = Pointer to string buffer
0012               *  P2 = Offset for ASCII digit
0013               *       MSB determines offset for chars A-F
0014               *       LSB determines offset for chars 0-9
0015               *  (CONFIG#0 = 1) = Display number at cursor YX
0016               *--------------------------------------------------------------
0017               *  Memory usage:
0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
0019               *  waux1, waux2, waux3
0020               *--------------------------------------------------------------
0021               *  Memory variables waux1-waux3 are used as temporary variables
0022               ********|*****|*********************|**************************
0023 28F4 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 28F6 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     28F8 8340 
0025 28FA 04E0  34         clr   @waux1
     28FC 833C 
0026 28FE 04E0  34         clr   @waux2
     2900 833E 
0027 2902 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2904 833C 
0028 2906 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2908 0205  20         li    tmp1,4                ; 4 nibbles
     290A 0004 
0033 290C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 290E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2910 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2912 0286  22         ci    tmp2,>000a
     2914 000A 
0039 2916 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2918 C21B  26         mov   *r11,tmp4
0045 291A 0988  56         srl   tmp4,8                ; Right justify
0046 291C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     291E FFF6 
0047 2920 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2922 C21B  26         mov   *r11,tmp4
0054 2924 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2926 00FF 
0055               
0056 2928 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 292A 06C6  14         swpb  tmp2
0058 292C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 292E 0944  56         srl   tmp0,4                ; Next nibble
0060 2930 0605  14         dec   tmp1
0061 2932 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2934 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2936 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2938 C160  34         mov   @waux3,tmp1           ; Get pointer
     293A 8340 
0067 293C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 293E 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2940 C120  34         mov   @waux2,tmp0
     2942 833E 
0070 2944 06C4  14         swpb  tmp0
0071 2946 DD44  32         movb  tmp0,*tmp1+
0072 2948 06C4  14         swpb  tmp0
0073 294A DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 294C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     294E 8340 
0078 2950 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2952 2020 
0079 2954 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2956 C120  34         mov   @waux1,tmp0
     2958 833C 
0084 295A 06C4  14         swpb  tmp0
0085 295C DD44  32         movb  tmp0,*tmp1+
0086 295E 06C4  14         swpb  tmp0
0087 2960 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2962 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2964 202A 
0092 2966 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2968 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 296A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     296C 7FFF 
0098 296E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2970 8340 
0099 2972 0460  28         b     @xutst0               ; Display string
     2974 241A 
0100 2976 0610     prefix  data  >0610                 ; Length byte + blank
0101               
0102               
0103               
0104               ***************************************************************
0105               * puthex - Put 16 bit word on screen
0106               ***************************************************************
0107               *  bl   @mkhex
0108               *       data P0,P1,P2,P3
0109               *--------------------------------------------------------------
0110               *  P0 = YX position
0111               *  P1 = Pointer to 16 bit word
0112               *  P2 = Pointer to string buffer
0113               *  P3 = Offset for ASCII digit
0114               *       MSB determines offset for chars A-F
0115               *       LSB determines offset for chars 0-9
0116               *--------------------------------------------------------------
0117               *  Memory usage:
0118               *  tmp0, tmp1, tmp2, tmp3
0119               *  waux1, waux2, waux3
0120               ********|*****|*********************|**************************
0121 2978 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     297A 832A 
0122 297C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     297E 8000 
0123 2980 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0183               
0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
**** **** ****     > cpu_numsupport.asm
0001               * FILE......: cpu_numsupport.asm
0002               * Purpose...: CPU create, display numbers module
0003               
0004               ***************************************************************
0005               * MKNUM - Convert unsigned number to string
0006               ***************************************************************
0007               *  BL   @MKNUM
0008               *  DATA P0,P1,P2
0009               *
0010               *  P0   = Pointer to 16 bit unsigned number
0011               *  P1   = Pointer to 5 byte string buffer
0012               *  P2HB = Offset for ASCII digit
0013               *  P2LB = Character for replacing leading 0's
0014               *
0015               *  (CONFIG:0 = 1) = Display number at cursor YX
0016               *-------------------------------------------------------------
0017               *  Destroys registers tmp0-tmp4
0018               ********|*****|*********************|**************************
0019 2982 0207  20 mknum   li    tmp3,5                ; Digit counter
     2984 0005 
0020 2986 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2988 C155  26         mov   *tmp1,tmp1            ; /
0022 298A C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 298C 0228  22         ai    tmp4,4                ; Get end of buffer
     298E 0004 
0024 2990 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2992 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2994 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2996 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2998 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 299A B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 299C D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 299E C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29A0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29A2 0607  14         dec   tmp3                  ; Decrease counter
0036 29A4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29A6 0207  20         li    tmp3,4                ; Check first 4 digits
     29A8 0004 
0041 29AA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29AC C11B  26         mov   *r11,tmp0
0043 29AE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29B0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29B2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29B4 05CB  14 mknum3  inct  r11
0047 29B6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29B8 202A 
0048 29BA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29BC 045B  20         b     *r11                  ; Exit
0050 29BE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29C0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29C2 13F8  14         jeq   mknum3                ; Yes, exit
0053 29C4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29C6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29C8 7FFF 
0058 29CA C10B  18         mov   r11,tmp0
0059 29CC 0224  22         ai    tmp0,-4
     29CE FFFC 
0060 29D0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29D2 0206  20         li    tmp2,>0500            ; String length = 5
     29D4 0500 
0062 29D6 0460  28         b     @xutstr               ; Display string
     29D8 241C 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1
0072               *--------------------------------------------------------------
0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
0074               *  p1   = Pointer to output variable
0075               *  p2   = Padding character to match against
0076               *--------------------------------------------------------------
0077               *  Copy unsigned number string into a length-padded, left
0078               *  justified string for display with putstr, putat, ...
0079               *
0080               *  The new string starts at index 5 in buffer, overwriting
0081               *  anything that is located there !
0082               *
0083               *  Before...:   XXXXX
0084               *  After....:   XXXXX|zY       where length byte z=1
0085               *               XXXXX|zYY      where length byte z=2
0086               *                 ..
0087               *               XXXXX|zYYYYY   where length byte z=5
0088               *--------------------------------------------------------------
0089               *  Destroys registers tmp0-tmp3
0090               ********|*****|*********************|**************************
0091               trimnum:
0092 29DA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29DC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29DE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29E0 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 29E2 0207  20         li    tmp3,5                ; Set counter
     29E4 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 29E6 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 29E8 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 29EA 0584  14         inc   tmp0                  ; Next character
0104 29EC 0607  14         dec   tmp3                  ; Last digit reached ?
0105 29EE 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 29F0 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 29F2 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 29F4 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 29F6 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 29F8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 29FA 0607  14         dec   tmp3                  ; Last character ?
0120 29FC 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 29FE 045B  20         b     *r11                  ; Return
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * PUTNUM - Put unsigned number on screen
0128               ***************************************************************
0129               *  BL   @PUTNUM
0130               *  DATA P0,P1,P2,P3
0131               *--------------------------------------------------------------
0132               *  P0   = YX position
0133               *  P1   = Pointer to 16 bit unsigned number
0134               *  P2   = Pointer to 5 byte string buffer
0135               *  P3HB = Offset for ASCII digit
0136               *  P3LB = Character for replacing leading 0's
0137               ********|*****|*********************|**************************
0138 2A00 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A02 832A 
0139 2A04 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A06 8000 
0140 2A08 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0187               
0191               
0195               
0199               
0203               
0205                       copy  "cpu_strings.asm"          ; String utilities support
**** **** ****     > cpu_strings.asm
0001               * FILE......: cpu_strings.asm
0002               * Purpose...: CPU string manipulation library
0003               
0004               
0005               ***************************************************************
0006               * string.ltrim - Left justify string
0007               ***************************************************************
0008               *  bl   @string.ltrim
0009               *       data p0,p1,p2
0010               *--------------------------------------------------------------
0011               *  P0 = Pointer to length-prefix string
0012               *  P1 = Pointer to RAM work buffer
0013               *  P2 = Fill character
0014               *--------------------------------------------------------------
0015               *  BL   @xstring.ltrim
0016               *
0017               *  TMP0 = Pointer to length-prefix string
0018               *  TMP1 = Pointer to RAM work buffer
0019               *  TMP2 = Fill character
0020               ********|*****|*********************|**************************
0021               string.ltrim:
0022 2A0A 0649  14         dect  stack
0023 2A0C C64B  30         mov   r11,*stack            ; Save return address
0024 2A0E 0649  14         dect  stack
0025 2A10 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A12 0649  14         dect  stack
0027 2A14 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A16 0649  14         dect  stack
0029 2A18 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A1A 0649  14         dect  stack
0031 2A1C C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A1E C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A20 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A22 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A24 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A26 0649  14         dect  stack
0044 2A28 C64B  30         mov   r11,*stack            ; Save return address
0045 2A2A 0649  14         dect  stack
0046 2A2C C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A2E 0649  14         dect  stack
0048 2A30 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A32 0649  14         dect  stack
0050 2A34 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A36 0649  14         dect  stack
0052 2A38 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A3A C1D4  26 !       mov   *tmp0,tmp3
0057 2A3C 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A3E 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A40 00FF 
0059 2A42 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A44 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A46 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A48 0584  14         inc   tmp0                  ; Next byte
0067 2A4A 0607  14         dec   tmp3                  ; Shorten string length
0068 2A4C 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A4E 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A50 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A52 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A54 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A56 C187  18         mov   tmp3,tmp2
0078 2A58 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A5A DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A5C 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A5E 2492 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A60 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A62 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A64 FFCE 
0090 2A66 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A68 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A6A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A6C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A6E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A70 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A72 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A74 045B  20         b     *r11                  ; Return to caller
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * string.getlenc - Get length of C-style string
0107               ***************************************************************
0108               *  bl   @string.getlenc
0109               *       data p0,p1
0110               *--------------------------------------------------------------
0111               *  P0 = Pointer to C-style string
0112               *  P1 = String termination character
0113               *--------------------------------------------------------------
0114               *  bl   @xstring.getlenc
0115               *
0116               *  TMP0 = Pointer to C-style string
0117               *  TMP1 = Termination character
0118               *--------------------------------------------------------------
0119               *  OUTPUT:
0120               *  @waux1 = Length of string
0121               ********|*****|*********************|**************************
0122               string.getlenc:
0123 2A76 0649  14         dect  stack
0124 2A78 C64B  30         mov   r11,*stack            ; Save return address
0125 2A7A 0649  14         dect  stack
0126 2A7C C644  30         mov   tmp0,*stack           ; Push tmp0
0127 2A7E 0649  14         dect  stack
0128 2A80 C645  30         mov   tmp1,*stack           ; Push tmp1
0129 2A82 0649  14         dect  stack
0130 2A84 C646  30         mov   tmp2,*stack           ; Push tmp2
0131                       ;-----------------------------------------------------------------------
0132                       ; Get parameter values
0133                       ;-----------------------------------------------------------------------
0134 2A86 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0135 2A88 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0136 2A8A 1006  14         jmp   !
0137                       ;-----------------------------------------------------------------------
0138                       ; Register version
0139                       ;-----------------------------------------------------------------------
0140               xstring.getlenc:
0141 2A8C 0649  14         dect  stack
0142 2A8E C64B  30         mov   r11,*stack            ; Save return address
0143 2A90 0649  14         dect  stack
0144 2A92 C644  30         mov   tmp0,*stack           ; Push tmp0
0145 2A94 0649  14         dect  stack
0146 2A96 C645  30         mov   tmp1,*stack           ; Push tmp1
0147                       ;-----------------------------------------------------------------------
0148                       ; Start
0149                       ;-----------------------------------------------------------------------
0150 2A98 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0151 2A9A 04C6  14         clr   tmp2                  ; Loop counter
0152                       ;-----------------------------------------------------------------------
0153                       ; Scan string for termination character
0154                       ;-----------------------------------------------------------------------
0155               string.getlenc.loop:
0156 2A9C 0586  14         inc   tmp2
0157 2A9E 9174  28         cb    *tmp0+,tmp1           ; Compare character
0158 2AA0 1304  14         jeq   string.getlenc.putlength
0159                       ;-----------------------------------------------------------------------
0160                       ; Sanity check on string length
0161                       ;-----------------------------------------------------------------------
0162 2AA2 0286  22         ci    tmp2,255
     2AA4 00FF 
0163 2AA6 1505  14         jgt   string.getlenc.panic
0164 2AA8 10F9  14         jmp   string.getlenc.loop
0165                       ;-----------------------------------------------------------------------
0166                       ; Return length
0167                       ;-----------------------------------------------------------------------
0168               string.getlenc.putlength:
0169 2AAA 0606  14         dec   tmp2                  ; One time adjustment
0170 2AAC C806  38         mov   tmp2,@waux1           ; Store length
     2AAE 833C 
0171 2AB0 1004  14         jmp   string.getlenc.exit   ; Exit
0172                       ;-----------------------------------------------------------------------
0173                       ; CPU crash
0174                       ;-----------------------------------------------------------------------
0175               string.getlenc.panic:
0176 2AB2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AB4 FFCE 
0177 2AB6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AB8 2030 
0178                       ;----------------------------------------------------------------------
0179                       ; Exit
0180                       ;----------------------------------------------------------------------
0181               string.getlenc.exit:
0182 2ABA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0183 2ABC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0184 2ABE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0185 2AC0 C2F9  30         mov   *stack+,r11           ; Pop r11
0186 2AC2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0213                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cpu.scrpad.backup - Backup scratchpad memory to cpu.scrpad.tgt
0010               ***************************************************************
0011               *  bl   @cpu.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  r0-r2, but values restored before exit
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to destination range
0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0018               *
0019               *  Expects current workspace to be in scratchpad memory.
0020               ********|*****|*********************|**************************
0021               cpu.scrpad.backup:
0022 2AC4 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2AC6 3E00 
0023 2AC8 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2ACA 3E02 
0024 2ACC C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2ACE 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2AD0 0200  20         li    r0,>8306              ; Scratpad source address
     2AD2 8306 
0029 2AD4 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2AD6 3E06 
0030 2AD8 0202  20         li    r2,62                 ; Loop counter
     2ADA 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2ADC CC70  46         mov   *r0+,*r1+
0036 2ADE CC70  46         mov   *r0+,*r1+
0037 2AE0 0642  14         dect  r2
0038 2AE2 16FC  14         jne   cpu.scrpad.backup.copy
0039 2AE4 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2AE6 83FE 
     2AE8 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2AEA C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2AEC 3E00 
0045 2AEE C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2AF0 3E02 
0046 2AF2 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2AF4 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2AF6 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               ***************************************************************
0055               * cpu.scrpad.restore - Restore scratchpad memory from cpu.scrpad.tgt
0056               ***************************************************************
0057               *  bl   @cpu.scrpad.restore
0058               *--------------------------------------------------------------
0059               *  Register usage
0060               *  r0-r2, but values restored before exit
0061               *--------------------------------------------------------------
0062               *  Restore scratchpad from memory area
0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0064               *  Current workspace can be outside scratchpad when called.
0065               ********|*****|*********************|**************************
0066               cpu.scrpad.restore:
0067                       ;------------------------------------------------------
0068                       ; Restore scratchpad >8300 - >8304
0069                       ;------------------------------------------------------
0070 2AF8 C820  54         mov   @cpu.scrpad.tgt,@>8300
     2AFA 3E00 
     2AFC 8300 
0071 2AFE C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2B00 3E02 
     2B02 8302 
0072 2B04 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2B06 3E04 
     2B08 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2B0A C800  38         mov   r0,@cpu.scrpad.tgt
     2B0C 3E00 
0077 2B0E C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2B10 3E02 
0078 2B12 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2B14 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2B16 0200  20         li    r0,cpu.scrpad.tgt + 6
     2B18 3E06 
0083 2B1A 0201  20         li    r1,>8306
     2B1C 8306 
0084 2B1E 0202  20         li    r2,62
     2B20 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2B22 CC70  46         mov   *r0+,*r1+
0090 2B24 CC70  46         mov   *r0+,*r1+
0091 2B26 0642  14         dect  r2
0092 2B28 16FC  14         jne   cpu.scrpad.restore.copy
0093 2B2A C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2B2C 3EFE 
     2B2E 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2B30 C020  34         mov   @cpu.scrpad.tgt,r0
     2B32 3E00 
0099 2B34 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2B36 3E02 
0100 2B38 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2B3A 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2B3C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0214                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > cpu_scrpad_paging.asm
0001               * FILE......: cpu_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cpu.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.pgout
0013               *       DATA p0
0014               *
0015               *  P0 = CPU memory destination
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu.scrpad.pgout
0018               *  TMP1 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  Register usage
0021               *  tmp0-tmp2 = Used as temporary registers
0022               *  tmp3      = Copy of CPU memory destination
0023               ********|*****|*********************|**************************
0024               cpu.scrpad.pgout:
0025 2B3E C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2B40 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2B42 8300 
0031 2B44 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2B46 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2B48 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2B4A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2B4C 0606  14         dec   tmp2
0038 2B4E 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2B50 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2B52 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2B54 2B5A 
0044                                                   ; R14=PC
0045 2B56 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2B58 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2B5A 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2B5C 2AF8 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2B5E 045B  20         b     *r11                  ; Return to caller
0062               
0063               
0064               ***************************************************************
0065               * cpu.scrpad.pgin - Page in scratchpad memory
0066               ***************************************************************
0067               *  bl   @cpu.scrpad.pgin
0068               *  DATA p0
0069               *  P0 = CPU memory source
0070               *--------------------------------------------------------------
0071               *  bl   @memx.scrpad.pgin
0072               *  TMP1 = CPU memory source
0073               *--------------------------------------------------------------
0074               *  Register usage
0075               *  tmp0-tmp2 = Used as temporary registers
0076               ********|*****|*********************|**************************
0077               cpu.scrpad.pgin:
0078 2B60 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2B62 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2B64 8300 
0084 2B66 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2B68 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2B6A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2B6C 0606  14         dec   tmp2
0090 2B6E 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2B70 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2B72 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2B74 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0216               
0218                       copy  "equ_fio.asm"              ; File I/O equates
**** **** ****     > equ_fio.asm
0001               * FILE......: equ_fio.asm
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations
0006               ************************************@**************************
0007      0000     io.op.open       equ >00            ; OPEN
0008      0001     io.op.close      equ >01            ; CLOSE
0009      0002     io.op.read       equ >02            ; READ
0010      0003     io.op.write      equ >03            ; WRITE
0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
0012      0005     io.op.load       equ >05            ; LOAD
0013      0006     io.op.save       equ >06            ; SAVE
0014      0007     io.op.delfile    equ >07            ; DELETE FILE
0015      0008     io.op.scratch    equ >08            ; SCRATCH
0016      0009     io.op.status     equ >09            ; STATUS
0017               ***************************************************************
0018               * File types - All relative files are fixed length
0019               ************************************@**************************
0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0026               ***************************************************************
0027               * File types - Sequential files
0028               ************************************@**************************
0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0041               
0042               ***************************************************************
0043               * File error codes - Bits 13-15 in PAB byte 1
0044               ************************************@**************************
0045      0000     io.err.no_error_occured             equ 0
0046                       ; Error code 0 with condition bit reset, indicates that
0047                       ; no error has occured
0048               
0049      0000     io.err.bad_device_name              equ 0
0050                       ; Device indicated not in system
0051                       ; Error code 0 with condition bit set, indicates a
0052                       ; device not present in system
0053               
0054      0001     io.err.device_write_prottected      equ 1
0055                       ; Device is write protected
0056               
0057      0002     io.err.bad_open_attribute           equ 2
0058                       ; One or more of the OPEN attributes are illegal or do
0059                       ; not match the file's actual characteristics.
0060                       ; This could be:
0061                       ;   * File type
0062                       ;   * Record length
0063                       ;   * I/O mode
0064                       ;   * File organization
0065               
0066      0003     io.err.illegal_operation            equ 3
0067                       ; Either an issued I/O command was not supported, or a
0068                       ; conflict with the OPEN mode has occured
0069               
0070      0004     io.err.out_of_table_buffer_space    equ 4
0071                       ; The amount of space left on the device is insufficient
0072                       ; for the requested operation
0073               
0074      0005     io.err.eof                          equ 5
0075                       ; Attempt to read past end of file.
0076                       ; This error may also be given for non-existing records
0077                       ; in a relative record file
0078               
0079      0006     io.err.device_error                 equ 6
0080                       ; Covers all hard device errors, such as parity and
0081                       ; bad medium errors
0082               
0083      0007     io.err.file_error                   equ 7
0084                       ; Covers all file-related error like: program/data
0085                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
**** **** ****     > fio_dsrlnk.asm
0001               * FILE......: fio_dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  P0 = 8 or 10 (a)
0016               *--------------------------------------------------------------
0017               *  Output:
0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0019               *--------------------------------------------------------------
0020               ; Spectra2 scratchpad memory needs to be paged out before.
0021               ; You need to specify following equates in main program
0022               ;
0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0025               ;
0026               ; Scratchpad memory usage
0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
0028               ; >8356            Pointer to PAB
0029               ; >83D0            CRU address of current device
0030               ; >83D2            DSR entry address
0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
0032               ;
0033               ; Credits
0034               ; Originally appeared in Miller Graphics The Smart Programmer.
0035               ; This version based on version of Paolo Bagnaresi.
0036               *--------------------------------------------------------------
0037      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********|*****|*********************|**************************
0041 2B76 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2B78 2B7A             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2B7A C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2B7C C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2B7E 8322 
0049 2B80 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2B82 2026 
0050 2B84 C020  34         mov   @>8356,r0             ; get ptr to pab
     2B86 8356 
0051 2B88 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2B8A 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2B8C FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2B8E 06C0  14         swpb  r0                    ;
0059 2B90 D800  38         movb  r0,@vdpa              ; send low byte
     2B92 8C02 
0060 2B94 06C0  14         swpb  r0                    ;
0061 2B96 D800  38         movb  r0,@vdpa              ; send high byte
     2B98 8C02 
0062 2B9A D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2B9C 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B9E 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2BA0 0704  14         seto  r4                    ; init counter
0070 2BA2 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2BA4 A420 
0071 2BA6 0580  14 !       inc   r0                    ; point to next char of name
0072 2BA8 0584  14         inc   r4                    ; incr char counter
0073 2BAA 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2BAC 0007 
0074 2BAE 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2BB0 80C4  18         c     r4,r3                 ; end of name?
0077 2BB2 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2BB4 06C0  14         swpb  r0                    ;
0082 2BB6 D800  38         movb  r0,@vdpa              ; send low byte
     2BB8 8C02 
0083 2BBA 06C0  14         swpb  r0                    ;
0084 2BBC D800  38         movb  r0,@vdpa              ; send high byte
     2BBE 8C02 
0085 2BC0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BC2 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2BC4 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2BC6 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2BC8 2C8A 
0093 2BCA 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2BCC C104  18         mov   r4,r4                 ; Check if length = 0
0099 2BCE 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2BD0 04E0  34         clr   @>83d0
     2BD2 83D0 
0102 2BD4 C804  38         mov   r4,@>8354             ; save name length for search
     2BD6 8354 
0103 2BD8 0584  14         inc   r4                    ; adjust for dot
0104 2BDA A804  38         a     r4,@>8356             ; point to position after name
     2BDC 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2BDE 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2BE0 83E0 
0110 2BE2 04C1  14         clr   r1                    ; version found of dsr
0111 2BE4 020C  20         li    r12,>0f00             ; init cru addr
     2BE6 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2BE8 C30C  18         mov   r12,r12               ; anything to turn off?
0117 2BEA 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2BEC 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2BEE 022C  22         ai    r12,>0100             ; next rom to turn on
     2BF0 0100 
0125 2BF2 04E0  34         clr   @>83d0                ; clear in case we are done
     2BF4 83D0 
0126 2BF6 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2BF8 2000 
0127 2BFA 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2BFC C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2BFE 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2C00 1D00  20         sbo   0                     ; turn on rom
0134 2C02 0202  20         li    r2,>4000              ; start at beginning of rom
     2C04 4000 
0135 2C06 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2C08 2C86 
0136 2C0A 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2C0C A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2C0E A40A 
0146 2C10 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2C12 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2C14 83D2 
0152                                                   ; subprogram
0153               
0154 2C16 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2C18 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2C1A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2C1C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2C1E 83D2 
0163                                                   ; subprogram
0164               
0165 2C20 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2C22 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2C24 04C5  14         clr   r5                    ; Remove any old stuff
0174 2C26 D160  34         movb  @>8355,r5             ; get length as counter
     2C28 8355 
0175 2C2A 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2C2C 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2C2E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2C30 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2C32 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2C34 A420 
0186 2C36 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2C38 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2C3A 0605  14         dec   r5                    ; loop until full length checked
0191 2C3C 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2C3E C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2C40 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2C42 0581  14         inc   r1                    ; next version found
0203 2C44 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2C46 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2C48 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2C4A 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C4C A400 
0212 2C4E C009  18         mov   r9,r0                 ; point to flag in pab
0213 2C50 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C52 8322 
0214                                                   ; (8 or >a)
0215 2C54 0281  22         ci    r1,8                  ; was it 8?
     2C56 0008 
0216 2C58 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2C5A D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C5C 8350 
0218                                                   ; Get error byte from @>8350
0219 2C5E 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2C60 06C0  14         swpb  r0                    ;
0227 2C62 D800  38         movb  r0,@vdpa              ; send low byte
     2C64 8C02 
0228 2C66 06C0  14         swpb  r0                    ;
0229 2C68 D800  38         movb  r0,@vdpa              ; send high byte
     2C6A 8C02 
0230 2C6C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C6E 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2C70 09D1  56         srl   r1,13                 ; just keep error bits
0238 2C72 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2C74 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2C76 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C78 A400 
0248               dsrlnk.error.devicename_invalid:
0249 2C7A 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2C7C 06C1  14         swpb  r1                    ; put error in hi byte
0252 2C7E D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2C80 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2C82 2026 
0254 2C84 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2C86 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2C88 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2C8A ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
**** **** ****     > runlib.asm
0220                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0011               ;                                   ;         Bit 13-15 used by DSR for returning
0012               ;                                   ;         file error details to DSRLNK
0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
0015               ;       byte  0                     ;  5    - Character count (bytes read)
0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
0018               ; -------------------------------------------------------------
0019               ;       byte  11                    ;  9    - File descriptor length
0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
0021               ;       even
0022               ***************************************************************
0023               
0024               
0025               ***************************************************************
0026               * file.open - Open File for procesing
0027               ***************************************************************
0028               *  bl   @file.open
0029               *  data P0
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *--------------------------------------------------------------
0033               *  bl   @xfile.open
0034               *
0035               *  R0 = Address of PAB in VDP RAM
0036               *--------------------------------------------------------------
0037               *  Output:
0038               *  tmp0 LSB = VDP PAB byte 1 (status)
0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0040               *  tmp2     = Status register contents upon DSRLNK return
0041               ********|*****|*********************|**************************
0042               file.open:
0043 2C8C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2C8E C04B  18         mov   r11,r1                ; Save return address
0049 2C90 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C92 A428 
0050 2C94 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2C96 04C5  14         clr   tmp1                  ; io.op.open
0052 2C98 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C9A 22C6 
0053               file.open_init:
0054 2C9C 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C9E 0009 
0055 2CA0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CA2 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2CA4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CA6 2B76 
0061 2CA8 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2CAA 1029  14         jmp   file.record.pab.details
0067                                                   ; Get status and return to caller
0068                                                   ; Status register bits are unaffected
0069               
0070               
0071               
0072               ***************************************************************
0073               * file.close - Close currently open file
0074               ***************************************************************
0075               *  bl   @file.close
0076               *  data P0
0077               *--------------------------------------------------------------
0078               *  P0 = Address of PAB in VDP RAM
0079               *--------------------------------------------------------------
0080               *  bl   @xfile.close
0081               *
0082               *  R0 = Address of PAB in VDP RAM
0083               *--------------------------------------------------------------
0084               *  Output:
0085               *  tmp0 LSB = VDP PAB byte 1 (status)
0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0087               *  tmp2     = Status register contents upon DSRLNK return
0088               ********|*****|*********************|**************************
0089               file.close:
0090 2CAC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2CAE C04B  18         mov   r11,r1                ; Save return address
0096 2CB0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2CB2 A428 
0097 2CB4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2CB6 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CB8 0001 
0099 2CBA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CBC 22C6 
0100               file.close_init:
0101 2CBE 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CC0 0009 
0102 2CC2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CC4 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2CC6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CC8 2B76 
0108 2CCA 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2CCC 1018  14         jmp   file.record.pab.details
0114                                                   ; Get status and return to caller
0115                                                   ; Status register bits are unaffected
0116               
0117               
0118               
0119               
0120               
0121               ***************************************************************
0122               * file.record.read - Read record from file
0123               ***************************************************************
0124               *  bl   @file.record.read
0125               *  data P0
0126               *--------------------------------------------------------------
0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0128               *--------------------------------------------------------------
0129               *  bl   @xfile.record.read
0130               *
0131               *  R0 = Address of PAB in VDP RAM
0132               *--------------------------------------------------------------
0133               *  Output:
0134               *  tmp0 LSB = VDP PAB byte 1 (status)
0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0136               *  tmp2     = Status register contents upon DSRLNK return
0137               ********|*****|*********************|**************************
0138               file.record.read:
0139 2CCE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2CD0 C04B  18         mov   r11,r1                ; Save return address
0145 2CD2 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2CD4 A428 
0146 2CD6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2CD8 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CDA 0002 
0148 2CDC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CDE 22C6 
0149               file.record.read_init:
0150 2CE0 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CE2 0009 
0151 2CE4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CE6 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2CE8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CEA 2B76 
0157 2CEC 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2CEE 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2CF0 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2CF2 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2CF4 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2CF6 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2CF8 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2CFA 1000  14         nop
0191               
0192               
0193               file.status:
0194 2CFC 1000  14         nop
0195               
0196               
0197               
0198               ***************************************************************
0199               * file.record.pab.details - Return PAB details to caller
0200               ***************************************************************
0201               * Called internally via JMP/B by file operations
0202               *--------------------------------------------------------------
0203               *  Output:
0204               *  tmp0 LSB = VDP PAB byte 1 (status)
0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0206               *  tmp2     = Status register contents upon DSRLNK return
0207               ********|*****|*********************|**************************
0208               
0209               ********|*****|*********************|**************************
0210               file.record.pab.details:
0211 2CFE 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2D00 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2D02 A428 
0219 2D04 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D06 0005 
0220 2D08 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D0A 22DE 
0221 2D0C C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2D0E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0226                                                   ; as returned by DSRLNK
0227               *--------------------------------------------------------------
0228               * Exit
0229               *--------------------------------------------------------------
0230               ; If an error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=tmp2) is set to 1.
0232               ;
0233               ; Upon return from this IO call you should basically test with:
0234               ;       coc   @wbit2,tmp2           ; Equal bit set?
0235               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0236               ;
0237               ; Then look for further details in the copy of VDP PAB byte 1
0238               ; in register tmp0, bits 13-15
0239               ;
0240               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0241               ;                                   ; calls, skip for type >A subprograms!)
0242               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0243               ;       jeq   my_error_handler
0244               *--------------------------------------------------------------
0245               file.record.pab.details.exit:
0246 2D10 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0222               
0223               *//////////////////////////////////////////////////////////////
0224               *                            TIMERS
0225               *//////////////////////////////////////////////////////////////
0226               
0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
**** **** ****     > timers_tmgr.asm
0001               * FILE......: timers_tmgr.asm
0002               * Purpose...: Timers / Thread scheduler
0003               
0004               ***************************************************************
0005               * TMGR - X - Start Timers/Thread scheduler
0006               ***************************************************************
0007               *  B @TMGR
0008               *--------------------------------------------------------------
0009               *  REMARKS
0010               *  Timer/Thread scheduler. Normally called from MAIN.
0011               *  This is basically the kernel keeping everything togehter.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2D12 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D14 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D16 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D18 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D1A 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D1C 2026 
0029 2D1E 1602  14         jne   tmgr1a                ; No, so move on
0030 2D20 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D22 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D24 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D26 202A 
0035 2D28 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D2A 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D2C 201A 
0048 2D2E 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D30 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D32 2018 
0050 2D34 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D36 0460  28         b     @kthread              ; Run kernel thread
     2D38 2DB0 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D3A 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D3C 201E 
0056 2D3E 13EB  14         jeq   tmgr1
0057 2D40 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D42 201C 
0058 2D44 16E8  14         jne   tmgr1
0059 2D46 C120  34         mov   @wtiusr,tmp0
     2D48 832E 
0060 2D4A 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D4C 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D4E 2DAE 
0065 2D50 C10A  18         mov   r10,tmp0
0066 2D52 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D54 00FF 
0067 2D56 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D58 2026 
0068 2D5A 1303  14         jeq   tmgr5
0069 2D5C 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D5E 003C 
0070 2D60 1002  14         jmp   tmgr6
0071 2D62 0284  22 tmgr5   ci    tmp0,50
     2D64 0032 
0072 2D66 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D68 1001  14         jmp   tmgr8
0074 2D6A 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D6C C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D6E 832C 
0079 2D70 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D72 FF00 
0080 2D74 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D76 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D78 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D7A 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D7C C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D7E 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D80 830C 
     2D82 830D 
0089 2D84 1608  14         jne   tmgr10                ; No, get next slot
0090 2D86 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D88 FF00 
0091 2D8A C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D8C C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D8E 8330 
0096 2D90 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D92 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D94 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D96 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D98 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D9A 8315 
     2D9C 8314 
0103 2D9E 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA0 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DA2 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DA4 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DA6 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DA8 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DAA FF00 
0109 2DAC 10B4  14         jmp   tmgr1
0110 2DAE 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
**** **** ****     > timers_kthread.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / The kernel thread
0003               
0004               
0005               ***************************************************************
0006               * KTHREAD - The kernel thread
0007               *--------------------------------------------------------------
0008               *  REMARKS
0009               *  You should not call the kernel thread manually.
0010               *  Instead control it via the CONFIG register.
0011               *
0012               *  The kernel thread is responsible for running the sound
0013               *  player and doing keyboard scan.
0014               ********|*****|*********************|**************************
0015 2DB0 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DB2 201A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2DB4 06A0  32         bl    @realkb               ; Scan full keyboard
     2DB6 279C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DB8 0460  28         b     @tmgr3                ; Exit
     2DBA 2D3A 
**** **** ****     > runlib.asm
0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
**** **** ****     > timers_hooks.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / User hooks
0003               
0004               
0005               ***************************************************************
0006               * MKHOOK - Allocate user hook
0007               ***************************************************************
0008               *  BL    @MKHOOK
0009               *  DATA  P0
0010               *--------------------------------------------------------------
0011               *  P0 = Address of user hook
0012               *--------------------------------------------------------------
0013               *  REMARKS
0014               *  The user hook gets executed after the kernel thread.
0015               *  The user hook must always exit with "B @HOOKOK"
0016               ********|*****|*********************|**************************
0017 2DBC C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DBE 832E 
0018 2DC0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DC2 201C 
0019 2DC4 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D16     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DC6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DC8 832E 
0029 2DCA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DCC FEFF 
0030 2DCE 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0230               
0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
**** **** ****     > timers_alloc.asm
0001               * FILE......: timer_alloc.asm
0002               * Purpose...: Timers / Timer allocation
0003               
0004               
0005               ***************************************************************
0006               * MKSLOT - Allocate timer slot(s)
0007               ***************************************************************
0008               *  BL    @MKSLOT
0009               *  BYTE  P0HB,P0LB
0010               *  DATA  P1
0011               *  ....
0012               *  DATA  EOL                        ; End-of-list
0013               *--------------------------------------------------------------
0014               *  P0 = Slot number, target count
0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
0016               ********|*****|*********************|**************************
0017 2DD0 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DD2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DD4 C184  18         mov   tmp0,tmp2
0023 2DD6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DD8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DDA 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DDC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DDE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE0 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DE2 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DE4 202C 
0035 2DE6 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DE8 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DEA 05CB  14 mkslo1  inct  r11
0041 2DEC 045B  20         b     *r11                  ; Exit
0042               
0043               
0044               ***************************************************************
0045               * CLSLOT - Clear single timer slot
0046               ***************************************************************
0047               *  BL    @CLSLOT
0048               *  DATA  P0
0049               *--------------------------------------------------------------
0050               *  P0 = Slot number
0051               ********|*****|*********************|**************************
0052 2DEE C13B  30 clslot  mov   *r11+,tmp0
0053 2DF0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DF2 A120  34         a     @wtitab,tmp0          ; Add table base
     2DF4 832C 
0055 2DF6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DF8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DFA 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0234               
0235               
0236               
0237               *//////////////////////////////////////////////////////////////
0238               *                    RUNLIB INITIALISATION
0239               *//////////////////////////////////////////////////////////////
0240               
0241               ***************************************************************
0242               *  RUNLIB - Runtime library initalisation
0243               ***************************************************************
0244               *  B  @RUNLIB
0245               *--------------------------------------------------------------
0246               *  REMARKS
0247               *  if R0 in WS1 equals >4a4a we were called from the system
0248               *  crash handler so we return there after initialisation.
0249               
0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0251               *  after clearing scratchpad memory. This has higher priority
0252               *  as crash handler flag R0.
0253               ********|*****|*********************|**************************
0255 2DFC 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2DFE 2AC4 
0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
0257               
0258 2E00 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E02 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E04 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E06 0000 
0266 2E08 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E0A 8300 
0267 2E0C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E0E 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E10 0202  20 runli2  li    r2,>8308
     2E12 8308 
0272 2E14 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E16 0282  22         ci    r2,>8400
     2E18 8400 
0274 2E1A 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E1C 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E1E FFFF 
0279 2E20 1602  14         jne   runli4                ; No, continue
0280 2E22 0420  54         blwp  @0                    ; Yes, bye bye
     2E24 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E26 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E28 833C 
0285 2E2A 04C1  14         clr   r1                    ; Reset counter
0286 2E2C 0202  20         li    r2,10                 ; We test 10 times
     2E2E 000A 
0287 2E30 C0E0  34 runli5  mov   @vdps,r3
     2E32 8802 
0288 2E34 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E36 202A 
0289 2E38 1302  14         jeq   runli6
0290 2E3A 0581  14         inc   r1                    ; Increase counter
0291 2E3C 10F9  14         jmp   runli5
0292 2E3E 0602  14 runli6  dec   r2                    ; Next test
0293 2E40 16F7  14         jne   runli5
0294 2E42 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E44 1250 
0295 2E46 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E48 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E4A 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E4C 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2E4E 221A 
0301 2E50 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2E52 8322 
0302 2E54 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0303 2E56 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0304 2E58 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0305               *--------------------------------------------------------------
0306               * Initialize registers, memory, ...
0307               *--------------------------------------------------------------
0308 2E5A 04C1  14 runli9  clr   r1
0309 2E5C 04C2  14         clr   r2
0310 2E5E 04C3  14         clr   r3
0311 2E60 0209  20         li    stack,>8400           ; Set stack
     2E62 8400 
0312 2E64 020F  20         li    r15,vdpw              ; Set VDP write address
     2E66 8C00 
0316               *--------------------------------------------------------------
0317               * Setup video memory
0318               *--------------------------------------------------------------
0320 2E68 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E6A 4A4A 
0321 2E6C 1605  14         jne   runlia
0322 2E6E 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E70 2288 
0323 2E72 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2E74 0000 
     2E76 3FFF 
0328 2E78 06A0  32 runlia  bl    @filv
     2E7A 2288 
0329 2E7C 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E7E 00F4 
     2E80 0010 
0330               *--------------------------------------------------------------
0331               * Check if there is a F18A present
0332               *--------------------------------------------------------------
0336 2E82 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E84 26E4 
0337 2E86 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E88 26FE 
0338 2E8A 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E8C 26F4 
0339               
0340 2E8E 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E90 232C 
0341 2E92 3201                   data >3201            ; F18a VR50 (>32), bit 1
0343               *--------------------------------------------------------------
0344               * Check if there is a speech synthesizer attached
0345               *--------------------------------------------------------------
0347               *       <<skipped>>
0351               *--------------------------------------------------------------
0352               * Load video mode table & font
0353               *--------------------------------------------------------------
0354 2E94 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E96 22F2 
0355 2E98 76DC             data  spvmod                ; Equate selected video mode table
0356 2E9A 0204  20         li    tmp0,spfont           ; Get font option
     2E9C 000C 
0357 2E9E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0358 2EA0 1304  14         jeq   runlid                ; Yes, skip it
0359 2EA2 06A0  32         bl    @ldfnt
     2EA4 235A 
0360 2EA6 1100             data  fntadr,spfont         ; Load specified font
     2EA8 000C 
0361               *--------------------------------------------------------------
0362               * Did a system crash occur before runlib was called?
0363               *--------------------------------------------------------------
0364 2EAA 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EAC 4A4A 
0365 2EAE 1602  14         jne   runlie                ; No, continue
0366 2EB0 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EB2 2090 
0367               *--------------------------------------------------------------
0368               * Branch to main program
0369               *--------------------------------------------------------------
0370 2EB4 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EB6 0040 
0371 2EB8 0460  28         b     @main                 ; Give control to main program
     2EBA 6050 
**** **** ****     > stevie_b1.asm.360191
0022                                                   ; Relocated spectra2 in low memory expansion
0023                                                   ; Is copied to RAM from bank 0.
0024                                                   ;
0025                                                   ; Including it here too, so that all
0026                                                   ; references get satisfied during assembly.
0027               ***************************************************************
0028               * stevie entry point after spectra2 initialisation
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code2
0031               main:
0032 6050 04E0  34         clr   @>6002                ; Jump to bank 1
     6052 6002 
0033 6054 0460  28         b     @main.stevie          ; Start editor
     6056 6058 
0034                       ;----------------------------------------------------------------------
0035                       ; Include files
0036                       ;-----------------------------------------------------------------------
0037                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: Stevie Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            Stevie Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * main
0011               * Initialize editor
0012               ***************************************************************
0013               * b   @main.stevie
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * -
0023               *--------------------------------------------------------------
0024               * Notes
0025               * Main entry point for stevie editor
0026               ***************************************************************
0027               
0028               
0029               ***************************************************************
0030               * Main
0031               ********|*****|*********************|**************************
0032               main.stevie:
0033 6058 20A0  38         coc   @wbit1,config         ; F18a detected?
     605A 2028 
0034 605C 1302  14         jeq   main.continue
0035 605E 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6060 0000 
0036               
0037               main.continue:
0038                       ;------------------------------------------------------
0039                       ; Setup F18A VDP
0040                       ;------------------------------------------------------
0041 6062 06A0  32         bl    @scroff               ; Turn screen off
     6064 2640 
0042               
0043 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26E4 
0044 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 232C 
0045 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6070 06A0  32         bl    @putvr                ; Turn on position based attributes
     6072 232C 
0048 6074 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6076 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     6078 232C 
0051 607A 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 607C 06A0  32         bl    @filv
     607E 2288 
0056 6080 0000                   data >0000,32,30*80   ; Clear screen
     6082 0020 
     6084 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6086 06A0  32         bl    @film
     6088 2230 
0061 608A A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     608C 0000 
     608E 6000 
0062                       ;------------------------------------------------------
0063                       ; Setup SAMS windows
0064                       ;------------------------------------------------------
0065 6090 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6092 677C 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6094 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6096 2660 
0070 6098 06A0  32         bl    @s8x8                 ; Small sprite
     609A 2670 
0071               
0072 609C 06A0  32         bl    @cpym2m
     609E 248C 
0073 60A0 76E6                   data romsat,ramsat,4  ; Load sprite SAT
     60A2 8380 
     60A4 0004 
0074               
0075 60A6 C820  54         mov   @romsat+2,@tv.curshape
     60A8 76E8 
     60AA A014 
0076                                                   ; Save cursor shape & color
0077               
0078 60AC 06A0  32         bl    @cpym2v
     60AE 2444 
0079 60B0 2800                   data sprpdt,cursors,3*8
     60B2 76EA 
     60B4 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 60B6 06A0  32         bl    @cpym2v
     60B8 2444 
0083 60BA 1008                   data >1008,patterns,11*8
     60BC 7702 
     60BE 0058 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60C0 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60C2 674E 
0089 60C4 06A0  32         bl    @tv.reset             ; Reset editor
     60C6 6760 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60C8 06A0  32         bl    @pane.action.colorscheme.Load
     60CA 7398 
0094                                                   ; Load color scheme and turn on screen
0095                       ;-------------------------------------------------------
0096                       ; Setup editor tasks & hook
0097                       ;-------------------------------------------------------
0098 60CC 0204  20         li    tmp0,>0200
     60CE 0200 
0099 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60D2 8314 
0100               
0101 60D4 06A0  32         bl    @at
     60D6 2680 
0102 60D8 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0105 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0106               
0107 60E2 06A0  32         bl    @mkslot
     60E4 2DD0 
0108 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 71E6 
0109 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 727E 
0110 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 72B2 
0111 60F2 FFFF                   data eol
0112               
0113 60F4 06A0  32         bl    @mkhook
     60F6 2DBC 
0114 60F8 71B6                   data hook.keyscan     ; Setup user hook
0115               
0116 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2D12 
**** **** ****     > stevie_b1.asm.360191
0038               
0039                       ;-----------------------------------------------------------------------
0040                       ; Keyboard actions
0041                       ;-----------------------------------------------------------------------
0042                       copy  "edkey.asm"           ; Keyboard actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 60FE C160  34         mov   @waux1,tmp1           ; Get key value
     6100 833C 
0010 6102 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6104 FF00 
0011 6106 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 6108 C1A0  34         mov   @tv.pane.focus,tmp2
     610A A01A 
0016 610C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     610E 0000 
0017 6110 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 6112 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6114 0001 
0021 6116 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 6118 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     611A FFCE 
0027 611C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     611E 2030 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 6120 0206  20         li    tmp2,keymap_actions.editor
     6122 7C8C 
0033 6124 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 7D4E 
0039 612A 1600  14         jne   edkey.key.check_next
0040                       ;-------------------------------------------------------
0041                       ; Iterate over keyboard map for matching action key
0042                       ;-------------------------------------------------------
0043               edkey.key.check_next:
0044 612C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0045 612E 1309  14         jeq   edkey.key.process.addbuffer
0046                                                   ; Yes, means no action key pressed, so
0047                                                   ; add character to buffer
0048                       ;-------------------------------------------------------
0049                       ; Check for action key match
0050                       ;-------------------------------------------------------
0051 6130 8585  30         c     tmp1,*tmp2            ; Action key matched?
0052 6132 1303  14         jeq   edkey.key.process.action
0053                                                   ; Yes, do action
0054 6134 0226  22         ai    tmp2,6                ; Skip current entry
     6136 0006 
0055 6138 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0056                       ;-------------------------------------------------------
0057                       ; Trigger keyboard action
0058                       ;-------------------------------------------------------
0059               edkey.key.process.action:
0060 613A 0226  22         ai    tmp2,4                ; Move to action address
     613C 0004 
0061 613E C196  26         mov   *tmp2,tmp2            ; Get action address
0062 6140 0456  20         b     *tmp2                 ; Process key action
0063                       ;-------------------------------------------------------
0064                       ; Add character to appropriate buffer
0065                       ;-------------------------------------------------------
0066               edkey.key.process.addbuffer:
0067 6142 C120  34         mov  @tv.pane.focus,tmp0    ; Frame buffer has focus?
     6144 A01A 
0068 6146 1602  14         jne  !                      ; No, skip frame buffer
0069 6148 0460  28         b    @edkey.action.char     ; Add character to frame buffer
     614A 65DE 
0070                       ;-------------------------------------------------------
0071                       ; CMDB buffer
0072                       ;-------------------------------------------------------
0073 614C 0284  22 !       ci   tmp0,pane.focus.cmdb   ; CMDB has focus ?
     614E 0001 
0074 6150 1602  14         jne  edkey.key.process.crash
0075                                                   ; No, crash
0076 6152 0460  28         b    @edkey.action.cmdb.char
     6154 66EA 
0077                                                   ; Add character to CMDB buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6158 FFCE 
0083 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     615C 2030 
**** **** ****     > stevie_b1.asm.360191
0043                       copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys
**** **** ****     > edkey.fb.mov.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 615E C120  34         mov   @fb.column,tmp0
     6160 A10C 
0010 6162 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6164 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6166 A10C 
0015 6168 0620  34         dec   @wyx                  ; Column-- VDP cursor
     616A 832A 
0016 616C 0620  34         dec   @fb.current
     616E A102 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6170 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6172 71DA 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6174 8820  54         c     @fb.column,@fb.row.length
     6176 A10C 
     6178 A108 
0028 617A 1406  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 617C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     617E A10C 
0033 6180 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6182 832A 
0034 6184 05A0  34         inc   @fb.current
     6186 A102 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 6188 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     618A 71DA 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 618C 8820  54         c     @fb.row.dirty,@w$ffff
     618E A10A 
     6190 202C 
0049 6192 1604  14         jne   edkey.action.up.cursor
0050 6194 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6196 6BCA 
0051 6198 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     619A A10A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 619C C120  34         mov   @fb.row,tmp0
     619E A106 
0057 61A0 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row > 0
0059 61A2 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     61A4 A104 
0060 61A6 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 61A8 0604  14         dec   tmp0                  ; fb.topline--
0066 61AA C804  38         mov   tmp0,@parm1
     61AC 8350 
0067 61AE 06A0  32         bl    @fb.refresh           ; Scroll one line up
     61B0 684A 
0068 61B2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61B4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61B6 A106 
0074 61B8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61BA 268E 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61BC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61BE 6D62 
0080 61C0 8820  54         c     @fb.column,@fb.row.length
     61C2 A10C 
     61C4 A108 
0081 61C6 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 61C8 C820  54         mov   @fb.row.length,@fb.column
     61CA A108 
     61CC A10C 
0086 61CE C120  34         mov   @fb.column,tmp0
     61D0 A10C 
0087 61D2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61D4 2698 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D8 682E 
0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61DC 71DA 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 61DE 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     61E0 A106 
     61E2 A204 
0102 61E4 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 61E6 8820  54         c     @fb.row.dirty,@w$ffff
     61E8 A10A 
     61EA 202C 
0107 61EC 1604  14         jne   edkey.action.down.move
0108 61EE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61F0 6BCA 
0109 61F2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61F4 A10A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 61F6 C120  34         mov   @fb.topline,tmp0
     61F8 A104 
0118 61FA A120  34         a     @fb.row,tmp0
     61FC A106 
0119 61FE 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6200 A204 
0120 6202 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6204 C120  34         mov   @fb.scrrows,tmp0
     6206 A118 
0126 6208 0604  14         dec   tmp0
0127 620A 8120  34         c     @fb.row,tmp0
     620C A106 
0128 620E 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6210 C820  54         mov   @fb.topline,@parm1
     6212 A104 
     6214 8350 
0133 6216 05A0  34         inc   @parm1
     6218 8350 
0134 621A 06A0  32         bl    @fb.refresh
     621C 684A 
0135 621E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6220 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6222 A106 
0141 6224 06A0  32         bl    @down                 ; Row++ VDP cursor
     6226 2686 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6228 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     622A 6D62 
0147               
0148 622C 8820  54         c     @fb.column,@fb.row.length
     622E A10C 
     6230 A108 
0149 6232 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 6234 C820  54         mov   @fb.row.length,@fb.column
     6236 A108 
     6238 A10C 
0155 623A C120  34         mov   @fb.column,tmp0
     623C A10C 
0156 623E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6240 2698 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6244 682E 
0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6248 71DA 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 624A C120  34         mov   @wyx,tmp0
     624C 832A 
0171 624E 0244  22         andi  tmp0,>ff00
     6250 FF00 
0172 6252 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6254 832A 
0173 6256 04E0  34         clr   @fb.column
     6258 A10C 
0174 625A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     625C 682E 
0175 625E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6260 71DA 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 6262 C120  34         mov   @fb.row.length,tmp0
     6264 A108 
0182 6266 C804  38         mov   tmp0,@fb.column
     6268 A10C 
0183 626A 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     626C 2698 
0184 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6270 682E 
0185 6272 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6274 71DA 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 6276 C120  34         mov   @fb.column,tmp0
     6278 A10C 
0194 627A 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 627C C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     627E A102 
0199 6280 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 6282 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 6284 0605  14         dec   tmp1
0206 6286 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 6288 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 628A D195  26         movb  *tmp1,tmp2            ; Get character
0214 628C 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 628E D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 6290 0986  56         srl   tmp2,8                ; Right justify
0217 6292 0286  22         ci    tmp2,32               ; Space character found?
     6294 0020 
0218 6296 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 6298 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     629A 2020 
0224 629C 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 629E 0287  22         ci    tmp3,>20ff            ; First character is space
     62A0 20FF 
0227 62A2 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 62A4 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     62A6 A10C 
0232 62A8 61C4  18         s     tmp0,tmp3
0233 62AA 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     62AC 0002 
0234 62AE 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 62B0 0585  14         inc   tmp1
0240 62B2 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 62B4 C805  38         mov   tmp1,@fb.current
     62B6 A102 
0246 62B8 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62BA A10C 
0247 62BC 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62BE 2698 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62C2 682E 
0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62C6 71DA 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 62C8 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 62CA C120  34         mov   @fb.column,tmp0
     62CC A10C 
0263 62CE 8804  38         c     tmp0,@fb.row.length
     62D0 A108 
0264 62D2 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 62D4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62D6 A102 
0269 62D8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 62DA 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 62DC 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 62DE 0585  14         inc   tmp1
0281 62E0 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 62E2 8804  38         c     tmp0,@fb.row.length
     62E4 A108 
0283 62E6 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 62E8 D195  26         movb  *tmp1,tmp2            ; Get character
0290 62EA 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 62EC D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 62EE 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 62F0 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     62F2 FFFF 
0295 62F4 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 62F6 0286  22         ci    tmp2,32
     62F8 0020 
0301 62FA 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 62FC 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 62FE 0286  22         ci    tmp2,32               ; Space character found?
     6300 0020 
0309 6302 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 6304 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6306 2020 
0315 6308 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 630A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     630C 20FF 
0318 630E 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 6310 0585  14         inc   tmp1
0323 6312 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 6314 C805  38         mov   tmp1,@fb.current
     6316 A102 
0329 6318 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     631A A10C 
0330 631C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     631E 2698 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6320 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6322 682E 
0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6326 71DA 
0337               
0338               
0339               
0340               
0341               *---------------------------------------------------------------
0342               * Previous page
0343               *---------------------------------------------------------------
0344               edkey.action.ppage:
0345                       ;-------------------------------------------------------
0346                       ; Sanity check
0347                       ;-------------------------------------------------------
0348 6328 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     632A A104 
0349 632C 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 632E 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6330 A118 
0354 6332 1503  14         jgt   edkey.action.ppage.topline
0355 6334 04E0  34         clr   @fb.topline           ; topline = 0
     6336 A104 
0356 6338 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 633A 6820  54         s     @fb.scrrows,@fb.topline
     633C A118 
     633E A104 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 6340 8820  54         c     @fb.row.dirty,@w$ffff
     6342 A10A 
     6344 202C 
0367 6346 1604  14         jne   edkey.action.ppage.refresh
0368 6348 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     634A 6BCA 
0369 634C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     634E A10A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 6350 C820  54         mov   @fb.topline,@parm1
     6352 A104 
     6354 8350 
0375 6356 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6358 684A 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 635A 04E0  34         clr   @fb.row
     635C A106 
0381 635E 04E0  34         clr   @fb.column
     6360 A10C 
0382 6362 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6364 832A 
0383 6366 0460  28         b     @edkey.action.up      ; In edkey.action up cursor is moved up
     6368 618C 
0384               
0385               
0386               
0387               *---------------------------------------------------------------
0388               * Next page
0389               *---------------------------------------------------------------
0390               edkey.action.npage:
0391                       ;-------------------------------------------------------
0392                       ; Sanity check
0393                       ;-------------------------------------------------------
0394 636A C120  34         mov   @fb.topline,tmp0
     636C A104 
0395 636E A120  34         a     @fb.scrrows,tmp0
     6370 A118 
0396 6372 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6374 A204 
0397 6376 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 6378 A820  54         a     @fb.scrrows,@fb.topline
     637A A118 
     637C A104 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 637E 8820  54         c     @fb.row.dirty,@w$ffff
     6380 A10A 
     6382 202C 
0408 6384 1604  14         jne   edkey.action.npage.refresh
0409 6386 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6388 6BCA 
0410 638A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     638C A10A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 638E 0460  28         b     @edkey.action.ppage.refresh
     6390 6350 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 6392 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6394 71DA 
0422               
0423               
0424               
0425               
0426               *---------------------------------------------------------------
0427               * Goto top of file
0428               *---------------------------------------------------------------
0429               edkey.action.top:
0430                       ;-------------------------------------------------------
0431                       ; Crunch current row if dirty
0432                       ;-------------------------------------------------------
0433 6396 8820  54         c     @fb.row.dirty,@w$ffff
     6398 A10A 
     639A 202C 
0434 639C 1604  14         jne   edkey.action.top.refresh
0435 639E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63A0 6BCA 
0436 63A2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63A4 A10A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 63A6 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     63A8 A104 
0442 63AA 04E0  34         clr   @parm1
     63AC 8350 
0443 63AE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63B0 684A 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 63B2 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B4 A106 
0449 63B6 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B8 A10C 
0450 63BA 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63BC 832A 
0451 63BE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C0 71DA 
0452               
0453               
0454               
0455               *---------------------------------------------------------------
0456               * Goto bottom of file
0457               *---------------------------------------------------------------
0458               edkey.action.bot:
0459                       ;-------------------------------------------------------
0460                       ; Crunch current row if dirty
0461                       ;-------------------------------------------------------
0462 63C2 8820  54         c     @fb.row.dirty,@w$ffff
     63C4 A10A 
     63C6 202C 
0463 63C8 1604  14         jne   edkey.action.bot.refresh
0464 63CA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63CC 6BCA 
0465 63CE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D0 A10A 
0466                       ;-------------------------------------------------------
0467                       ; Refresh page
0468                       ;-------------------------------------------------------
0469               edkey.action.bot.refresh:
0470 63D2 8820  54         c     @edb.lines,@fb.scrrows
     63D4 A204 
     63D6 A118 
0471                                                   ; Skip if whole editor buffer on screen
0472 63D8 1212  14         jle   !
0473 63DA C120  34         mov   @edb.lines,tmp0
     63DC A204 
0474 63DE 6120  34         s     @fb.scrrows,tmp0
     63E0 A118 
0475 63E2 C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     63E4 A104 
0476 63E6 C804  38         mov   tmp0,@parm1
     63E8 8350 
0477 63EA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63EC 684A 
0478                       ;-------------------------------------------------------
0479                       ; Exit
0480                       ;-------------------------------------------------------
0481               edkey.action.bot.exit:
0482 63EE 04E0  34         clr   @fb.row               ; Editor line 0
     63F0 A106 
0483 63F2 04E0  34         clr   @fb.column            ; Editor column 0
     63F4 A10C 
0484 63F6 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     63F8 0100 
0485 63FA C804  38         mov   tmp0,@wyx             ; Set cursor
     63FC 832A 
0486 63FE 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6400 71DA 
**** **** ****     > stevie_b1.asm.360191
0044                       copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 6402 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6404 A206 
0010 6406 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6408 682E 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 640A C120  34         mov   @fb.current,tmp0      ; Get pointer
     640C A102 
0015 640E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6410 A108 
0016 6412 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 6414 8820  54         c     @fb.column,@fb.row.length
     6416 A10C 
     6418 A108 
0022 641A 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 641C C120  34         mov   @fb.current,tmp0      ; Get pointer
     641E A102 
0028 6420 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 6422 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 6424 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 6426 0606  14         dec   tmp2
0036 6428 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 642A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     642C A10A 
0041 642E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6430 A116 
0042 6432 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6434 A108 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 6436 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6438 71DA 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 643A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     643C A206 
0055 643E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6440 682E 
0056 6442 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6444 A108 
0057 6446 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 6448 C120  34         mov   @fb.current,tmp0      ; Get pointer
     644A A102 
0063 644C C1A0  34         mov   @fb.colsline,tmp2
     644E A10E 
0064 6450 61A0  34         s     @fb.column,tmp2
     6452 A10C 
0065 6454 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 6456 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 6458 0606  14         dec   tmp2
0072 645A 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 645C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     645E A10A 
0077 6460 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6462 A116 
0078               
0079 6464 C820  54         mov   @fb.column,@fb.row.length
     6466 A10C 
     6468 A108 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 646A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     646C 71DA 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 646E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6470 A206 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 6472 C120  34         mov   @edb.lines,tmp0
     6474 A204 
0097 6476 1604  14         jne   !
0098 6478 04E0  34         clr   @fb.column            ; Column 0
     647A A10C 
0099 647C 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     647E 643A 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 6480 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6482 682E 
0104 6484 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6486 A10A 
0105 6488 C820  54         mov   @fb.topline,@parm1
     648A A104 
     648C 8350 
0106 648E A820  54         a     @fb.row,@parm1        ; Line number to remove
     6490 A106 
     6492 8350 
0107 6494 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6496 A204 
     6498 8352 
0108 649A 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     649C 6AB2 
0109 649E 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64A0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64A2 C820  54         mov   @fb.topline,@parm1
     64A4 A104 
     64A6 8350 
0114 64A8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64AA 684A 
0115 64AC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64AE A116 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 64B0 C120  34         mov   @fb.topline,tmp0
     64B2 A104 
0120 64B4 A120  34         a     @fb.row,tmp0
     64B6 A106 
0121 64B8 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64BA A204 
0122 64BC 1202  14         jle   edkey.action.del_line.exit
0123 64BE 0460  28         b     @edkey.action.up      ; One line up
     64C0 618C 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64C2 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64C4 624A 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws:
0138 64C6 0204  20         li    tmp0,>2000            ; White space
     64C8 2000 
0139 64CA C804  38         mov   tmp0,@parm1
     64CC 8350 
0140               edkey.action.ins_char:
0141 64CE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D0 A206 
0142 64D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64D4 682E 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64D6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64D8 A102 
0147 64DA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64DC A108 
0148 64DE 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 64E0 8820  54         c     @fb.column,@fb.row.length
     64E2 A10C 
     64E4 A108 
0154 64E6 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 64E8 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 64EA 61E0  34         s     @fb.column,tmp3
     64EC A10C 
0162 64EE A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 64F0 C144  18         mov   tmp0,tmp1
0164 64F2 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 64F4 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64F6 A10C 
0166 64F8 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 64FA D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 64FC 0604  14         dec   tmp0
0173 64FE 0605  14         dec   tmp1
0174 6500 0606  14         dec   tmp2
0175 6502 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 6504 D560  46         movb  @parm1,*tmp1
     6506 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 6508 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     650A A10A 
0184 650C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     650E A116 
0185 6510 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6512 A108 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 6514 0460  28         b     @edkey.action.char.overwrite
     6516 65F0 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 6518 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     651A 71DA 
0196               
0197               
0198               
0199               
0200               
0201               
0202               *---------------------------------------------------------------
0203               * Insert new line
0204               *---------------------------------------------------------------
0205               edkey.action.ins_line:
0206 651C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     651E A206 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 6520 8820  54         c     @fb.row.dirty,@w$ffff
     6522 A10A 
     6524 202C 
0211 6526 1604  14         jne   edkey.action.ins_line.insert
0212 6528 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     652A 6BCA 
0213 652C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     652E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6530 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6532 682E 
0219 6534 C820  54         mov   @fb.topline,@parm1
     6536 A104 
     6538 8350 
0220 653A A820  54         a     @fb.row,@parm1        ; Line number to insert
     653C A106 
     653E 8350 
0221 6540 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6542 A204 
     6544 8352 
0222               
0223 6546 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6548 6B3C 
0224                                                   ; \ i  parm1 = Line for insert
0225                                                   ; / i  parm2 = Last line to reorg
0226               
0227 654A 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     654C A204 
0228                       ;-------------------------------------------------------
0229                       ; Refresh frame buffer and physical screen
0230                       ;-------------------------------------------------------
0231 654E C820  54         mov   @fb.topline,@parm1
     6550 A104 
     6552 8350 
0232 6554 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6556 684A 
0233 6558 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     655A A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 655C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     655E 71DA 
0239               
0240               
0241               
0242               
0243               
0244               
0245               *---------------------------------------------------------------
0246               * Enter
0247               *---------------------------------------------------------------
0248               edkey.action.enter:
0249                       ;-------------------------------------------------------
0250                       ; Crunch current line if dirty
0251                       ;-------------------------------------------------------
0252 6560 8820  54         c     @fb.row.dirty,@w$ffff
     6562 A10A 
     6564 202C 
0253 6566 1606  14         jne   edkey.action.enter.upd_counter
0254 6568 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     656A A206 
0255 656C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     656E 6BCA 
0256 6570 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6572 A10A 
0257                       ;-------------------------------------------------------
0258                       ; Update line counter
0259                       ;-------------------------------------------------------
0260               edkey.action.enter.upd_counter:
0261 6574 C120  34         mov   @fb.topline,tmp0
     6576 A104 
0262 6578 A120  34         a     @fb.row,tmp0
     657A A106 
0263 657C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     657E A204 
0264 6580 1602  14         jne   edkey.action.newline  ; No, continue newline
0265 6582 05A0  34         inc   @edb.lines            ; Total lines++
     6584 A204 
0266                       ;-------------------------------------------------------
0267                       ; Process newline
0268                       ;-------------------------------------------------------
0269               edkey.action.newline:
0270                       ;-------------------------------------------------------
0271                       ; Scroll 1 line if cursor at bottom row of screen
0272                       ;-------------------------------------------------------
0273 6586 C120  34         mov   @fb.scrrows,tmp0
     6588 A118 
0274 658A 0604  14         dec   tmp0
0275 658C 8120  34         c     @fb.row,tmp0
     658E A106 
0276 6590 110A  14         jlt   edkey.action.newline.down
0277                       ;-------------------------------------------------------
0278                       ; Scroll
0279                       ;-------------------------------------------------------
0280 6592 C120  34         mov   @fb.scrrows,tmp0
     6594 A118 
0281 6596 C820  54         mov   @fb.topline,@parm1
     6598 A104 
     659A 8350 
0282 659C 05A0  34         inc   @parm1
     659E 8350 
0283 65A0 06A0  32         bl    @fb.refresh
     65A2 684A 
0284 65A4 1004  14         jmp   edkey.action.newline.rest
0285                       ;-------------------------------------------------------
0286                       ; Move cursor down a row, there are still rows left
0287                       ;-------------------------------------------------------
0288               edkey.action.newline.down:
0289 65A6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65A8 A106 
0290 65AA 06A0  32         bl    @down                 ; Row++ VDP cursor
     65AC 2686 
0291                       ;-------------------------------------------------------
0292                       ; Set VDP cursor and save variables
0293                       ;-------------------------------------------------------
0294               edkey.action.newline.rest:
0295 65AE 06A0  32         bl    @fb.get.firstnonblank
     65B0 68BA 
0296 65B2 C120  34         mov   @outparm1,tmp0
     65B4 8360 
0297 65B6 C804  38         mov   tmp0,@fb.column
     65B8 A10C 
0298 65BA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65BC 2698 
0299 65BE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65C0 6D62 
0300 65C2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C4 682E 
0301 65C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65C8 A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65CC 71DA 
0307               
0308               
0309               
0310               
0311               *---------------------------------------------------------------
0312               * Toggle insert/overwrite mode
0313               *---------------------------------------------------------------
0314               edkey.action.ins_onoff:
0315 65CE 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65D0 A20A 
0316                       ;-------------------------------------------------------
0317                       ; Delay
0318                       ;-------------------------------------------------------
0319 65D2 0204  20         li    tmp0,2000
     65D4 07D0 
0320               edkey.action.ins_onoff.loop:
0321 65D6 0604  14         dec   tmp0
0322 65D8 16FE  14         jne   edkey.action.ins_onoff.loop
0323                       ;-------------------------------------------------------
0324                       ; Exit
0325                       ;-------------------------------------------------------
0326               edkey.action.ins_onoff.exit:
0327 65DA 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65DC 72B2 
0328               
0329               
0330               
0331               
0332               *---------------------------------------------------------------
0333               * Process character (frame buffer)
0334               *---------------------------------------------------------------
0335               edkey.action.char:
0336 65DE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65E0 A206 
0337 65E2 D805  38         movb  tmp1,@parm1           ; Store character for insert
     65E4 8350 
0338 65E6 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     65E8 A20A 
0339 65EA 1302  14         jeq   edkey.action.char.overwrite
0340                       ;-------------------------------------------------------
0341                       ; Insert mode
0342                       ;-------------------------------------------------------
0343               edkey.action.char.insert:
0344 65EC 0460  28         b     @edkey.action.ins_char
     65EE 64CE 
0345                       ;-------------------------------------------------------
0346                       ; Overwrite mode
0347                       ;-------------------------------------------------------
0348               edkey.action.char.overwrite:
0349 65F0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65F2 682E 
0350 65F4 C120  34         mov   @fb.current,tmp0      ; Get pointer
     65F6 A102 
0351               
0352 65F8 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     65FA 8350 
0353 65FC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65FE A10A 
0354 6600 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6602 A116 
0355               
0356 6604 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6606 A10C 
0357 6608 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     660A 832A 
0358                       ;-------------------------------------------------------
0359                       ; Update line length in frame buffer
0360                       ;-------------------------------------------------------
0361 660C 8820  54         c     @fb.column,@fb.row.length
     660E A10C 
     6610 A108 
0362 6612 1103  14         jlt   edkey.action.char.exit
0363                                                   ; column < length line ? Skip processing
0364               
0365 6614 C820  54         mov   @fb.column,@fb.row.length
     6616 A10C 
     6618 A108 
0366                       ;-------------------------------------------------------
0367                       ; Exit
0368                       ;-------------------------------------------------------
0369               edkey.action.char.exit:
0370 661A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     661C 71DA 
**** **** ****     > stevie_b1.asm.360191
0045                       copy  "edkey.fb.misc.asm"   ; fb pane   - Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit stevie
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 661E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6620 2748 
0010 6622 0420  54         blwp  @0                    ; Exit
     6624 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6626 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6628 71DA 
0018               
0019               
0020               
0021               
0022               
0023               
0024               *---------------------------------------------------------------
0025               * Framebuffer down 1 row
0026               *---------------------------------------------------------------
0027               edkey.action.fbdown:
0028 662A 05A0  34         inc   @fb.scrrows
     662C A118 
0029 662E 0720  34         seto  @fb.dirty
     6630 A116 
0030               
0031 6632 045B  20         b     *r11
0032               
**** **** ****     > stevie_b1.asm.360191
0046                       copy  "edkey.fb.file.asm"   ; fb pane   - File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6634 0204  20         li   tmp0,fdname0
     6636 7984 
0007 6638 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 663A 0204  20         li   tmp0,fdname1
     663C 78F0 
0010 663E 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6640 0204  20         li   tmp0,fdname2
     6642 78FA 
0013 6644 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 6646 0204  20         li   tmp0,fdname3
     6648 790A 
0016 664A 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 664C 0204  20         li   tmp0,fdname4
     664E 7918 
0019 6650 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6652 0204  20         li   tmp0,fdname5
     6654 792A 
0022 6656 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 6658 0204  20         li   tmp0,fdname6
     665A 793C 
0025 665C 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 665E 0204  20         li   tmp0,fdname7
     6660 794E 
0028 6662 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6664 0204  20         li   tmp0,fdname8
     6666 7962 
0031 6668 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 666A 0204  20         li   tmp0,fdname9
     666C 7976 
0034 666E 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 6670 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6672 707A 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 6674 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6676 6396 
0042               
0043               
0044               
0045               edkey.action.dialog.dv80:
0046 6678 0204  20         li   tmp0,txt.cmdb.loaddv80
     667A 7864 
0047 667C C804  38         mov  tmp0,@cmdb.pantitle
     667E A31A 
0048 6680 0204  20         li   tmp0,txt.cmdb.hintdv80
     6682 7874 
0049 6684 C804  38         mov  tmp0,@cmdb.panhint
     6686 A31C 
0050 6688 0460  28         b    @edkey.action.cmdb.show
     668A 6712 
**** **** ****     > stevie_b1.asm.360191
0047                       copy  "edkey.cmdb.mov.asm"  ; cmdb pane - Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 668C C120  34         mov   @cmdb.column,tmp0
     668E A312 
0010 6690 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6692 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6694 A312 
0015 6696 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6698 A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 669A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     669C 71DA 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 669E 8820  54         c     @cmdb.column,@cmdb.length
     66A0 A312 
     66A2 A314 
0027 66A4 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 66A6 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     66A8 A312 
0032 66AA 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     66AC A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 66AE 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66B0 71DA 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 66B2 04C4  14         clr   tmp0
0045 66B4 C804  38         mov   tmp0,@cmdb.column      ; First column
     66B6 A312 
0046 66B8 0584  14         inc   tmp0
0047 66BA D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     66BC A30A 
0048 66BE C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     66C0 A30A 
0049               
0050 66C2 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66C4 71DA 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 66C6 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     66C8 A31E 
0057 66CA 0984  56         srl   tmp0,8                 ; Right justify
0058 66CC C804  38         mov   tmp0,@cmdb.column      ; Save column position
     66CE A312 
0059 66D0 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 66D2 0224  22         ai    tmp0,>1a00             ; Y=26
     66D4 1A00 
0061 66D6 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     66D8 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 66DA 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66DC 71DA 
**** **** ****     > stevie_b1.asm.360191
0048                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               
0006               *---------------------------------------------------------------
0007               * Clear current command
0008               *---------------------------------------------------------------
0009               edkey.action.cmdb.clear:
0010                       ;-------------------------------------------------------
0011                       ; Clear current command
0012                       ;-------------------------------------------------------
0013 66DE 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     66E0 6E04 
0014 66E2 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66E4 A318 
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018               edkey.action.cmdb.clear.exit:
0019 66E6 0460  28         b     @edkey.action.cmdb.home
     66E8 66B2 
0020                                                   ; Reposition cursor
0021               
0022               
0023               
0024               
0025               
0026               *---------------------------------------------------------------
0027               * Process character
0028               ********|*****|*********************|**************************
0029               edkey.action.cmdb.char:
0030 66EA 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66EC A318 
0031               
0032 66EE 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     66F0 A31F 
0033 66F2 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     66F4 A312 
0034 66F6 D505  30         movb  tmp1,*tmp0            ; Add character
0035 66F8 05A0  34         inc   @cmdb.column          ; Next column
     66FA A312 
0036 66FC 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     66FE A30A 
0037               
0038 6700 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6702 6E36 
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               edkey.action.cmdb.char.exit:
0043 6704 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6706 71DA 
0044               
0045               
0046               
0047               
0048               *---------------------------------------------------------------
0049               * Enter
0050               *---------------------------------------------------------------
0051               edkey.action.cmdb.enter:
0052                       ;-------------------------------------------------------
0053                       ; Parse command
0054                       ;-------------------------------------------------------
0055                       ; TO BE IMPLEMENTED
0056               
0057                       ;-------------------------------------------------------
0058                       ; Exit
0059                       ;-------------------------------------------------------
0060               edkey.action.cmdb.enter.exit:
0061 6708 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     670A 71DA 
**** **** ****     > stevie_b1.asm.360191
0049                       copy  "edkey.cmdb.misc.asm" ; cmdb pane - Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 670C C120  34         mov   @cmdb.visible,tmp0
     670E A302 
0010 6710 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 6712 04E0  34         clr   @cmdb.column          ; Column = 0
     6714 A312 
0016 6716 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6718 751C 
0017 671A 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 671C 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     671E 756C 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 6720 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6722 71DA 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.360191
0050                       copy  "edkey.cmdb.file.asm" ; cmdb pane - File related actions
**** **** ****     > edkey.cmdb.file.asm
0001               * FILE......: edkey.cmdb.fíle.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load DV 80 file
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.loadfile:
0009                       ;-------------------------------------------------------
0010                       ; Load file
0011                       ;-------------------------------------------------------
0012 6724 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6726 756C 
0013               
0014 6728 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     672A 6E36 
0015 672C C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     672E 8360 
0016 6730 1603  14         jne   !                     ; No, load file
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 6732 06A0  32         bl    @pane.errline.show    ; Show error line
     6734 75A2 
0021               
0022 6736 1009  14         jmp   edkey.action.cmdb.loadfile.exit
0023                       ;-------------------------------------------------------
0024                       ; Load specified file
0025                       ;-------------------------------------------------------
0026 6738 06A0  32 !       bl    @cpym2m
     673A 248C 
0027 673C A31E                   data cmdb.cmdlen,heap.top,80
     673E E000 
     6740 0050 
0028                                                   ; Copy filename from command line to buffer
0029               
0030 6742 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6744 E000 
0031 6746 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6748 707A 
0032                                                   ; \ i  tmp0 = Pointer to length-prefixed
0033                                                   ; /           device/filename string
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037               edkey.action.cmdb.loadfile.exit:
0038 674A 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     674C 6396 
**** **** ****     > stevie_b1.asm.360191
0051                       ;-----------------------------------------------------------------------
0052                       ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
0053                       ;-----------------------------------------------------------------------
0054                       copy  "tv.asm"              ; Main editor configuration
**** **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize editor settings
0012               ***************************************************************
0013               * bl @tv.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ***************************************************************
0026               tv.init:
0027 674E 0649  14         dect  stack
0028 6750 C64B  30         mov   r11,*stack            ; Save return address
0029 6752 0649  14         dect  stack
0030 6754 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6756 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     6758 A012 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               tv.init.exit:
0039 675A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 675C C2F9  30         mov   *stack+,r11           ; Pop R11
0041 675E 045B  20         b     *r11                  ; Return to caller
0042               
0043               
0044               
0045               ***************************************************************
0046               * tv.reset
0047               * Reset editor (clear buffer)
0048               ***************************************************************
0049               * bl @tv.reset
0050               *--------------------------------------------------------------
0051               * INPUT
0052               * none
0053               *--------------------------------------------------------------
0054               * OUTPUT
0055               * none
0056               *--------------------------------------------------------------
0057               * Register usage
0058               * r11
0059               *--------------------------------------------------------------
0060               * Notes
0061               ***************************************************************
0062               tv.reset:
0063 6760 0649  14         dect  stack
0064 6762 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Reset editor
0067                       ;------------------------------------------------------
0068 6764 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6766 6D80 
0069 6768 06A0  32         bl    @edb.init             ; Initialize editor buffer
     676A 6B94 
0070 676C 06A0  32         bl    @idx.init             ; Initialize index
     676E 6902 
0071 6770 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6772 67D8 
0072 6774 06A0  32         bl    @errline.init         ; Initialize error line
     6776 6E5A 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               tv.reset.exit:
0077 6778 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 677A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0055                       copy  "mem.asm"             ; Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: Stevie Editor - Memory management (SAMS)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Memory Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.sams.layout
0010               * Setup SAMS memory pages for Stevie
0011               ***************************************************************
0012               * bl  @mem.setup.sams.layout
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ***************************************************************
0020               mem.sams.layout:
0021 677C 0649  14         dect  stack
0022 677E C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 6780 06A0  32         bl    @sams.layout
     6782 2594 
0027 6784 775A                   data mem.sams.layout.data
0028               
0029 6786 06A0  32         bl    @sams.layout.copy
     6788 25F8 
0030 678A A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 678C C820  54         mov   @tv.sams.c000,@edb.sams.page
     678E A008 
     6790 A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 6792 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 6794 045B  20         b     *r11                  ; Return to caller
0040               
0041               
0042               
0043               ***************************************************************
0044               * mem.edb.sams.mappage
0045               * Activate editor buffer SAMS page for line
0046               ***************************************************************
0047               * bl  @mem.edb.sams.mappage
0048               *     data p0
0049               *--------------------------------------------------------------
0050               * p0 = Line number in editor buffer
0051               *--------------------------------------------------------------
0052               * bl  @xmem.edb.sams.mappage
0053               *
0054               * tmp0 = Line number in editor buffer
0055               *--------------------------------------------------------------
0056               * OUTPUT
0057               * outparm1 = Pointer to line in editor buffer
0058               * outparm2 = SAMS page
0059               *--------------------------------------------------------------
0060               * Register usage
0061               * tmp0, tmp1
0062               ***************************************************************
0063               mem.edb.sams.mappage:
0064 6796 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 6798 0649  14         dect  stack
0067 679A C64B  30         mov   r11,*stack            ; Push return address
0068 679C 0649  14         dect  stack
0069 679E C644  30         mov   tmp0,*stack           ; Push tmp0
0070 67A0 0649  14         dect  stack
0071 67A2 C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 67A4 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     67A6 A204 
0076 67A8 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 67AA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     67AC FFCE 
0082 67AE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     67B0 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 67B2 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     67B4 6A56 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 67B6 C120  34         mov   @outparm2,tmp0        ; SAMS page
     67B8 8362 
0093 67BA C160  34         mov   @outparm1,tmp1        ; Pointer to line
     67BC 8360 
0094 67BE 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 67C0 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     67C2 A008 
0101 67C4 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 67C6 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     67C8 2528 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 67CA C820  54         mov   @outparm2,@tv.sams.c000
     67CC 8362 
     67CE A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 67D0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 67D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 67D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 67D6 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.360191
0056                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * fb.init
0010               * Initialize framebuffer
0011               ***************************************************************
0012               *  bl   @fb.init
0013               *--------------------------------------------------------------
0014               *  INPUT
0015               *  none
0016               *--------------------------------------------------------------
0017               *  OUTPUT
0018               *  none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               ********|*****|*********************|**************************
0023               fb.init
0024 67D8 0649  14         dect  stack
0025 67DA C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 67DC 0204  20         li    tmp0,fb.top
     67DE A600 
0030 67E0 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     67E2 A100 
0031 67E4 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     67E6 A104 
0032 67E8 04E0  34         clr   @fb.row               ; Current row=0
     67EA A106 
0033 67EC 04E0  34         clr   @fb.column            ; Current column=0
     67EE A10C 
0034               
0035 67F0 0204  20         li    tmp0,80
     67F2 0050 
0036 67F4 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     67F6 A10E 
0037               
0038 67F8 0204  20         li    tmp0,29
     67FA 001D 
0039 67FC C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     67FE A118 
0040 6800 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6802 A11A 
0041               
0042 6804 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     6806 A01A 
0043 6808 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     680A A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 680C 06A0  32         bl    @film
     680E 2230 
0048 6810 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     6812 0000 
     6814 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 6816 0460  28         b     @poprt                ; Return to caller
     6818 222C 
0054               
0055               
0056               
0057               
0058               ***************************************************************
0059               * fb.row2line
0060               * Calculate line in editor buffer
0061               ***************************************************************
0062               * bl @fb.row2line
0063               *--------------------------------------------------------------
0064               * INPUT
0065               * @fb.topline = Top line in frame buffer
0066               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0067               *--------------------------------------------------------------
0068               * OUTPUT
0069               * @outparm1 = Matching line in editor buffer
0070               *--------------------------------------------------------------
0071               * Register usage
0072               * tmp2,tmp3
0073               *--------------------------------------------------------------
0074               * Formula
0075               * outparm1 = @fb.topline + @parm1
0076               ********|*****|*********************|**************************
0077               fb.row2line:
0078 681A 0649  14         dect  stack
0079 681C C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 681E C120  34         mov   @parm1,tmp0
     6820 8350 
0084 6822 A120  34         a     @fb.topline,tmp0
     6824 A104 
0085 6826 C804  38         mov   tmp0,@outparm1
     6828 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 682A 0460  28         b    @poprt                 ; Return to caller
     682C 222C 
0091               
0092               
0093               
0094               
0095               ***************************************************************
0096               * fb.calc_pointer
0097               * Calculate pointer address in frame buffer
0098               ***************************************************************
0099               * bl @fb.calc_pointer
0100               *--------------------------------------------------------------
0101               * INPUT
0102               * @fb.top       = Address of top row in frame buffer
0103               * @fb.topline   = Top line in frame buffer
0104               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0105               * @fb.column    = Current column in frame buffer
0106               * @fb.colsline  = Columns per line in frame buffer
0107               *--------------------------------------------------------------
0108               * OUTPUT
0109               * @fb.current   = Updated pointer
0110               *--------------------------------------------------------------
0111               * Register usage
0112               * tmp2,tmp3
0113               *--------------------------------------------------------------
0114               * Formula
0115               * pointer = row * colsline + column + deref(@fb.top.ptr)
0116               ********|*****|*********************|**************************
0117               fb.calc_pointer:
0118 682E 0649  14         dect  stack
0119 6830 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 6832 C1A0  34         mov   @fb.row,tmp2
     6834 A106 
0124 6836 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     6838 A10E 
0125 683A A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     683C A10C 
0126 683E A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     6840 A100 
0127 6842 C807  38         mov   tmp3,@fb.current
     6844 A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 6846 0460  28         b    @poprt                 ; Return to caller
     6848 222C 
0133               
0134               
0135               
0136               
0137               ***************************************************************
0138               * fb.refresh
0139               * Refresh frame buffer with editor buffer content
0140               ***************************************************************
0141               * bl @fb.refresh
0142               *--------------------------------------------------------------
0143               * INPUT
0144               * @parm1 = Line to start with (becomes @fb.topline)
0145               *--------------------------------------------------------------
0146               * OUTPUT
0147               * none
0148               *--------------------------------------------------------------
0149               * Register usage
0150               * tmp0,tmp1,tmp2
0151               ********|*****|*********************|**************************
0152               fb.refresh:
0153 684A 0649  14         dect  stack
0154 684C C64B  30         mov   r11,*stack            ; Push return address
0155 684E 0649  14         dect  stack
0156 6850 C644  30         mov   tmp0,*stack           ; Push tmp0
0157 6852 0649  14         dect  stack
0158 6854 C645  30         mov   tmp1,*stack           ; Push tmp1
0159 6856 0649  14         dect  stack
0160 6858 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 685A C820  54         mov   @parm1,@fb.topline
     685C 8350 
     685E A104 
0165 6860 04E0  34         clr   @parm2                ; Target row in frame buffer
     6862 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 6864 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6866 8350 
     6868 A204 
0170 686A 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 686C 06A0  32         bl    @edb.line.unpack      ; Unpack line
     686E 6C80 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 6870 05A0  34         inc   @parm1                ; Next line in editor buffer
     6872 8350 
0180 6874 05A0  34         inc   @parm2                ; Next row in frame buffer
     6876 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 6878 8820  54         c     @parm1,@edb.lines
     687A 8350 
     687C A204 
0185 687E 1112  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 6880 C120  34         mov   @parm2,tmp0           ; Current row
     6882 8352 
0192 6884 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6886 A118 
0193 6888 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 688A 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     688C A10E 
0195               
0196 688E C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 6890 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6892 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6894 A10E 
0200 6896 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6898 A100 
0201               
0202 689A C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 689C 04C5  14         clr   tmp1                  ; Clear with >00 character
0204               
0205 689E 06A0  32         bl    @xfilm                ; \ Fill memory
     68A0 2236 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 68A2 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 68A4 8820  54 !       c     @parm2,@fb.scrrows
     68A6 8352 
     68A8 A118 
0214 68AA 11E0  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 68AC 0720  34         seto  @fb.dirty             ; Refresh screen
     68AE A116 
0221 68B0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 68B2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 68B4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 68B6 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 68B8 045B  20         b     *r11                  ; Return to caller
0226               
0227               
0228               ***************************************************************
0229               * fb.get.firstnonblank
0230               * Get column of first non-blank character in specified line
0231               ***************************************************************
0232               * bl @fb.get.firstnonblank
0233               *--------------------------------------------------------------
0234               * OUTPUT
0235               * @outparm1 = Column containing first non-blank character
0236               * @outparm2 = Character
0237               ********|*****|*********************|**************************
0238               fb.get.firstnonblank:
0239 68BA 0649  14         dect  stack
0240 68BC C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 68BE 04E0  34         clr   @fb.column
     68C0 A10C 
0245 68C2 06A0  32         bl    @fb.calc_pointer
     68C4 682E 
0246 68C6 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     68C8 6D62 
0247 68CA C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     68CC A108 
0248 68CE 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 68D0 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     68D2 A102 
0251 68D4 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 68D6 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 68D8 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 68DA 0285  22         ci    tmp1,>2000            ; Whitespace?
     68DC 2000 
0260 68DE 1503  14         jgt   fb.get.firstnonblank.match
0261 68E0 0606  14         dec   tmp2                  ; Counter--
0262 68E2 16F9  14         jne   fb.get.firstnonblank.loop
0263 68E4 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 68E6 6120  34         s     @fb.current,tmp0      ; Calculate column
     68E8 A102 
0269 68EA 0604  14         dec   tmp0
0270 68EC C804  38         mov   tmp0,@outparm1        ; Save column
     68EE 8360 
0271 68F0 D805  38         movb  tmp1,@outparm2        ; Save character
     68F2 8362 
0272 68F4 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68F6 04E0  34         clr   @outparm1             ; X=0
     68F8 8360 
0278 68FA 04E0  34         clr   @outparm2             ; Null
     68FC 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 68FE 0460  28         b    @poprt                 ; Return to caller
     6900 222C 
**** **** ****     > stevie_b1.asm.360191
0057                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Stevie Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               *  Size of index page is 4K and allows indexing of 2048 lines
0010               *  per page.
0011               *
0012               *  Each index slot (word) has the format:
0013               *    +-----+-----+
0014               *    | MSB | LSB |
0015               *    +-----|-----+   LSB = Pointer offset 00-ff.
0016               *
0017               *  MSB = SAMS Page 00-ff
0018               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0019               *
0020               *  LSB = Pointer offset in range 00-ff
0021               *
0022               *        To calculate pointer to line in Editor buffer:
0023               *        Pointer address = edb.top + (LSB * 16)
0024               *
0025               *        Note that the editor buffer itself resides in own 4K memory range
0026               *        starting at edb.top
0027               *
0028               *        All support routines must assure that length-prefixed string in
0029               *        Editor buffer always start on a 16 byte boundary for being
0030               *        accessible via index.
0031               ***************************************************************
0032               
0033               
0034               ***************************************************************
0035               * idx.init
0036               * Initialize index
0037               ***************************************************************
0038               * bl @idx.init
0039               *--------------------------------------------------------------
0040               * INPUT
0041               * none
0042               *--------------------------------------------------------------
0043               * OUTPUT
0044               * none
0045               *--------------------------------------------------------------
0046               * Register usage
0047               * tmp0
0048               ********|*****|*********************|**************************
0049               idx.init:
0050 6902 0649  14         dect  stack
0051 6904 C64B  30         mov   r11,*stack            ; Save return address
0052 6906 0649  14         dect  stack
0053 6908 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 690A 0204  20         li    tmp0,idx.top
     690C B000 
0058 690E C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6910 A202 
0059               
0060 6912 C120  34         mov   @tv.sams.b000,tmp0
     6914 A006 
0061 6916 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     6918 A500 
0062 691A C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     691C A502 
0063 691E C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     6920 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 6922 06A0  32         bl    @film
     6924 2230 
0068 6926 B000                   data idx.top,>00,idx.size
     6928 0000 
     692A 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 692C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 692E C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6930 045B  20         b     *r11                  ; Return to caller
0077               
0078               
0079               
0080               ***************************************************************
0081               * _idx.sams.mapcolumn.on
0082               * Flatten SAMS index pages into continious memory region.
0083               * Gives 20 KB of index space (2048 * 5 = 10240 lines per file)
0084               *
0085               * >b000  1st index page
0086               * >c000  2nd index page
0087               * >d000  3rd index page
0088               * >e000  4th index page
0089               * >f000  5th index page
0090               ***************************************************************
0091               * bl @_idx.sams.mapcolumn.on
0092               *--------------------------------------------------------------
0093               * Register usage
0094               * tmp0, tmp1, tmp2
0095               *--------------------------------------------------------------
0096               *  Remarks
0097               *  Private, only to be called from inside idx module
0098               ********|*****|*********************|**************************
0099               _idx.sams.mapcolumn.on:
0100 6932 0649  14         dect  stack
0101 6934 C64B  30         mov   r11,*stack            ; Push return address
0102 6936 0649  14         dect  stack
0103 6938 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 693A 0649  14         dect  stack
0105 693C C645  30         mov   tmp1,*stack           ; Push tmp1
0106 693E 0649  14         dect  stack
0107 6940 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6942 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6944 A502 
0112 6946 0205  20         li    tmp1,idx.top
     6948 B000 
0113               
0114 694A C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     694C A504 
0115 694E 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6950 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6952 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6954 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6956 0005 
0121 6958 1104  14         jlt   !
0122 695A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     695C FFCE 
0123 695E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6960 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6962 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6964 2528 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6966 0584  14         inc   tmp0                  ; Next SAMS index page
0132 6968 0225  22         ai    tmp1,>1000            ; Next memory region
     696A 1000 
0133 696C 0606  14         dec   tmp2                  ; Update loop counter
0134 696E 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6970 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6972 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6974 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6976 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6978 045B  20         b     *r11                  ; Return to caller
0144               
0145               
0146               ***************************************************************
0147               * _idx.sams.mapcolumn.off
0148               * Restore normal SAMS layout again (single index page)
0149               ***************************************************************
0150               * bl @_idx.sams.mapcolumn.off
0151               *--------------------------------------------------------------
0152               * Register usage
0153               * tmp0, tmp1, tmp2, tmp3
0154               *--------------------------------------------------------------
0155               *  Remarks
0156               *  Private, only to be called from inside idx module
0157               ********|*****|*********************|**************************
0158               _idx.sams.mapcolumn.off:
0159 697A 0649  14         dect  stack
0160 697C C64B  30         mov   r11,*stack            ; Push return address
0161 697E 0649  14         dect  stack
0162 6980 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6982 0649  14         dect  stack
0164 6984 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6986 0649  14         dect  stack
0166 6988 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 698A 0649  14         dect  stack
0168 698C C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 698E 0205  20         li    tmp1,idx.top
     6990 B000 
0173 6992 0206  20         li    tmp2,5                ; Always 5 pages
     6994 0005 
0174 6996 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6998 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 699A C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 699C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     699E 2528 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 69A0 0225  22         ai    tmp1,>1000            ; Next memory region
     69A2 1000 
0185 69A4 0606  14         dec   tmp2                  ; Update loop counter
0186 69A6 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 69A8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 69AA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 69AC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 69AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 69B0 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 69B2 045B  20         b     *r11                  ; Return to caller
0197               
0198               
0199               
0200               ***************************************************************
0201               * idx._samspage.get
0202               * Get SAMS page for index
0203               ***************************************************************
0204               * bl @idx._samspage.get
0205               *--------------------------------------------------------------
0206               * INPUT
0207               * tmp0 = Line number
0208               *--------------------------------------------------------------
0209               * OUTPUT
0210               * @outparm1 = Offset for index entry in index SAMS page
0211               *--------------------------------------------------------------
0212               * Register usage
0213               * tmp0, tmp1, tmp2
0214               *--------------------------------------------------------------
0215               *  Remarks
0216               *  Private, only to be called from inside idx module.
0217               *  Activates SAMS page containing required index slot entry.
0218               ********|*****|*********************|**************************
0219               _idx.samspage.get:
0220 69B4 0649  14         dect  stack
0221 69B6 C64B  30         mov   r11,*stack            ; Save return address
0222 69B8 0649  14         dect  stack
0223 69BA C644  30         mov   tmp0,*stack           ; Push tmp0
0224 69BC 0649  14         dect  stack
0225 69BE C645  30         mov   tmp1,*stack           ; Push tmp1
0226 69C0 0649  14         dect  stack
0227 69C2 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 69C4 C184  18         mov   tmp0,tmp2             ; Line number
0232 69C6 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 69C8 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     69CA 0800 
0234               
0235 69CC 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 69CE 0A16  56         sla   tmp2,1                ; line number * 2
0240 69D0 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     69D2 8360 
0241               
0242 69D4 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     69D6 A502 
0243 69D8 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     69DA A500 
0244               
0245 69DC 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 69DE C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     69E0 A500 
0251 69E2 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     69E4 A006 
0252               
0253 69E6 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 69E8 0205  20         li    tmp1,>b000            ; Memory window for index page
     69EA B000 
0255               
0256 69EC 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     69EE 2528 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 69F0 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     69F2 A504 
0263 69F4 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 69F6 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     69F8 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 69FA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 69FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 69FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6A00 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6A02 045B  20         b     *r11                  ; Return to caller
0275               
0276               
0277               ***************************************************************
0278               * idx.entry.update
0279               * Update index entry - Each entry corresponds to a line
0280               ***************************************************************
0281               * bl @idx.entry.update
0282               *--------------------------------------------------------------
0283               * INPUT
0284               * @parm1    = Line number in editor buffer
0285               * @parm2    = Pointer to line in editor buffer
0286               * @parm3    = SAMS page
0287               *--------------------------------------------------------------
0288               * OUTPUT
0289               * @outparm1 = Pointer to updated index entry
0290               *--------------------------------------------------------------
0291               * Register usage
0292               * tmp0,tmp1,tmp2
0293               ********|*****|*********************|**************************
0294               idx.entry.update:
0295 6A04 0649  14         dect  stack
0296 6A06 C64B  30         mov   r11,*stack            ; Save return address
0297 6A08 0649  14         dect  stack
0298 6A0A C644  30         mov   tmp0,*stack           ; Push tmp0
0299 6A0C 0649  14         dect  stack
0300 6A0E C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 6A10 C120  34         mov   @parm1,tmp0           ; Get line number
     6A12 8350 
0305 6A14 C160  34         mov   @parm2,tmp1           ; Get pointer
     6A16 8352 
0306 6A18 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 6A1A 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6A1C 0FFF 
0312 6A1E 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 6A20 06E0  34         swpb  @parm3
     6A22 8354 
0317 6A24 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6A26 8354 
0318 6A28 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6A2A 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 6A2C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A2E 69B4 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 6A30 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6A32 8360 
0329 6A34 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A36 B000 
0330 6A38 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A3A 8360 
0331 6A3C 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 6A3E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A40 69B4 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 6A42 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6A44 8360 
0341 6A46 04E4  34         clr   @idx.top(tmp0)        ; /
     6A48 B000 
0342 6A4A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A4C 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 6A4E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6A50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6A52 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6A54 045B  20         b     *r11                  ; Return to caller
0351               
0352               
0353               
0354               
0355               
0356               ***************************************************************
0357               * idx.pointer.get
0358               * Get pointer to editor buffer line content
0359               ***************************************************************
0360               * bl @idx.pointer.get
0361               *--------------------------------------------------------------
0362               * INPUT
0363               * @parm1 = Line number in editor buffer
0364               *--------------------------------------------------------------
0365               * OUTPUT
0366               * @outparm1 = Pointer to editor buffer line content
0367               * @outparm2 = SAMS page
0368               *--------------------------------------------------------------
0369               * Register usage
0370               * tmp0,tmp1,tmp2
0371               ********|*****|*********************|**************************
0372               idx.pointer.get:
0373 6A56 0649  14         dect  stack
0374 6A58 C64B  30         mov   r11,*stack            ; Save return address
0375 6A5A 0649  14         dect  stack
0376 6A5C C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6A5E 0649  14         dect  stack
0378 6A60 C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6A62 0649  14         dect  stack
0380 6A64 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6A66 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A68 8350 
0385               
0386 6A6A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6A6C 69B4 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6A6E C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6A70 8360 
0391 6A72 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A74 B000 
0392               
0393 6A76 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6A78 C185  18         mov   tmp1,tmp2             ; \
0399 6A7A 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6A7C 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A7E 00FF 
0404 6A80 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6A82 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A84 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6A86 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A88 8360 
0411 6A8A C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A8C 8362 
0412 6A8E 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6A90 04E0  34         clr   @outparm1
     6A92 8360 
0418 6A94 04E0  34         clr   @outparm2
     6A96 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6A98 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6A9A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6A9C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6A9E C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6AA0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0058                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Stevie Editor - Delete index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * _idx.entry.delete.reorg
0014               * Reorganize index slot entries
0015               ***************************************************************
0016               * bl @_idx.entry.delete.reorg
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  Private, only to be called from idx_entry_delete
0020               ********|*****|*********************|**************************
0021               _idx.entry.delete.reorg:
0022                       ;------------------------------------------------------
0023                       ; Reorganize index entries
0024                       ;------------------------------------------------------
0025 6AA2 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6AA4 B000 
0026 6AA6 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6AA8 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6AAA CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6AAC 0606  14         dec   tmp2                  ; tmp2--
0034 6AAE 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6AB0 045B  20         b     *r11                  ; Return to caller
0037               
0038               
0039               
0040               ***************************************************************
0041               * idx.entry.delete
0042               * Delete index entry - Close gap created by delete
0043               ***************************************************************
0044               * bl @idx.entry.delete
0045               *--------------------------------------------------------------
0046               * INPUT
0047               * @parm1    = Line number in editor buffer to delete
0048               * @parm2    = Line number of last line to check for reorg
0049               *--------------------------------------------------------------
0050               * Register usage
0051               * tmp0,tmp2
0052               ********|*****|*********************|**************************
0053               idx.entry.delete:
0054 6AB2 0649  14         dect  stack
0055 6AB4 C64B  30         mov   r11,*stack            ; Save return address
0056 6AB6 0649  14         dect  stack
0057 6AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6ABA 0649  14         dect  stack
0059 6ABC C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6ABE 0649  14         dect  stack
0061 6AC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6AC2 0649  14         dect  stack
0063 6AC4 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6AC6 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6AC8 8350 
0068               
0069 6ACA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6ACC 69B4 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6ACE C120  34         mov   @outparm1,tmp0        ; Index offset
     6AD0 8360 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6AD2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6AD4 8352 
0078 6AD6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6AD8 8350 
0079 6ADA 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6ADC C1E0  34         mov   @parm2,tmp3
     6ADE 8352 
0086 6AE0 0287  22         ci    tmp3,2048
     6AE2 0800 
0087 6AE4 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6AE6 06A0  32         bl    @_idx.sams.mapcolumn.on
     6AE8 6932 
0095                                                   ; Index in continious memory region
0096               
0097 6AEA 06A0  32         bl    @_idx.entry.delete.reorg
     6AEC 6AA2 
0098                                                   ; Reorganize index
0099               
0100               
0101 6AEE 06A0  32         bl    @_idx.sams.mapcolumn.off
     6AF0 697A 
0102                                                   ; Restore memory window layout
0103               
0104 6AF2 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6AF4 06A0  32         bl    @_idx.entry.delete.reorg
     6AF6 6AA2 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6AF8 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6AFA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6AFC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6AFE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6B00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6B02 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6B04 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0059                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Stevie Editor - Insert index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * _idx.entry.insert.reorg
0014               * Reorganize index slot entries
0015               ***************************************************************
0016               * bl @_idx.entry.insert.reorg
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  Private, only to be called from idx_entry_delete
0020               ********|*****|*********************|**************************
0021               _idx.entry.insert.reorg:
0022                       ;------------------------------------------------------
0023                       ; sanity check 1
0024                       ;------------------------------------------------------
0025 6B06 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6B08 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6B0A 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6B0C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B0E FFCE 
0034 6B10 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B12 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6B14 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6B16 B000 
0039 6B18 C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6B1A 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6B1C 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6B1E C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6B20 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6B22 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6B24 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6B26 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6B28 AFFE 
0050 6B2A 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6B2C C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6B2E 0644  14         dect  tmp0                  ; Move pointer up
0058 6B30 0645  14         dect  tmp1                  ; Move pointer up
0059 6B32 0606  14         dec   tmp2                  ; Next index entry
0060 6B34 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6B36 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6B38 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6B3A 045B  20         b     *r11                  ; Return to caller
0069               
0070               
0071               
0072               
0073               ***************************************************************
0074               * idx.entry.insert
0075               * Insert index entry
0076               ***************************************************************
0077               * bl @idx.entry.insert
0078               *--------------------------------------------------------------
0079               * INPUT
0080               * @parm1    = Line number in editor buffer to insert
0081               * @parm2    = Line number of last line to check for reorg
0082               *--------------------------------------------------------------
0083               * OUTPUT
0084               * NONE
0085               *--------------------------------------------------------------
0086               * Register usage
0087               * tmp0,tmp2
0088               ********|*****|*********************|**************************
0089               idx.entry.insert:
0090 6B3C 0649  14         dect  stack
0091 6B3E C64B  30         mov   r11,*stack            ; Save return address
0092 6B40 0649  14         dect  stack
0093 6B42 C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6B44 0649  14         dect  stack
0095 6B46 C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6B48 0649  14         dect  stack
0097 6B4A C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6B4C 0649  14         dect  stack
0099 6B4E C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6B50 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B52 8352 
0104 6B54 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B56 8350 
0105 6B58 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6B5A C1E0  34         mov   @parm2,tmp3
     6B5C 8352 
0112 6B5E 0287  22         ci    tmp3,2048
     6B60 0800 
0113 6B62 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6B64 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B66 6932 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6B68 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B6A 8352 
0125 6B6C 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6B6E 06A0  32         bl    @_idx.entry.insert.reorg
     6B70 6B06 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6B72 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B74 697A 
0133                                                   ; Restore memory window layout
0134               
0135 6B76 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6B78 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B7A 8352 
0141               
0142 6B7C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B7E 69B4 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6B80 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B82 8360 
0147               
0148 6B84 06A0  32         bl    @_idx.entry.insert.reorg
     6B86 6B06 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6B88 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6B8A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6B8C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6B8E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6B90 C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6B92 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0060                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Editor Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * edb.init
0010               * Initialize Editor buffer
0011               ***************************************************************
0012               * bl @edb.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               edb.init:
0026 6B94 0649  14         dect  stack
0027 6B96 C64B  30         mov   r11,*stack            ; Save return address
0028 6B98 0649  14         dect  stack
0029 6B9A C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6B9C 0204  20         li    tmp0,edb.top          ; \
     6B9E C000 
0034 6BA0 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6BA2 A200 
0035 6BA4 C804  38         mov   tmp0,@edb.next_free.ptr
     6BA6 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6BA8 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6BAA A20A 
0039 6BAC 04E0  34         clr   @edb.lines            ; Lines=0
     6BAE A204 
0040 6BB0 04E0  34         clr   @edb.rle              ; RLE compression off
     6BB2 A20C 
0041               
0042 6BB4 0204  20         li    tmp0,txt.newfile      ; "New file"
     6BB6 77D4 
0043 6BB8 C804  38         mov   tmp0,@edb.filename.ptr
     6BBA A20E 
0044               
0045 6BBC 0204  20         li    tmp0,txt.filetype.none
     6BBE 77E6 
0046 6BC0 C804  38         mov   tmp0,@edb.filetype.ptr
     6BC2 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6BC4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6BC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6BC8 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               ***************************************************************
0059               * edb.line.pack
0060               * Pack current line in framebuffer
0061               ***************************************************************
0062               *  bl   @edb.line.pack
0063               *--------------------------------------------------------------
0064               * INPUT
0065               * @fb.top       = Address of top row in frame buffer
0066               * @fb.row       = Current row in frame buffer
0067               * @fb.column    = Current column in frame buffer
0068               * @fb.colsline  = Columns per line in frame buffer
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               *--------------------------------------------------------------
0072               * Register usage
0073               * tmp0,tmp1,tmp2
0074               *--------------------------------------------------------------
0075               * Memory usage
0076               * rambuf   = Saved @fb.column
0077               * rambuf+2 = Saved beginning of row
0078               * rambuf+4 = Saved length of row
0079               ********|*****|*********************|**************************
0080               edb.line.pack:
0081 6BCA 0649  14         dect  stack
0082 6BCC C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6BCE C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6BD0 A10C 
     6BD2 8390 
0087 6BD4 04E0  34         clr   @fb.column
     6BD6 A10C 
0088 6BD8 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6BDA 682E 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6BDC 04C4  14         clr   tmp0                  ; Counter
0093 6BDE C160  34         mov   @fb.current,tmp1      ; Get position
     6BE0 A102 
0094 6BE2 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6BE4 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6BE6 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6BE8 0986  56         srl   tmp2,8                ; Right justify
0102 6BEA 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6BEC 0584  14         inc   tmp0                  ; Increase string length
0104 6BEE 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6BF0 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6BF2 A104 
     6BF4 8350 
0111 6BF6 A820  54         a     @fb.row,@parm1        ; /
     6BF8 A106 
     6BFA 8350 
0112               
0113 6BFC C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6BFE 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6C00 C120  34         mov   @edb.next_free.ptr,tmp0
     6C02 A208 
0120 6C04 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6C06 8352 
0121               
0122 6C08 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6C0A 24F0 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6C0C C820  54         mov   @waux1,@parm3         ; Setup parm3
     6C0E 833C 
     6C10 8354 
0128               
0129 6C12 06A0  32         bl    @idx.entry.update     ; Update index
     6C14 6A04 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6C16 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6C18 A212 
     6C1A 8354 
0139 6C1C 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6C1E C120  34         mov   @parm3,tmp0           ; get SAMS page
     6C20 8354 
0142 6C22 C160  34         mov   @edb.next_free.ptr,tmp1
     6C24 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6C26 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6C28 2528 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6C2A C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6C2C A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6C2E C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6C30 8392 
0155 6C32 C160  34         mov   @edb.next_free.ptr,tmp1
     6C34 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6C36 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C38 A208 
0159               
0160 6C3A C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C3C 8394 
0161 6C3E 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6C40 06C6  14         swpb  tmp2
0163 6C42 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6C44 06C6  14         swpb  tmp2
0165 6C46 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6C48 0286  22         ci    tmp2,2
     6C4A 0002 
0172 6C4C 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6C4E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6C50 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6C52 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6C54 0286  22         ci    tmp2,1
     6C56 0001 
0179 6C58 1602  14         jne   edb.line.pack.copyline.block
0180 6C5A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6C5C 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6C5E 06A0  32         bl    @xpym2m               ; Copy memory block
     6C60 2492 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6C62 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6C64 8394 
     6C66 A208 
0192                                                      ; Add length of line
0193               
0194 6C68 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6C6A A208 
0195 6C6C 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0196 6C6E 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6C70 000F 
0197 6C72 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6C74 A208 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               edb.line.pack.exit:
0202 6C76 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6C78 8390 
     6C7A A10C 
0203 6C7C 0460  28         b     @poprt                ; Return to caller
     6C7E 222C 
0204               
0205               
0206               
0207               
0208               ***************************************************************
0209               * edb.line.unpack
0210               * Unpack specified line to framebuffer
0211               ***************************************************************
0212               *  bl   @edb.line.unpack
0213               *--------------------------------------------------------------
0214               * INPUT
0215               * @parm1 = Line to unpack in editor buffer
0216               * @parm2 = Target row in frame buffer
0217               *--------------------------------------------------------------
0218               * OUTPUT
0219               * none
0220               *--------------------------------------------------------------
0221               * Register usage
0222               * tmp0,tmp1,tmp2
0223               *--------------------------------------------------------------
0224               * Memory usage
0225               * rambuf    = Saved @parm1 of edb.line.unpack
0226               * rambuf+2  = Saved @parm2 of edb.line.unpack
0227               * rambuf+4  = Source memory address in editor buffer
0228               * rambuf+6  = Destination memory address in frame buffer
0229               * rambuf+8  = Length of line
0230               ********|*****|*********************|**************************
0231               edb.line.unpack:
0232 6C80 0649  14         dect  stack
0233 6C82 C64B  30         mov   r11,*stack            ; Save return address
0234 6C84 0649  14         dect  stack
0235 6C86 C644  30         mov   tmp0,*stack           ; Push tmp0
0236 6C88 0649  14         dect  stack
0237 6C8A C645  30         mov   tmp1,*stack           ; Push tmp1
0238 6C8C 0649  14         dect  stack
0239 6C8E C646  30         mov   tmp2,*stack           ; Push tmp2
0240                       ;------------------------------------------------------
0241                       ; Sanity check
0242                       ;------------------------------------------------------
0243 6C90 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6C92 8350 
     6C94 A204 
0244 6C96 1104  14         jlt   !
0245 6C98 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C9A FFCE 
0246 6C9C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C9E 2030 
0247                       ;------------------------------------------------------
0248                       ; Save parameters
0249                       ;------------------------------------------------------
0250 6CA0 C820  54 !       mov   @parm1,@rambuf
     6CA2 8350 
     6CA4 8390 
0251 6CA6 C820  54         mov   @parm2,@rambuf+2
     6CA8 8352 
     6CAA 8392 
0252                       ;------------------------------------------------------
0253                       ; Calculate offset in frame buffer
0254                       ;------------------------------------------------------
0255 6CAC C120  34         mov   @fb.colsline,tmp0
     6CAE A10E 
0256 6CB0 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6CB2 8352 
0257 6CB4 C1A0  34         mov   @fb.top.ptr,tmp2
     6CB6 A100 
0258 6CB8 A146  18         a     tmp2,tmp1             ; Add base to offset
0259 6CBA C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6CBC 8396 
0260                       ;------------------------------------------------------
0261                       ; Get pointer to line & page-in editor buffer page
0262                       ;------------------------------------------------------
0263 6CBE C120  34         mov   @parm1,tmp0
     6CC0 8350 
0264 6CC2 06A0  32         bl    @xmem.edb.sams.mappage
     6CC4 6798 
0265                                                   ; Activate editor buffer SAMS page for line
0266                                                   ; \ i  tmp0     = Line number
0267                                                   ; | o  outparm1 = Pointer to line
0268                                                   ; / o  outparm2 = SAMS page
0269               
0270 6CC6 C820  54         mov   @outparm2,@edb.sams.page
     6CC8 8362 
     6CCA A212 
0271                                                   ; Save current SAMS page
0272                       ;------------------------------------------------------
0273                       ; Handle empty line
0274                       ;------------------------------------------------------
0275 6CCC C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6CCE 8360 
0276 6CD0 1603  14         jne   !                     ; Check if pointer is set
0277 6CD2 04E0  34         clr   @rambuf+8             ; Set length=0
     6CD4 8398 
0278 6CD6 100F  14         jmp   edb.line.unpack.clear
0279                       ;------------------------------------------------------
0280                       ; Get line length
0281                       ;------------------------------------------------------
0282 6CD8 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0283 6CDA C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6CDC 8398 
0284               
0285 6CDE 05E0  34         inct  @outparm1             ; Skip line prefix
     6CE0 8360 
0286 6CE2 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6CE4 8360 
     6CE6 8394 
0287                       ;------------------------------------------------------
0288                       ; Sanity check on line length
0289                       ;------------------------------------------------------
0290 6CE8 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6CEA 0050 
0291 6CEC 1204  14         jle   edb.line.unpack.clear ; /
0292               
0293 6CEE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CF0 FFCE 
0294 6CF2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CF4 2030 
0295                       ;------------------------------------------------------
0296                       ; Erase chars from last column until column 80
0297                       ;------------------------------------------------------
0298               edb.line.unpack.clear:
0299 6CF6 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6CF8 8396 
0300 6CFA A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6CFC 8398 
0301               
0302 6CFE 04C5  14         clr   tmp1                  ; Fill with >00
0303 6D00 C1A0  34         mov   @fb.colsline,tmp2
     6D02 A10E 
0304 6D04 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6D06 8398 
0305 6D08 0586  14         inc   tmp2
0306               
0307 6D0A 06A0  32         bl    @xfilm                ; Fill CPU memory
     6D0C 2236 
0308                                                   ; \ i  tmp0 = Target address
0309                                                   ; | i  tmp1 = Byte to fill
0310                                                   ; / i  tmp2 = Repeat count
0311                       ;------------------------------------------------------
0312                       ; Prepare for unpacking data
0313                       ;------------------------------------------------------
0314               edb.line.unpack.prepare:
0315 6D0E C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6D10 8398 
0316 6D12 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0317 6D14 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6D16 8394 
0318 6D18 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6D1A 8396 
0319                       ;------------------------------------------------------
0320                       ; Check before copy
0321                       ;------------------------------------------------------
0322               edb.line.unpack.copy:
0323 6D1C 0286  22         ci    tmp2,80               ; Check line length
     6D1E 0050 
0324 6D20 1204  14         jle   !
0325 6D22 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D24 FFCE 
0326 6D26 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D28 2030 
0327                       ;------------------------------------------------------
0328                       ; Copy memory block
0329                       ;------------------------------------------------------
0330 6D2A 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6D2C 2492 
0331                                                   ; \ i  tmp0 = Source address
0332                                                   ; | i  tmp1 = Target address
0333                                                   ; / i  tmp2 = Bytes to copy
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               edb.line.unpack.exit:
0338 6D2E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0339 6D30 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0340 6D32 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0341 6D34 C2F9  30         mov   *stack+,r11           ; Pop r11
0342 6D36 045B  20         b     *r11                  ; Return to caller
0343               
0344               
0345               
0346               ***************************************************************
0347               * edb.line.getlength
0348               * Get length of specified line
0349               ***************************************************************
0350               *  bl   @edb.line.getlength
0351               *--------------------------------------------------------------
0352               * INPUT
0353               * @parm1 = Line number
0354               *--------------------------------------------------------------
0355               * OUTPUT
0356               * @outparm1 = Length of line
0357               * @outparm2 = SAMS page
0358               *--------------------------------------------------------------
0359               * Register usage
0360               * tmp0,tmp1
0361               *--------------------------------------------------------------
0362               * Remarks
0363               * Expects that the affected SAMS page is already paged-in!
0364               ********|*****|*********************|**************************
0365               edb.line.getlength:
0366 6D38 0649  14         dect  stack
0367 6D3A C64B  30         mov   r11,*stack            ; Push return address
0368 6D3C 0649  14         dect  stack
0369 6D3E C644  30         mov   tmp0,*stack           ; Push tmp0
0370 6D40 0649  14         dect  stack
0371 6D42 C645  30         mov   tmp1,*stack           ; Push tmp1
0372                       ;------------------------------------------------------
0373                       ; Initialisation
0374                       ;------------------------------------------------------
0375 6D44 04E0  34         clr   @outparm1             ; Reset length
     6D46 8360 
0376 6D48 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6D4A 8362 
0377                       ;------------------------------------------------------
0378                       ; Get length
0379                       ;------------------------------------------------------
0380 6D4C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6D4E 6A56 
0381                                                   ; \ i  parm1    = Line number
0382                                                   ; | o  outparm1 = Pointer to line
0383                                                   ; / o  outparm2 = SAMS page
0384               
0385 6D50 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6D52 8360 
0386 6D54 1302  14         jeq   edb.line.getlength.exit
0387                                                   ; Exit early if NULL pointer
0388                       ;------------------------------------------------------
0389                       ; Process line prefix
0390                       ;------------------------------------------------------
0391 6D56 C814  46         mov   *tmp0,@outparm1       ; Save length
     6D58 8360 
0392                       ;------------------------------------------------------
0393                       ; Exit
0394                       ;------------------------------------------------------
0395               edb.line.getlength.exit:
0396 6D5A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0397 6D5C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0398 6D5E C2F9  30         mov   *stack+,r11           ; Pop r11
0399 6D60 045B  20         b     *r11                  ; Return to caller
0400               
0401               
0402               
0403               ***************************************************************
0404               * edb.line.getlength2
0405               * Get length of current row (as seen from editor buffer side)
0406               ***************************************************************
0407               *  bl   @edb.line.getlength2
0408               *--------------------------------------------------------------
0409               * INPUT
0410               * @fb.row = Row in frame buffer
0411               *--------------------------------------------------------------
0412               * OUTPUT
0413               * @fb.row.length = Length of row
0414               *--------------------------------------------------------------
0415               * Register usage
0416               * tmp0
0417               ********|*****|*********************|**************************
0418               edb.line.getlength2:
0419 6D62 0649  14         dect  stack
0420 6D64 C64B  30         mov   r11,*stack            ; Save return address
0421                       ;------------------------------------------------------
0422                       ; Calculate line in editor buffer
0423                       ;------------------------------------------------------
0424 6D66 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6D68 A104 
0425 6D6A A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6D6C A106 
0426                       ;------------------------------------------------------
0427                       ; Get length
0428                       ;------------------------------------------------------
0429 6D6E C804  38         mov   tmp0,@parm1
     6D70 8350 
0430 6D72 06A0  32         bl    @edb.line.getlength
     6D74 6D38 
0431 6D76 C820  54         mov   @outparm1,@fb.row.length
     6D78 8360 
     6D7A A108 
0432                                                   ; Save row length
0433                       ;------------------------------------------------------
0434                       ; Exit
0435                       ;------------------------------------------------------
0436               edb.line.getlength2.exit:
0437 6D7C 0460  28         b     @poprt                ; Return to caller
     6D7E 222C 
0438               
**** **** ****     > stevie_b1.asm.360191
0061                       copy  "cmdb.asm"            ; Command Buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Command Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cmdb.init
0011               * Initialize Command Buffer
0012               ***************************************************************
0013               * bl @cmdb.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * none
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               cmdb.init:
0027 6D80 0649  14         dect  stack
0028 6D82 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6D84 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6D86 D000 
0033 6D88 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6D8A A300 
0034               
0035 6D8C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6D8E A302 
0036 6D90 0204  20         li    tmp0,4
     6D92 0004 
0037 6D94 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6D96 A306 
0038 6D98 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6D9A A308 
0039               
0040 6D9C 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6D9E A316 
0041 6DA0 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6DA2 A318 
0042                       ;------------------------------------------------------
0043                       ; Clear command buffer
0044                       ;------------------------------------------------------
0045 6DA4 06A0  32         bl    @film
     6DA6 2230 
0046 6DA8 D000             data  cmdb.top,>00,cmdb.size
     6DAA 0000 
     6DAC 1000 
0047                                                   ; Clear it all the way
0048               cmdb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6DAE C2F9  30         mov   *stack+,r11           ; Pop r11
0053 6DB0 045B  20         b     *r11                  ; Return to caller
0054               
0055               
0056               
0057               
0058               
0059               
0060               
0061               ***************************************************************
0062               * cmdb.refresh
0063               * Refresh command buffer content
0064               ***************************************************************
0065               * bl @cmdb.refresh
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * none
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               * none
0072               *--------------------------------------------------------------
0073               * Register usage
0074               * none
0075               *--------------------------------------------------------------
0076               * Notes
0077               ********|*****|*********************|**************************
0078               cmdb.refresh:
0079 6DB2 0649  14         dect  stack
0080 6DB4 C64B  30         mov   r11,*stack            ; Save return address
0081 6DB6 0649  14         dect  stack
0082 6DB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0083 6DBA 0649  14         dect  stack
0084 6DBC C645  30         mov   tmp1,*stack           ; Push tmp1
0085 6DBE 0649  14         dect  stack
0086 6DC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0087                       ;------------------------------------------------------
0088                       ; Dump Command buffer content
0089                       ;------------------------------------------------------
0090 6DC2 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6DC4 832A 
     6DC6 A30C 
0091 6DC8 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6DCA A310 
     6DCC 832A 
0092               
0093 6DCE 05A0  34         inc   @wyx                  ; X +1 for prompt
     6DD0 832A 
0094               
0095 6DD2 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6DD4 23F4 
0096                                                   ; \ i  @wyx = Cursor position
0097                                                   ; / o  tmp0 = VDP target address
0098               
0099 6DD6 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6DD8 A31F 
0100 6DDA 0206  20         li    tmp2,1*79             ; Command length
     6DDC 004F 
0101               
0102 6DDE 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6DE0 244A 
0103                                                   ; | i  tmp0 = VDP target address
0104                                                   ; | i  tmp1 = RAM source address
0105                                                   ; / i  tmp2 = Number of bytes to copy
0106                       ;------------------------------------------------------
0107                       ; Show command buffer prompt
0108                       ;------------------------------------------------------
0109 6DE2 C820  54         mov   @cmdb.yxprompt,@wyx
     6DE4 A310 
     6DE6 832A 
0110 6DE8 06A0  32         bl    @putstr
     6DEA 2418 
0111 6DEC 7862                   data txt.cmdb.prompt
0112               
0113 6DEE C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6DF0 A30C 
     6DF2 A114 
0114 6DF4 C820  54         mov   @cmdb.yxsave,@wyx
     6DF6 A30C 
     6DF8 832A 
0115                                                   ; Restore YX position
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119               cmdb.refresh.exit:
0120 6DFA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6DFC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6DFE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6E00 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6E02 045B  20         b     *r11                  ; Return to caller
0125               
0126               
0127               
0128               
0129               
0130               ***************************************************************
0131               * cmdb.cmd.clear
0132               * Clear current command
0133               ***************************************************************
0134               * bl @cmdb.cmd.clear
0135               *--------------------------------------------------------------
0136               * INPUT
0137               * none
0138               *--------------------------------------------------------------
0139               * OUTPUT
0140               * none
0141               *--------------------------------------------------------------
0142               * Register usage
0143               * tmp0,tmp1,tmp2
0144               *--------------------------------------------------------------
0145               * Notes
0146               ********|*****|*********************|**************************
0147               cmdb.cmd.clear:
0148 6E04 0649  14         dect  stack
0149 6E06 C64B  30         mov   r11,*stack            ; Save return address
0150 6E08 0649  14         dect  stack
0151 6E0A C644  30         mov   tmp0,*stack           ; Push tmp0
0152 6E0C 0649  14         dect  stack
0153 6E0E C645  30         mov   tmp1,*stack           ; Push tmp1
0154 6E10 0649  14         dect  stack
0155 6E12 C646  30         mov   tmp2,*stack           ; Push tmp2
0156                       ;------------------------------------------------------
0157                       ; Clear command
0158                       ;------------------------------------------------------
0159 6E14 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E16 A31E 
0160 6E18 06A0  32         bl    @film                 ; Clear command
     6E1A 2230 
0161 6E1C A31F                   data  cmdb.cmd,>00,80
     6E1E 0000 
     6E20 0050 
0162                       ;------------------------------------------------------
0163                       ; Put cursor at beginning of line
0164                       ;------------------------------------------------------
0165 6E22 C120  34         mov   @cmdb.yxprompt,tmp0
     6E24 A310 
0166 6E26 0584  14         inc   tmp0
0167 6E28 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6E2A A30A 
0168               
0169               cmdb.cmd.clear.exit:
0170                       ;------------------------------------------------------
0171                       ; Exit
0172                       ;------------------------------------------------------
0173 6E2C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0174 6E2E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0175 6E30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0176 6E32 C2F9  30         mov   *stack+,r11           ; Pop r11
0177 6E34 045B  20         b     *r11                  ; Return to caller
0178               
0179               
0180               
0181               
0182               
0183               
0184               ***************************************************************
0185               * cmdb.getlength
0186               * Get length of current command
0187               ***************************************************************
0188               * bl @cmdb.getlength
0189               *--------------------------------------------------------------
0190               * INPUT
0191               * @cmdb.cmd
0192               *--------------------------------------------------------------
0193               * OUTPUT
0194               * @cmdb.cmdlen  (Length in MSB)
0195               * @outparm1     (Length in LSB)
0196               *--------------------------------------------------------------
0197               * Register usage
0198               * tmp0
0199               *--------------------------------------------------------------
0200               * Notes
0201               ********|*****|*********************|**************************
0202               cmdb.cmd.getlength:
0203 6E36 0649  14         dect  stack
0204 6E38 C64B  30         mov   r11,*stack            ; Save return address
0205 6E3A 0649  14         dect  stack
0206 6E3C C644  30         mov   tmp0,*stack           ; Push tmp0
0207                       ;-------------------------------------------------------
0208                       ; Get length of null terminated string
0209                       ;-------------------------------------------------------
0210 6E3E 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6E40 2A76 
0211 6E42 A31F                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6E44 0000 
0212                                                  ; | i  p1    = Termination character
0213                                                  ; / o  waux1 = Length of string
0214 6E46 C120  34         mov   @waux1,tmp0
     6E48 833C 
0215 6E4A C804  38         mov   tmp0,@outparm1       ; Save length of string
     6E4C 8360 
0216 6E4E 0A84  56         sla   tmp0,8               ; LSB to MSB
0217 6E50 D804  38         movb  tmp0,@cmdb.cmdlen    ; Save length of string
     6E52 A31E 
0218                       ;------------------------------------------------------
0219                       ; Exit
0220                       ;------------------------------------------------------
0221               cmdb.cmd.getlength.exit:
0222 6E54 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0223 6E56 C2F9  30         mov   *stack+,r11           ; Pop r11
0224 6E58 045B  20         b     *r11                  ; Return to caller
0225               
0226               
**** **** ****     > stevie_b1.asm.360191
0062                       copy  "errline.asm"         ; Error line
**** **** ****     > errline.asm
0001               * FILE......: errline.asm
0002               * Purpose...: Stevie Editor - Error line utilities
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Error line utilities
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * errline.init
0010               * Initialize error line
0011               ***************************************************************
0012               * bl @errline.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               errline.init:
0026 6E5A 0649  14         dect  stack
0027 6E5C C64B  30         mov   r11,*stack            ; Save return address
0028 6E5E 0649  14         dect  stack
0029 6E60 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6E62 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6E64 A01C 
0034               
0035 6E66 06A0  32         bl    @film
     6E68 2230 
0036 6E6A A01E                   data tv.error.msg,0,160
     6E6C 0000 
     6E6E 00A0 
0037               
0038 6E70 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6E72 A000 
0039 6E74 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6E76 A01E 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6E78 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6E7A C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6E7C 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.360191
0063                       ;-----------------------------------------------------------------------
0064                       ; File handling
0065                       ;-----------------------------------------------------------------------
0066                       copy  "fh.read.sams.asm"    ; File handler read file
**** **** ****     > fh.read.sams.asm
0001               * FILE......: fh.read.sams.asm
0002               * Purpose...: File reader module (SAMS implementation)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.read.sams
0011               * Read file with SAMS support
0012               ***************************************************************
0013               *  bl   @fh.file.read.sams
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "Before Open file"
0018               * parm3 = Pointer to callback function "Read line from file"
0019               * parm4 = Pointer to callback function "Close file"
0020               * parm5 = Pointer to callback function "File I/O error"
0021               *--------------------------------------------------------------
0022               * OUTPUT
0023               *--------------------------------------------------------------
0024               * Register usage
0025               * tmp0, tmp1, tmp2
0026               ********|*****|*********************|**************************
0027               fh.file.read.sams:
0028 6E7E 0649  14         dect  stack
0029 6E80 C64B  30         mov   r11,*stack            ; Save return address
0030 6E82 0649  14         dect  stack
0031 6E84 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6E86 0649  14         dect  stack
0033 6E88 C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6E8A 0649  14         dect  stack
0035 6E8C C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6E8E 04E0  34         clr   @fh.records           ; Reset records counter
     6E90 A42E 
0040 6E92 04E0  34         clr   @fh.counter           ; Clear internal counter
     6E94 A434 
0041 6E96 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6E98 A432 
0042 6E9A 04E0  34         clr   @fh.kilobytes.prev    ; /
     6E9C A444 
0043 6E9E 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6EA0 A42A 
0044 6EA2 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6EA4 A42C 
0045               
0046 6EA6 C120  34         mov   @edb.top.ptr,tmp0
     6EA8 A200 
0047 6EAA 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6EAC 24F0 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6EAE C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6EB0 833C 
     6EB2 A438 
0053 6EB4 C820  54         mov   @waux1,@fh.sams.hipage
     6EB6 833C 
     6EB8 A43A 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6EBA C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6EBC 8350 
     6EBE A436 
0059 6EC0 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6EC2 8352 
     6EC4 A43C 
0060 6EC6 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6EC8 8354 
     6ECA A43E 
0061 6ECC C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6ECE 8356 
     6ED0 A440 
0062 6ED2 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6ED4 8358 
     6ED6 A442 
0063                       ;------------------------------------------------------
0064                       ; Sanity check
0065                       ;------------------------------------------------------
0066 6ED8 C120  34         mov   @fh.callback1,tmp0
     6EDA A43C 
0067 6EDC 0284  22         ci    tmp0,>6000            ; Insane address ?
     6EDE 6000 
0068 6EE0 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0069               
0070 6EE2 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6EE4 7FFF 
0071 6EE6 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0072               
0073 6EE8 C120  34         mov   @fh.callback2,tmp0
     6EEA A43E 
0074 6EEC 0284  22         ci    tmp0,>6000            ; Insane address ?
     6EEE 6000 
0075 6EF0 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6EF2 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6EF4 7FFF 
0078 6EF6 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0079               
0080 6EF8 C120  34         mov   @fh.callback3,tmp0
     6EFA A440 
0081 6EFC 0284  22         ci    tmp0,>6000            ; Insane address ?
     6EFE 6000 
0082 6F00 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6F02 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F04 7FFF 
0085 6F06 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0086               
0087 6F08 1004  14         jmp   fh.file.read.sams.load1
0088                                                   ; All checks passed, continue.
0089                                                   ;--------------------------
0090                                                   ; Check failed, crash CPU!
0091                                                   ;--------------------------
0092               fh.file.read.crash:
0093 6F0A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F0C FFCE 
0094 6F0E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F10 2030 
0095                       ;------------------------------------------------------
0096                       ; Callback "Before Open file"
0097                       ;------------------------------------------------------
0098               fh.file.read.sams.load1:
0099 6F12 C120  34         mov   @fh.callback1,tmp0
     6F14 A43C 
0100 6F16 0694  24         bl    *tmp0                 ; Run callback function
0101                       ;------------------------------------------------------
0102                       ; Copy PAB header to VDP
0103                       ;------------------------------------------------------
0104               fh.file.read.sams.pabheader:
0105 6F18 06A0  32         bl    @cpym2v
     6F1A 2444 
0106 6F1C 0A60                   data fh.vpab,fh.file.pab.header,9
     6F1E 7070 
     6F20 0009 
0107                                                   ; Copy PAB header to VDP
0108                       ;------------------------------------------------------
0109                       ; Append file descriptor to PAB header in VDP
0110                       ;------------------------------------------------------
0111 6F22 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6F24 0A69 
0112 6F26 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6F28 A436 
0113 6F2A D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0114 6F2C 0986  56         srl   tmp2,8                ; Right justify
0115 6F2E 0586  14         inc   tmp2                  ; Include length byte as well
0116 6F30 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6F32 244A 
0117                       ;------------------------------------------------------
0118                       ; Load GPL scratchpad layout
0119                       ;------------------------------------------------------
0120 6F34 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6F36 2B3E 
0121 6F38 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0122                       ;------------------------------------------------------
0123                       ; Open file
0124                       ;------------------------------------------------------
0125 6F3A 06A0  32         bl    @file.open
     6F3C 2C8C 
0126 6F3E 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0127 6F40 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6F42 2026 
0128 6F44 1602  14         jne   fh.file.read.sams.record
0129 6F46 0460  28         b     @fh.file.read.sams.error
     6F48 7038 
0130                                                   ; Yes, IO error occured
0131                       ;------------------------------------------------------
0132                       ; Step 1: Read file record
0133                       ;------------------------------------------------------
0134               fh.file.read.sams.record:
0135 6F4A 05A0  34         inc   @fh.records           ; Update counter
     6F4C A42E 
0136 6F4E 04E0  34         clr   @fh.reclen            ; Reset record length
     6F50 A430 
0137               
0138 6F52 06A0  32         bl    @file.record.read     ; Read file record
     6F54 2CCE 
0139 6F56 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0140                                                   ; |           (without +9 offset!)
0141                                                   ; | o  tmp0 = Status byte
0142                                                   ; | o  tmp1 = Bytes read
0143                                                   ; | o  tmp2 = Status register contents
0144                                                   ; /           upon DSRLNK return
0145               
0146 6F58 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6F5A A42A 
0147 6F5C C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6F5E A430 
0148 6F60 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6F62 A42C 
0149                       ;------------------------------------------------------
0150                       ; 1a: Calculate kilobytes processed
0151                       ;------------------------------------------------------
0152 6F64 A805  38         a     tmp1,@fh.counter
     6F66 A434 
0153 6F68 A160  34         a     @fh.counter,tmp1
     6F6A A434 
0154 6F6C 0285  22         ci    tmp1,1024
     6F6E 0400 
0155 6F70 1106  14         jlt   !
0156 6F72 05A0  34         inc   @fh.kilobytes
     6F74 A432 
0157 6F76 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6F78 FC00 
0158 6F7A C805  38         mov   tmp1,@fh.counter
     6F7C A434 
0159                       ;------------------------------------------------------
0160                       ; 1b: Load spectra scratchpad layout
0161                       ;------------------------------------------------------
0162 6F7E 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6F80 2AC4 
0163 6F82 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F84 2B60 
0164 6F86 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0165                       ;------------------------------------------------------
0166                       ; 1c: Check if a file error occured
0167                       ;------------------------------------------------------
0168               fh.file.read.sams.check_fioerr:
0169 6F88 C1A0  34         mov   @fh.ioresult,tmp2
     6F8A A42C 
0170 6F8C 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6F8E 2026 
0171 6F90 1602  14         jne   fh.file.read.sams.check_setpage
0172                                                   ; No, goto (1d)
0173 6F92 0460  28         b     @fh.file.read.sams.error
     6F94 7038 
0174                                                   ; Yes, so handle file error
0175                       ;------------------------------------------------------
0176                       ; 1d: Check if SAMS page needs to be set
0177                       ;------------------------------------------------------
0178               fh.file.read.sams.check_setpage:
0179 6F96 C120  34         mov   @edb.next_free.ptr,tmp0
     6F98 A208 
0180                                                   ;--------------------------
0181                                                   ; Sanity check
0182                                                   ;--------------------------
0183 6F9A 0284  22         ci    tmp0,edb.top + edb.size
     6F9C D000 
0184                                                   ; Insane address ?
0185 6F9E 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0186                                                   ;--------------------------
0187                                                   ; Check overflow
0188                                                   ;--------------------------
0189 6FA0 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6FA2 0FFF 
0190 6FA4 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6FA6 A430 
0191 6FA8 05C4  14         inct  tmp0                  ; +2 for line prefix
0192 6FAA 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6FAC 0FF0 
0193 6FAE 110E  14         jlt   fh.file.read.sams.process_line
0194                                                   ; Not yet so skip SAMS page switch
0195                       ;------------------------------------------------------
0196                       ; 1e: Increase SAMS page
0197                       ;------------------------------------------------------
0198 6FB0 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6FB2 A438 
0199 6FB4 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6FB6 A438 
     6FB8 A43A 
0200                                                   ; Set highest SAMS page
0201 6FBA C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6FBC A200 
     6FBE A208 
0202                                                   ; Start at top of SAMS page again
0203                       ;------------------------------------------------------
0204                       ; 1f: Switch to SAMS page
0205                       ;------------------------------------------------------
0206 6FC0 C120  34         mov   @fh.sams.page,tmp0
     6FC2 A438 
0207 6FC4 C160  34         mov   @edb.top.ptr,tmp1
     6FC6 A200 
0208 6FC8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6FCA 2528 
0209                                                   ; \ i  tmp0 = SAMS page number
0210                                                   ; / i  tmp1 = Memory address
0211                       ;------------------------------------------------------
0212                       ; Step 2: Process line
0213                       ;------------------------------------------------------
0214               fh.file.read.sams.process_line:
0215 6FCC 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6FCE 0960 
0216 6FD0 C160  34         mov   @edb.next_free.ptr,tmp1
     6FD2 A208 
0217                                                   ; RAM target in editor buffer
0218               
0219 6FD4 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6FD6 8352 
0220               
0221 6FD8 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6FDA A430 
0222 6FDC 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0223                                                   ; Handle empty line
0224                       ;------------------------------------------------------
0225                       ; 2a: Copy line from VDP to CPU editor buffer
0226                       ;------------------------------------------------------
0227                                                   ; Put line length word before string
0228 6FDE DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0229 6FE0 06C6  14         swpb  tmp2                  ; |
0230 6FE2 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0231 6FE4 06C6  14         swpb  tmp2                  ; /
0232               
0233 6FE6 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6FE8 A208 
0234 6FEA A806  38         a     tmp2,@edb.next_free.ptr
     6FEC A208 
0235                                                   ; Add line length
0236               
0237 6FEE 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6FF0 2470 
0238                                                   ; \ i  tmp0 = VDP source address
0239                                                   ; | i  tmp1 = RAM target address
0240                                                   ; / i  tmp2 = Bytes to copy
0241                       ;------------------------------------------------------
0242                       ; 2b: Align pointer to multiple of 16 memory address
0243                       ;------------------------------------------------------
0244 6FF2 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6FF4 A208 
0245 6FF6 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0246 6FF8 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6FFA 000F 
0247 6FFC A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6FFE A208 
0248                       ;------------------------------------------------------
0249                       ; Step 3: Update index
0250                       ;------------------------------------------------------
0251               fh.file.read.sams.prepindex:
0252 7000 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7002 A204 
     7004 8350 
0253                                                   ; parm2 = Must allready be set!
0254 7006 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7008 A438 
     700A 8354 
0255               
0256 700C 1009  14         jmp   fh.file.read.sams.updindex
0257                                                   ; Update index
0258                       ;------------------------------------------------------
0259                       ; 3a: Special handling for empty line
0260                       ;------------------------------------------------------
0261               fh.file.read.sams.prepindex.emptyline:
0262 700E C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     7010 A42E 
     7012 8350 
0263 7014 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7016 8350 
0264 7018 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     701A 8352 
0265 701C 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     701E 8354 
0266                       ;------------------------------------------------------
0267                       ; 3b: Do actual index update
0268                       ;------------------------------------------------------
0269               fh.file.read.sams.updindex:
0270 7020 06A0  32         bl    @idx.entry.update     ; Update index
     7022 6A04 
0271                                                   ; \ i  parm1    = Line num in editor buffer
0272                                                   ; | i  parm2    = Pointer to line in editor
0273                                                   ; |               buffer
0274                                                   ; | i  parm3    = SAMS page
0275                                                   ; | o  outparm1 = Pointer to updated index
0276                                                   ; /               entry
0277               
0278 7024 05A0  34         inc   @edb.lines            ; lines=lines+1
     7026 A204 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Callback "Read line from file"
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.display:
0283 7028 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     702A A43E 
0284 702C 0694  24         bl    *tmp0                 ; Run callback function
0285                       ;------------------------------------------------------
0286                       ; 4a: Next record
0287                       ;------------------------------------------------------
0288               fh.file.read.sams.next:
0289 702E 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7030 2B3E 
0290 7032 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0291               
0292 7034 0460  28         b     @fh.file.read.sams.record
     7036 6F4A 
0293                                                   ; Next record
0294                       ;------------------------------------------------------
0295                       ; Error handler
0296                       ;------------------------------------------------------
0297               fh.file.read.sams.error:
0298 7038 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     703A A42A 
0299 703C 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0300 703E 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7040 0005 
0301 7042 1309  14         jeq   fh.file.read.sams.eof
0302                                                   ; All good. File closed by DSRLNK
0303                       ;------------------------------------------------------
0304                       ; File error occured
0305                       ;------------------------------------------------------
0306 7044 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7046 2B60 
0307 7048 3F00                   data scrpad.backup2   ; / >2100->8300
0308               
0309 704A 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     704C 677C 
0310                       ;------------------------------------------------------
0311                       ; Callback "File I/O error"
0312                       ;------------------------------------------------------
0313 704E C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     7050 A442 
0314 7052 0694  24         bl    *tmp0                 ; Run callback function
0315 7054 1008  14         jmp   fh.file.read.sams.exit
0316                       ;------------------------------------------------------
0317                       ; End-Of-File reached
0318                       ;------------------------------------------------------
0319               fh.file.read.sams.eof:
0320 7056 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7058 2B60 
0321 705A 3F00                   data scrpad.backup2   ; / >2100->8300
0322               
0323 705C 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     705E 677C 
0324                       ;------------------------------------------------------
0325                       ; Callback "Close file"
0326                       ;------------------------------------------------------
0327 7060 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7062 A440 
0328 7064 0694  24         bl    *tmp0                 ; Run callback function
0329               *--------------------------------------------------------------
0330               * Exit
0331               *--------------------------------------------------------------
0332               fh.file.read.sams.exit:
0333 7066 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0334 7068 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0335 706A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0336 706C C2F9  30         mov   *stack+,r11           ; Pop R11
0337 706E 045B  20         b     *r11                  ; Return to caller
0338               
0339               
0340               ***************************************************************
0341               * PAB for accessing DV/80 file
0342               ********|*****|*********************|**************************
0343               fh.file.pab.header:
0344 7070 0014             byte  io.op.open            ;  0    - OPEN
0345                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0346 7072 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0347 7074 5000             byte  80                    ;  4    - Record length (80 chars max)
0348                       byte  00                    ;  5    - Character count
0349 7076 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0350 7078 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0351                       ;------------------------------------------------------
0352                       ; File descriptor part (variable length)
0353                       ;------------------------------------------------------
0354                       ; byte  12                  ;  9    - File descriptor length
0355                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0356                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.360191
0067                       copy  "fm.load.asm"         ; File manager loadfile
**** **** ****     > fm.load.asm
0001               * FILE......: fm_load.asm
0002               * Purpose...: High-level file manager module
0003               
0004               *---------------------------------------------------------------
0005               * Load file into editor buffer
0006               *---------------------------------------------------------------
0007               * bl    @fm.loadfile
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * tmp0  = Pointer to length-prefixed string containing both
0011               *         device and filename
0012               ********|*****|*********************|**************************
0013               fm.loadfile:
0014 707A 0649  14         dect  stack
0015 707C C64B  30         mov   r11,*stack            ; Save return address
0016                       ;-------------------------------------------------------
0017                       ; Reset editor
0018                       ;-------------------------------------------------------
0019 707E C804  38         mov   tmp0,@parm1           ; Setup file to load
     7080 8350 
0020 7082 06A0  32         bl    @tv.reset             ; Reset editor
     7084 6760 
0021 7086 C820  54         mov   @parm1,@edb.filename.ptr
     7088 8350 
     708A A20E 
0022                                                   ; Set filename
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 708C 06A0  32         bl    @filv
     708E 2288 
0027 7090 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7092 0000 
     7094 0004 
0028               
0029 7096 C160  34         mov   @fb.scrrows,tmp1
     7098 A118 
0030 709A 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     709C A10E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033               
0034 709E 06A0  32         bl    @scroff               ; Turn off screen
     70A0 2640 
0035               
0036 70A2 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0037 70A4 0205  20         li    tmp1,32               ; Character to fill
     70A6 0020 
0038               
0039 70A8 06A0  32         bl    @xfilv                ; Fill VDP memory
     70AA 228E 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = Byte to fill
0042                                                   ; / i  tmp2 = Bytes to copy
0043               
0044 70AC 06A0  32         bl    @pane.action.colorscheme.Load
     70AE 7398 
0045                                                   ; Load color scheme and turn on screen
0046                       ;-------------------------------------------------------
0047                       ; Read DV80 file and display
0048                       ;-------------------------------------------------------
0049 70B0 0204  20         li    tmp0,fm.loadfile.cb.indicator1
     70B2 70E4 
0050 70B4 C804  38         mov   tmp0,@parm2           ; Register callback 1
     70B6 8352 
0051               
0052 70B8 0204  20         li    tmp0,fm.loadfile.cb.indicator2
     70BA 710C 
0053 70BC C804  38         mov   tmp0,@parm3           ; Register callback 2
     70BE 8354 
0054               
0055 70C0 0204  20         li    tmp0,fm.loadfile.cb.indicator3
     70C2 7142 
0056 70C4 C804  38         mov   tmp0,@parm4           ; Register callback 3
     70C6 8356 
0057               
0058 70C8 0204  20         li    tmp0,fm.loadfile.cb.fioerr
     70CA 7174 
0059 70CC C804  38         mov   tmp0,@parm5           ; Register callback 4
     70CE 8358 
0060               
0061 70D0 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     70D2 6E7E 
0062                                                   ; \ i  parm1 = Pointer to length prefixed
0063                                                   ; |            file descriptor
0064                                                   ; | i  parm2 = Pointer to callback
0065                                                   ; |            "loading indicator 1"
0066                                                   ; | i  parm3 = Pointer to callback
0067                                                   ; |            "loading indicator 2"
0068                                                   ; | i  parm4 = Pointer to callback
0069                                                   ; |            "loading indicator 3"
0070                                                   ; | i  parm5 = Pointer to callback
0071                                                   ; /            "File I/O error handler"
0072               
0073 70D4 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     70D6 A206 
0074                                                   ; longer dirty.
0075               
0076 70D8 0204  20         li    tmp0,txt.filetype.DV80
     70DA 77E0 
0077 70DC C804  38         mov   tmp0,@edb.filetype.ptr
     70DE A210 
0078                                                   ; Set filetype display string
0079               *--------------------------------------------------------------
0080               * Exit
0081               *--------------------------------------------------------------
0082               fm.loadfile.exit:
0083 70E0 0460  28         b     @poprt                ; Return to caller
     70E2 222C 
0084               
0085               
0086               
0087               *---------------------------------------------------------------
0088               * Callback function "Show loading indicator 1"
0089               * Open file
0090               *---------------------------------------------------------------
0091               * Is expected to be passed as parm2 to @tfh.file.read
0092               *---------------------------------------------------------------
0093               fm.loadfile.cb.indicator1:
0094 70E4 0649  14         dect  stack
0095 70E6 C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Show loading indicators and file descriptor
0098                       ;------------------------------------------------------
0099 70E8 06A0  32         bl    @hchar
     70EA 2774 
0100 70EC 1D00                   byte 29,0,32,80
     70EE 2050 
0101 70F0 FFFF                   data EOL
0102               
0103 70F2 06A0  32         bl    @putat
     70F4 243C 
0104 70F6 1D00                   byte 29,0
0105 70F8 77B6                   data txt.loading      ; Display "Loading...."
0106               
0107 70FA 06A0  32         bl    @at
     70FC 2680 
0108 70FE 1D0B                   byte 29,11            ; Cursor YX position
0109 7100 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7102 8350 
0110 7104 06A0  32         bl    @xutst0               ; Display device/filename
     7106 241A 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.cb.indicator1.exit:
0115 7108 0460  28         b     @poprt                ; Return to caller
     710A 222C 
0116               
0117               
0118               
0119               
0120               *---------------------------------------------------------------
0121               * Callback function "Show loading indicator 2"
0122               *---------------------------------------------------------------
0123               * Read line
0124               * Is expected to be passed as parm3 to @tfh.file.read
0125               * Optimized for performance
0126               *---------------------------------------------------------------
0127               fm.loadfile.cb.indicator2:
0128                       ;------------------------------------------------------
0129                       ; Check if updated counters should be displayed
0130                       ;------------------------------------------------------
0131 710C 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     710E A432 
     7110 A444 
0132 7112 1316  14         jeq   !
0133                       ;------------------------------------------------------
0134                       ; Display updated counters
0135                       ;------------------------------------------------------
0136 7114 0649  14         dect  stack
0137 7116 C64B  30         mov   r11,*stack            ; Save return address
0138               
0139 7118 C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     711A A432 
     711C A444 
0140                                                   ; Save for compare
0141               
0142 711E 06A0  32         bl    @putnum
     7120 2A00 
0143 7122 1D4B                   byte 29,75            ; Show lines read
0144 7124 A204                   data edb.lines,rambuf,>3020
     7126 8390 
     7128 3020 
0145               
0146 712A 06A0  32         bl    @putnum
     712C 2A00 
0147 712E 1D38                   byte 29,56            ; Show kilobytes read
0148 7130 A432                   data fh.kilobytes,rambuf,>3020
     7132 8390 
     7134 3020 
0149               
0150 7136 06A0  32         bl    @putat
     7138 243C 
0151 713A 1D3D                   byte 29,61
0152 713C 77C2                   data txt.kb           ; Show "kb" string
0153                       ;------------------------------------------------------
0154                       ; Exit
0155                       ;------------------------------------------------------
0156               fm.loadfile.cb.indicator2.exit:
0157 713E C2F9  30         mov   *stack+,r11           ; Pop R11
0158 7140 045B  20 !       b     *r11                  ; Return to caller
0159               
0160               
0161               
0162               
0163               *---------------------------------------------------------------
0164               * Callback function "Show loading indicator 3"
0165               * Close file
0166               *---------------------------------------------------------------
0167               * Is expected to be passed as parm4 to @tfh.file.read
0168               *---------------------------------------------------------------
0169               fm.loadfile.cb.indicator3:
0170 7142 0649  14         dect  stack
0171 7144 C64B  30         mov   r11,*stack            ; Save return address
0172               
0173 7146 06A0  32         bl    @hchar
     7148 2774 
0174 714A 1D03                   byte 29,3,32,50       ; Erase loading indicator
     714C 2032 
0175 714E FFFF                   data EOL
0176               
0177 7150 06A0  32         bl    @putnum
     7152 2A00 
0178 7154 1D38                   byte 29,56            ; Show kilobytes read
0179 7156 A432                   data fh.kilobytes,rambuf,>3020
     7158 8390 
     715A 3020 
0180               
0181 715C 06A0  32         bl    @putat
     715E 243C 
0182 7160 1D3D                   byte 29,61
0183 7162 77C2                   data txt.kb           ; Show "kb" string
0184               
0185 7164 06A0  32         bl    @putnum
     7166 2A00 
0186 7168 1D4B                   byte 29,75            ; Show lines read
0187 716A A42E                   data fh.records,rambuf,>3020
     716C 8390 
     716E 3020 
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191               fm.loadfile.cb.indicator3.exit:
0192 7170 0460  28         b     @poprt                ; Return to caller
     7172 222C 
0193               
0194               
0195               
0196               *---------------------------------------------------------------
0197               * Callback function "File I/O error handler"
0198               *---------------------------------------------------------------
0199               * Is expected to be passed as parm5 to @tfh.file.read
0200               ********|*****|*********************|**************************
0201               fm.loadfile.cb.fioerr:
0202 7174 0649  14         dect  stack
0203 7176 C64B  30         mov   r11,*stack            ; Save return address
0204               
0205 7178 06A0  32         bl    @hchar
     717A 2774 
0206 717C 1D00                   byte 29,0,32,50       ; Erase loading indicator
     717E 2032 
0207 7180 FFFF                   data EOL
0208                       ;------------------------------------------------------
0209                       ; Build I/O error message
0210                       ;------------------------------------------------------
0211 7182 06A0  32         bl    @cpym2m
     7184 248C 
0212 7186 781B                   data txt.ioerr+1
0213 7188 A01F                   data tv.error.msg+1
0214 718A 0022                   data 34               ; Error message
0215               
0216 718C C120  34         mov   @edb.filename.ptr,tmp0
     718E A20E 
0217 7190 D194  26         movb  *tmp0,tmp2            ; Get length byte
0218 7192 0986  56         srl   tmp2,8                ; Right align
0219 7194 0584  14         inc   tmp0                  ; Skip length byte
0220 7196 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     7198 A03F 
0221               
0222 719A 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     719C 2492 
0223                                                   ; | i  tmp0 = ROM/RAM source
0224                                                   ; | i  tmp1 = RAM destination
0225                                                   ; / i  tmp2 = Bytes top copy
0226                       ;------------------------------------------------------
0227                       ; Reset filename to "new file"
0228                       ;------------------------------------------------------
0229 719E 0204  20         li    tmp0,txt.newfile      ; New file
     71A0 77D4 
0230 71A2 C804  38         mov   tmp0,@edb.filename.ptr
     71A4 A20E 
0231               
0232 71A6 0204  20         li    tmp0,txt.filetype.none
     71A8 77E6 
0233 71AA C804  38         mov   tmp0,@edb.filetype.ptr
     71AC A210 
0234                                                   ; Empty filetype string
0235                       ;------------------------------------------------------
0236                       ; Display I/O error message
0237                       ;------------------------------------------------------
0238 71AE 06A0  32         bl    @pane.errline.show    ; Show error line
     71B0 75A2 
0239                       ;------------------------------------------------------
0240                       ; Exit
0241                       ;------------------------------------------------------
0242               fm.loadfile.cb.fioerr.exit:
0243 71B2 0460  28         b     @poprt                ; Return to caller
     71B4 222C 
**** **** ****     > stevie_b1.asm.360191
0068                       ;-----------------------------------------------------------------------
0069                       ; User hook, background tasks
0070                       ;-----------------------------------------------------------------------
0071                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Keyboard handling (spectra2 user hook)
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011               hook.keyscan:
0012 71B6 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     71B8 2014 
0013 71BA 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 71BC 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     71BE 2014 
0019 71C0 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     71C2 833C 
     71C4 833E 
0020 71C6 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 71C8 C820  54         mov   @waux1,@waux2         ; Save as previous key
     71CA 833C 
     71CC 833E 
0026 71CE 0460  28         b     @edkey.key.process    ; Process key
     71D0 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 71D2 04E0  34         clr   @waux1
     71D4 833C 
0032 71D6 04E0  34         clr   @waux2
     71D8 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 71DA 0204  20         li    tmp0,2000             ; Avoid key bouncing
     71DC 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 71DE 0604  14         dec   tmp0
0043 71E0 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 71E2 0460  28         b     @hookok               ; Return
     71E4 2D16 
**** **** ****     > stevie_b1.asm.360191
0072                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0010               ***************************************************************
0011               task.vdp.panes:
0012                       ;------------------------------------------------------
0013                       ; Command buffer visible ?
0014                       ;------------------------------------------------------
0015 71E6 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     71E8 A302 
0016 71EA 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 71EC C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     71EE A318 
0022 71F0 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 71F2 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     71F4 74A4 
0025 71F6 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     71F8 A318 
0026 71FA 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 71FC C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     71FE A116 
0031 7200 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 7202 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7204 832A 
     7206 A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 7208 8820  54         c     @edb.lines,@fb.scrrows
     720A A204 
     720C A118 
0037 720E 1103  14         jlt   task.vdp.panes.setrows.small
0038 7210 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7212 A118 
0039 7214 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 7216 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7218 A204 
0045 721A 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 721C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     721E A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 7220 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 7222 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7224 A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 7226 06A0  32         bl    @xpym2v               ; Copy to VDP
     7228 244A 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 722A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     722C A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 722E C120  34         mov   @edb.lines,tmp0
     7230 A204 
0066 7232 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7234 A104 
0067 7236 0584  14         inc   tmp0                  ; Y = Y + 1
0068 7238 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     723A A118 
0069 723C 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 723E 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 7240 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7242 832A 
0077               
0078 7244 06A0  32         bl    @putstr
     7246 2418 
0079 7248 77A0                   data txt.marker       ; Display *EOF*
0080               
0081 724A 06A0  32         bl    @setx
     724C 2696 
0082 724E 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 7250 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     7252 A10E 
0088               
0089 7254 C160  34         mov   @wyx,tmp1             ;
     7256 832A 
0090 7258 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 725A 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 725C A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     725E A118 
0093               
0094 7260 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 7262 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     7264 FFFB 
0096               
0097 7266 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7268 23F4 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 726A 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 726C 06A0  32         bl    @xfilv                ; Fill VDP memory
     726E 228E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 7270 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7272 A114 
     7274 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 7276 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     7278 75E8 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 727A 0460  28         b     @slotok
     727C 2D92 
**** **** ****     > stevie_b1.asm.360191
0073                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: Stevie Editor - VDP copy SAT
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
0010               ********|*****|*********************|**************************
0011               task.vdp.copy.sat:
0012 727E C120  34         mov   @tv.pane.focus,tmp0
     7280 A01A 
0013 7282 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 7284 0284  22         ci    tmp0,pane.focus.cmdb
     7286 0001 
0016 7288 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 728A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     728C FFCE 
0022 728E 06A0  32         bl    @cpu.crash            ; / Halt system.
     7290 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7292 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7294 A30A 
     7296 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7298 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     729A 202A 
0032 729C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     729E 26A2 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 72A0 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     72A2 8380 
0036               
0037 72A4 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     72A6 2444 
0038 72A8 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     72AA 8380 
     72AC 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 72AE 0460  28         b     @slotok               ; Exit task
     72B0 2D92 
**** **** ****     > stevie_b1.asm.360191
0074                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: Stevie Editor - VDP sprite cursor
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Update cursor shape (blink)
0010               ***************************************************************
0011               task.vdp.cursor:
0012 72B2 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     72B4 A112 
0013 72B6 1303  14         jeq   task.vdp.cursor.visible
0014 72B8 04E0  34         clr   @ramsat+2              ; Hide cursor
     72BA 8382 
0015 72BC 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 72BE C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     72C0 A20A 
0019 72C2 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 72C4 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     72C6 A01A 
0025 72C8 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 72CA 0284  22         ci    tmp0,pane.focus.cmdb
     72CC 0001 
0028 72CE 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 72D0 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 72D2 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 72D4 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     72D6 0100 
0040 72D8 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 72DA 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     72DC 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 72DE D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     72E0 A014 
0051 72E2 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     72E4 A014 
     72E6 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 72E8 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     72EA 2444 
0057 72EC 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     72EE 8380 
     72F0 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 72F2 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     72F4 A302 
0064 72F6 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 72F8 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     72FA 75E8 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 72FC 0460  28         b     @slotok                ; Exit task
     72FE 2D92 
**** **** ****     > stevie_b1.asm.360191
0075                       ;-----------------------------------------------------------------------
0076                       ; Screen pane utilities
0077                       ;-----------------------------------------------------------------------
0078                       copy  "pane.utils.asm"      ; Pane utility functions
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
0003               
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *              Stevie Editor - Pane utility functions
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * pane.show_hintx
0011               * Show hint message
0012               ***************************************************************
0013               * bl  @pane.hint
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Cursor YX position
0017               * parm2 = Pointer to Length-prefixed string
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * none
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0, tmp1, tmp2
0024               ********|*****|*********************|**************************
0025               pane.show_hintx:
0026 7300 0649  14         dect  stack
0027 7302 C64B  30         mov   r11,*stack            ; Save return address
0028 7304 0649  14         dect  stack
0029 7306 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7308 0649  14         dect  stack
0031 730A C645  30         mov   tmp1,*stack           ; Push tmp1
0032 730C 0649  14         dect  stack
0033 730E C646  30         mov   tmp2,*stack           ; Push tmp2
0034 7310 0649  14         dect  stack
0035 7312 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 7314 C820  54         mov   @parm1,@wyx           ; Set cursor
     7316 8350 
     7318 832A 
0040 731A C160  34         mov   @parm2,tmp1           ; Get string to display
     731C 8352 
0041 731E 06A0  32         bl    @xutst0               ; Display string
     7320 241A 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 7322 C120  34         mov   @parm2,tmp0
     7324 8352 
0046 7326 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 7328 0984  56         srl   tmp0,8                ; Right justify
0048 732A C184  18         mov   tmp0,tmp2
0049 732C C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 732E 0506  16         neg   tmp2
0051 7330 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7332 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 7334 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7336 8350 
0056 7338 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 733A C804  38         mov   tmp0,@wyx             ; / Set cursor
     733C 832A 
0058               
0059 733E 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7340 23F4 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 7342 0205  20         li    tmp1,32               ; Byte to fill
     7344 0020 
0064               
0065 7346 06A0  32         bl    @xfilv                ; Clear line
     7348 228E 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 734A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 734C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 734E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 7350 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 7352 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7354 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               
0082               ***************************************************************
0083               * pane.show_hint
0084               * Show hint message (data parameter version)
0085               ***************************************************************
0086               * bl  @pane.hint
0087               *     data parm1,parm2
0088               *--------------------------------------------------------------
0089               * INPUT
0090               * parm1 = Cursor YX position
0091               * parm2 = Pointer to Length-prefixed string
0092               *--------------------------------------------------------------
0093               * OUTPUT
0094               * none
0095               *--------------------------------------------------------------
0096               * Register usage
0097               * none
0098               ********|*****|*********************|**************************
0099               pane.show_hint:
0100 7356 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7358 8350 
0101 735A C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     735C 8352 
0102 735E 0649  14         dect  stack
0103 7360 C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 7362 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7364 7300 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 7366 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 7368 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0079                       copy  "pane.utils.colorscheme.asm"
**** **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Colorscheme for panes
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.action.color.cycle
0010               * Cycle through available color scheme
0011               ***************************************************************
0012               * bl  @pane.action.colorscheme.cycle
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.action.colorscheme.cycle:
0021 736A 0649  14         dect  stack
0022 736C C64B  30         mov   r11,*stack            ; Push return address
0023 736E 0649  14         dect  stack
0024 7370 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7372 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7374 A012 
0027 7376 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     7378 0008 
0028                                                   ; Last entry reached?
0029 737A 1102  14         jlt   !
0030 737C 04C4  14         clr   tmp0
0031 737E 1001  14         jmp   pane.action.colorscheme.switch
0032 7380 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 7382 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7384 A012 
0038 7386 06A0  32         bl    @pane.action.colorscheme.load
     7388 7398 
0039                       ;-------------------------------------------------------
0040                       ; Delay
0041                       ;-------------------------------------------------------
0042 738A 0204  20         li    tmp0,12000
     738C 2EE0 
0043 738E 0604  14 !       dec   tmp0
0044 7390 16FE  14         jne   -!
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               pane.action.colorscheme.cycle.exit:
0049 7392 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0050 7394 C2F9  30         mov   *stack+,r11           ; Pop R11
0051 7396 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * pane.action.colorscheme.load
0059               * Load color scheme
0060               ***************************************************************
0061               * bl  @pane.action.colorscheme.load
0062               *--------------------------------------------------------------
0063               * INPUT
0064               * @tv.colorscheme = Index into color scheme table
0065               *--------------------------------------------------------------
0066               * OUTPUT
0067               * none
0068               *--------------------------------------------------------------
0069               * Register usage
0070               * tmp0,tmp1,tmp2,tmp3,tmp4
0071               ********|*****|*********************|**************************
0072               pane.action.colorscheme.load:
0073 7398 0649  14         dect  stack
0074 739A C64B  30         mov   r11,*stack            ; Save return address
0075 739C 0649  14         dect  stack
0076 739E C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73A0 0649  14         dect  stack
0078 73A2 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73A4 0649  14         dect  stack
0080 73A6 C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73A8 0649  14         dect  stack
0082 73AA C647  30         mov   tmp3,*stack           ; Push tmp3
0083 73AC 0649  14         dect  stack
0084 73AE C648  30         mov   tmp4,*stack           ; Push tmp4
0085 73B0 06A0  32         bl    @scroff               ; Turn screen off
     73B2 2640 
0086                       ;-------------------------------------------------------
0087                       ; Get framebuffer foreground/background color
0088                       ;-------------------------------------------------------
0089 73B4 C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     73B6 A012 
0090 73B8 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0091 73BA 0224  22         ai    tmp0,tv.colorscheme.table
     73BC 777A 
0092                                                   ; Add base for color scheme data table
0093 73BE C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0094 73C0 C807  38         mov   tmp3,@tv.color        ; Save colors
     73C2 A018 
0095                       ;-------------------------------------------------------
0096                       ; Get and save cursor color
0097                       ;-------------------------------------------------------
0098 73C4 C214  26         mov   *tmp0,tmp4            ; Get cursor color
0099 73C6 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     73C8 00FF 
0100 73CA C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     73CC A016 
0101                       ;-------------------------------------------------------
0102                       ; Get CMDB pane foreground/background color
0103                       ;-------------------------------------------------------
0104 73CE C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0105 73D0 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     73D2 FF00 
0106 73D4 0988  56         srl   tmp4,8                ; MSB to LSB
0107                       ;-------------------------------------------------------
0108                       ; Dump colors to VDP register 7 (text mode)
0109                       ;-------------------------------------------------------
0110 73D6 C147  18         mov   tmp3,tmp1             ; Get work copy
0111 73D8 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0112 73DA 0265  22         ori   tmp1,>0700
     73DC 0700 
0113 73DE C105  18         mov   tmp1,tmp0
0114 73E0 06A0  32         bl    @putvrx               ; Write VDP register
     73E2 232E 
0115                       ;-------------------------------------------------------
0116                       ; Dump colors for frame buffer pane (TAT)
0117                       ;-------------------------------------------------------
0118 73E4 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     73E6 1800 
0119 73E8 C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0120 73EA 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0121 73EC 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     73EE 0910 
0122 73F0 06A0  32         bl    @xfilv                ; Fill colors
     73F2 228E 
0123                                                   ; i \  tmp0 = start address
0124                                                   ; i |  tmp1 = byte to fill
0125                                                   ; i /  tmp2 = number of bytes to fill
0126                       ;-------------------------------------------------------
0127                       ; Dump colors for CMDB pane (TAT)
0128                       ;-------------------------------------------------------
0129               pane.action.colorscheme.cmdbpane:
0130 73F4 C120  34         mov   @cmdb.visible,tmp0
     73F6 A302 
0131 73F8 1307  14         jeq   pane.action.colorscheme.errpane
0132                                                   ; Skip if CMDB pane is hidden
0133               
0134 73FA 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     73FC 1FD0 
0135 73FE C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0136 7400 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     7402 0190 
0137 7404 06A0  32         bl    @xfilv                ; Fill colors
     7406 228E 
0138                                                   ; i \  tmp0 = start address
0139                                                   ; i |  tmp1 = byte to fill
0140                                                   ; i /  tmp2 = number of bytes to fill
0141                       ;-------------------------------------------------------
0142                       ; Dump colors for error line pane (TAT)
0143                       ;-------------------------------------------------------
0144               pane.action.colorscheme.errpane:
0145 7408 C120  34         mov   @tv.error.visible,tmp0
     740A A01C 
0146 740C 1304  14         jeq   pane.action.colorscheme.statusline
0147                                                   ; Skip if error line pane is hidden
0148               
0149 740E 0205  20         li    tmp1,>00f6            ; White on dark red
     7410 00F6 
0150 7412 06A0  32         bl    @pane.action.colorscheme.errline
     7414 7448 
0151                                                   ; Load color combination for error line
0152                       ;-------------------------------------------------------
0153                       ; Dump colors for bottom status line pane (TAT)
0154                       ;-------------------------------------------------------
0155               pane.action.colorscheme.statusline:
0156 7416 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     7418 2110 
0157 741A C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0158 741C 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     741E 00FF 
0159 7420 0206  20         li    tmp2,80               ; Number of bytes to fill
     7422 0050 
0160 7424 06A0  32         bl    @xfilv                ; Fill colors
     7426 228E 
0161                                                   ; i \  tmp0 = start address
0162                                                   ; i |  tmp1 = byte to fill
0163                                                   ; i /  tmp2 = number of bytes to fill
0164                       ;-------------------------------------------------------
0165                       ; Dump cursor FG color to sprite table (SAT)
0166                       ;-------------------------------------------------------
0167               pane.action.colorscheme.cursorcolor:
0168 7428 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     742A A016 
0169 742C 0A88  56         sla   tmp4,8                ; Move to MSB
0170 742E D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7430 8383 
0171 7432 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7434 A015 
0172                       ;-------------------------------------------------------
0173                       ; Exit
0174                       ;-------------------------------------------------------
0175               pane.action.colorscheme.load.exit:
0176 7436 06A0  32         bl    @scron                ; Turn screen on
     7438 2648 
0177 743A C239  30         mov   *stack+,tmp4          ; Pop tmp4
0178 743C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0179 743E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0180 7440 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 7442 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 7444 C2F9  30         mov   *stack+,r11           ; Pop R11
0183 7446 045B  20         b     *r11                  ; Return to caller
0184               
0185               
0186               
0187               ***************************************************************
0188               * pane.action.colorscheme.errline
0189               * Load color scheme for error line
0190               ***************************************************************
0191               * bl  @pane.action.colorscheme.errline
0192               *--------------------------------------------------------------
0193               * INPUT
0194               * @tmp1 = Foreground / Background color
0195               *--------------------------------------------------------------
0196               * OUTPUT
0197               * none
0198               *--------------------------------------------------------------
0199               * Register usage
0200               * tmp0,tmp1,tmp2
0201               ********|*****|*********************|**************************
0202               pane.action.colorscheme.errline:
0203 7448 0649  14         dect  stack
0204 744A C64B  30         mov   r11,*stack            ; Save return address
0205 744C 0649  14         dect  stack
0206 744E C644  30         mov   tmp0,*stack           ; Push tmp0
0207 7450 0649  14         dect  stack
0208 7452 C645  30         mov   tmp1,*stack           ; Push tmp1
0209 7454 0649  14         dect  stack
0210 7456 C646  30         mov   tmp2,*stack           ; Push tmp2
0211                       ;-------------------------------------------------------
0212                       ; Load error line colors
0213                       ;-------------------------------------------------------
0214 7458 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     745A 20C0 
0215 745C 0206  20         li    tmp2,80               ; Number of bytes to fill
     745E 0050 
0216 7460 06A0  32         bl    @xfilv                ; Fill colors
     7462 228E 
0217                                                   ; i \  tmp0 = start address
0218                                                   ; i |  tmp1 = byte to fill
0219                                                   ; i /  tmp2 = number of bytes to fill
0220                       ;-------------------------------------------------------
0221                       ; Exit
0222                       ;-------------------------------------------------------
0223               pane.action.colorscheme.errline.exit:
0224 7464 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0225 7466 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0226 7468 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0227 746A C2F9  30         mov   *stack+,r11           ; Pop R11
0228 746C 045B  20         b     *r11                  ; Return to caller
0229               
**** **** ****     > stevie_b1.asm.360191
0080                                                   ; Colorscheme handling in panes
0081                       copy  "pane.utils.tipiclock.asm"
**** **** ****     > pane.utils.tipiclock.asm
0001               * FILE......: pane.utils.tipiclock.asm
0002               * Purpose...: Stevie Editor - TIPI Clock
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - TIPI Clock
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.tipi.clock
0010               * Read tipi clock and display in bottom line
0011               ***************************************************************
0012               * bl  @pane.action.tipi.clock
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               pane.tipi.clock:
0021 746E 0649  14         dect  stack
0022 7470 C64B  30         mov   r11,*stack            ; Push return address
0023 7472 0649  14         dect  stack
0024 7474 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 7476 0204  20         li    tmp0,fdname.clock
     7478 798E 
0029 747A C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     747C 8350 
0030               
0031 747E 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     7480 74A0 
0032 7482 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7484 8352 
0033 7486 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7488 8354 
0034 748A C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     748C 8358 
0035               
0036 748E 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     7490 74A2 
0037 7492 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7494 8356 
0038               
0039 7496 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     7498 6E7E 
0040                                                   ; \ i  parm1 = Pointer to length prefixed
0041                                                   ; |            file descriptor
0042                                                   ; | i  parm2 = Pointer to callback
0043                                                   ; |            "loading indicator 1"
0044                                                   ; | i  parm3 = Pointer to callback
0045                                                   ; |            "loading indicator 2"
0046                                                   ; | i  parm4 = Pointer to callback
0047                                                   ; |            "loading indicator 3"
0048                                                   ; | i  parm5 = Pointer to callback
0049                                                   ; /            "File I/O error handler"
0050               
0051                       ;-------------------------------------------------------
0052                       ; Exit
0053                       ;-------------------------------------------------------
0054               pane.tipi.clock.exit:
0055 749A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 749C C2F9  30         mov   *stack+,r11           ; Pop R11
0057 749E 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               ***************************************************************
0061               * _pane.tipi.clock.cb.noop
0062               * Dummy callback function
0063               ***************************************************************
0064               * bl @_pane.tipi.clock.cb.noop
0065               *--------------------------------------------------------------
0066               *  Remarks
0067               *  Private, only to be called from _pane.tipi.clock
0068               *--------------------------------------------------------------
0069               _pane.tipi.clock.cb.noop:
0070 74A0 069B  24         bl    *r11                  ; Return to caller
0071               
0072               
0073               ***************************************************************
0074               * _pane.tipi.clock.cb.datetime
0075               * Display clock in bottom status line
0076               ***************************************************************
0077               * bl @_pane.tipi.clock.cb.datetime
0078               *--------------------------------------------------------------
0079               *  Remarks
0080               *  Private, only to be called from _pane.action.tipi.clock
0081               *--------------------------------------------------------------
0082               _pane.tipi.clock.cb.datetime:
0083 74A2 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0082                                                   ; TIPI clock
0083                       ;-----------------------------------------------------------------------
0084                       ; Screen panes
0085                       ;-----------------------------------------------------------------------
0086                       copy  "pane.cmdb.asm"       ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Command Buffer pane
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.cmdb.draw
0010               * Draw stevie Command Buffer
0011               ***************************************************************
0012               * bl  @pane.cmdb.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.cmdb.draw:
0021 74A4 0649  14         dect  stack
0022 74A6 C64B  30         mov   r11,*stack            ; Save return address
0023 74A8 0649  14         dect  stack
0024 74AA C644  30         mov   tmp0,*stack           ; Push tmp0
0025 74AC 0649  14         dect  stack
0026 74AE C645  30         mov   tmp1,*stack           ; Push tmp1
0027 74B0 0649  14         dect  stack
0028 74B2 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 74B4 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     74B6 A30E 
     74B8 832A 
0033 74BA C160  34         mov   @cmdb.pantitle,tmp1   ; | Display pane title
     74BC A31A 
0034 74BE 06A0  32         bl    @xutst0               ; /
     74C0 241A 
0035               
0036 74C2 06A0  32         bl    @setx
     74C4 2696 
0037 74C6 000E                   data 14               ; Position cursor
0038               
0039 74C8 06A0  32         bl    @putstr               ; Display horizontal line
     74CA 2418 
0040 74CC 789C                   data txt.cmdb.hbar
0041                       ;------------------------------------------------------
0042                       ; Clear lines after prompt in command buffer
0043                       ;------------------------------------------------------
0044 74CE C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     74D0 A31E 
0045 74D2 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0046 74D4 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     74D6 A310 
0047 74D8 C804  38         mov   tmp0,@wyx             ; /
     74DA 832A 
0048               
0049 74DC 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     74DE 23F4 
0050                                                   ; \ i  @wyx = Cursor position
0051                                                   ; / o  tmp0 = VDP target address
0052               
0053 74E0 0205  20         li    tmp1,32
     74E2 0020 
0054               
0055 74E4 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     74E6 A31E 
0056 74E8 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0057 74EA 0506  16         neg   tmp2                  ; | Based on command & prompt length
0058 74EC 0226  22         ai    tmp2,2*80 - 1         ; /
     74EE 009F 
0059               
0060 74F0 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     74F2 228E 
0061                                                   ; | i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = Byte to fill
0063                                                   ; / i  tmp2 = Number of bytes to fill
0064                       ;------------------------------------------------------
0065                       ; Display pane hint in command buffer
0066                       ;------------------------------------------------------
0067 74F4 0204  20         li    tmp0,>1c00            ; Y=28, X=0
     74F6 1C00 
0068 74F8 C804  38         mov   tmp0,@parm1           ; Set parameter
     74FA 8350 
0069 74FC C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     74FE A31C 
     7500 8352 
0070               
0071 7502 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7504 7300 
0072                                                   ; \ i  parm1 = Pointer to string with hint
0073                                                   ; / i  parm2 = YX position
0074                       ;------------------------------------------------------
0075                       ; Display keys in status line
0076                       ;------------------------------------------------------
0077 7506 06A0  32         bl    @pane.show_hint       ; Display pane hint
     7508 7356 
0078 750A 1D00                   byte  29,0            ; Y = 29, X=0
0079 750C 77EC                   data  txt.keys.loaddv80
0080                       ;------------------------------------------------------
0081                       ; Command buffer content
0082                       ;------------------------------------------------------
0083 750E 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7510 6DB2 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.cmdb.exit:
0088 7512 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0089 7514 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0090 7516 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 7518 C2F9  30         mov   *stack+,r11           ; Pop r11
0092 751A 045B  20         b     *r11                  ; Return
0093               
0094               
0095               ***************************************************************
0096               * pane.cmdb.show
0097               * Show command buffer pane
0098               ***************************************************************
0099               * bl @pane.cmdb.show
0100               *--------------------------------------------------------------
0101               * INPUT
0102               * none
0103               *--------------------------------------------------------------
0104               * OUTPUT
0105               * none
0106               *--------------------------------------------------------------
0107               * Register usage
0108               * none
0109               *--------------------------------------------------------------
0110               * Notes
0111               ********|*****|*********************|**************************
0112               pane.cmdb.show:
0113 751C 0649  14         dect  stack
0114 751E C64B  30         mov   r11,*stack            ; Save return address
0115 7520 0649  14         dect  stack
0116 7522 C644  30         mov   tmp0,*stack           ; Push tmp0
0117                       ;------------------------------------------------------
0118                       ; Show command buffer pane
0119                       ;------------------------------------------------------
0120 7524 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7526 832A 
     7528 A304 
0121                                                   ; Save YX position in frame buffer
0122               
0123 752A C120  34         mov   @fb.scrrows.max,tmp0
     752C A11A 
0124 752E 6120  34         s     @cmdb.scrrows,tmp0
     7530 A306 
0125 7532 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7534 A118 
0126               
0127 7536 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0128 7538 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     753A A30E 
0129               
0130 753C 0224  22         ai    tmp0,>0100
     753E 0100 
0131 7540 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7542 A310 
0132 7544 0584  14         inc   tmp0
0133 7546 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7548 A30A 
0134               
0135 754A 0720  34         seto  @cmdb.visible         ; Show pane
     754C A302 
0136 754E 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7550 A318 
0137               
0138 7552 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7554 0001 
0139 7556 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7558 A01A 
0140               
0141 755A 06A0  32         bl    @cmdb.cmd.clear;      ; Clear current command
     755C 6E04 
0142               
0143 755E 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7560 75D4 
0144               
0145 7562 06A0  32         bl    @pane.action.colorscheme.load
     7564 7398 
0146                                                   ; Reload colorscheme
0147               pane.cmdb.show.exit:
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151 7566 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0152 7568 C2F9  30         mov   *stack+,r11           ; Pop r11
0153 756A 045B  20         b     *r11                  ; Return to caller
0154               
0155               
0156               
0157               ***************************************************************
0158               * pane.cmdb.hide
0159               * Hide command buffer pane
0160               ***************************************************************
0161               * bl @pane.cmdb.hide
0162               *--------------------------------------------------------------
0163               * INPUT
0164               * none
0165               *--------------------------------------------------------------
0166               * OUTPUT
0167               * none
0168               *--------------------------------------------------------------
0169               * Register usage
0170               * none
0171               *--------------------------------------------------------------
0172               * Hiding the command buffer automatically passes pane focus
0173               * to frame buffer.
0174               ********|*****|*********************|**************************
0175               pane.cmdb.hide:
0176 756C 0649  14         dect  stack
0177 756E C64B  30         mov   r11,*stack            ; Save return address
0178                       ;------------------------------------------------------
0179                       ; Hide command buffer pane
0180                       ;------------------------------------------------------
0181 7570 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7572 A11A 
     7574 A118 
0182                       ;------------------------------------------------------
0183                       ; Adjust frame buffer size if error pane visible
0184                       ;------------------------------------------------------
0185 7576 C820  54         mov   @tv.error.visible,@tv.error.visible
     7578 A01C 
     757A A01C 
0186 757C 1302  14         jeq   !
0187 757E 0620  34         dec   @fb.scrrows
     7580 A118 
0188                       ;------------------------------------------------------
0189                       ; Clear error/hint & status line
0190                       ;------------------------------------------------------
0191 7582 06A0  32 !       bl    @hchar
     7584 2774 
0192 7586 1C00                   byte 28,0,32,80*2
     7588 20A0 
0193 758A FFFF                   data EOL
0194                       ;------------------------------------------------------
0195                       ; Hide command buffer pane (rest)
0196                       ;------------------------------------------------------
0197 758C C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     758E A304 
     7590 832A 
0198 7592 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7594 A302 
0199 7596 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7598 A116 
0200 759A 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     759C A01A 
0201                       ;------------------------------------------------------
0202                       ; Exit
0203                       ;------------------------------------------------------
0204               pane.cmdb.hide.exit:
0205 759E C2F9  30         mov   *stack+,r11           ; Pop r11
0206 75A0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0087                       copy  "pane.errline.asm"    ; Error line
**** **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Stevie Editor - Error line pane
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Error line pane
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.errline.show
0010               * Show command buffer pane
0011               ***************************************************************
0012               * bl @pane.errline.show
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1
0022               *--------------------------------------------------------------
0023               * Notes
0024               ********|*****|*********************|**************************
0025               pane.errline.show:
0026 75A2 0649  14         dect  stack
0027 75A4 C64B  30         mov   r11,*stack            ; Save return address
0028 75A6 0649  14         dect  stack
0029 75A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 75AA 0649  14         dect  stack
0031 75AC C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 75AE 0205  20         li    tmp1,>00f6            ; White on dark red
     75B0 00F6 
0034 75B2 06A0  32         bl    @pane.action.colorscheme.errline
     75B4 7448 
0035                       ;------------------------------------------------------
0036                       ; Show error line content
0037                       ;------------------------------------------------------
0038 75B6 06A0  32         bl    @putat                ; Display error message
     75B8 243C 
0039 75BA 1C00                   byte 28,0
0040 75BC A01E                   data tv.error.msg
0041               
0042 75BE C120  34         mov   @fb.scrrows.max,tmp0
     75C0 A11A 
0043 75C2 0604  14         dec   tmp0
0044 75C4 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     75C6 A118 
0045               
0046 75C8 0720  34         seto  @tv.error.visible     ; Error line is visible
     75CA A01C 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               pane.errline.show.exit:
0051 75CC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 75CE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 75D0 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 75D2 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               ***************************************************************
0059               * pane.errline.hide
0060               * Hide error line
0061               ***************************************************************
0062               * bl @pane.errline.hide
0063               *--------------------------------------------------------------
0064               * INPUT
0065               * none
0066               *--------------------------------------------------------------
0067               * OUTPUT
0068               * none
0069               *--------------------------------------------------------------
0070               * Register usage
0071               * none
0072               *--------------------------------------------------------------
0073               * Hiding the error line passes pane focus to frame buffer.
0074               ********|*****|*********************|**************************
0075               pane.errline.hide:
0076 75D4 0649  14         dect  stack
0077 75D6 C64B  30         mov   r11,*stack            ; Save return address
0078                       ;------------------------------------------------------
0079                       ; Hide command buffer pane
0080                       ;------------------------------------------------------
0081 75D8 06A0  32 !       bl    @errline.init         ; Clear error line
     75DA 6E5A 
0082 75DC C160  34         mov   @tv.color,tmp1        ; Get foreground/background color
     75DE A018 
0083 75E0 06A0  32         bl    @pane.action.colorscheme.errline
     75E2 7448 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.errline.hide.exit:
0088 75E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 75E6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.360191
0088                       copy  "pane.botline.asm"    ; Status line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Stevie Editor - Pane status bottom line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Pane status bottom line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.botline.draw
0010               * Draw Stevie status bottom line
0011               ***************************************************************
0012               * bl  @pane.botline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.botline.draw:
0021 75E8 0649  14         dect  stack
0022 75EA C64B  30         mov   r11,*stack            ; Save return address
0023 75EC 0649  14         dect  stack
0024 75EE C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 75F0 C820  54         mov   @wyx,@fb.yxsave
     75F2 832A 
     75F4 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 75F6 06A0  32         bl    @putat
     75F8 243C 
0032 75FA 1D00                   byte  29,0
0033 75FC 77D0                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 75FE 06A0  32         bl    @at
     7600 2680 
0039 7602 1D03                   byte  29,3            ; Position cursor
0040 7604 C160  34         mov   @edb.filename.ptr,tmp1
     7606 A20E 
0041                                                   ; Get string to display
0042 7608 06A0  32         bl    @xutst0               ; Display string
     760A 241A 
0043               
0044 760C 06A0  32         bl    @at
     760E 2680 
0045 7610 1D2C                   byte  29,44           ; Position cursor
0046               
0047 7612 C160  34         mov   @edb.filetype.ptr,tmp1
     7614 A210 
0048                                                   ; Get string to display
0049 7616 06A0  32         bl    @xutst0               ; Display Filetype string
     7618 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 761A C120  34         mov   @edb.insmode,tmp0
     761C A20A 
0055 761E 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 7620 06A0  32         bl    @putat
     7622 243C 
0061 7624 1D32                   byte  29,50
0062 7626 77AC                   data  txt.ovrwrite
0063 7628 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 762A 06A0  32         bl    @putat
     762C 243C 
0069 762E 1D32                   byte  29,50
0070 7630 77B0                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7632 C120  34         mov   @edb.dirty,tmp0
     7634 A206 
0076 7636 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7638 06A0  32         bl    @putat
     763A 243C 
0081 763C 1D36                   byte 29,54
0082 763E 77B4                   data txt.star
0083 7640 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7642 1000  14         nop
0089               pane.botline.show_linecol:
0090 7644 C820  54         mov   @fb.row,@parm1
     7646 A106 
     7648 8350 
0091 764A 06A0  32         bl    @fb.row2line
     764C 681A 
0092 764E 05A0  34         inc   @outparm1
     7650 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7652 06A0  32         bl    @putnum
     7654 2A00 
0097 7656 1D40                   byte  29,64           ; YX
0098 7658 8360                   data  outparm1,rambuf
     765A 8390 
0099 765C 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 765E 06A0  32         bl    @putat
     7660 243C 
0105 7662 1D45                   byte  29,69
0106 7664 779E                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 7666 06A0  32         bl    @film
     7668 2230 
0111 766A 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     766C 0020 
     766E 000C 
0112               
0113 7670 C820  54         mov   @fb.column,@waux1
     7672 A10C 
     7674 833C 
0114 7676 05A0  34         inc   @waux1                ; Offset 1
     7678 833C 
0115               
0116 767A 06A0  32         bl    @mknum                ; Convert unsigned number to string
     767C 2982 
0117 767E 833C                   data  waux1,rambuf
     7680 8390 
0118 7682 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 7684 06A0  32         bl    @trimnum              ; Trim number to the left
     7686 29DA 
0122 7688 8390                   data  rambuf,rambuf+6,32
     768A 8396 
     768C 0020 
0123               
0124 768E 0204  20         li    tmp0,>0200
     7690 0200 
0125 7692 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7694 8396 
0126               
0127 7696 06A0  32         bl    @putat
     7698 243C 
0128 769A 1D46                   byte 29,70
0129 769C 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 769E C820  54         mov   @fb.row,@parm1
     76A0 A106 
     76A2 8350 
0134 76A4 06A0  32         bl    @fb.row2line
     76A6 681A 
0135 76A8 8820  54         c     @edb.lines,@outparm1
     76AA A204 
     76AC 8360 
0136 76AE 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 76B0 06A0  32         bl    @putat
     76B2 243C 
0139 76B4 1D4B                   byte 29,75
0140 76B6 77A6                   data txt.bottom
0141               
0142 76B8 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 76BA C820  54         mov   @edb.lines,@waux1
     76BC A204 
     76BE 833C 
0148 76C0 05A0  34         inc   @waux1                ; Offset 1
     76C2 833C 
0149 76C4 06A0  32         bl    @putnum
     76C6 2A00 
0150 76C8 1D4B                   byte 29,75            ; YX
0151 76CA 833C                   data waux1,rambuf
     76CC 8390 
0152 76CE 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 76D0 C820  54         mov   @fb.yxsave,@wyx
     76D2 A114 
     76D4 832A 
0159 76D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 76D8 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 76DA 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.360191
0089                       ;-----------------------------------------------------------------------
0090                       ; Program data
0091                       ;-----------------------------------------------------------------------
0092                       copy  "data.constants.asm"  ; Data segment - Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: Stevie Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               
0008               
0009               ***************************************************************
0010               * Textmode (80 columns, 30 rows) - F18A
0011               *--------------------------------------------------------------
0012               *
0013               * ; VDP#0 Control bits
0014               * ;      bit 6=0: M3 | Graphics 1 mode
0015               * ;      bit 7=0: Disable external VDP input
0016               * ; VDP#1 Control bits
0017               * ;      bit 0=1: 16K selection
0018               * ;      bit 1=1: Enable display
0019               * ;      bit 2=1: Enable VDP interrupt
0020               * ;      bit 3=1: M1 \ TEXT MODE
0021               * ;      bit 4=0: M2 /
0022               * ;      bit 5=0: reserved
0023               * ;      bit 6=0: 8x8 sprites
0024               * ;      bit 7=0: Sprite magnification (1x)
0025               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0026               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0027               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0028               * ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
0029               * ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
0030               * ; VDP#7 Set foreground/background color
0031               ***************************************************************
0032               stevie.tx8030:
0033 76DC 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     76DE 003F 
     76E0 0243 
     76E2 05F4 
     76E4 0050 
0034               
0035               romsat:
0036 76E6 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     76E8 0001 
0037               
0038               cursors:
0039 76EA 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     76EC 0000 
     76EE 0000 
     76F0 001C 
0040 76F2 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     76F4 1010 
     76F6 1010 
     76F8 1000 
0041 76FA 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     76FC 1C1C 
     76FE 1C1C 
     7700 1C00 
0042               
0043               patterns:
0044 7702 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     7704 0000 
     7706 00FF 
     7708 0000 
0045 770A 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     770C 0000 
     770E FF00 
     7710 FF00 
0046               patterns.box:
0047 7712 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     7714 0000 
     7716 FF00 
     7718 FF00 
0048 771A 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     771C 0000 
     771E FF80 
     7720 BFA0 
0049 7722 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     7724 0000 
     7726 FC04 
     7728 F414 
0050 772A A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     772C A0A0 
     772E A0A0 
     7730 A0A0 
0051 7732 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     7734 1414 
     7736 1414 
     7738 1414 
0052 773A A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     773C A0A0 
     773E BF80 
     7740 FF00 
0053 7742 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     7744 1414 
     7746 F404 
     7748 FC00 
0054 774A 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     774C C0C0 
     774E C0C0 
     7750 0080 
0055 7752 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     7754 0F0F 
     7756 0F0F 
     7758 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 775A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     775C 0002 
0065 775E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7760 0003 
0066 7762 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7764 000A 
0067               
0068 7766 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     7768 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 776A C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     776C 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 776E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7770 000D 
0077 7772 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7774 000E 
0078 7776 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7778 000F 
0079               
0080               
0081               
0082               
0083               
0084               ***************************************************************
0085               * Stevie color schemes table
0086               *--------------------------------------------------------------
0087               * Word 1
0088               *    MSB  high-nibble    Foreground color frame buffer
0089               *    MSB  low-nibble     Background color frame buffer
0090               *    LSB  high-nibble    Foreground color bottom line pane
0091               *    LSB  low-nibble     Background color bottom line pane
0092               *
0093               * Word 2
0094               *    MSB  high-nibble    Foreground color cmdb pane
0095               *    MSB  low-nibble     Background color cmdb pane
0096               *    LSB  high-nibble    0
0097               *    LSB  low-nibble     Cursor foreground color
0098               *--------------------------------------------------------------
0099      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0100               
0101               tv.colorscheme.table:
0102                                        ; #  Framebuffer        | Status line        | CMDB
0103                                        ; ----------------------|--------------------|---------
0104 777A F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     777C F001 
0105 777E F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     7780 F00F 
0106 7782 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     7784 F00F 
0107 7786 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     7788 F00F 
0108 778A E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     778C F00F 
0109 778E 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     7790 1006 
0110 7792 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     7794 1001 
0111 7796 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     7798 1A0F 
0112 779A 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     779C F20F 
0113               
**** **** ****     > stevie_b1.asm.360191
0093                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for status line pane
0010               ;--------------------------------------------------------------
0011               txt.delim
0012 779E 012C             byte  1
0013 779F ....             text  ','
0014                       even
0015               
0016               txt.marker
0017 77A0 052A             byte  5
0018 77A1 ....             text  '*EOF*'
0019                       even
0020               
0021               txt.bottom
0022 77A6 0520             byte  5
0023 77A7 ....             text  '  BOT'
0024                       even
0025               
0026               txt.ovrwrite
0027 77AC 034F             byte  3
0028 77AD ....             text  'OVR'
0029                       even
0030               
0031               txt.insert
0032 77B0 0349             byte  3
0033 77B1 ....             text  'INS'
0034                       even
0035               
0036               txt.star
0037 77B4 012A             byte  1
0038 77B5 ....             text  '*'
0039                       even
0040               
0041               txt.loading
0042 77B6 0A4C             byte  10
0043 77B7 ....             text  'Loading...'
0044                       even
0045               
0046               txt.kb
0047 77C2 026B             byte  2
0048 77C3 ....             text  'kb'
0049                       even
0050               
0051               txt.rle
0052 77C6 0352             byte  3
0053 77C7 ....             text  'RLE'
0054                       even
0055               
0056               txt.lines
0057 77CA 054C             byte  5
0058 77CB ....             text  'Lines'
0059                       even
0060               
0061               txt.bufnum
0062 77D0 0323             byte  3
0063 77D1 ....             text  '#1 '
0064                       even
0065               
0066               txt.newfile
0067 77D4 0A5B             byte  10
0068 77D5 ....             text  '[New file]'
0069                       even
0070               
0071               txt.filetype.dv80
0072 77E0 0444             byte  4
0073 77E1 ....             text  'DV80'
0074                       even
0075               
0076               txt.filetype.none
0077 77E6 0420             byte  4
0078 77E7 ....             text  '    '
0079                       even
0080               
0081               
0082               
0083               txt.keys.loaddv80
0084 77EC 2D46             byte  45
0085 77ED ....             text  'FCTN-9=Back    FCTN-E=Previous    FCTN-X=Next'
0086                       even
0087               
0088               
0089               
0090               
0091               ;--------------------------------------------------------------
0092               ; Strings for error line pane
0093               ;--------------------------------------------------------------
0094               txt.ioerr
0095 781A 2049             byte  32
0096 781B ....             text  'I/O error. Failed loading file: '
0097                       even
0098               
0099               txt.io.nofile
0100 783C 154E             byte  21
0101 783D ....             text  'No filename specified'
0102                       even
0103               
0104               
0105               
0106               ;--------------------------------------------------------------
0107               ; Strings for command buffer
0108               ;--------------------------------------------------------------
0109               txt.cmdb.title
0110 7852 0E43             byte  14
0111 7853 ....             text  'Command buffer'
0112                       even
0113               
0114               txt.cmdb.prompt
0115 7862 013E             byte  1
0116 7863 ....             text  '>'
0117                       even
0118               
0119               txt.cmdb.loaddv80
0120 7864 0E4C             byte  14
0121 7865 ....             text  'Load DV80 file'
0122                       even
0123               
0124               
0125               txt.cmdb.hintdv80
0126 7874 2748             byte  39
0127 7875 ....             text  'HINT: Specify filename and press enter.'
0128                       even
0129               
0130               
0131 789C 4201     txt.cmdb.hbar      byte    66
0132 789E 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78A0 0101 
     78A2 0101 
     78A4 0101 
     78A6 0101 
     78A8 0101 
     78AA 0101 
     78AC 0101 
     78AE 0101 
     78B0 0101 
0133 78B2 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78B4 0101 
     78B6 0101 
     78B8 0101 
     78BA 0101 
     78BC 0101 
     78BE 0101 
     78C0 0101 
     78C2 0101 
     78C4 0101 
0134 78C6 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78C8 0101 
     78CA 0101 
     78CC 0101 
     78CE 0101 
     78D0 0101 
     78D2 0101 
     78D4 0101 
     78D6 0101 
     78D8 0101 
0135 78DA 0101                        byte    1,1,1,1,1,1
     78DC 0101 
     78DE 0100 
0136                                  even
0137               
0138               
0139               
0140 78E0 0C0A     txt.stevie         byte    12
0141                                  byte    10
0142 78E2 ....                        text    'stevie v1.00'
0143 78EE 0B00                        byte    11
0144                                  even
0145               
0146               fdname1
0147 78F0 0850             byte  8
0148 78F1 ....             text  'PI.CLOCK'
0149                       even
0150               
0151               fdname2
0152 78FA 0E54             byte  14
0153 78FB ....             text  'TIPI.TIVI.NR80'
0154                       even
0155               
0156               fdname3
0157 790A 0C44             byte  12
0158 790B ....             text  'DSK1.XBEADOC'
0159                       even
0160               
0161               fdname4
0162 7918 1154             byte  17
0163 7919 ....             text  'TIPI.TIVI.C99MAN1'
0164                       even
0165               
0166               fdname5
0167 792A 1154             byte  17
0168 792B ....             text  'TIPI.TIVI.C99MAN2'
0169                       even
0170               
0171               fdname6
0172 793C 1154             byte  17
0173 793D ....             text  'TIPI.TIVI.C99MAN3'
0174                       even
0175               
0176               fdname7
0177 794E 1254             byte  18
0178 794F ....             text  'TIPI.TIVI.C99SPECS'
0179                       even
0180               
0181               fdname8
0182 7962 1254             byte  18
0183 7963 ....             text  'TIPI.TIVI.RANDOM#C'
0184                       even
0185               
0186               fdname9
0187 7976 0D44             byte  13
0188 7977 ....             text  'DSK1.INVADERS'
0189                       even
0190               
0191               fdname0
0192 7984 0944             byte  9
0193 7985 ....             text  'DSK1.NR80'
0194                       even
0195               
0196               fdname.clock
0197 798E 0850             byte  8
0198 798F ....             text  'PI.CLOCK'
0199                       even
0200               
0201               
0202               
0203               *---------------------------------------------------------------
0204               * Keyboard labels - Function keys
0205               *---------------------------------------------------------------
0206               txt.fctn.0
0207 7998 0866             byte  8
0208 7999 ....             text  'fctn + 0'
0209                       even
0210               
0211               txt.fctn.1
0212 79A2 0866             byte  8
0213 79A3 ....             text  'fctn + 1'
0214                       even
0215               
0216               txt.fctn.2
0217 79AC 0866             byte  8
0218 79AD ....             text  'fctn + 2'
0219                       even
0220               
0221               txt.fctn.3
0222 79B6 0866             byte  8
0223 79B7 ....             text  'fctn + 3'
0224                       even
0225               
0226               txt.fctn.4
0227 79C0 0866             byte  8
0228 79C1 ....             text  'fctn + 4'
0229                       even
0230               
0231               txt.fctn.5
0232 79CA 0866             byte  8
0233 79CB ....             text  'fctn + 5'
0234                       even
0235               
0236               txt.fctn.6
0237 79D4 0866             byte  8
0238 79D5 ....             text  'fctn + 6'
0239                       even
0240               
0241               txt.fctn.7
0242 79DE 0866             byte  8
0243 79DF ....             text  'fctn + 7'
0244                       even
0245               
0246               txt.fctn.8
0247 79E8 0866             byte  8
0248 79E9 ....             text  'fctn + 8'
0249                       even
0250               
0251               txt.fctn.9
0252 79F2 0866             byte  8
0253 79F3 ....             text  'fctn + 9'
0254                       even
0255               
0256               txt.fctn.a
0257 79FC 0866             byte  8
0258 79FD ....             text  'fctn + a'
0259                       even
0260               
0261               txt.fctn.b
0262 7A06 0866             byte  8
0263 7A07 ....             text  'fctn + b'
0264                       even
0265               
0266               txt.fctn.c
0267 7A10 0866             byte  8
0268 7A11 ....             text  'fctn + c'
0269                       even
0270               
0271               txt.fctn.d
0272 7A1A 0866             byte  8
0273 7A1B ....             text  'fctn + d'
0274                       even
0275               
0276               txt.fctn.e
0277 7A24 0866             byte  8
0278 7A25 ....             text  'fctn + e'
0279                       even
0280               
0281               txt.fctn.f
0282 7A2E 0866             byte  8
0283 7A2F ....             text  'fctn + f'
0284                       even
0285               
0286               txt.fctn.g
0287 7A38 0866             byte  8
0288 7A39 ....             text  'fctn + g'
0289                       even
0290               
0291               txt.fctn.h
0292 7A42 0866             byte  8
0293 7A43 ....             text  'fctn + h'
0294                       even
0295               
0296               txt.fctn.i
0297 7A4C 0866             byte  8
0298 7A4D ....             text  'fctn + i'
0299                       even
0300               
0301               txt.fctn.j
0302 7A56 0866             byte  8
0303 7A57 ....             text  'fctn + j'
0304                       even
0305               
0306               txt.fctn.k
0307 7A60 0866             byte  8
0308 7A61 ....             text  'fctn + k'
0309                       even
0310               
0311               txt.fctn.l
0312 7A6A 0866             byte  8
0313 7A6B ....             text  'fctn + l'
0314                       even
0315               
0316               txt.fctn.m
0317 7A74 0866             byte  8
0318 7A75 ....             text  'fctn + m'
0319                       even
0320               
0321               txt.fctn.n
0322 7A7E 0866             byte  8
0323 7A7F ....             text  'fctn + n'
0324                       even
0325               
0326               txt.fctn.o
0327 7A88 0866             byte  8
0328 7A89 ....             text  'fctn + o'
0329                       even
0330               
0331               txt.fctn.p
0332 7A92 0866             byte  8
0333 7A93 ....             text  'fctn + p'
0334                       even
0335               
0336               txt.fctn.q
0337 7A9C 0866             byte  8
0338 7A9D ....             text  'fctn + q'
0339                       even
0340               
0341               txt.fctn.r
0342 7AA6 0866             byte  8
0343 7AA7 ....             text  'fctn + r'
0344                       even
0345               
0346               txt.fctn.s
0347 7AB0 0866             byte  8
0348 7AB1 ....             text  'fctn + s'
0349                       even
0350               
0351               txt.fctn.t
0352 7ABA 0866             byte  8
0353 7ABB ....             text  'fctn + t'
0354                       even
0355               
0356               txt.fctn.u
0357 7AC4 0866             byte  8
0358 7AC5 ....             text  'fctn + u'
0359                       even
0360               
0361               txt.fctn.v
0362 7ACE 0866             byte  8
0363 7ACF ....             text  'fctn + v'
0364                       even
0365               
0366               txt.fctn.w
0367 7AD8 0866             byte  8
0368 7AD9 ....             text  'fctn + w'
0369                       even
0370               
0371               txt.fctn.x
0372 7AE2 0866             byte  8
0373 7AE3 ....             text  'fctn + x'
0374                       even
0375               
0376               txt.fctn.y
0377 7AEC 0866             byte  8
0378 7AED ....             text  'fctn + y'
0379                       even
0380               
0381               txt.fctn.z
0382 7AF6 0866             byte  8
0383 7AF7 ....             text  'fctn + z'
0384                       even
0385               
0386               *---------------------------------------------------------------
0387               * Keyboard labels - Function keys extra
0388               *---------------------------------------------------------------
0389               txt.fctn.dot
0390 7B00 0866             byte  8
0391 7B01 ....             text  'fctn + .'
0392                       even
0393               
0394               txt.fctn.plus
0395 7B0A 0866             byte  8
0396 7B0B ....             text  'fctn + +'
0397                       even
0398               
0399               *---------------------------------------------------------------
0400               * Keyboard labels - Control keys
0401               *---------------------------------------------------------------
0402               txt.ctrl.0
0403 7B14 0863             byte  8
0404 7B15 ....             text  'ctrl + 0'
0405                       even
0406               
0407               txt.ctrl.1
0408 7B1E 0863             byte  8
0409 7B1F ....             text  'ctrl + 1'
0410                       even
0411               
0412               txt.ctrl.2
0413 7B28 0863             byte  8
0414 7B29 ....             text  'ctrl + 2'
0415                       even
0416               
0417               txt.ctrl.3
0418 7B32 0863             byte  8
0419 7B33 ....             text  'ctrl + 3'
0420                       even
0421               
0422               txt.ctrl.4
0423 7B3C 0863             byte  8
0424 7B3D ....             text  'ctrl + 4'
0425                       even
0426               
0427               txt.ctrl.5
0428 7B46 0863             byte  8
0429 7B47 ....             text  'ctrl + 5'
0430                       even
0431               
0432               txt.ctrl.6
0433 7B50 0863             byte  8
0434 7B51 ....             text  'ctrl + 6'
0435                       even
0436               
0437               txt.ctrl.7
0438 7B5A 0863             byte  8
0439 7B5B ....             text  'ctrl + 7'
0440                       even
0441               
0442               txt.ctrl.8
0443 7B64 0863             byte  8
0444 7B65 ....             text  'ctrl + 8'
0445                       even
0446               
0447               txt.ctrl.9
0448 7B6E 0863             byte  8
0449 7B6F ....             text  'ctrl + 9'
0450                       even
0451               
0452               txt.ctrl.a
0453 7B78 0863             byte  8
0454 7B79 ....             text  'ctrl + a'
0455                       even
0456               
0457               txt.ctrl.b
0458 7B82 0863             byte  8
0459 7B83 ....             text  'ctrl + b'
0460                       even
0461               
0462               txt.ctrl.c
0463 7B8C 0863             byte  8
0464 7B8D ....             text  'ctrl + c'
0465                       even
0466               
0467               txt.ctrl.d
0468 7B96 0863             byte  8
0469 7B97 ....             text  'ctrl + d'
0470                       even
0471               
0472               txt.ctrl.e
0473 7BA0 0863             byte  8
0474 7BA1 ....             text  'ctrl + e'
0475                       even
0476               
0477               txt.ctrl.f
0478 7BAA 0863             byte  8
0479 7BAB ....             text  'ctrl + f'
0480                       even
0481               
0482               txt.ctrl.g
0483 7BB4 0863             byte  8
0484 7BB5 ....             text  'ctrl + g'
0485                       even
0486               
0487               txt.ctrl.h
0488 7BBE 0863             byte  8
0489 7BBF ....             text  'ctrl + h'
0490                       even
0491               
0492               txt.ctrl.i
0493 7BC8 0863             byte  8
0494 7BC9 ....             text  'ctrl + i'
0495                       even
0496               
0497               txt.ctrl.j
0498 7BD2 0863             byte  8
0499 7BD3 ....             text  'ctrl + j'
0500                       even
0501               
0502               txt.ctrl.k
0503 7BDC 0863             byte  8
0504 7BDD ....             text  'ctrl + k'
0505                       even
0506               
0507               txt.ctrl.l
0508 7BE6 0863             byte  8
0509 7BE7 ....             text  'ctrl + l'
0510                       even
0511               
0512               txt.ctrl.m
0513 7BF0 0863             byte  8
0514 7BF1 ....             text  'ctrl + m'
0515                       even
0516               
0517               txt.ctrl.n
0518 7BFA 0863             byte  8
0519 7BFB ....             text  'ctrl + n'
0520                       even
0521               
0522               txt.ctrl.o
0523 7C04 0863             byte  8
0524 7C05 ....             text  'ctrl + o'
0525                       even
0526               
0527               txt.ctrl.p
0528 7C0E 0863             byte  8
0529 7C0F ....             text  'ctrl + p'
0530                       even
0531               
0532               txt.ctrl.q
0533 7C18 0863             byte  8
0534 7C19 ....             text  'ctrl + q'
0535                       even
0536               
0537               txt.ctrl.r
0538 7C22 0863             byte  8
0539 7C23 ....             text  'ctrl + r'
0540                       even
0541               
0542               txt.ctrl.s
0543 7C2C 0863             byte  8
0544 7C2D ....             text  'ctrl + s'
0545                       even
0546               
0547               txt.ctrl.t
0548 7C36 0863             byte  8
0549 7C37 ....             text  'ctrl + t'
0550                       even
0551               
0552               txt.ctrl.u
0553 7C40 0863             byte  8
0554 7C41 ....             text  'ctrl + u'
0555                       even
0556               
0557               txt.ctrl.v
0558 7C4A 0863             byte  8
0559 7C4B ....             text  'ctrl + v'
0560                       even
0561               
0562               txt.ctrl.w
0563 7C54 0863             byte  8
0564 7C55 ....             text  'ctrl + w'
0565                       even
0566               
0567               txt.ctrl.x
0568 7C5E 0863             byte  8
0569 7C5F ....             text  'ctrl + x'
0570                       even
0571               
0572               txt.ctrl.y
0573 7C68 0863             byte  8
0574 7C69 ....             text  'ctrl + y'
0575                       even
0576               
0577               txt.ctrl.z
0578 7C72 0863             byte  8
0579 7C73 ....             text  'ctrl + z'
0580                       even
0581               
0582               *---------------------------------------------------------------
0583               * Keyboard labels - control keys extra
0584               *---------------------------------------------------------------
0585               txt.ctrl.plus
0586 7C7C 0863             byte  8
0587 7C7D ....             text  'ctrl + +'
0588                       even
0589               
0590               *---------------------------------------------------------------
0591               * Special keys
0592               *---------------------------------------------------------------
0593               txt.enter
0594 7C86 0565             byte  5
0595 7C87 ....             text  'enter'
0596                       even
0597               
**** **** ****     > stevie_b1.asm.360191
0094                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      0000     key.fctn.0    equ >0000             ; fctn + 0
0008      0300     key.fctn.1    equ >0300             ; fctn + 1
0009      0400     key.fctn.2    equ >0400             ; fctn + 2
0010      0700     key.fctn.3    equ >0700             ; fctn + 3
0011      0000     key.fctn.4    equ >0000             ; fctn + 4
0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0013      0000     key.fctn.6    equ >0000             ; fctn + 6
0014      0000     key.fctn.7    equ >0000             ; fctn + 7
0015      0000     key.fctn.8    equ >0000             ; fctn + 8
0016      0F00     key.fctn.9    equ >0f00             ; fctn + 9
0017      0000     key.fctn.a    equ >0000             ; fctn + a
0018      0000     key.fctn.b    equ >0000             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      0000     key.fctn.h    equ >0000             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      0000     key.fctn.j    equ >0000             ; fctn + j
0027      0000     key.fctn.k    equ >0000             ; fctn + k
0028      0000     key.fctn.l    equ >0000             ; fctn + l
0029      0000     key.fctn.m    equ >0000             ; fctn + m
0030      0000     key.fctn.n    equ >0000             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      0000     key.fctn.q    equ >0000             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      0000     key.fctn.v    equ >0000             ; fctn + v
0039      0000     key.fctn.w    equ >0000             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      0000     key.fctn.y    equ >0000             ; fctn + y
0042      0000     key.fctn.z    equ >0000             ; fctn + z
0043               *---------------------------------------------------------------
0044               * Keyboard scancodes - Function keys extra
0045               *---------------------------------------------------------------
0046      B900     key.fctn.dot  equ >b900             ; fctn + .
0047      0500     key.fctn.plus equ >0500             ; fctn + +
0048               *---------------------------------------------------------------
0049               * Keyboard scancodes - control keys
0050               *-------------|---------------------|---------------------------
0051      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0052      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0053      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0054      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0055      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0056      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0057      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0058      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0059      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0060      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0061      8100     key.ctrl.a    equ >8100             ; ctrl + a
0062      8200     key.ctrl.b    equ >8200             ; ctrl + b
0063      0000     key.ctrl.c    equ >0000             ; ctrl + c
0064      8400     key.ctrl.d    equ >8400             ; ctrl + d
0065      8500     key.ctrl.e    equ >8500             ; ctrl + e
0066      8600     key.ctrl.f    equ >8600             ; ctrl + f
0067      0000     key.ctrl.g    equ >0000             ; ctrl + g
0068      0000     key.ctrl.h    equ >0000             ; ctrl + h
0069      0000     key.ctrl.i    equ >0000             ; ctrl + i
0070      0000     key.ctrl.j    equ >0000             ; ctrl + j
0071      0000     key.ctrl.k    equ >0000             ; ctrl + k
0072      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0073      0000     key.ctrl.m    equ >0000             ; ctrl + m
0074      0000     key.ctrl.n    equ >0000             ; ctrl + n
0075      0000     key.ctrl.o    equ >0000             ; ctrl + o
0076      0000     key.ctrl.p    equ >0000             ; ctrl + p
0077      0000     key.ctrl.q    equ >0000             ; ctrl + q
0078      0000     key.ctrl.r    equ >0000             ; ctrl + r
0079      9300     key.ctrl.s    equ >9300             ; ctrl + s
0080      9400     key.ctrl.t    equ >9400             ; ctrl + t
0081      0000     key.ctrl.u    equ >0000             ; ctrl + u
0082      0000     key.ctrl.v    equ >0000             ; ctrl + v
0083      0000     key.ctrl.w    equ >0000             ; ctrl + w
0084      9800     key.ctrl.x    equ >9800             ; ctrl + x
0085      0000     key.ctrl.y    equ >0000             ; ctrl + y
0086      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0087               *---------------------------------------------------------------
0088               * Keyboard scancodes - control keys extra
0089               *---------------------------------------------------------------
0090      9D00     key.ctrl.plus equ >9d00             ; ctrl + +
0091               *---------------------------------------------------------------
0092               * Special keys
0093               *---------------------------------------------------------------
0094      0D00     key.enter     equ >0d00             ; enter
0095               
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Action keys mapping table: Editor
0100               *---------------------------------------------------------------
0101               keymap_actions.editor:
0102                       ;-------------------------------------------------------
0103                       ; Movement keys
0104                       ;-------------------------------------------------------
0105 7C8C 0D00             data  key.enter, txt.enter, edkey.action.enter
     7C8E 7C86 
     7C90 6560 
0106 7C92 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7C94 7AB0 
     7C96 615E 
0107 7C98 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7C9A 7A1A 
     7C9C 6174 
0108 7C9E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7CA0 7A24 
     7CA2 618C 
0109 7CA4 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7CA6 7AE2 
     7CA8 61DE 
0110 7CAA 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7CAC 7B78 
     7CAE 624A 
0111 7CB0 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7CB2 7BAA 
     7CB4 6262 
0112 7CB6 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7CB8 7C2C 
     7CBA 6276 
0113 7CBC 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     7CBE 7B96 
     7CC0 62C8 
0114 7CC2 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7CC4 7BA0 
     7CC6 6328 
0115 7CC8 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7CCA 7C5E 
     7CCC 636A 
0116 7CCE 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7CD0 7C36 
     7CD2 6396 
0117 7CD4 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7CD6 7B82 
     7CD8 63C2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7CDA 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7CDC 79A2 
     7CDE 6402 
0122 7CE0 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7CE2 7BDC 
     7CE4 643A 
0123 7CE6 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7CE8 79B6 
     7CEA 646E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 7CEC 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7CEE 79AC 
     7CF0 64C6 
0128 7CF2 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7CF4 7B00 
     7CF6 65CE 
0129 7CF8 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7CFA 79CA 
     7CFC 651C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 7CFE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7D00 7B0A 
     7D02 661E 
0134 7D04 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7D06 7C72 
     7D08 736A 
0135                       ;-------------------------------------------------------
0136                       ; Editor/File buffer keys
0137                       ;-------------------------------------------------------
0138 7D0A B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7D0C 7B14 
     7D0E 6634 
0139 7D10 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7D12 7B1E 
     7D14 663A 
0140 7D16 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7D18 7B28 
     7D1A 6640 
0141 7D1C B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7D1E 7B32 
     7D20 6646 
0142 7D22 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7D24 7B3C 
     7D26 664C 
0143 7D28 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7D2A 7B46 
     7D2C 6652 
0144 7D2E B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7D30 7B50 
     7D32 6658 
0145 7D34 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7D36 7B5A 
     7D38 665E 
0146 7D3A 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7D3C 7B64 
     7D3E 6664 
0147 7D40 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7D42 7B6E 
     7D44 666A 
0148 7D46 8C00             data  key.ctrl.l, txt.ctrl.l, edkey.action.dialog.dv80
     7D48 7BE6 
     7D4A 6678 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 7D4C FFFF             data  EOL                           ; EOL
0153               
0154               
0155               
0156               
0157               *---------------------------------------------------------------
0158               * Action keys mapping table: Command Buffer (CMDB)
0159               *---------------------------------------------------------------
0160               keymap_actions.cmdb:
0161                       ;-------------------------------------------------------
0162                       ; Movement keys
0163                       ;-------------------------------------------------------
0164 7D4E 0800             data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
     7D50 7AB0 
     7D52 668C 
0165 7D54 0900             data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
     7D56 7A1A 
     7D58 669E 
0166 7D5A 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
     7D5C 7B78 
     7D5E 66B2 
0167 7D60 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
     7D62 7BAA 
     7D64 66C6 
0168                       ;-------------------------------------------------------
0169                       ; Modified keys
0170                       ;-------------------------------------------------------
0171 7D66 0700             data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
     7D68 79B6 
     7D6A 66DE 
0172 7D6C 0D00             data  key.enter, txt.enter, edkey.action.cmdb.loadfile
     7D6E 7C86 
     7D70 6724 
0173                       ;-------------------------------------------------------
0174                       ; Other action keys
0175                       ;-------------------------------------------------------
0176 7D72 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7D74 7B0A 
     7D76 661E 
0177 7D78 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
     7D7A 79F2 
     7D7C 671C 
0178 7D7E 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7D80 7C72 
     7D82 736A 
0179                       ;-------------------------------------------------------
0180                       ; End of list
0181                       ;-------------------------------------------------------
0182 7D84 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.360191
0095               
0099 7D86 7D86                   data $                ; Bank 1 ROM size OK.
0101               
0102               *--------------------------------------------------------------
0103               * Video mode configuration
0104               *--------------------------------------------------------------
0105      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0106      0004     spfbck  equ   >04                   ; Screen background color.
0107      76DC     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0108      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0109      0050     colrow  equ   80                    ; Columns per row
0110      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0111      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0112      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0113      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

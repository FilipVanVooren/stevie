XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.299124
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200615-299124
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
0009               * File: equates.asm                 ; Version 200615-299124
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
0071      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0072      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0073      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0074      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0075      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0076      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0077      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0078      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0079      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0080      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0081      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0082      0001     skip_random_generator     equ  1       ; Skip random functions
0083      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0084               *--------------------------------------------------------------
0085               * SPECTRA2 / Stevie startup options
0086               *--------------------------------------------------------------
0087      0001     debug                     equ  1       ; Turn on spectra2 debugging
0088      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0089                                                      ; memory address @cpu.scrpad.tgt
0090      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0091      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0092      6050     kickstart.code2           equ  >6050   ; Uniform aorg entry addr start of code
0093               *--------------------------------------------------------------
0094               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0095               *--------------------------------------------------------------
0096               ;                 equ  >8342           ; >8342-834F **free***
0097      8350     parm1             equ  >8350           ; Function parameter 1
0098      8352     parm2             equ  >8352           ; Function parameter 2
0099      8354     parm3             equ  >8354           ; Function parameter 3
0100      8356     parm4             equ  >8356           ; Function parameter 4
0101      8358     parm5             equ  >8358           ; Function parameter 5
0102      835A     parm6             equ  >835a           ; Function parameter 6
0103      835C     parm7             equ  >835c           ; Function parameter 7
0104      835E     parm8             equ  >835e           ; Function parameter 8
0105      8360     outparm1          equ  >8360           ; Function output parameter 1
0106      8362     outparm2          equ  >8362           ; Function output parameter 2
0107      8364     outparm3          equ  >8364           ; Function output parameter 3
0108      8366     outparm4          equ  >8366           ; Function output parameter 4
0109      8368     outparm5          equ  >8368           ; Function output parameter 5
0110      836A     outparm6          equ  >836a           ; Function output parameter 6
0111      836C     outparm7          equ  >836c           ; Function output parameter 7
0112      836E     outparm8          equ  >836e           ; Function output parameter 8
0113      8370     timers            equ  >8370           ; Timer table
0114      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0115      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0116               *--------------------------------------------------------------
0117               * Scratchpad backup 1               @>3e00-3eff     (256 bytes)
0118               * Scratchpad backup 2               @>3f00-3fff     (256 bytes)
0119               *--------------------------------------------------------------
0120      3E00     cpu.scrpad.tgt    equ  >3e00           ; Destination cpu.scrpad.backup/restore
0121      3E00     scrpad.backup1    equ  >3e00           ; Backup GPL layout
0122      3F00     scrpad.backup2    equ  >3f00           ; Backup spectra2 layout
0123               *--------------------------------------------------------------
0124               * stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0125               *--------------------------------------------------------------
0126      A000     tv.top            equ  >a000           ; Structure begin
0127      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0128      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0129      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0130      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0131      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0132      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0133      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0134      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0135      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0136      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-4)
0137      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0138      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0139      A018     tv.pane.focus     equ  tv.top + 24     ; Identify pane that has focus
0140      A018     tv.end            equ  tv.top + 24     ; End of structure
0141      0000     pane.focus.fb     equ  0               ; Editor pane has focus
0142      0001     pane.focus.cmdb   equ  1               ; Command buffer pane has focus
0143               *--------------------------------------------------------------
0144               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0145               *--------------------------------------------------------------
0146      A100     fb.struct         equ  >a100           ; Structure begin
0147      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0148      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0149      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0150                                                      ; line X in editor buffer).
0151      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0152                                                      ; (offset 0 .. @fb.scrrows)
0153      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0154      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0155      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0156      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0157      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0158      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0159      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0160      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0161      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0162      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0163      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0164               *--------------------------------------------------------------
0165               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0166               *--------------------------------------------------------------
0167      A200     edb.struct        equ  >a200           ; Begin structure
0168      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0169      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0170      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0171      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0172      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0173      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0174      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0175      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0176                                                      ; with current filename.
0177      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0178                                                      ; with current file type.
0179      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0180      A214     edb.end           equ  edb.struct + 20 ; End of structure
0181               *--------------------------------------------------------------
0182               * Command buffer structure          @>a300-a3ff     (256 bytes)
0183               *--------------------------------------------------------------
0184      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0185      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer
0186      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0187      A304     cmdb.scrrows      equ  cmdb.struct + 4 ; Current size of CMDB pane (in rows)
0188      A306     cmdb.default      equ  cmdb.struct + 6 ; Default size of CMDB pane (in rows)
0189      A308     cmdb.cursor       equ  cmdb.struct + 8 ; Screen YX of cursor in CMDB pane
0190      A30A     cmdb.yxsave       equ  cmdb.struct + 10; Copy of WYX
0191      A30C     cmdb.yxtop        equ  cmdb.struct + 12; YX position of first row in CMDB pane
0192      A30E     cmdb.column       equ  cmdb.struct + 14; Current column in CMDB
0193      A310     cmdb.length       equ  cmdb.struct + 16; Length of current row in CMDB
0194      A312     cmdb.lines        equ  cmdb.struct + 18; Total lines in CMDB
0195      A314     cmdb.dirty        equ  cmdb.struct + 20; Command buffer dirty (Text changed!)
0196      A316     cmdb.fb.yxsave    equ  cmdb.struct + 22; Copy of FB WYX when entering cmdb pane
0197      A318     cmdb.end          equ  cmdb.struct + 24; End of structure
0198               *--------------------------------------------------------------
0199               * File handle structure             @>a400-a4ff     (256 bytes)
0200               *--------------------------------------------------------------
0201      A400     fh.struct         equ  >a400           ; stevie file handling structures
0202      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0203      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0204      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0205      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0206      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0207      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0208      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0209      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0210      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0211      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0212      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0213      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0214      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0215      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0216      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0217      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0218      A444     fh.free           equ  fh.struct + 68  ; no longer used
0219      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0220      A496     fh.end            equ  fh.struct +150  ; End of structure
0221      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0222      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0223               *--------------------------------------------------------------
0224               * Index structure                   @>a500-a5ff     (256 bytes)
0225               *--------------------------------------------------------------
0226      A500     idx.struct        equ  >a500           ; stevie index structure
0227      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0228      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0229      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0230               *--------------------------------------------------------------
0231               * Frame buffer                      @>a600-afff    (2560 bytes)
0232               *--------------------------------------------------------------
0233      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0234      0960     fb.size           equ  80*30           ; Frame buffer size
0235               *--------------------------------------------------------------
0236               * Index                             @>b000-bfff    (4096 bytes)
0237               *--------------------------------------------------------------
0238      B000     idx.top           equ  >b000           ; Top of index
0239      1000     idx.size          equ  4096            ; Index size
0240               *--------------------------------------------------------------
0241               * Editor buffer                     @>c000-cfff    (4096 bytes)
0242               *--------------------------------------------------------------
0243      C000     edb.top           equ  >c000           ; Editor buffer high memory
0244      1000     edb.size          equ  4096            ; Editor buffer size
0245               *--------------------------------------------------------------
0246               * Command buffer                    @>d000-dfff    (4096 bytes)
0247               *--------------------------------------------------------------
0248      D000     cmdb.top          equ  >d000           ; Top of command buffer
0249      1000     cmdb.size         equ  4096            ; Command buffer size
0250               *--------------------------------------------------------------
0251               * *** FREE ***                      @>f000-ffff    (4096 bytes)
0252               *--------------------------------------------------------------
**** **** ****     > stevie_b1.asm.299124
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
0031 6015 ....             text  'STEVIE 200615-299124'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.299124
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
0061               *
0062               * == Kernel/Multitasking
0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0066               *
0067               * == Startup behaviour
0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0070               *******************************************************************************
0071               
0072               *//////////////////////////////////////////////////////////////
0073               *                       RUNLIB SETUP
0074               *//////////////////////////////////////////////////////////////
0075               
0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
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
0077                       copy  "equ_registers.asm"        ; Equates runlib registers
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
0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
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
0079                       copy  "equ_param.asm"            ; Equates runlib parameters
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
0080               
0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
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
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0086                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0087                       copy  "cpu_crash.asm"            ; CPU crash handler
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
     208E 2D88 
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
     20AA 242A 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 29B6 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 242A 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 29B6 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 242A 
0113 20D4 0300                   byte 3,0
0114 20D6 21B2                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 242A 
0116 20DC 0400                   byte 4,0
0117 20DE 21B8                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 242A 
0119 20E4 1600                   byte 22,0
0120 20E6 21BE                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 242A 
0122 20EC 1700                   byte 23,0
0123 20EE 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 266E 
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
     2116 29C0 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 2684 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 2418 
0164 2128 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 2684 
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
     2142 29C0 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 2932 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 2684 
0194 2158 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr
     215C 2418 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 2684 
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
     2174 2674 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2C96 
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
0260 21DB ....             text  'Build-ID  200615-299124'
0261                       even
0262               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
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
0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0465 2426 0460  28         b     @xpym2v               ; Display string
     2428 2438 
0466               
0467               
0468               ***************************************************************
0469               * Put length-byte prefixed string at YX
0470               ***************************************************************
0471               *  BL   @PUTAT
0472               *  DATA P0,P1
0473               *
0474               *  P0 = YX position
0475               *  P1 = Pointer to string
0476               *--------------------------------------------------------------
0477               *  REMARKS
0478               *  First byte of string must contain length
0479               ********|*****|*********************|**************************
0480 242A C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     242C 832A 
0481 242E 0460  28         b     @putstr
     2430 2418 
**** **** ****     > runlib.asm
0090               
0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 2432 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2434 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2436 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 2438 0264  22 xpym2v  ori   tmp0,>4000
     243A 4000 
0027 243C 06C4  14         swpb  tmp0
0028 243E D804  38         movb  tmp0,@vdpa
     2440 8C02 
0029 2442 06C4  14         swpb  tmp0
0030 2444 D804  38         movb  tmp0,@vdpa
     2446 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 2448 020F  20         li    r15,vdpw              ; Set VDP write address
     244A 8C00 
0035 244C C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     244E 2456 
     2450 8320 
0036 2452 0460  28         b     @mcloop               ; Write data to VDP
     2454 8320 
0037 2456 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0094               
0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 2458 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 245A C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 245C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 245E 06C4  14 xpyv2m  swpb  tmp0
0027 2460 D804  38         movb  tmp0,@vdpa
     2462 8C02 
0028 2464 06C4  14         swpb  tmp0
0029 2466 D804  38         movb  tmp0,@vdpa
     2468 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 246A 020F  20         li    r15,vdpr              ; Set VDP read address
     246C 8800 
0034 246E C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2470 2478 
     2472 8320 
0035 2474 0460  28         b     @mcloop               ; Read data from VDP
     2476 8320 
0036 2478 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0098               
0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 247A C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 247C C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 247E C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2480 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2482 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 2484 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2486 FFCE 
0034 2488 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     248A 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 248C 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     248E 0001 
0039 2490 1603  14         jne   cpym0                 ; No, continue checking
0040 2492 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2494 04C6  14         clr   tmp2                  ; Reset counter
0042 2496 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 2498 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     249A 7FFF 
0047 249C C1C4  18         mov   tmp0,tmp3
0048 249E 0247  22         andi  tmp3,1
     24A0 0001 
0049 24A2 1618  14         jne   cpyodd                ; Odd source address handling
0050 24A4 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24A6 0247  22         andi  tmp3,1
     24A8 0001 
0052 24AA 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24AC 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24AE 202A 
0057 24B0 1605  14         jne   cpym3
0058 24B2 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24B4 24DA 
     24B6 8320 
0059 24B8 0460  28         b     @mcloop               ; Copy memory and exit
     24BA 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24BC C1C6  18 cpym3   mov   tmp2,tmp3
0064 24BE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24C0 0001 
0065 24C2 1301  14         jeq   cpym4
0066 24C4 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24C6 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24C8 0646  14         dect  tmp2
0069 24CA 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24CC C1C7  18         mov   tmp3,tmp3
0074 24CE 1301  14         jeq   cpymz
0075 24D0 D554  38         movb  *tmp0,*tmp1
0076 24D2 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24D4 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24D6 8000 
0081 24D8 10E9  14         jmp   cpym2
0082 24DA DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0106               
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0062 24DC C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24DE 0649  14         dect  stack
0065 24E0 C64B  30         mov   r11,*stack            ; Push return address
0066 24E2 0649  14         dect  stack
0067 24E4 C640  30         mov   r0,*stack             ; Push r0
0068 24E6 0649  14         dect  stack
0069 24E8 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24EA 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24EC 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24EE 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24F0 4000 
0077 24F2 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24F4 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 24F6 020C  20         li    r12,>1e00             ; SAMS CRU address
     24F8 1E00 
0082 24FA 04C0  14         clr   r0
0083 24FC 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24FE D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2500 D100  18         movb  r0,tmp0
0086 2502 0984  56         srl   tmp0,8                ; Right align
0087 2504 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2506 833C 
0088 2508 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 250A C339  30         mov   *stack+,r12           ; Pop r12
0094 250C C039  30         mov   *stack+,r0            ; Pop r0
0095 250E C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2510 045B  20         b     *r11                  ; Return to caller
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
0131 2512 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2514 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2516 0649  14         dect  stack
0135 2518 C64B  30         mov   r11,*stack            ; Push return address
0136 251A 0649  14         dect  stack
0137 251C C640  30         mov   r0,*stack             ; Push r0
0138 251E 0649  14         dect  stack
0139 2520 C64C  30         mov   r12,*stack            ; Push r12
0140 2522 0649  14         dect  stack
0141 2524 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2526 0649  14         dect  stack
0143 2528 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 252A 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 252C 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 252E 0284  22         ci    tmp0,255              ; Crash if page > 255
     2530 00FF 
0153 2532 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2534 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2536 001E 
0158 2538 150A  14         jgt   !
0159 253A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     253C 0004 
0160 253E 1107  14         jlt   !
0161 2540 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2542 0012 
0162 2544 1508  14         jgt   sams.page.set.switch_page
0163 2546 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2548 0006 
0164 254A 1501  14         jgt   !
0165 254C 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 254E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2550 FFCE 
0170 2552 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2554 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2556 020C  20         li    r12,>1e00             ; SAMS CRU address
     2558 1E00 
0176 255A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 255C 06C0  14         swpb  r0                    ; LSB to MSB
0178 255E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2560 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2562 4000 
0180 2564 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2566 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 2568 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 256A C339  30         mov   *stack+,r12           ; Pop r12
0188 256C C039  30         mov   *stack+,r0            ; Pop r0
0189 256E C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2570 045B  20         b     *r11                  ; Return to caller
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
0204 2572 020C  20         li    r12,>1e00             ; SAMS CRU address
     2574 1E00 
0205 2576 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 2578 045B  20         b     *r11                  ; Return to caller
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
0227 257A 020C  20         li    r12,>1e00             ; SAMS CRU address
     257C 1E00 
0228 257E 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 2580 045B  20         b     *r11                  ; Return to caller
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
0260 2582 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 2584 0649  14         dect  stack
0263 2586 C64B  30         mov   r11,*stack            ; Save return address
0264 2588 0649  14         dect  stack
0265 258A C644  30         mov   tmp0,*stack           ; Save tmp0
0266 258C 0649  14         dect  stack
0267 258E C645  30         mov   tmp1,*stack           ; Save tmp1
0268 2590 0649  14         dect  stack
0269 2592 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 2594 0649  14         dect  stack
0271 2596 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 2598 0206  20         li    tmp2,8                ; Set loop counter
     259A 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 259C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 259E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25A0 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25A2 2516 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25A4 0606  14         dec   tmp2                  ; Next iteration
0288 25A6 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25A8 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25AA 2572 
0294                                                   ; / activating changes.
0295               
0296 25AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25B6 045B  20         b     *r11                  ; Return to caller
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
0318 25B8 0649  14         dect  stack
0319 25BA C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25BC 06A0  32         bl    @sams.layout
     25BE 2582 
0324 25C0 25C6                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25C4 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25C6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25C8 0002 
0336 25CA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25CC 0003 
0337 25CE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25D0 000A 
0338 25D2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25D4 000B 
0339 25D6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25D8 000C 
0340 25DA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25DC 000D 
0341 25DE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25E0 000E 
0342 25E2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25E4 000F 
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
0363 25E6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 25E8 0649  14         dect  stack
0366 25EA C64B  30         mov   r11,*stack            ; Push return address
0367 25EC 0649  14         dect  stack
0368 25EE C644  30         mov   tmp0,*stack           ; Push tmp0
0369 25F0 0649  14         dect  stack
0370 25F2 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 25F4 0649  14         dect  stack
0372 25F6 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 25F8 0649  14         dect  stack
0374 25FA C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 25FC 0205  20         li    tmp1,sams.layout.copy.data
     25FE 261E 
0379 2600 0206  20         li    tmp2,8                ; Set loop counter
     2602 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2604 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2606 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2608 24DE 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 260A CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     260C 833C 
0390               
0391 260E 0606  14         dec   tmp2                  ; Next iteration
0392 2610 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2612 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2614 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2616 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2618 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 261A C2F9  30         mov   *stack+,r11           ; Pop r11
0402 261C 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 261E 2000             data  >2000                 ; >2000-2fff
0408 2620 3000             data  >3000                 ; >3000-3fff
0409 2622 A000             data  >a000                 ; >a000-afff
0410 2624 B000             data  >b000                 ; >b000-bfff
0411 2626 C000             data  >c000                 ; >c000-cfff
0412 2628 D000             data  >d000                 ; >d000-dfff
0413 262A E000             data  >e000                 ; >e000-efff
0414 262C F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0114               
0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 262E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2630 FFBF 
0010 2632 0460  28         b     @putv01
     2634 2340 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2636 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2638 0040 
0018 263A 0460  28         b     @putv01
     263C 2340 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 263E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2640 FFDF 
0026 2642 0460  28         b     @putv01
     2644 2340 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2646 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2648 0020 
0034 264A 0460  28         b     @putv01
     264C 2340 
**** **** ****     > runlib.asm
0118               
0120                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 264E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2650 FFFE 
0011 2652 0460  28         b     @putv01
     2654 2340 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2656 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2658 0001 
0019 265A 0460  28         b     @putv01
     265C 2340 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 265E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2660 FFFD 
0027 2662 0460  28         b     @putv01
     2664 2340 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2666 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2668 0002 
0035 266A 0460  28         b     @putv01
     266C 2340 
**** **** ****     > runlib.asm
0122               
0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 266E C83B  50 at      mov   *r11+,@wyx
     2670 832A 
0019 2672 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2674 B820  54 down    ab    @hb$01,@wyx
     2676 201C 
     2678 832A 
0028 267A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 267C 7820  54 up      sb    @hb$01,@wyx
     267E 201C 
     2680 832A 
0037 2682 045B  20         b     *r11
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
0049 2684 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2686 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     2688 832A 
0051 268A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     268C 832A 
0052 268E 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 2690 C120  34 yx2px   mov   @wyx,tmp0
     2692 832A 
0022 2694 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2696 06C4  14         swpb  tmp0                  ; Y<->X
0024 2698 04C5  14         clr   tmp1                  ; Clear before copy
0025 269A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 269C 20A0  38         coc   @wbit1,config         ; f18a present ?
     269E 2028 
0030 26A0 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26A2 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26A4 833A 
     26A6 26D0 
0032 26A8 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26AA 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26AC B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26AE 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26B0 0500 
0037 26B2 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26B4 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26B6 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26B8 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26BA D105  18         movb  tmp1,tmp0
0051 26BC 06C4  14         swpb  tmp0                  ; X<->Y
0052 26BE 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26C0 202A 
0053 26C2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26C4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26C6 201C 
0059 26C8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26CA 202E 
0060 26CC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26CE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26D0 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0130               
0134               
0138               
0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 26D2 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26D4 06A0  32         bl    @putvr                ; Write once
     26D6 232C 
0015 26D8 391C             data  >391c                 ; VR1/57, value 00011100
0016 26DA 06A0  32         bl    @putvr                ; Write twice
     26DC 232C 
0017 26DE 391C             data  >391c                 ; VR1/57, value 00011100
0018 26E0 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26E2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26E4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26E6 232C 
0028 26E8 391C             data  >391c
0029 26EA 0458  20         b     *tmp4                 ; Exit
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
0040 26EC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26EE 06A0  32         bl    @cpym2v
     26F0 2432 
0042 26F2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26F4 2730 
     26F6 0006 
0043 26F8 06A0  32         bl    @putvr
     26FA 232C 
0044 26FC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26FE 06A0  32         bl    @putvr
     2700 232C 
0046 2702 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2704 0204  20         li    tmp0,>3f00
     2706 3F00 
0052 2708 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     270A 22B4 
0053 270C D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     270E 8800 
0054 2710 0984  56         srl   tmp0,8
0055 2712 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2714 8800 
0056 2716 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 2718 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 271A 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     271C BFFF 
0060 271E 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2720 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2722 4000 
0063               f18chk_exit:
0064 2724 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2726 2288 
0065 2728 3F00             data  >3f00,>00,6
     272A 0000 
     272C 0006 
0066 272E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2730 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2732 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2734 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2736 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2738 06A0  32         bl    @putvr
     273A 232C 
0097 273C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 273E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2740 232C 
0100 2742 391C             data  >391c                 ; Lock the F18a
0101 2744 0458  20         b     *tmp4                 ; Exit
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
0120 2746 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2748 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     274A 2028 
0122 274C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 274E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2750 8802 
0127 2752 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2754 232C 
0128 2756 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2758 04C4  14         clr   tmp0
0130 275A D120  34         movb  @vdps,tmp0
     275C 8802 
0131 275E 0984  56         srl   tmp0,8
0132 2760 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0142               
0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 2762 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2764 832A 
0018 2766 D17B  28         movb  *r11+,tmp1
0019 2768 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 276A D1BB  28         movb  *r11+,tmp2
0021 276C 0986  56         srl   tmp2,8                ; Repeat count
0022 276E C1CB  18         mov   r11,tmp3
0023 2770 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2772 23F4 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2774 020B  20         li    r11,hchar1
     2776 277C 
0028 2778 0460  28         b     @xfilv                ; Draw
     277A 228E 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 277C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     277E 202C 
0033 2780 1302  14         jeq   hchar2                ; Yes, exit
0034 2782 C2C7  18         mov   tmp3,r11
0035 2784 10EE  14         jmp   hchar                 ; Next one
0036 2786 05C7  14 hchar2  inct  tmp3
0037 2788 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0146               
0148                       copy  "vdp_vchar.asm"            ; VDP vchar functions
**** **** ****     > vdp_vchar.asm
0001               * FILE......: vdp_vchar.a99
0002               * Purpose...: VDP vchar module
0003               
0004               ***************************************************************
0005               * Repeat characters vertically at YX
0006               ***************************************************************
0007               *  BL    @VCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 278A C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     278C 832A 
0018 278E C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 2790 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     2792 833A 
0020 2794 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2796 23F4 
0021 2798 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 279A D1B7  28         movb  *tmp3+,tmp2
0023 279C 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 279E 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     27A0 22B0 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 27A2 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 27A4 A108  18         a     tmp4,tmp0             ; Next row
0033 27A6 0606  14         dec   tmp2
0034 27A8 16FA  14         jne   vchar2
0035 27AA 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27AC 202C 
0036 27AE 1303  14         jeq   vchar3                ; Yes, exit
0037 27B0 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     27B2 832A 
0038 27B4 10ED  14         jmp   vchar1                ; Next one
0039 27B6 05C7  14 vchar3  inct  tmp3
0040 27B8 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 27BA C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 27BC C804  38         mov   tmp0,@wyx             ; Set cursor position
     27BE 832A 
0051 27C0 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 27C2 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     27C4 833A 
0053 27C6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27C8 23F4 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 27CA 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     27CC 22B0 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 27CE D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 27D0 A120  34         a     @wcolmn,tmp0          ; Next row
     27D2 833A 
0063 27D4 0606  14         dec   tmp2
0064 27D6 16F9  14         jne   xvcha1
0065 27D8 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0150               
0154               
0158               
0162               
0166               
0170               
0174               
0176                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 27DA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27DC 202A 
0017 27DE 020C  20         li    r12,>0024
     27E0 0024 
0018 27E2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27E4 2872 
0019 27E6 04C6  14         clr   tmp2
0020 27E8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27EA 04CC  14         clr   r12
0025 27EC 1F08  20         tb    >0008                 ; Shift-key ?
0026 27EE 1302  14         jeq   realk1                ; No
0027 27F0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27F2 28A2 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27F4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27F6 1302  14         jeq   realk2                ; No
0033 27F8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27FA 28D2 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27FC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27FE 1302  14         jeq   realk3                ; No
0039 2800 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     2802 2902 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 2804 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 2806 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 2808 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 280A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     280C 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 280E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 2810 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     2812 0006 
0052 2814 0606  14 realk5  dec   tmp2
0053 2816 020C  20         li    r12,>24               ; CRU address for P2-P4
     2818 0024 
0054 281A 06C6  14         swpb  tmp2
0055 281C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 281E 06C6  14         swpb  tmp2
0057 2820 020C  20         li    r12,6                 ; CRU read address
     2822 0006 
0058 2824 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 2826 0547  14         inv   tmp3                  ;
0060 2828 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     282A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 282C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 282E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 2830 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2832 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2834 0285  22         ci    tmp1,8
     2836 0008 
0069 2838 1AFA  14         jl    realk6
0070 283A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 283C 1BEB  14         jh    realk5                ; No, next column
0072 283E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2840 C206  18 realk8  mov   tmp2,tmp4
0077 2842 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2844 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2846 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 2848 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 284A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 284C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 284E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2850 202A 
0087 2852 1608  14         jne   realka                ; No, continue saving key
0088 2854 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2856 289C 
0089 2858 1A05  14         jl    realka
0090 285A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     285C 289A 
0091 285E 1B02  14         jh    realka                ; No, continue
0092 2860 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2862 E000 
0093 2864 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2866 833C 
0094 2868 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     286A 2014 
0095 286C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     286E 8C00 
0096 2870 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2872 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2874 0000 
     2876 FF0D 
     2878 203D 
0099 287A ....             text  'xws29ol.'
0100 2882 ....             text  'ced38ik,'
0101 288A ....             text  'vrf47ujm'
0102 2892 ....             text  'btg56yhn'
0103 289A ....             text  'zqa10p;/'
0104 28A2 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     28A4 0000 
     28A6 FF0D 
     28A8 202B 
0105 28AA ....             text  'XWS@(OL>'
0106 28B2 ....             text  'CED#*IK<'
0107 28BA ....             text  'VRF$&UJM'
0108 28C2 ....             text  'BTG%^YHN'
0109 28CA ....             text  'ZQA!)P:-'
0110 28D2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28D4 0000 
     28D6 FF0D 
     28D8 2005 
0111 28DA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28DC 0804 
     28DE 0F27 
     28E0 C2B9 
0112 28E2 600B             data  >600b,>0907,>063f,>c1B8
     28E4 0907 
     28E6 063F 
     28E8 C1B8 
0113 28EA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28EC 7B02 
     28EE 015F 
     28F0 C0C3 
0114 28F2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28F4 7D0E 
     28F6 0CC6 
     28F8 BFC4 
0115 28FA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28FC 7C03 
     28FE BC22 
     2900 BDBA 
0116 2902 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     2904 0000 
     2906 FF0D 
     2908 209D 
0117 290A 9897             data  >9897,>93b2,>9f8f,>8c9B
     290C 93B2 
     290E 9F8F 
     2910 8C9B 
0118 2912 8385             data  >8385,>84b3,>9e89,>8b80
     2914 84B3 
     2916 9E89 
     2918 8B80 
0119 291A 9692             data  >9692,>86b4,>b795,>8a8D
     291C 86B4 
     291E B795 
     2920 8A8D 
0120 2922 8294             data  >8294,>87b5,>b698,>888E
     2924 87B5 
     2926 B698 
     2928 888E 
0121 292A 9A91             data  >9a91,>81b1,>b090,>9cBB
     292C 81B1 
     292E B090 
     2930 9CBB 
**** **** ****     > runlib.asm
0178               
0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 2932 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2934 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2936 8340 
0025 2938 04E0  34         clr   @waux1
     293A 833C 
0026 293C 04E0  34         clr   @waux2
     293E 833E 
0027 2940 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2942 833C 
0028 2944 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2946 0205  20         li    tmp1,4                ; 4 nibbles
     2948 0004 
0033 294A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 294C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     294E 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2950 0286  22         ci    tmp2,>000a
     2952 000A 
0039 2954 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2956 C21B  26         mov   *r11,tmp4
0045 2958 0988  56         srl   tmp4,8                ; Right justify
0046 295A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     295C FFF6 
0047 295E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2960 C21B  26         mov   *r11,tmp4
0054 2962 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2964 00FF 
0055               
0056 2966 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2968 06C6  14         swpb  tmp2
0058 296A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 296C 0944  56         srl   tmp0,4                ; Next nibble
0060 296E 0605  14         dec   tmp1
0061 2970 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2972 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2974 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2976 C160  34         mov   @waux3,tmp1           ; Get pointer
     2978 8340 
0067 297A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 297C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 297E C120  34         mov   @waux2,tmp0
     2980 833E 
0070 2982 06C4  14         swpb  tmp0
0071 2984 DD44  32         movb  tmp0,*tmp1+
0072 2986 06C4  14         swpb  tmp0
0073 2988 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 298A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     298C 8340 
0078 298E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2990 2020 
0079 2992 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2994 C120  34         mov   @waux1,tmp0
     2996 833C 
0084 2998 06C4  14         swpb  tmp0
0085 299A DD44  32         movb  tmp0,*tmp1+
0086 299C 06C4  14         swpb  tmp0
0087 299E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 29A0 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29A2 202A 
0092 29A4 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29A6 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29A8 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29AA 7FFF 
0098 29AC C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29AE 8340 
0099 29B0 0460  28         b     @xutst0               ; Display string
     29B2 241A 
0100 29B4 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29B6 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29B8 832A 
0122 29BA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29BC 8000 
0123 29BE 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0182               
0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 29C0 0207  20 mknum   li    tmp3,5                ; Digit counter
     29C2 0005 
0020 29C4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29C6 C155  26         mov   *tmp1,tmp1            ; /
0022 29C8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29CA 0228  22         ai    tmp4,4                ; Get end of buffer
     29CC 0004 
0024 29CE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29D0 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29D2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29D4 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29D6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29D8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29DA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29DC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29DE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29E0 0607  14         dec   tmp3                  ; Decrease counter
0036 29E2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29E4 0207  20         li    tmp3,4                ; Check first 4 digits
     29E6 0004 
0041 29E8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29EA C11B  26         mov   *r11,tmp0
0043 29EC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29EE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29F0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29F2 05CB  14 mknum3  inct  r11
0047 29F4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29F6 202A 
0048 29F8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29FA 045B  20         b     *r11                  ; Exit
0050 29FC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29FE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 2A00 13F8  14         jeq   mknum3                ; Yes, exit
0053 2A02 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 2A04 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A06 7FFF 
0058 2A08 C10B  18         mov   r11,tmp0
0059 2A0A 0224  22         ai    tmp0,-4
     2A0C FFFC 
0060 2A0E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A10 0206  20         li    tmp2,>0500            ; String length = 5
     2A12 0500 
0062 2A14 0460  28         b     @xutstr               ; Display string
     2A16 241C 
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
0092 2A18 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 2A1A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 2A1C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 2A1E 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 2A20 0207  20         li    tmp3,5                ; Set counter
     2A22 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A24 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A26 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A28 0584  14         inc   tmp0                  ; Next character
0104 2A2A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A2C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A2E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A30 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A32 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A34 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A36 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A38 0607  14         dec   tmp3                  ; Last character ?
0120 2A3A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A3C 045B  20         b     *r11                  ; Return
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
0138 2A3E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A40 832A 
0139 2A42 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A44 8000 
0140 2A46 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0190               
0194               
0198               
0202               
0206               
0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0022 2A48 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2A4A 3E00 
0023 2A4C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2A4E 3E02 
0024 2A50 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A52 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A54 0200  20         li    r0,>8306              ; Scratpad source address
     2A56 8306 
0029 2A58 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A5A 3E06 
0030 2A5C 0202  20         li    r2,62                 ; Loop counter
     2A5E 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A60 CC70  46         mov   *r0+,*r1+
0036 2A62 CC70  46         mov   *r0+,*r1+
0037 2A64 0642  14         dect  r2
0038 2A66 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A68 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A6A 83FE 
     2A6C 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A6E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A70 3E00 
0045 2A72 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A74 3E02 
0046 2A76 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A78 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A7A 045B  20         b     *r11                  ; Return to caller
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
0070 2A7C C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A7E 3E00 
     2A80 8300 
0071 2A82 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A84 3E02 
     2A86 8302 
0072 2A88 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A8A 3E04 
     2A8C 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A8E C800  38         mov   r0,@cpu.scrpad.tgt
     2A90 3E00 
0077 2A92 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A94 3E02 
0078 2A96 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A98 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A9A 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A9C 3E06 
0083 2A9E 0201  20         li    r1,>8306
     2AA0 8306 
0084 2AA2 0202  20         li    r2,62
     2AA4 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2AA6 CC70  46         mov   *r0+,*r1+
0090 2AA8 CC70  46         mov   *r0+,*r1+
0091 2AAA 0642  14         dect  r2
0092 2AAC 16FC  14         jne   cpu.scrpad.restore.copy
0093 2AAE C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2AB0 3EFE 
     2AB2 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2AB4 C020  34         mov   @cpu.scrpad.tgt,r0
     2AB6 3E00 
0099 2AB8 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2ABA 3E02 
0100 2ABC C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2ABE 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2AC0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0025 2AC2 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2AC4 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2AC6 8300 
0031 2AC8 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2ACA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2ACC 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2ACE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2AD0 0606  14         dec   tmp2
0038 2AD2 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2AD4 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2AD6 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2AD8 2ADE 
0044                                                   ; R14=PC
0045 2ADA 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2ADC 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2ADE 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2AE0 2A7C 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2AE2 045B  20         b     *r11                  ; Return to caller
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
0078 2AE4 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2AE6 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2AE8 8300 
0084 2AEA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2AEC 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2AEE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2AF0 0606  14         dec   tmp2
0090 2AF2 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AF4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AF6 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2AF8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0211               
0213                       copy  "equ_fio.asm"              ; File I/O equates
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
0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
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
0041 2AFA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2AFC 2AFE             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2AFE C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2B00 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2B02 8322 
0049 2B04 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2B06 2026 
0050 2B08 C020  34         mov   @>8356,r0             ; get ptr to pab
     2B0A 8356 
0051 2B0C C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2B0E 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2B10 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2B12 06C0  14         swpb  r0                    ;
0059 2B14 D800  38         movb  r0,@vdpa              ; send low byte
     2B16 8C02 
0060 2B18 06C0  14         swpb  r0                    ;
0061 2B1A D800  38         movb  r0,@vdpa              ; send high byte
     2B1C 8C02 
0062 2B1E D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2B20 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B22 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2B24 0704  14         seto  r4                    ; init counter
0070 2B26 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2B28 A420 
0071 2B2A 0580  14 !       inc   r0                    ; point to next char of name
0072 2B2C 0584  14         inc   r4                    ; incr char counter
0073 2B2E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2B30 0007 
0074 2B32 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2B34 80C4  18         c     r4,r3                 ; end of name?
0077 2B36 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2B38 06C0  14         swpb  r0                    ;
0082 2B3A D800  38         movb  r0,@vdpa              ; send low byte
     2B3C 8C02 
0083 2B3E 06C0  14         swpb  r0                    ;
0084 2B40 D800  38         movb  r0,@vdpa              ; send high byte
     2B42 8C02 
0085 2B44 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B46 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2B48 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2B4A 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2B4C 2C0E 
0093 2B4E 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B50 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B52 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B54 04E0  34         clr   @>83d0
     2B56 83D0 
0102 2B58 C804  38         mov   r4,@>8354             ; save name length for search
     2B5A 8354 
0103 2B5C 0584  14         inc   r4                    ; adjust for dot
0104 2B5E A804  38         a     r4,@>8356             ; point to position after name
     2B60 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B62 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B64 83E0 
0110 2B66 04C1  14         clr   r1                    ; version found of dsr
0111 2B68 020C  20         li    r12,>0f00             ; init cru addr
     2B6A 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B6C C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B6E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B70 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B72 022C  22         ai    r12,>0100             ; next rom to turn on
     2B74 0100 
0125 2B76 04E0  34         clr   @>83d0                ; clear in case we are done
     2B78 83D0 
0126 2B7A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B7C 2000 
0127 2B7E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B80 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B82 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B84 1D00  20         sbo   0                     ; turn on rom
0134 2B86 0202  20         li    r2,>4000              ; start at beginning of rom
     2B88 4000 
0135 2B8A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B8C 2C0A 
0136 2B8E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B90 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B92 A40A 
0146 2B94 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B96 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B98 83D2 
0152                                                   ; subprogram
0153               
0154 2B9A 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B9C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B9E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2BA0 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BA2 83D2 
0163                                                   ; subprogram
0164               
0165 2BA4 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2BA6 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2BA8 04C5  14         clr   r5                    ; Remove any old stuff
0174 2BAA D160  34         movb  @>8355,r5             ; get length as counter
     2BAC 8355 
0175 2BAE 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2BB0 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2BB2 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2BB4 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2BB6 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BB8 A420 
0186 2BBA 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2BBC 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2BBE 0605  14         dec   r5                    ; loop until full length checked
0191 2BC0 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2BC2 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2BC4 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2BC6 0581  14         inc   r1                    ; next version found
0203 2BC8 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2BCA 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2BCC 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2BCE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BD0 A400 
0212 2BD2 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2BD4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BD6 8322 
0214                                                   ; (8 or >a)
0215 2BD8 0281  22         ci    r1,8                  ; was it 8?
     2BDA 0008 
0216 2BDC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2BDE D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BE0 8350 
0218                                                   ; Get error byte from @>8350
0219 2BE2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2BE4 06C0  14         swpb  r0                    ;
0227 2BE6 D800  38         movb  r0,@vdpa              ; send low byte
     2BE8 8C02 
0228 2BEA 06C0  14         swpb  r0                    ;
0229 2BEC D800  38         movb  r0,@vdpa              ; send high byte
     2BEE 8C02 
0230 2BF0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BF2 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BF4 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BF6 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BF8 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BFA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BFC A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BFE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2C00 06C1  14         swpb  r1                    ; put error in hi byte
0252 2C02 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2C04 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2C06 2026 
0254 2C08 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2C0A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2C0C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2C0E ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
**** **** ****     > runlib.asm
0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
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
0043 2C10 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2C12 C04B  18         mov   r11,r1                ; Save return address
0049 2C14 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C16 A428 
0050 2C18 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2C1A 04C5  14         clr   tmp1                  ; io.op.open
0052 2C1C 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C1E 22C6 
0053               file.open_init:
0054 2C20 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C22 0009 
0055 2C24 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C26 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2C28 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C2A 2AFA 
0061 2C2C 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2C2E 1029  14         jmp   file.record.pab.details
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
0090 2C30 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2C32 C04B  18         mov   r11,r1                ; Save return address
0096 2C34 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C36 A428 
0097 2C38 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2C3A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C3C 0001 
0099 2C3E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C40 22C6 
0100               file.close_init:
0101 2C42 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C44 0009 
0102 2C46 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C48 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2C4A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C4C 2AFA 
0108 2C4E 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C50 1018  14         jmp   file.record.pab.details
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
0139 2C52 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C54 C04B  18         mov   r11,r1                ; Save return address
0145 2C56 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C58 A428 
0146 2C5A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C5C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C5E 0002 
0148 2C60 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C62 22C6 
0149               file.record.read_init:
0150 2C64 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C66 0009 
0151 2C68 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C6A 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C6C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C6E 2AFA 
0157 2C70 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C72 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C74 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C76 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C78 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C7A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C7C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C7E 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C80 1000  14         nop
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
0211 2C82 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C84 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C86 A428 
0219 2C88 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C8A 0005 
0220 2C8C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C8E 22DE 
0221 2C90 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C92 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0226                                                   ; as returned by DSRLNK
0227               *--------------------------------------------------------------
0228               * Exit
0229               *--------------------------------------------------------------
0230               ; If an error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=tmp2) is set to 1.
0232               ;
0233               ; If no error occured during the IO operation, then the
0234               ; equal bit in the saved status register (=tmp2) is set to 0.
0235               ;
0236               ; Upon return from this IO call you should basically test with:
0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0239               ;
0240               ; Then look for further details in the copy of VDP PAB byte 1
0241               ; in register tmp0, bits 13-15
0242               ;
0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0244               ;                                   ; calls, skip for type >A subprograms!)
0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0246               ;       jeq   my_error_handler
0247               *--------------------------------------------------------------
0248               file.record.pab.details.exit:
0249 2C94 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                            TIMERS
0220               *//////////////////////////////////////////////////////////////
0221               
0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 2C96 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C98 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C9A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C9C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C9E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2CA0 2026 
0029 2CA2 1602  14         jne   tmgr1a                ; No, so move on
0030 2CA4 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2CA6 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2CA8 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2CAA 202A 
0035 2CAC 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2CAE 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2CB0 201A 
0048 2CB2 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2CB4 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2CB6 2018 
0050 2CB8 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2CBA 0460  28         b     @kthread              ; Run kernel thread
     2CBC 2D34 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2CBE 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2CC0 201E 
0056 2CC2 13EB  14         jeq   tmgr1
0057 2CC4 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CC6 201C 
0058 2CC8 16E8  14         jne   tmgr1
0059 2CCA C120  34         mov   @wtiusr,tmp0
     2CCC 832E 
0060 2CCE 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CD0 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CD2 2D32 
0065 2CD4 C10A  18         mov   r10,tmp0
0066 2CD6 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CD8 00FF 
0067 2CDA 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CDC 2026 
0068 2CDE 1303  14         jeq   tmgr5
0069 2CE0 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CE2 003C 
0070 2CE4 1002  14         jmp   tmgr6
0071 2CE6 0284  22 tmgr5   ci    tmp0,50
     2CE8 0032 
0072 2CEA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CEC 1001  14         jmp   tmgr8
0074 2CEE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CF0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CF2 832C 
0079 2CF4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CF6 FF00 
0080 2CF8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CFA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CFC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CFE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D00 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D02 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D04 830C 
     2D06 830D 
0089 2D08 1608  14         jne   tmgr10                ; No, get next slot
0090 2D0A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D0C FF00 
0091 2D0E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D10 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D12 8330 
0096 2D14 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D16 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D18 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D1A 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D1C 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D1E 8315 
     2D20 8314 
0103 2D22 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D24 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D26 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D28 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D2A 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D2C 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D2E FF00 
0109 2D30 10B4  14         jmp   tmgr1
0110 2D32 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 2D34 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D36 201A 
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
0041 2D38 06A0  32         bl    @realkb               ; Scan full keyboard
     2D3A 27DA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D3C 0460  28         b     @tmgr3                ; Exit
     2D3E 2CBE 
**** **** ****     > runlib.asm
0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 2D40 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D42 832E 
0018 2D44 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D46 201C 
0019 2D48 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C9A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D4A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D4C 832E 
0029 2D4E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D50 FEFF 
0030 2D52 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0225               
0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 2D54 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D56 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D58 C184  18         mov   tmp0,tmp2
0023 2D5A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D5C A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D5E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D60 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D62 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D64 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D66 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D68 202C 
0035 2D6A 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D6C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D6E 05CB  14 mkslo1  inct  r11
0041 2D70 045B  20         b     *r11                  ; Exit
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
0052 2D72 C13B  30 clslot  mov   *r11+,tmp0
0053 2D74 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D76 A120  34         a     @wtitab,tmp0          ; Add table base
     2D78 832C 
0055 2D7A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D7C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D7E 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0229               
0230               
0231               
0232               *//////////////////////////////////////////////////////////////
0233               *                    RUNLIB INITIALISATION
0234               *//////////////////////////////////////////////////////////////
0235               
0236               ***************************************************************
0237               *  RUNLIB - Runtime library initalisation
0238               ***************************************************************
0239               *  B  @RUNLIB
0240               *--------------------------------------------------------------
0241               *  REMARKS
0242               *  if R0 in WS1 equals >4a4a we were called from the system
0243               *  crash handler so we return there after initialisation.
0244               
0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0246               *  after clearing scratchpad memory. This has higher priority
0247               *  as crash handler flag R0.
0248               ********|*****|*********************|**************************
0250 2D80 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D82 2A48 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D84 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D86 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D88 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D8A 0000 
0261 2D8C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D8E 8300 
0262 2D90 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D92 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D94 0202  20 runli2  li    r2,>8308
     2D96 8308 
0267 2D98 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D9A 0282  22         ci    r2,>8400
     2D9C 8400 
0269 2D9E 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2DA0 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2DA2 FFFF 
0274 2DA4 1602  14         jne   runli4                ; No, continue
0275 2DA6 0420  54         blwp  @0                    ; Yes, bye bye
     2DA8 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2DAA C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2DAC 833C 
0280 2DAE 04C1  14         clr   r1                    ; Reset counter
0281 2DB0 0202  20         li    r2,10                 ; We test 10 times
     2DB2 000A 
0282 2DB4 C0E0  34 runli5  mov   @vdps,r3
     2DB6 8802 
0283 2DB8 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2DBA 202A 
0284 2DBC 1302  14         jeq   runli6
0285 2DBE 0581  14         inc   r1                    ; Increase counter
0286 2DC0 10F9  14         jmp   runli5
0287 2DC2 0602  14 runli6  dec   r2                    ; Next test
0288 2DC4 16F7  14         jne   runli5
0289 2DC6 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DC8 1250 
0290 2DCA 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2DCC 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DCE 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2DD0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2DD2 221A 
0296 2DD4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2DD6 8322 
0297 2DD8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2DDA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2DDC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2DDE 04C1  14 runli9  clr   r1
0304 2DE0 04C2  14         clr   r2
0305 2DE2 04C3  14         clr   r3
0306 2DE4 0209  20         li    stack,>8400           ; Set stack
     2DE6 8400 
0307 2DE8 020F  20         li    r15,vdpw              ; Set VDP write address
     2DEA 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2DEC 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DEE 4A4A 
0316 2DF0 1605  14         jne   runlia
0317 2DF2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DF4 2288 
0318 2DF6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DF8 0000 
     2DFA 3FFF 
0323 2DFC 06A0  32 runlia  bl    @filv
     2DFE 2288 
0324 2E00 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E02 00F4 
     2E04 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2E06 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E08 26D2 
0332 2E0A 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E0C 26EC 
0333 2E0E 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E10 26E2 
0334               
0335 2E12 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E14 232C 
0336 2E16 3201                   data >3201            ; F18a VR50 (>32), bit 1
0338               *--------------------------------------------------------------
0339               * Check if there is a speech synthesizer attached
0340               *--------------------------------------------------------------
0342               *       <<skipped>>
0346               *--------------------------------------------------------------
0347               * Load video mode table & font
0348               *--------------------------------------------------------------
0349 2E18 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E1A 22F2 
0350 2E1C 746E             data  spvmod                ; Equate selected video mode table
0351 2E1E 0204  20         li    tmp0,spfont           ; Get font option
     2E20 000C 
0352 2E22 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0353 2E24 1304  14         jeq   runlid                ; Yes, skip it
0354 2E26 06A0  32         bl    @ldfnt
     2E28 235A 
0355 2E2A 1100             data  fntadr,spfont         ; Load specified font
     2E2C 000C 
0356               *--------------------------------------------------------------
0357               * Did a system crash occur before runlib was called?
0358               *--------------------------------------------------------------
0359 2E2E 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E30 4A4A 
0360 2E32 1602  14         jne   runlie                ; No, continue
0361 2E34 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E36 2090 
0362               *--------------------------------------------------------------
0363               * Branch to main program
0364               *--------------------------------------------------------------
0365 2E38 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E3A 0040 
0366 2E3C 0460  28         b     @main                 ; Give control to main program
     2E3E 6050 
**** **** ****     > stevie_b1.asm.299124
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
0034                       ;-----------------------------------------------------------------------
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
     6064 262E 
0042 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26D2 
0043 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 232C 
0044 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0045               
0046 6070 06A0  32         bl    @putvr                ; Turn on position based attributes
     6072 232C 
0047 6074 3202                   data >3202            ; F18a VR50 (>32), bit 2
0048               
0049 6076 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     6078 232C 
0050 607A 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0051               
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 607C 06A0  32         bl    @filv
     607E 2288 
0056 6080 0000                   data >0000,32,30*80   ; Clear screen
     6082 0020 
     6084 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize position-based colors (VDP TAT)
0059                       ;------------------------------------------------------
0060 6086 06A0  32         bl    @filv
     6088 2288 
0061 608A 1800                   data >1800,>f0,29*80  ; Colors for frame buffer area
     608C 00F0 
     608E 0910 
0062               
0063 6090 06A0  32         bl    @filv
     6092 2288 
0064 6094 2110                   data >2110,>1f,1*80   ; Colors for bottom line pane
     6096 001F 
     6098 0050 
0065                       ;------------------------------------------------------
0066                       ; Complete F18A VDP setup
0067                       ;------------------------------------------------------
0068 609A 06A0  32         bl    @scron                ; Turn screen on
     609C 2636 
0069                       ;------------------------------------------------------
0070                       ; Initialize high memory expansion
0071                       ;------------------------------------------------------
0072 609E 06A0  32         bl    @film
     60A0 2230 
0073 60A2 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     60A4 0000 
     60A6 6000 
0074                       ;------------------------------------------------------
0075                       ; Setup SAMS windows
0076                       ;------------------------------------------------------
0077 60A8 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     60AA 672C 
0078                       ;------------------------------------------------------
0079                       ; Setup cursor, screen, etc.
0080                       ;------------------------------------------------------
0081 60AC 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     60AE 264E 
0082 60B0 06A0  32         bl    @s8x8                 ; Small sprite
     60B2 265E 
0083               
0084 60B4 06A0  32         bl    @cpym2m
     60B6 247A 
0085 60B8 7478                   data romsat,ramsat,4  ; Load sprite SAT
     60BA 8380 
     60BC 0004 
0086               
0087 60BE C820  54         mov   @romsat+2,@tv.curshape
     60C0 747A 
     60C2 A014 
0088                                                   ; Save cursor shape & color
0089               
0090 60C4 06A0  32         bl    @cpym2v
     60C6 2432 
0091 60C8 2800                   data sprpdt,cursors,3*8
     60CA 747C 
     60CC 0018 
0092                                                   ; Load sprite cursor patterns
0093               
0094 60CE 06A0  32         bl    @cpym2v
     60D0 2432 
0095 60D2 1008                   data >1008,patterns,11*8
     60D4 7494 
     60D6 0058 
0096                                                   ; Load character patterns
0097               *--------------------------------------------------------------
0098               * Initialize
0099               *--------------------------------------------------------------
0100 60D8 06A0  32         bl    @stevie.init          ; Initialize Stevie editor config
     60DA 6720 
0101 60DC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60DE 6D30 
0102 60E0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60E2 6B44 
0103 60E4 06A0  32         bl    @idx.init             ; Initialize index
     60E6 68B2 
0104 60E8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60EA 6788 
0105                       ;-------------------------------------------------------
0106                       ; Setup editor tasks & hook
0107                       ;-------------------------------------------------------
0108 60EC 0204  20         li    tmp0,>0200
     60EE 0200 
0109 60F0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60F2 8314 
0110               
0111 60F4 06A0  32         bl    @at
     60F6 266E 
0112 60F8 0000                   data  >0000           ; Cursor YX position = >0000
0113               
0114 60FA 0204  20         li    tmp0,timers
     60FC 8370 
0115 60FE C804  38         mov   tmp0,@wtitab
     6100 832C 
0116               
0117 6102 06A0  32         bl    @mkslot
     6104 2D54 
0118 6106 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     6108 710E 
0119 610A 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     610C 71A6 
0120 610E 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     6110 71DA 
0121 6112 FFFF                   data eol
0122               
0123 6114 06A0  32         bl    @mkhook
     6116 2D40 
0124 6118 70DE                   data hook.keyscan     ; Setup user hook
0125               
0126 611A 0460  28         b     @tmgr                 ; Start timers and kthread
     611C 2C96 
0127               
0128               
**** **** ****     > stevie_b1.asm.299124
0038                       copy  "edkey.asm"           ; Keyboard actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 611E C160  34         mov   @waux1,tmp1           ; Get key value
     6120 833C 
0010 6122 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6124 FF00 
0011 6126 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 6128 C1A0  34         mov   @tv.pane.focus,tmp2
     612A A018 
0016 612C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     612E 0000 
0017 6130 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 6132 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6134 0001 
0021 6136 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 6138 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     613A FFCE 
0027 613C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     613E 2030 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 6140 0206  20         li    tmp2,keymap_actions.editor
     6142 7998 
0033 6144 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6146 0206  20         li    tmp2,keymap_actions.cmdb
     6148 7A5A 
0039 614A 1600  14         jne   edkey.key.check_next
0040                       ;-------------------------------------------------------
0041                       ; Iterate over keyboard map for matching action key
0042                       ;-------------------------------------------------------
0043               edkey.key.check_next:
0044 614C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0045 614E 1309  14         jeq   edkey.key.process.addbuffer
0046                                                   ; Yes, means no action key pressed, so
0047                                                   ; add character to buffer
0048                       ;-------------------------------------------------------
0049                       ; Check for action key match
0050                       ;-------------------------------------------------------
0051 6150 8585  30         c     tmp1,*tmp2            ; Action key matched?
0052 6152 1303  14         jeq   edkey.key.process.action
0053                                                   ; Yes, do action
0054 6154 0226  22         ai    tmp2,6                ; Skip current entry
     6156 0006 
0055 6158 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0056                       ;-------------------------------------------------------
0057                       ; Trigger keyboard action
0058                       ;-------------------------------------------------------
0059               edkey.key.process.action:
0060 615A 0226  22         ai    tmp2,4                ; Move to action address
     615C 0004 
0061 615E C196  26         mov   *tmp2,tmp2            ; Get action address
0062 6160 0456  20         b     *tmp2                 ; Process key action
0063                       ;-------------------------------------------------------
0064                       ; Add character to appropriate buffer
0065                       ;-------------------------------------------------------
0066               edkey.key.process.addbuffer:
0067 6162 C120  34         mov  @tv.pane.focus,tmp0    ; Frame buffer has focus?
     6164 A018 
0068 6166 1602  14         jne  !                      ; No, skip frame buffer
0069 6168 0460  28         b    @edkey.action.char     ; Add character to frame buffer
     616A 65FE 
0070                       ;-------------------------------------------------------
0071                       ; CMDB buffer
0072                       ;-------------------------------------------------------
0073 616C 0284  22 !       ci   tmp0,pane.focus.cmdb   ; CMDB has focus ?
     616E 0001 
0074 6170 1602  14         jne  edkey.key.process.crash
0075                                                   ; No, crash
0076 6172 0460  28         b    @edkey.cmdb.action.char
     6174 66F2 
0077                                                   ; Add character to CMDB buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6176 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6178 FFCE 
0083 617A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     617C 2030 
**** **** ****     > stevie_b1.asm.299124
0039                       copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys
**** **** ****     > edkey.fb.mov.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 617E C120  34         mov   @fb.column,tmp0
     6180 A10C 
0010 6182 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6184 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6186 A10C 
0015 6188 0620  34         dec   @wyx                  ; Column-- VDP cursor
     618A 832A 
0016 618C 0620  34         dec   @fb.current
     618E A102 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6190 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6192 7102 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6194 8820  54         c     @fb.column,@fb.row.length
     6196 A10C 
     6198 A108 
0028 619A 1406  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 619C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     619E A10C 
0033 61A0 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     61A2 832A 
0034 61A4 05A0  34         inc   @fb.current
     61A6 A102 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 61A8 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     61AA 7102 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 61AC 8820  54         c     @fb.row.dirty,@w$ffff
     61AE A10A 
     61B0 202C 
0049 61B2 1604  14         jne   edkey.action.up.cursor
0050 61B4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61B6 6B7A 
0051 61B8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61BA A10A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 61BC C120  34         mov   @fb.row,tmp0
     61BE A106 
0057 61C0 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row > 0
0059 61C2 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     61C4 A104 
0060 61C6 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 61C8 0604  14         dec   tmp0                  ; fb.topline--
0066 61CA C804  38         mov   tmp0,@parm1
     61CC 8350 
0067 61CE 06A0  32         bl    @fb.refresh           ; Scroll one line up
     61D0 67FA 
0068 61D2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61D4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61D6 A106 
0074 61D8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61DA 267C 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61DC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61DE 6D12 
0080 61E0 8820  54         c     @fb.column,@fb.row.length
     61E2 A10C 
     61E4 A108 
0081 61E6 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 61E8 C820  54         mov   @fb.row.length,@fb.column
     61EA A108 
     61EC A10C 
0086 61EE C120  34         mov   @fb.column,tmp0
     61F0 A10C 
0087 61F2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61F4 2686 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61F8 67DE 
0093 61FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61FC 7102 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 61FE 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6200 A106 
     6202 A204 
0102 6204 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 6206 8820  54         c     @fb.row.dirty,@w$ffff
     6208 A10A 
     620A 202C 
0107 620C 1604  14         jne   edkey.action.down.move
0108 620E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6210 6B7A 
0109 6212 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6214 A10A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 6216 C120  34         mov   @fb.topline,tmp0
     6218 A104 
0118 621A A120  34         a     @fb.row,tmp0
     621C A106 
0119 621E 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6220 A204 
0120 6222 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 6224 C120  34         mov   @fb.scrrows,tmp0
     6226 A118 
0126 6228 0604  14         dec   tmp0
0127 622A 8120  34         c     @fb.row,tmp0
     622C A106 
0128 622E 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 6230 C820  54         mov   @fb.topline,@parm1
     6232 A104 
     6234 8350 
0133 6236 05A0  34         inc   @parm1
     6238 8350 
0134 623A 06A0  32         bl    @fb.refresh
     623C 67FA 
0135 623E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6240 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6242 A106 
0141 6244 06A0  32         bl    @down                 ; Row++ VDP cursor
     6246 2674 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6248 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     624A 6D12 
0147               
0148 624C 8820  54         c     @fb.column,@fb.row.length
     624E A10C 
     6250 A108 
0149 6252 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 6254 C820  54         mov   @fb.row.length,@fb.column
     6256 A108 
     6258 A10C 
0155 625A C120  34         mov   @fb.column,tmp0
     625C A10C 
0156 625E 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6260 2686 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6262 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6264 67DE 
0162 6266 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6268 7102 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 626A C120  34         mov   @wyx,tmp0
     626C 832A 
0171 626E 0244  22         andi  tmp0,>ff00
     6270 FF00 
0172 6272 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6274 832A 
0173 6276 04E0  34         clr   @fb.column
     6278 A10C 
0174 627A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     627C 67DE 
0175 627E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6280 7102 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 6282 C120  34         mov   @fb.row.length,tmp0
     6284 A108 
0182 6286 C804  38         mov   tmp0,@fb.column
     6288 A10C 
0183 628A 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     628C 2686 
0184 628E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6290 67DE 
0185 6292 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6294 7102 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 6296 C120  34         mov   @fb.column,tmp0
     6298 A10C 
0194 629A 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 629C C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     629E A102 
0199 62A0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 62A2 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 62A4 0605  14         dec   tmp1
0206 62A6 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 62A8 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 62AA D195  26         movb  *tmp1,tmp2            ; Get character
0214 62AC 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 62AE D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 62B0 0986  56         srl   tmp2,8                ; Right justify
0217 62B2 0286  22         ci    tmp2,32               ; Space character found?
     62B4 0020 
0218 62B6 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 62B8 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62BA 2020 
0224 62BC 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 62BE 0287  22         ci    tmp3,>20ff            ; First character is space
     62C0 20FF 
0227 62C2 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 62C4 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     62C6 A10C 
0232 62C8 61C4  18         s     tmp0,tmp3
0233 62CA 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     62CC 0002 
0234 62CE 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 62D0 0585  14         inc   tmp1
0240 62D2 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 62D4 C805  38         mov   tmp1,@fb.current
     62D6 A102 
0246 62D8 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62DA A10C 
0247 62DC 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62DE 2686 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62E2 67DE 
0253 62E4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62E6 7102 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 62E8 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 62EA C120  34         mov   @fb.column,tmp0
     62EC A10C 
0263 62EE 8804  38         c     tmp0,@fb.row.length
     62F0 A108 
0264 62F2 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 62F4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62F6 A102 
0269 62F8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 62FA 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 62FC 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 62FE 0585  14         inc   tmp1
0281 6300 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 6302 8804  38         c     tmp0,@fb.row.length
     6304 A108 
0283 6306 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 6308 D195  26         movb  *tmp1,tmp2            ; Get character
0290 630A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 630C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 630E 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 6310 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6312 FFFF 
0295 6314 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 6316 0286  22         ci    tmp2,32
     6318 0020 
0301 631A 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 631C 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 631E 0286  22         ci    tmp2,32               ; Space character found?
     6320 0020 
0309 6322 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 6324 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6326 2020 
0315 6328 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 632A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     632C 20FF 
0318 632E 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 6330 0585  14         inc   tmp1
0323 6332 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 6334 C805  38         mov   tmp1,@fb.current
     6336 A102 
0329 6338 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     633A A10C 
0330 633C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     633E 2686 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6340 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6342 67DE 
0336 6344 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6346 7102 
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
0348 6348 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     634A A104 
0349 634C 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 634E 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6350 A118 
0354 6352 1503  14         jgt   edkey.action.ppage.topline
0355 6354 04E0  34         clr   @fb.topline           ; topline = 0
     6356 A104 
0356 6358 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 635A 6820  54         s     @fb.scrrows,@fb.topline
     635C A118 
     635E A104 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 6360 8820  54         c     @fb.row.dirty,@w$ffff
     6362 A10A 
     6364 202C 
0367 6366 1604  14         jne   edkey.action.ppage.refresh
0368 6368 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     636A 6B7A 
0369 636C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636E A10A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 6370 C820  54         mov   @fb.topline,@parm1
     6372 A104 
     6374 8350 
0375 6376 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6378 67FA 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 637A 04E0  34         clr   @fb.row
     637C A106 
0381 637E 04E0  34         clr   @fb.column
     6380 A10C 
0382 6382 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     6384 832A 
0383 6386 0460  28         b     @edkey.action.up      ; In edkey.action up cursor is moved up
     6388 61AC 
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
0394 638A C120  34         mov   @fb.topline,tmp0
     638C A104 
0395 638E A120  34         a     @fb.scrrows,tmp0
     6390 A118 
0396 6392 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6394 A204 
0397 6396 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 6398 A820  54         a     @fb.scrrows,@fb.topline
     639A A118 
     639C A104 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 639E 8820  54         c     @fb.row.dirty,@w$ffff
     63A0 A10A 
     63A2 202C 
0408 63A4 1604  14         jne   edkey.action.npage.refresh
0409 63A6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63A8 6B7A 
0410 63AA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63AC A10A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 63AE 0460  28         b     @edkey.action.ppage.refresh
     63B0 6370 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 63B2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63B4 7102 
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
0433 63B6 8820  54         c     @fb.row.dirty,@w$ffff
     63B8 A10A 
     63BA 202C 
0434 63BC 1604  14         jne   edkey.action.top.refresh
0435 63BE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63C0 6B7A 
0436 63C2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63C4 A10A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 63C6 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     63C8 A104 
0442 63CA 04E0  34         clr   @parm1
     63CC 8350 
0443 63CE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63D0 67FA 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 63D2 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63D4 A106 
0449 63D6 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63D8 A10C 
0450 63DA 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63DC 832A 
0451 63DE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63E0 7102 
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
0462 63E2 8820  54         c     @fb.row.dirty,@w$ffff
     63E4 A10A 
     63E6 202C 
0463 63E8 1604  14         jne   edkey.action.bot.refresh
0464 63EA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63EC 6B7A 
0465 63EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63F0 A10A 
0466                       ;-------------------------------------------------------
0467                       ; Refresh page
0468                       ;-------------------------------------------------------
0469               edkey.action.bot.refresh:
0470 63F2 8820  54         c     @edb.lines,@fb.scrrows
     63F4 A204 
     63F6 A118 
0471                                                   ; Skip if whole editor buffer on screen
0472 63F8 1212  14         jle   !
0473 63FA C120  34         mov   @edb.lines,tmp0
     63FC A204 
0474 63FE 6120  34         s     @fb.scrrows,tmp0
     6400 A118 
0475 6402 C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     6404 A104 
0476 6406 C804  38         mov   tmp0,@parm1
     6408 8350 
0477 640A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     640C 67FA 
0478                       ;-------------------------------------------------------
0479                       ; Exit
0480                       ;-------------------------------------------------------
0481               edkey.action.bot.exit:
0482 640E 04E0  34         clr   @fb.row               ; Editor line 0
     6410 A106 
0483 6412 04E0  34         clr   @fb.column            ; Editor column 0
     6414 A10C 
0484 6416 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     6418 0100 
0485 641A C804  38         mov   tmp0,@wyx             ; Set cursor
     641C 832A 
0486 641E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6420 7102 
**** **** ****     > stevie_b1.asm.299124
0040                       copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 6422 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6424 A206 
0010 6426 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6428 67DE 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 642A C120  34         mov   @fb.current,tmp0      ; Get pointer
     642C A102 
0015 642E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6430 A108 
0016 6432 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 6434 8820  54         c     @fb.column,@fb.row.length
     6436 A10C 
     6438 A108 
0022 643A 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 643C C120  34         mov   @fb.current,tmp0      ; Get pointer
     643E A102 
0028 6440 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 6442 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 6444 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 6446 0606  14         dec   tmp2
0036 6448 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 644A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     644C A10A 
0041 644E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6450 A116 
0042 6452 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6454 A108 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 6456 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6458 7102 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 645A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     645C A206 
0055 645E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6460 67DE 
0056 6462 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6464 A108 
0057 6466 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 6468 C120  34         mov   @fb.current,tmp0      ; Get pointer
     646A A102 
0063 646C C1A0  34         mov   @fb.colsline,tmp2
     646E A10E 
0064 6470 61A0  34         s     @fb.column,tmp2
     6472 A10C 
0065 6474 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 6476 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 6478 0606  14         dec   tmp2
0072 647A 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 647C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     647E A10A 
0077 6480 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6482 A116 
0078               
0079 6484 C820  54         mov   @fb.column,@fb.row.length
     6486 A10C 
     6488 A108 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 648A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     648C 7102 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 648E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6490 A206 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 6492 C120  34         mov   @edb.lines,tmp0
     6494 A204 
0097 6496 1604  14         jne   !
0098 6498 04E0  34         clr   @fb.column            ; Column 0
     649A A10C 
0099 649C 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     649E 645A 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 64A0 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64A2 67DE 
0104 64A4 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64A6 A10A 
0105 64A8 C820  54         mov   @fb.topline,@parm1
     64AA A104 
     64AC 8350 
0106 64AE A820  54         a     @fb.row,@parm1        ; Line number to remove
     64B0 A106 
     64B2 8350 
0107 64B4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64B6 A204 
     64B8 8352 
0108 64BA 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     64BC 6A62 
0109 64BE 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64C0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64C2 C820  54         mov   @fb.topline,@parm1
     64C4 A104 
     64C6 8350 
0114 64C8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64CA 67FA 
0115 64CC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64CE A116 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 64D0 C120  34         mov   @fb.topline,tmp0
     64D2 A104 
0120 64D4 A120  34         a     @fb.row,tmp0
     64D6 A106 
0121 64D8 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64DA A204 
0122 64DC 1202  14         jle   edkey.action.del_line.exit
0123 64DE 0460  28         b     @edkey.action.up      ; One line up
     64E0 61AC 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64E2 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64E4 626A 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws:
0138 64E6 0204  20         li    tmp0,>2000            ; White space
     64E8 2000 
0139 64EA C804  38         mov   tmp0,@parm1
     64EC 8350 
0140               edkey.action.ins_char:
0141 64EE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64F0 A206 
0142 64F2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64F4 67DE 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64F6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     64F8 A102 
0147 64FA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64FC A108 
0148 64FE 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 6500 8820  54         c     @fb.column,@fb.row.length
     6502 A10C 
     6504 A108 
0154 6506 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 6508 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 650A 61E0  34         s     @fb.column,tmp3
     650C A10C 
0162 650E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 6510 C144  18         mov   tmp0,tmp1
0164 6512 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 6514 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6516 A10C 
0166 6518 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 651A D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 651C 0604  14         dec   tmp0
0173 651E 0605  14         dec   tmp1
0174 6520 0606  14         dec   tmp2
0175 6522 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 6524 D560  46         movb  @parm1,*tmp1
     6526 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 6528 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     652A A10A 
0184 652C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     652E A116 
0185 6530 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6532 A108 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 6534 0460  28         b     @edkey.action.char.overwrite
     6536 6610 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 6538 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     653A 7102 
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
0206 653C 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     653E A206 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 6540 8820  54         c     @fb.row.dirty,@w$ffff
     6542 A10A 
     6544 202C 
0211 6546 1604  14         jne   edkey.action.ins_line.insert
0212 6548 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     654A 6B7A 
0213 654C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     654E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6550 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6552 67DE 
0219 6554 C820  54         mov   @fb.topline,@parm1
     6556 A104 
     6558 8350 
0220 655A A820  54         a     @fb.row,@parm1        ; Line number to insert
     655C A106 
     655E 8350 
0221 6560 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6562 A204 
     6564 8352 
0222               
0223 6566 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6568 6AEC 
0224                                                   ; \ i  parm1 = Line for insert
0225                                                   ; / i  parm2 = Last line to reorg
0226               
0227 656A 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     656C A204 
0228                       ;-------------------------------------------------------
0229                       ; Refresh frame buffer and physical screen
0230                       ;-------------------------------------------------------
0231 656E C820  54         mov   @fb.topline,@parm1
     6570 A104 
     6572 8350 
0232 6574 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6576 67FA 
0233 6578 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     657A A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 657C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     657E 7102 
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
0252 6580 8820  54         c     @fb.row.dirty,@w$ffff
     6582 A10A 
     6584 202C 
0253 6586 1606  14         jne   edkey.action.enter.upd_counter
0254 6588 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     658A A206 
0255 658C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     658E 6B7A 
0256 6590 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6592 A10A 
0257                       ;-------------------------------------------------------
0258                       ; Update line counter
0259                       ;-------------------------------------------------------
0260               edkey.action.enter.upd_counter:
0261 6594 C120  34         mov   @fb.topline,tmp0
     6596 A104 
0262 6598 A120  34         a     @fb.row,tmp0
     659A A106 
0263 659C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     659E A204 
0264 65A0 1602  14         jne   edkey.action.newline  ; No, continue newline
0265 65A2 05A0  34         inc   @edb.lines            ; Total lines++
     65A4 A204 
0266                       ;-------------------------------------------------------
0267                       ; Process newline
0268                       ;-------------------------------------------------------
0269               edkey.action.newline:
0270                       ;-------------------------------------------------------
0271                       ; Scroll 1 line if cursor at bottom row of screen
0272                       ;-------------------------------------------------------
0273 65A6 C120  34         mov   @fb.scrrows,tmp0
     65A8 A118 
0274 65AA 0604  14         dec   tmp0
0275 65AC 8120  34         c     @fb.row,tmp0
     65AE A106 
0276 65B0 110A  14         jlt   edkey.action.newline.down
0277                       ;-------------------------------------------------------
0278                       ; Scroll
0279                       ;-------------------------------------------------------
0280 65B2 C120  34         mov   @fb.scrrows,tmp0
     65B4 A118 
0281 65B6 C820  54         mov   @fb.topline,@parm1
     65B8 A104 
     65BA 8350 
0282 65BC 05A0  34         inc   @parm1
     65BE 8350 
0283 65C0 06A0  32         bl    @fb.refresh
     65C2 67FA 
0284 65C4 1004  14         jmp   edkey.action.newline.rest
0285                       ;-------------------------------------------------------
0286                       ; Move cursor down a row, there are still rows left
0287                       ;-------------------------------------------------------
0288               edkey.action.newline.down:
0289 65C6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65C8 A106 
0290 65CA 06A0  32         bl    @down                 ; Row++ VDP cursor
     65CC 2674 
0291                       ;-------------------------------------------------------
0292                       ; Set VDP cursor and save variables
0293                       ;-------------------------------------------------------
0294               edkey.action.newline.rest:
0295 65CE 06A0  32         bl    @fb.get.firstnonblank
     65D0 686A 
0296 65D2 C120  34         mov   @outparm1,tmp0
     65D4 8360 
0297 65D6 C804  38         mov   tmp0,@fb.column
     65D8 A10C 
0298 65DA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65DC 2686 
0299 65DE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65E0 6D12 
0300 65E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65E4 67DE 
0301 65E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65E8 A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65EA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65EC 7102 
0307               
0308               
0309               
0310               
0311               *---------------------------------------------------------------
0312               * Toggle insert/overwrite mode
0313               *---------------------------------------------------------------
0314               edkey.action.ins_onoff:
0315 65EE 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65F0 A20A 
0316                       ;-------------------------------------------------------
0317                       ; Delay
0318                       ;-------------------------------------------------------
0319 65F2 0204  20         li    tmp0,2000
     65F4 07D0 
0320               edkey.action.ins_onoff.loop:
0321 65F6 0604  14         dec   tmp0
0322 65F8 16FE  14         jne   edkey.action.ins_onoff.loop
0323                       ;-------------------------------------------------------
0324                       ; Exit
0325                       ;-------------------------------------------------------
0326               edkey.action.ins_onoff.exit:
0327 65FA 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65FC 71DA 
0328               
0329               
0330               
0331               
0332               *---------------------------------------------------------------
0333               * Process character (frame buffer)
0334               *---------------------------------------------------------------
0335               edkey.action.char:
0336 65FE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6600 A206 
0337 6602 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6604 8350 
0338 6606 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6608 A20A 
0339 660A 1302  14         jeq   edkey.action.char.overwrite
0340                       ;-------------------------------------------------------
0341                       ; Insert mode
0342                       ;-------------------------------------------------------
0343               edkey.action.char.insert:
0344 660C 0460  28         b     @edkey.action.ins_char
     660E 64EE 
0345                       ;-------------------------------------------------------
0346                       ; Overwrite mode
0347                       ;-------------------------------------------------------
0348               edkey.action.char.overwrite:
0349 6610 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6612 67DE 
0350 6614 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6616 A102 
0351               
0352 6618 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     661A 8350 
0353 661C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     661E A10A 
0354 6620 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6622 A116 
0355               
0356 6624 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6626 A10C 
0357 6628 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     662A 832A 
0358                       ;-------------------------------------------------------
0359                       ; Update line length in frame buffer
0360                       ;-------------------------------------------------------
0361 662C 8820  54         c     @fb.column,@fb.row.length
     662E A10C 
     6630 A108 
0362 6632 1103  14         jlt   edkey.action.char.exit
0363                                                   ; column < length line ? Skip processing
0364               
0365 6634 C820  54         mov   @fb.column,@fb.row.length
     6636 A10C 
     6638 A108 
0366                       ;-------------------------------------------------------
0367                       ; Exit
0368                       ;-------------------------------------------------------
0369               edkey.action.char.exit:
0370 663A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     663C 7102 
**** **** ****     > stevie_b1.asm.299124
0041                       copy  "edkey.fb.misc.asm"   ; fb pane   - Actions for miscelanneous keys
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit stevie
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 663E 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6640 2736 
0010 6642 0420  54         blwp  @0                    ; Exit
     6644 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6646 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6648 7102 
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
0028 664A 05A0  34         inc   @fb.scrrows
     664C A118 
0029 664E 0720  34         seto  @fb.dirty
     6650 A116 
0030               
0031 6652 045B  20         b     *r11
0032               
**** **** ****     > stevie_b1.asm.299124
0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6654 0204  20         li   tmp0,fdname0
     6656 7690 
0007 6658 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 665A 0204  20         li   tmp0,fdname1
     665C 75FC 
0010 665E 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6660 0204  20         li   tmp0,fdname2
     6662 7606 
0013 6664 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 6666 0204  20         li   tmp0,fdname3
     6668 7616 
0016 666A 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 666C 0204  20         li   tmp0,fdname4
     666E 7624 
0019 6670 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6672 0204  20         li   tmp0,fdname5
     6674 7636 
0022 6676 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 6678 0204  20         li   tmp0,fdname6
     667A 7648 
0025 667C 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 667E 0204  20         li   tmp0,fdname7
     6680 765A 
0028 6682 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6684 0204  20         li   tmp0,fdname8
     6686 766E 
0031 6688 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 668A 0204  20         li   tmp0,fdname9
     668C 7682 
0034 668E 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 6690 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6692 6F9C 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 6694 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6696 63B6 
**** **** ****     > stevie_b1.asm.299124
0043                       copy  "edkey.cmdb.mov.asm"  ; cmdb pane - Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 6698 C120  34         mov   @cmdb.column,tmp0
     669A A30E 
0010 669C 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 669E 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     66A0 A30E 
0015 66A2 0620  34         dec   @wyx                  ; Column-- VDP cursor
     66A4 832A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 66A6 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66A8 7102 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 66AA 8820  54         c     @cmdb.column,@cmdb.length
     66AC A30E 
     66AE A310 
0027 66B0 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 66B2 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     66B4 A30E 
0032 66B6 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     66B8 832A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 66BA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66BC 7102 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 66BE 06A0  32         bl    @setx
     66C0 2684 
0045 66C2 0000                   data 0                 ; VDP cursor column=0
0046 66C4 04E0  34         clr   @cmdb.column
     66C6 A30E 
0047 66C8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66CA 7102 
0048               
0049               *---------------------------------------------------------------
0050               * Cursor end of line
0051               *---------------------------------------------------------------
0052               edkey.action.cmdb.end:
0053 66CC C120  34         mov   @fb.row.length,tmp0
     66CE A108 
0054 66D0 C804  38         mov   tmp0,@fb.column
     66D2 A10C 
0055 66D4 06A0  32         bl    @xsetx                 ; Set VDP cursor column position
     66D6 2686 
0056 66D8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66DA 7102 
**** **** ****     > stevie_b1.asm.299124
0044                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Insert character
0007               *
0008               * @parm1 = high byte has character to insert
0009               ********|*****|*********************|**************************
0010               edkey.cmdb.action.ins_char:
0011 66DC 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66DE A314 
0012                       ;-------------------------------------------------------
0013                       ; Loop from end of line until current character
0014                       ;-------------------------------------------------------
0015               edkey.cmdb.action.ins_char_loop:
0016 66E0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0017 66E2 0604  14         dec   tmp0
0018 66E4 0605  14         dec   tmp1
0019 66E6 0606  14         dec   tmp2
0020 66E8 16FB  14         jne   edkey.cmdb.action.ins_char_loop
0021                       ;-------------------------------------------------------
0022                       ; Set specified character on current position
0023                       ;-------------------------------------------------------
0024 66EA D560  46         movb  @parm1,*tmp1
     66EC 8350 
0025                       ;-------------------------------------------------------
0026                       ; Exit
0027                       ;-------------------------------------------------------
0028               edkey.cmdb.action.ins_char.exit:
0029 66EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66F0 7102 
0030               
0031               
0032               
0033               *---------------------------------------------------------------
0034               * Process character
0035               ********|*****|*********************|**************************
0036               edkey.cmdb.action.char:
0037 66F2 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66F4 A314 
0038               
0039 66F6 C120  34         mov   @cmdb.top.ptr,tmp0
     66F8 A300 
0040 66FA A120  34         a     @cmdb.column,tmp0
     66FC A30E 
0041 66FE D505  30         movb  tmp1,*tmp0
0042               
0043 6700 05A0  34         inc   @cmdb.column
     6702 A30E 
0044                       ;-------------------------------------------------------
0045                       ; Exit
0046                       ;-------------------------------------------------------
0047               edkey.cmdb.action.char.exit:
0048 6704 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6706 7102 
**** **** ****     > stevie_b1.asm.299124
0045                       copy  "edkey.cmdb.misc.asm" ; cmdb pane - Actions for miscelanneous keys
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 6708 C120  34         mov   @cmdb.visible,tmp0
     670A A302 
0010 670C 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 670E 04E0  34         clr   @cmdb.column          ; Column = 0
     6710 A30E 
0016 6712 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6714 7320 
0017 6716 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6718 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     671A 735A 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 671C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     671E 7102 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.299124
0046                       copy  "stevie.asm"          ; Main editor configuration
**** **** ****     > stevie.asm
0001               * FILE......: stevie.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize main editor
0012               ***************************************************************
0013               * bl @stevie.init
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
0026               stevie.init:
0027 6720 0649  14         dect  stack
0028 6722 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6724 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     6726 A012 
0033                       ;------------------------------------------------------
0034                       ; Exit
0035                       ;------------------------------------------------------
0036               stevie.init.exit:
0037 6728 0460  28         b     @poprt                ; Return to caller
     672A 222C 
**** **** ****     > stevie_b1.asm.299124
0047                       copy  "mem.asm"             ; Memory Management
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
0021 672C 0649  14         dect  stack
0022 672E C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 6730 06A0  32         bl    @sams.layout
     6732 2582 
0027 6734 74EC                   data mem.sams.layout.data
0028               
0029 6736 06A0  32         bl    @sams.layout.copy
     6738 25E6 
0030 673A A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 673C C820  54         mov   @tv.sams.c000,@edb.sams.page
     673E A008 
     6740 A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 6742 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 6744 045B  20         b     *r11                  ; Return to caller
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
0064 6746 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 6748 0649  14         dect  stack
0067 674A C64B  30         mov   r11,*stack            ; Push return address
0068 674C 0649  14         dect  stack
0069 674E C644  30         mov   tmp0,*stack           ; Push tmp0
0070 6750 0649  14         dect  stack
0071 6752 C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 6754 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6756 A204 
0076 6758 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 675A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     675C FFCE 
0082 675E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6760 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 6762 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6764 6A06 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 6766 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6768 8362 
0093 676A C160  34         mov   @outparm1,tmp1        ; Pointer to line
     676C 8360 
0094 676E 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 6770 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6772 A008 
0101 6774 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 6776 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6778 2516 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 677A C820  54         mov   @outparm2,@tv.sams.c000
     677C 8362 
     677E A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 6780 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 6782 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 6784 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 6786 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.299124
0048                       copy  "fb.asm"              ; Framebuffer
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
0024 6788 0649  14         dect  stack
0025 678A C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 678C 0204  20         li    tmp0,fb.top
     678E A600 
0030 6790 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     6792 A100 
0031 6794 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     6796 A104 
0032 6798 04E0  34         clr   @fb.row               ; Current row=0
     679A A106 
0033 679C 04E0  34         clr   @fb.column            ; Current column=0
     679E A10C 
0034               
0035 67A0 0204  20         li    tmp0,80
     67A2 0050 
0036 67A4 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     67A6 A10E 
0037               
0038 67A8 0204  20         li    tmp0,29
     67AA 001D 
0039 67AC C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     67AE A118 
0040 67B0 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     67B2 A11A 
0041               
0042 67B4 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     67B6 A018 
0043 67B8 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     67BA A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 67BC 06A0  32         bl    @film
     67BE 2230 
0048 67C0 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     67C2 0000 
     67C4 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 67C6 0460  28         b     @poprt                ; Return to caller
     67C8 222C 
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
0078 67CA 0649  14         dect  stack
0079 67CC C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67CE C120  34         mov   @parm1,tmp0
     67D0 8350 
0084 67D2 A120  34         a     @fb.topline,tmp0
     67D4 A104 
0085 67D6 C804  38         mov   tmp0,@outparm1
     67D8 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67DA 0460  28         b    @poprt                 ; Return to caller
     67DC 222C 
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
0118 67DE 0649  14         dect  stack
0119 67E0 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 67E2 C1A0  34         mov   @fb.row,tmp2
     67E4 A106 
0124 67E6 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     67E8 A10E 
0125 67EA A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     67EC A10C 
0126 67EE A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     67F0 A100 
0127 67F2 C807  38         mov   tmp3,@fb.current
     67F4 A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 67F6 0460  28         b    @poprt                 ; Return to caller
     67F8 222C 
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
0153 67FA 0649  14         dect  stack
0154 67FC C64B  30         mov   r11,*stack            ; Push return address
0155 67FE 0649  14         dect  stack
0156 6800 C644  30         mov   tmp0,*stack           ; Push tmp0
0157 6802 0649  14         dect  stack
0158 6804 C645  30         mov   tmp1,*stack           ; Push tmp1
0159 6806 0649  14         dect  stack
0160 6808 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 680A C820  54         mov   @parm1,@fb.topline
     680C 8350 
     680E A104 
0165 6810 04E0  34         clr   @parm2                ; Target row in frame buffer
     6812 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 6814 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6816 8350 
     6818 A204 
0170 681A 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 681C 06A0  32         bl    @edb.line.unpack      ; Unpack line
     681E 6C30 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 6820 05A0  34         inc   @parm1                ; Next line in editor buffer
     6822 8350 
0180 6824 05A0  34         inc   @parm2                ; Next row in frame buffer
     6826 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 6828 8820  54         c     @parm1,@edb.lines
     682A 8350 
     682C A204 
0185 682E 1112  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 6830 C120  34         mov   @parm2,tmp0           ; Current row
     6832 8352 
0192 6834 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6836 A118 
0193 6838 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 683A 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     683C A10E 
0195               
0196 683E C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 6840 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6842 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6844 A10E 
0200 6846 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6848 A100 
0201               
0202 684A C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 684C 04C5  14         clr   tmp1                  ; Clear with >00 character
0204               
0205 684E 06A0  32         bl    @xfilm                ; \ Fill memory
     6850 2236 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 6852 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 6854 8820  54 !       c     @parm2,@fb.scrrows
     6856 8352 
     6858 A118 
0214 685A 11E0  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 685C 0720  34         seto  @fb.dirty             ; Refresh screen
     685E A116 
0221 6860 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 6862 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 6864 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 6866 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 6868 045B  20         b     *r11                  ; Return to caller
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
0239 686A 0649  14         dect  stack
0240 686C C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 686E 04E0  34         clr   @fb.column
     6870 A10C 
0245 6872 06A0  32         bl    @fb.calc_pointer
     6874 67DE 
0246 6876 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6878 6D12 
0247 687A C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     687C A108 
0248 687E 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 6880 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6882 A102 
0251 6884 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 6886 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 6888 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 688A 0285  22         ci    tmp1,>2000            ; Whitespace?
     688C 2000 
0260 688E 1503  14         jgt   fb.get.firstnonblank.match
0261 6890 0606  14         dec   tmp2                  ; Counter--
0262 6892 16F9  14         jne   fb.get.firstnonblank.loop
0263 6894 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 6896 6120  34         s     @fb.current,tmp0      ; Calculate column
     6898 A102 
0269 689A 0604  14         dec   tmp0
0270 689C C804  38         mov   tmp0,@outparm1        ; Save column
     689E 8360 
0271 68A0 D805  38         movb  tmp1,@outparm2        ; Save character
     68A2 8362 
0272 68A4 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68A6 04E0  34         clr   @outparm1             ; X=0
     68A8 8360 
0278 68AA 04E0  34         clr   @outparm2             ; Null
     68AC 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 68AE 0460  28         b    @poprt                 ; Return to caller
     68B0 222C 
**** **** ****     > stevie_b1.asm.299124
0049                       copy  "idx.asm"             ; Index management
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
0050 68B2 0649  14         dect  stack
0051 68B4 C64B  30         mov   r11,*stack            ; Save return address
0052 68B6 0649  14         dect  stack
0053 68B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 68BA 0204  20         li    tmp0,idx.top
     68BC B000 
0058 68BE C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     68C0 A202 
0059               
0060 68C2 C120  34         mov   @tv.sams.b000,tmp0
     68C4 A006 
0061 68C6 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     68C8 A500 
0062 68CA C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     68CC A502 
0063 68CE C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     68D0 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 68D2 06A0  32         bl    @film
     68D4 2230 
0068 68D6 B000                   data idx.top,>00,idx.size
     68D8 0000 
     68DA 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 68DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 68DE C2F9  30         mov   *stack+,r11           ; Pop r11
0076 68E0 045B  20         b     *r11                  ; Return to caller
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
0100 68E2 0649  14         dect  stack
0101 68E4 C64B  30         mov   r11,*stack            ; Push return address
0102 68E6 0649  14         dect  stack
0103 68E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 68EA 0649  14         dect  stack
0105 68EC C645  30         mov   tmp1,*stack           ; Push tmp1
0106 68EE 0649  14         dect  stack
0107 68F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 68F2 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     68F4 A502 
0112 68F6 0205  20         li    tmp1,idx.top
     68F8 B000 
0113               
0114 68FA C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     68FC A504 
0115 68FE 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6900 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6902 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6904 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6906 0005 
0121 6908 1104  14         jlt   !
0122 690A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     690C FFCE 
0123 690E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6910 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6912 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6914 2516 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6916 0584  14         inc   tmp0                  ; Next SAMS index page
0132 6918 0225  22         ai    tmp1,>1000            ; Next memory region
     691A 1000 
0133 691C 0606  14         dec   tmp2                  ; Update loop counter
0134 691E 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6920 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6922 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6924 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6926 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6928 045B  20         b     *r11                  ; Return to caller
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
0159 692A 0649  14         dect  stack
0160 692C C64B  30         mov   r11,*stack            ; Push return address
0161 692E 0649  14         dect  stack
0162 6930 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6932 0649  14         dect  stack
0164 6934 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6936 0649  14         dect  stack
0166 6938 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 693A 0649  14         dect  stack
0168 693C C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 693E 0205  20         li    tmp1,idx.top
     6940 B000 
0173 6942 0206  20         li    tmp2,5                ; Always 5 pages
     6944 0005 
0174 6946 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6948 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 694A C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 694C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     694E 2516 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 6950 0225  22         ai    tmp1,>1000            ; Next memory region
     6952 1000 
0185 6954 0606  14         dec   tmp2                  ; Update loop counter
0186 6956 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6958 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 695A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 695C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 695E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6960 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6962 045B  20         b     *r11                  ; Return to caller
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
0220 6964 0649  14         dect  stack
0221 6966 C64B  30         mov   r11,*stack            ; Save return address
0222 6968 0649  14         dect  stack
0223 696A C644  30         mov   tmp0,*stack           ; Push tmp0
0224 696C 0649  14         dect  stack
0225 696E C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6970 0649  14         dect  stack
0227 6972 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6974 C184  18         mov   tmp0,tmp2             ; Line number
0232 6976 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6978 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     697A 0800 
0234               
0235 697C 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 697E 0A16  56         sla   tmp2,1                ; line number * 2
0240 6980 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6982 8360 
0241               
0242 6984 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6986 A502 
0243 6988 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     698A A500 
0244               
0245 698C 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 698E C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6990 A500 
0251 6992 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     6994 A006 
0252               
0253 6996 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6998 0205  20         li    tmp1,>b000            ; Memory window for index page
     699A B000 
0255               
0256 699C 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     699E 2516 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 69A0 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     69A2 A504 
0263 69A4 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 69A6 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     69A8 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 69AA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 69AC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 69AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 69B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 69B2 045B  20         b     *r11                  ; Return to caller
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
0295 69B4 0649  14         dect  stack
0296 69B6 C64B  30         mov   r11,*stack            ; Save return address
0297 69B8 0649  14         dect  stack
0298 69BA C644  30         mov   tmp0,*stack           ; Push tmp0
0299 69BC 0649  14         dect  stack
0300 69BE C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 69C0 C120  34         mov   @parm1,tmp0           ; Get line number
     69C2 8350 
0305 69C4 C160  34         mov   @parm2,tmp1           ; Get pointer
     69C6 8352 
0306 69C8 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 69CA 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     69CC 0FFF 
0312 69CE 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 69D0 06E0  34         swpb  @parm3
     69D2 8354 
0317 69D4 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     69D6 8354 
0318 69D8 06E0  34         swpb  @parm3                ; \ Restore original order again,
     69DA 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 69DC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     69DE 6964 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 69E0 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     69E2 8360 
0329 69E4 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     69E6 B000 
0330 69E8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69EA 8360 
0331 69EC 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 69EE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     69F0 6964 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 69F2 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     69F4 8360 
0341 69F6 04E4  34         clr   @idx.top(tmp0)        ; /
     69F8 B000 
0342 69FA C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69FC 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 69FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6A00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6A02 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6A04 045B  20         b     *r11                  ; Return to caller
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
0373 6A06 0649  14         dect  stack
0374 6A08 C64B  30         mov   r11,*stack            ; Save return address
0375 6A0A 0649  14         dect  stack
0376 6A0C C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6A0E 0649  14         dect  stack
0378 6A10 C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6A12 0649  14         dect  stack
0380 6A14 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6A16 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A18 8350 
0385               
0386 6A1A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6A1C 6964 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6A1E C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6A20 8360 
0391 6A22 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A24 B000 
0392               
0393 6A26 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6A28 C185  18         mov   tmp1,tmp2             ; \
0399 6A2A 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6A2C 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A2E 00FF 
0404 6A30 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6A32 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A34 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6A36 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A38 8360 
0411 6A3A C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A3C 8362 
0412 6A3E 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6A40 04E0  34         clr   @outparm1
     6A42 8360 
0418 6A44 04E0  34         clr   @outparm2
     6A46 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6A48 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6A4A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6A4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6A4E C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6A50 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0050                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0025 6A52 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6A54 B000 
0026 6A56 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6A58 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6A5A CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6A5C 0606  14         dec   tmp2                  ; tmp2--
0034 6A5E 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6A60 045B  20         b     *r11                  ; Return to caller
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
0054 6A62 0649  14         dect  stack
0055 6A64 C64B  30         mov   r11,*stack            ; Save return address
0056 6A66 0649  14         dect  stack
0057 6A68 C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6A6A 0649  14         dect  stack
0059 6A6C C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6A6E 0649  14         dect  stack
0061 6A70 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6A72 0649  14         dect  stack
0063 6A74 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6A76 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A78 8350 
0068               
0069 6A7A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A7C 6964 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6A7E C120  34         mov   @outparm1,tmp0        ; Index offset
     6A80 8360 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6A82 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6A84 8352 
0078 6A86 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6A88 8350 
0079 6A8A 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6A8C C1E0  34         mov   @parm2,tmp3
     6A8E 8352 
0086 6A90 0287  22         ci    tmp3,2048
     6A92 0800 
0087 6A94 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6A96 06A0  32         bl    @_idx.sams.mapcolumn.on
     6A98 68E2 
0095                                                   ; Index in continious memory region
0096               
0097 6A9A 06A0  32         bl    @_idx.entry.delete.reorg
     6A9C 6A52 
0098                                                   ; Reorganize index
0099               
0100               
0101 6A9E 06A0  32         bl    @_idx.sams.mapcolumn.off
     6AA0 692A 
0102                                                   ; Restore memory window layout
0103               
0104 6AA2 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6AA4 06A0  32         bl    @_idx.entry.delete.reorg
     6AA6 6A52 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6AA8 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6AAA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6AAC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6AAE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6AB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6AB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6AB4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0051                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0025 6AB6 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6AB8 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6ABA 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6ABC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6ABE FFCE 
0034 6AC0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AC2 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6AC4 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6AC6 B000 
0039 6AC8 C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6ACA 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6ACC 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6ACE C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6AD0 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6AD2 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6AD4 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6AD6 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6AD8 AFFE 
0050 6ADA 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6ADC C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6ADE 0644  14         dect  tmp0                  ; Move pointer up
0058 6AE0 0645  14         dect  tmp1                  ; Move pointer up
0059 6AE2 0606  14         dec   tmp2                  ; Next index entry
0060 6AE4 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6AE6 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6AE8 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6AEA 045B  20         b     *r11                  ; Return to caller
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
0090 6AEC 0649  14         dect  stack
0091 6AEE C64B  30         mov   r11,*stack            ; Save return address
0092 6AF0 0649  14         dect  stack
0093 6AF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6AF4 0649  14         dect  stack
0095 6AF6 C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6AF8 0649  14         dect  stack
0097 6AFA C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6AFC 0649  14         dect  stack
0099 6AFE C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6B00 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B02 8352 
0104 6B04 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B06 8350 
0105 6B08 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6B0A C1E0  34         mov   @parm2,tmp3
     6B0C 8352 
0112 6B0E 0287  22         ci    tmp3,2048
     6B10 0800 
0113 6B12 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6B14 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B16 68E2 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6B18 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B1A 8352 
0125 6B1C 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6B1E 06A0  32         bl    @_idx.entry.insert.reorg
     6B20 6AB6 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6B22 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B24 692A 
0133                                                   ; Restore memory window layout
0134               
0135 6B26 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6B28 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B2A 8352 
0141               
0142 6B2C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B2E 6964 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6B30 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B32 8360 
0147               
0148 6B34 06A0  32         bl    @_idx.entry.insert.reorg
     6B36 6AB6 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6B38 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6B3A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6B3C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6B3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6B40 C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6B42 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0052                       copy  "edb.asm"             ; Editor Buffer
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
0026 6B44 0649  14         dect  stack
0027 6B46 C64B  30         mov   r11,*stack            ; Save return address
0028 6B48 0649  14         dect  stack
0029 6B4A C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6B4C 0204  20         li    tmp0,edb.top          ; \
     6B4E C000 
0034 6B50 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6B52 A200 
0035 6B54 C804  38         mov   tmp0,@edb.next_free.ptr
     6B56 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6B58 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6B5A A20A 
0039 6B5C 04E0  34         clr   @edb.lines            ; Lines=0
     6B5E A204 
0040 6B60 04E0  34         clr   @edb.rle              ; RLE compression off
     6B62 A20C 
0041               
0042 6B64 0204  20         li    tmp0,txt.newfile      ; "New file"
     6B66 7590 
0043 6B68 C804  38         mov   tmp0,@edb.filename.ptr
     6B6A A20E 
0044               
0045 6B6C 0204  20         li    tmp0,txt.filetype.none
     6B6E 75E6 
0046 6B70 C804  38         mov   tmp0,@edb.filetype.ptr
     6B72 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6B74 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6B76 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B78 045B  20         b     *r11                  ; Return to caller
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
0081 6B7A 0649  14         dect  stack
0082 6B7C C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6B7E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6B80 A10C 
     6B82 8390 
0087 6B84 04E0  34         clr   @fb.column
     6B86 A10C 
0088 6B88 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6B8A 67DE 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6B8C 04C4  14         clr   tmp0                  ; Counter
0093 6B8E C160  34         mov   @fb.current,tmp1      ; Get position
     6B90 A102 
0094 6B92 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6B94 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6B96 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6B98 0986  56         srl   tmp2,8                ; Right justify
0102 6B9A 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6B9C 0584  14         inc   tmp0                  ; Increase string length
0104 6B9E 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6BA0 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6BA2 A104 
     6BA4 8350 
0111 6BA6 A820  54         a     @fb.row,@parm1        ; /
     6BA8 A106 
     6BAA 8350 
0112               
0113 6BAC C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6BAE 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6BB0 C120  34         mov   @edb.next_free.ptr,tmp0
     6BB2 A208 
0120 6BB4 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6BB6 8352 
0121               
0122 6BB8 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6BBA 24DE 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6BBC C820  54         mov   @waux1,@parm3         ; Setup parm3
     6BBE 833C 
     6BC0 8354 
0128               
0129 6BC2 06A0  32         bl    @idx.entry.update     ; Update index
     6BC4 69B4 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6BC6 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6BC8 A212 
     6BCA 8354 
0139 6BCC 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6BCE C120  34         mov   @parm3,tmp0           ; get SAMS page
     6BD0 8354 
0142 6BD2 C160  34         mov   @edb.next_free.ptr,tmp1
     6BD4 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6BD6 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6BD8 2516 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6BDA C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6BDC A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6BDE C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6BE0 8392 
0155 6BE2 C160  34         mov   @edb.next_free.ptr,tmp1
     6BE4 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6BE6 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6BE8 A208 
0159               
0160 6BEA C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6BEC 8394 
0161 6BEE 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6BF0 06C6  14         swpb  tmp2
0163 6BF2 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6BF4 06C6  14         swpb  tmp2
0165 6BF6 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6BF8 0286  22         ci    tmp2,2
     6BFA 0002 
0172 6BFC 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6BFE DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6C00 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6C02 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6C04 0286  22         ci    tmp2,1
     6C06 0001 
0179 6C08 1602  14         jne   edb.line.pack.copyline.block
0180 6C0A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6C0C 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6C0E 06A0  32         bl    @xpym2m               ; Copy memory block
     6C10 2480 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6C12 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6C14 8394 
     6C16 A208 
0192                                                      ; Add length of line
0193               
0194 6C18 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6C1A A208 
0195 6C1C 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0196 6C1E 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6C20 000F 
0197 6C22 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6C24 A208 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               edb.line.pack.exit:
0202 6C26 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6C28 8390 
     6C2A A10C 
0203 6C2C 0460  28         b     @poprt                ; Return to caller
     6C2E 222C 
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
0232 6C30 0649  14         dect  stack
0233 6C32 C64B  30         mov   r11,*stack            ; Save return address
0234 6C34 0649  14         dect  stack
0235 6C36 C644  30         mov   tmp0,*stack           ; Push tmp0
0236 6C38 0649  14         dect  stack
0237 6C3A C645  30         mov   tmp1,*stack           ; Push tmp1
0238 6C3C 0649  14         dect  stack
0239 6C3E C646  30         mov   tmp2,*stack           ; Push tmp2
0240                       ;------------------------------------------------------
0241                       ; Sanity check
0242                       ;------------------------------------------------------
0243 6C40 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6C42 8350 
     6C44 A204 
0244 6C46 1104  14         jlt   !
0245 6C48 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C4A FFCE 
0246 6C4C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C4E 2030 
0247                       ;------------------------------------------------------
0248                       ; Save parameters
0249                       ;------------------------------------------------------
0250 6C50 C820  54 !       mov   @parm1,@rambuf
     6C52 8350 
     6C54 8390 
0251 6C56 C820  54         mov   @parm2,@rambuf+2
     6C58 8352 
     6C5A 8392 
0252                       ;------------------------------------------------------
0253                       ; Calculate offset in frame buffer
0254                       ;------------------------------------------------------
0255 6C5C C120  34         mov   @fb.colsline,tmp0
     6C5E A10E 
0256 6C60 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6C62 8352 
0257 6C64 C1A0  34         mov   @fb.top.ptr,tmp2
     6C66 A100 
0258 6C68 A146  18         a     tmp2,tmp1             ; Add base to offset
0259 6C6A C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6C6C 8396 
0260                       ;------------------------------------------------------
0261                       ; Get pointer to line & page-in editor buffer page
0262                       ;------------------------------------------------------
0263 6C6E C120  34         mov   @parm1,tmp0
     6C70 8350 
0264 6C72 06A0  32         bl    @xmem.edb.sams.mappage
     6C74 6748 
0265                                                   ; Activate editor buffer SAMS page for line
0266                                                   ; \ i  tmp0     = Line number
0267                                                   ; | o  outparm1 = Pointer to line
0268                                                   ; / o  outparm2 = SAMS page
0269               
0270 6C76 C820  54         mov   @outparm2,@edb.sams.page
     6C78 8362 
     6C7A A212 
0271                                                   ; Save current SAMS page
0272                       ;------------------------------------------------------
0273                       ; Handle empty line
0274                       ;------------------------------------------------------
0275 6C7C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6C7E 8360 
0276 6C80 1603  14         jne   !                     ; Check if pointer is set
0277 6C82 04E0  34         clr   @rambuf+8             ; Set length=0
     6C84 8398 
0278 6C86 100F  14         jmp   edb.line.unpack.clear
0279                       ;------------------------------------------------------
0280                       ; Get line length
0281                       ;------------------------------------------------------
0282 6C88 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0283 6C8A C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6C8C 8398 
0284               
0285 6C8E 05E0  34         inct  @outparm1             ; Skip line prefix
     6C90 8360 
0286 6C92 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6C94 8360 
     6C96 8394 
0287                       ;------------------------------------------------------
0288                       ; Sanity check on line length
0289                       ;------------------------------------------------------
0290 6C98 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6C9A 0050 
0291 6C9C 1204  14         jle   edb.line.unpack.clear ; /
0292               
0293 6C9E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CA0 FFCE 
0294 6CA2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CA4 2030 
0295                       ;------------------------------------------------------
0296                       ; Erase chars from last column until column 80
0297                       ;------------------------------------------------------
0298               edb.line.unpack.clear:
0299 6CA6 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6CA8 8396 
0300 6CAA A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6CAC 8398 
0301               
0302 6CAE 04C5  14         clr   tmp1                  ; Fill with >00
0303 6CB0 C1A0  34         mov   @fb.colsline,tmp2
     6CB2 A10E 
0304 6CB4 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6CB6 8398 
0305 6CB8 0586  14         inc   tmp2
0306               
0307 6CBA 06A0  32         bl    @xfilm                ; Fill CPU memory
     6CBC 2236 
0308                                                   ; \ i  tmp0 = Target address
0309                                                   ; | i  tmp1 = Byte to fill
0310                                                   ; / i  tmp2 = Repeat count
0311                       ;------------------------------------------------------
0312                       ; Prepare for unpacking data
0313                       ;------------------------------------------------------
0314               edb.line.unpack.prepare:
0315 6CBE C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6CC0 8398 
0316 6CC2 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0317 6CC4 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6CC6 8394 
0318 6CC8 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6CCA 8396 
0319                       ;------------------------------------------------------
0320                       ; Check before copy
0321                       ;------------------------------------------------------
0322               edb.line.unpack.copy:
0323 6CCC 0286  22         ci    tmp2,80               ; Check line length
     6CCE 0050 
0324 6CD0 1204  14         jle   !
0325 6CD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CD4 FFCE 
0326 6CD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CD8 2030 
0327                       ;------------------------------------------------------
0328                       ; Copy memory block
0329                       ;------------------------------------------------------
0330 6CDA 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6CDC 2480 
0331                                                   ; \ i  tmp0 = Source address
0332                                                   ; | i  tmp1 = Target address
0333                                                   ; / i  tmp2 = Bytes to copy
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               edb.line.unpack.exit:
0338 6CDE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0339 6CE0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0340 6CE2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0341 6CE4 C2F9  30         mov   *stack+,r11           ; Pop r11
0342 6CE6 045B  20         b     *r11                  ; Return to caller
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
0366 6CE8 0649  14         dect  stack
0367 6CEA C64B  30         mov   r11,*stack            ; Push return address
0368 6CEC 0649  14         dect  stack
0369 6CEE C644  30         mov   tmp0,*stack           ; Push tmp0
0370 6CF0 0649  14         dect  stack
0371 6CF2 C645  30         mov   tmp1,*stack           ; Push tmp1
0372                       ;------------------------------------------------------
0373                       ; Initialisation
0374                       ;------------------------------------------------------
0375 6CF4 04E0  34         clr   @outparm1             ; Reset length
     6CF6 8360 
0376 6CF8 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6CFA 8362 
0377                       ;------------------------------------------------------
0378                       ; Get length
0379                       ;------------------------------------------------------
0380 6CFC 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6CFE 6A06 
0381                                                   ; \ i  parm1    = Line number
0382                                                   ; | o  outparm1 = Pointer to line
0383                                                   ; / o  outparm2 = SAMS page
0384               
0385 6D00 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6D02 8360 
0386 6D04 1302  14         jeq   edb.line.getlength.exit
0387                                                   ; Exit early if NULL pointer
0388                       ;------------------------------------------------------
0389                       ; Process line prefix
0390                       ;------------------------------------------------------
0391 6D06 C814  46         mov   *tmp0,@outparm1       ; Save length
     6D08 8360 
0392                       ;------------------------------------------------------
0393                       ; Exit
0394                       ;------------------------------------------------------
0395               edb.line.getlength.exit:
0396 6D0A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0397 6D0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0398 6D0E C2F9  30         mov   *stack+,r11           ; Pop r11
0399 6D10 045B  20         b     *r11                  ; Return to caller
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
0419 6D12 0649  14         dect  stack
0420 6D14 C64B  30         mov   r11,*stack            ; Save return address
0421                       ;------------------------------------------------------
0422                       ; Calculate line in editor buffer
0423                       ;------------------------------------------------------
0424 6D16 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6D18 A104 
0425 6D1A A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6D1C A106 
0426                       ;------------------------------------------------------
0427                       ; Get length
0428                       ;------------------------------------------------------
0429 6D1E C804  38         mov   tmp0,@parm1
     6D20 8350 
0430 6D22 06A0  32         bl    @edb.line.getlength
     6D24 6CE8 
0431 6D26 C820  54         mov   @outparm1,@fb.row.length
     6D28 8360 
     6D2A A108 
0432                                                   ; Save row length
0433                       ;------------------------------------------------------
0434                       ; Exit
0435                       ;------------------------------------------------------
0436               edb.line.getlength2.exit:
0437 6D2C 0460  28         b     @poprt                ; Return to caller
     6D2E 222C 
0438               
**** **** ****     > stevie_b1.asm.299124
0053                       copy  "cmdb.asm"            ; Command Buffer
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
0027 6D30 0649  14         dect  stack
0028 6D32 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6D34 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6D36 D000 
0033 6D38 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6D3A A300 
0034               
0035 6D3C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6D3E A302 
0036 6D40 0204  20         li    tmp0,10
     6D42 000A 
0037 6D44 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6D46 A304 
0038 6D48 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6D4A A306 
0039               
0040 6D4C 0204  20         li    tmp0,>1b01            ; Y=27, X=1
     6D4E 1B01 
0041 6D50 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6D52 A308 
0042               
0043 6D54 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6D56 A312 
0044 6D58 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6D5A A314 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6D5C 06A0  32         bl    @film
     6D5E 2230 
0049 6D60 D000             data  cmdb.top,>00,cmdb.size
     6D62 0000 
     6D64 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6D66 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6D68 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               
0060               
0061               
0062               
0063               
0064               ***************************************************************
0065               * cmdb.refresh
0066               * Refresh command buffer content
0067               ***************************************************************
0068               * bl @cmdb.refresh
0069               *--------------------------------------------------------------
0070               * INPUT
0071               * none
0072               *--------------------------------------------------------------
0073               * OUTPUT
0074               * none
0075               *--------------------------------------------------------------
0076               * Register usage
0077               * none
0078               *--------------------------------------------------------------
0079               * Notes
0080               ********|*****|*********************|**************************
0081               cmdb.refresh:
0082 6D6A 0649  14         dect  stack
0083 6D6C C64B  30         mov   r11,*stack            ; Save return address
0084 6D6E 0649  14         dect  stack
0085 6D70 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D72 0649  14         dect  stack
0087 6D74 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D76 0649  14         dect  stack
0089 6D78 C646  30         mov   tmp2,*stack           ; Push tmp2
0090                       ;------------------------------------------------------
0091                       ; Dump Command buffer content
0092                       ;------------------------------------------------------
0093 6D7A C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6D7C 832A 
     6D7E A30A 
0094 6D80 C820  54         mov   @cmdb.yxtop,@wyx      ; Screen position top of CMDB pane
     6D82 A30C 
     6D84 832A 
0095               
0096 6D86 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6D88 23F4 
0097                                                   ; \ i  @wyx = Cursor position
0098                                                   ; / o  tmp0 = VDP target address
0099               
0100 6D8A C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6D8C A300 
0101 6D8E 0206  20         li    tmp2,5*80
     6D90 0190 
0102               
0103 6D92 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6D94 2438 
0104                                                   ; | i  tmp0 = VDP target address
0105                                                   ; | i  tmp1 = RAM source address
0106                                                   ; / i  tmp2 = Number of bytes to copy
0107                       ;------------------------------------------------------
0108                       ; Show command buffer prompt
0109                       ;------------------------------------------------------
0110 6D96 06A0  32         bl    @putat
     6D98 242A 
0111 6D9A 1B00                   byte 27,0
0112 6D9C 759C                   data txt.cmdb.prompt
0113               
0114 6D9E C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6DA0 A30A 
     6DA2 A114 
0115 6DA4 C820  54         mov   @cmdb.yxsave,@wyx
     6DA6 A30A 
     6DA8 832A 
0116                                                   ; Restore YX position
0117                       ;------------------------------------------------------
0118                       ; Exit
0119                       ;------------------------------------------------------
0120               cmdb.refresh.exit:
0121 6DAA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0122 6DAC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0123 6DAE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0124 6DB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0125 6DB2 045B  20         b     *r11                  ; Return to caller
0126               
**** **** ****     > stevie_b1.asm.299124
0054                       copy  "fh.read.sams.asm"    ; File handler read file
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
0025               * tmp0, tmp1, tmp2, tmp3, tmp4
0026               ********|*****|*********************|**************************
0027               fh.file.read.sams:
0028 6DB4 0649  14         dect  stack
0029 6DB6 C64B  30         mov   r11,*stack            ; Save return address
0030                       ;------------------------------------------------------
0031                       ; Initialisation
0032                       ;------------------------------------------------------
0033 6DB8 04E0  34         clr   @fh.records           ; Reset records counter
     6DBA A42E 
0034 6DBC 04E0  34         clr   @fh.counter           ; Clear internal counter
     6DBE A434 
0035 6DC0 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6DC2 A432 
0036 6DC4 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0037 6DC6 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6DC8 A42A 
0038 6DCA 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6DCC A42C 
0039               
0040 6DCE C120  34         mov   @edb.top.ptr,tmp0
     6DD0 A200 
0041 6DD2 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6DD4 24DE 
0042                                                   ; \ i  tmp0  = Memory address
0043                                                   ; | o  waux1 = SAMS page number
0044                                                   ; / o  waux2 = Address of SAMS register
0045               
0046 6DD6 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6DD8 833C 
     6DDA A438 
0047 6DDC C820  54         mov   @waux1,@fh.sams.hipage
     6DDE 833C 
     6DE0 A43A 
0048                                                   ; Set highest SAMS page in use
0049                       ;------------------------------------------------------
0050                       ; Save parameters / callback functions
0051                       ;------------------------------------------------------
0052 6DE2 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6DE4 8350 
     6DE6 A436 
0053 6DE8 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6DEA 8352 
     6DEC A43C 
0054 6DEE C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6DF0 8354 
     6DF2 A43E 
0055 6DF4 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6DF6 8356 
     6DF8 A440 
0056 6DFA C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6DFC 8358 
     6DFE A442 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 6E00 C120  34         mov   @fh.callback1,tmp0
     6E02 A43C 
0061 6E04 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E06 6000 
0062 6E08 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0063               
0064 6E0A 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E0C 7FFF 
0065 6E0E 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0066               
0067 6E10 C120  34         mov   @fh.callback2,tmp0
     6E12 A43E 
0068 6E14 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E16 6000 
0069 6E18 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0070               
0071 6E1A 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E1C 7FFF 
0072 6E1E 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6E20 C120  34         mov   @fh.callback3,tmp0
     6E22 A440 
0075 6E24 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E26 6000 
0076 6E28 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0077               
0078 6E2A 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E2C 7FFF 
0079 6E2E 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6E30 1004  14         jmp   fh.file.read.sams.load1
0082                                                   ; All checks passed, continue.
0083                                                   ;--------------------------
0084                                                   ; Check failed, crash CPU!
0085                                                   ;--------------------------
0086               fh.file.read.crash:
0087 6E32 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E34 FFCE 
0088 6E36 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E38 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.read.sams.load1:
0093 6E3A C120  34         mov   @fh.callback1,tmp0
     6E3C A43C 
0094 6E3E 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.read.sams.pabheader:
0099 6E40 06A0  32         bl    @cpym2v
     6E42 2432 
0100 6E44 0A60                   data fh.vpab,fh.file.pab.header,9
     6E46 6F92 
     6E48 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 6E4A 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6E4C 0A69 
0106 6E4E C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6E50 A436 
0107 6E52 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 6E54 0986  56         srl   tmp2,8                ; Right justify
0109 6E56 0586  14         inc   tmp2                  ; Include length byte as well
0110 6E58 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6E5A 2438 
0111                       ;------------------------------------------------------
0112                       ; Load GPL scratchpad layout
0113                       ;------------------------------------------------------
0114 6E5C 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6E5E 2AC2 
0115 6E60 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0116                       ;------------------------------------------------------
0117                       ; Open file
0118                       ;------------------------------------------------------
0119 6E62 06A0  32         bl    @file.open
     6E64 2C10 
0120 6E66 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0121 6E68 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6E6A 2026 
0122 6E6C 1602  14         jne   fh.file.read.sams.record
0123 6E6E 0460  28         b     @fh.file.read.sams.error
     6E70 6F60 
0124                                                   ; Yes, IO error occured
0125                       ;------------------------------------------------------
0126                       ; Step 1: Read file record
0127                       ;------------------------------------------------------
0128               fh.file.read.sams.record:
0129 6E72 05A0  34         inc   @fh.records           ; Update counter
     6E74 A42E 
0130 6E76 04E0  34         clr   @fh.reclen            ; Reset record length
     6E78 A430 
0131               
0132 6E7A 06A0  32         bl    @file.record.read     ; Read file record
     6E7C 2C52 
0133 6E7E 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0134                                                   ; |           (without +9 offset!)
0135                                                   ; | o  tmp0 = Status byte
0136                                                   ; | o  tmp1 = Bytes read
0137                                                   ; | o  tmp2 = Status register contents
0138                                                   ; /           upon DSRLNK return
0139               
0140 6E80 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6E82 A42A 
0141 6E84 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6E86 A430 
0142 6E88 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6E8A A42C 
0143                       ;------------------------------------------------------
0144                       ; 1a: Calculate kilobytes processed
0145                       ;------------------------------------------------------
0146 6E8C A805  38         a     tmp1,@fh.counter
     6E8E A434 
0147 6E90 A160  34         a     @fh.counter,tmp1
     6E92 A434 
0148 6E94 0285  22         ci    tmp1,1024
     6E96 0400 
0149 6E98 1106  14         jlt   !
0150 6E9A 05A0  34         inc   @fh.kilobytes
     6E9C A432 
0151 6E9E 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6EA0 FC00 
0152 6EA2 C805  38         mov   tmp1,@fh.counter
     6EA4 A434 
0153                       ;------------------------------------------------------
0154                       ; 1b: Load spectra scratchpad layout
0155                       ;------------------------------------------------------
0156 6EA6 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6EA8 2A48 
0157 6EAA 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6EAC 2AE4 
0158 6EAE 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0159                       ;------------------------------------------------------
0160                       ; 1c: Check if a file error occured
0161                       ;------------------------------------------------------
0162               fh.file.read.sams.check_fioerr:
0163 6EB0 C1A0  34         mov   @fh.ioresult,tmp2
     6EB2 A42C 
0164 6EB4 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6EB6 2026 
0165 6EB8 1602  14         jne   fh.file.read.sams.check_setpage
0166                                                   ; No, goto (1d)
0167 6EBA 0460  28         b     @fh.file.read.sams.error
     6EBC 6F60 
0168                                                   ; Yes, so handle file error
0169                       ;------------------------------------------------------
0170                       ; 1d: Check if SAMS page needs to be set
0171                       ;------------------------------------------------------
0172               fh.file.read.sams.check_setpage:
0173 6EBE C120  34         mov   @edb.next_free.ptr,tmp0
     6EC0 A208 
0174                                                   ;--------------------------
0175                                                   ; Sanity check
0176                                                   ;--------------------------
0177 6EC2 0284  22         ci    tmp0,edb.top + edb.size
     6EC4 D000 
0178                                                   ; Insane address ?
0179 6EC6 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0180                                                   ;--------------------------
0181                                                   ; Check overflow
0182                                                   ;--------------------------
0183 6EC8 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6ECA 0FFF 
0184 6ECC A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6ECE A430 
0185 6ED0 05C4  14         inct  tmp0                  ; +2 for line prefix
0186 6ED2 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6ED4 0FF0 
0187 6ED6 110E  14         jlt   fh.file.read.sams.process_line
0188                                                   ; Not yet so skip SAMS page switch
0189                       ;------------------------------------------------------
0190                       ; 1e: Increase SAMS page
0191                       ;------------------------------------------------------
0192 6ED8 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6EDA A438 
0193 6EDC C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6EDE A438 
     6EE0 A43A 
0194                                                   ; Set highest SAMS page
0195 6EE2 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6EE4 A200 
     6EE6 A208 
0196                                                   ; Start at top of SAMS page again
0197                       ;------------------------------------------------------
0198                       ; 1f: Switch to SAMS page
0199                       ;------------------------------------------------------
0200 6EE8 C120  34         mov   @fh.sams.page,tmp0
     6EEA A438 
0201 6EEC C160  34         mov   @edb.top.ptr,tmp1
     6EEE A200 
0202 6EF0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EF2 2516 
0203                                                   ; \ i  tmp0 = SAMS page number
0204                                                   ; / i  tmp1 = Memory address
0205                       ;------------------------------------------------------
0206                       ; Step 2: Process line
0207                       ;------------------------------------------------------
0208               fh.file.read.sams.process_line:
0209 6EF4 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6EF6 0960 
0210 6EF8 C160  34         mov   @edb.next_free.ptr,tmp1
     6EFA A208 
0211                                                   ; RAM target in editor buffer
0212               
0213 6EFC C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6EFE 8352 
0214               
0215 6F00 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6F02 A430 
0216 6F04 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0217                                                   ; Handle empty line
0218                       ;------------------------------------------------------
0219                       ; 2a: Copy line from VDP to CPU editor buffer
0220                       ;------------------------------------------------------
0221                                                   ; Put line length word before string
0222 6F06 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0223 6F08 06C6  14         swpb  tmp2                  ; |
0224 6F0A DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0225 6F0C 06C6  14         swpb  tmp2                  ; /
0226               
0227 6F0E 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6F10 A208 
0228 6F12 A806  38         a     tmp2,@edb.next_free.ptr
     6F14 A208 
0229                                                   ; Add line length
0230               
0231 6F16 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6F18 245E 
0232                                                   ; \ i  tmp0 = VDP source address
0233                                                   ; | i  tmp1 = RAM target address
0234                                                   ; / i  tmp2 = Bytes to copy
0235                       ;------------------------------------------------------
0236                       ; 2b: Align pointer to multiple of 16 memory address
0237                       ;------------------------------------------------------
0238 6F1A C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F1C A208 
0239 6F1E 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0240 6F20 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F22 000F 
0241 6F24 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F26 A208 
0242                       ;------------------------------------------------------
0243                       ; Step 3: Update index
0244                       ;------------------------------------------------------
0245               fh.file.read.sams.prepindex:
0246 6F28 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6F2A A204 
     6F2C 8350 
0247                                                   ; parm2 = Must allready be set!
0248 6F2E C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6F30 A438 
     6F32 8354 
0249               
0250 6F34 1009  14         jmp   fh.file.read.sams.updindex
0251                                                   ; Update index
0252                       ;------------------------------------------------------
0253                       ; 3a: Special handling for empty line
0254                       ;------------------------------------------------------
0255               fh.file.read.sams.prepindex.emptyline:
0256 6F36 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6F38 A42E 
     6F3A 8350 
0257 6F3C 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6F3E 8350 
0258 6F40 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6F42 8352 
0259 6F44 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6F46 8354 
0260                       ;------------------------------------------------------
0261                       ; 3b: Do actual index update
0262                       ;------------------------------------------------------
0263               fh.file.read.sams.updindex:
0264 6F48 06A0  32         bl    @idx.entry.update     ; Update index
     6F4A 69B4 
0265                                                   ; \ i  parm1    = Line num in editor buffer
0266                                                   ; | i  parm2    = Pointer to line in editor
0267                                                   ; |               buffer
0268                                                   ; | i  parm3    = SAMS page
0269                                                   ; | o  outparm1 = Pointer to updated index
0270                                                   ; /               entry
0271               
0272 6F4C 05A0  34         inc   @edb.lines            ; lines=lines+1
     6F4E A204 
0273                       ;------------------------------------------------------
0274                       ; Step 4: Callback "Read line from file"
0275                       ;------------------------------------------------------
0276               fh.file.read.sams.display:
0277 6F50 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6F52 A43E 
0278 6F54 0694  24         bl    *tmp0                 ; Run callback function
0279                       ;------------------------------------------------------
0280                       ; 4a: Next record
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.next:
0283 6F56 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6F58 2AC2 
0284 6F5A 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0285               
0286 6F5C 0460  28         b     @fh.file.read.sams.record
     6F5E 6E72 
0287                                                   ; Next record
0288                       ;------------------------------------------------------
0289                       ; Error handler
0290                       ;------------------------------------------------------
0291               fh.file.read.sams.error:
0292 6F60 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6F62 A42A 
0293 6F64 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0294 6F66 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6F68 0005 
0295 6F6A 1309  14         jeq   fh.file.read.sams.eof
0296                                                   ; All good. File closed by DSRLNK
0297                       ;------------------------------------------------------
0298                       ; File error occured
0299                       ;------------------------------------------------------
0300 6F6C 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F6E 2AE4 
0301 6F70 3F00                   data scrpad.backup2   ; / >2100->8300
0302               
0303 6F72 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F74 672C 
0304                       ;------------------------------------------------------
0305                       ; Callback "File I/O error"
0306                       ;------------------------------------------------------
0307 6F76 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     6F78 A442 
0308 6F7A 0694  24         bl    *tmp0                 ; Run callback function
0309 6F7C 1008  14         jmp   fh.file.read.sams.exit
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               fh.file.read.sams.eof:
0314 6F7E 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F80 2AE4 
0315 6F82 3F00                   data scrpad.backup2   ; / >2100->8300
0316               
0317 6F84 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F86 672C 
0318                       ;------------------------------------------------------
0319                       ; Callback "Close file"
0320                       ;------------------------------------------------------
0321 6F88 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     6F8A A440 
0322 6F8C 0694  24         bl    *tmp0                 ; Run callback function
0323               *--------------------------------------------------------------
0324               * Exit
0325               *--------------------------------------------------------------
0326               fh.file.read.sams.exit:
0327 6F8E C2F9  30         mov   *stack+,r11           ; Pop r11
0328 6F90 045B  20         b     *r11                  ; Return to caller
0329               
0330               
0331               
0332               ***************************************************************
0333               * PAB for accessing DV/80 file
0334               ********|*****|*********************|**************************
0335               fh.file.pab.header:
0336 6F92 0014             byte  io.op.open            ;  0    - OPEN
0337                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0338 6F94 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0339 6F96 5000             byte  80                    ;  4    - Record length (80 chars max)
0340                       byte  00                    ;  5    - Character count
0341 6F98 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0342 6F9A 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0343                       ;------------------------------------------------------
0344                       ; File descriptor part (variable length)
0345                       ;------------------------------------------------------
0346                       ; byte  12                  ;  9    - File descriptor length
0347                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0348                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.299124
0055                       copy  "fm.load.asm"         ; File manager loadfile
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
0014 6F9C 0649  14         dect  stack
0015 6F9E C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6FA0 C804  38         mov   tmp0,@parm1           ; Setup file to load
     6FA2 8350 
0018 6FA4 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6FA6 6B44 
0019 6FA8 06A0  32         bl    @idx.init             ; Initialize index
     6FAA 68B2 
0020 6FAC 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6FAE 6788 
0021 6FB0 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6FB2 735A 
0022 6FB4 C820  54         mov   @parm1,@edb.filename.ptr
     6FB6 8350 
     6FB8 A20E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6FBA 06A0  32         bl    @filv
     6FBC 2288 
0028 6FBE 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6FC0 0000 
     6FC2 0004 
0029               
0030 6FC4 C160  34         mov   @fb.scrrows,tmp1
     6FC6 A118 
0031 6FC8 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6FCA A10E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6FCC 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0035 6FCE 0205  20         li    tmp1,32               ; Character to fill
     6FD0 0020 
0036               
0037 6FD2 06A0  32         bl    @xfilv                ; Fill VDP memory
     6FD4 228E 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6FD6 0204  20         li    tmp0,fm.loadfile.cb.indicator1
     6FD8 700A 
0045 6FDA C804  38         mov   tmp0,@parm2           ; Register callback 1
     6FDC 8352 
0046               
0047 6FDE 0204  20         li    tmp0,fm.loadfile.cb.indicator2
     6FE0 7032 
0048 6FE2 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6FE4 8354 
0049               
0050 6FE6 0204  20         li    tmp0,fm.loadfile.cb.indicator3
     6FE8 7064 
0051 6FEA C804  38         mov   tmp0,@parm4           ; Register callback 3
     6FEC 8356 
0052               
0053 6FEE 0204  20         li    tmp0,fm.loadfile.cb.fioerr
     6FF0 7096 
0054 6FF2 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6FF4 8358 
0055               
0056 6FF6 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6FF8 6DB4 
0057                                                   ; \ i  parm1 = Pointer to length prefixed
0058                                                   ; |            file descriptor
0059                                                   ; | i  parm2 = Pointer to callback
0060                                                   ; |            "loading indicator 1"
0061                                                   ; | i  parm3 = Pointer to callback
0062                                                   ; |            "loading indicator 2"
0063                                                   ; | i  parm4 = Pointer to callback
0064                                                   ; |            "loading indicator 3"
0065                                                   ; | i  parm5 = Pointer to callback
0066                                                   ; /            "File I/O error handler"
0067               
0068 6FFA 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6FFC A206 
0069                                                   ; longer dirty.
0070               
0071 6FFE 0204  20         li    tmp0,txt.filetype.DV80
     7000 75E0 
0072 7002 C804  38         mov   tmp0,@edb.filetype.ptr
     7004 A210 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 7006 0460  28         b     @poprt                ; Return to caller
     7008 222C 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               * Open file
0085               *---------------------------------------------------------------
0086               * Is expected to be passed as parm2 to @tfh.file.read
0087               *---------------------------------------------------------------
0088               fm.loadfile.cb.indicator1:
0089 700A 0649  14         dect  stack
0090 700C C64B  30         mov   r11,*stack            ; Save return address
0091                       ;------------------------------------------------------
0092                       ; Show loading indicators and file descriptor
0093                       ;------------------------------------------------------
0094 700E 06A0  32         bl    @hchar
     7010 2762 
0095 7012 1D03                   byte 29,3,32,77
     7014 204D 
0096 7016 FFFF                   data EOL
0097               
0098 7018 06A0  32         bl    @putat
     701A 242A 
0099 701C 1D03                   byte 29,3
0100 701E 7548                   data txt.loading      ; Display "Loading...."
0101               
0102 7020 06A0  32         bl    @at
     7022 266E 
0103 7024 1D0E                   byte 29,14            ; Cursor YX position
0104 7026 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7028 8350 
0105 702A 06A0  32         bl    @xutst0               ; Display device/filename
     702C 241A 
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               fm.loadfile.cb.indicator1.exit:
0110 702E 0460  28         b     @poprt                ; Return to caller
     7030 222C 
0111               
0112               
0113               
0114               
0115               *---------------------------------------------------------------
0116               * Callback function "Show loading indicator 2"
0117               *---------------------------------------------------------------
0118               * Read line
0119               * Is expected to be passed as parm3 to @tfh.file.read
0120               *---------------------------------------------------------------
0121               fm.loadfile.cb.indicator2:
0122 7032 0649  14         dect  stack
0123 7034 C64B  30         mov   r11,*stack            ; Save return address
0124               
0125 7036 06A0  32         bl    @putnum
     7038 2A3E 
0126 703A 1D4B                   byte 29,75            ; Show lines read
0127 703C A204                   data edb.lines,rambuf,>3020
     703E 8390 
     7040 3020 
0128               
0129 7042 8220  34         c     @fh.kilobytes,tmp4
     7044 A432 
0130 7046 130C  14         jeq   fm.loadfile.cb.indicator2.exit
0131               
0132 7048 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     704A A432 
0133               
0134 704C 06A0  32         bl    @putnum
     704E 2A3E 
0135 7050 1D38                   byte 29,56            ; Show kilobytes read
0136 7052 A432                   data fh.kilobytes,rambuf,>3020
     7054 8390 
     7056 3020 
0137               
0138 7058 06A0  32         bl    @putat
     705A 242A 
0139 705C 1D3D                   byte 29,61
0140 705E 7554                   data txt.kb           ; Show "kb" string
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               fm.loadfile.cb.indicator2.exit:
0145 7060 0460  28         b     @poprt                ; Return to caller
     7062 222C 
0146               
0147               
0148               
0149               
0150               
0151               *---------------------------------------------------------------
0152               * Callback function "Show loading indicator 3"
0153               * Close file
0154               *---------------------------------------------------------------
0155               * Is expected to be passed as parm4 to @tfh.file.read
0156               *---------------------------------------------------------------
0157               fm.loadfile.cb.indicator3:
0158 7064 0649  14         dect  stack
0159 7066 C64B  30         mov   r11,*stack            ; Save return address
0160               
0161               
0162 7068 06A0  32         bl    @hchar
     706A 2762 
0163 706C 1D03                   byte 29,3,32,50       ; Erase loading indicator
     706E 2032 
0164 7070 FFFF                   data EOL
0165               
0166 7072 06A0  32         bl    @putnum
     7074 2A3E 
0167 7076 1D38                   byte 29,56            ; Show kilobytes read
0168 7078 A432                   data fh.kilobytes,rambuf,>3020
     707A 8390 
     707C 3020 
0169               
0170 707E 06A0  32         bl    @putat
     7080 242A 
0171 7082 1D3D                   byte 29,61
0172 7084 7554                   data txt.kb           ; Show "kb" string
0173               
0174 7086 06A0  32         bl    @putnum
     7088 2A3E 
0175 708A 1D4B                   byte 29,75            ; Show lines read
0176 708C A42E                   data fh.records,rambuf,>3020
     708E 8390 
     7090 3020 
0177                       ;------------------------------------------------------
0178                       ; Exit
0179                       ;------------------------------------------------------
0180               fm.loadfile.cb.indicator3.exit:
0181 7092 0460  28         b     @poprt                ; Return to caller
     7094 222C 
0182               
0183               
0184               
0185               *---------------------------------------------------------------
0186               * Callback function "File I/O error handler"
0187               *---------------------------------------------------------------
0188               * Is expected to be passed as parm5 to @tfh.file.read
0189               ********|*****|*********************|**************************
0190               fm.loadfile.cb.fioerr:
0191 7096 0649  14         dect  stack
0192 7098 C64B  30         mov   r11,*stack            ; Save return address
0193               
0194 709A 06A0  32         bl    @hchar
     709C 2762 
0195 709E 1D00                   byte 29,0,32,50       ; Erase loading indicator
     70A0 2032 
0196 70A2 FFFF                   data EOL
0197               
0198                       ;------------------------------------------------------
0199                       ; Display I/O error message
0200                       ;------------------------------------------------------
0201 70A4 06A0  32         bl    @cpym2m
     70A6 247A 
0202 70A8 7563                   data txt.ioerr+1
0203 70AA D000                   data cmdb.top
0204 70AC 0029                   data 41               ; Error message
0205               
0206               
0207 70AE C120  34         mov   @edb.filename.ptr,tmp0
     70B0 A20E 
0208 70B2 D194  26         movb  *tmp0,tmp2            ; Get length byte
0209 70B4 0986  56         srl   tmp2,8                ; Right align
0210 70B6 0584  14         inc   tmp0                  ; Skip length byte
0211 70B8 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     70BA D02A 
0212               
0213 70BC 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     70BE 2480 
0214                                                   ; | i  tmp0 = ROM/RAM source
0215                                                   ; | i  tmp1 = RAM destination
0216                                                   ; / i  tmp2 = Bytes top copy
0217               
0218               
0219 70C0 0204  20         li    tmp0,txt.newfile      ; New file
     70C2 7590 
0220 70C4 C804  38         mov   tmp0,@edb.filename.ptr
     70C6 A20E 
0221               
0222 70C8 0204  20         li    tmp0,txt.filetype.none
     70CA 75E6 
0223 70CC C804  38         mov   tmp0,@edb.filetype.ptr
     70CE A210 
0224                                                   ; Empty filetype string
0225               
0226 70D0 C820  54         mov   @cmdb.scrrows,@parm1
     70D2 A304 
     70D4 8350 
0227 70D6 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     70D8 7320 
0228                       ;------------------------------------------------------
0229                       ; Exit
0230                       ;------------------------------------------------------
0231               fm.loadfile.cb.fioerr.exit:
0232 70DA 0460  28         b     @poprt                ; Return to caller
     70DC 222C 
**** **** ****     > stevie_b1.asm.299124
0056                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 70DE 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     70E0 2014 
0013 70E2 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 70E4 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     70E6 2014 
0019 70E8 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     70EA 833C 
     70EC 833E 
0020 70EE 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 70F0 C820  54         mov   @waux1,@waux2         ; Save as previous key
     70F2 833C 
     70F4 833E 
0026 70F6 0460  28         b     @edkey.key.process    ; Process key
     70F8 611E 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 70FA 04E0  34         clr   @waux1
     70FC 833C 
0032 70FE 04E0  34         clr   @waux2
     7100 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 7102 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7104 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 7106 0604  14         dec   tmp0
0043 7108 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 710A 0460  28         b     @hookok               ; Return
     710C 2C9A 
**** **** ****     > stevie_b1.asm.299124
0057                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0015 710E C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7110 A302 
0016 7112 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 7114 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7116 A314 
0022 7118 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 711A 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     711C 7302 
0025 711E 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7120 A314 
0026 7122 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 7124 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7126 A116 
0031 7128 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 712A C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     712C 832A 
     712E A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 7130 8820  54         c     @edb.lines,@fb.scrrows
     7132 A204 
     7134 A118 
0037 7136 1103  14         jlt   task.vdp.panes.setrows.small
0038 7138 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     713A A118 
0039 713C 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 713E C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7140 A204 
0045 7142 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 7144 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7146 A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 7148 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 714A C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     714C A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 714E 06A0  32         bl    @xpym2v               ; Copy to VDP
     7150 2438 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 7152 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7154 A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 7156 C120  34         mov   @edb.lines,tmp0
     7158 A204 
0066 715A 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     715C A104 
0067 715E 0584  14         inc   tmp0                  ; Y = Y + 1
0068 7160 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     7162 A118 
0069 7164 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 7166 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 7168 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     716A 832A 
0077               
0078 716C 06A0  32         bl    @putstr
     716E 2418 
0079 7170 7532                   data txt.marker       ; Display *EOF*
0080               
0081 7172 06A0  32         bl    @setx
     7174 2684 
0082 7176 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 7178 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     717A A10E 
0088               
0089 717C C160  34         mov   @wyx,tmp1             ;
     717E 832A 
0090 7180 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 7182 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 7184 A160  34         a     @fb.scrrows.max,tmp1  ; tmp1 = -Y position + fb.scrrows.max
     7186 A11A 
0093               
0094 7188 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 718A 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     718C FFFB 
0096               
0097 718E 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7190 23F4 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 7192 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 7194 06A0  32         bl    @xfilv                ; Fill VDP memory
     7196 228E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 7198 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     719A A114 
     719C 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 719E 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     71A0 737A 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 71A2 0460  28         b     @slotok
     71A4 2D16 
**** **** ****     > stevie_b1.asm.299124
0058                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 71A6 C120  34         mov   @tv.pane.focus,tmp0
     71A8 A018 
0013 71AA 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 71AC 0284  22         ci    tmp0,pane.focus.cmdb
     71AE 0001 
0016 71B0 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 71B2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     71B4 FFCE 
0022 71B6 06A0  32         bl    @cpu.crash            ; / Halt system.
     71B8 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 71BA C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     71BC A308 
     71BE 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 71C0 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     71C2 202A 
0032 71C4 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     71C6 2690 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 71C8 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     71CA 8380 
0036               
0037 71CC 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     71CE 2432 
0038 71D0 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     71D2 8380 
     71D4 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 71D6 0460  28         b     @slotok               ; Exit task
     71D8 2D16 
**** **** ****     > stevie_b1.asm.299124
0059                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 71DA 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     71DC A112 
0013 71DE 1303  14         jeq   task.vdp.cursor.visible
0014 71E0 04E0  34         clr   @ramsat+2              ; Hide cursor
     71E2 8382 
0015 71E4 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 71E6 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     71E8 A20A 
0019 71EA 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 71EC C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     71EE A018 
0025 71F0 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 71F2 0284  22         ci    tmp0,pane.focus.cmdb
     71F4 0001 
0028 71F6 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 71F8 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 71FA 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 71FC 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     71FE 0100 
0040 7200 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 7202 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7204 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7206 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7208 A014 
0051 720A C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     720C A014 
     720E 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7210 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7212 2432 
0057 7214 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     7216 8380 
     7218 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 721A 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     721C 737A 
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               task.vdp.cursor.exit:
0068 721E 0460  28         b     @slotok                ; Exit task
     7220 2D16 
**** **** ****     > stevie_b1.asm.299124
0060               
0061                       copy  "pane.utils.colorscheme.asm"
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
0021 7222 0649  14         dect  stack
0022 7224 C64B  30         mov   r11,*stack            ; Push return address
0023 7226 0649  14         dect  stack
0024 7228 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 722A C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     722C A012 
0027 722E 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     7230 0008 
0028                                                   ; Last entry reached?
0029 7232 1102  14         jlt   !
0030 7234 04C4  14         clr   tmp0
0031 7236 1001  14         jmp   pane.action.colorscheme.switch
0032 7238 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 723A C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     723C A012 
0038 723E 06A0  32         bl    @pane.action.colorscheme.load
     7240 7250 
0039                       ;-------------------------------------------------------
0040                       ; Delay
0041                       ;-------------------------------------------------------
0042 7242 0204  20         li    tmp0,12000
     7244 2EE0 
0043 7246 0604  14 !       dec   tmp0
0044 7248 16FE  14         jne   -!
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               pane.action.colorscheme.cycle.exit:
0049 724A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0050 724C C2F9  30         mov   *stack+,r11           ; Pop R11
0051 724E 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               
0055               
0056               
0057               ***************************************************************
0058               * pane.action.color.load
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
0070               * tmp0,tmp1,tmp2,tmp3
0071               ********|*****|*********************|**************************
0072               pane.action.colorscheme.load:
0073 7250 0649  14         dect  stack
0074 7252 C64B  30         mov   r11,*stack            ; Save return address
0075 7254 0649  14         dect  stack
0076 7256 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 7258 0649  14         dect  stack
0078 725A C645  30         mov   tmp1,*stack           ; Push tmp1
0079 725C 0649  14         dect  stack
0080 725E C646  30         mov   tmp2,*stack           ; Push tmp2
0081 7260 0649  14         dect  stack
0082 7262 C647  30         mov   tmp3,*stack           ; Push tmp3
0083 7264 0649  14         dect  stack
0084 7266 C648  30         mov   tmp4,*stack           ; Push tmp4
0085 7268 06A0  32         bl    @scroff               ; Turn screen off
     726A 262E 
0086                       ;-------------------------------------------------------
0087                       ; Get foreground/background color
0088                       ;-------------------------------------------------------
0089 726C C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     726E A012 
0090 7270 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0091 7272 0224  22         ai    tmp0,tv.colorscheme.table
     7274 750C 
0092                                                   ; Add base for color scheme data table
0093 7276 C1F4  30         mov   *tmp0+,tmp3           ; Get fg/bg color
0094 7278 C214  26         mov   *tmp0,tmp4            ; Get cursor colors
0095 727A C808  38         mov   tmp4,@tv.curcolor     ; Save cursor colors
     727C A016 
0096                       ;-------------------------------------------------------
0097                       ; Dump colors to VDP register 7 (text mode)
0098                       ;-------------------------------------------------------
0099 727E C147  18         mov   tmp3,tmp1             ; Get work copy
0100 7280 0985  56         srl   tmp1,8                ; MSB to LSB
0101 7282 0265  22         ori   tmp1,>0700
     7284 0700 
0102 7286 C105  18         mov   tmp1,tmp0
0103 7288 06A0  32         bl    @putvrx               ; Write VDP register
     728A 232E 
0104                       ;-------------------------------------------------------
0105                       ; Dump colors for frame buffer pane (TAT)
0106                       ;-------------------------------------------------------
0107 728C 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     728E 1800 
0108 7290 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0109 7292 0985  56         srl   tmp1,8                ; MSB to LSB
0110 7294 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     7296 0910 
0111 7298 06A0  32         bl    @xfilv                ; Fill colors
     729A 228E 
0112                                                   ; i \  tmp0 = start address
0113                                                   ; i |  tmp1 = byte to fill
0114                                                   ; i /  tmp2 = number of bytes to fill
0115                       ;-------------------------------------------------------
0116                       ; Dump colors for bottom status line pane (TAT)
0117                       ;-------------------------------------------------------
0118 729C 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     729E 2110 
0119 72A0 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0120 72A2 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     72A4 00FF 
0121 72A6 0206  20         li    tmp2,80               ; Number of bytes to fill
     72A8 0050 
0122 72AA 06A0  32         bl    @xfilv                ; Fill colors
     72AC 228E 
0123                                                   ; i \  tmp0 = start address
0124                                                   ; i |  tmp1 = byte to fill
0125                                                   ; i /  tmp2 = number of bytes to fill
0126                       ;-------------------------------------------------------
0127                       ; Dump cursor FG color to sprite table (SAT)
0128                       ;-------------------------------------------------------
0129 72AE 0248  22         andi  tmp4,>0f00
     72B0 0F00 
0130 72B2 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     72B4 8383 
0131 72B6 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     72B8 A015 
0132                       ;-------------------------------------------------------
0133                       ; Exit
0134                       ;-------------------------------------------------------
0135               pane.action.colorscheme.load.exit:
0136 72BA 06A0  32         bl    @scron                ; Turn screen on
     72BC 2636 
0137 72BE C239  30         mov   *stack+,tmp4          ; Pop tmp4
0138 72C0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0139 72C2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 72C4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 72C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 72C8 C2F9  30         mov   *stack+,r11           ; Pop R11
0143 72CA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0062                                                   ; Colorscheme handling in panges
0063                       copy  "pane.utils.tipiclock.asm"
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
0021 72CC 0649  14         dect  stack
0022 72CE C64B  30         mov   r11,*stack            ; Push return address
0023 72D0 0649  14         dect  stack
0024 72D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 72D4 0204  20         li    tmp0,fdname.clock
     72D6 769A 
0029 72D8 C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     72DA 8350 
0030               
0031 72DC 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     72DE 72FE 
0032 72E0 C804  38         mov   tmp0,@parm2           ; Register callback 1
     72E2 8352 
0033 72E4 C804  38         mov   tmp0,@parm3           ; Register callback 2
     72E6 8354 
0034 72E8 C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     72EA 8358 
0035               
0036 72EC 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     72EE 7300 
0037 72F0 C804  38         mov   tmp0,@parm4           ; Register callback 3
     72F2 8356 
0038               
0039 72F4 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     72F6 6DB4 
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
0055 72F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 72FA C2F9  30         mov   *stack+,r11           ; Pop R11
0057 72FC 045B  20         b     *r11                  ; Return to caller
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
0070 72FE 069B  24         bl    *r11                  ; Return to caller
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
0083 7300 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0064                                                   ; Colorscheme
0065               
0066                       copy  "pane.cmdb.asm"       ; Command buffer pane
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
0021 7302 0649  14         dect  stack
0022 7304 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Draw command buffer
0025                       ;------------------------------------------------------
0026 7306 06A0  32         bl    @putat
     7308 242A 
0027 730A 1200                   byte 18,0
0028 730C 75D0                   data txt.cmdb.title
0029               
0030 730E 06A0  32         bl    @hchar
     7310 2762 
0031 7312 120F                   byte 18,15,1,65        ; Horizontal top line
     7314 0141 
0032 7316 FFFF                   data EOL
0033               
0034 7318 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     731A 6D6A 
0035                       ;------------------------------------------------------
0036                       ; Exit
0037                       ;------------------------------------------------------
0038               pane.cmdb.exit:
0039 731C C2F9  30         mov   *stack+,r11           ; Pop r11
0040 731E 045B  20         b     *r11                  ; Return
0041               
0042               
0043               ***************************************************************
0044               * pane.cmdb.show
0045               * Show command buffer pane
0046               ***************************************************************
0047               * bl @pane.cmdb.show
0048               *--------------------------------------------------------------
0049               * INPUT
0050               * none
0051               *--------------------------------------------------------------
0052               * OUTPUT
0053               * none
0054               *--------------------------------------------------------------
0055               * Register usage
0056               * none
0057               *--------------------------------------------------------------
0058               * Notes
0059               ********|*****|*********************|**************************
0060               pane.cmdb.show:
0061 7320 0649  14         dect  stack
0062 7322 C64B  30         mov   r11,*stack            ; Save return address
0063 7324 0649  14         dect  stack
0064 7326 C644  30         mov   tmp0,*stack           ; Push tmp0
0065                       ;------------------------------------------------------
0066                       ; Show command buffer pane
0067                       ;------------------------------------------------------
0068 7328 C820  54         mov   @wyx,@cmdb.fb.yxsave
     732A 832A 
     732C A316 
0069                                                   ; Save YX position in frame buffer
0070               
0071 732E C120  34         mov   @fb.scrrows.max,tmp0
     7330 A11A 
0072 7332 6120  34         s     @cmdb.scrrows,tmp0
     7334 A304 
0073 7336 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7338 A118 
0074               
0075 733A 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0076 733C 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0077 733E 0584  14         inc   tmp0                  ; X=1
0078 7340 C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
     7342 A30C 
0079               
0080 7344 0720  34         seto  @cmdb.visible         ; Show pane
     7346 A302 
0081 7348 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     734A A314 
0082               
0083 734C 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     734E 0001 
0084 7350 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7352 A018 
0085               pane.cmdb.show.exit:
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089 7354 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0090 7356 C2F9  30         mov   *stack+,r11           ; Pop r11
0091 7358 045B  20         b     *r11                  ; Return to caller
0092               
0093               
0094               
0095               ***************************************************************
0096               * pane.cmdb.hide
0097               * Hide command buffer pane
0098               ***************************************************************
0099               * bl @pane.cmdb.hide
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
0110               * Hiding the command buffer automatically passes pane focus
0111               * to frame buffer.
0112               ********|*****|*********************|**************************
0113               pane.cmdb.hide:
0114 735A 0649  14         dect  stack
0115 735C C64B  30         mov   r11,*stack            ; Save return address
0116                       ;------------------------------------------------------
0117                       ; Hide command buffer pane
0118                       ;------------------------------------------------------
0119 735E C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7360 A11A 
     7362 A118 
0120                                                   ; Resize framebuffer
0121               
0122 7364 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7366 A316 
     7368 832A 
0123               
0124 736A 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     736C A302 
0125 736E 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7370 A116 
0126 7372 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7374 A018 
0127               
0128               pane.cmdb.hide.exit:
0129                       ;------------------------------------------------------
0130                       ; Exit
0131                       ;------------------------------------------------------
0132 7376 C2F9  30         mov   *stack+,r11           ; Pop r11
0133 7378 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.299124
0067                       copy  "pane.botline.asm"    ; Status line pane
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
0021 737A 0649  14         dect  stack
0022 737C C64B  30         mov   r11,*stack            ; Save return address
0023 737E 0649  14         dect  stack
0024 7380 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7382 C820  54         mov   @wyx,@fb.yxsave
     7384 832A 
     7386 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 7388 06A0  32         bl    @putat
     738A 242A 
0032 738C 1D00                   byte  29,0
0033 738E 758C                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 7390 06A0  32         bl    @at
     7392 266E 
0039 7394 1D03                   byte  29,3            ; Position cursor
0040 7396 C160  34         mov   @edb.filename.ptr,tmp1
     7398 A20E 
0041                                                   ; Get string to display
0042 739A 06A0  32         bl    @xutst0               ; Display string
     739C 241A 
0043               
0044 739E 06A0  32         bl    @at
     73A0 266E 
0045 73A2 1D23                   byte  29,35           ; Position cursor
0046               
0047 73A4 C160  34         mov   @edb.filetype.ptr,tmp1
     73A6 A210 
0048                                                   ; Get string to display
0049 73A8 06A0  32         bl    @xutst0               ; Display Filetype string
     73AA 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 73AC C120  34         mov   @edb.insmode,tmp0
     73AE A20A 
0055 73B0 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 73B2 06A0  32         bl    @putat
     73B4 242A 
0061 73B6 1D32                   byte  29,50
0062 73B8 753E                   data  txt.ovrwrite
0063 73BA 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 73BC 06A0  32         bl    @putat
     73BE 242A 
0069 73C0 1D32                   byte  29,50
0070 73C2 7542                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 73C4 C120  34         mov   @edb.dirty,tmp0
     73C6 A206 
0076 73C8 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 73CA 06A0  32         bl    @putat
     73CC 242A 
0081 73CE 1D36                   byte 29,54
0082 73D0 7546                   data txt.star
0083 73D2 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 73D4 1000  14         nop
0089               pane.botline.show_linecol:
0090 73D6 C820  54         mov   @fb.row,@parm1
     73D8 A106 
     73DA 8350 
0091 73DC 06A0  32         bl    @fb.row2line
     73DE 67CA 
0092 73E0 05A0  34         inc   @outparm1
     73E2 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 73E4 06A0  32         bl    @putnum
     73E6 2A3E 
0097 73E8 1D40                   byte  29,64           ; YX
0098 73EA 8360                   data  outparm1,rambuf
     73EC 8390 
0099 73EE 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 73F0 06A0  32         bl    @putat
     73F2 242A 
0105 73F4 1D45                   byte  29,69
0106 73F6 7530                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 73F8 06A0  32         bl    @film
     73FA 2230 
0111 73FC 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     73FE 0020 
     7400 000C 
0112               
0113 7402 C820  54         mov   @fb.column,@waux1
     7404 A10C 
     7406 833C 
0114 7408 05A0  34         inc   @waux1                ; Offset 1
     740A 833C 
0115               
0116 740C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     740E 29C0 
0117 7410 833C                   data  waux1,rambuf
     7412 8390 
0118 7414 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 7416 06A0  32         bl    @trimnum              ; Trim number to the left
     7418 2A18 
0122 741A 8390                   data  rambuf,rambuf+6,32
     741C 8396 
     741E 0020 
0123               
0124 7420 0204  20         li    tmp0,>0200
     7422 0200 
0125 7424 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7426 8396 
0126               
0127 7428 06A0  32         bl    @putat
     742A 242A 
0128 742C 1D46                   byte 29,70
0129 742E 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7430 C820  54         mov   @fb.row,@parm1
     7432 A106 
     7434 8350 
0134 7436 06A0  32         bl    @fb.row2line
     7438 67CA 
0135 743A 8820  54         c     @edb.lines,@outparm1
     743C A204 
     743E 8360 
0136 7440 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 7442 06A0  32         bl    @putat
     7444 242A 
0139 7446 1D4B                   byte 29,75
0140 7448 7538                   data txt.bottom
0141               
0142 744A 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 744C C820  54         mov   @edb.lines,@waux1
     744E A204 
     7450 833C 
0148 7452 05A0  34         inc   @waux1                ; Offset 1
     7454 833C 
0149 7456 06A0  32         bl    @putnum
     7458 2A3E 
0150 745A 1D4B                   byte 29,75            ; YX
0151 745C 833C                   data waux1,rambuf
     745E 8390 
0152 7460 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 7462 C820  54         mov   @fb.yxsave,@wyx
     7464 A114 
     7466 832A 
0159 7468 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 746A C2F9  30         mov   *stack+,r11           ; Pop r11
0161 746C 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.299124
0068                       copy  "data.constants.asm"  ; Data segment - Constants
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
0033 746E 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     7470 003F 
     7472 0243 
     7474 05F4 
     7476 0050 
0034               
0035               romsat:
0036 7478 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     747A 0001 
0037               
0038               cursors:
0039 747C 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     747E 0000 
     7480 0000 
     7482 001C 
0040 7484 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     7486 1010 
     7488 1010 
     748A 1000 
0041 748C 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     748E 1C1C 
     7490 1C1C 
     7492 1C00 
0042               
0043               patterns:
0044 7494 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     7496 0000 
     7498 00FF 
     749A 0000 
0045 749C 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     749E 0000 
     74A0 FF00 
     74A2 FF00 
0046               patterns.box:
0047 74A4 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     74A6 0000 
     74A8 FF00 
     74AA FF00 
0048 74AC 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     74AE 0000 
     74B0 FF80 
     74B2 BFA0 
0049 74B4 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     74B6 0000 
     74B8 FC04 
     74BA F414 
0050 74BC A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     74BE A0A0 
     74C0 A0A0 
     74C2 A0A0 
0051 74C4 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     74C6 1414 
     74C8 1414 
     74CA 1414 
0052 74CC A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     74CE A0A0 
     74D0 BF80 
     74D2 FF00 
0053 74D4 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     74D6 1414 
     74D8 F404 
     74DA FC00 
0054 74DC 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     74DE C0C0 
     74E0 C0C0 
     74E2 0080 
0055 74E4 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     74E6 0F0F 
     74E8 0F0F 
     74EA 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 74EC 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     74EE 0002 
0065 74F0 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     74F2 0003 
0066 74F4 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     74F6 000A 
0067               
0068 74F8 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     74FA 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 74FC C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     74FE 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 7500 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7502 000D 
0077 7504 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7506 000E 
0078 7508 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     750A 000F 
0079               
0080               
0081               
0082               
0083               
0084               ***************************************************************
0085               * Stevie color schemes table
0086               *--------------------------------------------------------------
0087               * Word 1
0088               *    MSB  high-nibble    Foreground color frame buffer and cursor sprite
0089               *    MSB  low-nibble     Background color frame buffer and background pane
0090               *    LSB  high-nibble    Foreground color bottom line pane
0091               *    LSB  low-nibble     Background color bottom line pane
0092               *
0093               * Word 2
0094               *    MSB  high-nibble    0
0095               *    MSB  low-nibble     Cursor foreground color 1
0096               *    LSB  high-nibble    0
0097               *    LSB  low-nibble     Cursor foreground color 2
0098               *--------------------------------------------------------------
0099      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0100               
0101               tv.colorscheme.table:
0102                                  ;----------------------+-----------------------|-------------
0103                                  ; Framebuffer          | Bottom line pane      | Cursor color
0104                                  ; Fg. / Bg.            | Fg. / Bg.             |  1 / 2
0105                                  ;-----------------------------+----------------|-------------
0106 750C F41F      data  >f41f,>0101 ; White + Dark blue    | Black + White         | Black+Black
     750E 0101 
0107 7510 F41C      data  >f41c,>0f0f ; White + Dark blue    | Black + Dark green    | White+White
     7512 0F0F 
0108 7514 A11A      data  >a11a,>0f0f ; Dark yellow + Black  | Black + Dark yellow   | White+White
     7516 0F0F 
0109 7518 2112      data  >2112,>0f0f ; Medium green + Black | Black + Medium green  | White+White
     751A 0F0F 
0110 751C E11E      data  >e11e,>0f0f ; Grey + Black         | Black + Grey          | White+White
     751E 0F0F 
0111 7520 1771      data  >1771,>0606 ; Black + Cyan         | Cyan  + Black         | Red  +Red
     7522 0606 
0112 7524 1F10      data  >1f10,>010f ; Black + White        | Black + Transparant   | White+White
     7526 010F 
0113 7528 A1F0      data  >a1f0,>0f0f ; Dark yellow + Black  | White + Transparant   | White+White
     752A 0F0F 
0114 752C 21F0      data  >21f0,>0f0f ; Medium green + Black | White + Transparant   | White+White
     752E 0F0F 
0115               
**** **** ****     > stevie_b1.asm.299124
0069                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 7530 012C             byte  1
0009 7531 ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 7532 052A             byte  5
0014 7533 ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 7538 0520             byte  5
0019 7539 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 753E 034F             byte  3
0024 753F ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 7542 0349             byte  3
0029 7543 ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 7546 012A             byte  1
0034 7547 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 7548 0A4C             byte  10
0039 7549 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 7554 026B             byte  2
0044 7555 ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 7558 0352             byte  3
0049 7559 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 755C 054C             byte  5
0054 755D ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 7562 2921             byte  41
0059 7563 ....             text  '! I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 758C 0223             byte  2
0064 758D ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 7590 0A5B             byte  10
0069 7591 ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.prompt
0074 759C 013E             byte  1
0075 759D ....             text  '>'
0076                       even
0077               
0078               txt.cmdb.hint
0079 759E 2348             byte  35
0080 759F ....             text  'Hint: Type "help" for command list.'
0081                       even
0082               
0083               txt.cmdb.catalog
0084 75C2 0C46             byte  12
0085 75C3 ....             text  'File catalog'
0086                       even
0087               
0088               txt.cmdb.title
0089 75D0 0E43             byte  14
0090 75D1 ....             text  'Command buffer'
0091                       even
0092               
0093               
0094               txt.filetype.dv80
0095 75E0 0444             byte  4
0096 75E1 ....             text  'DV80'
0097                       even
0098               
0099               txt.filetype.none
0100 75E6 0420             byte  4
0101 75E7 ....             text  '    '
0102                       even
0103               
0104               
0105 75EC 0C0A     txt.stevie         byte    12
0106                                  byte    10
0107 75EE ....                        text    'stevie v1.00'
0108 75FA 0B00                        byte    11
0109                                  even
0110               
0111               fdname1
0112 75FC 0850             byte  8
0113 75FD ....             text  'PI.CLOCK'
0114                       even
0115               
0116               fdname2
0117 7606 0E54             byte  14
0118 7607 ....             text  'TIPI.TIVI.NR80'
0119                       even
0120               
0121               fdname3
0122 7616 0C44             byte  12
0123 7617 ....             text  'DSK1.XBEADOC'
0124                       even
0125               
0126               fdname4
0127 7624 1154             byte  17
0128 7625 ....             text  'TIPI.TIVI.C99MAN1'
0129                       even
0130               
0131               fdname5
0132 7636 1154             byte  17
0133 7637 ....             text  'TIPI.TIVI.C99MAN2'
0134                       even
0135               
0136               fdname6
0137 7648 1154             byte  17
0138 7649 ....             text  'TIPI.TIVI.C99MAN3'
0139                       even
0140               
0141               fdname7
0142 765A 1254             byte  18
0143 765B ....             text  'TIPI.TIVI.C99SPECS'
0144                       even
0145               
0146               fdname8
0147 766E 1254             byte  18
0148 766F ....             text  'TIPI.TIVI.RANDOM#C'
0149                       even
0150               
0151               fdname9
0152 7682 0D44             byte  13
0153 7683 ....             text  'DSK1.INVADERS'
0154                       even
0155               
0156               fdname0
0157 7690 0944             byte  9
0158 7691 ....             text  'DSK1.NR80'
0159                       even
0160               
0161               fdname.clock
0162 769A 0850             byte  8
0163 769B ....             text  'PI.CLOCK'
0164                       even
0165               
0166               
0167               
0168               *---------------------------------------------------------------
0169               * Keyboard labels - Function keys
0170               *---------------------------------------------------------------
0171               txt.fctn.0
0172 76A4 0866             byte  8
0173 76A5 ....             text  'fctn + 0'
0174                       even
0175               
0176               txt.fctn.1
0177 76AE 0866             byte  8
0178 76AF ....             text  'fctn + 1'
0179                       even
0180               
0181               txt.fctn.2
0182 76B8 0866             byte  8
0183 76B9 ....             text  'fctn + 2'
0184                       even
0185               
0186               txt.fctn.3
0187 76C2 0866             byte  8
0188 76C3 ....             text  'fctn + 3'
0189                       even
0190               
0191               txt.fctn.4
0192 76CC 0866             byte  8
0193 76CD ....             text  'fctn + 4'
0194                       even
0195               
0196               txt.fctn.5
0197 76D6 0866             byte  8
0198 76D7 ....             text  'fctn + 5'
0199                       even
0200               
0201               txt.fctn.6
0202 76E0 0866             byte  8
0203 76E1 ....             text  'fctn + 6'
0204                       even
0205               
0206               txt.fctn.7
0207 76EA 0866             byte  8
0208 76EB ....             text  'fctn + 7'
0209                       even
0210               
0211               txt.fctn.8
0212 76F4 0866             byte  8
0213 76F5 ....             text  'fctn + 8'
0214                       even
0215               
0216               txt.fctn.9
0217 76FE 0866             byte  8
0218 76FF ....             text  'fctn + 9'
0219                       even
0220               
0221               txt.fctn.a
0222 7708 0866             byte  8
0223 7709 ....             text  'fctn + a'
0224                       even
0225               
0226               txt.fctn.b
0227 7712 0866             byte  8
0228 7713 ....             text  'fctn + b'
0229                       even
0230               
0231               txt.fctn.c
0232 771C 0866             byte  8
0233 771D ....             text  'fctn + c'
0234                       even
0235               
0236               txt.fctn.d
0237 7726 0866             byte  8
0238 7727 ....             text  'fctn + d'
0239                       even
0240               
0241               txt.fctn.e
0242 7730 0866             byte  8
0243 7731 ....             text  'fctn + e'
0244                       even
0245               
0246               txt.fctn.f
0247 773A 0866             byte  8
0248 773B ....             text  'fctn + f'
0249                       even
0250               
0251               txt.fctn.g
0252 7744 0866             byte  8
0253 7745 ....             text  'fctn + g'
0254                       even
0255               
0256               txt.fctn.h
0257 774E 0866             byte  8
0258 774F ....             text  'fctn + h'
0259                       even
0260               
0261               txt.fctn.i
0262 7758 0866             byte  8
0263 7759 ....             text  'fctn + i'
0264                       even
0265               
0266               txt.fctn.j
0267 7762 0866             byte  8
0268 7763 ....             text  'fctn + j'
0269                       even
0270               
0271               txt.fctn.k
0272 776C 0866             byte  8
0273 776D ....             text  'fctn + k'
0274                       even
0275               
0276               txt.fctn.l
0277 7776 0866             byte  8
0278 7777 ....             text  'fctn + l'
0279                       even
0280               
0281               txt.fctn.m
0282 7780 0866             byte  8
0283 7781 ....             text  'fctn + m'
0284                       even
0285               
0286               txt.fctn.n
0287 778A 0866             byte  8
0288 778B ....             text  'fctn + n'
0289                       even
0290               
0291               txt.fctn.o
0292 7794 0866             byte  8
0293 7795 ....             text  'fctn + o'
0294                       even
0295               
0296               txt.fctn.p
0297 779E 0866             byte  8
0298 779F ....             text  'fctn + p'
0299                       even
0300               
0301               txt.fctn.q
0302 77A8 0866             byte  8
0303 77A9 ....             text  'fctn + q'
0304                       even
0305               
0306               txt.fctn.r
0307 77B2 0866             byte  8
0308 77B3 ....             text  'fctn + r'
0309                       even
0310               
0311               txt.fctn.s
0312 77BC 0866             byte  8
0313 77BD ....             text  'fctn + s'
0314                       even
0315               
0316               txt.fctn.t
0317 77C6 0866             byte  8
0318 77C7 ....             text  'fctn + t'
0319                       even
0320               
0321               txt.fctn.u
0322 77D0 0866             byte  8
0323 77D1 ....             text  'fctn + u'
0324                       even
0325               
0326               txt.fctn.v
0327 77DA 0866             byte  8
0328 77DB ....             text  'fctn + v'
0329                       even
0330               
0331               txt.fctn.w
0332 77E4 0866             byte  8
0333 77E5 ....             text  'fctn + w'
0334                       even
0335               
0336               txt.fctn.x
0337 77EE 0866             byte  8
0338 77EF ....             text  'fctn + x'
0339                       even
0340               
0341               txt.fctn.y
0342 77F8 0866             byte  8
0343 77F9 ....             text  'fctn + y'
0344                       even
0345               
0346               txt.fctn.z
0347 7802 0866             byte  8
0348 7803 ....             text  'fctn + z'
0349                       even
0350               
0351               *---------------------------------------------------------------
0352               * Keyboard labels - Function keys extra
0353               *---------------------------------------------------------------
0354               txt.fctn.dot
0355 780C 0866             byte  8
0356 780D ....             text  'fctn + .'
0357                       even
0358               
0359               txt.fctn.plus
0360 7816 0866             byte  8
0361 7817 ....             text  'fctn + +'
0362                       even
0363               
0364               *---------------------------------------------------------------
0365               * Keyboard labels - Control keys
0366               *---------------------------------------------------------------
0367               txt.ctrl.0
0368 7820 0863             byte  8
0369 7821 ....             text  'ctrl + 0'
0370                       even
0371               
0372               txt.ctrl.1
0373 782A 0863             byte  8
0374 782B ....             text  'ctrl + 1'
0375                       even
0376               
0377               txt.ctrl.2
0378 7834 0863             byte  8
0379 7835 ....             text  'ctrl + 2'
0380                       even
0381               
0382               txt.ctrl.3
0383 783E 0863             byte  8
0384 783F ....             text  'ctrl + 3'
0385                       even
0386               
0387               txt.ctrl.4
0388 7848 0863             byte  8
0389 7849 ....             text  'ctrl + 4'
0390                       even
0391               
0392               txt.ctrl.5
0393 7852 0863             byte  8
0394 7853 ....             text  'ctrl + 5'
0395                       even
0396               
0397               txt.ctrl.6
0398 785C 0863             byte  8
0399 785D ....             text  'ctrl + 6'
0400                       even
0401               
0402               txt.ctrl.7
0403 7866 0863             byte  8
0404 7867 ....             text  'ctrl + 7'
0405                       even
0406               
0407               txt.ctrl.8
0408 7870 0863             byte  8
0409 7871 ....             text  'ctrl + 8'
0410                       even
0411               
0412               txt.ctrl.9
0413 787A 0863             byte  8
0414 787B ....             text  'ctrl + 9'
0415                       even
0416               
0417               txt.ctrl.a
0418 7884 0863             byte  8
0419 7885 ....             text  'ctrl + a'
0420                       even
0421               
0422               txt.ctrl.b
0423 788E 0863             byte  8
0424 788F ....             text  'ctrl + b'
0425                       even
0426               
0427               txt.ctrl.c
0428 7898 0863             byte  8
0429 7899 ....             text  'ctrl + c'
0430                       even
0431               
0432               txt.ctrl.d
0433 78A2 0863             byte  8
0434 78A3 ....             text  'ctrl + d'
0435                       even
0436               
0437               txt.ctrl.e
0438 78AC 0863             byte  8
0439 78AD ....             text  'ctrl + e'
0440                       even
0441               
0442               txt.ctrl.f
0443 78B6 0863             byte  8
0444 78B7 ....             text  'ctrl + f'
0445                       even
0446               
0447               txt.ctrl.g
0448 78C0 0863             byte  8
0449 78C1 ....             text  'ctrl + g'
0450                       even
0451               
0452               txt.ctrl.h
0453 78CA 0863             byte  8
0454 78CB ....             text  'ctrl + h'
0455                       even
0456               
0457               txt.ctrl.i
0458 78D4 0863             byte  8
0459 78D5 ....             text  'ctrl + i'
0460                       even
0461               
0462               txt.ctrl.j
0463 78DE 0863             byte  8
0464 78DF ....             text  'ctrl + j'
0465                       even
0466               
0467               txt.ctrl.k
0468 78E8 0863             byte  8
0469 78E9 ....             text  'ctrl + k'
0470                       even
0471               
0472               txt.ctrl.l
0473 78F2 0863             byte  8
0474 78F3 ....             text  'ctrl + l'
0475                       even
0476               
0477               txt.ctrl.m
0478 78FC 0863             byte  8
0479 78FD ....             text  'ctrl + m'
0480                       even
0481               
0482               txt.ctrl.n
0483 7906 0863             byte  8
0484 7907 ....             text  'ctrl + n'
0485                       even
0486               
0487               txt.ctrl.o
0488 7910 0863             byte  8
0489 7911 ....             text  'ctrl + o'
0490                       even
0491               
0492               txt.ctrl.p
0493 791A 0863             byte  8
0494 791B ....             text  'ctrl + p'
0495                       even
0496               
0497               txt.ctrl.q
0498 7924 0863             byte  8
0499 7925 ....             text  'ctrl + q'
0500                       even
0501               
0502               txt.ctrl.r
0503 792E 0863             byte  8
0504 792F ....             text  'ctrl + r'
0505                       even
0506               
0507               txt.ctrl.s
0508 7938 0863             byte  8
0509 7939 ....             text  'ctrl + s'
0510                       even
0511               
0512               txt.ctrl.t
0513 7942 0863             byte  8
0514 7943 ....             text  'ctrl + t'
0515                       even
0516               
0517               txt.ctrl.u
0518 794C 0863             byte  8
0519 794D ....             text  'ctrl + u'
0520                       even
0521               
0522               txt.ctrl.v
0523 7956 0863             byte  8
0524 7957 ....             text  'ctrl + v'
0525                       even
0526               
0527               txt.ctrl.w
0528 7960 0863             byte  8
0529 7961 ....             text  'ctrl + w'
0530                       even
0531               
0532               txt.ctrl.x
0533 796A 0863             byte  8
0534 796B ....             text  'ctrl + x'
0535                       even
0536               
0537               txt.ctrl.y
0538 7974 0863             byte  8
0539 7975 ....             text  'ctrl + y'
0540                       even
0541               
0542               txt.ctrl.z
0543 797E 0863             byte  8
0544 797F ....             text  'ctrl + z'
0545                       even
0546               
0547               *---------------------------------------------------------------
0548               * Keyboard labels - control keys extra
0549               *---------------------------------------------------------------
0550               txt.ctrl.plus
0551 7988 0863             byte  8
0552 7989 ....             text  'ctrl + +'
0553                       even
0554               
0555               *---------------------------------------------------------------
0556               * Special keys
0557               *---------------------------------------------------------------
0558               txt.enter
0559 7992 0565             byte  5
0560 7993 ....             text  'enter'
0561                       even
0562               
**** **** ****     > stevie_b1.asm.299124
0070                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0072      0000     key.ctrl.l    equ >0000             ; ctrl + l
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
0105 7998 0D00             data  key.enter, txt.enter, edkey.action.enter
     799A 7992 
     799C 6580 
0106 799E 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     79A0 77BC 
     79A2 617E 
0107 79A4 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     79A6 7726 
     79A8 6194 
0108 79AA 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     79AC 7730 
     79AE 61AC 
0109 79B0 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     79B2 77EE 
     79B4 61FE 
0110 79B6 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     79B8 7884 
     79BA 626A 
0111 79BC 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     79BE 78B6 
     79C0 6282 
0112 79C2 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     79C4 7938 
     79C6 6296 
0113 79C8 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     79CA 78A2 
     79CC 62E8 
0114 79CE 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     79D0 78AC 
     79D2 6348 
0115 79D4 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     79D6 796A 
     79D8 638A 
0116 79DA 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     79DC 7942 
     79DE 63B6 
0117 79E0 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     79E2 788E 
     79E4 63E2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 79E6 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     79E8 76AE 
     79EA 6422 
0122 79EC 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     79EE 78E8 
     79F0 645A 
0123 79F2 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     79F4 76C2 
     79F6 648E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 79F8 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     79FA 76B8 
     79FC 64E6 
0128 79FE B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7A00 780C 
     7A02 65EE 
0129 7A04 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7A06 76D6 
     7A08 653C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 7A0A 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7A0C 7816 
     7A0E 663E 
0134 7A10 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7A12 76FE 
     7A14 6708 
0135 7A16 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7A18 797E 
     7A1A 7222 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 7A1C B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7A1E 7820 
     7A20 6654 
0140 7A22 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7A24 782A 
     7A26 665A 
0141 7A28 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7A2A 7834 
     7A2C 6660 
0142 7A2E B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7A30 783E 
     7A32 6666 
0143 7A34 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7A36 7848 
     7A38 666C 
0144 7A3A B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7A3C 7852 
     7A3E 6672 
0145 7A40 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7A42 785C 
     7A44 6678 
0146 7A46 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7A48 7866 
     7A4A 667E 
0147 7A4C 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7A4E 7870 
     7A50 6684 
0148 7A52 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7A54 787A 
     7A56 668A 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 7A58 FFFF             data  EOL                           ; EOL
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
0164 7A5A 0D00             data  key.enter, txt.enter, edkey.action.enter
     7A5C 7992 
     7A5E 6580 
0165 7A60 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7A62 77BC 
     7A64 617E 
0166 7A66 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7A68 7726 
     7A6A 6194 
0167                       ;-------------------------------------------------------
0168                       ; Other action keys
0169                       ;-------------------------------------------------------
0170 7A6C 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7A6E 7816 
     7A70 663E 
0171 7A72 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7A74 76FE 
     7A76 6708 
0172 7A78 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7A7A 797E 
     7A7C 7222 
0173                       ;-------------------------------------------------------
0174                       ; End of list
0175                       ;-------------------------------------------------------
0176 7A7E FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.299124
0071               
0075 7A80 7A80                   data $                ; Bank 1 ROM size OK.
0077               
0078               *--------------------------------------------------------------
0079               * Video mode configuration
0080               *--------------------------------------------------------------
0081      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0082      0004     spfbck  equ   >04                   ; Screen background color.
0083      746E     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0084      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0085      0050     colrow  equ   80                    ; Columns per row
0086      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0087      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0088      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0089      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

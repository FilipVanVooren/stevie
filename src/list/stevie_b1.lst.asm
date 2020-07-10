XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.149718
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200710-149718
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
0009               * File: equates.asm                 ; Version 200710-149718
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
0142      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-4)
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
0201      A312     cmdb.column       equ  cmdb.struct + 18; Current column in CMDB
0202      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0203      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0204      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0205      A31A     cmdb.pantitle     equ  cmdb.struct + 26; Pointer to string with pane title
0206      A31C     cmdb.panhint      equ  cmdb.struct + 28; Pointer to string with pane hint
0207      A31E     cmdb.cmdlen       equ  cmdb.struct + 30; Length of current command (byte!)
0208      A31F     cmdb.cmd          equ  cmdb.struct + 31; Current comand (80 bytes max.)
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
0230      A444     fh.free           equ  fh.struct + 68  ; no longer used
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
0263               * *** FREE ***                      @>f000-ffff    (4096 bytes)
0264               *--------------------------------------------------------------
**** **** ****     > stevie_b1.asm.149718
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
0031 6015 ....             text  'STEVIE 200710-149718'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.149718
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
     208E 2D38 
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
     20B2 2966 
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
     20C6 2966 
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
     2116 2970 
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
     2142 2970 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 28E2 
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
     2180 2C46 
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
0260 21DB ....             text  'Build-ID  200710-149718'
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
0016 278A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     278C 202A 
0017 278E 020C  20         li    r12,>0024
     2790 0024 
0018 2792 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     2794 2822 
0019 2796 04C6  14         clr   tmp2
0020 2798 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 279A 04CC  14         clr   r12
0025 279C 1F08  20         tb    >0008                 ; Shift-key ?
0026 279E 1302  14         jeq   realk1                ; No
0027 27A0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27A2 2852 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27A4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27A6 1302  14         jeq   realk2                ; No
0033 27A8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27AA 2882 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27AC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27AE 1302  14         jeq   realk3                ; No
0039 27B0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27B2 28B2 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27B4 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27B6 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27B8 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27BA E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27BC 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27BE 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27C0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27C2 0006 
0052 27C4 0606  14 realk5  dec   tmp2
0053 27C6 020C  20         li    r12,>24               ; CRU address for P2-P4
     27C8 0024 
0054 27CA 06C6  14         swpb  tmp2
0055 27CC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27CE 06C6  14         swpb  tmp2
0057 27D0 020C  20         li    r12,6                 ; CRU read address
     27D2 0006 
0058 27D4 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 27D6 0547  14         inv   tmp3                  ;
0060 27D8 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     27DA FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 27DC 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 27DE 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 27E0 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 27E2 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 27E4 0285  22         ci    tmp1,8
     27E6 0008 
0069 27E8 1AFA  14         jl    realk6
0070 27EA C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 27EC 1BEB  14         jh    realk5                ; No, next column
0072 27EE 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 27F0 C206  18 realk8  mov   tmp2,tmp4
0077 27F2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 27F4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 27F6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 27F8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 27FA 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 27FC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 27FE 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2800 202A 
0087 2802 1608  14         jne   realka                ; No, continue saving key
0088 2804 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2806 284C 
0089 2808 1A05  14         jl    realka
0090 280A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     280C 284A 
0091 280E 1B02  14         jh    realka                ; No, continue
0092 2810 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2812 E000 
0093 2814 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2816 833C 
0094 2818 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     281A 2014 
0095 281C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     281E 8C00 
0096 2820 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2822 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2824 0000 
     2826 FF0D 
     2828 203D 
0099 282A ....             text  'xws29ol.'
0100 2832 ....             text  'ced38ik,'
0101 283A ....             text  'vrf47ujm'
0102 2842 ....             text  'btg56yhn'
0103 284A ....             text  'zqa10p;/'
0104 2852 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2854 0000 
     2856 FF0D 
     2858 202B 
0105 285A ....             text  'XWS@(OL>'
0106 2862 ....             text  'CED#*IK<'
0107 286A ....             text  'VRF$&UJM'
0108 2872 ....             text  'BTG%^YHN'
0109 287A ....             text  'ZQA!)P:-'
0110 2882 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     2884 0000 
     2886 FF0D 
     2888 2005 
0111 288A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     288C 0804 
     288E 0F27 
     2890 C2B9 
0112 2892 600B             data  >600b,>0907,>063f,>c1B8
     2894 0907 
     2896 063F 
     2898 C1B8 
0113 289A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     289C 7B02 
     289E 015F 
     28A0 C0C3 
0114 28A2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28A4 7D0E 
     28A6 0CC6 
     28A8 BFC4 
0115 28AA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28AC 7C03 
     28AE BC22 
     28B0 BDBA 
0116 28B2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28B4 0000 
     28B6 FF0D 
     28B8 209D 
0117 28BA 9897             data  >9897,>93b2,>9f8f,>8c9B
     28BC 93B2 
     28BE 9F8F 
     28C0 8C9B 
0118 28C2 8385             data  >8385,>84b3,>9e89,>8b80
     28C4 84B3 
     28C6 9E89 
     28C8 8B80 
0119 28CA 9692             data  >9692,>86b4,>b795,>8a8D
     28CC 86B4 
     28CE B795 
     28D0 8A8D 
0120 28D2 8294             data  >8294,>87b5,>b698,>888E
     28D4 87B5 
     28D6 B698 
     28D8 888E 
0121 28DA 9A91             data  >9a91,>81b1,>b090,>9cBB
     28DC 81B1 
     28DE B090 
     28E0 9CBB 
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
0023 28E2 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 28E4 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     28E6 8340 
0025 28E8 04E0  34         clr   @waux1
     28EA 833C 
0026 28EC 04E0  34         clr   @waux2
     28EE 833E 
0027 28F0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     28F2 833C 
0028 28F4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 28F6 0205  20         li    tmp1,4                ; 4 nibbles
     28F8 0004 
0033 28FA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 28FC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     28FE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2900 0286  22         ci    tmp2,>000a
     2902 000A 
0039 2904 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2906 C21B  26         mov   *r11,tmp4
0045 2908 0988  56         srl   tmp4,8                ; Right justify
0046 290A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     290C FFF6 
0047 290E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2910 C21B  26         mov   *r11,tmp4
0054 2912 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2914 00FF 
0055               
0056 2916 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2918 06C6  14         swpb  tmp2
0058 291A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 291C 0944  56         srl   tmp0,4                ; Next nibble
0060 291E 0605  14         dec   tmp1
0061 2920 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2922 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2924 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2926 C160  34         mov   @waux3,tmp1           ; Get pointer
     2928 8340 
0067 292A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 292C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 292E C120  34         mov   @waux2,tmp0
     2930 833E 
0070 2932 06C4  14         swpb  tmp0
0071 2934 DD44  32         movb  tmp0,*tmp1+
0072 2936 06C4  14         swpb  tmp0
0073 2938 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 293A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     293C 8340 
0078 293E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2940 2020 
0079 2942 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2944 C120  34         mov   @waux1,tmp0
     2946 833C 
0084 2948 06C4  14         swpb  tmp0
0085 294A DD44  32         movb  tmp0,*tmp1+
0086 294C 06C4  14         swpb  tmp0
0087 294E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2950 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2952 202A 
0092 2954 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2956 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2958 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     295A 7FFF 
0098 295C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     295E 8340 
0099 2960 0460  28         b     @xutst0               ; Display string
     2962 241A 
0100 2964 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2966 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2968 832A 
0122 296A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     296C 8000 
0123 296E 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 2970 0207  20 mknum   li    tmp3,5                ; Digit counter
     2972 0005 
0020 2974 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 2976 C155  26         mov   *tmp1,tmp1            ; /
0022 2978 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 297A 0228  22         ai    tmp4,4                ; Get end of buffer
     297C 0004 
0024 297E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     2980 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 2982 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 2984 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 2986 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 2988 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 298A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 298C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 298E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 2990 0607  14         dec   tmp3                  ; Decrease counter
0036 2992 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 2994 0207  20         li    tmp3,4                ; Check first 4 digits
     2996 0004 
0041 2998 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 299A C11B  26         mov   *r11,tmp0
0043 299C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 299E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29A0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29A2 05CB  14 mknum3  inct  r11
0047 29A4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29A6 202A 
0048 29A8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29AA 045B  20         b     *r11                  ; Exit
0050 29AC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29AE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29B0 13F8  14         jeq   mknum3                ; Yes, exit
0053 29B2 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29B4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29B6 7FFF 
0058 29B8 C10B  18         mov   r11,tmp0
0059 29BA 0224  22         ai    tmp0,-4
     29BC FFFC 
0060 29BE C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29C0 0206  20         li    tmp2,>0500            ; String length = 5
     29C2 0500 
0062 29C4 0460  28         b     @xutstr               ; Display string
     29C6 241C 
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
0092 29C8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29CA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29CC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29CE 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 29D0 0207  20         li    tmp3,5                ; Set counter
     29D2 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 29D4 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 29D6 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 29D8 0584  14         inc   tmp0                  ; Next character
0104 29DA 0607  14         dec   tmp3                  ; Last digit reached ?
0105 29DC 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 29DE 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 29E0 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 29E2 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 29E4 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 29E6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 29E8 0607  14         dec   tmp3                  ; Last character ?
0120 29EA 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 29EC 045B  20         b     *r11                  ; Return
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
0138 29EE C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     29F0 832A 
0139 29F2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29F4 8000 
0140 29F6 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 29F8 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     29FA 3E00 
0023 29FC C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     29FE 3E02 
0024 2A00 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A02 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A04 0200  20         li    r0,>8306              ; Scratpad source address
     2A06 8306 
0029 2A08 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A0A 3E06 
0030 2A0C 0202  20         li    r2,62                 ; Loop counter
     2A0E 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A10 CC70  46         mov   *r0+,*r1+
0036 2A12 CC70  46         mov   *r0+,*r1+
0037 2A14 0642  14         dect  r2
0038 2A16 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A18 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A1A 83FE 
     2A1C 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A1E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A20 3E00 
0045 2A22 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A24 3E02 
0046 2A26 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A28 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A2A 045B  20         b     *r11                  ; Return to caller
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
0070 2A2C C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A2E 3E00 
     2A30 8300 
0071 2A32 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A34 3E02 
     2A36 8302 
0072 2A38 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A3A 3E04 
     2A3C 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A3E C800  38         mov   r0,@cpu.scrpad.tgt
     2A40 3E00 
0077 2A42 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A44 3E02 
0078 2A46 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A48 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A4A 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A4C 3E06 
0083 2A4E 0201  20         li    r1,>8306
     2A50 8306 
0084 2A52 0202  20         li    r2,62
     2A54 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A56 CC70  46         mov   *r0+,*r1+
0090 2A58 CC70  46         mov   *r0+,*r1+
0091 2A5A 0642  14         dect  r2
0092 2A5C 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A5E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A60 3EFE 
     2A62 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A64 C020  34         mov   @cpu.scrpad.tgt,r0
     2A66 3E00 
0099 2A68 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A6A 3E02 
0100 2A6C C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2A6E 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2A70 045B  20         b     *r11                  ; Return to caller
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
0025 2A72 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2A74 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2A76 8300 
0031 2A78 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2A7A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2A7C 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2A7E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2A80 0606  14         dec   tmp2
0038 2A82 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2A84 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2A86 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2A88 2A8E 
0044                                                   ; R14=PC
0045 2A8A 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2A8C 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2A8E 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2A90 2A2C 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2A92 045B  20         b     *r11                  ; Return to caller
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
0078 2A94 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2A96 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2A98 8300 
0084 2A9A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2A9C 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2A9E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2AA0 0606  14         dec   tmp2
0090 2AA2 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AA4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AA6 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2AA8 045B  20         b     *r11                  ; Return to caller
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
0041 2AAA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2AAC 2AAE             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2AAE C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2AB0 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2AB2 8322 
0049 2AB4 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2AB6 2026 
0050 2AB8 C020  34         mov   @>8356,r0             ; get ptr to pab
     2ABA 8356 
0051 2ABC C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2ABE 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AC0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AC2 06C0  14         swpb  r0                    ;
0059 2AC4 D800  38         movb  r0,@vdpa              ; send low byte
     2AC6 8C02 
0060 2AC8 06C0  14         swpb  r0                    ;
0061 2ACA D800  38         movb  r0,@vdpa              ; send high byte
     2ACC 8C02 
0062 2ACE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2AD0 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2AD2 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2AD4 0704  14         seto  r4                    ; init counter
0070 2AD6 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2AD8 A420 
0071 2ADA 0580  14 !       inc   r0                    ; point to next char of name
0072 2ADC 0584  14         inc   r4                    ; incr char counter
0073 2ADE 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2AE0 0007 
0074 2AE2 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2AE4 80C4  18         c     r4,r3                 ; end of name?
0077 2AE6 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2AE8 06C0  14         swpb  r0                    ;
0082 2AEA D800  38         movb  r0,@vdpa              ; send low byte
     2AEC 8C02 
0083 2AEE 06C0  14         swpb  r0                    ;
0084 2AF0 D800  38         movb  r0,@vdpa              ; send high byte
     2AF2 8C02 
0085 2AF4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2AF6 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2AF8 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2AFA 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2AFC 2BBE 
0093 2AFE 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B00 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B02 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B04 04E0  34         clr   @>83d0
     2B06 83D0 
0102 2B08 C804  38         mov   r4,@>8354             ; save name length for search
     2B0A 8354 
0103 2B0C 0584  14         inc   r4                    ; adjust for dot
0104 2B0E A804  38         a     r4,@>8356             ; point to position after name
     2B10 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B12 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B14 83E0 
0110 2B16 04C1  14         clr   r1                    ; version found of dsr
0111 2B18 020C  20         li    r12,>0f00             ; init cru addr
     2B1A 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B1C C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B1E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B20 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B22 022C  22         ai    r12,>0100             ; next rom to turn on
     2B24 0100 
0125 2B26 04E0  34         clr   @>83d0                ; clear in case we are done
     2B28 83D0 
0126 2B2A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B2C 2000 
0127 2B2E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B30 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B32 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B34 1D00  20         sbo   0                     ; turn on rom
0134 2B36 0202  20         li    r2,>4000              ; start at beginning of rom
     2B38 4000 
0135 2B3A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B3C 2BBA 
0136 2B3E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B40 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B42 A40A 
0146 2B44 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B46 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B48 83D2 
0152                                                   ; subprogram
0153               
0154 2B4A 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B4C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B4E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B50 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B52 83D2 
0163                                                   ; subprogram
0164               
0165 2B54 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B56 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B58 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B5A D160  34         movb  @>8355,r5             ; get length as counter
     2B5C 8355 
0175 2B5E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B60 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B62 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B64 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B66 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B68 A420 
0186 2B6A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B6C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2B6E 0605  14         dec   r5                    ; loop until full length checked
0191 2B70 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2B72 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2B74 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2B76 0581  14         inc   r1                    ; next version found
0203 2B78 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2B7A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2B7C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2B7E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2B80 A400 
0212 2B82 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2B84 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2B86 8322 
0214                                                   ; (8 or >a)
0215 2B88 0281  22         ci    r1,8                  ; was it 8?
     2B8A 0008 
0216 2B8C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2B8E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2B90 8350 
0218                                                   ; Get error byte from @>8350
0219 2B92 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2B94 06C0  14         swpb  r0                    ;
0227 2B96 D800  38         movb  r0,@vdpa              ; send low byte
     2B98 8C02 
0228 2B9A 06C0  14         swpb  r0                    ;
0229 2B9C D800  38         movb  r0,@vdpa              ; send high byte
     2B9E 8C02 
0230 2BA0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BA2 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BA4 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BA6 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BA8 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BAA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BAC A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BAE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2BB0 06C1  14         swpb  r1                    ; put error in hi byte
0252 2BB2 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2BB4 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2BB6 2026 
0254 2BB8 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2BBA AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2BBC 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2BBE ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 2BC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BC2 C04B  18         mov   r11,r1                ; Save return address
0049 2BC4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BC6 A428 
0050 2BC8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BCA 04C5  14         clr   tmp1                  ; io.op.open
0052 2BCC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BCE 22C6 
0053               file.open_init:
0054 2BD0 0220  22         ai    r0,9                  ; Move to file descriptor length
     2BD2 0009 
0055 2BD4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2BD6 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2BD8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2BDA 2AAA 
0061 2BDC 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2BDE 1029  14         jmp   file.record.pab.details
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
0090 2BE0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2BE2 C04B  18         mov   r11,r1                ; Save return address
0096 2BE4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BE6 A428 
0097 2BE8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2BEA 0205  20         li    tmp1,io.op.close      ; io.op.close
     2BEC 0001 
0099 2BEE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BF0 22C6 
0100               file.close_init:
0101 2BF2 0220  22         ai    r0,9                  ; Move to file descriptor length
     2BF4 0009 
0102 2BF6 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2BF8 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2BFA 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2BFC 2AAA 
0108 2BFE 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C00 1018  14         jmp   file.record.pab.details
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
0139 2C02 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C04 C04B  18         mov   r11,r1                ; Save return address
0145 2C06 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C08 A428 
0146 2C0A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C0C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C0E 0002 
0148 2C10 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C12 22C6 
0149               file.record.read_init:
0150 2C14 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C16 0009 
0151 2C18 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C1A 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C1C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C1E 2AAA 
0157 2C20 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C22 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C24 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C26 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C28 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C2A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C2C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C2E 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C30 1000  14         nop
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
0211 2C32 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C34 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C36 A428 
0219 2C38 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C3A 0005 
0220 2C3C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C3E 22DE 
0221 2C40 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C42 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0246 2C44 0451  20         b     *r1                   ; Return to caller
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
0020 2C46 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C48 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C4A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C4C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C4E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C50 2026 
0029 2C52 1602  14         jne   tmgr1a                ; No, so move on
0030 2C54 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C56 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C58 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C5A 202A 
0035 2C5C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C5E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C60 201A 
0048 2C62 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C64 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C66 2018 
0050 2C68 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C6A 0460  28         b     @kthread              ; Run kernel thread
     2C6C 2CE4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2C6E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2C70 201E 
0056 2C72 13EB  14         jeq   tmgr1
0057 2C74 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2C76 201C 
0058 2C78 16E8  14         jne   tmgr1
0059 2C7A C120  34         mov   @wtiusr,tmp0
     2C7C 832E 
0060 2C7E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2C80 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2C82 2CE2 
0065 2C84 C10A  18         mov   r10,tmp0
0066 2C86 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2C88 00FF 
0067 2C8A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2C8C 2026 
0068 2C8E 1303  14         jeq   tmgr5
0069 2C90 0284  22         ci    tmp0,60               ; 1 second reached ?
     2C92 003C 
0070 2C94 1002  14         jmp   tmgr6
0071 2C96 0284  22 tmgr5   ci    tmp0,50
     2C98 0032 
0072 2C9A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2C9C 1001  14         jmp   tmgr8
0074 2C9E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CA0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CA2 832C 
0079 2CA4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CA6 FF00 
0080 2CA8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CAA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CAC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CAE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CB0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CB2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CB4 830C 
     2CB6 830D 
0089 2CB8 1608  14         jne   tmgr10                ; No, get next slot
0090 2CBA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CBC FF00 
0091 2CBE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CC0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CC2 8330 
0096 2CC4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CC6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CC8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CCA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CCC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2CCE 8315 
     2CD0 8314 
0103 2CD2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2CD4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2CD6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2CD8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2CDA 10F7  14         jmp   tmgr10                ; Process next slot
0108 2CDC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2CDE FF00 
0109 2CE0 10B4  14         jmp   tmgr1
0110 2CE2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2CE4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2CE6 201A 
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
0041 2CE8 06A0  32         bl    @realkb               ; Scan full keyboard
     2CEA 278A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2CEC 0460  28         b     @tmgr3                ; Exit
     2CEE 2C6E 
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
0017 2CF0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2CF2 832E 
0018 2CF4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2CF6 201C 
0019 2CF8 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C4A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2CFA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2CFC 832E 
0029 2CFE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D00 FEFF 
0030 2D02 045B  20         b     *r11                  ; Return
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
0017 2D04 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D06 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D08 C184  18         mov   tmp0,tmp2
0023 2D0A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D0C A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D0E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D10 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D12 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D14 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D16 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D18 202C 
0035 2D1A 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D1C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D1E 05CB  14 mkslo1  inct  r11
0041 2D20 045B  20         b     *r11                  ; Exit
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
0052 2D22 C13B  30 clslot  mov   *r11+,tmp0
0053 2D24 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D26 A120  34         a     @wtitab,tmp0          ; Add table base
     2D28 832C 
0055 2D2A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D2C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D2E 045B  20         b     *r11                  ; Exit
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
0250 2D30 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D32 29F8 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D34 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D36 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D38 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D3A 0000 
0261 2D3C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D3E 8300 
0262 2D40 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D42 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D44 0202  20 runli2  li    r2,>8308
     2D46 8308 
0267 2D48 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D4A 0282  22         ci    r2,>8400
     2D4C 8400 
0269 2D4E 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D50 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D52 FFFF 
0274 2D54 1602  14         jne   runli4                ; No, continue
0275 2D56 0420  54         blwp  @0                    ; Yes, bye bye
     2D58 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D5A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D5C 833C 
0280 2D5E 04C1  14         clr   r1                    ; Reset counter
0281 2D60 0202  20         li    r2,10                 ; We test 10 times
     2D62 000A 
0282 2D64 C0E0  34 runli5  mov   @vdps,r3
     2D66 8802 
0283 2D68 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D6A 202A 
0284 2D6C 1302  14         jeq   runli6
0285 2D6E 0581  14         inc   r1                    ; Increase counter
0286 2D70 10F9  14         jmp   runli5
0287 2D72 0602  14 runli6  dec   r2                    ; Next test
0288 2D74 16F7  14         jne   runli5
0289 2D76 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2D78 1250 
0290 2D7A 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2D7C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2D7E 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2D80 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2D82 221A 
0296 2D84 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2D86 8322 
0297 2D88 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2D8A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2D8C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2D8E 04C1  14 runli9  clr   r1
0304 2D90 04C2  14         clr   r2
0305 2D92 04C3  14         clr   r3
0306 2D94 0209  20         li    stack,>8400           ; Set stack
     2D96 8400 
0307 2D98 020F  20         li    r15,vdpw              ; Set VDP write address
     2D9A 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2D9C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2D9E 4A4A 
0316 2DA0 1605  14         jne   runlia
0317 2DA2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DA4 2288 
0318 2DA6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DA8 0000 
     2DAA 3FFF 
0323 2DAC 06A0  32 runlia  bl    @filv
     2DAE 2288 
0324 2DB0 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DB2 00F4 
     2DB4 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2DB6 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DB8 26D2 
0332 2DBA 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DBC 26EC 
0333 2DBE 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DC0 26E2 
0334               
0335 2DC2 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2DC4 232C 
0336 2DC6 3201                   data >3201            ; F18a VR50 (>32), bit 1
0338               *--------------------------------------------------------------
0339               * Check if there is a speech synthesizer attached
0340               *--------------------------------------------------------------
0342               *       <<skipped>>
0346               *--------------------------------------------------------------
0347               * Load video mode table & font
0348               *--------------------------------------------------------------
0349 2DC8 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DCA 22F2 
0350 2DCC 761A             data  spvmod                ; Equate selected video mode table
0351 2DCE 0204  20         li    tmp0,spfont           ; Get font option
     2DD0 000C 
0352 2DD2 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0353 2DD4 1304  14         jeq   runlid                ; Yes, skip it
0354 2DD6 06A0  32         bl    @ldfnt
     2DD8 235A 
0355 2DDA 1100             data  fntadr,spfont         ; Load specified font
     2DDC 000C 
0356               *--------------------------------------------------------------
0357               * Did a system crash occur before runlib was called?
0358               *--------------------------------------------------------------
0359 2DDE 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2DE0 4A4A 
0360 2DE2 1602  14         jne   runlie                ; No, continue
0361 2DE4 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2DE6 2090 
0362               *--------------------------------------------------------------
0363               * Branch to main program
0364               *--------------------------------------------------------------
0365 2DE8 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2DEA 0040 
0366 2DEC 0460  28         b     @main                 ; Give control to main program
     2DEE 6050 
**** **** ****     > stevie_b1.asm.149718
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
     6064 262E 
0042               
0043 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26D2 
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
     6092 674A 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6094 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6096 264E 
0070 6098 06A0  32         bl    @s8x8                 ; Small sprite
     609A 265E 
0071               
0072 609C 06A0  32         bl    @cpym2m
     609E 247A 
0073 60A0 7624                   data romsat,ramsat,4  ; Load sprite SAT
     60A2 8380 
     60A4 0004 
0074               
0075 60A6 C820  54         mov   @romsat+2,@tv.curshape
     60A8 7626 
     60AA A014 
0076                                                   ; Save cursor shape & color
0077               
0078 60AC 06A0  32         bl    @cpym2v
     60AE 2432 
0079 60B0 2800                   data sprpdt,cursors,3*8
     60B2 7628 
     60B4 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 60B6 06A0  32         bl    @cpym2v
     60B8 2432 
0083 60BA 1008                   data >1008,patterns,11*8
     60BC 7640 
     60BE 0058 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60C0 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60C2 671C 
0089 60C4 06A0  32         bl    @tv.reset             ; Reset editor
     60C6 672E 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60C8 06A0  32         bl    @pane.action.colorscheme.Load
     60CA 72C0 
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
     60D6 266E 
0102 60D8 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0105 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0106               
0107 60E2 06A0  32         bl    @mkslot
     60E4 2D04 
0108 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 7178 
0109 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 7210 
0110 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 7244 
0111 60F2 FFFF                   data eol
0112               
0113 60F4 06A0  32         bl    @mkhook
     60F6 2CF0 
0114 60F8 7148                   data hook.keyscan     ; Setup user hook
0115               
0116 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2C46 
**** **** ****     > stevie_b1.asm.149718
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
     6122 7BDE 
0033 6124 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 7CA0 
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
     6154 66D2 
0077                                                   ; Add character to CMDB buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6158 FFCE 
0083 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     615C 2030 
**** **** ****     > stevie_b1.asm.149718
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
     6172 716C 
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
     618A 716C 
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
     6196 6B98 
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
     61B0 6818 
0068 61B2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61B4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61B6 A106 
0074 61B8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61BA 267C 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61BC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61BE 6D30 
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
     61D4 2686 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D8 67FC 
0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61DC 716C 
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
     61F0 6B98 
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
     621C 6818 
0135 621E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6220 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6222 A106 
0141 6224 06A0  32         bl    @down                 ; Row++ VDP cursor
     6226 2674 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6228 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     622A 6D30 
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
     6240 2686 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6244 67FC 
0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6248 716C 
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
     625C 67FC 
0175 625E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6260 716C 
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
     626C 2686 
0184 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6270 67FC 
0185 6272 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6274 716C 
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
     62BE 2686 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62C2 67FC 
0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62C6 716C 
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
     631E 2686 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6320 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6322 67FC 
0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6326 716C 
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
     634A 6B98 
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
     6358 6818 
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
     6388 6B98 
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
     6394 716C 
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
     63A0 6B98 
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
     63B0 6818 
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
     63C0 716C 
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
     63CC 6B98 
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
     63EC 6818 
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
     6400 716C 
**** **** ****     > stevie_b1.asm.149718
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
     6408 67FC 
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
     6438 716C 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 643A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     643C A206 
0055 643E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6440 67FC 
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
     646C 716C 
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
     6482 67FC 
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
     649C 6A80 
0109 649E 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64A0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64A2 C820  54         mov   @fb.topline,@parm1
     64A4 A104 
     64A6 8350 
0114 64A8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64AA 6818 
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
     64D4 67FC 
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
     651A 716C 
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
     652A 6B98 
0213 652C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     652E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6530 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6532 67FC 
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
     6548 6B0A 
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
     6556 6818 
0233 6558 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     655A A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 655C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     655E 716C 
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
     656E 6B98 
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
     65A2 6818 
0284 65A4 1004  14         jmp   edkey.action.newline.rest
0285                       ;-------------------------------------------------------
0286                       ; Move cursor down a row, there are still rows left
0287                       ;-------------------------------------------------------
0288               edkey.action.newline.down:
0289 65A6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65A8 A106 
0290 65AA 06A0  32         bl    @down                 ; Row++ VDP cursor
     65AC 2674 
0291                       ;-------------------------------------------------------
0292                       ; Set VDP cursor and save variables
0293                       ;-------------------------------------------------------
0294               edkey.action.newline.rest:
0295 65AE 06A0  32         bl    @fb.get.firstnonblank
     65B0 6888 
0296 65B2 C120  34         mov   @outparm1,tmp0
     65B4 8360 
0297 65B6 C804  38         mov   tmp0,@fb.column
     65B8 A10C 
0298 65BA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65BC 2686 
0299 65BE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65C0 6D30 
0300 65C2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C4 67FC 
0301 65C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65C8 A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65CC 716C 
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
     65DC 7244 
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
     65F2 67FC 
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
     661C 716C 
**** **** ****     > stevie_b1.asm.149718
0045                       copy  "edkey.fb.misc.asm"   ; fb pane   - Actions for miscelanneous keys
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
     6620 2736 
0010 6622 0420  54         blwp  @0                    ; Exit
     6624 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6626 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6628 716C 
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
**** **** ****     > stevie_b1.asm.149718
0046                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6634 0204  20         li   tmp0,fdname0
     6636 78D6 
0007 6638 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 663A 0204  20         li   tmp0,fdname1
     663C 7842 
0010 663E 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6640 0204  20         li   tmp0,fdname2
     6642 784C 
0013 6644 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 6646 0204  20         li   tmp0,fdname3
     6648 785C 
0016 664A 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 664C 0204  20         li   tmp0,fdname4
     664E 786A 
0019 6650 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6652 0204  20         li   tmp0,fdname5
     6654 787C 
0022 6656 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 6658 0204  20         li   tmp0,fdname6
     665A 788E 
0025 665C 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 665E 0204  20         li   tmp0,fdname7
     6660 78A0 
0028 6662 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6664 0204  20         li   tmp0,fdname8
     6666 78B4 
0031 6668 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 666A 0204  20         li   tmp0,fdname9
     666C 78C8 
0034 666E 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 6670 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6672 7010 
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
     667A 778C 
0047 667C C804  38         mov  tmp0,@cmdb.pantitle
     667E A31A 
0048 6680 0204  20         li   tmp0,txt.cmdb.hintdv80
     6682 779C 
0049 6684 C804  38         mov  tmp0,@cmdb.panhint
     6686 A31C 
0050 6688 0460  28         b    @edkey.action.cmdb.show
     668A 670A 
**** **** ****     > stevie_b1.asm.149718
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
     669C 716C 
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
     66B0 716C 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 66B2 0204  20         li    tmp0,1
     66B4 0001 
0045 66B6 C804  38         mov   tmp0,@cmdb.column      ; First column
     66B8 A312 
0046               
0047 66BA D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     66BC A30A 
0048 66BE C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     66C0 A30A 
0049               
0050 66C2 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66C4 716C 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 66C6 C120  34         mov   @fb.row.length,tmp0
     66C8 A108 
0057 66CA C804  38         mov   tmp0,@fb.column
     66CC A10C 
0058 66CE 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66D0 716C 
**** **** ****     > stevie_b1.asm.149718
0048                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Process character
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.char:
0009 66D2 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66D4 A318 
0010               
0011 66D6 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     66D8 A31F 
0012 66DA A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     66DC A312 
0013 66DE D505  30         movb  tmp1,*tmp0            ; Add character
0014 66E0 0205  20         li    tmp1,>0100
     66E2 0100 
0015 66E4 B805  38         ab    tmp1,@cmdb.cmdlen     ; Adjust command length
     66E6 A31E 
0016 66E8 05A0  34         inc   @cmdb.column          ; Next column
     66EA A312 
0017 66EC 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     66EE A30A 
0018                       ;-------------------------------------------------------
0019                       ; Exit
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.char.exit:
0022 66F0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66F2 716C 
0023               
0024               
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Enter
0029               *---------------------------------------------------------------
0030               edkey.action.cmdb.enter:
0031                       ;-------------------------------------------------------
0032                       ; Load file
0033                       ;-------------------------------------------------------
0034 66F4 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     66F6 74AA 
0035 66F8 0204  20         li    tmp0,cmdb.cmdlen      ; Length-prefixed command string
     66FA A31E 
0036 66FC 06A0  32         bl    @fm.loadfile
     66FE 7010 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.enter.exit:
0041 6700 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6702 6396 
**** **** ****     > stevie_b1.asm.149718
0049                       copy  "edkey.cmdb.misc.asm" ; cmdb pane - Actions for miscelanneous keys
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 6704 C120  34         mov   @cmdb.visible,tmp0
     6706 A302 
0010 6708 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 670A 04E0  34         clr   @cmdb.column          ; Column = 0
     670C A312 
0016 670E 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6710 745A 
0017 6712 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6714 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6716 74AA 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 6718 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     671A 716C 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.149718
0050                       ;-----------------------------------------------------------------------
0051                       ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
0052                       ;-----------------------------------------------------------------------
0053                       copy  "tv.asm"              ; Main editor configuration
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
0027 671C 0649  14         dect  stack
0028 671E C64B  30         mov   r11,*stack            ; Save return address
0029 6720 0649  14         dect  stack
0030 6722 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6724 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     6726 A012 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               tv.init.exit:
0039 6728 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 672A C2F9  30         mov   *stack+,r11           ; Pop R11
0041 672C 045B  20         b     *r11                  ; Return to caller
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
0063 672E 0649  14         dect  stack
0064 6730 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Reset editor
0067                       ;------------------------------------------------------
0068 6732 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6734 6D4E 
0069 6736 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6738 6B62 
0070 673A 06A0  32         bl    @idx.init             ; Initialize index
     673C 68D0 
0071 673E 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6740 67A6 
0072 6742 06A0  32         bl    @errline.init         ; Initialize error line
     6744 6E04 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               tv.reset.exit:
0077 6746 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 6748 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0054                       copy  "mem.asm"             ; Memory Management
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
0021 674A 0649  14         dect  stack
0022 674C C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 674E 06A0  32         bl    @sams.layout
     6750 2582 
0027 6752 7698                   data mem.sams.layout.data
0028               
0029 6754 06A0  32         bl    @sams.layout.copy
     6756 25E6 
0030 6758 A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 675A C820  54         mov   @tv.sams.c000,@edb.sams.page
     675C A008 
     675E A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 6760 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 6762 045B  20         b     *r11                  ; Return to caller
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
0064 6764 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 6766 0649  14         dect  stack
0067 6768 C64B  30         mov   r11,*stack            ; Push return address
0068 676A 0649  14         dect  stack
0069 676C C644  30         mov   tmp0,*stack           ; Push tmp0
0070 676E 0649  14         dect  stack
0071 6770 C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 6772 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6774 A204 
0076 6776 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 6778 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     677A FFCE 
0082 677C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     677E 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 6780 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6782 6A24 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 6784 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6786 8362 
0093 6788 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     678A 8360 
0094 678C 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 678E 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6790 A008 
0101 6792 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 6794 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6796 2516 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 6798 C820  54         mov   @outparm2,@tv.sams.c000
     679A 8362 
     679C A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 679E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 67A0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 67A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 67A4 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.149718
0055                       copy  "fb.asm"              ; Framebuffer
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
0024 67A6 0649  14         dect  stack
0025 67A8 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 67AA 0204  20         li    tmp0,fb.top
     67AC A600 
0030 67AE C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     67B0 A100 
0031 67B2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     67B4 A104 
0032 67B6 04E0  34         clr   @fb.row               ; Current row=0
     67B8 A106 
0033 67BA 04E0  34         clr   @fb.column            ; Current column=0
     67BC A10C 
0034               
0035 67BE 0204  20         li    tmp0,80
     67C0 0050 
0036 67C2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     67C4 A10E 
0037               
0038 67C6 0204  20         li    tmp0,29
     67C8 001D 
0039 67CA C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     67CC A118 
0040 67CE C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     67D0 A11A 
0041               
0042 67D2 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     67D4 A01A 
0043 67D6 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     67D8 A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 67DA 06A0  32         bl    @film
     67DC 2230 
0048 67DE A600             data  fb.top,>00,fb.size    ; Clear it all the way
     67E0 0000 
     67E2 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 67E4 0460  28         b     @poprt                ; Return to caller
     67E6 222C 
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
0078 67E8 0649  14         dect  stack
0079 67EA C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67EC C120  34         mov   @parm1,tmp0
     67EE 8350 
0084 67F0 A120  34         a     @fb.topline,tmp0
     67F2 A104 
0085 67F4 C804  38         mov   tmp0,@outparm1
     67F6 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67F8 0460  28         b    @poprt                 ; Return to caller
     67FA 222C 
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
0118 67FC 0649  14         dect  stack
0119 67FE C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 6800 C1A0  34         mov   @fb.row,tmp2
     6802 A106 
0124 6804 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     6806 A10E 
0125 6808 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     680A A10C 
0126 680C A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     680E A100 
0127 6810 C807  38         mov   tmp3,@fb.current
     6812 A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 6814 0460  28         b    @poprt                 ; Return to caller
     6816 222C 
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
0153 6818 0649  14         dect  stack
0154 681A C64B  30         mov   r11,*stack            ; Push return address
0155 681C 0649  14         dect  stack
0156 681E C644  30         mov   tmp0,*stack           ; Push tmp0
0157 6820 0649  14         dect  stack
0158 6822 C645  30         mov   tmp1,*stack           ; Push tmp1
0159 6824 0649  14         dect  stack
0160 6826 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 6828 C820  54         mov   @parm1,@fb.topline
     682A 8350 
     682C A104 
0165 682E 04E0  34         clr   @parm2                ; Target row in frame buffer
     6830 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 6832 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6834 8350 
     6836 A204 
0170 6838 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 683A 06A0  32         bl    @edb.line.unpack      ; Unpack line
     683C 6C4E 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 683E 05A0  34         inc   @parm1                ; Next line in editor buffer
     6840 8350 
0180 6842 05A0  34         inc   @parm2                ; Next row in frame buffer
     6844 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 6846 8820  54         c     @parm1,@edb.lines
     6848 8350 
     684A A204 
0185 684C 1112  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 684E C120  34         mov   @parm2,tmp0           ; Current row
     6850 8352 
0192 6852 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6854 A118 
0193 6856 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 6858 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     685A A10E 
0195               
0196 685C C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 685E 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6860 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6862 A10E 
0200 6864 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6866 A100 
0201               
0202 6868 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 686A 04C5  14         clr   tmp1                  ; Clear with >00 character
0204               
0205 686C 06A0  32         bl    @xfilm                ; \ Fill memory
     686E 2236 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 6870 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 6872 8820  54 !       c     @parm2,@fb.scrrows
     6874 8352 
     6876 A118 
0214 6878 11E0  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 687A 0720  34         seto  @fb.dirty             ; Refresh screen
     687C A116 
0221 687E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 6880 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 6882 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 6884 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 6886 045B  20         b     *r11                  ; Return to caller
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
0239 6888 0649  14         dect  stack
0240 688A C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 688C 04E0  34         clr   @fb.column
     688E A10C 
0245 6890 06A0  32         bl    @fb.calc_pointer
     6892 67FC 
0246 6894 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6896 6D30 
0247 6898 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     689A A108 
0248 689C 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 689E C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     68A0 A102 
0251 68A2 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 68A4 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 68A6 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 68A8 0285  22         ci    tmp1,>2000            ; Whitespace?
     68AA 2000 
0260 68AC 1503  14         jgt   fb.get.firstnonblank.match
0261 68AE 0606  14         dec   tmp2                  ; Counter--
0262 68B0 16F9  14         jne   fb.get.firstnonblank.loop
0263 68B2 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 68B4 6120  34         s     @fb.current,tmp0      ; Calculate column
     68B6 A102 
0269 68B8 0604  14         dec   tmp0
0270 68BA C804  38         mov   tmp0,@outparm1        ; Save column
     68BC 8360 
0271 68BE D805  38         movb  tmp1,@outparm2        ; Save character
     68C0 8362 
0272 68C2 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68C4 04E0  34         clr   @outparm1             ; X=0
     68C6 8360 
0278 68C8 04E0  34         clr   @outparm2             ; Null
     68CA 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 68CC 0460  28         b    @poprt                 ; Return to caller
     68CE 222C 
**** **** ****     > stevie_b1.asm.149718
0056                       copy  "idx.asm"             ; Index management
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
0050 68D0 0649  14         dect  stack
0051 68D2 C64B  30         mov   r11,*stack            ; Save return address
0052 68D4 0649  14         dect  stack
0053 68D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 68D8 0204  20         li    tmp0,idx.top
     68DA B000 
0058 68DC C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     68DE A202 
0059               
0060 68E0 C120  34         mov   @tv.sams.b000,tmp0
     68E2 A006 
0061 68E4 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     68E6 A500 
0062 68E8 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     68EA A502 
0063 68EC C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     68EE A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 68F0 06A0  32         bl    @film
     68F2 2230 
0068 68F4 B000                   data idx.top,>00,idx.size
     68F6 0000 
     68F8 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 68FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 68FC C2F9  30         mov   *stack+,r11           ; Pop r11
0076 68FE 045B  20         b     *r11                  ; Return to caller
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
0100 6900 0649  14         dect  stack
0101 6902 C64B  30         mov   r11,*stack            ; Push return address
0102 6904 0649  14         dect  stack
0103 6906 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 6908 0649  14         dect  stack
0105 690A C645  30         mov   tmp1,*stack           ; Push tmp1
0106 690C 0649  14         dect  stack
0107 690E C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6910 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6912 A502 
0112 6914 0205  20         li    tmp1,idx.top
     6916 B000 
0113               
0114 6918 C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     691A A504 
0115 691C 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 691E 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6920 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6922 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6924 0005 
0121 6926 1104  14         jlt   !
0122 6928 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     692A FFCE 
0123 692C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     692E 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6930 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6932 2516 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6934 0584  14         inc   tmp0                  ; Next SAMS index page
0132 6936 0225  22         ai    tmp1,>1000            ; Next memory region
     6938 1000 
0133 693A 0606  14         dec   tmp2                  ; Update loop counter
0134 693C 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 693E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6940 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6942 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6944 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6946 045B  20         b     *r11                  ; Return to caller
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
0159 6948 0649  14         dect  stack
0160 694A C64B  30         mov   r11,*stack            ; Push return address
0161 694C 0649  14         dect  stack
0162 694E C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6950 0649  14         dect  stack
0164 6952 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6954 0649  14         dect  stack
0166 6956 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 6958 0649  14         dect  stack
0168 695A C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 695C 0205  20         li    tmp1,idx.top
     695E B000 
0173 6960 0206  20         li    tmp2,5                ; Always 5 pages
     6962 0005 
0174 6964 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6966 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 6968 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 696A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     696C 2516 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 696E 0225  22         ai    tmp1,>1000            ; Next memory region
     6970 1000 
0185 6972 0606  14         dec   tmp2                  ; Update loop counter
0186 6974 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6976 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 6978 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 697A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 697C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 697E C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6980 045B  20         b     *r11                  ; Return to caller
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
0220 6982 0649  14         dect  stack
0221 6984 C64B  30         mov   r11,*stack            ; Save return address
0222 6986 0649  14         dect  stack
0223 6988 C644  30         mov   tmp0,*stack           ; Push tmp0
0224 698A 0649  14         dect  stack
0225 698C C645  30         mov   tmp1,*stack           ; Push tmp1
0226 698E 0649  14         dect  stack
0227 6990 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6992 C184  18         mov   tmp0,tmp2             ; Line number
0232 6994 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6996 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6998 0800 
0234               
0235 699A 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 699C 0A16  56         sla   tmp2,1                ; line number * 2
0240 699E C806  38         mov   tmp2,@outparm1        ; Offset index entry
     69A0 8360 
0241               
0242 69A2 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     69A4 A502 
0243 69A6 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     69A8 A500 
0244               
0245 69AA 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 69AC C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     69AE A500 
0251 69B0 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     69B2 A006 
0252               
0253 69B4 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 69B6 0205  20         li    tmp1,>b000            ; Memory window for index page
     69B8 B000 
0255               
0256 69BA 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     69BC 2516 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 69BE 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     69C0 A504 
0263 69C2 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 69C4 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     69C6 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 69C8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 69CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 69CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 69CE C2F9  30         mov   *stack+,r11           ; Pop r11
0274 69D0 045B  20         b     *r11                  ; Return to caller
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
0295 69D2 0649  14         dect  stack
0296 69D4 C64B  30         mov   r11,*stack            ; Save return address
0297 69D6 0649  14         dect  stack
0298 69D8 C644  30         mov   tmp0,*stack           ; Push tmp0
0299 69DA 0649  14         dect  stack
0300 69DC C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 69DE C120  34         mov   @parm1,tmp0           ; Get line number
     69E0 8350 
0305 69E2 C160  34         mov   @parm2,tmp1           ; Get pointer
     69E4 8352 
0306 69E6 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 69E8 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     69EA 0FFF 
0312 69EC 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 69EE 06E0  34         swpb  @parm3
     69F0 8354 
0317 69F2 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     69F4 8354 
0318 69F6 06E0  34         swpb  @parm3                ; \ Restore original order again,
     69F8 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 69FA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     69FC 6982 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 69FE C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6A00 8360 
0329 6A02 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A04 B000 
0330 6A06 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A08 8360 
0331 6A0A 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 6A0C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A0E 6982 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 6A10 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6A12 8360 
0341 6A14 04E4  34         clr   @idx.top(tmp0)        ; /
     6A16 B000 
0342 6A18 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A1A 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 6A1C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6A1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6A20 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6A22 045B  20         b     *r11                  ; Return to caller
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
0373 6A24 0649  14         dect  stack
0374 6A26 C64B  30         mov   r11,*stack            ; Save return address
0375 6A28 0649  14         dect  stack
0376 6A2A C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6A2C 0649  14         dect  stack
0378 6A2E C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6A30 0649  14         dect  stack
0380 6A32 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6A34 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A36 8350 
0385               
0386 6A38 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6A3A 6982 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6A3C C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6A3E 8360 
0391 6A40 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A42 B000 
0392               
0393 6A44 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6A46 C185  18         mov   tmp1,tmp2             ; \
0399 6A48 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6A4A 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A4C 00FF 
0404 6A4E 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6A50 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A52 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6A54 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A56 8360 
0411 6A58 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A5A 8362 
0412 6A5C 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6A5E 04E0  34         clr   @outparm1
     6A60 8360 
0418 6A62 04E0  34         clr   @outparm2
     6A64 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6A66 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6A68 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6A6A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6A6C C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6A6E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0057                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0025 6A70 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6A72 B000 
0026 6A74 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6A76 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6A78 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6A7A 0606  14         dec   tmp2                  ; tmp2--
0034 6A7C 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6A7E 045B  20         b     *r11                  ; Return to caller
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
0054 6A80 0649  14         dect  stack
0055 6A82 C64B  30         mov   r11,*stack            ; Save return address
0056 6A84 0649  14         dect  stack
0057 6A86 C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6A88 0649  14         dect  stack
0059 6A8A C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6A8C 0649  14         dect  stack
0061 6A8E C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6A90 0649  14         dect  stack
0063 6A92 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6A94 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A96 8350 
0068               
0069 6A98 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A9A 6982 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6A9C C120  34         mov   @outparm1,tmp0        ; Index offset
     6A9E 8360 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6AA0 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6AA2 8352 
0078 6AA4 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6AA6 8350 
0079 6AA8 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6AAA C1E0  34         mov   @parm2,tmp3
     6AAC 8352 
0086 6AAE 0287  22         ci    tmp3,2048
     6AB0 0800 
0087 6AB2 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6AB4 06A0  32         bl    @_idx.sams.mapcolumn.on
     6AB6 6900 
0095                                                   ; Index in continious memory region
0096               
0097 6AB8 06A0  32         bl    @_idx.entry.delete.reorg
     6ABA 6A70 
0098                                                   ; Reorganize index
0099               
0100               
0101 6ABC 06A0  32         bl    @_idx.sams.mapcolumn.off
     6ABE 6948 
0102                                                   ; Restore memory window layout
0103               
0104 6AC0 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6AC2 06A0  32         bl    @_idx.entry.delete.reorg
     6AC4 6A70 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6AC6 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6AC8 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6ACA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6ACC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6ACE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6AD0 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6AD2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0058                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0025 6AD4 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6AD6 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6AD8 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6ADA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6ADC FFCE 
0034 6ADE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AE0 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6AE2 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6AE4 B000 
0039 6AE6 C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6AE8 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6AEA 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6AEC C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6AEE 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6AF0 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6AF2 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6AF4 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6AF6 AFFE 
0050 6AF8 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6AFA C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6AFC 0644  14         dect  tmp0                  ; Move pointer up
0058 6AFE 0645  14         dect  tmp1                  ; Move pointer up
0059 6B00 0606  14         dec   tmp2                  ; Next index entry
0060 6B02 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6B04 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6B06 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6B08 045B  20         b     *r11                  ; Return to caller
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
0090 6B0A 0649  14         dect  stack
0091 6B0C C64B  30         mov   r11,*stack            ; Save return address
0092 6B0E 0649  14         dect  stack
0093 6B10 C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6B12 0649  14         dect  stack
0095 6B14 C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6B16 0649  14         dect  stack
0097 6B18 C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6B1A 0649  14         dect  stack
0099 6B1C C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6B1E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B20 8352 
0104 6B22 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B24 8350 
0105 6B26 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6B28 C1E0  34         mov   @parm2,tmp3
     6B2A 8352 
0112 6B2C 0287  22         ci    tmp3,2048
     6B2E 0800 
0113 6B30 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6B32 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B34 6900 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6B36 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B38 8352 
0125 6B3A 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6B3C 06A0  32         bl    @_idx.entry.insert.reorg
     6B3E 6AD4 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6B40 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B42 6948 
0133                                                   ; Restore memory window layout
0134               
0135 6B44 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6B46 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B48 8352 
0141               
0142 6B4A 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B4C 6982 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6B4E C120  34         mov   @outparm1,tmp0        ; Index offset
     6B50 8360 
0147               
0148 6B52 06A0  32         bl    @_idx.entry.insert.reorg
     6B54 6AD4 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6B56 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6B58 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6B5A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6B5C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6B5E C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6B60 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0059                       copy  "edb.asm"             ; Editor Buffer
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
0026 6B62 0649  14         dect  stack
0027 6B64 C64B  30         mov   r11,*stack            ; Save return address
0028 6B66 0649  14         dect  stack
0029 6B68 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6B6A 0204  20         li    tmp0,edb.top          ; \
     6B6C C000 
0034 6B6E C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6B70 A200 
0035 6B72 C804  38         mov   tmp0,@edb.next_free.ptr
     6B74 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6B76 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6B78 A20A 
0039 6B7A 04E0  34         clr   @edb.lines            ; Lines=0
     6B7C A204 
0040 6B7E 04E0  34         clr   @edb.rle              ; RLE compression off
     6B80 A20C 
0041               
0042 6B82 0204  20         li    tmp0,txt.newfile      ; "New file"
     6B84 7712 
0043 6B86 C804  38         mov   tmp0,@edb.filename.ptr
     6B88 A20E 
0044               
0045 6B8A 0204  20         li    tmp0,txt.filetype.none
     6B8C 7724 
0046 6B8E C804  38         mov   tmp0,@edb.filetype.ptr
     6B90 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6B92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6B94 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B96 045B  20         b     *r11                  ; Return to caller
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
0081 6B98 0649  14         dect  stack
0082 6B9A C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6B9C C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6B9E A10C 
     6BA0 8390 
0087 6BA2 04E0  34         clr   @fb.column
     6BA4 A10C 
0088 6BA6 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6BA8 67FC 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6BAA 04C4  14         clr   tmp0                  ; Counter
0093 6BAC C160  34         mov   @fb.current,tmp1      ; Get position
     6BAE A102 
0094 6BB0 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6BB2 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6BB4 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6BB6 0986  56         srl   tmp2,8                ; Right justify
0102 6BB8 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6BBA 0584  14         inc   tmp0                  ; Increase string length
0104 6BBC 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6BBE C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6BC0 A104 
     6BC2 8350 
0111 6BC4 A820  54         a     @fb.row,@parm1        ; /
     6BC6 A106 
     6BC8 8350 
0112               
0113 6BCA C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6BCC 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6BCE C120  34         mov   @edb.next_free.ptr,tmp0
     6BD0 A208 
0120 6BD2 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6BD4 8352 
0121               
0122 6BD6 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6BD8 24DE 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6BDA C820  54         mov   @waux1,@parm3         ; Setup parm3
     6BDC 833C 
     6BDE 8354 
0128               
0129 6BE0 06A0  32         bl    @idx.entry.update     ; Update index
     6BE2 69D2 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6BE4 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6BE6 A212 
     6BE8 8354 
0139 6BEA 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6BEC C120  34         mov   @parm3,tmp0           ; get SAMS page
     6BEE 8354 
0142 6BF0 C160  34         mov   @edb.next_free.ptr,tmp1
     6BF2 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6BF4 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6BF6 2516 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6BF8 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6BFA A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6BFC C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6BFE 8392 
0155 6C00 C160  34         mov   @edb.next_free.ptr,tmp1
     6C02 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6C04 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C06 A208 
0159               
0160 6C08 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C0A 8394 
0161 6C0C 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6C0E 06C6  14         swpb  tmp2
0163 6C10 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6C12 06C6  14         swpb  tmp2
0165 6C14 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6C16 0286  22         ci    tmp2,2
     6C18 0002 
0172 6C1A 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6C1C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6C1E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6C20 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6C22 0286  22         ci    tmp2,1
     6C24 0001 
0179 6C26 1602  14         jne   edb.line.pack.copyline.block
0180 6C28 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6C2A 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6C2C 06A0  32         bl    @xpym2m               ; Copy memory block
     6C2E 2480 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6C30 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6C32 8394 
     6C34 A208 
0192                                                      ; Add length of line
0193               
0194 6C36 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6C38 A208 
0195 6C3A 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0196 6C3C 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6C3E 000F 
0197 6C40 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6C42 A208 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               edb.line.pack.exit:
0202 6C44 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6C46 8390 
     6C48 A10C 
0203 6C4A 0460  28         b     @poprt                ; Return to caller
     6C4C 222C 
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
0232 6C4E 0649  14         dect  stack
0233 6C50 C64B  30         mov   r11,*stack            ; Save return address
0234 6C52 0649  14         dect  stack
0235 6C54 C644  30         mov   tmp0,*stack           ; Push tmp0
0236 6C56 0649  14         dect  stack
0237 6C58 C645  30         mov   tmp1,*stack           ; Push tmp1
0238 6C5A 0649  14         dect  stack
0239 6C5C C646  30         mov   tmp2,*stack           ; Push tmp2
0240                       ;------------------------------------------------------
0241                       ; Sanity check
0242                       ;------------------------------------------------------
0243 6C5E 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6C60 8350 
     6C62 A204 
0244 6C64 1104  14         jlt   !
0245 6C66 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C68 FFCE 
0246 6C6A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C6C 2030 
0247                       ;------------------------------------------------------
0248                       ; Save parameters
0249                       ;------------------------------------------------------
0250 6C6E C820  54 !       mov   @parm1,@rambuf
     6C70 8350 
     6C72 8390 
0251 6C74 C820  54         mov   @parm2,@rambuf+2
     6C76 8352 
     6C78 8392 
0252                       ;------------------------------------------------------
0253                       ; Calculate offset in frame buffer
0254                       ;------------------------------------------------------
0255 6C7A C120  34         mov   @fb.colsline,tmp0
     6C7C A10E 
0256 6C7E 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6C80 8352 
0257 6C82 C1A0  34         mov   @fb.top.ptr,tmp2
     6C84 A100 
0258 6C86 A146  18         a     tmp2,tmp1             ; Add base to offset
0259 6C88 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6C8A 8396 
0260                       ;------------------------------------------------------
0261                       ; Get pointer to line & page-in editor buffer page
0262                       ;------------------------------------------------------
0263 6C8C C120  34         mov   @parm1,tmp0
     6C8E 8350 
0264 6C90 06A0  32         bl    @xmem.edb.sams.mappage
     6C92 6766 
0265                                                   ; Activate editor buffer SAMS page for line
0266                                                   ; \ i  tmp0     = Line number
0267                                                   ; | o  outparm1 = Pointer to line
0268                                                   ; / o  outparm2 = SAMS page
0269               
0270 6C94 C820  54         mov   @outparm2,@edb.sams.page
     6C96 8362 
     6C98 A212 
0271                                                   ; Save current SAMS page
0272                       ;------------------------------------------------------
0273                       ; Handle empty line
0274                       ;------------------------------------------------------
0275 6C9A C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6C9C 8360 
0276 6C9E 1603  14         jne   !                     ; Check if pointer is set
0277 6CA0 04E0  34         clr   @rambuf+8             ; Set length=0
     6CA2 8398 
0278 6CA4 100F  14         jmp   edb.line.unpack.clear
0279                       ;------------------------------------------------------
0280                       ; Get line length
0281                       ;------------------------------------------------------
0282 6CA6 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0283 6CA8 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6CAA 8398 
0284               
0285 6CAC 05E0  34         inct  @outparm1             ; Skip line prefix
     6CAE 8360 
0286 6CB0 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6CB2 8360 
     6CB4 8394 
0287                       ;------------------------------------------------------
0288                       ; Sanity check on line length
0289                       ;------------------------------------------------------
0290 6CB6 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6CB8 0050 
0291 6CBA 1204  14         jle   edb.line.unpack.clear ; /
0292               
0293 6CBC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CBE FFCE 
0294 6CC0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CC2 2030 
0295                       ;------------------------------------------------------
0296                       ; Erase chars from last column until column 80
0297                       ;------------------------------------------------------
0298               edb.line.unpack.clear:
0299 6CC4 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6CC6 8396 
0300 6CC8 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6CCA 8398 
0301               
0302 6CCC 04C5  14         clr   tmp1                  ; Fill with >00
0303 6CCE C1A0  34         mov   @fb.colsline,tmp2
     6CD0 A10E 
0304 6CD2 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6CD4 8398 
0305 6CD6 0586  14         inc   tmp2
0306               
0307 6CD8 06A0  32         bl    @xfilm                ; Fill CPU memory
     6CDA 2236 
0308                                                   ; \ i  tmp0 = Target address
0309                                                   ; | i  tmp1 = Byte to fill
0310                                                   ; / i  tmp2 = Repeat count
0311                       ;------------------------------------------------------
0312                       ; Prepare for unpacking data
0313                       ;------------------------------------------------------
0314               edb.line.unpack.prepare:
0315 6CDC C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6CDE 8398 
0316 6CE0 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0317 6CE2 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6CE4 8394 
0318 6CE6 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6CE8 8396 
0319                       ;------------------------------------------------------
0320                       ; Check before copy
0321                       ;------------------------------------------------------
0322               edb.line.unpack.copy:
0323 6CEA 0286  22         ci    tmp2,80               ; Check line length
     6CEC 0050 
0324 6CEE 1204  14         jle   !
0325 6CF0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CF2 FFCE 
0326 6CF4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CF6 2030 
0327                       ;------------------------------------------------------
0328                       ; Copy memory block
0329                       ;------------------------------------------------------
0330 6CF8 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6CFA 2480 
0331                                                   ; \ i  tmp0 = Source address
0332                                                   ; | i  tmp1 = Target address
0333                                                   ; / i  tmp2 = Bytes to copy
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               edb.line.unpack.exit:
0338 6CFC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0339 6CFE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0340 6D00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0341 6D02 C2F9  30         mov   *stack+,r11           ; Pop r11
0342 6D04 045B  20         b     *r11                  ; Return to caller
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
0366 6D06 0649  14         dect  stack
0367 6D08 C64B  30         mov   r11,*stack            ; Push return address
0368 6D0A 0649  14         dect  stack
0369 6D0C C644  30         mov   tmp0,*stack           ; Push tmp0
0370 6D0E 0649  14         dect  stack
0371 6D10 C645  30         mov   tmp1,*stack           ; Push tmp1
0372                       ;------------------------------------------------------
0373                       ; Initialisation
0374                       ;------------------------------------------------------
0375 6D12 04E0  34         clr   @outparm1             ; Reset length
     6D14 8360 
0376 6D16 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6D18 8362 
0377                       ;------------------------------------------------------
0378                       ; Get length
0379                       ;------------------------------------------------------
0380 6D1A 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6D1C 6A24 
0381                                                   ; \ i  parm1    = Line number
0382                                                   ; | o  outparm1 = Pointer to line
0383                                                   ; / o  outparm2 = SAMS page
0384               
0385 6D1E C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6D20 8360 
0386 6D22 1302  14         jeq   edb.line.getlength.exit
0387                                                   ; Exit early if NULL pointer
0388                       ;------------------------------------------------------
0389                       ; Process line prefix
0390                       ;------------------------------------------------------
0391 6D24 C814  46         mov   *tmp0,@outparm1       ; Save length
     6D26 8360 
0392                       ;------------------------------------------------------
0393                       ; Exit
0394                       ;------------------------------------------------------
0395               edb.line.getlength.exit:
0396 6D28 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0397 6D2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0398 6D2C C2F9  30         mov   *stack+,r11           ; Pop r11
0399 6D2E 045B  20         b     *r11                  ; Return to caller
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
0419 6D30 0649  14         dect  stack
0420 6D32 C64B  30         mov   r11,*stack            ; Save return address
0421                       ;------------------------------------------------------
0422                       ; Calculate line in editor buffer
0423                       ;------------------------------------------------------
0424 6D34 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6D36 A104 
0425 6D38 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6D3A A106 
0426                       ;------------------------------------------------------
0427                       ; Get length
0428                       ;------------------------------------------------------
0429 6D3C C804  38         mov   tmp0,@parm1
     6D3E 8350 
0430 6D40 06A0  32         bl    @edb.line.getlength
     6D42 6D06 
0431 6D44 C820  54         mov   @outparm1,@fb.row.length
     6D46 8360 
     6D48 A108 
0432                                                   ; Save row length
0433                       ;------------------------------------------------------
0434                       ; Exit
0435                       ;------------------------------------------------------
0436               edb.line.getlength2.exit:
0437 6D4A 0460  28         b     @poprt                ; Return to caller
     6D4C 222C 
0438               
**** **** ****     > stevie_b1.asm.149718
0060                       copy  "cmdb.asm"            ; Command Buffer
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
0027 6D4E 0649  14         dect  stack
0028 6D50 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6D52 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6D54 D000 
0033 6D56 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6D58 A300 
0034               
0035 6D5A 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6D5C A302 
0036 6D5E 0204  20         li    tmp0,4
     6D60 0004 
0037 6D62 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6D64 A306 
0038 6D66 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6D68 A308 
0039               
0040 6D6A 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6D6C A316 
0041 6D6E 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6D70 A318 
0042                       ;------------------------------------------------------
0043                       ; Clear command buffer
0044                       ;------------------------------------------------------
0045 6D72 06A0  32         bl    @film
     6D74 2230 
0046 6D76 D000             data  cmdb.top,>00,cmdb.size
     6D78 0000 
     6D7A 1000 
0047                                                   ; Clear it all the way
0048               cmdb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6D7C C2F9  30         mov   *stack+,r11           ; Pop r11
0053 6D7E 045B  20         b     *r11                  ; Return to caller
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
0079 6D80 0649  14         dect  stack
0080 6D82 C64B  30         mov   r11,*stack            ; Save return address
0081 6D84 0649  14         dect  stack
0082 6D86 C644  30         mov   tmp0,*stack           ; Push tmp0
0083 6D88 0649  14         dect  stack
0084 6D8A C645  30         mov   tmp1,*stack           ; Push tmp1
0085 6D8C 0649  14         dect  stack
0086 6D8E C646  30         mov   tmp2,*stack           ; Push tmp2
0087                       ;------------------------------------------------------
0088                       ; Dump Command buffer content
0089                       ;------------------------------------------------------
0090 6D90 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6D92 832A 
     6D94 A30C 
0091 6D96 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6D98 A310 
     6D9A 832A 
0092               
0093 6D9C 05A0  34         inc   @wyx                  ; X +1 for prompt
     6D9E 832A 
0094               
0095 6DA0 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6DA2 23F4 
0096                                                   ; \ i  @wyx = Cursor position
0097                                                   ; / o  tmp0 = VDP target address
0098               
0099 6DA4 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6DA6 A31F 
0100 6DA8 0206  20         li    tmp2,1*79             ; Command length
     6DAA 004F 
0101               
0102 6DAC 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6DAE 2438 
0103                                                   ; | i  tmp0 = VDP target address
0104                                                   ; | i  tmp1 = RAM source address
0105                                                   ; / i  tmp2 = Number of bytes to copy
0106                       ;------------------------------------------------------
0107                       ; Show command buffer prompt
0108                       ;------------------------------------------------------
0109 6DB0 C820  54         mov   @cmdb.yxprompt,@wyx
     6DB2 A310 
     6DB4 832A 
0110 6DB6 06A0  32         bl    @putstr
     6DB8 2418 
0111 6DBA 778A                   data txt.cmdb.prompt
0112               
0113 6DBC C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6DBE A30C 
     6DC0 A114 
0114 6DC2 C820  54         mov   @cmdb.yxsave,@wyx
     6DC4 A30C 
     6DC6 832A 
0115                                                   ; Restore YX position
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119               cmdb.refresh.exit:
0120 6DC8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6DCA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6DCC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6DCE C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6DD0 045B  20         b     *r11                  ; Return to caller
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
0148 6DD2 0649  14         dect  stack
0149 6DD4 C64B  30         mov   r11,*stack            ; Save return address
0150 6DD6 0649  14         dect  stack
0151 6DD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0152 6DDA 0649  14         dect  stack
0153 6DDC C645  30         mov   tmp1,*stack           ; Push tmp1
0154 6DDE 0649  14         dect  stack
0155 6DE0 C646  30         mov   tmp2,*stack           ; Push tmp2
0156                       ;------------------------------------------------------
0157                       ; Clear command
0158                       ;------------------------------------------------------
0159 6DE2 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6DE4 A31E 
0160 6DE6 06A0  32         bl    @film                 ; Clear command
     6DE8 2230 
0161 6DEA A31F                   data  cmdb.cmd,>00,80
     6DEC 0000 
     6DEE 0050 
0162                       ;------------------------------------------------------
0163                       ; Put cursor at beginning of line
0164                       ;------------------------------------------------------
0165 6DF0 C120  34         mov   @cmdb.yxprompt,tmp0
     6DF2 A310 
0166 6DF4 0584  14         inc   tmp0
0167 6DF6 C804  38         mov   tmp0,@cmdb.cursor
     6DF8 A30A 
0168               cmdb.cmd.clear.exit:
0169                       ;------------------------------------------------------
0170                       ; Exit
0171                       ;------------------------------------------------------
0172 6DFA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0173 6DFC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0174 6DFE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0175 6E00 C2F9  30         mov   *stack+,r11           ; Pop r11
0176 6E02 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0061                       copy  "errline.asm"         ; Error line
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
0026 6E04 0649  14         dect  stack
0027 6E06 C64B  30         mov   r11,*stack            ; Save return address
0028 6E08 0649  14         dect  stack
0029 6E0A C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6E0C 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6E0E A01C 
0034               
0035 6E10 06A0  32         bl    @film
     6E12 2230 
0036 6E14 A01E                   data tv.error.msg,0,160
     6E16 0000 
     6E18 00A0 
0037               
0038 6E1A 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6E1C A000 
0039 6E1E D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6E20 A01E 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6E22 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6E24 C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6E26 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.149718
0062                       ;-----------------------------------------------------------------------
0063                       ; File handling
0064                       ;-----------------------------------------------------------------------
0065                       copy  "fh.read.sams.asm"    ; File handler read file
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
0028 6E28 0649  14         dect  stack
0029 6E2A C64B  30         mov   r11,*stack            ; Save return address
0030                       ;------------------------------------------------------
0031                       ; Initialisation
0032                       ;------------------------------------------------------
0033 6E2C 04E0  34         clr   @fh.records           ; Reset records counter
     6E2E A42E 
0034 6E30 04E0  34         clr   @fh.counter           ; Clear internal counter
     6E32 A434 
0035 6E34 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6E36 A432 
0036 6E38 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0037 6E3A 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6E3C A42A 
0038 6E3E 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6E40 A42C 
0039               
0040 6E42 C120  34         mov   @edb.top.ptr,tmp0
     6E44 A200 
0041 6E46 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6E48 24DE 
0042                                                   ; \ i  tmp0  = Memory address
0043                                                   ; | o  waux1 = SAMS page number
0044                                                   ; / o  waux2 = Address of SAMS register
0045               
0046 6E4A C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6E4C 833C 
     6E4E A438 
0047 6E50 C820  54         mov   @waux1,@fh.sams.hipage
     6E52 833C 
     6E54 A43A 
0048                                                   ; Set highest SAMS page in use
0049                       ;------------------------------------------------------
0050                       ; Save parameters / callback functions
0051                       ;------------------------------------------------------
0052 6E56 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6E58 8350 
     6E5A A436 
0053 6E5C C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6E5E 8352 
     6E60 A43C 
0054 6E62 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6E64 8354 
     6E66 A43E 
0055 6E68 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6E6A 8356 
     6E6C A440 
0056 6E6E C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6E70 8358 
     6E72 A442 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 6E74 C120  34         mov   @fh.callback1,tmp0
     6E76 A43C 
0061 6E78 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E7A 6000 
0062 6E7C 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0063               
0064 6E7E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E80 7FFF 
0065 6E82 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0066               
0067 6E84 C120  34         mov   @fh.callback2,tmp0
     6E86 A43E 
0068 6E88 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E8A 6000 
0069 6E8C 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0070               
0071 6E8E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E90 7FFF 
0072 6E92 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6E94 C120  34         mov   @fh.callback3,tmp0
     6E96 A440 
0075 6E98 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E9A 6000 
0076 6E9C 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0077               
0078 6E9E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6EA0 7FFF 
0079 6EA2 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6EA4 1004  14         jmp   fh.file.read.sams.load1
0082                                                   ; All checks passed, continue.
0083                                                   ;--------------------------
0084                                                   ; Check failed, crash CPU!
0085                                                   ;--------------------------
0086               fh.file.read.crash:
0087 6EA6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6EA8 FFCE 
0088 6EAA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6EAC 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.read.sams.load1:
0093 6EAE C120  34         mov   @fh.callback1,tmp0
     6EB0 A43C 
0094 6EB2 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.read.sams.pabheader:
0099 6EB4 06A0  32         bl    @cpym2v
     6EB6 2432 
0100 6EB8 0A60                   data fh.vpab,fh.file.pab.header,9
     6EBA 7006 
     6EBC 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 6EBE 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6EC0 0A69 
0106 6EC2 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6EC4 A436 
0107 6EC6 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 6EC8 0986  56         srl   tmp2,8                ; Right justify
0109 6ECA 0586  14         inc   tmp2                  ; Include length byte as well
0110 6ECC 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6ECE 2438 
0111                       ;------------------------------------------------------
0112                       ; Load GPL scratchpad layout
0113                       ;------------------------------------------------------
0114 6ED0 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6ED2 2A72 
0115 6ED4 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0116                       ;------------------------------------------------------
0117                       ; Open file
0118                       ;------------------------------------------------------
0119 6ED6 06A0  32         bl    @file.open
     6ED8 2BC0 
0120 6EDA 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0121 6EDC 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6EDE 2026 
0122 6EE0 1602  14         jne   fh.file.read.sams.record
0123 6EE2 0460  28         b     @fh.file.read.sams.error
     6EE4 6FD4 
0124                                                   ; Yes, IO error occured
0125                       ;------------------------------------------------------
0126                       ; Step 1: Read file record
0127                       ;------------------------------------------------------
0128               fh.file.read.sams.record:
0129 6EE6 05A0  34         inc   @fh.records           ; Update counter
     6EE8 A42E 
0130 6EEA 04E0  34         clr   @fh.reclen            ; Reset record length
     6EEC A430 
0131               
0132 6EEE 06A0  32         bl    @file.record.read     ; Read file record
     6EF0 2C02 
0133 6EF2 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0134                                                   ; |           (without +9 offset!)
0135                                                   ; | o  tmp0 = Status byte
0136                                                   ; | o  tmp1 = Bytes read
0137                                                   ; | o  tmp2 = Status register contents
0138                                                   ; /           upon DSRLNK return
0139               
0140 6EF4 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6EF6 A42A 
0141 6EF8 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6EFA A430 
0142 6EFC C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6EFE A42C 
0143                       ;------------------------------------------------------
0144                       ; 1a: Calculate kilobytes processed
0145                       ;------------------------------------------------------
0146 6F00 A805  38         a     tmp1,@fh.counter
     6F02 A434 
0147 6F04 A160  34         a     @fh.counter,tmp1
     6F06 A434 
0148 6F08 0285  22         ci    tmp1,1024
     6F0A 0400 
0149 6F0C 1106  14         jlt   !
0150 6F0E 05A0  34         inc   @fh.kilobytes
     6F10 A432 
0151 6F12 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6F14 FC00 
0152 6F16 C805  38         mov   tmp1,@fh.counter
     6F18 A434 
0153                       ;------------------------------------------------------
0154                       ; 1b: Load spectra scratchpad layout
0155                       ;------------------------------------------------------
0156 6F1A 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6F1C 29F8 
0157 6F1E 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F20 2A94 
0158 6F22 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0159                       ;------------------------------------------------------
0160                       ; 1c: Check if a file error occured
0161                       ;------------------------------------------------------
0162               fh.file.read.sams.check_fioerr:
0163 6F24 C1A0  34         mov   @fh.ioresult,tmp2
     6F26 A42C 
0164 6F28 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6F2A 2026 
0165 6F2C 1602  14         jne   fh.file.read.sams.check_setpage
0166                                                   ; No, goto (1d)
0167 6F2E 0460  28         b     @fh.file.read.sams.error
     6F30 6FD4 
0168                                                   ; Yes, so handle file error
0169                       ;------------------------------------------------------
0170                       ; 1d: Check if SAMS page needs to be set
0171                       ;------------------------------------------------------
0172               fh.file.read.sams.check_setpage:
0173 6F32 C120  34         mov   @edb.next_free.ptr,tmp0
     6F34 A208 
0174                                                   ;--------------------------
0175                                                   ; Sanity check
0176                                                   ;--------------------------
0177 6F36 0284  22         ci    tmp0,edb.top + edb.size
     6F38 D000 
0178                                                   ; Insane address ?
0179 6F3A 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0180                                                   ;--------------------------
0181                                                   ; Check overflow
0182                                                   ;--------------------------
0183 6F3C 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6F3E 0FFF 
0184 6F40 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6F42 A430 
0185 6F44 05C4  14         inct  tmp0                  ; +2 for line prefix
0186 6F46 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6F48 0FF0 
0187 6F4A 110E  14         jlt   fh.file.read.sams.process_line
0188                                                   ; Not yet so skip SAMS page switch
0189                       ;------------------------------------------------------
0190                       ; 1e: Increase SAMS page
0191                       ;------------------------------------------------------
0192 6F4C 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6F4E A438 
0193 6F50 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6F52 A438 
     6F54 A43A 
0194                                                   ; Set highest SAMS page
0195 6F56 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6F58 A200 
     6F5A A208 
0196                                                   ; Start at top of SAMS page again
0197                       ;------------------------------------------------------
0198                       ; 1f: Switch to SAMS page
0199                       ;------------------------------------------------------
0200 6F5C C120  34         mov   @fh.sams.page,tmp0
     6F5E A438 
0201 6F60 C160  34         mov   @edb.top.ptr,tmp1
     6F62 A200 
0202 6F64 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6F66 2516 
0203                                                   ; \ i  tmp0 = SAMS page number
0204                                                   ; / i  tmp1 = Memory address
0205                       ;------------------------------------------------------
0206                       ; Step 2: Process line
0207                       ;------------------------------------------------------
0208               fh.file.read.sams.process_line:
0209 6F68 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6F6A 0960 
0210 6F6C C160  34         mov   @edb.next_free.ptr,tmp1
     6F6E A208 
0211                                                   ; RAM target in editor buffer
0212               
0213 6F70 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6F72 8352 
0214               
0215 6F74 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6F76 A430 
0216 6F78 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0217                                                   ; Handle empty line
0218                       ;------------------------------------------------------
0219                       ; 2a: Copy line from VDP to CPU editor buffer
0220                       ;------------------------------------------------------
0221                                                   ; Put line length word before string
0222 6F7A DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0223 6F7C 06C6  14         swpb  tmp2                  ; |
0224 6F7E DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0225 6F80 06C6  14         swpb  tmp2                  ; /
0226               
0227 6F82 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6F84 A208 
0228 6F86 A806  38         a     tmp2,@edb.next_free.ptr
     6F88 A208 
0229                                                   ; Add line length
0230               
0231 6F8A 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6F8C 245E 
0232                                                   ; \ i  tmp0 = VDP source address
0233                                                   ; | i  tmp1 = RAM target address
0234                                                   ; / i  tmp2 = Bytes to copy
0235                       ;------------------------------------------------------
0236                       ; 2b: Align pointer to multiple of 16 memory address
0237                       ;------------------------------------------------------
0238 6F8E C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F90 A208 
0239 6F92 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0240 6F94 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F96 000F 
0241 6F98 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F9A A208 
0242                       ;------------------------------------------------------
0243                       ; Step 3: Update index
0244                       ;------------------------------------------------------
0245               fh.file.read.sams.prepindex:
0246 6F9C C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6F9E A204 
     6FA0 8350 
0247                                                   ; parm2 = Must allready be set!
0248 6FA2 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6FA4 A438 
     6FA6 8354 
0249               
0250 6FA8 1009  14         jmp   fh.file.read.sams.updindex
0251                                                   ; Update index
0252                       ;------------------------------------------------------
0253                       ; 3a: Special handling for empty line
0254                       ;------------------------------------------------------
0255               fh.file.read.sams.prepindex.emptyline:
0256 6FAA C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6FAC A42E 
     6FAE 8350 
0257 6FB0 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6FB2 8350 
0258 6FB4 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6FB6 8352 
0259 6FB8 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6FBA 8354 
0260                       ;------------------------------------------------------
0261                       ; 3b: Do actual index update
0262                       ;------------------------------------------------------
0263               fh.file.read.sams.updindex:
0264 6FBC 06A0  32         bl    @idx.entry.update     ; Update index
     6FBE 69D2 
0265                                                   ; \ i  parm1    = Line num in editor buffer
0266                                                   ; | i  parm2    = Pointer to line in editor
0267                                                   ; |               buffer
0268                                                   ; | i  parm3    = SAMS page
0269                                                   ; | o  outparm1 = Pointer to updated index
0270                                                   ; /               entry
0271               
0272 6FC0 05A0  34         inc   @edb.lines            ; lines=lines+1
     6FC2 A204 
0273                       ;------------------------------------------------------
0274                       ; Step 4: Callback "Read line from file"
0275                       ;------------------------------------------------------
0276               fh.file.read.sams.display:
0277 6FC4 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6FC6 A43E 
0278 6FC8 0694  24         bl    *tmp0                 ; Run callback function
0279                       ;------------------------------------------------------
0280                       ; 4a: Next record
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.next:
0283 6FCA 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6FCC 2A72 
0284 6FCE 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0285               
0286 6FD0 0460  28         b     @fh.file.read.sams.record
     6FD2 6EE6 
0287                                                   ; Next record
0288                       ;------------------------------------------------------
0289                       ; Error handler
0290                       ;------------------------------------------------------
0291               fh.file.read.sams.error:
0292 6FD4 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6FD6 A42A 
0293 6FD8 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0294 6FDA 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6FDC 0005 
0295 6FDE 1309  14         jeq   fh.file.read.sams.eof
0296                                                   ; All good. File closed by DSRLNK
0297                       ;------------------------------------------------------
0298                       ; File error occured
0299                       ;------------------------------------------------------
0300 6FE0 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6FE2 2A94 
0301 6FE4 3F00                   data scrpad.backup2   ; / >2100->8300
0302               
0303 6FE6 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6FE8 674A 
0304                       ;------------------------------------------------------
0305                       ; Callback "File I/O error"
0306                       ;------------------------------------------------------
0307 6FEA C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     6FEC A442 
0308 6FEE 0694  24         bl    *tmp0                 ; Run callback function
0309 6FF0 1008  14         jmp   fh.file.read.sams.exit
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               fh.file.read.sams.eof:
0314 6FF2 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6FF4 2A94 
0315 6FF6 3F00                   data scrpad.backup2   ; / >2100->8300
0316               
0317 6FF8 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6FFA 674A 
0318                       ;------------------------------------------------------
0319                       ; Callback "Close file"
0320                       ;------------------------------------------------------
0321 6FFC C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     6FFE A440 
0322 7000 0694  24         bl    *tmp0                 ; Run callback function
0323               *--------------------------------------------------------------
0324               * Exit
0325               *--------------------------------------------------------------
0326               fh.file.read.sams.exit:
0327 7002 C2F9  30         mov   *stack+,r11           ; Pop r11
0328 7004 045B  20         b     *r11                  ; Return to caller
0329               
0330               
0331               
0332               ***************************************************************
0333               * PAB for accessing DV/80 file
0334               ********|*****|*********************|**************************
0335               fh.file.pab.header:
0336 7006 0014             byte  io.op.open            ;  0    - OPEN
0337                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0338 7008 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0339 700A 5000             byte  80                    ;  4    - Record length (80 chars max)
0340                       byte  00                    ;  5    - Character count
0341 700C 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0342 700E 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0343                       ;------------------------------------------------------
0344                       ; File descriptor part (variable length)
0345                       ;------------------------------------------------------
0346                       ; byte  12                  ;  9    - File descriptor length
0347                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0348                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.149718
0066                       copy  "fm.load.asm"         ; File manager loadfile
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
0014 7010 0649  14         dect  stack
0015 7012 C64B  30         mov   r11,*stack            ; Save return address
0016                       ;-------------------------------------------------------
0017                       ; Reset editor
0018                       ;-------------------------------------------------------
0019 7014 C804  38         mov   tmp0,@parm1           ; Setup file to load
     7016 8350 
0020 7018 06A0  32         bl    @tv.reset             ; Reset editor
     701A 672E 
0021 701C C820  54         mov   @parm1,@edb.filename.ptr
     701E 8350 
     7020 A20E 
0022                                                   ; Set filename
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7022 06A0  32         bl    @filv
     7024 2288 
0027 7026 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7028 0000 
     702A 0004 
0028               
0029 702C C160  34         mov   @fb.scrrows,tmp1
     702E A118 
0030 7030 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7032 A10E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033               
0034 7034 06A0  32         bl    @scroff               ; Turn off screen
     7036 262E 
0035               
0036 7038 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0037 703A 0205  20         li    tmp1,32               ; Character to fill
     703C 0020 
0038               
0039 703E 06A0  32         bl    @xfilv                ; Fill VDP memory
     7040 228E 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = Byte to fill
0042                                                   ; / i  tmp2 = Bytes to copy
0043               
0044 7042 06A0  32         bl    @pane.action.colorscheme.Load
     7044 72C0 
0045                                                   ; Load color scheme and turn on screen
0046                       ;-------------------------------------------------------
0047                       ; Read DV80 file and display
0048                       ;-------------------------------------------------------
0049 7046 0204  20         li    tmp0,fm.loadfile.cb.indicator1
     7048 707A 
0050 704A C804  38         mov   tmp0,@parm2           ; Register callback 1
     704C 8352 
0051               
0052 704E 0204  20         li    tmp0,fm.loadfile.cb.indicator2
     7050 70A2 
0053 7052 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7054 8354 
0054               
0055 7056 0204  20         li    tmp0,fm.loadfile.cb.indicator3
     7058 70D4 
0056 705A C804  38         mov   tmp0,@parm4           ; Register callback 3
     705C 8356 
0057               
0058 705E 0204  20         li    tmp0,fm.loadfile.cb.fioerr
     7060 7106 
0059 7062 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7064 8358 
0060               
0061 7066 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     7068 6E28 
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
0073 706A 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     706C A206 
0074                                                   ; longer dirty.
0075               
0076 706E 0204  20         li    tmp0,txt.filetype.DV80
     7070 771E 
0077 7072 C804  38         mov   tmp0,@edb.filetype.ptr
     7074 A210 
0078                                                   ; Set filetype display string
0079               *--------------------------------------------------------------
0080               * Exit
0081               *--------------------------------------------------------------
0082               fm.loadfile.exit:
0083 7076 0460  28         b     @poprt                ; Return to caller
     7078 222C 
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
0094 707A 0649  14         dect  stack
0095 707C C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Show loading indicators and file descriptor
0098                       ;------------------------------------------------------
0099 707E 06A0  32         bl    @hchar
     7080 2762 
0100 7082 1D00                   byte 29,0,32,80
     7084 2050 
0101 7086 FFFF                   data EOL
0102               
0103 7088 06A0  32         bl    @putat
     708A 242A 
0104 708C 1D00                   byte 29,0
0105 708E 76F4                   data txt.loading      ; Display "Loading...."
0106               
0107 7090 06A0  32         bl    @at
     7092 266E 
0108 7094 1D0B                   byte 29,11            ; Cursor YX position
0109 7096 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7098 8350 
0110 709A 06A0  32         bl    @xutst0               ; Display device/filename
     709C 241A 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.cb.indicator1.exit:
0115 709E 0460  28         b     @poprt                ; Return to caller
     70A0 222C 
0116               
0117               
0118               
0119               
0120               *---------------------------------------------------------------
0121               * Callback function "Show loading indicator 2"
0122               *---------------------------------------------------------------
0123               * Read line
0124               * Is expected to be passed as parm3 to @tfh.file.read
0125               *---------------------------------------------------------------
0126               fm.loadfile.cb.indicator2:
0127 70A2 0649  14         dect  stack
0128 70A4 C64B  30         mov   r11,*stack            ; Save return address
0129               
0130 70A6 06A0  32         bl    @putnum
     70A8 29EE 
0131 70AA 1D4B                   byte 29,75            ; Show lines read
0132 70AC A204                   data edb.lines,rambuf,>3020
     70AE 8390 
     70B0 3020 
0133               
0134 70B2 8220  34         c     @fh.kilobytes,tmp4
     70B4 A432 
0135 70B6 130C  14         jeq   fm.loadfile.cb.indicator2.exit
0136               
0137 70B8 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     70BA A432 
0138               
0139 70BC 06A0  32         bl    @putnum
     70BE 29EE 
0140 70C0 1D38                   byte 29,56            ; Show kilobytes read
0141 70C2 A432                   data fh.kilobytes,rambuf,>3020
     70C4 8390 
     70C6 3020 
0142               
0143 70C8 06A0  32         bl    @putat
     70CA 242A 
0144 70CC 1D3D                   byte 29,61
0145 70CE 7700                   data txt.kb           ; Show "kb" string
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149               fm.loadfile.cb.indicator2.exit:
0150 70D0 0460  28         b     @poprt                ; Return to caller
     70D2 222C 
0151               
0152               
0153               
0154               
0155               
0156               *---------------------------------------------------------------
0157               * Callback function "Show loading indicator 3"
0158               * Close file
0159               *---------------------------------------------------------------
0160               * Is expected to be passed as parm4 to @tfh.file.read
0161               *---------------------------------------------------------------
0162               fm.loadfile.cb.indicator3:
0163 70D4 0649  14         dect  stack
0164 70D6 C64B  30         mov   r11,*stack            ; Save return address
0165               
0166               
0167 70D8 06A0  32         bl    @hchar
     70DA 2762 
0168 70DC 1D03                   byte 29,3,32,50       ; Erase loading indicator
     70DE 2032 
0169 70E0 FFFF                   data EOL
0170               
0171 70E2 06A0  32         bl    @putnum
     70E4 29EE 
0172 70E6 1D38                   byte 29,56            ; Show kilobytes read
0173 70E8 A432                   data fh.kilobytes,rambuf,>3020
     70EA 8390 
     70EC 3020 
0174               
0175 70EE 06A0  32         bl    @putat
     70F0 242A 
0176 70F2 1D3D                   byte 29,61
0177 70F4 7700                   data txt.kb           ; Show "kb" string
0178               
0179 70F6 06A0  32         bl    @putnum
     70F8 29EE 
0180 70FA 1D4B                   byte 29,75            ; Show lines read
0181 70FC A42E                   data fh.records,rambuf,>3020
     70FE 8390 
     7100 3020 
0182                       ;------------------------------------------------------
0183                       ; Exit
0184                       ;------------------------------------------------------
0185               fm.loadfile.cb.indicator3.exit:
0186 7102 0460  28         b     @poprt                ; Return to caller
     7104 222C 
0187               
0188               
0189               
0190               *---------------------------------------------------------------
0191               * Callback function "File I/O error handler"
0192               *---------------------------------------------------------------
0193               * Is expected to be passed as parm5 to @tfh.file.read
0194               ********|*****|*********************|**************************
0195               fm.loadfile.cb.fioerr:
0196 7106 0649  14         dect  stack
0197 7108 C64B  30         mov   r11,*stack            ; Save return address
0198               
0199 710A 06A0  32         bl    @hchar
     710C 2762 
0200 710E 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7110 2032 
0201 7112 FFFF                   data EOL
0202                       ;------------------------------------------------------
0203                       ; Build I/O error message
0204                       ;------------------------------------------------------
0205 7114 06A0  32         bl    @cpym2m
     7116 247A 
0206 7118 7759                   data txt.ioerr+1
0207 711A A01F                   data tv.error.msg+1
0208 711C 0022                   data 34               ; Error message
0209               
0210 711E C120  34         mov   @edb.filename.ptr,tmp0
     7120 A20E 
0211 7122 D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 7124 0986  56         srl   tmp2,8                ; Right align
0213 7126 0584  14         inc   tmp0                  ; Skip length byte
0214 7128 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     712A A03F 
0215               
0216 712C 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     712E 2480 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220                       ;------------------------------------------------------
0221                       ; Reset filename to "new file"
0222                       ;------------------------------------------------------
0223 7130 0204  20         li    tmp0,txt.newfile      ; New file
     7132 7712 
0224 7134 C804  38         mov   tmp0,@edb.filename.ptr
     7136 A20E 
0225               
0226 7138 0204  20         li    tmp0,txt.filetype.none
     713A 7724 
0227 713C C804  38         mov   tmp0,@edb.filetype.ptr
     713E A210 
0228                                                   ; Empty filetype string
0229                       ;------------------------------------------------------
0230                       ; Display I/O error message
0231                       ;------------------------------------------------------
0232 7140 06A0  32         bl    @pane.errline.show    ; Show error line
     7142 74E0 
0233                       ;------------------------------------------------------
0234                       ; Exit
0235                       ;------------------------------------------------------
0236               fm.loadfile.cb.fioerr.exit:
0237 7144 0460  28         b     @poprt                ; Return to caller
     7146 222C 
**** **** ****     > stevie_b1.asm.149718
0067                       ;-----------------------------------------------------------------------
0068                       ; User hook, background tasks
0069                       ;-----------------------------------------------------------------------
0070                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 7148 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     714A 2014 
0013 714C 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 714E 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     7150 2014 
0019 7152 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7154 833C 
     7156 833E 
0020 7158 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 715A C820  54         mov   @waux1,@waux2         ; Save as previous key
     715C 833C 
     715E 833E 
0026 7160 0460  28         b     @edkey.key.process    ; Process key
     7162 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 7164 04E0  34         clr   @waux1
     7166 833C 
0032 7168 04E0  34         clr   @waux2
     716A 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 716C 0204  20         li    tmp0,2000             ; Avoid key bouncing
     716E 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 7170 0604  14         dec   tmp0
0043 7172 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 7174 0460  28         b     @hookok               ; Return
     7176 2C4A 
**** **** ****     > stevie_b1.asm.149718
0071                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0015 7178 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     717A A302 
0016 717C 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 717E C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7180 A318 
0022 7182 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 7184 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     7186 73CC 
0025 7188 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     718A A318 
0026 718C 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 718E C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7190 A116 
0031 7192 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 7194 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7196 832A 
     7198 A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 719A 8820  54         c     @edb.lines,@fb.scrrows
     719C A204 
     719E A118 
0037 71A0 1103  14         jlt   task.vdp.panes.setrows.small
0038 71A2 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     71A4 A118 
0039 71A6 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 71A8 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     71AA A204 
0045 71AC 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 71AE 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     71B0 A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 71B2 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 71B4 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     71B6 A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 71B8 06A0  32         bl    @xpym2v               ; Copy to VDP
     71BA 2438 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 71BC 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     71BE A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 71C0 C120  34         mov   @edb.lines,tmp0
     71C2 A204 
0066 71C4 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     71C6 A104 
0067 71C8 0584  14         inc   tmp0                  ; Y = Y + 1
0068 71CA 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     71CC A118 
0069 71CE 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 71D0 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 71D2 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     71D4 832A 
0077               
0078 71D6 06A0  32         bl    @putstr
     71D8 2418 
0079 71DA 76DE                   data txt.marker       ; Display *EOF*
0080               
0081 71DC 06A0  32         bl    @setx
     71DE 2684 
0082 71E0 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 71E2 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     71E4 A10E 
0088               
0089 71E6 C160  34         mov   @wyx,tmp1             ;
     71E8 832A 
0090 71EA 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 71EC 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 71EE A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     71F0 A118 
0093               
0094 71F2 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 71F4 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     71F6 FFFB 
0096               
0097 71F8 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     71FA 23F4 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 71FC 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 71FE 06A0  32         bl    @xfilv                ; Fill VDP memory
     7200 228E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 7202 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7204 A114 
     7206 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 7208 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     720A 7526 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 720C 0460  28         b     @slotok
     720E 2CC6 
**** **** ****     > stevie_b1.asm.149718
0072                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 7210 C120  34         mov   @tv.pane.focus,tmp0
     7212 A01A 
0013 7214 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 7216 0284  22         ci    tmp0,pane.focus.cmdb
     7218 0001 
0016 721A 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 721C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     721E FFCE 
0022 7220 06A0  32         bl    @cpu.crash            ; / Halt system.
     7222 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7224 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7226 A30A 
     7228 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 722A E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     722C 202A 
0032 722E 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7230 2690 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7232 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7234 8380 
0036               
0037 7236 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7238 2432 
0038 723A 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     723C 8380 
     723E 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7240 0460  28         b     @slotok               ; Exit task
     7242 2CC6 
**** **** ****     > stevie_b1.asm.149718
0073                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 7244 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     7246 A112 
0013 7248 1303  14         jeq   task.vdp.cursor.visible
0014 724A 04E0  34         clr   @ramsat+2              ; Hide cursor
     724C 8382 
0015 724E 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7250 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7252 A20A 
0019 7254 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 7256 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7258 A01A 
0025 725A 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 725C 0284  22         ci    tmp0,pane.focus.cmdb
     725E 0001 
0028 7260 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 7262 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 7264 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 7266 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7268 0100 
0040 726A 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 726C 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     726E 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7270 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7272 A014 
0051 7274 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     7276 A014 
     7278 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 727A 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     727C 2432 
0057 727E 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     7280 8380 
     7282 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 7284 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     7286 A302 
0064 7288 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 728A 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     728C 7526 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 728E 0460  28         b     @slotok                ; Exit task
     7290 2CC6 
**** **** ****     > stevie_b1.asm.149718
0074                       ;-----------------------------------------------------------------------
0075                       ; Screen pane utilities
0076                       ;-----------------------------------------------------------------------
0077                       copy  "pane.utils.colorscheme.asm"
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
0021 7292 0649  14         dect  stack
0022 7294 C64B  30         mov   r11,*stack            ; Push return address
0023 7296 0649  14         dect  stack
0024 7298 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 729A C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     729C A012 
0027 729E 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     72A0 0008 
0028                                                   ; Last entry reached?
0029 72A2 1102  14         jlt   !
0030 72A4 04C4  14         clr   tmp0
0031 72A6 1001  14         jmp   pane.action.colorscheme.switch
0032 72A8 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 72AA C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     72AC A012 
0038 72AE 06A0  32         bl    @pane.action.colorscheme.load
     72B0 72C0 
0039                       ;-------------------------------------------------------
0040                       ; Delay
0041                       ;-------------------------------------------------------
0042 72B2 0204  20         li    tmp0,12000
     72B4 2EE0 
0043 72B6 0604  14 !       dec   tmp0
0044 72B8 16FE  14         jne   -!
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               pane.action.colorscheme.cycle.exit:
0049 72BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0050 72BC C2F9  30         mov   *stack+,r11           ; Pop R11
0051 72BE 045B  20         b     *r11                  ; Return to caller
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
0073 72C0 0649  14         dect  stack
0074 72C2 C64B  30         mov   r11,*stack            ; Save return address
0075 72C4 0649  14         dect  stack
0076 72C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 72C8 0649  14         dect  stack
0078 72CA C645  30         mov   tmp1,*stack           ; Push tmp1
0079 72CC 0649  14         dect  stack
0080 72CE C646  30         mov   tmp2,*stack           ; Push tmp2
0081 72D0 0649  14         dect  stack
0082 72D2 C647  30         mov   tmp3,*stack           ; Push tmp3
0083 72D4 0649  14         dect  stack
0084 72D6 C648  30         mov   tmp4,*stack           ; Push tmp4
0085 72D8 06A0  32         bl    @scroff               ; Turn screen off
     72DA 262E 
0086                       ;-------------------------------------------------------
0087                       ; Get framebuffer foreground/background color
0088                       ;-------------------------------------------------------
0089 72DC C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     72DE A012 
0090 72E0 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0091 72E2 0224  22         ai    tmp0,tv.colorscheme.table
     72E4 76B8 
0092                                                   ; Add base for color scheme data table
0093 72E6 C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0094 72E8 C807  38         mov   tmp3,@tv.color        ; Save colors
     72EA A018 
0095                       ;-------------------------------------------------------
0096                       ; Get and save cursor color
0097                       ;-------------------------------------------------------
0098 72EC C214  26         mov   *tmp0,tmp4            ; Get cursor color
0099 72EE 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     72F0 00FF 
0100 72F2 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     72F4 A016 
0101                       ;-------------------------------------------------------
0102                       ; Get CMDB pane foreground/background color
0103                       ;-------------------------------------------------------
0104 72F6 C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0105 72F8 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     72FA FF00 
0106 72FC 0988  56         srl   tmp4,8                ; MSB to LSB
0107                       ;-------------------------------------------------------
0108                       ; Dump colors to VDP register 7 (text mode)
0109                       ;-------------------------------------------------------
0110 72FE C147  18         mov   tmp3,tmp1             ; Get work copy
0111 7300 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0112 7302 0265  22         ori   tmp1,>0700
     7304 0700 
0113 7306 C105  18         mov   tmp1,tmp0
0114 7308 06A0  32         bl    @putvrx               ; Write VDP register
     730A 232E 
0115                       ;-------------------------------------------------------
0116                       ; Dump colors for frame buffer pane (TAT)
0117                       ;-------------------------------------------------------
0118 730C 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     730E 1800 
0119 7310 C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0120 7312 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0121 7314 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     7316 0910 
0122 7318 06A0  32         bl    @xfilv                ; Fill colors
     731A 228E 
0123                                                   ; i \  tmp0 = start address
0124                                                   ; i |  tmp1 = byte to fill
0125                                                   ; i /  tmp2 = number of bytes to fill
0126                       ;-------------------------------------------------------
0127                       ; Dump colors for CMDB pane (TAT)
0128                       ;-------------------------------------------------------
0129               pane.action.colorscheme.cmdbpane:
0130 731C C120  34         mov   @cmdb.visible,tmp0
     731E A302 
0131 7320 1307  14         jeq   pane.action.colorscheme.errpane
0132                                                   ; Skip if CMDB pane is hidden
0133               
0134 7322 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     7324 1FD0 
0135 7326 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0136 7328 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     732A 0190 
0137 732C 06A0  32         bl    @xfilv                ; Fill colors
     732E 228E 
0138                                                   ; i \  tmp0 = start address
0139                                                   ; i |  tmp1 = byte to fill
0140                                                   ; i /  tmp2 = number of bytes to fill
0141                       ;-------------------------------------------------------
0142                       ; Dump colors for error line pane (TAT)
0143                       ;-------------------------------------------------------
0144               pane.action.colorscheme.errpane:
0145 7330 C120  34         mov   @tv.error.visible,tmp0
     7332 A01C 
0146 7334 1304  14         jeq   pane.action.colorscheme.statusline
0147                                                   ; Skip if error line pane is hidden
0148               
0149 7336 0205  20         li    tmp1,>00f6            ; White on dark red
     7338 00F6 
0150 733A 06A0  32         bl    @pane.action.colorscheme.errline
     733C 7370 
0151                                                   ; Load color combination for error line
0152                       ;-------------------------------------------------------
0153                       ; Dump colors for bottom status line pane (TAT)
0154                       ;-------------------------------------------------------
0155               pane.action.colorscheme.statusline:
0156 733E 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     7340 2110 
0157 7342 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0158 7344 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7346 00FF 
0159 7348 0206  20         li    tmp2,80               ; Number of bytes to fill
     734A 0050 
0160 734C 06A0  32         bl    @xfilv                ; Fill colors
     734E 228E 
0161                                                   ; i \  tmp0 = start address
0162                                                   ; i |  tmp1 = byte to fill
0163                                                   ; i /  tmp2 = number of bytes to fill
0164                       ;-------------------------------------------------------
0165                       ; Dump cursor FG color to sprite table (SAT)
0166                       ;-------------------------------------------------------
0167               pane.action.colorscheme.cursorcolor:
0168 7350 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     7352 A016 
0169 7354 0A88  56         sla   tmp4,8                ; Move to MSB
0170 7356 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7358 8383 
0171 735A D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     735C A015 
0172                       ;-------------------------------------------------------
0173                       ; Exit
0174                       ;-------------------------------------------------------
0175               pane.action.colorscheme.load.exit:
0176 735E 06A0  32         bl    @scron                ; Turn screen on
     7360 2636 
0177 7362 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0178 7364 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0179 7366 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0180 7368 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 736A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 736C C2F9  30         mov   *stack+,r11           ; Pop R11
0183 736E 045B  20         b     *r11                  ; Return to caller
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
0203 7370 0649  14         dect  stack
0204 7372 C64B  30         mov   r11,*stack            ; Save return address
0205 7374 0649  14         dect  stack
0206 7376 C644  30         mov   tmp0,*stack           ; Push tmp0
0207 7378 0649  14         dect  stack
0208 737A C645  30         mov   tmp1,*stack           ; Push tmp1
0209 737C 0649  14         dect  stack
0210 737E C646  30         mov   tmp2,*stack           ; Push tmp2
0211                       ;-------------------------------------------------------
0212                       ; Load error line colors
0213                       ;-------------------------------------------------------
0214 7380 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     7382 20C0 
0215 7384 0206  20         li    tmp2,80               ; Number of bytes to fill
     7386 0050 
0216 7388 06A0  32         bl    @xfilv                ; Fill colors
     738A 228E 
0217                                                   ; i \  tmp0 = start address
0218                                                   ; i |  tmp1 = byte to fill
0219                                                   ; i /  tmp2 = number of bytes to fill
0220                       ;-------------------------------------------------------
0221                       ; Exit
0222                       ;-------------------------------------------------------
0223               pane.action.colorscheme.errline.exit:
0224 738C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0225 738E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0226 7390 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0227 7392 C2F9  30         mov   *stack+,r11           ; Pop R11
0228 7394 045B  20         b     *r11                  ; Return to caller
0229               
**** **** ****     > stevie_b1.asm.149718
0078                                                   ; Colorscheme handling in panges
0079                       copy  "pane.utils.tipiclock.asm"
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
0021 7396 0649  14         dect  stack
0022 7398 C64B  30         mov   r11,*stack            ; Push return address
0023 739A 0649  14         dect  stack
0024 739C C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 739E 0204  20         li    tmp0,fdname.clock
     73A0 78E0 
0029 73A2 C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     73A4 8350 
0030               
0031 73A6 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     73A8 73C8 
0032 73AA C804  38         mov   tmp0,@parm2           ; Register callback 1
     73AC 8352 
0033 73AE C804  38         mov   tmp0,@parm3           ; Register callback 2
     73B0 8354 
0034 73B2 C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     73B4 8358 
0035               
0036 73B6 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     73B8 73CA 
0037 73BA C804  38         mov   tmp0,@parm4           ; Register callback 3
     73BC 8356 
0038               
0039 73BE 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     73C0 6E28 
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
0055 73C2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 73C4 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 73C6 045B  20         b     *r11                  ; Return to caller
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
0070 73C8 069B  24         bl    *r11                  ; Return to caller
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
0083 73CA 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0080                                                   ; TIPI clock
0081                       ;-----------------------------------------------------------------------
0082                       ; Screen panes
0083                       ;-----------------------------------------------------------------------
0084                       copy  "pane.cmdb.asm"       ; Command buffer
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
0021 73CC 0649  14         dect  stack
0022 73CE C64B  30         mov   r11,*stack            ; Save return address
0023 73D0 0649  14         dect  stack
0024 73D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 73D4 0649  14         dect  stack
0026 73D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 73D8 0649  14         dect  stack
0028 73DA C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 73DC C820  54         mov   @cmdb.yxtop,@wyx      ; \
     73DE A30E 
     73E0 832A 
0033 73E2 C160  34         mov   @cmdb.pantitle,tmp1   ; | Display pane title
     73E4 A31A 
0034 73E6 06A0  32         bl    @xutst0               ; /
     73E8 241A 
0035               
0036 73EA 06A0  32         bl    @setx
     73EC 2684 
0037 73EE 000E                   data 14               ; Position cursor
0038               
0039 73F0 06A0  32         bl    @putstr               ; Display horizontal line
     73F2 2418 
0040 73F4 77EE                   data txt.cmdb.hbar
0041                       ;------------------------------------------------------
0042                       ; Clear lines after prompt in command buffer
0043                       ;------------------------------------------------------
0044 73F6 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     73F8 A31E 
0045 73FA 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0046 73FC A120  34         a     @cmdb.yxprompt,tmp0   ; |
     73FE A310 
0047 7400 C804  38         mov   tmp0,@wyx             ; /
     7402 832A 
0048               
0049 7404 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7406 23F4 
0050                                                   ; \ i  @wyx = Cursor position
0051                                                   ; / o  tmp0 = VDP target address
0052               
0053 7408 0205  20         li    tmp1,32
     740A 0020 
0054               
0055 740C C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     740E A31E 
0056 7410 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0057 7412 0506  16         neg   tmp2                  ; | Based on command & prompt length
0058 7414 0226  22         ai    tmp2,2*80 - 1         ; /
     7416 009F 
0059               
0060 7418 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     741A 228E 
0061                                                   ; | i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = Byte to fill
0063                                                   ; / i  tmp2 = Number of bytes to fill
0064                       ;------------------------------------------------------
0065                       ; Display pane hint in command buffer
0066                       ;------------------------------------------------------
0067 741C 06A0  32         bl    @at                   ; \
     741E 266E 
0068 7420 1C00                   byte 28,0             ; | Display pane hint
0069 7422 C160  34         mov   @cmdb.panhint,tmp1    ; |
     7424 A31C 
0070 7426 06A0  32         bl    @xutst0               ; /
     7428 241A 
0071                       ;------------------------------------------------------
0072                       ; Display keys in status line
0073                       ;------------------------------------------------------
0074 742A D120  34         movb  @txt.keys.loaddv80,tmp0
     742C 772A 
0075                                                   ; Get length byte of hint
0076 742E 0984  56         srl   tmp0,8                ; Right justify
0077 7430 C184  18         mov   tmp0,tmp2
0078 7432 0506  16         neg   tmp2
0079 7434 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7436 0050 
0080 7438 0224  22         ai    tmp0,>0910            ; VDP start address (bottom status line)
     743A 0910 
0081 743C 0205  20         li    tmp1,32               ; Byte to fill
     743E 0020 
0082               
0083 7440 06A0  32         bl    @xfilv                ; Clear line
     7442 228E 
0084                                                   ; i \  tmp0 = start address
0085                                                   ; i |  tmp1 = byte to fill
0086                                                   ; i /  tmp2 = number of bytes to fill
0087               
0088 7444 06A0  32         bl    @putat                ; Display key hint
     7446 242A 
0089 7448 1D00                   byte 29,0
0090 744A 772A                   data txt.keys.loaddv80
0091                       ;------------------------------------------------------
0092                       ; Command buffer content
0093                       ;------------------------------------------------------
0094 744C 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     744E 6D80 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               pane.cmdb.exit:
0099 7450 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 7452 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 7454 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7456 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7458 045B  20         b     *r11                  ; Return
0104               
0105               
0106               ***************************************************************
0107               * pane.cmdb.show
0108               * Show command buffer pane
0109               ***************************************************************
0110               * bl @pane.cmdb.show
0111               *--------------------------------------------------------------
0112               * INPUT
0113               * none
0114               *--------------------------------------------------------------
0115               * OUTPUT
0116               * none
0117               *--------------------------------------------------------------
0118               * Register usage
0119               * none
0120               *--------------------------------------------------------------
0121               * Notes
0122               ********|*****|*********************|**************************
0123               pane.cmdb.show:
0124 745A 0649  14         dect  stack
0125 745C C64B  30         mov   r11,*stack            ; Save return address
0126 745E 0649  14         dect  stack
0127 7460 C644  30         mov   tmp0,*stack           ; Push tmp0
0128                       ;------------------------------------------------------
0129                       ; Show command buffer pane
0130                       ;------------------------------------------------------
0131 7462 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7464 832A 
     7466 A304 
0132                                                   ; Save YX position in frame buffer
0133               
0134 7468 C120  34         mov   @fb.scrrows.max,tmp0
     746A A11A 
0135 746C 6120  34         s     @cmdb.scrrows,tmp0
     746E A306 
0136 7470 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7472 A118 
0137               
0138 7474 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0139 7476 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7478 A30E 
0140               
0141 747A 0224  22         ai    tmp0,>0100
     747C 0100 
0142 747E C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7480 A310 
0143 7482 0584  14         inc   tmp0
0144 7484 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7486 A30A 
0145               
0146 7488 0720  34         seto  @cmdb.visible         ; Show pane
     748A A302 
0147 748C 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     748E A318 
0148               
0149 7490 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7492 0001 
0150 7494 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7496 A01A 
0151               
0152 7498 06A0  32         bl    @cmdb.cmd.clear;      ; Clear current command
     749A 6DD2 
0153               
0154 749C 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     749E 7512 
0155               
0156 74A0 06A0  32         bl    @pane.action.colorscheme.load
     74A2 72C0 
0157                                                   ; Reload colorscheme
0158               pane.cmdb.show.exit:
0159                       ;------------------------------------------------------
0160                       ; Exit
0161                       ;------------------------------------------------------
0162 74A4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0163 74A6 C2F9  30         mov   *stack+,r11           ; Pop r11
0164 74A8 045B  20         b     *r11                  ; Return to caller
0165               
0166               
0167               
0168               ***************************************************************
0169               * pane.cmdb.hide
0170               * Hide command buffer pane
0171               ***************************************************************
0172               * bl @pane.cmdb.hide
0173               *--------------------------------------------------------------
0174               * INPUT
0175               * none
0176               *--------------------------------------------------------------
0177               * OUTPUT
0178               * none
0179               *--------------------------------------------------------------
0180               * Register usage
0181               * none
0182               *--------------------------------------------------------------
0183               * Hiding the command buffer automatically passes pane focus
0184               * to frame buffer.
0185               ********|*****|*********************|**************************
0186               pane.cmdb.hide:
0187 74AA 0649  14         dect  stack
0188 74AC C64B  30         mov   r11,*stack            ; Save return address
0189                       ;------------------------------------------------------
0190                       ; Hide command buffer pane
0191                       ;------------------------------------------------------
0192 74AE C820  54         mov   @fb.scrrows.max,@fb.scrrows
     74B0 A11A 
     74B2 A118 
0193                       ;------------------------------------------------------
0194                       ; Adjust frame buffer size if error pane visible
0195                       ;------------------------------------------------------
0196 74B4 C820  54         mov   @tv.error.visible,@tv.error.visible
     74B6 A01C 
     74B8 A01C 
0197 74BA 1302  14         jeq   !
0198 74BC 0620  34         dec   @fb.scrrows
     74BE A118 
0199                       ;------------------------------------------------------
0200                       ; Clear error/hint & status line
0201                       ;------------------------------------------------------
0202 74C0 06A0  32 !       bl    @hchar
     74C2 2762 
0203 74C4 1C00                   byte 28,0,32,80*2
     74C6 20A0 
0204 74C8 FFFF                   data EOL
0205                       ;------------------------------------------------------
0206                       ; Hide command buffer pane (rest)
0207                       ;------------------------------------------------------
0208 74CA C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     74CC A304 
     74CE 832A 
0209 74D0 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     74D2 A302 
0210 74D4 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     74D6 A116 
0211 74D8 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     74DA A01A 
0212                       ;------------------------------------------------------
0213                       ; Exit
0214                       ;------------------------------------------------------
0215               pane.cmdb.hide.exit:
0216 74DC C2F9  30         mov   *stack+,r11           ; Pop r11
0217 74DE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0085                       copy  "pane.errline.asm"    ; Error line
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
0026 74E0 0649  14         dect  stack
0027 74E2 C64B  30         mov   r11,*stack            ; Save return address
0028 74E4 0649  14         dect  stack
0029 74E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 74E8 0649  14         dect  stack
0031 74EA C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 74EC 0205  20         li    tmp1,>00f6            ; White on dark red
     74EE 00F6 
0034 74F0 06A0  32         bl    @pane.action.colorscheme.errline
     74F2 7370 
0035                       ;------------------------------------------------------
0036                       ; Show error line content
0037                       ;------------------------------------------------------
0038 74F4 06A0  32         bl    @putat                ; Display error message
     74F6 242A 
0039 74F8 1C00                   byte 28,0
0040 74FA A01E                   data tv.error.msg
0041               
0042 74FC C120  34         mov   @fb.scrrows.max,tmp0
     74FE A11A 
0043 7500 0604  14         dec   tmp0
0044 7502 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7504 A118 
0045               
0046 7506 0720  34         seto  @tv.error.visible     ; Error line is visible
     7508 A01C 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               pane.errline.show.exit:
0051 750A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 750C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 750E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 7510 045B  20         b     *r11                  ; Return to caller
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
0076 7512 0649  14         dect  stack
0077 7514 C64B  30         mov   r11,*stack            ; Save return address
0078                       ;------------------------------------------------------
0079                       ; Hide command buffer pane
0080                       ;------------------------------------------------------
0081 7516 06A0  32 !       bl    @errline.init         ; Clear error line
     7518 6E04 
0082 751A C160  34         mov   @tv.color,tmp1        ; Get foreground/background color
     751C A018 
0083 751E 06A0  32         bl    @pane.action.colorscheme.errline
     7520 7370 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.errline.hide.exit:
0088 7522 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 7524 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.149718
0086                       copy  "pane.botline.asm"    ; Status line
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
0021 7526 0649  14         dect  stack
0022 7528 C64B  30         mov   r11,*stack            ; Save return address
0023 752A 0649  14         dect  stack
0024 752C C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 752E C820  54         mov   @wyx,@fb.yxsave
     7530 832A 
     7532 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 7534 06A0  32         bl    @putat
     7536 242A 
0032 7538 1D00                   byte  29,0
0033 753A 770E                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 753C 06A0  32         bl    @at
     753E 266E 
0039 7540 1D03                   byte  29,3            ; Position cursor
0040 7542 C160  34         mov   @edb.filename.ptr,tmp1
     7544 A20E 
0041                                                   ; Get string to display
0042 7546 06A0  32         bl    @xutst0               ; Display string
     7548 241A 
0043               
0044 754A 06A0  32         bl    @at
     754C 266E 
0045 754E 1D2C                   byte  29,44           ; Position cursor
0046               
0047 7550 C160  34         mov   @edb.filetype.ptr,tmp1
     7552 A210 
0048                                                   ; Get string to display
0049 7554 06A0  32         bl    @xutst0               ; Display Filetype string
     7556 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 7558 C120  34         mov   @edb.insmode,tmp0
     755A A20A 
0055 755C 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 755E 06A0  32         bl    @putat
     7560 242A 
0061 7562 1D32                   byte  29,50
0062 7564 76EA                   data  txt.ovrwrite
0063 7566 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 7568 06A0  32         bl    @putat
     756A 242A 
0069 756C 1D32                   byte  29,50
0070 756E 76EE                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7570 C120  34         mov   @edb.dirty,tmp0
     7572 A206 
0076 7574 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7576 06A0  32         bl    @putat
     7578 242A 
0081 757A 1D36                   byte 29,54
0082 757C 76F2                   data txt.star
0083 757E 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7580 1000  14         nop
0089               pane.botline.show_linecol:
0090 7582 C820  54         mov   @fb.row,@parm1
     7584 A106 
     7586 8350 
0091 7588 06A0  32         bl    @fb.row2line
     758A 67E8 
0092 758C 05A0  34         inc   @outparm1
     758E 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7590 06A0  32         bl    @putnum
     7592 29EE 
0097 7594 1D40                   byte  29,64           ; YX
0098 7596 8360                   data  outparm1,rambuf
     7598 8390 
0099 759A 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 759C 06A0  32         bl    @putat
     759E 242A 
0105 75A0 1D45                   byte  29,69
0106 75A2 76DC                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 75A4 06A0  32         bl    @film
     75A6 2230 
0111 75A8 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     75AA 0020 
     75AC 000C 
0112               
0113 75AE C820  54         mov   @fb.column,@waux1
     75B0 A10C 
     75B2 833C 
0114 75B4 05A0  34         inc   @waux1                ; Offset 1
     75B6 833C 
0115               
0116 75B8 06A0  32         bl    @mknum                ; Convert unsigned number to string
     75BA 2970 
0117 75BC 833C                   data  waux1,rambuf
     75BE 8390 
0118 75C0 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 75C2 06A0  32         bl    @trimnum              ; Trim number to the left
     75C4 29C8 
0122 75C6 8390                   data  rambuf,rambuf+6,32
     75C8 8396 
     75CA 0020 
0123               
0124 75CC 0204  20         li    tmp0,>0200
     75CE 0200 
0125 75D0 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     75D2 8396 
0126               
0127 75D4 06A0  32         bl    @putat
     75D6 242A 
0128 75D8 1D46                   byte 29,70
0129 75DA 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 75DC C820  54         mov   @fb.row,@parm1
     75DE A106 
     75E0 8350 
0134 75E2 06A0  32         bl    @fb.row2line
     75E4 67E8 
0135 75E6 8820  54         c     @edb.lines,@outparm1
     75E8 A204 
     75EA 8360 
0136 75EC 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 75EE 06A0  32         bl    @putat
     75F0 242A 
0139 75F2 1D4B                   byte 29,75
0140 75F4 76E4                   data txt.bottom
0141               
0142 75F6 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 75F8 C820  54         mov   @edb.lines,@waux1
     75FA A204 
     75FC 833C 
0148 75FE 05A0  34         inc   @waux1                ; Offset 1
     7600 833C 
0149 7602 06A0  32         bl    @putnum
     7604 29EE 
0150 7606 1D4B                   byte 29,75            ; YX
0151 7608 833C                   data waux1,rambuf
     760A 8390 
0152 760C 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 760E C820  54         mov   @fb.yxsave,@wyx
     7610 A114 
     7612 832A 
0159 7614 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 7616 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7618 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.149718
0087                       ;-----------------------------------------------------------------------
0088                       ; Program data
0089                       ;-----------------------------------------------------------------------
0090                       copy  "data.constants.asm"  ; Data segment - Constants
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
0033 761A 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     761C 003F 
     761E 0243 
     7620 05F4 
     7622 0050 
0034               
0035               romsat:
0036 7624 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     7626 0001 
0037               
0038               cursors:
0039 7628 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     762A 0000 
     762C 0000 
     762E 001C 
0040 7630 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     7632 1010 
     7634 1010 
     7636 1000 
0041 7638 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     763A 1C1C 
     763C 1C1C 
     763E 1C00 
0042               
0043               patterns:
0044 7640 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     7642 0000 
     7644 00FF 
     7646 0000 
0045 7648 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     764A 0000 
     764C FF00 
     764E FF00 
0046               patterns.box:
0047 7650 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     7652 0000 
     7654 FF00 
     7656 FF00 
0048 7658 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     765A 0000 
     765C FF80 
     765E BFA0 
0049 7660 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     7662 0000 
     7664 FC04 
     7666 F414 
0050 7668 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     766A A0A0 
     766C A0A0 
     766E A0A0 
0051 7670 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     7672 1414 
     7674 1414 
     7676 1414 
0052 7678 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     767A A0A0 
     767C BF80 
     767E FF00 
0053 7680 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     7682 1414 
     7684 F404 
     7686 FC00 
0054 7688 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     768A C0C0 
     768C C0C0 
     768E 0080 
0055 7690 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     7692 0F0F 
     7694 0F0F 
     7696 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 7698 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     769A 0002 
0065 769C 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     769E 0003 
0066 76A0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     76A2 000A 
0067               
0068 76A4 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     76A6 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 76A8 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     76AA 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 76AC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     76AE 000D 
0077 76B0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     76B2 000E 
0078 76B4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     76B6 000F 
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
0104 76B8 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     76BA F001 
0105 76BC F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     76BE F00F 
0106 76C0 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     76C2 F00F 
0107 76C4 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     76C6 F00F 
0108 76C8 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     76CA F00F 
0109 76CC 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     76CE 1006 
0110 76D0 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     76D2 1001 
0111 76D4 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     76D6 1A0F 
0112 76D8 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     76DA F20F 
0113               
**** **** ****     > stevie_b1.asm.149718
0091                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 76DC 012C             byte  1
0013 76DD ....             text  ','
0014                       even
0015               
0016               txt.marker
0017 76DE 052A             byte  5
0018 76DF ....             text  '*EOF*'
0019                       even
0020               
0021               txt.bottom
0022 76E4 0520             byte  5
0023 76E5 ....             text  '  BOT'
0024                       even
0025               
0026               txt.ovrwrite
0027 76EA 034F             byte  3
0028 76EB ....             text  'OVR'
0029                       even
0030               
0031               txt.insert
0032 76EE 0349             byte  3
0033 76EF ....             text  'INS'
0034                       even
0035               
0036               txt.star
0037 76F2 012A             byte  1
0038 76F3 ....             text  '*'
0039                       even
0040               
0041               txt.loading
0042 76F4 0A4C             byte  10
0043 76F5 ....             text  'Loading...'
0044                       even
0045               
0046               txt.kb
0047 7700 026B             byte  2
0048 7701 ....             text  'kb'
0049                       even
0050               
0051               txt.rle
0052 7704 0352             byte  3
0053 7705 ....             text  'RLE'
0054                       even
0055               
0056               txt.lines
0057 7708 054C             byte  5
0058 7709 ....             text  'Lines'
0059                       even
0060               
0061               txt.bufnum
0062 770E 0323             byte  3
0063 770F ....             text  '#1 '
0064                       even
0065               
0066               txt.newfile
0067 7712 0A5B             byte  10
0068 7713 ....             text  '[New file]'
0069                       even
0070               
0071               txt.filetype.dv80
0072 771E 0444             byte  4
0073 771F ....             text  'DV80'
0074                       even
0075               
0076               txt.filetype.none
0077 7724 0420             byte  4
0078 7725 ....             text  '    '
0079                       even
0080               
0081               
0082               
0083               txt.keys.loaddv80
0084 772A 2D46             byte  45
0085 772B ....             text  'FCTN-9=Back    FCTN-E=Previous    FCTN-X=Next'
0086                       even
0087               
0088               
0089               
0090               
0091               ;--------------------------------------------------------------
0092               ; Strings for error line pane
0093               ;--------------------------------------------------------------
0094               txt.ioerr
0095 7758 2049             byte  32
0096 7759 ....             text  'I/O error. Failed loading file: '
0097                       even
0098               
0099               
0100               
0101               ;--------------------------------------------------------------
0102               ; Strings for command buffer
0103               ;--------------------------------------------------------------
0104               txt.cmdb.title
0105 777A 0E43             byte  14
0106 777B ....             text  'Command buffer'
0107                       even
0108               
0109               txt.cmdb.prompt
0110 778A 013E             byte  1
0111 778B ....             text  '>'
0112                       even
0113               
0114               txt.cmdb.loaddv80
0115 778C 0E4C             byte  14
0116 778D ....             text  'Load DV80 file'
0117                       even
0118               
0119               
0120 779C 5048     txt.cmdb.hintdv80  byte    80
0121 779D ....                        text    'HINT: Specify disk device, path/filename and press '
0122 77D0 ....                        text    'ENTER.                        '
0123                                  even
0124               
0125 77EE 4201     txt.cmdb.hbar      byte    66
0126 77F0 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     77F2 0101 
     77F4 0101 
     77F6 0101 
     77F8 0101 
     77FA 0101 
     77FC 0101 
     77FE 0101 
     7800 0101 
     7802 0101 
0127 7804 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     7806 0101 
     7808 0101 
     780A 0101 
     780C 0101 
     780E 0101 
     7810 0101 
     7812 0101 
     7814 0101 
     7816 0101 
0128 7818 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     781A 0101 
     781C 0101 
     781E 0101 
     7820 0101 
     7822 0101 
     7824 0101 
     7826 0101 
     7828 0101 
     782A 0101 
0129 782C 0101                        byte    1,1,1,1,1,1
     782E 0101 
     7830 0100 
0130                                  even
0131               
0132               
0133               
0134 7832 0C0A     txt.stevie         byte    12
0135                                  byte    10
0136 7834 ....                        text    'stevie v1.00'
0137 7840 0B00                        byte    11
0138                                  even
0139               
0140               fdname1
0141 7842 0850             byte  8
0142 7843 ....             text  'PI.CLOCK'
0143                       even
0144               
0145               fdname2
0146 784C 0E54             byte  14
0147 784D ....             text  'TIPI.TIVI.NR80'
0148                       even
0149               
0150               fdname3
0151 785C 0C44             byte  12
0152 785D ....             text  'DSK1.XBEADOC'
0153                       even
0154               
0155               fdname4
0156 786A 1154             byte  17
0157 786B ....             text  'TIPI.TIVI.C99MAN1'
0158                       even
0159               
0160               fdname5
0161 787C 1154             byte  17
0162 787D ....             text  'TIPI.TIVI.C99MAN2'
0163                       even
0164               
0165               fdname6
0166 788E 1154             byte  17
0167 788F ....             text  'TIPI.TIVI.C99MAN3'
0168                       even
0169               
0170               fdname7
0171 78A0 1254             byte  18
0172 78A1 ....             text  'TIPI.TIVI.C99SPECS'
0173                       even
0174               
0175               fdname8
0176 78B4 1254             byte  18
0177 78B5 ....             text  'TIPI.TIVI.RANDOM#C'
0178                       even
0179               
0180               fdname9
0181 78C8 0D44             byte  13
0182 78C9 ....             text  'DSK1.INVADERS'
0183                       even
0184               
0185               fdname0
0186 78D6 0944             byte  9
0187 78D7 ....             text  'DSK1.NR80'
0188                       even
0189               
0190               fdname.clock
0191 78E0 0850             byte  8
0192 78E1 ....             text  'PI.CLOCK'
0193                       even
0194               
0195               
0196               
0197               *---------------------------------------------------------------
0198               * Keyboard labels - Function keys
0199               *---------------------------------------------------------------
0200               txt.fctn.0
0201 78EA 0866             byte  8
0202 78EB ....             text  'fctn + 0'
0203                       even
0204               
0205               txt.fctn.1
0206 78F4 0866             byte  8
0207 78F5 ....             text  'fctn + 1'
0208                       even
0209               
0210               txt.fctn.2
0211 78FE 0866             byte  8
0212 78FF ....             text  'fctn + 2'
0213                       even
0214               
0215               txt.fctn.3
0216 7908 0866             byte  8
0217 7909 ....             text  'fctn + 3'
0218                       even
0219               
0220               txt.fctn.4
0221 7912 0866             byte  8
0222 7913 ....             text  'fctn + 4'
0223                       even
0224               
0225               txt.fctn.5
0226 791C 0866             byte  8
0227 791D ....             text  'fctn + 5'
0228                       even
0229               
0230               txt.fctn.6
0231 7926 0866             byte  8
0232 7927 ....             text  'fctn + 6'
0233                       even
0234               
0235               txt.fctn.7
0236 7930 0866             byte  8
0237 7931 ....             text  'fctn + 7'
0238                       even
0239               
0240               txt.fctn.8
0241 793A 0866             byte  8
0242 793B ....             text  'fctn + 8'
0243                       even
0244               
0245               txt.fctn.9
0246 7944 0866             byte  8
0247 7945 ....             text  'fctn + 9'
0248                       even
0249               
0250               txt.fctn.a
0251 794E 0866             byte  8
0252 794F ....             text  'fctn + a'
0253                       even
0254               
0255               txt.fctn.b
0256 7958 0866             byte  8
0257 7959 ....             text  'fctn + b'
0258                       even
0259               
0260               txt.fctn.c
0261 7962 0866             byte  8
0262 7963 ....             text  'fctn + c'
0263                       even
0264               
0265               txt.fctn.d
0266 796C 0866             byte  8
0267 796D ....             text  'fctn + d'
0268                       even
0269               
0270               txt.fctn.e
0271 7976 0866             byte  8
0272 7977 ....             text  'fctn + e'
0273                       even
0274               
0275               txt.fctn.f
0276 7980 0866             byte  8
0277 7981 ....             text  'fctn + f'
0278                       even
0279               
0280               txt.fctn.g
0281 798A 0866             byte  8
0282 798B ....             text  'fctn + g'
0283                       even
0284               
0285               txt.fctn.h
0286 7994 0866             byte  8
0287 7995 ....             text  'fctn + h'
0288                       even
0289               
0290               txt.fctn.i
0291 799E 0866             byte  8
0292 799F ....             text  'fctn + i'
0293                       even
0294               
0295               txt.fctn.j
0296 79A8 0866             byte  8
0297 79A9 ....             text  'fctn + j'
0298                       even
0299               
0300               txt.fctn.k
0301 79B2 0866             byte  8
0302 79B3 ....             text  'fctn + k'
0303                       even
0304               
0305               txt.fctn.l
0306 79BC 0866             byte  8
0307 79BD ....             text  'fctn + l'
0308                       even
0309               
0310               txt.fctn.m
0311 79C6 0866             byte  8
0312 79C7 ....             text  'fctn + m'
0313                       even
0314               
0315               txt.fctn.n
0316 79D0 0866             byte  8
0317 79D1 ....             text  'fctn + n'
0318                       even
0319               
0320               txt.fctn.o
0321 79DA 0866             byte  8
0322 79DB ....             text  'fctn + o'
0323                       even
0324               
0325               txt.fctn.p
0326 79E4 0866             byte  8
0327 79E5 ....             text  'fctn + p'
0328                       even
0329               
0330               txt.fctn.q
0331 79EE 0866             byte  8
0332 79EF ....             text  'fctn + q'
0333                       even
0334               
0335               txt.fctn.r
0336 79F8 0866             byte  8
0337 79F9 ....             text  'fctn + r'
0338                       even
0339               
0340               txt.fctn.s
0341 7A02 0866             byte  8
0342 7A03 ....             text  'fctn + s'
0343                       even
0344               
0345               txt.fctn.t
0346 7A0C 0866             byte  8
0347 7A0D ....             text  'fctn + t'
0348                       even
0349               
0350               txt.fctn.u
0351 7A16 0866             byte  8
0352 7A17 ....             text  'fctn + u'
0353                       even
0354               
0355               txt.fctn.v
0356 7A20 0866             byte  8
0357 7A21 ....             text  'fctn + v'
0358                       even
0359               
0360               txt.fctn.w
0361 7A2A 0866             byte  8
0362 7A2B ....             text  'fctn + w'
0363                       even
0364               
0365               txt.fctn.x
0366 7A34 0866             byte  8
0367 7A35 ....             text  'fctn + x'
0368                       even
0369               
0370               txt.fctn.y
0371 7A3E 0866             byte  8
0372 7A3F ....             text  'fctn + y'
0373                       even
0374               
0375               txt.fctn.z
0376 7A48 0866             byte  8
0377 7A49 ....             text  'fctn + z'
0378                       even
0379               
0380               *---------------------------------------------------------------
0381               * Keyboard labels - Function keys extra
0382               *---------------------------------------------------------------
0383               txt.fctn.dot
0384 7A52 0866             byte  8
0385 7A53 ....             text  'fctn + .'
0386                       even
0387               
0388               txt.fctn.plus
0389 7A5C 0866             byte  8
0390 7A5D ....             text  'fctn + +'
0391                       even
0392               
0393               *---------------------------------------------------------------
0394               * Keyboard labels - Control keys
0395               *---------------------------------------------------------------
0396               txt.ctrl.0
0397 7A66 0863             byte  8
0398 7A67 ....             text  'ctrl + 0'
0399                       even
0400               
0401               txt.ctrl.1
0402 7A70 0863             byte  8
0403 7A71 ....             text  'ctrl + 1'
0404                       even
0405               
0406               txt.ctrl.2
0407 7A7A 0863             byte  8
0408 7A7B ....             text  'ctrl + 2'
0409                       even
0410               
0411               txt.ctrl.3
0412 7A84 0863             byte  8
0413 7A85 ....             text  'ctrl + 3'
0414                       even
0415               
0416               txt.ctrl.4
0417 7A8E 0863             byte  8
0418 7A8F ....             text  'ctrl + 4'
0419                       even
0420               
0421               txt.ctrl.5
0422 7A98 0863             byte  8
0423 7A99 ....             text  'ctrl + 5'
0424                       even
0425               
0426               txt.ctrl.6
0427 7AA2 0863             byte  8
0428 7AA3 ....             text  'ctrl + 6'
0429                       even
0430               
0431               txt.ctrl.7
0432 7AAC 0863             byte  8
0433 7AAD ....             text  'ctrl + 7'
0434                       even
0435               
0436               txt.ctrl.8
0437 7AB6 0863             byte  8
0438 7AB7 ....             text  'ctrl + 8'
0439                       even
0440               
0441               txt.ctrl.9
0442 7AC0 0863             byte  8
0443 7AC1 ....             text  'ctrl + 9'
0444                       even
0445               
0446               txt.ctrl.a
0447 7ACA 0863             byte  8
0448 7ACB ....             text  'ctrl + a'
0449                       even
0450               
0451               txt.ctrl.b
0452 7AD4 0863             byte  8
0453 7AD5 ....             text  'ctrl + b'
0454                       even
0455               
0456               txt.ctrl.c
0457 7ADE 0863             byte  8
0458 7ADF ....             text  'ctrl + c'
0459                       even
0460               
0461               txt.ctrl.d
0462 7AE8 0863             byte  8
0463 7AE9 ....             text  'ctrl + d'
0464                       even
0465               
0466               txt.ctrl.e
0467 7AF2 0863             byte  8
0468 7AF3 ....             text  'ctrl + e'
0469                       even
0470               
0471               txt.ctrl.f
0472 7AFC 0863             byte  8
0473 7AFD ....             text  'ctrl + f'
0474                       even
0475               
0476               txt.ctrl.g
0477 7B06 0863             byte  8
0478 7B07 ....             text  'ctrl + g'
0479                       even
0480               
0481               txt.ctrl.h
0482 7B10 0863             byte  8
0483 7B11 ....             text  'ctrl + h'
0484                       even
0485               
0486               txt.ctrl.i
0487 7B1A 0863             byte  8
0488 7B1B ....             text  'ctrl + i'
0489                       even
0490               
0491               txt.ctrl.j
0492 7B24 0863             byte  8
0493 7B25 ....             text  'ctrl + j'
0494                       even
0495               
0496               txt.ctrl.k
0497 7B2E 0863             byte  8
0498 7B2F ....             text  'ctrl + k'
0499                       even
0500               
0501               txt.ctrl.l
0502 7B38 0863             byte  8
0503 7B39 ....             text  'ctrl + l'
0504                       even
0505               
0506               txt.ctrl.m
0507 7B42 0863             byte  8
0508 7B43 ....             text  'ctrl + m'
0509                       even
0510               
0511               txt.ctrl.n
0512 7B4C 0863             byte  8
0513 7B4D ....             text  'ctrl + n'
0514                       even
0515               
0516               txt.ctrl.o
0517 7B56 0863             byte  8
0518 7B57 ....             text  'ctrl + o'
0519                       even
0520               
0521               txt.ctrl.p
0522 7B60 0863             byte  8
0523 7B61 ....             text  'ctrl + p'
0524                       even
0525               
0526               txt.ctrl.q
0527 7B6A 0863             byte  8
0528 7B6B ....             text  'ctrl + q'
0529                       even
0530               
0531               txt.ctrl.r
0532 7B74 0863             byte  8
0533 7B75 ....             text  'ctrl + r'
0534                       even
0535               
0536               txt.ctrl.s
0537 7B7E 0863             byte  8
0538 7B7F ....             text  'ctrl + s'
0539                       even
0540               
0541               txt.ctrl.t
0542 7B88 0863             byte  8
0543 7B89 ....             text  'ctrl + t'
0544                       even
0545               
0546               txt.ctrl.u
0547 7B92 0863             byte  8
0548 7B93 ....             text  'ctrl + u'
0549                       even
0550               
0551               txt.ctrl.v
0552 7B9C 0863             byte  8
0553 7B9D ....             text  'ctrl + v'
0554                       even
0555               
0556               txt.ctrl.w
0557 7BA6 0863             byte  8
0558 7BA7 ....             text  'ctrl + w'
0559                       even
0560               
0561               txt.ctrl.x
0562 7BB0 0863             byte  8
0563 7BB1 ....             text  'ctrl + x'
0564                       even
0565               
0566               txt.ctrl.y
0567 7BBA 0863             byte  8
0568 7BBB ....             text  'ctrl + y'
0569                       even
0570               
0571               txt.ctrl.z
0572 7BC4 0863             byte  8
0573 7BC5 ....             text  'ctrl + z'
0574                       even
0575               
0576               *---------------------------------------------------------------
0577               * Keyboard labels - control keys extra
0578               *---------------------------------------------------------------
0579               txt.ctrl.plus
0580 7BCE 0863             byte  8
0581 7BCF ....             text  'ctrl + +'
0582                       even
0583               
0584               *---------------------------------------------------------------
0585               * Special keys
0586               *---------------------------------------------------------------
0587               txt.enter
0588 7BD8 0565             byte  5
0589 7BD9 ....             text  'enter'
0590                       even
0591               
**** **** ****     > stevie_b1.asm.149718
0092                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 7BDE 0D00             data  key.enter, txt.enter, edkey.action.enter
     7BE0 7BD8 
     7BE2 6560 
0106 7BE4 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7BE6 7A02 
     7BE8 615E 
0107 7BEA 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7BEC 796C 
     7BEE 6174 
0108 7BF0 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7BF2 7976 
     7BF4 618C 
0109 7BF6 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7BF8 7A34 
     7BFA 61DE 
0110 7BFC 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7BFE 7ACA 
     7C00 624A 
0111 7C02 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7C04 7AFC 
     7C06 6262 
0112 7C08 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7C0A 7B7E 
     7C0C 6276 
0113 7C0E 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     7C10 7AE8 
     7C12 62C8 
0114 7C14 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7C16 7AF2 
     7C18 6328 
0115 7C1A 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7C1C 7BB0 
     7C1E 636A 
0116 7C20 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7C22 7B88 
     7C24 6396 
0117 7C26 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7C28 7AD4 
     7C2A 63C2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7C2C 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7C2E 78F4 
     7C30 6402 
0122 7C32 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7C34 7B2E 
     7C36 643A 
0123 7C38 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7C3A 7908 
     7C3C 646E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 7C3E 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7C40 78FE 
     7C42 64C6 
0128 7C44 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7C46 7A52 
     7C48 65CE 
0129 7C4A 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7C4C 791C 
     7C4E 651C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 7C50 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7C52 7A5C 
     7C54 661E 
0134 7C56 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7C58 7BC4 
     7C5A 7292 
0135                       ;-------------------------------------------------------
0136                       ; Editor/File buffer keys
0137                       ;-------------------------------------------------------
0138 7C5C B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7C5E 7A66 
     7C60 6634 
0139 7C62 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7C64 7A70 
     7C66 663A 
0140 7C68 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7C6A 7A7A 
     7C6C 6640 
0141 7C6E B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7C70 7A84 
     7C72 6646 
0142 7C74 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7C76 7A8E 
     7C78 664C 
0143 7C7A B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7C7C 7A98 
     7C7E 6652 
0144 7C80 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7C82 7AA2 
     7C84 6658 
0145 7C86 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7C88 7AAC 
     7C8A 665E 
0146 7C8C 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7C8E 7AB6 
     7C90 6664 
0147 7C92 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7C94 7AC0 
     7C96 666A 
0148 7C98 8C00             data  key.ctrl.l, txt.ctrl.l, edkey.action.dialog.dv80
     7C9A 7B38 
     7C9C 6678 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 7C9E FFFF             data  EOL                           ; EOL
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
0164 7CA0 0800             data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
     7CA2 7A02 
     7CA4 668C 
0165 7CA6 0900             data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
     7CA8 796C 
     7CAA 669E 
0166 7CAC 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
     7CAE 7ACA 
     7CB0 66B2 
0167 7CB2 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
     7CB4 7AFC 
     7CB6 66C6 
0168                       ;-------------------------------------------------------
0169                       ; Modified keys
0170                       ;-------------------------------------------------------
0171 7CB8 0D00             data  key.enter, txt.enter, edkey.action.cmdb.enter
     7CBA 7BD8 
     7CBC 66F4 
0172                       ;-------------------------------------------------------
0173                       ; Other action keys
0174                       ;-------------------------------------------------------
0175 7CBE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7CC0 7A5C 
     7CC2 661E 
0176 7CC4 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
     7CC6 7944 
     7CC8 6714 
0177 7CCA 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7CCC 7BC4 
     7CCE 7292 
0178                       ;-------------------------------------------------------
0179                       ; End of list
0180                       ;-------------------------------------------------------
0181 7CD0 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.149718
0093               
0097 7CD2 7CD2                   data $                ; Bank 1 ROM size OK.
0099               
0100               *--------------------------------------------------------------
0101               * Video mode configuration
0102               *--------------------------------------------------------------
0103      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0104      0004     spfbck  equ   >04                   ; Screen background color.
0105      761A     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0106      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0107      0050     colrow  equ   80                    ; Columns per row
0108      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0109      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0110      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0111      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

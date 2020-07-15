XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.476537
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200715-476537
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
0009               * File: equates.asm                 ; Version 200715-476537
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
0051               * e000-efff    4096           Heap
0052               * f000-ffff    4096           *FREE*
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
**** **** ****     > stevie_b1.asm.476537
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
0031 6015 ....             text  'STEVIE 200715-476537'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.476537
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
     208E 2E0C 
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
     2180 2D1A 
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
0260 21DB ....             text  'Build-ID  200715-476537'
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
0125 2A7A 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A7C 05D9  26         inct  *stack                ; Skip "data P1"
0127 2A7E 0649  14         dect  stack
0128 2A80 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2A82 0649  14         dect  stack
0130 2A84 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2A86 0649  14         dect  stack
0132 2A88 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2A8A C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2A8C C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2A8E 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2A90 0649  14         dect  stack
0144 2A92 C64B  30         mov   r11,*stack            ; Save return address
0145 2A94 0649  14         dect  stack
0146 2A96 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2A98 0649  14         dect  stack
0148 2A9A C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2A9C 0649  14         dect  stack
0150 2A9E C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AA0 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AA2 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AA4 0586  14         inc   tmp2
0161 2AA6 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AA8 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2AAA 0286  22         ci    tmp2,255
     2AAC 00FF 
0167 2AAE 1505  14         jgt   string.getlenc.panic
0168 2AB0 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AB2 0606  14         dec   tmp2                  ; One time adjustment
0174 2AB4 C806  38         mov   tmp2,@waux1           ; Store length
     2AB6 833C 
0175 2AB8 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2ABA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ABC FFCE 
0181 2ABE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AC0 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AC2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AC4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AC6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2ACA 045B  20         b     *r11                  ; Return to caller
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
0022 2ACC C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2ACE 3E00 
0023 2AD0 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2AD2 3E02 
0024 2AD4 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2AD6 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2AD8 0200  20         li    r0,>8306              ; Scratpad source address
     2ADA 8306 
0029 2ADC 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2ADE 3E06 
0030 2AE0 0202  20         li    r2,62                 ; Loop counter
     2AE2 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2AE4 CC70  46         mov   *r0+,*r1+
0036 2AE6 CC70  46         mov   *r0+,*r1+
0037 2AE8 0642  14         dect  r2
0038 2AEA 16FC  14         jne   cpu.scrpad.backup.copy
0039 2AEC C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2AEE 83FE 
     2AF0 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2AF2 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2AF4 3E00 
0045 2AF6 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2AF8 3E02 
0046 2AFA C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2AFC 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2AFE 045B  20         b     *r11                  ; Return to caller
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
0070 2B00 C820  54         mov   @cpu.scrpad.tgt,@>8300
     2B02 3E00 
     2B04 8300 
0071 2B06 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2B08 3E02 
     2B0A 8302 
0072 2B0C C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2B0E 3E04 
     2B10 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2B12 C800  38         mov   r0,@cpu.scrpad.tgt
     2B14 3E00 
0077 2B16 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2B18 3E02 
0078 2B1A C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2B1C 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2B1E 0200  20         li    r0,cpu.scrpad.tgt + 6
     2B20 3E06 
0083 2B22 0201  20         li    r1,>8306
     2B24 8306 
0084 2B26 0202  20         li    r2,62
     2B28 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2B2A CC70  46         mov   *r0+,*r1+
0090 2B2C CC70  46         mov   *r0+,*r1+
0091 2B2E 0642  14         dect  r2
0092 2B30 16FC  14         jne   cpu.scrpad.restore.copy
0093 2B32 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2B34 3EFE 
     2B36 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2B38 C020  34         mov   @cpu.scrpad.tgt,r0
     2B3A 3E00 
0099 2B3C C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2B3E 3E02 
0100 2B40 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2B42 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2B44 045B  20         b     *r11                  ; Return to caller
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
0025 2B46 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2B48 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2B4A 8300 
0031 2B4C C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2B4E 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2B50 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2B52 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2B54 0606  14         dec   tmp2
0038 2B56 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2B58 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2B5A 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2B5C 2B62 
0044                                                   ; R14=PC
0045 2B5E 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2B60 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2B62 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2B64 2B00 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2B66 045B  20         b     *r11                  ; Return to caller
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
0078 2B68 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2B6A 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2B6C 8300 
0084 2B6E 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2B70 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2B72 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2B74 0606  14         dec   tmp2
0090 2B76 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2B78 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2B7A 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2B7C 045B  20         b     *r11                  ; Return to caller
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
0041 2B7E A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2B80 2B82             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2B82 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2B84 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2B86 8322 
0049 2B88 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2B8A 2026 
0050 2B8C C020  34         mov   @>8356,r0             ; get ptr to pab
     2B8E 8356 
0051 2B90 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2B92 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2B94 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2B96 06C0  14         swpb  r0                    ;
0059 2B98 D800  38         movb  r0,@vdpa              ; send low byte
     2B9A 8C02 
0060 2B9C 06C0  14         swpb  r0                    ;
0061 2B9E D800  38         movb  r0,@vdpa              ; send high byte
     2BA0 8C02 
0062 2BA2 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2BA4 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2BA6 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2BA8 0704  14         seto  r4                    ; init counter
0070 2BAA 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2BAC A420 
0071 2BAE 0580  14 !       inc   r0                    ; point to next char of name
0072 2BB0 0584  14         inc   r4                    ; incr char counter
0073 2BB2 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2BB4 0007 
0074 2BB6 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2BB8 80C4  18         c     r4,r3                 ; end of name?
0077 2BBA 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2BBC 06C0  14         swpb  r0                    ;
0082 2BBE D800  38         movb  r0,@vdpa              ; send low byte
     2BC0 8C02 
0083 2BC2 06C0  14         swpb  r0                    ;
0084 2BC4 D800  38         movb  r0,@vdpa              ; send high byte
     2BC6 8C02 
0085 2BC8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BCA 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2BCC DC81  32         movb  r1,*r2+               ; move into buffer
0092 2BCE 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2BD0 2C92 
0093 2BD2 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2BD4 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2BD6 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2BD8 04E0  34         clr   @>83d0
     2BDA 83D0 
0102 2BDC C804  38         mov   r4,@>8354             ; save name length for search
     2BDE 8354 
0103 2BE0 0584  14         inc   r4                    ; adjust for dot
0104 2BE2 A804  38         a     r4,@>8356             ; point to position after name
     2BE4 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2BE6 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2BE8 83E0 
0110 2BEA 04C1  14         clr   r1                    ; version found of dsr
0111 2BEC 020C  20         li    r12,>0f00             ; init cru addr
     2BEE 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2BF0 C30C  18         mov   r12,r12               ; anything to turn off?
0117 2BF2 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2BF4 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2BF6 022C  22         ai    r12,>0100             ; next rom to turn on
     2BF8 0100 
0125 2BFA 04E0  34         clr   @>83d0                ; clear in case we are done
     2BFC 83D0 
0126 2BFE 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2C00 2000 
0127 2C02 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2C04 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2C06 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2C08 1D00  20         sbo   0                     ; turn on rom
0134 2C0A 0202  20         li    r2,>4000              ; start at beginning of rom
     2C0C 4000 
0135 2C0E 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2C10 2C8E 
0136 2C12 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2C14 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2C16 A40A 
0146 2C18 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2C1A C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2C1C 83D2 
0152                                                   ; subprogram
0153               
0154 2C1E 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2C20 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2C22 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2C24 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2C26 83D2 
0163                                                   ; subprogram
0164               
0165 2C28 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2C2A C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2C2C 04C5  14         clr   r5                    ; Remove any old stuff
0174 2C2E D160  34         movb  @>8355,r5             ; get length as counter
     2C30 8355 
0175 2C32 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2C34 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2C36 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2C38 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2C3A 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2C3C A420 
0186 2C3E 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2C40 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2C42 0605  14         dec   r5                    ; loop until full length checked
0191 2C44 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2C46 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2C48 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2C4A 0581  14         inc   r1                    ; next version found
0203 2C4C 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2C4E 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2C50 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2C52 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2C54 A400 
0212 2C56 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2C58 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2C5A 8322 
0214                                                   ; (8 or >a)
0215 2C5C 0281  22         ci    r1,8                  ; was it 8?
     2C5E 0008 
0216 2C60 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2C62 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2C64 8350 
0218                                                   ; Get error byte from @>8350
0219 2C66 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2C68 06C0  14         swpb  r0                    ;
0227 2C6A D800  38         movb  r0,@vdpa              ; send low byte
     2C6C 8C02 
0228 2C6E 06C0  14         swpb  r0                    ;
0229 2C70 D800  38         movb  r0,@vdpa              ; send high byte
     2C72 8C02 
0230 2C74 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C76 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2C78 09D1  56         srl   r1,13                 ; just keep error bits
0238 2C7A 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2C7C 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2C7E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C80 A400 
0248               dsrlnk.error.devicename_invalid:
0249 2C82 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2C84 06C1  14         swpb  r1                    ; put error in hi byte
0252 2C86 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2C88 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2C8A 2026 
0254 2C8C 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2C8E AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2C90 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2C92 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 2C94 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2C96 C04B  18         mov   r11,r1                ; Save return address
0049 2C98 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C9A A428 
0050 2C9C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2C9E 04C5  14         clr   tmp1                  ; io.op.open
0052 2CA0 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CA2 22C6 
0053               file.open_init:
0054 2CA4 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CA6 0009 
0055 2CA8 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CAA 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2CAC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CAE 2B7E 
0061 2CB0 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2CB2 1029  14         jmp   file.record.pab.details
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
0090 2CB4 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2CB6 C04B  18         mov   r11,r1                ; Save return address
0096 2CB8 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2CBA A428 
0097 2CBC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2CBE 0205  20         li    tmp1,io.op.close      ; io.op.close
     2CC0 0001 
0099 2CC2 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CC4 22C6 
0100               file.close_init:
0101 2CC6 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CC8 0009 
0102 2CCA C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CCC 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2CCE 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CD0 2B7E 
0108 2CD2 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2CD4 1018  14         jmp   file.record.pab.details
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
0139 2CD6 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2CD8 C04B  18         mov   r11,r1                ; Save return address
0145 2CDA C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2CDC A428 
0146 2CDE C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2CE0 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CE2 0002 
0148 2CE4 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CE6 22C6 
0149               file.record.read_init:
0150 2CE8 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CEA 0009 
0151 2CEC C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CEE 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2CF0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CF2 2B7E 
0157 2CF4 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2CF6 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2CF8 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2CFA 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2CFC 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2CFE 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2D00 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2D02 1000  14         nop
0191               
0192               
0193               file.status:
0194 2D04 1000  14         nop
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
0211 2D06 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2D08 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2D0A A428 
0219 2D0C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D0E 0005 
0220 2D10 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D12 22DE 
0221 2D14 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2D16 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0246 2D18 0451  20         b     *r1                   ; Return to caller
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
0020 2D1A 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D1C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D1E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D20 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D22 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D24 2026 
0029 2D26 1602  14         jne   tmgr1a                ; No, so move on
0030 2D28 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D2A 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D2C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D2E 202A 
0035 2D30 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D32 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D34 201A 
0048 2D36 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D38 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D3A 2018 
0050 2D3C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D3E 0460  28         b     @kthread              ; Run kernel thread
     2D40 2DB8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D42 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D44 201E 
0056 2D46 13EB  14         jeq   tmgr1
0057 2D48 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D4A 201C 
0058 2D4C 16E8  14         jne   tmgr1
0059 2D4E C120  34         mov   @wtiusr,tmp0
     2D50 832E 
0060 2D52 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D54 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D56 2DB6 
0065 2D58 C10A  18         mov   r10,tmp0
0066 2D5A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D5C 00FF 
0067 2D5E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D60 2026 
0068 2D62 1303  14         jeq   tmgr5
0069 2D64 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D66 003C 
0070 2D68 1002  14         jmp   tmgr6
0071 2D6A 0284  22 tmgr5   ci    tmp0,50
     2D6C 0032 
0072 2D6E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D70 1001  14         jmp   tmgr8
0074 2D72 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D74 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D76 832C 
0079 2D78 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D7A FF00 
0080 2D7C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D7E 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D80 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D82 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D84 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D86 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D88 830C 
     2D8A 830D 
0089 2D8C 1608  14         jne   tmgr10                ; No, get next slot
0090 2D8E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D90 FF00 
0091 2D92 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D94 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D96 8330 
0096 2D98 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D9A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D9C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D9E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2DA0 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2DA2 8315 
     2DA4 8314 
0103 2DA6 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA8 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DAA 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DAC 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DAE 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DB0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DB2 FF00 
0109 2DB4 10B4  14         jmp   tmgr1
0110 2DB6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DB8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DBA 201A 
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
0041 2DBC 06A0  32         bl    @realkb               ; Scan full keyboard
     2DBE 279C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DC0 0460  28         b     @tmgr3                ; Exit
     2DC2 2D42 
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
0017 2DC4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DC6 832E 
0018 2DC8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DCA 201C 
0019 2DCC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D1E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DCE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DD0 832E 
0029 2DD2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DD4 FEFF 
0030 2DD6 045B  20         b     *r11                  ; Return
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
0017 2DD8 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DDA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DDC C184  18         mov   tmp0,tmp2
0023 2DDE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DE0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DE2 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DE4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DE6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DEA 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DEC 202C 
0035 2DEE 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DF0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DF2 05CB  14 mkslo1  inct  r11
0041 2DF4 045B  20         b     *r11                  ; Exit
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
0052 2DF6 C13B  30 clslot  mov   *r11+,tmp0
0053 2DF8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DFA A120  34         a     @wtitab,tmp0          ; Add table base
     2DFC 832C 
0055 2DFE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2E00 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2E02 045B  20         b     *r11                  ; Exit
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
0255 2E04 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2E06 2ACC 
0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
0257               
0258 2E08 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E0A 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E0C 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E0E 0000 
0266 2E10 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E12 8300 
0267 2E14 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E16 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E18 0202  20 runli2  li    r2,>8308
     2E1A 8308 
0272 2E1C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E1E 0282  22         ci    r2,>8400
     2E20 8400 
0274 2E22 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E24 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E26 FFFF 
0279 2E28 1602  14         jne   runli4                ; No, continue
0280 2E2A 0420  54         blwp  @0                    ; Yes, bye bye
     2E2C 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E2E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E30 833C 
0285 2E32 04C1  14         clr   r1                    ; Reset counter
0286 2E34 0202  20         li    r2,10                 ; We test 10 times
     2E36 000A 
0287 2E38 C0E0  34 runli5  mov   @vdps,r3
     2E3A 8802 
0288 2E3C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E3E 202A 
0289 2E40 1302  14         jeq   runli6
0290 2E42 0581  14         inc   r1                    ; Increase counter
0291 2E44 10F9  14         jmp   runli5
0292 2E46 0602  14 runli6  dec   r2                    ; Next test
0293 2E48 16F7  14         jne   runli5
0294 2E4A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E4C 1250 
0295 2E4E 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E50 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E52 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E54 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2E56 221A 
0301 2E58 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2E5A 8322 
0302 2E5C CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0303 2E5E CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0304 2E60 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0305               *--------------------------------------------------------------
0306               * Initialize registers, memory, ...
0307               *--------------------------------------------------------------
0308 2E62 04C1  14 runli9  clr   r1
0309 2E64 04C2  14         clr   r2
0310 2E66 04C3  14         clr   r3
0311 2E68 0209  20         li    stack,>8400           ; Set stack
     2E6A 8400 
0312 2E6C 020F  20         li    r15,vdpw              ; Set VDP write address
     2E6E 8C00 
0316               *--------------------------------------------------------------
0317               * Setup video memory
0318               *--------------------------------------------------------------
0320 2E70 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E72 4A4A 
0321 2E74 1605  14         jne   runlia
0322 2E76 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E78 2288 
0323 2E7A 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2E7C 0000 
     2E7E 3FFF 
0328 2E80 06A0  32 runlia  bl    @filv
     2E82 2288 
0329 2E84 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E86 00F4 
     2E88 0010 
0330               *--------------------------------------------------------------
0331               * Check if there is a F18A present
0332               *--------------------------------------------------------------
0336 2E8A 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E8C 26E4 
0337 2E8E 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E90 26FE 
0338 2E92 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E94 26F4 
0339               
0340 2E96 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E98 232C 
0341 2E9A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0343               *--------------------------------------------------------------
0344               * Check if there is a speech synthesizer attached
0345               *--------------------------------------------------------------
0347               *       <<skipped>>
0351               *--------------------------------------------------------------
0352               * Load video mode table & font
0353               *--------------------------------------------------------------
0354 2E9C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E9E 22F2 
0355 2EA0 76F4             data  spvmod                ; Equate selected video mode table
0356 2EA2 0204  20         li    tmp0,spfont           ; Get font option
     2EA4 000C 
0357 2EA6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0358 2EA8 1304  14         jeq   runlid                ; Yes, skip it
0359 2EAA 06A0  32         bl    @ldfnt
     2EAC 235A 
0360 2EAE 1100             data  fntadr,spfont         ; Load specified font
     2EB0 000C 
0361               *--------------------------------------------------------------
0362               * Did a system crash occur before runlib was called?
0363               *--------------------------------------------------------------
0364 2EB2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EB4 4A4A 
0365 2EB6 1602  14         jne   runlie                ; No, continue
0366 2EB8 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EBA 2090 
0367               *--------------------------------------------------------------
0368               * Branch to main program
0369               *--------------------------------------------------------------
0370 2EBC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EBE 0040 
0371 2EC0 0460  28         b     @main                 ; Give control to main program
     2EC2 6050 
**** **** ****     > stevie_b1.asm.476537
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
     6092 6780 
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
0073 60A0 76FE                   data romsat,ramsat,4  ; Load sprite SAT
     60A2 8380 
     60A4 0004 
0074               
0075 60A6 C820  54         mov   @romsat+2,@tv.curshape
     60A8 7700 
     60AA A014 
0076                                                   ; Save cursor shape & color
0077               
0078 60AC 06A0  32         bl    @cpym2v
     60AE 2444 
0079 60B0 2800                   data sprpdt,cursors,3*8
     60B2 7702 
     60B4 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 60B6 06A0  32         bl    @cpym2v
     60B8 2444 
0083 60BA 1008                   data >1008,patterns,11*8
     60BC 771A 
     60BE 0058 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60C0 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60C2 6752 
0089 60C4 06A0  32         bl    @tv.reset             ; Reset editor
     60C6 6764 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60C8 06A0  32         bl    @pane.action.colorscheme.Load
     60CA 739C 
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
     60E4 2DD8 
0108 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 71EA 
0109 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 7282 
0110 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 72B6 
0111 60F2 FFFF                   data eol
0112               
0113 60F4 06A0  32         bl    @mkhook
     60F6 2DC4 
0114 60F8 71BA                   data hook.keyscan     ; Setup user hook
0115               
0116 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2D1A 
**** **** ****     > stevie_b1.asm.476537
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
     6122 7CB0 
0033 6124 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 7D72 
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
     6154 66D6 
0077                                                   ; Add character to CMDB buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6158 FFCE 
0083 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     615C 2030 
**** **** ****     > stevie_b1.asm.476537
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
     6172 71DE 
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
     618A 71DE 
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
     6196 6BCE 
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
     61B0 684E 
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
     61BE 6D66 
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
     61D8 6832 
0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61DC 71DE 
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
     61F0 6BCE 
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
     621C 684E 
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
     622A 6D66 
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
     6244 6832 
0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6248 71DE 
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
     625C 6832 
0175 625E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6260 71DE 
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
     6270 6832 
0185 6272 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6274 71DE 
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
     62C2 6832 
0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62C6 71DE 
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
     6322 6832 
0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6326 71DE 
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
     634A 6BCE 
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
     6358 684E 
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
     6388 6BCE 
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
     6394 71DE 
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
     63A0 6BCE 
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
     63B0 684E 
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
     63C0 71DE 
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
     63CC 6BCE 
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
     63EC 684E 
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
     6400 71DE 
**** **** ****     > stevie_b1.asm.476537
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
     6408 6832 
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
     6438 71DE 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 643A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     643C A206 
0055 643E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6440 6832 
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
     646C 71DE 
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
     6482 6832 
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
     649C 6AB6 
0109 649E 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64A0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64A2 C820  54         mov   @fb.topline,@parm1
     64A4 A104 
     64A6 8350 
0114 64A8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64AA 684E 
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
     64D4 6832 
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
     651A 71DE 
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
     652A 6BCE 
0213 652C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     652E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6530 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6532 6832 
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
     6548 6B40 
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
     6556 684E 
0233 6558 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     655A A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 655C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     655E 71DE 
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
     656E 6BCE 
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
     65A2 684E 
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
     65B0 68BE 
0296 65B2 C120  34         mov   @outparm1,tmp0
     65B4 8360 
0297 65B6 C804  38         mov   tmp0,@fb.column
     65B8 A10C 
0298 65BA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65BC 2698 
0299 65BE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65C0 6D66 
0300 65C2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C4 6832 
0301 65C6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65C8 A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65CA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65CC 71DE 
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
     65DC 72B6 
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
     65F2 6832 
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
     661C 71DE 
**** **** ****     > stevie_b1.asm.476537
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
     6628 71DE 
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
**** **** ****     > stevie_b1.asm.476537
0046                       copy  "edkey.fb.file.asm"   ; fb pane   - File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6634 0204  20         li   tmp0,fdname0
     6636 79A8 
0007 6638 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 663A 0204  20         li   tmp0,fdname1
     663C 7914 
0010 663E 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6640 0204  20         li   tmp0,fdname2
     6642 791E 
0013 6644 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 6646 0204  20         li   tmp0,fdname3
     6648 792E 
0016 664A 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 664C 0204  20         li   tmp0,fdname4
     664E 793C 
0019 6650 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6652 0204  20         li   tmp0,fdname5
     6654 794E 
0022 6656 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 6658 0204  20         li   tmp0,fdname6
     665A 7960 
0025 665C 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 665E 0204  20         li   tmp0,fdname7
     6660 7972 
0028 6662 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6664 0204  20         li   tmp0,fdname8
     6666 7986 
0031 6668 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 666A 0204  20         li   tmp0,fdname9
     666C 799A 
0034 666E 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 6670 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6672 707E 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 6674 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6676 6396 
**** **** ****     > stevie_b1.asm.476537
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
0009 6678 C120  34         mov   @cmdb.column,tmp0
     667A A312 
0010 667C 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 667E 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6680 A312 
0015 6682 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6684 A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 6686 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6688 71DE 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 668A 8820  54         c     @cmdb.column,@cmdb.length
     668C A312 
     668E A314 
0027 6690 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 6692 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     6694 A312 
0032 6696 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     6698 A30A 
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 669A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     669C 71DE 
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 669E 04C4  14         clr   tmp0
0045 66A0 C804  38         mov   tmp0,@cmdb.column      ; First column
     66A2 A312 
0046 66A4 0584  14         inc   tmp0
0047 66A6 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     66A8 A30A 
0048 66AA C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     66AC A30A 
0049               
0050 66AE 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66B0 71DE 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 66B2 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     66B4 A31E 
0057 66B6 0984  56         srl   tmp0,8                 ; Right justify
0058 66B8 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     66BA A312 
0059 66BC 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 66BE 0224  22         ai    tmp0,>1a00             ; Y=26
     66C0 1A00 
0061 66C2 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     66C4 A30A 
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 66C6 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66C8 71DE 
**** **** ****     > stevie_b1.asm.476537
0048                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               ***************************************************************
0006               * edkey.action.cmdb.clear
0007               * Clear current command
0008               ***************************************************************
0009               * b  @edkey.action.cmdb.clear
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               *--------------------------------------------------------------
0020               * Notes
0021               ********|*****|*********************|**************************
0022               edkey.action.cmdb.clear:
0023                       ;-------------------------------------------------------
0024                       ; Clear current command
0025                       ;-------------------------------------------------------
0026 66CA 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     66CC 6E08 
0027 66CE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66D0 A318 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.clear.exit:
0032 66D2 0460  28         b     @edkey.action.cmdb.home
     66D4 669E 
0033                                                   ; Reposition cursor
0034               
0035               
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * edkey.action.cmdb.char
0042               * Add character to command line
0043               ***************************************************************
0044               * b  @edkey.action.cmdb.char
0045               *--------------------------------------------------------------
0046               * INPUT
0047               * tmp1
0048               *--------------------------------------------------------------
0049               * OUTPUT
0050               * none
0051               *--------------------------------------------------------------
0052               * Register usage
0053               * tmp0
0054               *--------------------------------------------------------------
0055               * Notes
0056               ********|*****|*********************|**************************
0057               edkey.action.cmdb.char:
0058                       ;-------------------------------------------------------
0059                       ; Sanity checks
0060                       ;-------------------------------------------------------
0061 66D6 D105  18         movb  tmp1,tmp0             ; Get keycode
0062 66D8 0984  56         srl   tmp0,8                ; MSB to LSB
0063               
0064 66DA 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66DC 0020 
0065 66DE 1110  14         jlt   edkey.action.cmdb.char.exit
0066                                                   ; Yes, skip
0067               
0068 66E0 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     66E2 007E 
0069 66E4 150D  14         jgt   edkey.action.cmdb.char.exit
0070                                                   ; Yes, skip
0071                       ;-------------------------------------------------------
0072                       ; Add character
0073                       ;-------------------------------------------------------
0074 66E6 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66E8 A318 
0075               
0076 66EA 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     66EC A31F 
0077 66EE A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     66F0 A312 
0078 66F2 D505  30         movb  tmp1,*tmp0            ; Add character
0079 66F4 05A0  34         inc   @cmdb.column          ; Next column
     66F6 A312 
0080 66F8 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     66FA A30A 
0081               
0082 66FC 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     66FE 6E3A 
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.cmdb.char.exit:
0087 6700 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6702 71DE 
0088               
0089               
0090               
0091               
0092               *---------------------------------------------------------------
0093               * Enter
0094               *---------------------------------------------------------------
0095               edkey.action.cmdb.enter:
0096                       ;-------------------------------------------------------
0097                       ; Parse command
0098                       ;-------------------------------------------------------
0099                       ; TO BE IMPLEMENTED
0100               
0101                       ;-------------------------------------------------------
0102                       ; Exit
0103                       ;-------------------------------------------------------
0104               edkey.action.cmdb.enter.exit:
0105 6704 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6706 71DE 
**** **** ****     > stevie_b1.asm.476537
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
0009 6708 C120  34         mov   @cmdb.visible,tmp0
     670A A302 
0010 670C 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 670E 04E0  34         clr   @cmdb.column          ; Column = 0
     6710 A312 
0016 6712 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6714 7520 
0017 6716 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6718 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     671A 7570 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 671C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     671E 71DE 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.476537
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
0012 6720 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6722 7570 
0013               
0014 6724 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6726 6E3A 
0015 6728 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     672A 8360 
0016 672C 1607  14         jne   !                     ; No, load file
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 672E 06A0  32         bl    @pane.errline.show    ; Show error line
     6730 75A6 
0021               
0022 6732 06A0  32         bl    @pane.show_hint
     6734 735A 
0023 6736 1C00                   byte 28,0
0024 6738 7854                   data txt.io.nofile
0025               
0026 673A 1009  14         jmp   edkey.action.cmdb.loadfile.exit
0027                       ;-------------------------------------------------------
0028                       ; Load specified file
0029                       ;-------------------------------------------------------
0030 673C 06A0  32 !       bl    @cpym2m
     673E 248C 
0031 6740 A31E                   data cmdb.cmdlen,heap.top,80
     6742 E000 
     6744 0050 
0032                                                   ; Copy filename from command line to buffer
0033               
0034 6746 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6748 E000 
0035 674A 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     674C 707E 
0036                                                   ; \ i  tmp0 = Pointer to length-prefixed
0037                                                   ; /           device/filename string
0038                       ;-------------------------------------------------------
0039                       ; Exit
0040                       ;-------------------------------------------------------
0041               edkey.action.cmdb.loadfile.exit:
0042 674E 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6750 6396 
**** **** ****     > stevie_b1.asm.476537
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
0027 6752 0649  14         dect  stack
0028 6754 C64B  30         mov   r11,*stack            ; Save return address
0029 6756 0649  14         dect  stack
0030 6758 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 675A 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     675C A012 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               tv.init.exit:
0039 675E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6760 C2F9  30         mov   *stack+,r11           ; Pop R11
0041 6762 045B  20         b     *r11                  ; Return to caller
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
0063 6764 0649  14         dect  stack
0064 6766 C64B  30         mov   r11,*stack            ; Save return address
0065                       ;------------------------------------------------------
0066                       ; Reset editor
0067                       ;------------------------------------------------------
0068 6768 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     676A 6D84 
0069 676C 06A0  32         bl    @edb.init             ; Initialize editor buffer
     676E 6B98 
0070 6770 06A0  32         bl    @idx.init             ; Initialize index
     6772 6906 
0071 6774 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6776 67DC 
0072 6778 06A0  32         bl    @errline.init         ; Initialize error line
     677A 6E5E 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               tv.reset.exit:
0077 677C C2F9  30         mov   *stack+,r11           ; Pop R11
0078 677E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
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
0021 6780 0649  14         dect  stack
0022 6782 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 6784 06A0  32         bl    @sams.layout
     6786 2594 
0027 6788 7772                   data mem.sams.layout.data
0028               
0029 678A 06A0  32         bl    @sams.layout.copy
     678C 25F8 
0030 678E A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 6790 C820  54         mov   @tv.sams.c000,@edb.sams.page
     6792 A008 
     6794 A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 6796 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 6798 045B  20         b     *r11                  ; Return to caller
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
0064 679A C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 679C 0649  14         dect  stack
0067 679E C64B  30         mov   r11,*stack            ; Push return address
0068 67A0 0649  14         dect  stack
0069 67A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0070 67A4 0649  14         dect  stack
0071 67A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 67A8 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     67AA A204 
0076 67AC 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 67AE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     67B0 FFCE 
0082 67B2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     67B4 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 67B6 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     67B8 6A5A 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 67BA C120  34         mov   @outparm2,tmp0        ; SAMS page
     67BC 8362 
0093 67BE C160  34         mov   @outparm1,tmp1        ; Pointer to line
     67C0 8360 
0094 67C2 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 67C4 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     67C6 A008 
0101 67C8 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 67CA 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     67CC 2528 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 67CE C820  54         mov   @outparm2,@tv.sams.c000
     67D0 8362 
     67D2 A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 67D4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 67D6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 67D8 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 67DA 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.476537
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
0024 67DC 0649  14         dect  stack
0025 67DE C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 67E0 0204  20         li    tmp0,fb.top
     67E2 A600 
0030 67E4 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     67E6 A100 
0031 67E8 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     67EA A104 
0032 67EC 04E0  34         clr   @fb.row               ; Current row=0
     67EE A106 
0033 67F0 04E0  34         clr   @fb.column            ; Current column=0
     67F2 A10C 
0034               
0035 67F4 0204  20         li    tmp0,80
     67F6 0050 
0036 67F8 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     67FA A10E 
0037               
0038 67FC 0204  20         li    tmp0,29
     67FE 001D 
0039 6800 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     6802 A118 
0040 6804 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6806 A11A 
0041               
0042 6808 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     680A A01A 
0043 680C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     680E A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 6810 06A0  32         bl    @film
     6812 2230 
0048 6814 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     6816 0000 
     6818 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 681A 0460  28         b     @poprt                ; Return to caller
     681C 222C 
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
0078 681E 0649  14         dect  stack
0079 6820 C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 6822 C120  34         mov   @parm1,tmp0
     6824 8350 
0084 6826 A120  34         a     @fb.topline,tmp0
     6828 A104 
0085 682A C804  38         mov   tmp0,@outparm1
     682C 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 682E 0460  28         b    @poprt                 ; Return to caller
     6830 222C 
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
0118 6832 0649  14         dect  stack
0119 6834 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 6836 C1A0  34         mov   @fb.row,tmp2
     6838 A106 
0124 683A 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     683C A10E 
0125 683E A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     6840 A10C 
0126 6842 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     6844 A100 
0127 6846 C807  38         mov   tmp3,@fb.current
     6848 A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 684A 0460  28         b    @poprt                 ; Return to caller
     684C 222C 
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
0153 684E 0649  14         dect  stack
0154 6850 C64B  30         mov   r11,*stack            ; Push return address
0155 6852 0649  14         dect  stack
0156 6854 C644  30         mov   tmp0,*stack           ; Push tmp0
0157 6856 0649  14         dect  stack
0158 6858 C645  30         mov   tmp1,*stack           ; Push tmp1
0159 685A 0649  14         dect  stack
0160 685C C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 685E C820  54         mov   @parm1,@fb.topline
     6860 8350 
     6862 A104 
0165 6864 04E0  34         clr   @parm2                ; Target row in frame buffer
     6866 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 6868 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     686A 8350 
     686C A204 
0170 686E 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 6870 06A0  32         bl    @edb.line.unpack      ; Unpack line
     6872 6C84 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 6874 05A0  34         inc   @parm1                ; Next line in editor buffer
     6876 8350 
0180 6878 05A0  34         inc   @parm2                ; Next row in frame buffer
     687A 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 687C 8820  54         c     @parm1,@edb.lines
     687E 8350 
     6880 A204 
0185 6882 1112  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 6884 C120  34         mov   @parm2,tmp0           ; Current row
     6886 8352 
0192 6888 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     688A A118 
0193 688C 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 688E 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6890 A10E 
0195               
0196 6892 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 6894 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6896 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6898 A10E 
0200 689A A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     689C A100 
0201               
0202 689E C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 68A0 04C5  14         clr   tmp1                  ; Clear with >00 character
0204               
0205 68A2 06A0  32         bl    @xfilm                ; \ Fill memory
     68A4 2236 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 68A6 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 68A8 8820  54 !       c     @parm2,@fb.scrrows
     68AA 8352 
     68AC A118 
0214 68AE 11E0  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 68B0 0720  34         seto  @fb.dirty             ; Refresh screen
     68B2 A116 
0221 68B4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 68B6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 68B8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 68BA C2F9  30         mov   *stack+,r11           ; Pop r11
0225 68BC 045B  20         b     *r11                  ; Return to caller
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
0239 68BE 0649  14         dect  stack
0240 68C0 C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 68C2 04E0  34         clr   @fb.column
     68C4 A10C 
0245 68C6 06A0  32         bl    @fb.calc_pointer
     68C8 6832 
0246 68CA 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     68CC 6D66 
0247 68CE C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     68D0 A108 
0248 68D2 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 68D4 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     68D6 A102 
0251 68D8 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 68DA D174  28         movb  *tmp0+,tmp1           ; Get character
0257 68DC 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 68DE 0285  22         ci    tmp1,>2000            ; Whitespace?
     68E0 2000 
0260 68E2 1503  14         jgt   fb.get.firstnonblank.match
0261 68E4 0606  14         dec   tmp2                  ; Counter--
0262 68E6 16F9  14         jne   fb.get.firstnonblank.loop
0263 68E8 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 68EA 6120  34         s     @fb.current,tmp0      ; Calculate column
     68EC A102 
0269 68EE 0604  14         dec   tmp0
0270 68F0 C804  38         mov   tmp0,@outparm1        ; Save column
     68F2 8360 
0271 68F4 D805  38         movb  tmp1,@outparm2        ; Save character
     68F6 8362 
0272 68F8 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68FA 04E0  34         clr   @outparm1             ; X=0
     68FC 8360 
0278 68FE 04E0  34         clr   @outparm2             ; Null
     6900 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 6902 0460  28         b    @poprt                 ; Return to caller
     6904 222C 
**** **** ****     > stevie_b1.asm.476537
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
0050 6906 0649  14         dect  stack
0051 6908 C64B  30         mov   r11,*stack            ; Save return address
0052 690A 0649  14         dect  stack
0053 690C C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 690E 0204  20         li    tmp0,idx.top
     6910 B000 
0058 6912 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6914 A202 
0059               
0060 6916 C120  34         mov   @tv.sams.b000,tmp0
     6918 A006 
0061 691A C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     691C A500 
0062 691E C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     6920 A502 
0063 6922 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     6924 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 6926 06A0  32         bl    @film
     6928 2230 
0068 692A B000                   data idx.top,>00,idx.size
     692C 0000 
     692E 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 6930 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 6932 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6934 045B  20         b     *r11                  ; Return to caller
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
0100 6936 0649  14         dect  stack
0101 6938 C64B  30         mov   r11,*stack            ; Push return address
0102 693A 0649  14         dect  stack
0103 693C C644  30         mov   tmp0,*stack           ; Push tmp0
0104 693E 0649  14         dect  stack
0105 6940 C645  30         mov   tmp1,*stack           ; Push tmp1
0106 6942 0649  14         dect  stack
0107 6944 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6946 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6948 A502 
0112 694A 0205  20         li    tmp1,idx.top
     694C B000 
0113               
0114 694E C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     6950 A504 
0115 6952 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6954 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6956 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6958 0286  22         ci    tmp2,5                ; Crash if too many index pages
     695A 0005 
0121 695C 1104  14         jlt   !
0122 695E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6960 FFCE 
0123 6962 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6964 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6966 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6968 2528 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 696A 0584  14         inc   tmp0                  ; Next SAMS index page
0132 696C 0225  22         ai    tmp1,>1000            ; Next memory region
     696E 1000 
0133 6970 0606  14         dec   tmp2                  ; Update loop counter
0134 6972 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6974 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6976 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6978 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 697A C2F9  30         mov   *stack+,r11           ; Pop return address
0143 697C 045B  20         b     *r11                  ; Return to caller
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
0159 697E 0649  14         dect  stack
0160 6980 C64B  30         mov   r11,*stack            ; Push return address
0161 6982 0649  14         dect  stack
0162 6984 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6986 0649  14         dect  stack
0164 6988 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 698A 0649  14         dect  stack
0166 698C C646  30         mov   tmp2,*stack           ; Push tmp2
0167 698E 0649  14         dect  stack
0168 6990 C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 6992 0205  20         li    tmp1,idx.top
     6994 B000 
0173 6996 0206  20         li    tmp2,5                ; Always 5 pages
     6998 0005 
0174 699A 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     699C A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 699E C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 69A0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     69A2 2528 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 69A4 0225  22         ai    tmp1,>1000            ; Next memory region
     69A6 1000 
0185 69A8 0606  14         dec   tmp2                  ; Update loop counter
0186 69AA 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 69AC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 69AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 69B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 69B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 69B4 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 69B6 045B  20         b     *r11                  ; Return to caller
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
0220 69B8 0649  14         dect  stack
0221 69BA C64B  30         mov   r11,*stack            ; Save return address
0222 69BC 0649  14         dect  stack
0223 69BE C644  30         mov   tmp0,*stack           ; Push tmp0
0224 69C0 0649  14         dect  stack
0225 69C2 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 69C4 0649  14         dect  stack
0227 69C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 69C8 C184  18         mov   tmp0,tmp2             ; Line number
0232 69CA 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 69CC 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     69CE 0800 
0234               
0235 69D0 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 69D2 0A16  56         sla   tmp2,1                ; line number * 2
0240 69D4 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     69D6 8360 
0241               
0242 69D8 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     69DA A502 
0243 69DC 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     69DE A500 
0244               
0245 69E0 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 69E2 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     69E4 A500 
0251 69E6 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     69E8 A006 
0252               
0253 69EA C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 69EC 0205  20         li    tmp1,>b000            ; Memory window for index page
     69EE B000 
0255               
0256 69F0 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     69F2 2528 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 69F4 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     69F6 A504 
0263 69F8 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 69FA C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     69FC A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 69FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 6A00 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6A02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6A04 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6A06 045B  20         b     *r11                  ; Return to caller
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
0295 6A08 0649  14         dect  stack
0296 6A0A C64B  30         mov   r11,*stack            ; Save return address
0297 6A0C 0649  14         dect  stack
0298 6A0E C644  30         mov   tmp0,*stack           ; Push tmp0
0299 6A10 0649  14         dect  stack
0300 6A12 C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 6A14 C120  34         mov   @parm1,tmp0           ; Get line number
     6A16 8350 
0305 6A18 C160  34         mov   @parm2,tmp1           ; Get pointer
     6A1A 8352 
0306 6A1C 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 6A1E 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6A20 0FFF 
0312 6A22 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 6A24 06E0  34         swpb  @parm3
     6A26 8354 
0317 6A28 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6A2A 8354 
0318 6A2C 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6A2E 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 6A30 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A32 69B8 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 6A34 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6A36 8360 
0329 6A38 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A3A B000 
0330 6A3C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A3E 8360 
0331 6A40 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 6A42 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A44 69B8 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 6A46 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6A48 8360 
0341 6A4A 04E4  34         clr   @idx.top(tmp0)        ; /
     6A4C B000 
0342 6A4E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A50 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 6A52 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6A54 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6A56 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6A58 045B  20         b     *r11                  ; Return to caller
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
0373 6A5A 0649  14         dect  stack
0374 6A5C C64B  30         mov   r11,*stack            ; Save return address
0375 6A5E 0649  14         dect  stack
0376 6A60 C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6A62 0649  14         dect  stack
0378 6A64 C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6A66 0649  14         dect  stack
0380 6A68 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6A6A C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A6C 8350 
0385               
0386 6A6E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6A70 69B8 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6A72 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6A74 8360 
0391 6A76 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A78 B000 
0392               
0393 6A7A 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6A7C C185  18         mov   tmp1,tmp2             ; \
0399 6A7E 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6A80 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A82 00FF 
0404 6A84 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6A86 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A88 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6A8A C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A8C 8360 
0411 6A8E C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A90 8362 
0412 6A92 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6A94 04E0  34         clr   @outparm1
     6A96 8360 
0418 6A98 04E0  34         clr   @outparm2
     6A9A 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6A9C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6A9E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6AA0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6AA2 C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6AA4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
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
0025 6AA6 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6AA8 B000 
0026 6AAA C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6AAC 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6AAE CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6AB0 0606  14         dec   tmp2                  ; tmp2--
0034 6AB2 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6AB4 045B  20         b     *r11                  ; Return to caller
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
0054 6AB6 0649  14         dect  stack
0055 6AB8 C64B  30         mov   r11,*stack            ; Save return address
0056 6ABA 0649  14         dect  stack
0057 6ABC C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6ABE 0649  14         dect  stack
0059 6AC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6AC2 0649  14         dect  stack
0061 6AC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6AC6 0649  14         dect  stack
0063 6AC8 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6ACA C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6ACC 8350 
0068               
0069 6ACE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6AD0 69B8 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6AD2 C120  34         mov   @outparm1,tmp0        ; Index offset
     6AD4 8360 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6AD6 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6AD8 8352 
0078 6ADA 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6ADC 8350 
0079 6ADE 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6AE0 C1E0  34         mov   @parm2,tmp3
     6AE2 8352 
0086 6AE4 0287  22         ci    tmp3,2048
     6AE6 0800 
0087 6AE8 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6AEA 06A0  32         bl    @_idx.sams.mapcolumn.on
     6AEC 6936 
0095                                                   ; Index in continious memory region
0096               
0097 6AEE 06A0  32         bl    @_idx.entry.delete.reorg
     6AF0 6AA6 
0098                                                   ; Reorganize index
0099               
0100               
0101 6AF2 06A0  32         bl    @_idx.sams.mapcolumn.off
     6AF4 697E 
0102                                                   ; Restore memory window layout
0103               
0104 6AF6 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6AF8 06A0  32         bl    @_idx.entry.delete.reorg
     6AFA 6AA6 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6AFC 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6AFE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6B00 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6B02 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6B04 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6B06 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6B08 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
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
0025 6B0A 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6B0C 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6B0E 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6B10 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B12 FFCE 
0034 6B14 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B16 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6B18 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6B1A B000 
0039 6B1C C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6B1E 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6B20 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6B22 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6B24 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6B26 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6B28 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6B2A 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6B2C AFFE 
0050 6B2E 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6B30 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6B32 0644  14         dect  tmp0                  ; Move pointer up
0058 6B34 0645  14         dect  tmp1                  ; Move pointer up
0059 6B36 0606  14         dec   tmp2                  ; Next index entry
0060 6B38 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6B3A 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6B3C 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6B3E 045B  20         b     *r11                  ; Return to caller
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
0090 6B40 0649  14         dect  stack
0091 6B42 C64B  30         mov   r11,*stack            ; Save return address
0092 6B44 0649  14         dect  stack
0093 6B46 C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6B48 0649  14         dect  stack
0095 6B4A C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6B4C 0649  14         dect  stack
0097 6B4E C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6B50 0649  14         dect  stack
0099 6B52 C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6B54 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B56 8352 
0104 6B58 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B5A 8350 
0105 6B5C 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6B5E C1E0  34         mov   @parm2,tmp3
     6B60 8352 
0112 6B62 0287  22         ci    tmp3,2048
     6B64 0800 
0113 6B66 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6B68 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B6A 6936 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6B6C C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B6E 8352 
0125 6B70 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6B72 06A0  32         bl    @_idx.entry.insert.reorg
     6B74 6B0A 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6B76 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B78 697E 
0133                                                   ; Restore memory window layout
0134               
0135 6B7A 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6B7C C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6B7E 8352 
0141               
0142 6B80 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B82 69B8 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6B84 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B86 8360 
0147               
0148 6B88 06A0  32         bl    @_idx.entry.insert.reorg
     6B8A 6B0A 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6B8C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6B8E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6B90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6B92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6B94 C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6B96 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
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
0026 6B98 0649  14         dect  stack
0027 6B9A C64B  30         mov   r11,*stack            ; Save return address
0028 6B9C 0649  14         dect  stack
0029 6B9E C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6BA0 0204  20         li    tmp0,edb.top          ; \
     6BA2 C000 
0034 6BA4 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6BA6 A200 
0035 6BA8 C804  38         mov   tmp0,@edb.next_free.ptr
     6BAA A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6BAC 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6BAE A20A 
0039 6BB0 04E0  34         clr   @edb.lines            ; Lines=0
     6BB2 A204 
0040 6BB4 04E0  34         clr   @edb.rle              ; RLE compression off
     6BB6 A20C 
0041               
0042 6BB8 0204  20         li    tmp0,txt.newfile      ; "New file"
     6BBA 77EC 
0043 6BBC C804  38         mov   tmp0,@edb.filename.ptr
     6BBE A20E 
0044               
0045 6BC0 0204  20         li    tmp0,txt.filetype.none
     6BC2 77FE 
0046 6BC4 C804  38         mov   tmp0,@edb.filetype.ptr
     6BC6 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6BC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6BCA C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6BCC 045B  20         b     *r11                  ; Return to caller
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
0081 6BCE 0649  14         dect  stack
0082 6BD0 C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6BD2 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6BD4 A10C 
     6BD6 8390 
0087 6BD8 04E0  34         clr   @fb.column
     6BDA A10C 
0088 6BDC 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6BDE 6832 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6BE0 04C4  14         clr   tmp0                  ; Counter
0093 6BE2 C160  34         mov   @fb.current,tmp1      ; Get position
     6BE4 A102 
0094 6BE6 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6BE8 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6BEA D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6BEC 0986  56         srl   tmp2,8                ; Right justify
0102 6BEE 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6BF0 0584  14         inc   tmp0                  ; Increase string length
0104 6BF2 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6BF4 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6BF6 A104 
     6BF8 8350 
0111 6BFA A820  54         a     @fb.row,@parm1        ; /
     6BFC A106 
     6BFE 8350 
0112               
0113 6C00 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6C02 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6C04 C120  34         mov   @edb.next_free.ptr,tmp0
     6C06 A208 
0120 6C08 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6C0A 8352 
0121               
0122 6C0C 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6C0E 24F0 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6C10 C820  54         mov   @waux1,@parm3         ; Setup parm3
     6C12 833C 
     6C14 8354 
0128               
0129 6C16 06A0  32         bl    @idx.entry.update     ; Update index
     6C18 6A08 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6C1A 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6C1C A212 
     6C1E 8354 
0139 6C20 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6C22 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6C24 8354 
0142 6C26 C160  34         mov   @edb.next_free.ptr,tmp1
     6C28 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6C2A 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6C2C 2528 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6C2E C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6C30 A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6C32 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6C34 8392 
0155 6C36 C160  34         mov   @edb.next_free.ptr,tmp1
     6C38 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6C3A 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C3C A208 
0159               
0160 6C3E C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C40 8394 
0161 6C42 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6C44 06C6  14         swpb  tmp2
0163 6C46 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6C48 06C6  14         swpb  tmp2
0165 6C4A 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6C4C 0286  22         ci    tmp2,2
     6C4E 0002 
0172 6C50 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6C52 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6C54 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6C56 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6C58 0286  22         ci    tmp2,1
     6C5A 0001 
0179 6C5C 1602  14         jne   edb.line.pack.copyline.block
0180 6C5E D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6C60 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6C62 06A0  32         bl    @xpym2m               ; Copy memory block
     6C64 2492 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6C66 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6C68 8394 
     6C6A A208 
0192                                                      ; Add length of line
0193               
0194 6C6C C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6C6E A208 
0195 6C70 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0196 6C72 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6C74 000F 
0197 6C76 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6C78 A208 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               edb.line.pack.exit:
0202 6C7A C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6C7C 8390 
     6C7E A10C 
0203 6C80 0460  28         b     @poprt                ; Return to caller
     6C82 222C 
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
0232 6C84 0649  14         dect  stack
0233 6C86 C64B  30         mov   r11,*stack            ; Save return address
0234 6C88 0649  14         dect  stack
0235 6C8A C644  30         mov   tmp0,*stack           ; Push tmp0
0236 6C8C 0649  14         dect  stack
0237 6C8E C645  30         mov   tmp1,*stack           ; Push tmp1
0238 6C90 0649  14         dect  stack
0239 6C92 C646  30         mov   tmp2,*stack           ; Push tmp2
0240                       ;------------------------------------------------------
0241                       ; Sanity check
0242                       ;------------------------------------------------------
0243 6C94 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6C96 8350 
     6C98 A204 
0244 6C9A 1104  14         jlt   !
0245 6C9C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C9E FFCE 
0246 6CA0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CA2 2030 
0247                       ;------------------------------------------------------
0248                       ; Save parameters
0249                       ;------------------------------------------------------
0250 6CA4 C820  54 !       mov   @parm1,@rambuf
     6CA6 8350 
     6CA8 8390 
0251 6CAA C820  54         mov   @parm2,@rambuf+2
     6CAC 8352 
     6CAE 8392 
0252                       ;------------------------------------------------------
0253                       ; Calculate offset in frame buffer
0254                       ;------------------------------------------------------
0255 6CB0 C120  34         mov   @fb.colsline,tmp0
     6CB2 A10E 
0256 6CB4 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6CB6 8352 
0257 6CB8 C1A0  34         mov   @fb.top.ptr,tmp2
     6CBA A100 
0258 6CBC A146  18         a     tmp2,tmp1             ; Add base to offset
0259 6CBE C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6CC0 8396 
0260                       ;------------------------------------------------------
0261                       ; Get pointer to line & page-in editor buffer page
0262                       ;------------------------------------------------------
0263 6CC2 C120  34         mov   @parm1,tmp0
     6CC4 8350 
0264 6CC6 06A0  32         bl    @xmem.edb.sams.mappage
     6CC8 679C 
0265                                                   ; Activate editor buffer SAMS page for line
0266                                                   ; \ i  tmp0     = Line number
0267                                                   ; | o  outparm1 = Pointer to line
0268                                                   ; / o  outparm2 = SAMS page
0269               
0270 6CCA C820  54         mov   @outparm2,@edb.sams.page
     6CCC 8362 
     6CCE A212 
0271                                                   ; Save current SAMS page
0272                       ;------------------------------------------------------
0273                       ; Handle empty line
0274                       ;------------------------------------------------------
0275 6CD0 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6CD2 8360 
0276 6CD4 1603  14         jne   !                     ; Check if pointer is set
0277 6CD6 04E0  34         clr   @rambuf+8             ; Set length=0
     6CD8 8398 
0278 6CDA 100F  14         jmp   edb.line.unpack.clear
0279                       ;------------------------------------------------------
0280                       ; Get line length
0281                       ;------------------------------------------------------
0282 6CDC C154  26 !       mov   *tmp0,tmp1            ; Get line length
0283 6CDE C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6CE0 8398 
0284               
0285 6CE2 05E0  34         inct  @outparm1             ; Skip line prefix
     6CE4 8360 
0286 6CE6 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6CE8 8360 
     6CEA 8394 
0287                       ;------------------------------------------------------
0288                       ; Sanity check on line length
0289                       ;------------------------------------------------------
0290 6CEC 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6CEE 0050 
0291 6CF0 1204  14         jle   edb.line.unpack.clear ; /
0292               
0293 6CF2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CF4 FFCE 
0294 6CF6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CF8 2030 
0295                       ;------------------------------------------------------
0296                       ; Erase chars from last column until column 80
0297                       ;------------------------------------------------------
0298               edb.line.unpack.clear:
0299 6CFA C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6CFC 8396 
0300 6CFE A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6D00 8398 
0301               
0302 6D02 04C5  14         clr   tmp1                  ; Fill with >00
0303 6D04 C1A0  34         mov   @fb.colsline,tmp2
     6D06 A10E 
0304 6D08 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6D0A 8398 
0305 6D0C 0586  14         inc   tmp2
0306               
0307 6D0E 06A0  32         bl    @xfilm                ; Fill CPU memory
     6D10 2236 
0308                                                   ; \ i  tmp0 = Target address
0309                                                   ; | i  tmp1 = Byte to fill
0310                                                   ; / i  tmp2 = Repeat count
0311                       ;------------------------------------------------------
0312                       ; Prepare for unpacking data
0313                       ;------------------------------------------------------
0314               edb.line.unpack.prepare:
0315 6D12 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6D14 8398 
0316 6D16 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0317 6D18 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6D1A 8394 
0318 6D1C C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6D1E 8396 
0319                       ;------------------------------------------------------
0320                       ; Check before copy
0321                       ;------------------------------------------------------
0322               edb.line.unpack.copy:
0323 6D20 0286  22         ci    tmp2,80               ; Check line length
     6D22 0050 
0324 6D24 1204  14         jle   !
0325 6D26 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D28 FFCE 
0326 6D2A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D2C 2030 
0327                       ;------------------------------------------------------
0328                       ; Copy memory block
0329                       ;------------------------------------------------------
0330 6D2E 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6D30 2492 
0331                                                   ; \ i  tmp0 = Source address
0332                                                   ; | i  tmp1 = Target address
0333                                                   ; / i  tmp2 = Bytes to copy
0334                       ;------------------------------------------------------
0335                       ; Exit
0336                       ;------------------------------------------------------
0337               edb.line.unpack.exit:
0338 6D32 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0339 6D34 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0340 6D36 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0341 6D38 C2F9  30         mov   *stack+,r11           ; Pop r11
0342 6D3A 045B  20         b     *r11                  ; Return to caller
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
0366 6D3C 0649  14         dect  stack
0367 6D3E C64B  30         mov   r11,*stack            ; Push return address
0368 6D40 0649  14         dect  stack
0369 6D42 C644  30         mov   tmp0,*stack           ; Push tmp0
0370 6D44 0649  14         dect  stack
0371 6D46 C645  30         mov   tmp1,*stack           ; Push tmp1
0372                       ;------------------------------------------------------
0373                       ; Initialisation
0374                       ;------------------------------------------------------
0375 6D48 04E0  34         clr   @outparm1             ; Reset length
     6D4A 8360 
0376 6D4C 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6D4E 8362 
0377                       ;------------------------------------------------------
0378                       ; Get length
0379                       ;------------------------------------------------------
0380 6D50 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6D52 6A5A 
0381                                                   ; \ i  parm1    = Line number
0382                                                   ; | o  outparm1 = Pointer to line
0383                                                   ; / o  outparm2 = SAMS page
0384               
0385 6D54 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6D56 8360 
0386 6D58 1302  14         jeq   edb.line.getlength.exit
0387                                                   ; Exit early if NULL pointer
0388                       ;------------------------------------------------------
0389                       ; Process line prefix
0390                       ;------------------------------------------------------
0391 6D5A C814  46         mov   *tmp0,@outparm1       ; Save length
     6D5C 8360 
0392                       ;------------------------------------------------------
0393                       ; Exit
0394                       ;------------------------------------------------------
0395               edb.line.getlength.exit:
0396 6D5E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0397 6D60 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0398 6D62 C2F9  30         mov   *stack+,r11           ; Pop r11
0399 6D64 045B  20         b     *r11                  ; Return to caller
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
0419 6D66 0649  14         dect  stack
0420 6D68 C64B  30         mov   r11,*stack            ; Save return address
0421                       ;------------------------------------------------------
0422                       ; Calculate line in editor buffer
0423                       ;------------------------------------------------------
0424 6D6A C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6D6C A104 
0425 6D6E A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6D70 A106 
0426                       ;------------------------------------------------------
0427                       ; Get length
0428                       ;------------------------------------------------------
0429 6D72 C804  38         mov   tmp0,@parm1
     6D74 8350 
0430 6D76 06A0  32         bl    @edb.line.getlength
     6D78 6D3C 
0431 6D7A C820  54         mov   @outparm1,@fb.row.length
     6D7C 8360 
     6D7E A108 
0432                                                   ; Save row length
0433                       ;------------------------------------------------------
0434                       ; Exit
0435                       ;------------------------------------------------------
0436               edb.line.getlength2.exit:
0437 6D80 0460  28         b     @poprt                ; Return to caller
     6D82 222C 
0438               
**** **** ****     > stevie_b1.asm.476537
0061                       ;-----------------------------------------------------------------------
0062                       ; Command buffer handling
0063                       ;-----------------------------------------------------------------------
0064                       copy  "cmdb.asm"            ; Command buffer shared code
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
0027 6D84 0649  14         dect  stack
0028 6D86 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6D88 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6D8A D000 
0033 6D8C C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6D8E A300 
0034               
0035 6D90 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6D92 A302 
0036 6D94 0204  20         li    tmp0,4
     6D96 0004 
0037 6D98 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6D9A A306 
0038 6D9C C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6D9E A308 
0039               
0040 6DA0 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6DA2 A316 
0041 6DA4 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6DA6 A318 
0042                       ;------------------------------------------------------
0043                       ; Clear command buffer
0044                       ;------------------------------------------------------
0045 6DA8 06A0  32         bl    @film
     6DAA 2230 
0046 6DAC D000             data  cmdb.top,>00,cmdb.size
     6DAE 0000 
     6DB0 1000 
0047                                                   ; Clear it all the way
0048               cmdb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6DB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0053 6DB4 045B  20         b     *r11                  ; Return to caller
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
0079 6DB6 0649  14         dect  stack
0080 6DB8 C64B  30         mov   r11,*stack            ; Save return address
0081 6DBA 0649  14         dect  stack
0082 6DBC C644  30         mov   tmp0,*stack           ; Push tmp0
0083 6DBE 0649  14         dect  stack
0084 6DC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0085 6DC2 0649  14         dect  stack
0086 6DC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0087                       ;------------------------------------------------------
0088                       ; Dump Command buffer content
0089                       ;------------------------------------------------------
0090 6DC6 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6DC8 832A 
     6DCA A30C 
0091 6DCC C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6DCE A310 
     6DD0 832A 
0092               
0093 6DD2 05A0  34         inc   @wyx                  ; X +1 for prompt
     6DD4 832A 
0094               
0095 6DD6 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6DD8 23F4 
0096                                                   ; \ i  @wyx = Cursor position
0097                                                   ; / o  tmp0 = VDP target address
0098               
0099 6DDA 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6DDC A31F 
0100 6DDE 0206  20         li    tmp2,1*79             ; Command length
     6DE0 004F 
0101               
0102 6DE2 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6DE4 244A 
0103                                                   ; | i  tmp0 = VDP target address
0104                                                   ; | i  tmp1 = RAM source address
0105                                                   ; / i  tmp2 = Number of bytes to copy
0106                       ;------------------------------------------------------
0107                       ; Show command buffer prompt
0108                       ;------------------------------------------------------
0109 6DE6 C820  54         mov   @cmdb.yxprompt,@wyx
     6DE8 A310 
     6DEA 832A 
0110 6DEC 06A0  32         bl    @putstr
     6DEE 2418 
0111 6DF0 7886                   data txt.cmdb.prompt
0112               
0113 6DF2 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6DF4 A30C 
     6DF6 A114 
0114 6DF8 C820  54         mov   @cmdb.yxsave,@wyx
     6DFA A30C 
     6DFC 832A 
0115                                                   ; Restore YX position
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119               cmdb.refresh.exit:
0120 6DFE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6E00 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6E02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6E04 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6E06 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0065                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
0001               ***************************************************************
0002               * cmdb.cmd.clear
0003               * Clear current command
0004               ***************************************************************
0005               * bl @cmdb.cmd.clear
0006               *--------------------------------------------------------------
0007               * INPUT
0008               * none
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0,tmp1,tmp2
0015               *--------------------------------------------------------------
0016               * Notes
0017               ********|*****|*********************|**************************
0018               cmdb.cmd.clear:
0019 6E08 0649  14         dect  stack
0020 6E0A C64B  30         mov   r11,*stack            ; Save return address
0021 6E0C 0649  14         dect  stack
0022 6E0E C644  30         mov   tmp0,*stack           ; Push tmp0
0023 6E10 0649  14         dect  stack
0024 6E12 C645  30         mov   tmp1,*stack           ; Push tmp1
0025 6E14 0649  14         dect  stack
0026 6E16 C646  30         mov   tmp2,*stack           ; Push tmp2
0027                       ;------------------------------------------------------
0028                       ; Clear command
0029                       ;------------------------------------------------------
0030 6E18 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E1A A31E 
0031 6E1C 06A0  32         bl    @film                 ; Clear command
     6E1E 2230 
0032 6E20 A31F                   data  cmdb.cmd,>00,80
     6E22 0000 
     6E24 0050 
0033                       ;------------------------------------------------------
0034                       ; Put cursor at beginning of line
0035                       ;------------------------------------------------------
0036 6E26 C120  34         mov   @cmdb.yxprompt,tmp0
     6E28 A310 
0037 6E2A 0584  14         inc   tmp0
0038 6E2C C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6E2E A30A 
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               cmdb.cmd.clear.exit:
0043 6E30 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 6E32 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 6E34 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 6E36 C2F9  30         mov   *stack+,r11           ; Pop r11
0047 6E38 045B  20         b     *r11                  ; Return to caller
0048               
0049               
0050               
0051               
0052               
0053               
0054               ***************************************************************
0055               * cmdb.cmdb.getlength
0056               * Get length of current command
0057               ***************************************************************
0058               * bl @cmdb.cmd.getlength
0059               *--------------------------------------------------------------
0060               * INPUT
0061               * @cmdb.cmd
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * @cmdb.cmdlen  (Length in MSB)
0065               * @outparm1     (Length in LSB)
0066               *--------------------------------------------------------------
0067               * Register usage
0068               * tmp0
0069               *--------------------------------------------------------------
0070               * Notes
0071               ********|*****|*********************|**************************
0072               cmdb.cmd.getlength:
0073 6E3A 0649  14         dect  stack
0074 6E3C C64B  30         mov   r11,*stack            ; Save return address
0075 6E3E 0649  14         dect  stack
0076 6E40 C644  30         mov   tmp0,*stack           ; Push tmp0
0077                       ;-------------------------------------------------------
0078                       ; Get length of null terminated string
0079                       ;-------------------------------------------------------
0080 6E42 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6E44 2A76 
0081 6E46 A31F                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6E48 0000 
0082                                                  ; | i  p1    = Termination character
0083                                                  ; / o  waux1 = Length of string
0084 6E4A C120  34         mov   @waux1,tmp0
     6E4C 833C 
0085 6E4E C804  38         mov   tmp0,@outparm1       ; Save length of string
     6E50 8360 
0086 6E52 0A84  56         sla   tmp0,8               ; LSB to MSB
0087 6E54 D804  38         movb  tmp0,@cmdb.cmdlen    ; Save length of string
     6E56 A31E 
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               cmdb.cmd.getlength.exit:
0092 6E58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0093 6E5A C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6E5C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0066                       copy  "errline.asm"         ; Error line
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
0026 6E5E 0649  14         dect  stack
0027 6E60 C64B  30         mov   r11,*stack            ; Save return address
0028 6E62 0649  14         dect  stack
0029 6E64 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6E66 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6E68 A01C 
0034               
0035 6E6A 06A0  32         bl    @film
     6E6C 2230 
0036 6E6E A01E                   data tv.error.msg,0,160
     6E70 0000 
     6E72 00A0 
0037               
0038 6E74 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6E76 A000 
0039 6E78 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6E7A A01E 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6E7C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6E7E C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6E80 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.476537
0067                       ;-----------------------------------------------------------------------
0068                       ; File handling
0069                       ;-----------------------------------------------------------------------
0070                       copy  "fh.read.sams.asm"    ; File handler read file
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
0028 6E82 0649  14         dect  stack
0029 6E84 C64B  30         mov   r11,*stack            ; Save return address
0030 6E86 0649  14         dect  stack
0031 6E88 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6E8A 0649  14         dect  stack
0033 6E8C C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6E8E 0649  14         dect  stack
0035 6E90 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6E92 04E0  34         clr   @fh.records           ; Reset records counter
     6E94 A42E 
0040 6E96 04E0  34         clr   @fh.counter           ; Clear internal counter
     6E98 A434 
0041 6E9A 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6E9C A432 
0042 6E9E 04E0  34         clr   @fh.kilobytes.prev    ; /
     6EA0 A444 
0043 6EA2 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6EA4 A42A 
0044 6EA6 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6EA8 A42C 
0045               
0046 6EAA C120  34         mov   @edb.top.ptr,tmp0
     6EAC A200 
0047 6EAE 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6EB0 24F0 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6EB2 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6EB4 833C 
     6EB6 A438 
0053 6EB8 C820  54         mov   @waux1,@fh.sams.hipage
     6EBA 833C 
     6EBC A43A 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6EBE C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6EC0 8350 
     6EC2 A436 
0059 6EC4 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6EC6 8352 
     6EC8 A43C 
0060 6ECA C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6ECC 8354 
     6ECE A43E 
0061 6ED0 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6ED2 8356 
     6ED4 A440 
0062 6ED6 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6ED8 8358 
     6EDA A442 
0063                       ;------------------------------------------------------
0064                       ; Sanity check
0065                       ;------------------------------------------------------
0066 6EDC C120  34         mov   @fh.callback1,tmp0
     6EDE A43C 
0067 6EE0 0284  22         ci    tmp0,>6000            ; Insane address ?
     6EE2 6000 
0068 6EE4 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0069               
0070 6EE6 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6EE8 7FFF 
0071 6EEA 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0072               
0073 6EEC C120  34         mov   @fh.callback2,tmp0
     6EEE A43E 
0074 6EF0 0284  22         ci    tmp0,>6000            ; Insane address ?
     6EF2 6000 
0075 6EF4 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6EF6 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6EF8 7FFF 
0078 6EFA 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0079               
0080 6EFC C120  34         mov   @fh.callback3,tmp0
     6EFE A440 
0081 6F00 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F02 6000 
0082 6F04 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6F06 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F08 7FFF 
0085 6F0A 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0086               
0087 6F0C 1004  14         jmp   fh.file.read.sams.load1
0088                                                   ; All checks passed, continue.
0089                                                   ;--------------------------
0090                                                   ; Check failed, crash CPU!
0091                                                   ;--------------------------
0092               fh.file.read.crash:
0093 6F0E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F10 FFCE 
0094 6F12 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F14 2030 
0095                       ;------------------------------------------------------
0096                       ; Callback "Before Open file"
0097                       ;------------------------------------------------------
0098               fh.file.read.sams.load1:
0099 6F16 C120  34         mov   @fh.callback1,tmp0
     6F18 A43C 
0100 6F1A 0694  24         bl    *tmp0                 ; Run callback function
0101                       ;------------------------------------------------------
0102                       ; Copy PAB header to VDP
0103                       ;------------------------------------------------------
0104               fh.file.read.sams.pabheader:
0105 6F1C 06A0  32         bl    @cpym2v
     6F1E 2444 
0106 6F20 0A60                   data fh.vpab,fh.file.pab.header,9
     6F22 7074 
     6F24 0009 
0107                                                   ; Copy PAB header to VDP
0108                       ;------------------------------------------------------
0109                       ; Append file descriptor to PAB header in VDP
0110                       ;------------------------------------------------------
0111 6F26 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6F28 0A69 
0112 6F2A C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6F2C A436 
0113 6F2E D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0114 6F30 0986  56         srl   tmp2,8                ; Right justify
0115 6F32 0586  14         inc   tmp2                  ; Include length byte as well
0116 6F34 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6F36 244A 
0117                       ;------------------------------------------------------
0118                       ; Load GPL scratchpad layout
0119                       ;------------------------------------------------------
0120 6F38 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6F3A 2B46 
0121 6F3C 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0122                       ;------------------------------------------------------
0123                       ; Open file
0124                       ;------------------------------------------------------
0125 6F3E 06A0  32         bl    @file.open
     6F40 2C94 
0126 6F42 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0127 6F44 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6F46 2026 
0128 6F48 1602  14         jne   fh.file.read.sams.record
0129 6F4A 0460  28         b     @fh.file.read.sams.error
     6F4C 703C 
0130                                                   ; Yes, IO error occured
0131                       ;------------------------------------------------------
0132                       ; Step 1: Read file record
0133                       ;------------------------------------------------------
0134               fh.file.read.sams.record:
0135 6F4E 05A0  34         inc   @fh.records           ; Update counter
     6F50 A42E 
0136 6F52 04E0  34         clr   @fh.reclen            ; Reset record length
     6F54 A430 
0137               
0138 6F56 06A0  32         bl    @file.record.read     ; Read file record
     6F58 2CD6 
0139 6F5A 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0140                                                   ; |           (without +9 offset!)
0141                                                   ; | o  tmp0 = Status byte
0142                                                   ; | o  tmp1 = Bytes read
0143                                                   ; | o  tmp2 = Status register contents
0144                                                   ; /           upon DSRLNK return
0145               
0146 6F5C C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6F5E A42A 
0147 6F60 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6F62 A430 
0148 6F64 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6F66 A42C 
0149                       ;------------------------------------------------------
0150                       ; 1a: Calculate kilobytes processed
0151                       ;------------------------------------------------------
0152 6F68 A805  38         a     tmp1,@fh.counter
     6F6A A434 
0153 6F6C A160  34         a     @fh.counter,tmp1
     6F6E A434 
0154 6F70 0285  22         ci    tmp1,1024
     6F72 0400 
0155 6F74 1106  14         jlt   !
0156 6F76 05A0  34         inc   @fh.kilobytes
     6F78 A432 
0157 6F7A 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6F7C FC00 
0158 6F7E C805  38         mov   tmp1,@fh.counter
     6F80 A434 
0159                       ;------------------------------------------------------
0160                       ; 1b: Load spectra scratchpad layout
0161                       ;------------------------------------------------------
0162 6F82 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6F84 2ACC 
0163 6F86 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F88 2B68 
0164 6F8A 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0165                       ;------------------------------------------------------
0166                       ; 1c: Check if a file error occured
0167                       ;------------------------------------------------------
0168               fh.file.read.sams.check_fioerr:
0169 6F8C C1A0  34         mov   @fh.ioresult,tmp2
     6F8E A42C 
0170 6F90 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6F92 2026 
0171 6F94 1602  14         jne   fh.file.read.sams.check_setpage
0172                                                   ; No, goto (1d)
0173 6F96 0460  28         b     @fh.file.read.sams.error
     6F98 703C 
0174                                                   ; Yes, so handle file error
0175                       ;------------------------------------------------------
0176                       ; 1d: Check if SAMS page needs to be set
0177                       ;------------------------------------------------------
0178               fh.file.read.sams.check_setpage:
0179 6F9A C120  34         mov   @edb.next_free.ptr,tmp0
     6F9C A208 
0180                                                   ;--------------------------
0181                                                   ; Sanity check
0182                                                   ;--------------------------
0183 6F9E 0284  22         ci    tmp0,edb.top + edb.size
     6FA0 D000 
0184                                                   ; Insane address ?
0185 6FA2 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0186                                                   ;--------------------------
0187                                                   ; Check overflow
0188                                                   ;--------------------------
0189 6FA4 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6FA6 0FFF 
0190 6FA8 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6FAA A430 
0191 6FAC 05C4  14         inct  tmp0                  ; +2 for line prefix
0192 6FAE 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6FB0 0FF0 
0193 6FB2 110E  14         jlt   fh.file.read.sams.process_line
0194                                                   ; Not yet so skip SAMS page switch
0195                       ;------------------------------------------------------
0196                       ; 1e: Increase SAMS page
0197                       ;------------------------------------------------------
0198 6FB4 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6FB6 A438 
0199 6FB8 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6FBA A438 
     6FBC A43A 
0200                                                   ; Set highest SAMS page
0201 6FBE C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6FC0 A200 
     6FC2 A208 
0202                                                   ; Start at top of SAMS page again
0203                       ;------------------------------------------------------
0204                       ; 1f: Switch to SAMS page
0205                       ;------------------------------------------------------
0206 6FC4 C120  34         mov   @fh.sams.page,tmp0
     6FC6 A438 
0207 6FC8 C160  34         mov   @edb.top.ptr,tmp1
     6FCA A200 
0208 6FCC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6FCE 2528 
0209                                                   ; \ i  tmp0 = SAMS page number
0210                                                   ; / i  tmp1 = Memory address
0211                       ;------------------------------------------------------
0212                       ; Step 2: Process line
0213                       ;------------------------------------------------------
0214               fh.file.read.sams.process_line:
0215 6FD0 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6FD2 0960 
0216 6FD4 C160  34         mov   @edb.next_free.ptr,tmp1
     6FD6 A208 
0217                                                   ; RAM target in editor buffer
0218               
0219 6FD8 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6FDA 8352 
0220               
0221 6FDC C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6FDE A430 
0222 6FE0 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0223                                                   ; Handle empty line
0224                       ;------------------------------------------------------
0225                       ; 2a: Copy line from VDP to CPU editor buffer
0226                       ;------------------------------------------------------
0227                                                   ; Put line length word before string
0228 6FE2 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0229 6FE4 06C6  14         swpb  tmp2                  ; |
0230 6FE6 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0231 6FE8 06C6  14         swpb  tmp2                  ; /
0232               
0233 6FEA 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6FEC A208 
0234 6FEE A806  38         a     tmp2,@edb.next_free.ptr
     6FF0 A208 
0235                                                   ; Add line length
0236               
0237 6FF2 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6FF4 2470 
0238                                                   ; \ i  tmp0 = VDP source address
0239                                                   ; | i  tmp1 = RAM target address
0240                                                   ; / i  tmp2 = Bytes to copy
0241                       ;------------------------------------------------------
0242                       ; 2b: Align pointer to multiple of 16 memory address
0243                       ;------------------------------------------------------
0244 6FF6 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6FF8 A208 
0245 6FFA 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0246 6FFC 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6FFE 000F 
0247 7000 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7002 A208 
0248                       ;------------------------------------------------------
0249                       ; Step 3: Update index
0250                       ;------------------------------------------------------
0251               fh.file.read.sams.prepindex:
0252 7004 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7006 A204 
     7008 8350 
0253                                                   ; parm2 = Must allready be set!
0254 700A C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     700C A438 
     700E 8354 
0255               
0256 7010 1009  14         jmp   fh.file.read.sams.updindex
0257                                                   ; Update index
0258                       ;------------------------------------------------------
0259                       ; 3a: Special handling for empty line
0260                       ;------------------------------------------------------
0261               fh.file.read.sams.prepindex.emptyline:
0262 7012 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     7014 A42E 
     7016 8350 
0263 7018 0620  34         dec   @parm1                ;         Adjust for base 0 index
     701A 8350 
0264 701C 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     701E 8352 
0265 7020 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7022 8354 
0266                       ;------------------------------------------------------
0267                       ; 3b: Do actual index update
0268                       ;------------------------------------------------------
0269               fh.file.read.sams.updindex:
0270 7024 06A0  32         bl    @idx.entry.update     ; Update index
     7026 6A08 
0271                                                   ; \ i  parm1    = Line num in editor buffer
0272                                                   ; | i  parm2    = Pointer to line in editor
0273                                                   ; |               buffer
0274                                                   ; | i  parm3    = SAMS page
0275                                                   ; | o  outparm1 = Pointer to updated index
0276                                                   ; /               entry
0277               
0278 7028 05A0  34         inc   @edb.lines            ; lines=lines+1
     702A A204 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Callback "Read line from file"
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.display:
0283 702C C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     702E A43E 
0284 7030 0694  24         bl    *tmp0                 ; Run callback function
0285                       ;------------------------------------------------------
0286                       ; 4a: Next record
0287                       ;------------------------------------------------------
0288               fh.file.read.sams.next:
0289 7032 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7034 2B46 
0290 7036 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0291               
0292 7038 0460  28         b     @fh.file.read.sams.record
     703A 6F4E 
0293                                                   ; Next record
0294                       ;------------------------------------------------------
0295                       ; Error handler
0296                       ;------------------------------------------------------
0297               fh.file.read.sams.error:
0298 703C C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     703E A42A 
0299 7040 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0300 7042 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7044 0005 
0301 7046 1309  14         jeq   fh.file.read.sams.eof
0302                                                   ; All good. File closed by DSRLNK
0303                       ;------------------------------------------------------
0304                       ; File error occured
0305                       ;------------------------------------------------------
0306 7048 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     704A 2B68 
0307 704C 3F00                   data scrpad.backup2   ; / >2100->8300
0308               
0309 704E 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7050 6780 
0310                       ;------------------------------------------------------
0311                       ; Callback "File I/O error"
0312                       ;------------------------------------------------------
0313 7052 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     7054 A442 
0314 7056 0694  24         bl    *tmp0                 ; Run callback function
0315 7058 1008  14         jmp   fh.file.read.sams.exit
0316                       ;------------------------------------------------------
0317                       ; End-Of-File reached
0318                       ;------------------------------------------------------
0319               fh.file.read.sams.eof:
0320 705A 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     705C 2B68 
0321 705E 3F00                   data scrpad.backup2   ; / >2100->8300
0322               
0323 7060 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7062 6780 
0324                       ;------------------------------------------------------
0325                       ; Callback "Close file"
0326                       ;------------------------------------------------------
0327 7064 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7066 A440 
0328 7068 0694  24         bl    *tmp0                 ; Run callback function
0329               *--------------------------------------------------------------
0330               * Exit
0331               *--------------------------------------------------------------
0332               fh.file.read.sams.exit:
0333 706A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0334 706C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0335 706E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0336 7070 C2F9  30         mov   *stack+,r11           ; Pop R11
0337 7072 045B  20         b     *r11                  ; Return to caller
0338               
0339               
0340               ***************************************************************
0341               * PAB for accessing DV/80 file
0342               ********|*****|*********************|**************************
0343               fh.file.pab.header:
0344 7074 0014             byte  io.op.open            ;  0    - OPEN
0345                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0346 7076 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0347 7078 5000             byte  80                    ;  4    - Record length (80 chars max)
0348                       byte  00                    ;  5    - Character count
0349 707A 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0350 707C 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0351                       ;------------------------------------------------------
0352                       ; File descriptor part (variable length)
0353                       ;------------------------------------------------------
0354                       ; byte  12                  ;  9    - File descriptor length
0355                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0356                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.476537
0071                       copy  "fm.load.asm"         ; File manager loadfile
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
0014 707E 0649  14         dect  stack
0015 7080 C64B  30         mov   r11,*stack            ; Save return address
0016                       ;-------------------------------------------------------
0017                       ; Reset editor
0018                       ;-------------------------------------------------------
0019 7082 C804  38         mov   tmp0,@parm1           ; Setup file to load
     7084 8350 
0020 7086 06A0  32         bl    @tv.reset             ; Reset editor
     7088 6764 
0021 708A C820  54         mov   @parm1,@edb.filename.ptr
     708C 8350 
     708E A20E 
0022                                                   ; Set filename
0023                       ;-------------------------------------------------------
0024                       ; Clear VDP screen buffer
0025                       ;-------------------------------------------------------
0026 7090 06A0  32         bl    @filv
     7092 2288 
0027 7094 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7096 0000 
     7098 0004 
0028               
0029 709A C160  34         mov   @fb.scrrows,tmp1
     709C A118 
0030 709E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     70A0 A10E 
0031                                                   ; 16 bit part is in tmp2!
0032               
0033               
0034 70A2 06A0  32         bl    @scroff               ; Turn off screen
     70A4 2640 
0035               
0036 70A6 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0037 70A8 0205  20         li    tmp1,32               ; Character to fill
     70AA 0020 
0038               
0039 70AC 06A0  32         bl    @xfilv                ; Fill VDP memory
     70AE 228E 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = Byte to fill
0042                                                   ; / i  tmp2 = Bytes to copy
0043               
0044 70B0 06A0  32         bl    @pane.action.colorscheme.Load
     70B2 739C 
0045                                                   ; Load color scheme and turn on screen
0046                       ;-------------------------------------------------------
0047                       ; Read DV80 file and display
0048                       ;-------------------------------------------------------
0049 70B4 0204  20         li    tmp0,fm.loadfile.cb.indicator1
     70B6 70E8 
0050 70B8 C804  38         mov   tmp0,@parm2           ; Register callback 1
     70BA 8352 
0051               
0052 70BC 0204  20         li    tmp0,fm.loadfile.cb.indicator2
     70BE 7110 
0053 70C0 C804  38         mov   tmp0,@parm3           ; Register callback 2
     70C2 8354 
0054               
0055 70C4 0204  20         li    tmp0,fm.loadfile.cb.indicator3
     70C6 7146 
0056 70C8 C804  38         mov   tmp0,@parm4           ; Register callback 3
     70CA 8356 
0057               
0058 70CC 0204  20         li    tmp0,fm.loadfile.cb.fioerr
     70CE 7178 
0059 70D0 C804  38         mov   tmp0,@parm5           ; Register callback 4
     70D2 8358 
0060               
0061 70D4 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     70D6 6E82 
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
0073 70D8 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     70DA A206 
0074                                                   ; longer dirty.
0075               
0076 70DC 0204  20         li    tmp0,txt.filetype.DV80
     70DE 77F8 
0077 70E0 C804  38         mov   tmp0,@edb.filetype.ptr
     70E2 A210 
0078                                                   ; Set filetype display string
0079               *--------------------------------------------------------------
0080               * Exit
0081               *--------------------------------------------------------------
0082               fm.loadfile.exit:
0083 70E4 0460  28         b     @poprt                ; Return to caller
     70E6 222C 
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
0094 70E8 0649  14         dect  stack
0095 70EA C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Show loading indicators and file descriptor
0098                       ;------------------------------------------------------
0099 70EC 06A0  32         bl    @hchar
     70EE 2774 
0100 70F0 1D00                   byte 29,0,32,80
     70F2 2050 
0101 70F4 FFFF                   data EOL
0102               
0103 70F6 06A0  32         bl    @putat
     70F8 243C 
0104 70FA 1D00                   byte 29,0
0105 70FC 77CE                   data txt.loading      ; Display "Loading...."
0106               
0107 70FE 06A0  32         bl    @at
     7100 2680 
0108 7102 1D0B                   byte 29,11            ; Cursor YX position
0109 7104 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7106 8350 
0110 7108 06A0  32         bl    @xutst0               ; Display device/filename
     710A 241A 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.cb.indicator1.exit:
0115 710C 0460  28         b     @poprt                ; Return to caller
     710E 222C 
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
0131 7110 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     7112 A432 
     7114 A444 
0132 7116 1316  14         jeq   !
0133                       ;------------------------------------------------------
0134                       ; Display updated counters
0135                       ;------------------------------------------------------
0136 7118 0649  14         dect  stack
0137 711A C64B  30         mov   r11,*stack            ; Save return address
0138               
0139 711C C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     711E A432 
     7120 A444 
0140                                                   ; Save for compare
0141               
0142 7122 06A0  32         bl    @putnum
     7124 2A00 
0143 7126 1D4B                   byte 29,75            ; Show lines read
0144 7128 A204                   data edb.lines,rambuf,>3020
     712A 8390 
     712C 3020 
0145               
0146 712E 06A0  32         bl    @putnum
     7130 2A00 
0147 7132 1D38                   byte 29,56            ; Show kilobytes read
0148 7134 A432                   data fh.kilobytes,rambuf,>3020
     7136 8390 
     7138 3020 
0149               
0150 713A 06A0  32         bl    @putat
     713C 243C 
0151 713E 1D3D                   byte 29,61
0152 7140 77DA                   data txt.kb           ; Show "kb" string
0153                       ;------------------------------------------------------
0154                       ; Exit
0155                       ;------------------------------------------------------
0156               fm.loadfile.cb.indicator2.exit:
0157 7142 C2F9  30         mov   *stack+,r11           ; Pop R11
0158 7144 045B  20 !       b     *r11                  ; Return to caller
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
0170 7146 0649  14         dect  stack
0171 7148 C64B  30         mov   r11,*stack            ; Save return address
0172               
0173 714A 06A0  32         bl    @hchar
     714C 2774 
0174 714E 1D03                   byte 29,3,32,50       ; Erase loading indicator
     7150 2032 
0175 7152 FFFF                   data EOL
0176               
0177 7154 06A0  32         bl    @putnum
     7156 2A00 
0178 7158 1D38                   byte 29,56            ; Show kilobytes read
0179 715A A432                   data fh.kilobytes,rambuf,>3020
     715C 8390 
     715E 3020 
0180               
0181 7160 06A0  32         bl    @putat
     7162 243C 
0182 7164 1D3D                   byte 29,61
0183 7166 77DA                   data txt.kb           ; Show "kb" string
0184               
0185 7168 06A0  32         bl    @putnum
     716A 2A00 
0186 716C 1D4B                   byte 29,75            ; Show lines read
0187 716E A42E                   data fh.records,rambuf,>3020
     7170 8390 
     7172 3020 
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191               fm.loadfile.cb.indicator3.exit:
0192 7174 0460  28         b     @poprt                ; Return to caller
     7176 222C 
0193               
0194               
0195               
0196               *---------------------------------------------------------------
0197               * Callback function "File I/O error handler"
0198               *---------------------------------------------------------------
0199               * Is expected to be passed as parm5 to @tfh.file.read
0200               ********|*****|*********************|**************************
0201               fm.loadfile.cb.fioerr:
0202 7178 0649  14         dect  stack
0203 717A C64B  30         mov   r11,*stack            ; Save return address
0204               
0205 717C 06A0  32         bl    @hchar
     717E 2774 
0206 7180 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7182 2032 
0207 7184 FFFF                   data EOL
0208                       ;------------------------------------------------------
0209                       ; Build I/O error message
0210                       ;------------------------------------------------------
0211 7186 06A0  32         bl    @cpym2m
     7188 248C 
0212 718A 7833                   data txt.ioerr+1
0213 718C A01F                   data tv.error.msg+1
0214 718E 0022                   data 34               ; Error message
0215               
0216 7190 C120  34         mov   @edb.filename.ptr,tmp0
     7192 A20E 
0217 7194 D194  26         movb  *tmp0,tmp2            ; Get length byte
0218 7196 0986  56         srl   tmp2,8                ; Right align
0219 7198 0584  14         inc   tmp0                  ; Skip length byte
0220 719A 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     719C A03F 
0221               
0222 719E 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     71A0 2492 
0223                                                   ; | i  tmp0 = ROM/RAM source
0224                                                   ; | i  tmp1 = RAM destination
0225                                                   ; / i  tmp2 = Bytes top copy
0226                       ;------------------------------------------------------
0227                       ; Reset filename to "new file"
0228                       ;------------------------------------------------------
0229 71A2 0204  20         li    tmp0,txt.newfile      ; New file
     71A4 77EC 
0230 71A6 C804  38         mov   tmp0,@edb.filename.ptr
     71A8 A20E 
0231               
0232 71AA 0204  20         li    tmp0,txt.filetype.none
     71AC 77FE 
0233 71AE C804  38         mov   tmp0,@edb.filetype.ptr
     71B0 A210 
0234                                                   ; Empty filetype string
0235                       ;------------------------------------------------------
0236                       ; Display I/O error message
0237                       ;------------------------------------------------------
0238 71B2 06A0  32         bl    @pane.errline.show    ; Show error line
     71B4 75A6 
0239                       ;------------------------------------------------------
0240                       ; Exit
0241                       ;------------------------------------------------------
0242               fm.loadfile.cb.fioerr.exit:
0243 71B6 0460  28         b     @poprt                ; Return to caller
     71B8 222C 
**** **** ****     > stevie_b1.asm.476537
0072                       ;-----------------------------------------------------------------------
0073                       ; User hook, background tasks
0074                       ;-----------------------------------------------------------------------
0075                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 71BA 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     71BC 2014 
0013 71BE 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 71C0 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     71C2 2014 
0019 71C4 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     71C6 833C 
     71C8 833E 
0020 71CA 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 71CC C820  54         mov   @waux1,@waux2         ; Save as previous key
     71CE 833C 
     71D0 833E 
0026 71D2 0460  28         b     @edkey.key.process    ; Process key
     71D4 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 71D6 04E0  34         clr   @waux1
     71D8 833C 
0032 71DA 04E0  34         clr   @waux2
     71DC 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 71DE 0204  20         li    tmp0,2000             ; Avoid key bouncing
     71E0 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 71E2 0604  14         dec   tmp0
0043 71E4 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 71E6 0460  28         b     @hookok               ; Return
     71E8 2D1E 
**** **** ****     > stevie_b1.asm.476537
0076                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0015 71EA C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     71EC A302 
0016 71EE 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 71F0 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     71F2 A318 
0022 71F4 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 71F6 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     71F8 74A8 
0025 71FA 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     71FC A318 
0026 71FE 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 7200 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7202 A116 
0031 7204 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 7206 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7208 832A 
     720A A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 720C 8820  54         c     @edb.lines,@fb.scrrows
     720E A204 
     7210 A118 
0037 7212 1103  14         jlt   task.vdp.panes.setrows.small
0038 7214 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7216 A118 
0039 7218 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 721A C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     721C A204 
0045 721E 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 7220 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7222 A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 7224 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 7226 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7228 A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 722A 06A0  32         bl    @xpym2v               ; Copy to VDP
     722C 244A 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 722E 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7230 A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 7232 C120  34         mov   @edb.lines,tmp0
     7234 A204 
0066 7236 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7238 A104 
0067 723A 0584  14         inc   tmp0                  ; Y = Y + 1
0068 723C 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     723E A118 
0069 7240 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 7242 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 7244 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7246 832A 
0077               
0078 7248 06A0  32         bl    @putstr
     724A 2418 
0079 724C 77B8                   data txt.marker       ; Display *EOF*
0080               
0081 724E 06A0  32         bl    @setx
     7250 2696 
0082 7252 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 7254 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     7256 A10E 
0088               
0089 7258 C160  34         mov   @wyx,tmp1             ;
     725A 832A 
0090 725C 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 725E 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 7260 A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     7262 A118 
0093               
0094 7264 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 7266 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     7268 FFFB 
0096               
0097 726A 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     726C 23F4 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 726E 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 7270 06A0  32         bl    @xfilv                ; Fill VDP memory
     7272 228E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 7274 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7276 A114 
     7278 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 727A 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     727C 75EC 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 727E 0460  28         b     @slotok
     7280 2D9A 
**** **** ****     > stevie_b1.asm.476537
0077                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 7282 C120  34         mov   @tv.pane.focus,tmp0
     7284 A01A 
0013 7286 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 7288 0284  22         ci    tmp0,pane.focus.cmdb
     728A 0001 
0016 728C 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 728E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7290 FFCE 
0022 7292 06A0  32         bl    @cpu.crash            ; / Halt system.
     7294 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7296 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7298 A30A 
     729A 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 729C E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     729E 202A 
0032 72A0 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     72A2 26A2 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 72A4 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     72A6 8380 
0036               
0037 72A8 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     72AA 2444 
0038 72AC 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     72AE 8380 
     72B0 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 72B2 0460  28         b     @slotok               ; Exit task
     72B4 2D9A 
**** **** ****     > stevie_b1.asm.476537
0078                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 72B6 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     72B8 A112 
0013 72BA 1303  14         jeq   task.vdp.cursor.visible
0014 72BC 04E0  34         clr   @ramsat+2              ; Hide cursor
     72BE 8382 
0015 72C0 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 72C2 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     72C4 A20A 
0019 72C6 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 72C8 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     72CA A01A 
0025 72CC 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 72CE 0284  22         ci    tmp0,pane.focus.cmdb
     72D0 0001 
0028 72D2 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 72D4 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 72D6 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 72D8 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     72DA 0100 
0040 72DC 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 72DE 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     72E0 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 72E2 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     72E4 A014 
0051 72E6 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     72E8 A014 
     72EA 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 72EC 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     72EE 2444 
0057 72F0 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     72F2 8380 
     72F4 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 72F6 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     72F8 A302 
0064 72FA 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 72FC 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     72FE 75EC 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 7300 0460  28         b     @slotok                ; Exit task
     7302 2D9A 
**** **** ****     > stevie_b1.asm.476537
0079                       ;-----------------------------------------------------------------------
0080                       ; Screen pane utilities
0081                       ;-----------------------------------------------------------------------
0082                       copy  "pane.utils.asm"      ; Pane utility functions
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
0013               * bl  @pane.show_hintx
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1 = Cursor YX position
0017               * @parm2 = Pointer to Length-prefixed string
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * none
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0, tmp1, tmp2
0024               ********|*****|*********************|**************************
0025               pane.show_hintx:
0026 7304 0649  14         dect  stack
0027 7306 C64B  30         mov   r11,*stack            ; Save return address
0028 7308 0649  14         dect  stack
0029 730A C644  30         mov   tmp0,*stack           ; Push tmp0
0030 730C 0649  14         dect  stack
0031 730E C645  30         mov   tmp1,*stack           ; Push tmp1
0032 7310 0649  14         dect  stack
0033 7312 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 7314 0649  14         dect  stack
0035 7316 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 7318 C820  54         mov   @parm1,@wyx           ; Set cursor
     731A 8350 
     731C 832A 
0040 731E C160  34         mov   @parm2,tmp1           ; Get string to display
     7320 8352 
0041 7322 06A0  32         bl    @xutst0               ; Display string
     7324 241A 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 7326 C120  34         mov   @parm2,tmp0
     7328 8352 
0046 732A D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 732C 0984  56         srl   tmp0,8                ; Right justify
0048 732E C184  18         mov   tmp0,tmp2
0049 7330 C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 7332 0506  16         neg   tmp2
0051 7334 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7336 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 7338 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     733A 8350 
0056 733C A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 733E C804  38         mov   tmp0,@wyx             ; / Set cursor
     7340 832A 
0058               
0059 7342 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7344 23F4 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 7346 0205  20         li    tmp1,32               ; Byte to fill
     7348 0020 
0064               
0065 734A 06A0  32         bl    @xfilv                ; Clear line
     734C 228E 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 734E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 7350 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 7352 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 7354 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 7356 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7358 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               
0082               ***************************************************************
0083               * pane.show_hint
0084               * Show hint message (data parameter version)
0085               ***************************************************************
0086               * bl  @pane.show_hint
0087               *     data p1,p2
0088               *--------------------------------------------------------------
0089               * INPUT
0090               * p1 = Cursor YX position
0091               * p2 = Pointer to Length-prefixed string
0092               *--------------------------------------------------------------
0093               * OUTPUT
0094               * none
0095               *--------------------------------------------------------------
0096               * Register usage
0097               * none
0098               ********|*****|*********************|**************************
0099               pane.show_hint:
0100 735A C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     735C 8350 
0101 735E C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     7360 8352 
0102 7362 0649  14         dect  stack
0103 7364 C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 7366 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7368 7304 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 736A C2F9  30         mov   *stack+,r11           ; Pop R11
0113 736C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0083                       copy  "pane.utils.colorscheme.asm"
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
0021 736E 0649  14         dect  stack
0022 7370 C64B  30         mov   r11,*stack            ; Push return address
0023 7372 0649  14         dect  stack
0024 7374 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7376 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     7378 A012 
0027 737A 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     737C 0008 
0028                                                   ; Last entry reached?
0029 737E 1102  14         jlt   !
0030 7380 04C4  14         clr   tmp0
0031 7382 1001  14         jmp   pane.action.colorscheme.switch
0032 7384 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 7386 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7388 A012 
0038 738A 06A0  32         bl    @pane.action.colorscheme.load
     738C 739C 
0039                       ;-------------------------------------------------------
0040                       ; Delay
0041                       ;-------------------------------------------------------
0042 738E 0204  20         li    tmp0,12000
     7390 2EE0 
0043 7392 0604  14 !       dec   tmp0
0044 7394 16FE  14         jne   -!
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               pane.action.colorscheme.cycle.exit:
0049 7396 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0050 7398 C2F9  30         mov   *stack+,r11           ; Pop R11
0051 739A 045B  20         b     *r11                  ; Return to caller
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
0073 739C 0649  14         dect  stack
0074 739E C64B  30         mov   r11,*stack            ; Save return address
0075 73A0 0649  14         dect  stack
0076 73A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 73A4 0649  14         dect  stack
0078 73A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0079 73A8 0649  14         dect  stack
0080 73AA C646  30         mov   tmp2,*stack           ; Push tmp2
0081 73AC 0649  14         dect  stack
0082 73AE C647  30         mov   tmp3,*stack           ; Push tmp3
0083 73B0 0649  14         dect  stack
0084 73B2 C648  30         mov   tmp4,*stack           ; Push tmp4
0085 73B4 06A0  32         bl    @scroff               ; Turn screen off
     73B6 2640 
0086                       ;-------------------------------------------------------
0087                       ; Get framebuffer foreground/background color
0088                       ;-------------------------------------------------------
0089 73B8 C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     73BA A012 
0090 73BC 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0091 73BE 0224  22         ai    tmp0,tv.colorscheme.table
     73C0 7792 
0092                                                   ; Add base for color scheme data table
0093 73C2 C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0094 73C4 C807  38         mov   tmp3,@tv.color        ; Save colors
     73C6 A018 
0095                       ;-------------------------------------------------------
0096                       ; Get and save cursor color
0097                       ;-------------------------------------------------------
0098 73C8 C214  26         mov   *tmp0,tmp4            ; Get cursor color
0099 73CA 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     73CC 00FF 
0100 73CE C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     73D0 A016 
0101                       ;-------------------------------------------------------
0102                       ; Get CMDB pane foreground/background color
0103                       ;-------------------------------------------------------
0104 73D2 C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0105 73D4 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     73D6 FF00 
0106 73D8 0988  56         srl   tmp4,8                ; MSB to LSB
0107                       ;-------------------------------------------------------
0108                       ; Dump colors to VDP register 7 (text mode)
0109                       ;-------------------------------------------------------
0110 73DA C147  18         mov   tmp3,tmp1             ; Get work copy
0111 73DC 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0112 73DE 0265  22         ori   tmp1,>0700
     73E0 0700 
0113 73E2 C105  18         mov   tmp1,tmp0
0114 73E4 06A0  32         bl    @putvrx               ; Write VDP register
     73E6 232E 
0115                       ;-------------------------------------------------------
0116                       ; Dump colors for frame buffer pane (TAT)
0117                       ;-------------------------------------------------------
0118 73E8 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     73EA 1800 
0119 73EC C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0120 73EE 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0121 73F0 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     73F2 0910 
0122 73F4 06A0  32         bl    @xfilv                ; Fill colors
     73F6 228E 
0123                                                   ; i \  tmp0 = start address
0124                                                   ; i |  tmp1 = byte to fill
0125                                                   ; i /  tmp2 = number of bytes to fill
0126                       ;-------------------------------------------------------
0127                       ; Dump colors for CMDB pane (TAT)
0128                       ;-------------------------------------------------------
0129               pane.action.colorscheme.cmdbpane:
0130 73F8 C120  34         mov   @cmdb.visible,tmp0
     73FA A302 
0131 73FC 1307  14         jeq   pane.action.colorscheme.errpane
0132                                                   ; Skip if CMDB pane is hidden
0133               
0134 73FE 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     7400 1FD0 
0135 7402 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0136 7404 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     7406 0190 
0137 7408 06A0  32         bl    @xfilv                ; Fill colors
     740A 228E 
0138                                                   ; i \  tmp0 = start address
0139                                                   ; i |  tmp1 = byte to fill
0140                                                   ; i /  tmp2 = number of bytes to fill
0141                       ;-------------------------------------------------------
0142                       ; Dump colors for error line pane (TAT)
0143                       ;-------------------------------------------------------
0144               pane.action.colorscheme.errpane:
0145 740C C120  34         mov   @tv.error.visible,tmp0
     740E A01C 
0146 7410 1304  14         jeq   pane.action.colorscheme.statusline
0147                                                   ; Skip if error line pane is hidden
0148               
0149 7412 0205  20         li    tmp1,>00f6            ; White on dark red
     7414 00F6 
0150 7416 06A0  32         bl    @pane.action.colorscheme.errline
     7418 744C 
0151                                                   ; Load color combination for error line
0152                       ;-------------------------------------------------------
0153                       ; Dump colors for bottom status line pane (TAT)
0154                       ;-------------------------------------------------------
0155               pane.action.colorscheme.statusline:
0156 741A 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     741C 2110 
0157 741E C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0158 7420 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7422 00FF 
0159 7424 0206  20         li    tmp2,80               ; Number of bytes to fill
     7426 0050 
0160 7428 06A0  32         bl    @xfilv                ; Fill colors
     742A 228E 
0161                                                   ; i \  tmp0 = start address
0162                                                   ; i |  tmp1 = byte to fill
0163                                                   ; i /  tmp2 = number of bytes to fill
0164                       ;-------------------------------------------------------
0165                       ; Dump cursor FG color to sprite table (SAT)
0166                       ;-------------------------------------------------------
0167               pane.action.colorscheme.cursorcolor:
0168 742C C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     742E A016 
0169 7430 0A88  56         sla   tmp4,8                ; Move to MSB
0170 7432 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7434 8383 
0171 7436 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7438 A015 
0172                       ;-------------------------------------------------------
0173                       ; Exit
0174                       ;-------------------------------------------------------
0175               pane.action.colorscheme.load.exit:
0176 743A 06A0  32         bl    @scron                ; Turn screen on
     743C 2648 
0177 743E C239  30         mov   *stack+,tmp4          ; Pop tmp4
0178 7440 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0179 7442 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0180 7444 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 7446 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 7448 C2F9  30         mov   *stack+,r11           ; Pop R11
0183 744A 045B  20         b     *r11                  ; Return to caller
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
0203 744C 0649  14         dect  stack
0204 744E C64B  30         mov   r11,*stack            ; Save return address
0205 7450 0649  14         dect  stack
0206 7452 C644  30         mov   tmp0,*stack           ; Push tmp0
0207 7454 0649  14         dect  stack
0208 7456 C645  30         mov   tmp1,*stack           ; Push tmp1
0209 7458 0649  14         dect  stack
0210 745A C646  30         mov   tmp2,*stack           ; Push tmp2
0211                       ;-------------------------------------------------------
0212                       ; Load error line colors
0213                       ;-------------------------------------------------------
0214 745C 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     745E 20C0 
0215 7460 0206  20         li    tmp2,80               ; Number of bytes to fill
     7462 0050 
0216 7464 06A0  32         bl    @xfilv                ; Fill colors
     7466 228E 
0217                                                   ; i \  tmp0 = start address
0218                                                   ; i |  tmp1 = byte to fill
0219                                                   ; i /  tmp2 = number of bytes to fill
0220                       ;-------------------------------------------------------
0221                       ; Exit
0222                       ;-------------------------------------------------------
0223               pane.action.colorscheme.errline.exit:
0224 7468 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0225 746A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0226 746C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0227 746E C2F9  30         mov   *stack+,r11           ; Pop R11
0228 7470 045B  20         b     *r11                  ; Return to caller
0229               
**** **** ****     > stevie_b1.asm.476537
0084                                                   ; Colorscheme handling in panes
0085                       copy  "pane.utils.tipiclock.asm"
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
0021 7472 0649  14         dect  stack
0022 7474 C64B  30         mov   r11,*stack            ; Push return address
0023 7476 0649  14         dect  stack
0024 7478 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 747A 0204  20         li    tmp0,fdname.clock
     747C 79B2 
0029 747E C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     7480 8350 
0030               
0031 7482 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     7484 74A4 
0032 7486 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7488 8352 
0033 748A C804  38         mov   tmp0,@parm3           ; Register callback 2
     748C 8354 
0034 748E C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     7490 8358 
0035               
0036 7492 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     7494 74A6 
0037 7496 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7498 8356 
0038               
0039 749A 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     749C 6E82 
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
0055 749E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 74A0 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 74A2 045B  20         b     *r11                  ; Return to caller
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
0070 74A4 069B  24         bl    *r11                  ; Return to caller
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
0083 74A6 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0086                                                   ; TIPI clock
0087                       ;-----------------------------------------------------------------------
0088                       ; Screen panes
0089                       ;-----------------------------------------------------------------------
0090                       copy  "pane.cmdb.asm"       ; Command buffer
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
0021 74A8 0649  14         dect  stack
0022 74AA C64B  30         mov   r11,*stack            ; Save return address
0023 74AC 0649  14         dect  stack
0024 74AE C644  30         mov   tmp0,*stack           ; Push tmp0
0025 74B0 0649  14         dect  stack
0026 74B2 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 74B4 0649  14         dect  stack
0028 74B6 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 74B8 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     74BA A30E 
     74BC 832A 
0033 74BE C160  34         mov   @cmdb.pantitle,tmp1   ; | Display pane title
     74C0 A31A 
0034 74C2 06A0  32         bl    @xutst0               ; /
     74C4 241A 
0035               
0036 74C6 06A0  32         bl    @setx
     74C8 2696 
0037 74CA 000E                   data 14               ; Position cursor
0038               
0039 74CC 06A0  32         bl    @putstr               ; Display horizontal line
     74CE 2418 
0040 74D0 78C0                   data txt.cmdb.hbar
0041                       ;------------------------------------------------------
0042                       ; Clear lines after prompt in command buffer
0043                       ;------------------------------------------------------
0044 74D2 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     74D4 A31E 
0045 74D6 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0046 74D8 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     74DA A310 
0047 74DC C804  38         mov   tmp0,@wyx             ; /
     74DE 832A 
0048               
0049 74E0 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     74E2 23F4 
0050                                                   ; \ i  @wyx = Cursor position
0051                                                   ; / o  tmp0 = VDP target address
0052               
0053 74E4 0205  20         li    tmp1,32
     74E6 0020 
0054               
0055 74E8 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     74EA A31E 
0056 74EC 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0057 74EE 0506  16         neg   tmp2                  ; | Based on command & prompt length
0058 74F0 0226  22         ai    tmp2,2*80 - 1         ; /
     74F2 009F 
0059               
0060 74F4 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     74F6 228E 
0061                                                   ; | i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = Byte to fill
0063                                                   ; / i  tmp2 = Number of bytes to fill
0064                       ;------------------------------------------------------
0065                       ; Display pane hint in command buffer
0066                       ;------------------------------------------------------
0067 74F8 0204  20         li    tmp0,>1c00            ; Y=28, X=0
     74FA 1C00 
0068 74FC C804  38         mov   tmp0,@parm1           ; Set parameter
     74FE 8350 
0069 7500 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7502 A31C 
     7504 8352 
0070               
0071 7506 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7508 7304 
0072                                                   ; \ i  parm1 = Pointer to string with hint
0073                                                   ; / i  parm2 = YX position
0074                       ;------------------------------------------------------
0075                       ; Display keys in status line
0076                       ;------------------------------------------------------
0077 750A 06A0  32         bl    @pane.show_hint       ; Display pane hint
     750C 735A 
0078 750E 1D00                   byte  29,0            ; Y = 29, X=0
0079 7510 7804                   data  txt.keys.loaddv80
0080                       ;------------------------------------------------------
0081                       ; Command buffer content
0082                       ;------------------------------------------------------
0083 7512 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7514 6DB6 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.cmdb.exit:
0088 7516 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0089 7518 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0090 751A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0091 751C C2F9  30         mov   *stack+,r11           ; Pop r11
0092 751E 045B  20         b     *r11                  ; Return
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
0113 7520 0649  14         dect  stack
0114 7522 C64B  30         mov   r11,*stack            ; Save return address
0115 7524 0649  14         dect  stack
0116 7526 C644  30         mov   tmp0,*stack           ; Push tmp0
0117                       ;------------------------------------------------------
0118                       ; Show command buffer pane
0119                       ;------------------------------------------------------
0120 7528 C820  54         mov   @wyx,@cmdb.fb.yxsave
     752A 832A 
     752C A304 
0121                                                   ; Save YX position in frame buffer
0122               
0123 752E C120  34         mov   @fb.scrrows.max,tmp0
     7530 A11A 
0124 7532 6120  34         s     @cmdb.scrrows,tmp0
     7534 A306 
0125 7536 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7538 A118 
0126               
0127 753A 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0128 753C C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     753E A30E 
0129               
0130 7540 0224  22         ai    tmp0,>0100
     7542 0100 
0131 7544 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7546 A310 
0132 7548 0584  14         inc   tmp0
0133 754A C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     754C A30A 
0134               
0135 754E 0720  34         seto  @cmdb.visible         ; Show pane
     7550 A302 
0136 7552 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7554 A318 
0137               
0138 7556 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7558 0001 
0139 755A C804  38         mov   tmp0,@tv.pane.focus   ; /
     755C A01A 
0140               
0141 755E 06A0  32         bl    @cmdb.cmd.clear;      ; Clear current command
     7560 6E08 
0142               
0143 7562 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7564 75D8 
0144               
0145 7566 06A0  32         bl    @pane.action.colorscheme.load
     7568 739C 
0146                                                   ; Reload colorscheme
0147               pane.cmdb.show.exit:
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151 756A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0152 756C C2F9  30         mov   *stack+,r11           ; Pop r11
0153 756E 045B  20         b     *r11                  ; Return to caller
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
0176 7570 0649  14         dect  stack
0177 7572 C64B  30         mov   r11,*stack            ; Save return address
0178                       ;------------------------------------------------------
0179                       ; Hide command buffer pane
0180                       ;------------------------------------------------------
0181 7574 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7576 A11A 
     7578 A118 
0182                       ;------------------------------------------------------
0183                       ; Adjust frame buffer size if error pane visible
0184                       ;------------------------------------------------------
0185 757A C820  54         mov   @tv.error.visible,@tv.error.visible
     757C A01C 
     757E A01C 
0186 7580 1302  14         jeq   !
0187 7582 0620  34         dec   @fb.scrrows
     7584 A118 
0188                       ;------------------------------------------------------
0189                       ; Clear error/hint & status line
0190                       ;------------------------------------------------------
0191 7586 06A0  32 !       bl    @hchar
     7588 2774 
0192 758A 1C00                   byte 28,0,32,80*2
     758C 20A0 
0193 758E FFFF                   data EOL
0194                       ;------------------------------------------------------
0195                       ; Hide command buffer pane (rest)
0196                       ;------------------------------------------------------
0197 7590 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7592 A304 
     7594 832A 
0198 7596 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7598 A302 
0199 759A 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     759C A116 
0200 759E 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     75A0 A01A 
0201                       ;------------------------------------------------------
0202                       ; Exit
0203                       ;------------------------------------------------------
0204               pane.cmdb.hide.exit:
0205 75A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0206 75A4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0091                       copy  "pane.errline.asm"    ; Error line
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
0026 75A6 0649  14         dect  stack
0027 75A8 C64B  30         mov   r11,*stack            ; Save return address
0028 75AA 0649  14         dect  stack
0029 75AC C644  30         mov   tmp0,*stack           ; Push tmp0
0030 75AE 0649  14         dect  stack
0031 75B0 C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 75B2 0205  20         li    tmp1,>00f6            ; White on dark red
     75B4 00F6 
0034 75B6 06A0  32         bl    @pane.action.colorscheme.errline
     75B8 744C 
0035                       ;------------------------------------------------------
0036                       ; Show error line content
0037                       ;------------------------------------------------------
0038 75BA 06A0  32         bl    @putat                ; Display error message
     75BC 243C 
0039 75BE 1C00                   byte 28,0
0040 75C0 A01E                   data tv.error.msg
0041               
0042 75C2 C120  34         mov   @fb.scrrows.max,tmp0
     75C4 A11A 
0043 75C6 0604  14         dec   tmp0
0044 75C8 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     75CA A118 
0045               
0046 75CC 0720  34         seto  @tv.error.visible     ; Error line is visible
     75CE A01C 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               pane.errline.show.exit:
0051 75D0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 75D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 75D4 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 75D6 045B  20         b     *r11                  ; Return to caller
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
0076 75D8 0649  14         dect  stack
0077 75DA C64B  30         mov   r11,*stack            ; Save return address
0078                       ;------------------------------------------------------
0079                       ; Hide command buffer pane
0080                       ;------------------------------------------------------
0081 75DC 06A0  32 !       bl    @errline.init         ; Clear error line
     75DE 6E5E 
0082 75E0 C160  34         mov   @tv.color,tmp1        ; Get foreground/background color
     75E2 A018 
0083 75E4 06A0  32         bl    @pane.action.colorscheme.errline
     75E6 744C 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.errline.hide.exit:
0088 75E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 75EA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.476537
0092                       copy  "pane.botline.asm"    ; Status line
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
0021 75EC 0649  14         dect  stack
0022 75EE C64B  30         mov   r11,*stack            ; Save return address
0023 75F0 0649  14         dect  stack
0024 75F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 75F4 C820  54         mov   @wyx,@fb.yxsave
     75F6 832A 
     75F8 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 75FA 06A0  32         bl    @putat
     75FC 243C 
0032 75FE 1D00                   byte  29,0
0033 7600 77E8                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 7602 06A0  32         bl    @at
     7604 2680 
0039 7606 1D03                   byte  29,3            ; Position cursor
0040 7608 C160  34         mov   @edb.filename.ptr,tmp1
     760A A20E 
0041                                                   ; Get string to display
0042 760C 06A0  32         bl    @xutst0               ; Display string
     760E 241A 
0043               
0044 7610 06A0  32         bl    @at
     7612 2680 
0045 7614 1D2C                   byte  29,44           ; Position cursor
0046               
0047 7616 C160  34         mov   @edb.filetype.ptr,tmp1
     7618 A210 
0048                                                   ; Get string to display
0049 761A 06A0  32         bl    @xutst0               ; Display Filetype string
     761C 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 761E C120  34         mov   @edb.insmode,tmp0
     7620 A20A 
0055 7622 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 7624 06A0  32         bl    @putat
     7626 243C 
0061 7628 1D32                   byte  29,50
0062 762A 77C4                   data  txt.ovrwrite
0063 762C 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 762E 06A0  32         bl    @putat
     7630 243C 
0069 7632 1D32                   byte  29,50
0070 7634 77C8                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7636 C120  34         mov   @edb.dirty,tmp0
     7638 A206 
0076 763A 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 763C 06A0  32         bl    @putat
     763E 243C 
0081 7640 1D36                   byte 29,54
0082 7642 77CC                   data txt.star
0083 7644 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7646 1000  14         nop
0089               pane.botline.show_linecol:
0090 7648 C820  54         mov   @fb.row,@parm1
     764A A106 
     764C 8350 
0091 764E 06A0  32         bl    @fb.row2line
     7650 681E 
0092 7652 05A0  34         inc   @outparm1
     7654 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7656 06A0  32         bl    @putnum
     7658 2A00 
0097 765A 1D40                   byte  29,64           ; YX
0098 765C 8360                   data  outparm1,rambuf
     765E 8390 
0099 7660 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7662 06A0  32         bl    @putat
     7664 243C 
0105 7666 1D45                   byte  29,69
0106 7668 77B6                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 766A 06A0  32         bl    @film
     766C 2230 
0111 766E 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     7670 0020 
     7672 000C 
0112               
0113 7674 C820  54         mov   @fb.column,@waux1
     7676 A10C 
     7678 833C 
0114 767A 05A0  34         inc   @waux1                ; Offset 1
     767C 833C 
0115               
0116 767E 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7680 2982 
0117 7682 833C                   data  waux1,rambuf
     7684 8390 
0118 7686 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 7688 06A0  32         bl    @trimnum              ; Trim number to the left
     768A 29DA 
0122 768C 8390                   data  rambuf,rambuf+6,32
     768E 8396 
     7690 0020 
0123               
0124 7692 0204  20         li    tmp0,>0200
     7694 0200 
0125 7696 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7698 8396 
0126               
0127 769A 06A0  32         bl    @putat
     769C 243C 
0128 769E 1D46                   byte 29,70
0129 76A0 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 76A2 C820  54         mov   @fb.row,@parm1
     76A4 A106 
     76A6 8350 
0134 76A8 06A0  32         bl    @fb.row2line
     76AA 681E 
0135 76AC 8820  54         c     @edb.lines,@outparm1
     76AE A204 
     76B0 8360 
0136 76B2 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 76B4 06A0  32         bl    @putat
     76B6 243C 
0139 76B8 1D4B                   byte 29,75
0140 76BA 77BE                   data txt.bottom
0141               
0142 76BC 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 76BE C820  54         mov   @edb.lines,@waux1
     76C0 A204 
     76C2 833C 
0148 76C4 05A0  34         inc   @waux1                ; Offset 1
     76C6 833C 
0149 76C8 06A0  32         bl    @putnum
     76CA 2A00 
0150 76CC 1D4B                   byte 29,75            ; YX
0151 76CE 833C                   data waux1,rambuf
     76D0 8390 
0152 76D2 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 76D4 C820  54         mov   @fb.yxsave,@wyx
     76D6 A114 
     76D8 832A 
0159 76DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 76DC C2F9  30         mov   *stack+,r11           ; Pop r11
0161 76DE 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.476537
0093                       ;-----------------------------------------------------------------------
0094                       ; Dialogs
0095                       ;-----------------------------------------------------------------------
0096                       copy  "dialog.file.load.asm"
**** **** ****     > dialog.file.load.asm
0001               * FILE......: dialog.file.load.asm
0002               * Purpose...: Dialog "Load file"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Open DV80 file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.load_dv80
0011               * Open Dialog for loading DV 80 file
0012               ***************************************************************
0013               * b @dialog.load_dv80
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
0025               ********|*****|*********************|**************************
0026               dialog.loaddv80:
0027 76E0 0204  20         li    tmp0,txt.cmdb.loaddv80
     76E2 7888 
0028 76E4 C804  38         mov   tmp0,@cmdb.pantitle   ; Title for dialog
     76E6 A31A 
0029               
0030 76E8 0204  20         li    tmp0,txt.cmdb.hintdv80
     76EA 7898 
0031 76EC C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     76EE A31C 
0032               
0033 76F0 0460  28         b    @edkey.action.cmdb.show
     76F2 670E 
0034                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.476537
0097                                                   ; Dialog "Load DV80 file"
0098                       ;-----------------------------------------------------------------------
0099                       ; Program data
0100                       ;-----------------------------------------------------------------------
0101                       copy  "data.constants.asm"  ; Data segment - Constants
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
0033 76F4 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     76F6 003F 
     76F8 0243 
     76FA 05F4 
     76FC 0050 
0034               
0035               romsat:
0036 76FE 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     7700 0001 
0037               
0038               cursors:
0039 7702 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     7704 0000 
     7706 0000 
     7708 001C 
0040 770A 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 2 - Insert mode
     770C 1C1C 
     770E 1C1C 
     7710 1C00 
0041 7712 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     7714 1C1C 
     7716 1C1C 
     7718 1C00 
0042               
0043               patterns:
0044 771A 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     771C 0000 
     771E 00FF 
     7720 0000 
0045 7722 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     7724 0000 
     7726 FF00 
     7728 FF00 
0046               patterns.box:
0047 772A 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     772C 0000 
     772E FF00 
     7730 FF00 
0048 7732 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     7734 0000 
     7736 FF80 
     7738 BFA0 
0049 773A 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     773C 0000 
     773E FC04 
     7740 F414 
0050 7742 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7744 A0A0 
     7746 A0A0 
     7748 A0A0 
0051 774A 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     774C 1414 
     774E 1414 
     7750 1414 
0052 7752 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7754 A0A0 
     7756 BF80 
     7758 FF00 
0053 775A 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     775C 1414 
     775E F404 
     7760 FC00 
0054 7762 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7764 C0C0 
     7766 C0C0 
     7768 0080 
0055 776A 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     776C 0F0F 
     776E 0F0F 
     7770 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 7772 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7774 0002 
0065 7776 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7778 0003 
0066 777A A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     777C 000A 
0067               
0068 777E B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     7780 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 7782 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7784 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 7786 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7788 000D 
0077 778A E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     778C 000E 
0078 778E F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7790 000F 
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
0104 7792 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     7794 F001 
0105 7796 F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     7798 F00F 
0106 779A A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     779C F00F 
0107 779E 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     77A0 F00F 
0108 77A2 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     77A4 F00F 
0109 77A6 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     77A8 1006 
0110 77AA 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     77AC 1001 
0111 77AE A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     77B0 1A0F 
0112 77B2 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     77B4 F20F 
0113               
**** **** ****     > stevie_b1.asm.476537
0102                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 77B6 012C             byte  1
0013 77B7 ....             text  ','
0014                       even
0015               
0016               txt.marker
0017 77B8 052A             byte  5
0018 77B9 ....             text  '*EOF*'
0019                       even
0020               
0021               txt.bottom
0022 77BE 0520             byte  5
0023 77BF ....             text  '  BOT'
0024                       even
0025               
0026               txt.ovrwrite
0027 77C4 034F             byte  3
0028 77C5 ....             text  'OVR'
0029                       even
0030               
0031               txt.insert
0032 77C8 0349             byte  3
0033 77C9 ....             text  'INS'
0034                       even
0035               
0036               txt.star
0037 77CC 012A             byte  1
0038 77CD ....             text  '*'
0039                       even
0040               
0041               txt.loading
0042 77CE 0A4C             byte  10
0043 77CF ....             text  'Loading...'
0044                       even
0045               
0046               txt.kb
0047 77DA 026B             byte  2
0048 77DB ....             text  'kb'
0049                       even
0050               
0051               txt.rle
0052 77DE 0352             byte  3
0053 77DF ....             text  'RLE'
0054                       even
0055               
0056               txt.lines
0057 77E2 054C             byte  5
0058 77E3 ....             text  'Lines'
0059                       even
0060               
0061               txt.bufnum
0062 77E8 0323             byte  3
0063 77E9 ....             text  '#1 '
0064                       even
0065               
0066               txt.newfile
0067 77EC 0A5B             byte  10
0068 77ED ....             text  '[New file]'
0069                       even
0070               
0071               txt.filetype.dv80
0072 77F8 0444             byte  4
0073 77F9 ....             text  'DV80'
0074                       even
0075               
0076               txt.filetype.none
0077 77FE 0420             byte  4
0078 77FF ....             text  '    '
0079                       even
0080               
0081               
0082               
0083               txt.keys.loaddv80
0084 7804 2D46             byte  45
0085 7805 ....             text  'FCTN-9=Back    FCTN-E=Previous    FCTN-X=Next'
0086                       even
0087               
0088               
0089               
0090               
0091               ;--------------------------------------------------------------
0092               ; Strings for error line pane
0093               ;--------------------------------------------------------------
0094               txt.ioerr
0095 7832 2049             byte  32
0096 7833 ....             text  'I/O error. Failed loading file: '
0097                       even
0098               
0099               txt.io.nofile
0100 7854 2149             byte  33
0101 7855 ....             text  'I/O error. No filename specified.'
0102                       even
0103               
0104               
0105               
0106               ;--------------------------------------------------------------
0107               ; Strings for command buffer
0108               ;--------------------------------------------------------------
0109               txt.cmdb.title
0110 7876 0E43             byte  14
0111 7877 ....             text  'Command buffer'
0112                       even
0113               
0114               txt.cmdb.prompt
0115 7886 013E             byte  1
0116 7887 ....             text  '>'
0117                       even
0118               
0119               txt.cmdb.loaddv80
0120 7888 0E4C             byte  14
0121 7889 ....             text  'Load DV80 file'
0122                       even
0123               
0124               
0125               txt.cmdb.hintdv80
0126 7898 2748             byte  39
0127 7899 ....             text  'HINT: Specify filename and press enter.'
0128                       even
0129               
0130               
0131 78C0 4201     txt.cmdb.hbar      byte    66
0132 78C2 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78C4 0101 
     78C6 0101 
     78C8 0101 
     78CA 0101 
     78CC 0101 
     78CE 0101 
     78D0 0101 
     78D2 0101 
     78D4 0101 
0133 78D6 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78D8 0101 
     78DA 0101 
     78DC 0101 
     78DE 0101 
     78E0 0101 
     78E2 0101 
     78E4 0101 
     78E6 0101 
     78E8 0101 
0134 78EA 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     78EC 0101 
     78EE 0101 
     78F0 0101 
     78F2 0101 
     78F4 0101 
     78F6 0101 
     78F8 0101 
     78FA 0101 
     78FC 0101 
0135 78FE 0101                        byte    1,1,1,1,1,1
     7900 0101 
     7902 0100 
0136                                  even
0137               
0138               
0139               
0140 7904 0C0A     txt.stevie         byte    12
0141                                  byte    10
0142 7906 ....                        text    'stevie v1.00'
0143 7912 0B00                        byte    11
0144                                  even
0145               
0146               fdname1
0147 7914 0850             byte  8
0148 7915 ....             text  'PI.CLOCK'
0149                       even
0150               
0151               fdname2
0152 791E 0E54             byte  14
0153 791F ....             text  'TIPI.TIVI.NR80'
0154                       even
0155               
0156               fdname3
0157 792E 0C44             byte  12
0158 792F ....             text  'DSK1.XBEADOC'
0159                       even
0160               
0161               fdname4
0162 793C 1154             byte  17
0163 793D ....             text  'TIPI.TIVI.C99MAN1'
0164                       even
0165               
0166               fdname5
0167 794E 1154             byte  17
0168 794F ....             text  'TIPI.TIVI.C99MAN2'
0169                       even
0170               
0171               fdname6
0172 7960 1154             byte  17
0173 7961 ....             text  'TIPI.TIVI.C99MAN3'
0174                       even
0175               
0176               fdname7
0177 7972 1254             byte  18
0178 7973 ....             text  'TIPI.TIVI.C99SPECS'
0179                       even
0180               
0181               fdname8
0182 7986 1254             byte  18
0183 7987 ....             text  'TIPI.TIVI.RANDOM#C'
0184                       even
0185               
0186               fdname9
0187 799A 0D44             byte  13
0188 799B ....             text  'DSK1.INVADERS'
0189                       even
0190               
0191               fdname0
0192 79A8 0944             byte  9
0193 79A9 ....             text  'DSK1.NR80'
0194                       even
0195               
0196               fdname.clock
0197 79B2 0850             byte  8
0198 79B3 ....             text  'PI.CLOCK'
0199                       even
0200               
0201               
0202               
0203               *---------------------------------------------------------------
0204               * Keyboard labels - Function keys
0205               *---------------------------------------------------------------
0206               txt.fctn.0
0207 79BC 0866             byte  8
0208 79BD ....             text  'fctn + 0'
0209                       even
0210               
0211               txt.fctn.1
0212 79C6 0866             byte  8
0213 79C7 ....             text  'fctn + 1'
0214                       even
0215               
0216               txt.fctn.2
0217 79D0 0866             byte  8
0218 79D1 ....             text  'fctn + 2'
0219                       even
0220               
0221               txt.fctn.3
0222 79DA 0866             byte  8
0223 79DB ....             text  'fctn + 3'
0224                       even
0225               
0226               txt.fctn.4
0227 79E4 0866             byte  8
0228 79E5 ....             text  'fctn + 4'
0229                       even
0230               
0231               txt.fctn.5
0232 79EE 0866             byte  8
0233 79EF ....             text  'fctn + 5'
0234                       even
0235               
0236               txt.fctn.6
0237 79F8 0866             byte  8
0238 79F9 ....             text  'fctn + 6'
0239                       even
0240               
0241               txt.fctn.7
0242 7A02 0866             byte  8
0243 7A03 ....             text  'fctn + 7'
0244                       even
0245               
0246               txt.fctn.8
0247 7A0C 0866             byte  8
0248 7A0D ....             text  'fctn + 8'
0249                       even
0250               
0251               txt.fctn.9
0252 7A16 0866             byte  8
0253 7A17 ....             text  'fctn + 9'
0254                       even
0255               
0256               txt.fctn.a
0257 7A20 0866             byte  8
0258 7A21 ....             text  'fctn + a'
0259                       even
0260               
0261               txt.fctn.b
0262 7A2A 0866             byte  8
0263 7A2B ....             text  'fctn + b'
0264                       even
0265               
0266               txt.fctn.c
0267 7A34 0866             byte  8
0268 7A35 ....             text  'fctn + c'
0269                       even
0270               
0271               txt.fctn.d
0272 7A3E 0866             byte  8
0273 7A3F ....             text  'fctn + d'
0274                       even
0275               
0276               txt.fctn.e
0277 7A48 0866             byte  8
0278 7A49 ....             text  'fctn + e'
0279                       even
0280               
0281               txt.fctn.f
0282 7A52 0866             byte  8
0283 7A53 ....             text  'fctn + f'
0284                       even
0285               
0286               txt.fctn.g
0287 7A5C 0866             byte  8
0288 7A5D ....             text  'fctn + g'
0289                       even
0290               
0291               txt.fctn.h
0292 7A66 0866             byte  8
0293 7A67 ....             text  'fctn + h'
0294                       even
0295               
0296               txt.fctn.i
0297 7A70 0866             byte  8
0298 7A71 ....             text  'fctn + i'
0299                       even
0300               
0301               txt.fctn.j
0302 7A7A 0866             byte  8
0303 7A7B ....             text  'fctn + j'
0304                       even
0305               
0306               txt.fctn.k
0307 7A84 0866             byte  8
0308 7A85 ....             text  'fctn + k'
0309                       even
0310               
0311               txt.fctn.l
0312 7A8E 0866             byte  8
0313 7A8F ....             text  'fctn + l'
0314                       even
0315               
0316               txt.fctn.m
0317 7A98 0866             byte  8
0318 7A99 ....             text  'fctn + m'
0319                       even
0320               
0321               txt.fctn.n
0322 7AA2 0866             byte  8
0323 7AA3 ....             text  'fctn + n'
0324                       even
0325               
0326               txt.fctn.o
0327 7AAC 0866             byte  8
0328 7AAD ....             text  'fctn + o'
0329                       even
0330               
0331               txt.fctn.p
0332 7AB6 0866             byte  8
0333 7AB7 ....             text  'fctn + p'
0334                       even
0335               
0336               txt.fctn.q
0337 7AC0 0866             byte  8
0338 7AC1 ....             text  'fctn + q'
0339                       even
0340               
0341               txt.fctn.r
0342 7ACA 0866             byte  8
0343 7ACB ....             text  'fctn + r'
0344                       even
0345               
0346               txt.fctn.s
0347 7AD4 0866             byte  8
0348 7AD5 ....             text  'fctn + s'
0349                       even
0350               
0351               txt.fctn.t
0352 7ADE 0866             byte  8
0353 7ADF ....             text  'fctn + t'
0354                       even
0355               
0356               txt.fctn.u
0357 7AE8 0866             byte  8
0358 7AE9 ....             text  'fctn + u'
0359                       even
0360               
0361               txt.fctn.v
0362 7AF2 0866             byte  8
0363 7AF3 ....             text  'fctn + v'
0364                       even
0365               
0366               txt.fctn.w
0367 7AFC 0866             byte  8
0368 7AFD ....             text  'fctn + w'
0369                       even
0370               
0371               txt.fctn.x
0372 7B06 0866             byte  8
0373 7B07 ....             text  'fctn + x'
0374                       even
0375               
0376               txt.fctn.y
0377 7B10 0866             byte  8
0378 7B11 ....             text  'fctn + y'
0379                       even
0380               
0381               txt.fctn.z
0382 7B1A 0866             byte  8
0383 7B1B ....             text  'fctn + z'
0384                       even
0385               
0386               *---------------------------------------------------------------
0387               * Keyboard labels - Function keys extra
0388               *---------------------------------------------------------------
0389               txt.fctn.dot
0390 7B24 0866             byte  8
0391 7B25 ....             text  'fctn + .'
0392                       even
0393               
0394               txt.fctn.plus
0395 7B2E 0866             byte  8
0396 7B2F ....             text  'fctn + +'
0397                       even
0398               
0399               *---------------------------------------------------------------
0400               * Keyboard labels - Control keys
0401               *---------------------------------------------------------------
0402               txt.ctrl.0
0403 7B38 0863             byte  8
0404 7B39 ....             text  'ctrl + 0'
0405                       even
0406               
0407               txt.ctrl.1
0408 7B42 0863             byte  8
0409 7B43 ....             text  'ctrl + 1'
0410                       even
0411               
0412               txt.ctrl.2
0413 7B4C 0863             byte  8
0414 7B4D ....             text  'ctrl + 2'
0415                       even
0416               
0417               txt.ctrl.3
0418 7B56 0863             byte  8
0419 7B57 ....             text  'ctrl + 3'
0420                       even
0421               
0422               txt.ctrl.4
0423 7B60 0863             byte  8
0424 7B61 ....             text  'ctrl + 4'
0425                       even
0426               
0427               txt.ctrl.5
0428 7B6A 0863             byte  8
0429 7B6B ....             text  'ctrl + 5'
0430                       even
0431               
0432               txt.ctrl.6
0433 7B74 0863             byte  8
0434 7B75 ....             text  'ctrl + 6'
0435                       even
0436               
0437               txt.ctrl.7
0438 7B7E 0863             byte  8
0439 7B7F ....             text  'ctrl + 7'
0440                       even
0441               
0442               txt.ctrl.8
0443 7B88 0863             byte  8
0444 7B89 ....             text  'ctrl + 8'
0445                       even
0446               
0447               txt.ctrl.9
0448 7B92 0863             byte  8
0449 7B93 ....             text  'ctrl + 9'
0450                       even
0451               
0452               txt.ctrl.a
0453 7B9C 0863             byte  8
0454 7B9D ....             text  'ctrl + a'
0455                       even
0456               
0457               txt.ctrl.b
0458 7BA6 0863             byte  8
0459 7BA7 ....             text  'ctrl + b'
0460                       even
0461               
0462               txt.ctrl.c
0463 7BB0 0863             byte  8
0464 7BB1 ....             text  'ctrl + c'
0465                       even
0466               
0467               txt.ctrl.d
0468 7BBA 0863             byte  8
0469 7BBB ....             text  'ctrl + d'
0470                       even
0471               
0472               txt.ctrl.e
0473 7BC4 0863             byte  8
0474 7BC5 ....             text  'ctrl + e'
0475                       even
0476               
0477               txt.ctrl.f
0478 7BCE 0863             byte  8
0479 7BCF ....             text  'ctrl + f'
0480                       even
0481               
0482               txt.ctrl.g
0483 7BD8 0863             byte  8
0484 7BD9 ....             text  'ctrl + g'
0485                       even
0486               
0487               txt.ctrl.h
0488 7BE2 0863             byte  8
0489 7BE3 ....             text  'ctrl + h'
0490                       even
0491               
0492               txt.ctrl.i
0493 7BEC 0863             byte  8
0494 7BED ....             text  'ctrl + i'
0495                       even
0496               
0497               txt.ctrl.j
0498 7BF6 0863             byte  8
0499 7BF7 ....             text  'ctrl + j'
0500                       even
0501               
0502               txt.ctrl.k
0503 7C00 0863             byte  8
0504 7C01 ....             text  'ctrl + k'
0505                       even
0506               
0507               txt.ctrl.l
0508 7C0A 0863             byte  8
0509 7C0B ....             text  'ctrl + l'
0510                       even
0511               
0512               txt.ctrl.m
0513 7C14 0863             byte  8
0514 7C15 ....             text  'ctrl + m'
0515                       even
0516               
0517               txt.ctrl.n
0518 7C1E 0863             byte  8
0519 7C1F ....             text  'ctrl + n'
0520                       even
0521               
0522               txt.ctrl.o
0523 7C28 0863             byte  8
0524 7C29 ....             text  'ctrl + o'
0525                       even
0526               
0527               txt.ctrl.p
0528 7C32 0863             byte  8
0529 7C33 ....             text  'ctrl + p'
0530                       even
0531               
0532               txt.ctrl.q
0533 7C3C 0863             byte  8
0534 7C3D ....             text  'ctrl + q'
0535                       even
0536               
0537               txt.ctrl.r
0538 7C46 0863             byte  8
0539 7C47 ....             text  'ctrl + r'
0540                       even
0541               
0542               txt.ctrl.s
0543 7C50 0863             byte  8
0544 7C51 ....             text  'ctrl + s'
0545                       even
0546               
0547               txt.ctrl.t
0548 7C5A 0863             byte  8
0549 7C5B ....             text  'ctrl + t'
0550                       even
0551               
0552               txt.ctrl.u
0553 7C64 0863             byte  8
0554 7C65 ....             text  'ctrl + u'
0555                       even
0556               
0557               txt.ctrl.v
0558 7C6E 0863             byte  8
0559 7C6F ....             text  'ctrl + v'
0560                       even
0561               
0562               txt.ctrl.w
0563 7C78 0863             byte  8
0564 7C79 ....             text  'ctrl + w'
0565                       even
0566               
0567               txt.ctrl.x
0568 7C82 0863             byte  8
0569 7C83 ....             text  'ctrl + x'
0570                       even
0571               
0572               txt.ctrl.y
0573 7C8C 0863             byte  8
0574 7C8D ....             text  'ctrl + y'
0575                       even
0576               
0577               txt.ctrl.z
0578 7C96 0863             byte  8
0579 7C97 ....             text  'ctrl + z'
0580                       even
0581               
0582               *---------------------------------------------------------------
0583               * Keyboard labels - control keys extra
0584               *---------------------------------------------------------------
0585               txt.ctrl.plus
0586 7CA0 0863             byte  8
0587 7CA1 ....             text  'ctrl + +'
0588                       even
0589               
0590               *---------------------------------------------------------------
0591               * Special keys
0592               *---------------------------------------------------------------
0593               txt.enter
0594 7CAA 0565             byte  5
0595 7CAB ....             text  'enter'
0596                       even
0597               
**** **** ****     > stevie_b1.asm.476537
0103                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 7CB0 0D00             data  key.enter, txt.enter, edkey.action.enter
     7CB2 7CAA 
     7CB4 6560 
0106 7CB6 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7CB8 7AD4 
     7CBA 615E 
0107 7CBC 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7CBE 7A3E 
     7CC0 6174 
0108 7CC2 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7CC4 7A48 
     7CC6 618C 
0109 7CC8 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7CCA 7B06 
     7CCC 61DE 
0110 7CCE 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7CD0 7B9C 
     7CD2 624A 
0111 7CD4 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7CD6 7BCE 
     7CD8 6262 
0112 7CDA 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7CDC 7C50 
     7CDE 6276 
0113 7CE0 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     7CE2 7BBA 
     7CE4 62C8 
0114 7CE6 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7CE8 7BC4 
     7CEA 6328 
0115 7CEC 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7CEE 7C82 
     7CF0 636A 
0116 7CF2 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7CF4 7C5A 
     7CF6 6396 
0117 7CF8 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7CFA 7BA6 
     7CFC 63C2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7CFE 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7D00 79C6 
     7D02 6402 
0122 7D04 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7D06 7C00 
     7D08 643A 
0123 7D0A 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7D0C 79DA 
     7D0E 646E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 7D10 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7D12 79D0 
     7D14 64C6 
0128 7D16 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7D18 7B24 
     7D1A 65CE 
0129 7D1C 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7D1E 79EE 
     7D20 651C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 7D22 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7D24 7B2E 
     7D26 661E 
0134 7D28 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7D2A 7C96 
     7D2C 736E 
0135                       ;-------------------------------------------------------
0136                       ; Editor/File buffer keys
0137                       ;-------------------------------------------------------
0138 7D2E B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7D30 7B38 
     7D32 6634 
0139 7D34 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7D36 7B42 
     7D38 663A 
0140 7D3A B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7D3C 7B4C 
     7D3E 6640 
0141 7D40 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7D42 7B56 
     7D44 6646 
0142 7D46 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7D48 7B60 
     7D4A 664C 
0143 7D4C B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7D4E 7B6A 
     7D50 6652 
0144 7D52 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7D54 7B74 
     7D56 6658 
0145 7D58 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7D5A 7B7E 
     7D5C 665E 
0146 7D5E 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7D60 7B88 
     7D62 6664 
0147 7D64 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7D66 7B92 
     7D68 666A 
0148                       ;-------------------------------------------------------
0149                       ; Dialog keys
0150                       ;-------------------------------------------------------
0151 7D6A 8C00             data  key.ctrl.l, txt.ctrl.l, dialog.loaddv80
     7D6C 7C0A 
     7D6E 76E0 
0152                       ;-------------------------------------------------------
0153                       ; End of list
0154                       ;-------------------------------------------------------
0155 7D70 FFFF             data  EOL                           ; EOL
0156               
0157               
0158               
0159               
0160               *---------------------------------------------------------------
0161               * Action keys mapping table: Command Buffer (CMDB)
0162               *---------------------------------------------------------------
0163               keymap_actions.cmdb:
0164                       ;-------------------------------------------------------
0165                       ; Movement keys
0166                       ;-------------------------------------------------------
0167 7D72 0800             data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
     7D74 7AD4 
     7D76 6678 
0168 7D78 0900             data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
     7D7A 7A3E 
     7D7C 668A 
0169 7D7E 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
     7D80 7B9C 
     7D82 669E 
0170                       ;-------------------------------------------------------
0171                       ; Modified keys
0172                       ;-------------------------------------------------------
0173 7D84 0700             data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
     7D86 79DA 
     7D88 66CA 
0174 7D8A 0D00             data  key.enter, txt.enter, edkey.action.cmdb.loadfile
     7D8C 7CAA 
     7D8E 6720 
0175                       ;-------------------------------------------------------
0176                       ; Other action keys
0177                       ;-------------------------------------------------------
0178 7D90 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7D92 7B2E 
     7D94 661E 
0179 7D96 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
     7D98 7A16 
     7D9A 6718 
0180 7D9C 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7D9E 7C96 
     7DA0 736E 
0181                       ;-------------------------------------------------------
0182                       ; End of list
0183                       ;-------------------------------------------------------
0184 7DA2 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.476537
0104               
0108 7DA4 7DA4                   data $                ; Bank 1 ROM size OK.
0110               
0111               *--------------------------------------------------------------
0112               * Video mode configuration
0113               *--------------------------------------------------------------
0114      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0115      0004     spfbck  equ   >04                   ; Screen background color.
0116      76F4     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0117      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0118      0050     colrow  equ   80                    ; Columns per row
0119      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0120      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0121      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0122      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

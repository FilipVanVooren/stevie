XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.asm.8885
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi_b1.asm                 ; Version 200509-8885
0010               
0011               
0012               ***************************************************************
0013               * BANK 1 - TiVi support modules
0014               ********|*****|*********************|**************************
0015                       aorg  >6000
0016                       save  >6000,>7fff           ; Save bank 1
0017                       copy  "equates.asm"         ; Equates TiVi configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.asm                 ; Version 200509-8885
0010               *--------------------------------------------------------------
0011               * TiVi memory layout
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
0032               * 6000-7fff    8192       1   TiVi program code
0033               *
0034               *
0035               * HIGH MEMORY EXPANSION (a000-ffff)
0036               *
0037               * Mem range   Bytes    BANK   Purpose
0038               * =========   =====    ====   ==================================
0039               * a000-a0ff     256           TiVI Editor shared structure
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
0062               * 1000                        PDT - Pattern Descriptor Table
0063               * 1800                        SPT - Sprite Pattern Table
0064               * 2000                        SAT - Sprite Attribute List
0065               *--------------------------------------------------------------
0066               * Skip unused spectra2 code modules for reduced code size
0067               *--------------------------------------------------------------
0068      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0069      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0070      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0071      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0072      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0073      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0074      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0075      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0076      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0077      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0078      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0079      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0080      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0081      0001     skip_random_generator     equ  1       ; Skip random functions
0082      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0083               *--------------------------------------------------------------
0084               * SPECTRA2 / TiVi startup options
0085               *--------------------------------------------------------------
0086      0001     debug                     equ  1       ; Turn on spectra2 debugging
0087      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0088                                                      ; memory address @cpu.scrpad.tgt
0089      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0090      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0091      6050     kickstart.code2           equ  >6050   ; Uniform aorg entry addr start of code
0092               *--------------------------------------------------------------
0093               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0094               *--------------------------------------------------------------
0095               ;                 equ  >8342           ; >8342-834F **free***
0096      8350     parm1             equ  >8350           ; Function parameter 1
0097      8352     parm2             equ  >8352           ; Function parameter 2
0098      8354     parm3             equ  >8354           ; Function parameter 3
0099      8356     parm4             equ  >8356           ; Function parameter 4
0100      8358     parm5             equ  >8358           ; Function parameter 5
0101      835A     parm6             equ  >835a           ; Function parameter 6
0102      835C     parm7             equ  >835c           ; Function parameter 7
0103      835E     parm8             equ  >835e           ; Function parameter 8
0104      8360     outparm1          equ  >8360           ; Function output parameter 1
0105      8362     outparm2          equ  >8362           ; Function output parameter 2
0106      8364     outparm3          equ  >8364           ; Function output parameter 3
0107      8366     outparm4          equ  >8366           ; Function output parameter 4
0108      8368     outparm5          equ  >8368           ; Function output parameter 5
0109      836A     outparm6          equ  >836a           ; Function output parameter 6
0110      836C     outparm7          equ  >836c           ; Function output parameter 7
0111      836E     outparm8          equ  >836e           ; Function output parameter 8
0112      8370     timers            equ  >8370           ; Timer table
0113      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0114      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0115               *--------------------------------------------------------------
0116               * Scratchpad backup 1               @>3e00-3eff     (256 bytes)
0117               * Scratchpad backup 2               @>3f00-3fff     (256 bytes)
0118               *--------------------------------------------------------------
0119      3E00     cpu.scrpad.tgt    equ  >3e00           ; Destination cpu.scrpad.backup/restore
0120      3E00     scrpad.backup1    equ  >3e00           ; Backup GPL layout
0121      3F00     scrpad.backup2    equ  >3f00           ; Backup spectra2 layout
0122               *--------------------------------------------------------------
0123               * TiVi Editor shared structures     @>a000-a0ff     (256 bytes)
0124               *--------------------------------------------------------------
0125      A000     tv.top            equ  >a000           ; Structure begin
0126      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0127      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0128      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0129      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0130      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0131      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0132      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0133      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0134      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0135      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-4)
0136      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color
0137      A016     tv.pane.focus     equ  tv.top + 22     ; Identify pane that has focus
0138      A016     tv.end            equ  tv.top + 22     ; End of structure
0139      0000     pane.focus.fb     equ  0               ; Editor pane has focus
0140      0001     pane.focus.cmdb   equ  1               ; Command buffer pane has focus
0141               *--------------------------------------------------------------
0142               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0143               *--------------------------------------------------------------
0144      A100     fb.struct         equ  >a100           ; Structure begin
0145      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0146      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0147      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0148                                                      ; line X in editor buffer).
0149      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0150                                                      ; (offset 0 .. @fb.scrrows)
0151      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0152      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0153      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0154      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0155      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0156      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0157      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0158      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0159      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0160      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0161      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0162               *--------------------------------------------------------------
0163               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0164               *--------------------------------------------------------------
0165      A200     edb.struct        equ  >a200           ; Begin structure
0166      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0167      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0168      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0169      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0170      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0171      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0172      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0173      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0174                                                      ; with current filename.
0175      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0176                                                      ; with current file type.
0177      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0178      A214     edb.end           equ  edb.struct + 20 ; End of structure
0179               *--------------------------------------------------------------
0180               * Command buffer structure          @>a300-a3ff     (256 bytes)
0181               *--------------------------------------------------------------
0182      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0183      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer
0184      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0185      A304     cmdb.scrrows      equ  cmdb.struct + 4 ; Current size of cmdb pane (in rows)
0186      A306     cmdb.default      equ  cmdb.struct + 6 ; Default size of cmdb pane (in rows)
0187      A308     cmdb.cursor       equ  cmdb.struct + 8 ; Screen YX of cursor in cmdb pane
0188      A30A     cmdb.yxsave       equ  cmdb.struct + 10; Copy of WYX
0189      A30C     cmdb.yxtop        equ  cmdb.struct + 12; YX position of first row in cmdb pane
0190      A30E     cmdb.lines        equ  cmdb.struct + 14; Total lines in editor buffer
0191      A310     cmdb.dirty        equ  cmdb.struct + 16; Editor buffer dirty (Text changed!)
0192      A312     cmdb.fb.yxsave    equ  cmdb.struct + 18; Copy of FB WYX when entering cmdb pane
0193      A314     cmdb.end          equ  cmdb.struct + 20; End of structure
0194               *--------------------------------------------------------------
0195               * File handle structure             @>a400-a4ff     (256 bytes)
0196               *--------------------------------------------------------------
0197      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0198      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0199      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0200      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0201      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0202      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0203      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0204      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0205      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0206      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0207      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0208      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0209      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0210      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0211      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0212      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0213      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0214      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0215      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0216      A496     fh.end            equ  fh.struct +150  ; End of structure
0217      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0218      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0219               *--------------------------------------------------------------
0220               * Index structure                   @>a500-a5ff     (256 bytes)
0221               *--------------------------------------------------------------
0222      A500     idx.struct        equ  >a500           ; TiVi index structure
0223      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0224      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0225      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0226               *--------------------------------------------------------------
0227               * Frame buffer                      @>a600-afff    (2560 bytes)
0228               *--------------------------------------------------------------
0229      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0230      0960     fb.size           equ  80*30           ; Frame buffer size
0231               *--------------------------------------------------------------
0232               * Index                             @>b000-bfff    (4096 bytes)
0233               *--------------------------------------------------------------
0234      B000     idx.top           equ  >b000           ; Top of index
0235      1000     idx.size          equ  4096            ; Index size
0236               *--------------------------------------------------------------
0237               * Editor buffer                     @>c000-cfff    (4096 bytes)
0238               *--------------------------------------------------------------
0239      C000     edb.top           equ  >c000           ; Editor buffer high memory
0240      1000     edb.size          equ  4096            ; Editor buffer size
0241               *--------------------------------------------------------------
0242               * Command buffer                    @>d000-dfff    (4096 bytes)
0243               *--------------------------------------------------------------
0244      D000     cmdb.top          equ  >d000           ; Top of command buffer
0245      1000     cmdb.size         equ  4096            ; Command buffer size
0246               *--------------------------------------------------------------
0247               * *** FREE ***                      @>f000-ffff    (4096 bytes)
0248               *--------------------------------------------------------------
**** **** ****     > tivi_b1.asm.8885
0018                       copy  "kickstart.asm"       ; Cartridge header
**** **** ****     > kickstart.asm
0001               * FILE......: kickstart.asm
0002               * Purpose...: Bankswitch routine for starting TiVi
0003               
0004               ***************************************************************
0005               * TiVi Cartridge Header & kickstart ROM bank 0
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
0030 6014 1054             byte  16
0031 6015 ....             text  'TIVI 200509-8885'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > tivi_b1.asm.8885
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
0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0011               * R9      Stack pointer
0012               * R10     Highest slot in use + Timer counter
0013               * R11     Subroutine return address
0014               * R12     CRU
0015               * R13     Copy of VDP status byte and counter for sound player
0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0017               * R15     VDP read/write address
0018               *--------------------------------------------------------------
0019               * Special purpose registers
0020               * R0      shift count
0021               * R12     CRU
0022               * R13     WS     - when using LWPI, BLWP, RTWP
0023               * R14     PC     - when using LWPI, BLWP, RTWP
0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0025               ***************************************************************
0026               * Define registers
0027               ********|*****|*********************|**************************
0028      0000     r0      equ   0
0029      0001     r1      equ   1
0030      0002     r2      equ   2
0031      0003     r3      equ   3
0032      0004     r4      equ   4
0033      0005     r5      equ   5
0034      0006     r6      equ   6
0035      0007     r7      equ   7
0036      0008     r8      equ   8
0037      0009     r9      equ   9
0038      000A     r10     equ   10
0039      000B     r11     equ   11
0040      000C     r12     equ   12
0041      000D     r13     equ   13
0042      000E     r14     equ   14
0043      000F     r15     equ   15
0044               ***************************************************************
0045               * Define register equates
0046               ********|*****|*********************|**************************
0047      0002     config  equ   r2                    ; Config register
0048      0003     xconfig equ   r3                    ; Extended config register
0049      0004     tmp0    equ   r4                    ; Temp register 0
0050      0005     tmp1    equ   r5                    ; Temp register 1
0051      0006     tmp2    equ   r6                    ; Temp register 2
0052      0007     tmp3    equ   r7                    ; Temp register 3
0053      0008     tmp4    equ   r8                    ; Temp register 4
0054      0009     stack   equ   r9                    ; Stack pointer
0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0057               ***************************************************************
0058               * Define MSB/LSB equates for registers
0059               ********|*****|*********************|**************************
0060      8300     r0hb    equ   ws1                   ; HI byte R0
0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0092               ********|*****|*********************|**************************
0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0103               ********|*****|*********************|**************************
0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0108               ***************************************************************
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
     208E 2D66 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @putat                ; Show crash message
     2092 240E 
0078 2094 0000                   data >0000,cpu.crash.msg.crashed
     2096 216A 
0079               
0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
     209A 2994 
0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 20A4 06A0  32         bl    @putat                ; Show caller message
     20A6 240E 
0090 20A8 0100                   data >0100,cpu.crash.msg.caller
     20AA 2180 
0091               
0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
     20AE 2994 
0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 20B8 06A0  32         bl    @putat
     20BA 240E 
0102 20BC 0300                   byte 3,0
0103 20BE 219A                   data cpu.crash.msg.wp
0104 20C0 06A0  32         bl    @putat
     20C2 240E 
0105 20C4 0400                   byte 4,0
0106 20C6 21A0                   data cpu.crash.msg.st
0107 20C8 06A0  32         bl    @putat
     20CA 240E 
0108 20CC 1600                   byte 22,0
0109 20CE 21A6                   data cpu.crash.msg.source
0110 20D0 06A0  32         bl    @putat
     20D2 240E 
0111 20D4 1700                   byte 23,0
0112 20D6 21C0                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
     20DA 264C 
0117 20DC 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 20DE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20E0 FFDC 
0121 20E2 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 20E4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 20E6 0649  14         dect  stack
0127 20E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 20EA 0649  14         dect  stack
0129 20EC C645  30         mov   tmp1,*stack           ; Push tmp1
0130 20EE 0649  14         dect  stack
0131 20F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 20F2 C046  18         mov   tmp2,r1               ; Save register number
0137 20F4 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     20F6 0001 
0138 20F8 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 20FA 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 20FC 06A0  32         bl    @mknum
     20FE 299E 
0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
     2108 2662 
0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     210E 23FC 
0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
     2114 2662 
0157 2116 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 2118 0281  22         ci    r1,10
     211A 000A 
0161 211C 1102  14         jlt   !
0162 211E 0620  34         dec   @wyx                  ; x=x-1
     2120 832A 
0163               
0164 2122 06A0  32 !       bl    @putstr
     2124 23FC 
0165 2126 2196                   data cpu.crash.msg.r
0166               
0167 2128 06A0  32         bl    @mknum
     212A 299E 
0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
     2134 2910 
0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
     213E 2662 
0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 2142 06A0  32         bl    @putstr
     2144 23FC 
0187 2146 2198                   data cpu.crash.msg.marker
0188               
0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
     214A 2662 
0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2150 23FC 
0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 215A 06A0  32         bl    @down                 ; y=y+1
     215C 2652 
0202               
0203 215E 0586  14         inc   tmp2
0204 2160 0286  22         ci    tmp2,17
     2162 0011 
0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2168 2C74 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 216A 1553             byte  21
0214 216B ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 2180 1543             byte  21
0219 2181 ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 2196 0152             byte  1
0224 2197 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 2198 013E             byte  1
0229 2199 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 219A 042A             byte  4
0234 219B ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 21A0 042A             byte  4
0239 21A1 ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 21A6 1953             byte  25
0244 21A7 ....             text  'Source    tivi_b1.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 21C0 1542             byte  21
0249 21C1 ....             text  'Build-ID  200509-8885'
0250                       even
0251               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21D6 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21D8 000E 
     21DA 0106 
     21DC 0204 
     21DE 0020 
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
0032 21E0 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21E2 000E 
     21E4 0106 
     21E6 00F4 
     21E8 0028 
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
0058 21EA 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21EC 003F 
     21EE 0240 
     21F0 03F4 
     21F2 0050 
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
0084 21F4 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21F6 003F 
     21F8 0240 
     21FA 03F4 
     21FC 0050 
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
0013 21FE 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2200 16FD             data  >16fd                 ; |         jne   mcloop
0015 2202 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2204 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2206 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 2208 C0F9  30 popr3   mov   *stack+,r3
0039 220A C0B9  30 popr2   mov   *stack+,r2
0040 220C C079  30 popr1   mov   *stack+,r1
0041 220E C039  30 popr0   mov   *stack+,r0
0042 2210 C2F9  30 poprt   mov   *stack+,r11
0043 2212 045B  20         b     *r11
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
0067 2214 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 2216 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 2218 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 221A C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 221C 1604  14         jne   filchk                ; No, continue checking
0075               
0076 221E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2220 FFCE 
0077 2222 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2224 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 2226 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2228 830B 
     222A 830A 
0082               
0083 222C 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     222E 0001 
0084 2230 1602  14         jne   filchk2
0085 2232 DD05  32         movb  tmp1,*tmp0+
0086 2234 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 2236 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2238 0002 
0091 223A 1603  14         jne   filchk3
0092 223C DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 223E DD05  32         movb  tmp1,*tmp0+
0094 2240 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 2242 C1C4  18 filchk3 mov   tmp0,tmp3
0099 2244 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2246 0001 
0100 2248 1605  14         jne   fil16b
0101 224A DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 224C 0606  14         dec   tmp2
0103 224E 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2250 0002 
0104 2252 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2254 C1C6  18 fil16b  mov   tmp2,tmp3
0109 2256 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2258 0001 
0110 225A 1301  14         jeq   dofill
0111 225C 0606  14         dec   tmp2                  ; Make TMP2 even
0112 225E CD05  34 dofill  mov   tmp1,*tmp0+
0113 2260 0646  14         dect  tmp2
0114 2262 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2264 C1C7  18         mov   tmp3,tmp3
0119 2266 1301  14         jeq   fil.$$
0120 2268 DD05  32         movb  tmp1,*tmp0+
0121 226A 045B  20 fil.$$  b     *r11
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
0140 226C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 226E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 2270 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 2272 0264  22 xfilv   ori   tmp0,>4000
     2274 4000 
0147 2276 06C4  14         swpb  tmp0
0148 2278 D804  38         movb  tmp0,@vdpa
     227A 8C02 
0149 227C 06C4  14         swpb  tmp0
0150 227E D804  38         movb  tmp0,@vdpa
     2280 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 2282 020F  20         li    r15,vdpw              ; Set VDP write address
     2284 8C00 
0155 2286 06C5  14         swpb  tmp1
0156 2288 C820  54         mov   @filzz,@mcloop        ; Setup move command
     228A 2292 
     228C 8320 
0157 228E 0460  28         b     @mcloop               ; Write data to VDP
     2290 8320 
0158               *--------------------------------------------------------------
0162 2292 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 2294 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     2296 4000 
0183 2298 06C4  14 vdra    swpb  tmp0
0184 229A D804  38         movb  tmp0,@vdpa
     229C 8C02 
0185 229E 06C4  14         swpb  tmp0
0186 22A0 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22A2 8C02 
0187 22A4 045B  20         b     *r11                  ; Exit
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
0198 22A6 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22A8 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22AA 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22AC 4000 
0204 22AE 06C4  14         swpb  tmp0                  ; \
0205 22B0 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22B2 8C02 
0206 22B4 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22B6 D804  38         movb  tmp0,@vdpa            ; /
     22B8 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22BA 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22BC D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22BE 045B  20         b     *r11                  ; Exit
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
0232 22C0 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22C2 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22C4 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22C6 8C02 
0238 22C8 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22CA D804  38         movb  tmp0,@vdpa            ; /
     22CC 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22CE D120  34         movb  @vdpr,tmp0            ; Read byte
     22D0 8800 
0244 22D2 0984  56         srl   tmp0,8                ; Right align
0245 22D4 045B  20         b     *r11                  ; Exit
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
0264 22D6 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22D8 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22DA C144  18         mov   tmp0,tmp1
0270 22DC 05C5  14         inct  tmp1
0271 22DE D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22E0 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22E2 FF00 
0273 22E4 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 22E6 C805  38         mov   tmp1,@wbase           ; Store calculated base
     22E8 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 22EA 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     22EC 8000 
0279 22EE 0206  20         li    tmp2,8
     22F0 0008 
0280 22F2 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     22F4 830B 
0281 22F6 06C5  14         swpb  tmp1
0282 22F8 D805  38         movb  tmp1,@vdpa
     22FA 8C02 
0283 22FC 06C5  14         swpb  tmp1
0284 22FE D805  38         movb  tmp1,@vdpa
     2300 8C02 
0285 2302 0225  22         ai    tmp1,>0100
     2304 0100 
0286 2306 0606  14         dec   tmp2
0287 2308 16F4  14         jne   vidta1                ; Next register
0288 230A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     230C 833A 
0289 230E 045B  20         b     *r11
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
0306 2310 C13B  30 putvr   mov   *r11+,tmp0
0307 2312 0264  22 putvrx  ori   tmp0,>8000
     2314 8000 
0308 2316 06C4  14         swpb  tmp0
0309 2318 D804  38         movb  tmp0,@vdpa
     231A 8C02 
0310 231C 06C4  14         swpb  tmp0
0311 231E D804  38         movb  tmp0,@vdpa
     2320 8C02 
0312 2322 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2324 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 2326 C10E  18         mov   r14,tmp0
0322 2328 0984  56         srl   tmp0,8
0323 232A 06A0  32         bl    @putvrx               ; Write VR#0
     232C 2312 
0324 232E 0204  20         li    tmp0,>0100
     2330 0100 
0325 2332 D820  54         movb  @r14lb,@tmp0lb
     2334 831D 
     2336 8309 
0326 2338 06A0  32         bl    @putvrx               ; Write VR#1
     233A 2312 
0327 233C 0458  20         b     *tmp4                 ; Exit
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
0341 233E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 2340 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 2342 C11B  26         mov   *r11,tmp0             ; Get P0
0344 2344 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2346 7FFF 
0345 2348 2120  38         coc   @wbit0,tmp0
     234A 202A 
0346 234C 1604  14         jne   ldfnt1
0347 234E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2350 8000 
0348 2352 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2354 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 2356 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2358 23C0 
0353 235A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     235C 9C02 
0354 235E 06C4  14         swpb  tmp0
0355 2360 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2362 9C02 
0356 2364 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2366 9800 
0357 2368 06C5  14         swpb  tmp1
0358 236A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     236C 9800 
0359 236E 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 2370 D805  38         movb  tmp1,@grmwa
     2372 9C02 
0364 2374 06C5  14         swpb  tmp1
0365 2376 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     2378 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 237A C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 237C 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     237E 2294 
0371 2380 05C8  14         inct  tmp4                  ; R11=R11+2
0372 2382 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 2384 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     2386 7FFF 
0374 2388 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     238A 23C2 
0375 238C C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     238E 23C4 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 2390 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 2392 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 2394 D120  34         movb  @grmrd,tmp0
     2396 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 2398 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     239A 202A 
0386 239C 1603  14         jne   ldfnt3                ; No, so skip
0387 239E D1C4  18         movb  tmp0,tmp3
0388 23A0 0917  56         srl   tmp3,1
0389 23A2 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23A4 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23A6 8C00 
0394 23A8 0606  14         dec   tmp2
0395 23AA 16F2  14         jne   ldfnt2
0396 23AC 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23AE 020F  20         li    r15,vdpw              ; Set VDP write address
     23B0 8C00 
0398 23B2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23B4 7FFF 
0399 23B6 0458  20         b     *tmp4                 ; Exit
0400 23B8 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23BA 200A 
     23BC 8C00 
0401 23BE 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23C0 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23C2 0200 
     23C4 0000 
0406 23C6 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23C8 01C0 
     23CA 0101 
0407 23CC 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23CE 02A0 
     23D0 0101 
0408 23D2 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23D4 00E0 
     23D6 0101 
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
0426 23D8 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23DA C3A0  34         mov   @wyx,r14              ; Get YX
     23DC 832A 
0428 23DE 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23E0 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23E2 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 23E4 C3A0  34         mov   @wyx,r14              ; Get YX
     23E6 832A 
0435 23E8 024E  22         andi  r14,>00ff             ; Remove Y
     23EA 00FF 
0436 23EC A3CE  18         a     r14,r15               ; pos = pos + X
0437 23EE A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     23F0 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 23F2 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 23F4 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 23F6 020F  20         li    r15,vdpw              ; VDP write address
     23F8 8C00 
0444 23FA 045B  20         b     *r11
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
0459 23FC C17B  30 putstr  mov   *r11+,tmp1
0460 23FE D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 2400 C1CB  18 xutstr  mov   r11,tmp3
0462 2402 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2404 23D8 
0463 2406 C2C7  18         mov   tmp3,r11
0464 2408 0986  56         srl   tmp2,8                ; Right justify length byte
0465 240A 0460  28         b     @xpym2v               ; Display string
     240C 241C 
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
0480 240E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2410 832A 
0481 2412 0460  28         b     @putstr
     2414 23FC 
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
0020 2416 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2418 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 241A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 241C 0264  22 xpym2v  ori   tmp0,>4000
     241E 4000 
0027 2420 06C4  14         swpb  tmp0
0028 2422 D804  38         movb  tmp0,@vdpa
     2424 8C02 
0029 2426 06C4  14         swpb  tmp0
0030 2428 D804  38         movb  tmp0,@vdpa
     242A 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 242C 020F  20         li    r15,vdpw              ; Set VDP write address
     242E 8C00 
0035 2430 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2432 243A 
     2434 8320 
0036 2436 0460  28         b     @mcloop               ; Write data to VDP
     2438 8320 
0037 243A D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 243C C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 243E C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2440 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2442 06C4  14 xpyv2m  swpb  tmp0
0027 2444 D804  38         movb  tmp0,@vdpa
     2446 8C02 
0028 2448 06C4  14         swpb  tmp0
0029 244A D804  38         movb  tmp0,@vdpa
     244C 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 244E 020F  20         li    r15,vdpr              ; Set VDP read address
     2450 8800 
0034 2452 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2454 245C 
     2456 8320 
0035 2458 0460  28         b     @mcloop               ; Read data from VDP
     245A 8320 
0036 245C DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 245E C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 2460 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2462 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2464 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2466 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 2468 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     246A FFCE 
0034 246C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     246E 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2470 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2472 0001 
0039 2474 1603  14         jne   cpym0                 ; No, continue checking
0040 2476 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2478 04C6  14         clr   tmp2                  ; Reset counter
0042 247A 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 247C 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     247E 7FFF 
0047 2480 C1C4  18         mov   tmp0,tmp3
0048 2482 0247  22         andi  tmp3,1
     2484 0001 
0049 2486 1618  14         jne   cpyodd                ; Odd source address handling
0050 2488 C1C5  18 cpym1   mov   tmp1,tmp3
0051 248A 0247  22         andi  tmp3,1
     248C 0001 
0052 248E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2490 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2492 202A 
0057 2494 1605  14         jne   cpym3
0058 2496 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2498 24BE 
     249A 8320 
0059 249C 0460  28         b     @mcloop               ; Copy memory and exit
     249E 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24A0 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24A2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24A4 0001 
0065 24A6 1301  14         jeq   cpym4
0066 24A8 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24AA CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24AC 0646  14         dect  tmp2
0069 24AE 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24B0 C1C7  18         mov   tmp3,tmp3
0074 24B2 1301  14         jeq   cpymz
0075 24B4 D554  38         movb  *tmp0,*tmp1
0076 24B6 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24B8 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24BA 8000 
0081 24BC 10E9  14         jmp   cpym2
0082 24BE DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 24C0 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24C2 0649  14         dect  stack
0065 24C4 C64B  30         mov   r11,*stack            ; Push return address
0066 24C6 0649  14         dect  stack
0067 24C8 C640  30         mov   r0,*stack             ; Push r0
0068 24CA 0649  14         dect  stack
0069 24CC C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24CE 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24D0 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24D2 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24D4 4000 
0077 24D6 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24D8 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 24DA 020C  20         li    r12,>1e00             ; SAMS CRU address
     24DC 1E00 
0082 24DE 04C0  14         clr   r0
0083 24E0 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24E2 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 24E4 D100  18         movb  r0,tmp0
0086 24E6 0984  56         srl   tmp0,8                ; Right align
0087 24E8 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     24EA 833C 
0088 24EC 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 24EE C339  30         mov   *stack+,r12           ; Pop r12
0094 24F0 C039  30         mov   *stack+,r0            ; Pop r0
0095 24F2 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 24F4 045B  20         b     *r11                  ; Return to caller
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
0131 24F6 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 24F8 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 24FA 0649  14         dect  stack
0135 24FC C64B  30         mov   r11,*stack            ; Push return address
0136 24FE 0649  14         dect  stack
0137 2500 C640  30         mov   r0,*stack             ; Push r0
0138 2502 0649  14         dect  stack
0139 2504 C64C  30         mov   r12,*stack            ; Push r12
0140 2506 0649  14         dect  stack
0141 2508 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 250A 0649  14         dect  stack
0143 250C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 250E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2510 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 2512 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2514 001E 
0153 2516 150A  14         jgt   !
0154 2518 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     251A 0004 
0155 251C 1107  14         jlt   !
0156 251E 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2520 0012 
0157 2522 1508  14         jgt   sams.page.set.switch_page
0158 2524 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2526 0006 
0159 2528 1501  14         jgt   !
0160 252A 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 252C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     252E FFCE 
0165 2530 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2532 2030 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 2534 020C  20         li    r12,>1e00             ; SAMS CRU address
     2536 1E00 
0171 2538 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 253A 06C0  14         swpb  r0                    ; LSB to MSB
0173 253C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 253E D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2540 4000 
0175 2542 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 2544 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 2546 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 2548 C339  30         mov   *stack+,r12           ; Pop r12
0183 254A C039  30         mov   *stack+,r0            ; Pop r0
0184 254C C2F9  30         mov   *stack+,r11           ; Pop return address
0185 254E 045B  20         b     *r11                  ; Return to caller
0186               
0187               
0188               
0189               
0190               ***************************************************************
0191               * sams.mapping.on - Enable SAMS mapping mode
0192               ***************************************************************
0193               *  bl   @sams.mapping.on
0194               *--------------------------------------------------------------
0195               *  Register usage
0196               *  r12
0197               ********|*****|*********************|**************************
0198               sams.mapping.on:
0199 2550 020C  20         li    r12,>1e00             ; SAMS CRU address
     2552 1E00 
0200 2554 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 2556 045B  20         b     *r11                  ; Return to caller
0206               
0207               
0208               
0209               
0210               ***************************************************************
0211               * sams.mapping.off - Disable SAMS mapping mode
0212               ***************************************************************
0213               * bl  @sams.mapping.off
0214               *--------------------------------------------------------------
0215               * OUTPUT
0216               * none
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * r12
0220               ********|*****|*********************|**************************
0221               sams.mapping.off:
0222 2558 020C  20         li    r12,>1e00             ; SAMS CRU address
     255A 1E00 
0223 255C 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 255E 045B  20         b     *r11                  ; Return to caller
0229               
0230               
0231               
0232               
0233               
0234               ***************************************************************
0235               * sams.layout
0236               * Setup SAMS memory banks
0237               ***************************************************************
0238               * bl  @sams.layout
0239               *     data P0
0240               *--------------------------------------------------------------
0241               * INPUT
0242               * P0 = Pointer to SAMS page layout table (16 words).
0243               *--------------------------------------------------------------
0244               * bl  @xsams.layout
0245               *
0246               * tmp0 = Pointer to SAMS page layout table (16 words).
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0, tmp1, tmp2, tmp3
0253               ********|*****|*********************|**************************
0254               sams.layout:
0255 2560 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 2562 0649  14         dect  stack
0258 2564 C64B  30         mov   r11,*stack            ; Save return address
0259 2566 0649  14         dect  stack
0260 2568 C644  30         mov   tmp0,*stack           ; Save tmp0
0261 256A 0649  14         dect  stack
0262 256C C645  30         mov   tmp1,*stack           ; Save tmp1
0263 256E 0649  14         dect  stack
0264 2570 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 2572 0649  14         dect  stack
0266 2574 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 2576 0206  20         li    tmp2,8                ; Set loop counter
     2578 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 257A C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 257C C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 257E 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2580 24FA 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 2582 0606  14         dec   tmp2                  ; Next iteration
0283 2584 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 2586 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     2588 2550 
0289                                                   ; / activating changes.
0290               
0291 258A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 258C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 258E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 2590 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 2592 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 2594 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.layout.reset
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.layout.reset
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.layout.reset:
0313 2596 0649  14         dect  stack
0314 2598 C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 259A 06A0  32         bl    @sams.layout
     259C 2560 
0319 259E 25A4                   data sams.layout.standard
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.layout.reset.exit:
0324 25A0 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 25A2 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.layout.standard:
0330 25A4 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25A6 0002 
0331 25A8 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25AA 0003 
0332 25AC A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25AE 000A 
0333 25B0 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25B2 000B 
0334 25B4 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25B6 000C 
0335 25B8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25BA 000D 
0336 25BC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25BE 000E 
0337 25C0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25C2 000F 
0338               
0339               
0340               
0341               ***************************************************************
0342               * sams.layout.copy
0343               * Copy SAMS memory layout
0344               ***************************************************************
0345               * bl  @sams.layout.copy
0346               *     data P0
0347               *--------------------------------------------------------------
0348               * P0 = Pointer to 8 words RAM buffer for results
0349               *--------------------------------------------------------------
0350               * OUTPUT
0351               * RAM buffer will have the SAMS page number for each range
0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0353               *--------------------------------------------------------------
0354               * Register usage
0355               * tmp0, tmp1, tmp2, tmp3
0356               ***************************************************************
0357               sams.layout.copy:
0358 25C4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 25C6 0649  14         dect  stack
0361 25C8 C64B  30         mov   r11,*stack            ; Push return address
0362 25CA 0649  14         dect  stack
0363 25CC C644  30         mov   tmp0,*stack           ; Push tmp0
0364 25CE 0649  14         dect  stack
0365 25D0 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 25D2 0649  14         dect  stack
0367 25D4 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 25D6 0649  14         dect  stack
0369 25D8 C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 25DA 0205  20         li    tmp1,sams.layout.copy.data
     25DC 25FC 
0374 25DE 0206  20         li    tmp2,8                ; Set loop counter
     25E0 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.layout.copy.loop:
0379 25E2 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 25E4 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     25E6 24C2 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 25E8 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     25EA 833C 
0385               
0386 25EC 0606  14         dec   tmp2                  ; Next iteration
0387 25EE 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.layout.copy.exit:
0392 25F0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 25F2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 25F4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 25F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 25F8 C2F9  30         mov   *stack+,r11           ; Pop r11
0397 25FA 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.layout.copy.data:
0402 25FC 2000             data  >2000                 ; >2000-2fff
0403 25FE 3000             data  >3000                 ; >3000-3fff
0404 2600 A000             data  >a000                 ; >a000-afff
0405 2602 B000             data  >b000                 ; >b000-bfff
0406 2604 C000             data  >c000                 ; >c000-cfff
0407 2606 D000             data  >d000                 ; >d000-dfff
0408 2608 E000             data  >e000                 ; >e000-efff
0409 260A F000             data  >f000                 ; >f000-ffff
0410               
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
0009 260C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     260E FFBF 
0010 2610 0460  28         b     @putv01
     2612 2324 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2614 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2616 0040 
0018 2618 0460  28         b     @putv01
     261A 2324 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 261C 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     261E FFDF 
0026 2620 0460  28         b     @putv01
     2622 2324 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2624 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2626 0020 
0034 2628 0460  28         b     @putv01
     262A 2324 
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
0010 262C 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     262E FFFE 
0011 2630 0460  28         b     @putv01
     2632 2324 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2634 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2636 0001 
0019 2638 0460  28         b     @putv01
     263A 2324 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 263C 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     263E FFFD 
0027 2640 0460  28         b     @putv01
     2642 2324 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2644 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2646 0002 
0035 2648 0460  28         b     @putv01
     264A 2324 
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
0018 264C C83B  50 at      mov   *r11+,@wyx
     264E 832A 
0019 2650 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2652 B820  54 down    ab    @hb$01,@wyx
     2654 201C 
     2656 832A 
0028 2658 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 265A 7820  54 up      sb    @hb$01,@wyx
     265C 201C 
     265E 832A 
0037 2660 045B  20         b     *r11
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
0049 2662 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2664 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     2666 832A 
0051 2668 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     266A 832A 
0052 266C 045B  20         b     *r11
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
0021 266E C120  34 yx2px   mov   @wyx,tmp0
     2670 832A 
0022 2672 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2674 06C4  14         swpb  tmp0                  ; Y<->X
0024 2676 04C5  14         clr   tmp1                  ; Clear before copy
0025 2678 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 267A 20A0  38         coc   @wbit1,config         ; f18a present ?
     267C 2028 
0030 267E 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2680 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2682 833A 
     2684 26AE 
0032 2686 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 2688 0A15  56         sla   tmp1,1                ; X = X * 2
0035 268A B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 268C 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     268E 0500 
0037 2690 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2692 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2694 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2696 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 2698 D105  18         movb  tmp1,tmp0
0051 269A 06C4  14         swpb  tmp0                  ; X<->Y
0052 269C 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     269E 202A 
0053 26A0 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26A2 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26A4 201C 
0059 26A6 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26A8 202E 
0060 26AA 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26AC 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26AE 0050            data   80
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
0013 26B0 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26B2 06A0  32         bl    @putvr                ; Write once
     26B4 2310 
0015 26B6 391C             data  >391c                 ; VR1/57, value 00011100
0016 26B8 06A0  32         bl    @putvr                ; Write twice
     26BA 2310 
0017 26BC 391C             data  >391c                 ; VR1/57, value 00011100
0018 26BE 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26C0 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26C2 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26C4 2310 
0028 26C6 391C             data  >391c
0029 26C8 0458  20         b     *tmp4                 ; Exit
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
0040 26CA C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26CC 06A0  32         bl    @cpym2v
     26CE 2416 
0042 26D0 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26D2 270E 
     26D4 0006 
0043 26D6 06A0  32         bl    @putvr
     26D8 2310 
0044 26DA 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26DC 06A0  32         bl    @putvr
     26DE 2310 
0046 26E0 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 26E2 0204  20         li    tmp0,>3f00
     26E4 3F00 
0052 26E6 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     26E8 2298 
0053 26EA D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     26EC 8800 
0054 26EE 0984  56         srl   tmp0,8
0055 26F0 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     26F2 8800 
0056 26F4 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 26F6 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 26F8 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     26FA BFFF 
0060 26FC 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 26FE 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2700 4000 
0063               f18chk_exit:
0064 2702 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2704 226C 
0065 2706 3F00             data  >3f00,>00,6
     2708 0000 
     270A 0006 
0066 270C 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 270E 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2710 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2712 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2714 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2716 06A0  32         bl    @putvr
     2718 2310 
0097 271A 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 271C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     271E 2310 
0100 2720 391C             data  >391c                 ; Lock the F18a
0101 2722 0458  20         b     *tmp4                 ; Exit
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
0120 2724 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2726 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     2728 2028 
0122 272A 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 272C C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     272E 8802 
0127 2730 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2732 2310 
0128 2734 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2736 04C4  14         clr   tmp0
0130 2738 D120  34         movb  @vdps,tmp0
     273A 8802 
0131 273C 0984  56         srl   tmp0,8
0132 273E 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2740 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2742 832A 
0018 2744 D17B  28         movb  *r11+,tmp1
0019 2746 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 2748 D1BB  28         movb  *r11+,tmp2
0021 274A 0986  56         srl   tmp2,8                ; Repeat count
0022 274C C1CB  18         mov   r11,tmp3
0023 274E 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2750 23D8 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2752 020B  20         li    r11,hchar1
     2754 275A 
0028 2756 0460  28         b     @xfilv                ; Draw
     2758 2272 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 275A 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     275C 202C 
0033 275E 1302  14         jeq   hchar2                ; Yes, exit
0034 2760 C2C7  18         mov   tmp3,r11
0035 2762 10EE  14         jmp   hchar                 ; Next one
0036 2764 05C7  14 hchar2  inct  tmp3
0037 2766 0457  20         b     *tmp3                 ; Exit
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
0017 2768 C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     276A 832A 
0018 276C C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 276E C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     2770 833A 
0020 2772 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2774 23D8 
0021 2776 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 2778 D1B7  28         movb  *tmp3+,tmp2
0023 277A 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 277C 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     277E 2294 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 2780 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 2782 A108  18         a     tmp4,tmp0             ; Next row
0033 2784 0606  14         dec   tmp2
0034 2786 16FA  14         jne   vchar2
0035 2788 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     278A 202C 
0036 278C 1303  14         jeq   vchar3                ; Yes, exit
0037 278E C837  50         mov   *tmp3+,@wyx           ; Save YX position
     2790 832A 
0038 2792 10ED  14         jmp   vchar1                ; Next one
0039 2794 05C7  14 vchar3  inct  tmp3
0040 2796 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 2798 C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 279A C804  38         mov   tmp0,@wyx             ; Set cursor position
     279C 832A 
0051 279E 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 27A0 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     27A2 833A 
0053 27A4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A6 23D8 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 27A8 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     27AA 2294 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 27AC D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 27AE A120  34         a     @wcolmn,tmp0          ; Next row
     27B0 833A 
0063 27B2 0606  14         dec   tmp2
0064 27B4 16F9  14         jne   xvcha1
0065 27B6 0458  20         b     *tmp4                 ; Exit
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
0016 27B8 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BA 202A 
0017 27BC 020C  20         li    r12,>0024
     27BE 0024 
0018 27C0 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C2 2850 
0019 27C4 04C6  14         clr   tmp2
0020 27C6 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27C8 04CC  14         clr   r12
0025 27CA 1F08  20         tb    >0008                 ; Shift-key ?
0026 27CC 1302  14         jeq   realk1                ; No
0027 27CE 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D0 2880 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D2 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D4 1302  14         jeq   realk2                ; No
0033 27D6 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27D8 28B0 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DA 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27DC 1302  14         jeq   realk3                ; No
0039 27DE 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E0 28E0 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E2 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27E4 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27E6 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27E8 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27EA 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27EC 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27EE 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F0 0006 
0052 27F2 0606  14 realk5  dec   tmp2
0053 27F4 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F6 0024 
0054 27F8 06C6  14         swpb  tmp2
0055 27FA 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27FC 06C6  14         swpb  tmp2
0057 27FE 020C  20         li    r12,6                 ; CRU read address
     2800 0006 
0058 2802 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 2804 0547  14         inv   tmp3                  ;
0060 2806 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2808 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 280A 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 280C 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 280E 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2810 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2812 0285  22         ci    tmp1,8
     2814 0008 
0069 2816 1AFA  14         jl    realk6
0070 2818 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 281A 1BEB  14         jh    realk5                ; No, next column
0072 281C 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 281E C206  18 realk8  mov   tmp2,tmp4
0077 2820 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2822 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2824 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 2826 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 2828 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 282A D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 282C 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     282E 202A 
0087 2830 1608  14         jne   realka                ; No, continue saving key
0088 2832 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2834 287A 
0089 2836 1A05  14         jl    realka
0090 2838 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     283A 2878 
0091 283C 1B02  14         jh    realka                ; No, continue
0092 283E 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2840 E000 
0093 2842 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2844 833C 
0094 2846 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2848 2014 
0095 284A 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     284C 8C00 
0096 284E 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2850 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2852 0000 
     2854 FF0D 
     2856 203D 
0099 2858 ....             text  'xws29ol.'
0100 2860 ....             text  'ced38ik,'
0101 2868 ....             text  'vrf47ujm'
0102 2870 ....             text  'btg56yhn'
0103 2878 ....             text  'zqa10p;/'
0104 2880 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2882 0000 
     2884 FF0D 
     2886 202B 
0105 2888 ....             text  'XWS@(OL>'
0106 2890 ....             text  'CED#*IK<'
0107 2898 ....             text  'VRF$&UJM'
0108 28A0 ....             text  'BTG%^YHN'
0109 28A8 ....             text  'ZQA!)P:-'
0110 28B0 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B2 0000 
     28B4 FF0D 
     28B6 2005 
0111 28B8 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28BA 0804 
     28BC 0F27 
     28BE C2B9 
0112 28C0 600B             data  >600b,>0907,>063f,>c1B8
     28C2 0907 
     28C4 063F 
     28C6 C1B8 
0113 28C8 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28CA 7B02 
     28CC 015F 
     28CE C0C3 
0114 28D0 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D2 7D0E 
     28D4 0CC6 
     28D6 BFC4 
0115 28D8 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28DA 7C03 
     28DC BC22 
     28DE BDBA 
0116 28E0 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E2 0000 
     28E4 FF0D 
     28E6 209D 
0117 28E8 9897             data  >9897,>93b2,>9f8f,>8c9B
     28EA 93B2 
     28EC 9F8F 
     28EE 8C9B 
0118 28F0 8385             data  >8385,>84b3,>9e89,>8b80
     28F2 84B3 
     28F4 9E89 
     28F6 8B80 
0119 28F8 9692             data  >9692,>86b4,>b795,>8a8D
     28FA 86B4 
     28FC B795 
     28FE 8A8D 
0120 2900 8294             data  >8294,>87b5,>b698,>888E
     2902 87B5 
     2904 B698 
     2906 888E 
0121 2908 9A91             data  >9a91,>81b1,>b090,>9cBB
     290A 81B1 
     290C B090 
     290E 9CBB 
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
0023 2910 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2912 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2914 8340 
0025 2916 04E0  34         clr   @waux1
     2918 833C 
0026 291A 04E0  34         clr   @waux2
     291C 833E 
0027 291E 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2920 833C 
0028 2922 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2924 0205  20         li    tmp1,4                ; 4 nibbles
     2926 0004 
0033 2928 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 292A 0246  22         andi  tmp2,>000f            ; Only keep LSN
     292C 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 292E 0286  22         ci    tmp2,>000a
     2930 000A 
0039 2932 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2934 C21B  26         mov   *r11,tmp4
0045 2936 0988  56         srl   tmp4,8                ; Right justify
0046 2938 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     293A FFF6 
0047 293C 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 293E C21B  26         mov   *r11,tmp4
0054 2940 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2942 00FF 
0055               
0056 2944 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2946 06C6  14         swpb  tmp2
0058 2948 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 294A 0944  56         srl   tmp0,4                ; Next nibble
0060 294C 0605  14         dec   tmp1
0061 294E 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2950 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2952 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2954 C160  34         mov   @waux3,tmp1           ; Get pointer
     2956 8340 
0067 2958 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 295A 0585  14         inc   tmp1                  ; Next byte, not word!
0069 295C C120  34         mov   @waux2,tmp0
     295E 833E 
0070 2960 06C4  14         swpb  tmp0
0071 2962 DD44  32         movb  tmp0,*tmp1+
0072 2964 06C4  14         swpb  tmp0
0073 2966 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2968 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     296A 8340 
0078 296C D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     296E 2020 
0079 2970 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2972 C120  34         mov   @waux1,tmp0
     2974 833C 
0084 2976 06C4  14         swpb  tmp0
0085 2978 DD44  32         movb  tmp0,*tmp1+
0086 297A 06C4  14         swpb  tmp0
0087 297C DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 297E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2980 202A 
0092 2982 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2984 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2986 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2988 7FFF 
0098 298A C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     298C 8340 
0099 298E 0460  28         b     @xutst0               ; Display string
     2990 23FE 
0100 2992 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2994 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2996 832A 
0122 2998 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     299A 8000 
0123 299C 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 299E 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A0 0005 
0020 29A2 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A4 C155  26         mov   *tmp1,tmp1            ; /
0022 29A6 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29A8 0228  22         ai    tmp4,4                ; Get end of buffer
     29AA 0004 
0024 29AC 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29AE 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B0 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B2 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B4 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B6 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29B8 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29BA C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29BC 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29BE 0607  14         dec   tmp3                  ; Decrease counter
0036 29C0 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C2 0207  20         li    tmp3,4                ; Check first 4 digits
     29C4 0004 
0041 29C6 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29C8 C11B  26         mov   *r11,tmp0
0043 29CA 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29CC 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29CE 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D0 05CB  14 mknum3  inct  r11
0047 29D2 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D4 202A 
0048 29D6 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29D8 045B  20         b     *r11                  ; Exit
0050 29DA DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29DC 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29DE 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E0 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E2 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E4 7FFF 
0058 29E6 C10B  18         mov   r11,tmp0
0059 29E8 0224  22         ai    tmp0,-4
     29EA FFFC 
0060 29EC C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29EE 0206  20         li    tmp2,>0500            ; String length = 5
     29F0 0500 
0062 29F2 0460  28         b     @xutstr               ; Display string
     29F4 2400 
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
0092 29F6 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29F8 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29FA C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29FC 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 29FE 0207  20         li    tmp3,5                ; Set counter
     2A00 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A02 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A04 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A06 0584  14         inc   tmp0                  ; Next character
0104 2A08 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A0A 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A0C 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A0E 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A10 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A12 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A14 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A16 0607  14         dec   tmp3                  ; Last character ?
0120 2A18 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A1A 045B  20         b     *r11                  ; Return
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
0138 2A1C C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A1E 832A 
0139 2A20 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A22 8000 
0140 2A24 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A26 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2A28 3E00 
0023 2A2A C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2A2C 3E02 
0024 2A2E C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A30 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A32 0200  20         li    r0,>8306              ; Scratpad source address
     2A34 8306 
0029 2A36 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A38 3E06 
0030 2A3A 0202  20         li    r2,62                 ; Loop counter
     2A3C 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A3E CC70  46         mov   *r0+,*r1+
0036 2A40 CC70  46         mov   *r0+,*r1+
0037 2A42 0642  14         dect  r2
0038 2A44 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A46 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A48 83FE 
     2A4A 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A4C C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A4E 3E00 
0045 2A50 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A52 3E02 
0046 2A54 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A56 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A58 045B  20         b     *r11                  ; Return to caller
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
0070 2A5A C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A5C 3E00 
     2A5E 8300 
0071 2A60 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A62 3E02 
     2A64 8302 
0072 2A66 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A68 3E04 
     2A6A 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A6C C800  38         mov   r0,@cpu.scrpad.tgt
     2A6E 3E00 
0077 2A70 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A72 3E02 
0078 2A74 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A76 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A78 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A7A 3E06 
0083 2A7C 0201  20         li    r1,>8306
     2A7E 8306 
0084 2A80 0202  20         li    r2,62
     2A82 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A84 CC70  46         mov   *r0+,*r1+
0090 2A86 CC70  46         mov   *r0+,*r1+
0091 2A88 0642  14         dect  r2
0092 2A8A 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A8C C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A8E 3EFE 
     2A90 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A92 C020  34         mov   @cpu.scrpad.tgt,r0
     2A94 3E00 
0099 2A96 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A98 3E02 
0100 2A9A C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2A9C 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2A9E 045B  20         b     *r11                  ; Return to caller
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
0025 2AA0 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2AA2 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2AA4 8300 
0031 2AA6 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2AA8 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2AAA 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2AAC CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2AAE 0606  14         dec   tmp2
0038 2AB0 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2AB2 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2AB4 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2AB6 2ABC 
0044                                                   ; R14=PC
0045 2AB8 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2ABA 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2ABC 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2ABE 2A5A 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2AC0 045B  20         b     *r11                  ; Return to caller
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
0078 2AC2 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2AC4 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2AC6 8300 
0084 2AC8 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2ACA 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2ACC CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2ACE 0606  14         dec   tmp2
0090 2AD0 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AD2 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AD4 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2AD6 045B  20         b     *r11                  ; Return to caller
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
0041 2AD8 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2ADA 2ADC             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2ADC C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2ADE C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2AE0 8322 
0049 2AE2 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2AE4 2026 
0050 2AE6 C020  34         mov   @>8356,r0             ; get ptr to pab
     2AE8 8356 
0051 2AEA C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2AEC 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AEE FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AF0 06C0  14         swpb  r0                    ;
0059 2AF2 D800  38         movb  r0,@vdpa              ; send low byte
     2AF4 8C02 
0060 2AF6 06C0  14         swpb  r0                    ;
0061 2AF8 D800  38         movb  r0,@vdpa              ; send high byte
     2AFA 8C02 
0062 2AFC D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2AFE 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B00 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2B02 0704  14         seto  r4                    ; init counter
0070 2B04 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2B06 A420 
0071 2B08 0580  14 !       inc   r0                    ; point to next char of name
0072 2B0A 0584  14         inc   r4                    ; incr char counter
0073 2B0C 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2B0E 0007 
0074 2B10 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2B12 80C4  18         c     r4,r3                 ; end of name?
0077 2B14 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2B16 06C0  14         swpb  r0                    ;
0082 2B18 D800  38         movb  r0,@vdpa              ; send low byte
     2B1A 8C02 
0083 2B1C 06C0  14         swpb  r0                    ;
0084 2B1E D800  38         movb  r0,@vdpa              ; send high byte
     2B20 8C02 
0085 2B22 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B24 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2B26 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2B28 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2B2A 2BEC 
0093 2B2C 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B2E C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B30 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B32 04E0  34         clr   @>83d0
     2B34 83D0 
0102 2B36 C804  38         mov   r4,@>8354             ; save name length for search
     2B38 8354 
0103 2B3A 0584  14         inc   r4                    ; adjust for dot
0104 2B3C A804  38         a     r4,@>8356             ; point to position after name
     2B3E 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B40 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B42 83E0 
0110 2B44 04C1  14         clr   r1                    ; version found of dsr
0111 2B46 020C  20         li    r12,>0f00             ; init cru addr
     2B48 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B4A C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B4C 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B4E 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B50 022C  22         ai    r12,>0100             ; next rom to turn on
     2B52 0100 
0125 2B54 04E0  34         clr   @>83d0                ; clear in case we are done
     2B56 83D0 
0126 2B58 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B5A 2000 
0127 2B5C 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B5E C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B60 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B62 1D00  20         sbo   0                     ; turn on rom
0134 2B64 0202  20         li    r2,>4000              ; start at beginning of rom
     2B66 4000 
0135 2B68 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B6A 2BE8 
0136 2B6C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B6E A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B70 A40A 
0146 2B72 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B74 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B76 83D2 
0152                                                   ; subprogram
0153               
0154 2B78 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B7A C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B7C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B7E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B80 83D2 
0163                                                   ; subprogram
0164               
0165 2B82 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B84 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B86 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B88 D160  34         movb  @>8355,r5             ; get length as counter
     2B8A 8355 
0175 2B8C 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B8E 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B90 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B92 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B94 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B96 A420 
0186 2B98 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B9A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2B9C 0605  14         dec   r5                    ; loop until full length checked
0191 2B9E 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2BA0 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2BA2 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2BA4 0581  14         inc   r1                    ; next version found
0203 2BA6 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2BA8 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2BAA 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2BAC 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BAE A400 
0212 2BB0 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2BB2 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BB4 8322 
0214                                                   ; (8 or >a)
0215 2BB6 0281  22         ci    r1,8                  ; was it 8?
     2BB8 0008 
0216 2BBA 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2BBC D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BBE 8350 
0218                                                   ; Get error byte from @>8350
0219 2BC0 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2BC2 06C0  14         swpb  r0                    ;
0227 2BC4 D800  38         movb  r0,@vdpa              ; send low byte
     2BC6 8C02 
0228 2BC8 06C0  14         swpb  r0                    ;
0229 2BCA D800  38         movb  r0,@vdpa              ; send high byte
     2BCC 8C02 
0230 2BCE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BD0 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BD2 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BD4 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BD6 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BD8 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BDA A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BDC 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2BDE 06C1  14         swpb  r1                    ; put error in hi byte
0252 2BE0 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2BE2 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2BE4 2026 
0254 2BE6 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2BE8 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2BEA 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2BEC ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 2BEE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BF0 C04B  18         mov   r11,r1                ; Save return address
0049 2BF2 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BF4 A428 
0050 2BF6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BF8 04C5  14         clr   tmp1                  ; io.op.open
0052 2BFA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BFC 22AA 
0053               file.open_init:
0054 2BFE 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C00 0009 
0055 2C02 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C04 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2C06 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C08 2AD8 
0061 2C0A 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2C0C 1029  14         jmp   file.record.pab.details
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
0090 2C0E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2C10 C04B  18         mov   r11,r1                ; Save return address
0096 2C12 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C14 A428 
0097 2C16 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2C18 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C1A 0001 
0099 2C1C 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C1E 22AA 
0100               file.close_init:
0101 2C20 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C22 0009 
0102 2C24 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C26 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2C28 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C2A 2AD8 
0108 2C2C 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C2E 1018  14         jmp   file.record.pab.details
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
0139 2C30 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C32 C04B  18         mov   r11,r1                ; Save return address
0145 2C34 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C36 A428 
0146 2C38 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C3A 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C3C 0002 
0148 2C3E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C40 22AA 
0149               file.record.read_init:
0150 2C42 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C44 0009 
0151 2C46 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C48 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C4A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C4C 2AD8 
0157 2C4E 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C50 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C52 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C54 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C56 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C58 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C5A 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C5C 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C5E 1000  14         nop
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
0211 2C60 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C62 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C64 A428 
0219 2C66 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C68 0005 
0220 2C6A 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C6C 22C2 
0221 2C6E C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C70 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 2C72 0451  20         b     *r1                   ; Return to caller
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
0020 2C74 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C76 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C78 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C7A 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C7C 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C7E 2026 
0029 2C80 1602  14         jne   tmgr1a                ; No, so move on
0030 2C82 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C84 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C86 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C88 202A 
0035 2C8A 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C8C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C8E 201A 
0048 2C90 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C92 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C94 2018 
0050 2C96 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C98 0460  28         b     @kthread              ; Run kernel thread
     2C9A 2D12 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2C9C 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2C9E 201E 
0056 2CA0 13EB  14         jeq   tmgr1
0057 2CA2 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CA4 201C 
0058 2CA6 16E8  14         jne   tmgr1
0059 2CA8 C120  34         mov   @wtiusr,tmp0
     2CAA 832E 
0060 2CAC 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CAE 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CB0 2D10 
0065 2CB2 C10A  18         mov   r10,tmp0
0066 2CB4 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CB6 00FF 
0067 2CB8 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CBA 2026 
0068 2CBC 1303  14         jeq   tmgr5
0069 2CBE 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CC0 003C 
0070 2CC2 1002  14         jmp   tmgr6
0071 2CC4 0284  22 tmgr5   ci    tmp0,50
     2CC6 0032 
0072 2CC8 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CCA 1001  14         jmp   tmgr8
0074 2CCC 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CCE C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CD0 832C 
0079 2CD2 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CD4 FF00 
0080 2CD6 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CD8 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CDA 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CDC 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CDE C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CE0 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CE2 830C 
     2CE4 830D 
0089 2CE6 1608  14         jne   tmgr10                ; No, get next slot
0090 2CE8 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CEA FF00 
0091 2CEC C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CEE C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CF0 8330 
0096 2CF2 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CF4 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CF6 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CF8 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CFA 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2CFC 8315 
     2CFE 8314 
0103 2D00 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D02 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D04 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D06 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D08 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D0A 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D0C FF00 
0109 2D0E 10B4  14         jmp   tmgr1
0110 2D10 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2D12 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D14 201A 
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
0041 2D16 06A0  32         bl    @realkb               ; Scan full keyboard
     2D18 27B8 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D1A 0460  28         b     @tmgr3                ; Exit
     2D1C 2C9C 
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
0017 2D1E C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D20 832E 
0018 2D22 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D24 201C 
0019 2D26 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C78     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D28 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D2A 832E 
0029 2D2C 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D2E FEFF 
0030 2D30 045B  20         b     *r11                  ; Return
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
0017 2D32 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D34 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D36 C184  18         mov   tmp0,tmp2
0023 2D38 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D3A A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D3C 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D3E CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D40 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D42 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D44 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D46 202C 
0035 2D48 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D4A 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D4C 05CB  14 mkslo1  inct  r11
0041 2D4E 045B  20         b     *r11                  ; Exit
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
0052 2D50 C13B  30 clslot  mov   *r11+,tmp0
0053 2D52 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D54 A120  34         a     @wtitab,tmp0          ; Add table base
     2D56 832C 
0055 2D58 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D5A 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D5C 045B  20         b     *r11                  ; Exit
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
0250 2D5E 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D60 2A26 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D62 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D64 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D66 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D68 0000 
0261 2D6A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D6C 8300 
0262 2D6E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D70 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D72 0202  20 runli2  li    r2,>8308
     2D74 8308 
0267 2D76 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D78 0282  22         ci    r2,>8400
     2D7A 8400 
0269 2D7C 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D7E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D80 FFFF 
0274 2D82 1602  14         jne   runli4                ; No, continue
0275 2D84 0420  54         blwp  @0                    ; Yes, bye bye
     2D86 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D88 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D8A 833C 
0280 2D8C 04C1  14         clr   r1                    ; Reset counter
0281 2D8E 0202  20         li    r2,10                 ; We test 10 times
     2D90 000A 
0282 2D92 C0E0  34 runli5  mov   @vdps,r3
     2D94 8802 
0283 2D96 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D98 202A 
0284 2D9A 1302  14         jeq   runli6
0285 2D9C 0581  14         inc   r1                    ; Increase counter
0286 2D9E 10F9  14         jmp   runli5
0287 2DA0 0602  14 runli6  dec   r2                    ; Next test
0288 2DA2 16F7  14         jne   runli5
0289 2DA4 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DA6 1250 
0290 2DA8 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2DAA 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DAC 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2DAE 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2DB0 21FE 
0296 2DB2 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2DB4 8322 
0297 2DB6 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2DB8 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2DBA CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2DBC 04C1  14 runli9  clr   r1
0304 2DBE 04C2  14         clr   r2
0305 2DC0 04C3  14         clr   r3
0306 2DC2 0209  20         li    stack,>8400           ; Set stack
     2DC4 8400 
0307 2DC6 020F  20         li    r15,vdpw              ; Set VDP write address
     2DC8 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2DCA 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DCC 4A4A 
0316 2DCE 1605  14         jne   runlia
0317 2DD0 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DD2 226C 
0318 2DD4 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DD6 0000 
     2DD8 3FFF 
0323 2DDA 06A0  32 runlia  bl    @filv
     2DDC 226C 
0324 2DDE 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DE0 00F4 
     2DE2 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2DE4 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DE6 26B0 
0332 2DE8 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DEA 26CA 
0333 2DEC 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DEE 26C0 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0339               *       <<skipped>>
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 2DF0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DF2 22D6 
0347 2DF4 21F4             data  spvmod                ; Equate selected video mode table
0348 2DF6 0204  20         li    tmp0,spfont           ; Get font option
     2DF8 000C 
0349 2DFA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 2DFC 1304  14         jeq   runlid                ; Yes, skip it
0351 2DFE 06A0  32         bl    @ldfnt
     2E00 233E 
0352 2E02 1100             data  fntadr,spfont         ; Load specified font
     2E04 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 2E06 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E08 4A4A 
0357 2E0A 1602  14         jne   runlie                ; No, continue
0358 2E0C 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E0E 2090 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 2E10 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E12 0040 
0363 2E14 0460  28         b     @main                 ; Give control to main program
     2E16 6050 
**** **** ****     > tivi_b1.asm.8885
0022                                                   ; Relocated spectra2 in low memory expansion
0023                                                   ; Is copied to RAM from bank 0.
0024                                                   ;
0025                                                   ; Including it here too, so that all
0026                                                   ; references get satisfied during assembly.
0027               ***************************************************************
0028               * TiVi entry point after spectra2 initialisation
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code2
0031               main:
0032 6050 04E0  34         clr   @>6002                ; Jump to bank 1
     6052 6002 
0033 6054 0460  28         b     @main.tivi            ; Start editor
     6056 6058 
0034                       ;-----------------------------------------------------------------------
0035                       ; Include files
0036                       ;-----------------------------------------------------------------------
0037                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: TiVi Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            TiVi Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * main
0011               * Initialize editor
0012               ***************************************************************
0013               * b   @main.tivi
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
0025               * Main entry point for TiVi editor
0026               ***************************************************************
0027               
0028               
0029               ***************************************************************
0030               * Main
0031               ********|*****|*********************|**************************
0032               main.tivi:
0033 6058 20A0  38         coc   @wbit1,config         ; F18a detected?
     605A 2028 
0034 605C 1302  14         jeq   main.continue
0035 605E 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6060 0000 
0036               
0037               main.continue:
0038 6062 06A0  32         bl    @scroff               ; Turn screen off
     6064 260C 
0039 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26B0 
0040 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 2310 
0041 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0042                       ;------------------------------------------------------
0043                       ; Initialize VDP SIT
0044                       ;------------------------------------------------------
0045 6070 06A0  32         bl    @filv
     6072 226C 
0046 6074 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6076 0020 
     6078 09B0 
0047 607A 06A0  32         bl    @scron                ; Turn screen on
     607C 2614 
0048                       ;------------------------------------------------------
0049                       ; Initialize high memory expansion
0050                       ;------------------------------------------------------
0051 607E 06A0  32         bl    @film
     6080 2214 
0052 6082 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6084 0000 
     6086 6000 
0053                       ;------------------------------------------------------
0054                       ; Setup SAMS windows
0055                       ;------------------------------------------------------
0056 6088 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     608A 6732 
0057                       ;------------------------------------------------------
0058                       ; Setup cursor, screen, etc.
0059                       ;------------------------------------------------------
0060 608C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608E 262C 
0061 6090 06A0  32         bl    @s8x8                 ; Small sprite
     6092 263C 
0062               
0063 6094 06A0  32         bl    @cpym2m
     6096 245E 
0064 6098 7390                   data romsat,ramsat,4  ; Load sprite SAT
     609A 8380 
     609C 0004 
0065               
0066 609E C820  54         mov   @romsat+2,@tv.curshape
     60A0 7392 
     60A2 A014 
0067                                                   ; Save cursor shape & color
0068               
0069 60A4 06A0  32         bl    @cpym2v
     60A6 2416 
0070 60A8 1800                   data sprpdt,cursors,3*8
     60AA 7394 
     60AC 0018 
0071                                                   ; Load sprite cursor patterns
0072               
0073 60AE 06A0  32         bl    @cpym2v
     60B0 2416 
0074 60B2 1008                   data >1008,patterns,11*8
     60B4 73AC 
     60B6 0058 
0075                                                   ; Load character patterns
0076               *--------------------------------------------------------------
0077               * Initialize
0078               *--------------------------------------------------------------
0079 60B8 06A0  32         bl    @tivi.init            ; Initialize TiVi editor config
     60BA 6726 
0080 60BC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60BE 6CBA 
0081 60C0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60C2 6ADC 
0082 60C4 06A0  32         bl    @idx.init             ; Initialize index
     60C6 68B4 
0083 60C8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60CA 6788 
0084                       ;-------------------------------------------------------
0085                       ; Setup editor tasks & hook
0086                       ;-------------------------------------------------------
0087 60CC 0204  20         li    tmp0,>0200
     60CE 0200 
0088 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60D2 8314 
0089               
0090 60D4 06A0  32         bl    @at
     60D6 264C 
0091 60D8 0100                   data  >0100           ; Cursor YX position = >0000
0092               
0093 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0094 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0095               
0096 60E2 06A0  32         bl    @mkslot
     60E4 2D32 
0097 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 710C 
0098 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 71F6 
0099 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 722A 
0100 60F2 FFFF                   data eol
0101               
0102 60F4 06A0  32         bl    @mkhook
     60F6 2D1E 
0103 60F8 70DC                   data hook.keyscan     ; Setup user hook
0104               
0105 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2C74 
0106               
0107               
**** **** ****     > tivi_b1.asm.8885
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
0009 60FE C160  34         mov   @waux1,tmp1           ; Get key value
     6100 833C 
0010 6102 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6104 FF00 
0011 6106 0707  14         seto  tmp3                  ; EOL marker
0012               
0013 6108 C1A0  34         mov   @tv.pane.focus,tmp2
     610A A016 
0014 610C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     610E 0000 
0015 6110 1307  14         jeq   edkey.key.process.loadmap.editor
0016                                                   ; Yes, so load editor keymap
0017               
0018 6112 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6114 0001 
0019 6116 1307  14         jeq   edkey.key.process.loadmap.cmdb
0020                                                   ; Yes, so load CMDB keymap
0021                       ;-------------------------------------------------------
0022                       ; Pane without focus, crash
0023                       ;-------------------------------------------------------
0024 6118 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     611A FFCE 
0025 611C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     611E 2030 
0026                       ;-------------------------------------------------------
0027                       ; Use editor keyboard map
0028                       ;-------------------------------------------------------
0029               edkey.key.process.loadmap.editor:
0030 6120 0206  20         li    tmp2,keymap_actions.editor
     6122 786C 
0031 6124 1003  14         jmp   edkey.key.check_next
0032                       ;-------------------------------------------------------
0033                       ; Use CMDB keyboard map
0034                       ;-------------------------------------------------------
0035               edkey.key.process.loadmap.cmdb:
0036 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 792E 
0037 612A 1600  14         jne   edkey.key.check_next
0038                       ;-------------------------------------------------------
0039                       ; Iterate over keyboard map for matching action key
0040                       ;-------------------------------------------------------
0041               edkey.key.check_next:
0042 612C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0043 612E 1309  14         jeq   edkey.key.process.addbuffer
0044                                                   ; Yes, means no action key pressed, so
0045                                                   ; add character to buffer
0046                       ;-------------------------------------------------------
0047                       ; Check for action key match
0048                       ;-------------------------------------------------------
0049 6130 8585  30         c     tmp1,*tmp2            ; Action key matched?
0050 6132 1303  14         jeq   edkey.key.process.action
0051                                                   ; Yes, do action
0052 6134 0226  22         ai    tmp2,6                ; Skip current entry
     6136 0006 
0053 6138 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0054                       ;-------------------------------------------------------
0055                       ; Trigger keyboard action
0056                       ;-------------------------------------------------------
0057               edkey.key.process.action:
0058 613A 0226  22         ai    tmp2,4                ; Move to action address
     613C 0004 
0059 613E C196  26         mov   *tmp2,tmp2            ; Get action address
0060 6140 0456  20         b     *tmp2                 ; Process key action
0061                       ;-------------------------------------------------------
0062                       ; Add character to buffer
0063                       ;-------------------------------------------------------
0064               edkey.key.process.addbuffer:
0065 6142 C120  34         mov  @tv.pane.focus,tmp0    ; Framebuffer has focus?
     6144 A016 
0066 6146 1602  14         jne  !
0067                       ;-------------------------------------------------------
0068                       ; Frame buffer
0069                       ;-------------------------------------------------------
0070 6148 0460  28         b    @edkey.action.char     ; Add character to buffer
     614A 65E6 
0071                       ;-------------------------------------------------------
0072                       ; CMDB buffer
0073                       ;-------------------------------------------------------
0074 614C 0285  22 !       ci   tmp1,pane.focus.cmdb   ; CMDB has focus ?
     614E 0001 
0075 6150 1602  14         jne  edkey.key.process.crash
0076 6152 0460  28         b    @edkey.cmdb.action.char
     6154 6716 
0077                                                   ; Add character to buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6156 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6158 FFCE 
0083 615A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     615C 2030 
**** **** ****     > tivi_b1.asm.8885
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
     6172 7100 
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
     618A 7100 
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
     6196 6B12 
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
     61B0 67FA 
0068 61B2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61B4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61B6 A106 
0074 61B8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61BA 265A 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61BC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61BE 6C9C 
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
     61D4 2664 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D8 67DE 
0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61DC 7100 
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
     61F0 6B12 
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
     621C 67FA 
0135 621E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6220 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6222 A106 
0141 6224 06A0  32         bl    @down                 ; Row++ VDP cursor
     6226 2652 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6228 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     622A 6C9C 
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
     6240 2664 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6244 67DE 
0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6248 7100 
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
     625C 67DE 
0175 625E 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6260 7100 
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
     626C 2664 
0184 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6270 67DE 
0185 6272 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6274 7100 
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
     62BE 2664 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62C2 67DE 
0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62C6 7100 
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
     631E 2664 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6320 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6322 67DE 
0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6326 7100 
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
0353 632E 8804  38         c     tmp0,@fb.scrrows   ; topline > rows on screen?
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
     634A 6B12 
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
     6358 67FA 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 635A 04E0  34         clr   @fb.row
     635C A106 
0381 635E 04E0  34         clr   @fb.column
     6360 A10C 
0382 6362 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     6364 0100 
0383 6366 C804  38         mov   tmp0,@wyx             ; In edkey.action up cursor is moved up
     6368 832A 
0384 636A 0460  28         b     @edkey.action.up      ; Do rest of logic
     636C 618C 
0385               
0386               
0387               
0388               *---------------------------------------------------------------
0389               * Next page
0390               *---------------------------------------------------------------
0391               edkey.action.npage:
0392                       ;-------------------------------------------------------
0393                       ; Sanity check
0394                       ;-------------------------------------------------------
0395 636E C120  34         mov   @fb.topline,tmp0
     6370 A104 
0396 6372 A120  34         a     @fb.scrrows,tmp0
     6374 A118 
0397 6376 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6378 A204 
0398 637A 150D  14         jgt   edkey.action.npage.exit
0399                       ;-------------------------------------------------------
0400                       ; Adjust topline
0401                       ;-------------------------------------------------------
0402               edkey.action.npage.topline:
0403 637C A820  54         a     @fb.scrrows,@fb.topline
     637E A118 
     6380 A104 
0404                       ;-------------------------------------------------------
0405                       ; Crunch current row if dirty
0406                       ;-------------------------------------------------------
0407               edkey.action.npage.crunch:
0408 6382 8820  54         c     @fb.row.dirty,@w$ffff
     6384 A10A 
     6386 202C 
0409 6388 1604  14         jne   edkey.action.npage.refresh
0410 638A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     638C 6B12 
0411 638E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6390 A10A 
0412                       ;-------------------------------------------------------
0413                       ; Refresh page
0414                       ;-------------------------------------------------------
0415               edkey.action.npage.refresh:
0416 6392 0460  28         b     @edkey.action.ppage.refresh
     6394 6350 
0417                                                   ; Same logic as previous page
0418                       ;-------------------------------------------------------
0419                       ; Exit
0420                       ;-------------------------------------------------------
0421               edkey.action.npage.exit:
0422 6396 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6398 7100 
0423               
0424               
0425               
0426               
0427               *---------------------------------------------------------------
0428               * Goto top of file
0429               *---------------------------------------------------------------
0430               edkey.action.top:
0431                       ;-------------------------------------------------------
0432                       ; Crunch current row if dirty
0433                       ;-------------------------------------------------------
0434 639A 8820  54         c     @fb.row.dirty,@w$ffff
     639C A10A 
     639E 202C 
0435 63A0 1604  14         jne   edkey.action.top.refresh
0436 63A2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63A4 6B12 
0437 63A6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63A8 A10A 
0438                       ;-------------------------------------------------------
0439                       ; Refresh page
0440                       ;-------------------------------------------------------
0441               edkey.action.top.refresh:
0442 63AA 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     63AC A104 
0443 63AE 04E0  34         clr   @parm1
     63B0 8350 
0444 63B2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63B4 67FA 
0445                       ;-------------------------------------------------------
0446                       ; Exit
0447                       ;-------------------------------------------------------
0448               edkey.action.top.exit:
0449 63B6 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B8 A106 
0450 63BA 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63BC A10C 
0451 63BE 0204  20         li    tmp0,>0100
     63C0 0100 
0452 63C2 C804  38         mov   tmp0,@wyx             ; Set VDP cursor on line 1, column 0
     63C4 832A 
0453 63C6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C8 7100 
0454               
0455               
0456               
0457               *---------------------------------------------------------------
0458               * Goto bottom of file
0459               *---------------------------------------------------------------
0460               edkey.action.bot:
0461                       ;-------------------------------------------------------
0462                       ; Crunch current row if dirty
0463                       ;-------------------------------------------------------
0464 63CA 8820  54         c     @fb.row.dirty,@w$ffff
     63CC A10A 
     63CE 202C 
0465 63D0 1604  14         jne   edkey.action.bot.refresh
0466 63D2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63D4 6B12 
0467 63D6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D8 A10A 
0468                       ;-------------------------------------------------------
0469                       ; Refresh page
0470                       ;-------------------------------------------------------
0471               edkey.action.bot.refresh:
0472 63DA 8820  54         c     @edb.lines,@fb.scrrows
     63DC A204 
     63DE A118 
0473                                                   ; Skip if whole editor buffer on screen
0474 63E0 1212  14         jle   !
0475 63E2 C120  34         mov   @edb.lines,tmp0
     63E4 A204 
0476 63E6 6120  34         s     @fb.scrrows,tmp0
     63E8 A118 
0477 63EA C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     63EC A104 
0478 63EE C804  38         mov   tmp0,@parm1
     63F0 8350 
0479 63F2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63F4 67FA 
0480                       ;-------------------------------------------------------
0481                       ; Exit
0482                       ;-------------------------------------------------------
0483               edkey.action.bot.exit:
0484 63F6 04E0  34         clr   @fb.row               ; Editor line 0
     63F8 A106 
0485 63FA 04E0  34         clr   @fb.column            ; Editor column 0
     63FC A10C 
0486 63FE 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     6400 0100 
0487 6402 C804  38         mov   tmp0,@wyx             ; Set cursor
     6404 832A 
0488 6406 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6408 7100 
**** **** ****     > tivi_b1.asm.8885
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
0009 640A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     640C A206 
0010 640E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6410 67DE 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 6412 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6414 A102 
0015 6416 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6418 A108 
0016 641A 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 641C 8820  54         c     @fb.column,@fb.row.length
     641E A10C 
     6420 A108 
0022 6422 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 6424 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6426 A102 
0028 6428 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 642A 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 642C DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 642E 0606  14         dec   tmp2
0036 6430 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 6432 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6434 A10A 
0041 6436 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6438 A116 
0042 643A 0620  34         dec   @fb.row.length        ; @fb.row.length--
     643C A108 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 643E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6440 7100 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 6442 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6444 A206 
0055 6446 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6448 67DE 
0056 644A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     644C A108 
0057 644E 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 6450 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6452 A102 
0063 6454 C1A0  34         mov   @fb.colsline,tmp2
     6456 A10E 
0064 6458 61A0  34         s     @fb.column,tmp2
     645A A10C 
0065 645C 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 645E DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 6460 0606  14         dec   tmp2
0072 6462 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 6464 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6466 A10A 
0077 6468 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     646A A116 
0078               
0079 646C C820  54         mov   @fb.column,@fb.row.length
     646E A10C 
     6470 A108 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 6472 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6474 7100 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 6476 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6478 A206 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 647A C120  34         mov   @edb.lines,tmp0
     647C A204 
0097 647E 1604  14         jne   !
0098 6480 04E0  34         clr   @fb.column            ; Column 0
     6482 A10C 
0099 6484 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     6486 6442 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 6488 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     648A 67DE 
0104 648C 04E0  34         clr   @fb.row.dirty         ; Discard current line
     648E A10A 
0105 6490 C820  54         mov   @fb.topline,@parm1
     6492 A104 
     6494 8350 
0106 6496 A820  54         a     @fb.row,@parm1        ; Line number to remove
     6498 A106 
     649A 8350 
0107 649C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     649E A204 
     64A0 8352 
0108 64A2 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     64A4 6A5E 
0109 64A6 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64A8 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64AA C820  54         mov   @fb.topline,@parm1
     64AC A104 
     64AE 8350 
0114 64B0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64B2 67FA 
0115 64B4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64B6 A116 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 64B8 C120  34         mov   @fb.topline,tmp0
     64BA A104 
0120 64BC A120  34         a     @fb.row,tmp0
     64BE A106 
0121 64C0 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64C2 A204 
0122 64C4 1202  14         jle   edkey.action.del_line.exit
0123 64C6 0460  28         b     @edkey.action.up      ; One line up
     64C8 618C 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64CA 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64CC 624A 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws:
0138 64CE 0204  20         li    tmp0,>2000            ; White space
     64D0 2000 
0139 64D2 C804  38         mov   tmp0,@parm1
     64D4 8350 
0140               edkey.action.ins_char:
0141 64D6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64D8 A206 
0142 64DA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64DC 67DE 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64DE C120  34         mov   @fb.current,tmp0      ; Get pointer
     64E0 A102 
0147 64E2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64E4 A108 
0148 64E6 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 64E8 8820  54         c     @fb.column,@fb.row.length
     64EA A10C 
     64EC A108 
0154 64EE 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 64F0 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 64F2 61E0  34         s     @fb.column,tmp3
     64F4 A10C 
0162 64F6 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 64F8 C144  18         mov   tmp0,tmp1
0164 64FA 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 64FC 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64FE A10C 
0166 6500 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 6502 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 6504 0604  14         dec   tmp0
0173 6506 0605  14         dec   tmp1
0174 6508 0606  14         dec   tmp2
0175 650A 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 650C D560  46         movb  @parm1,*tmp1
     650E 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 6510 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6512 A10A 
0184 6514 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6516 A116 
0185 6518 05A0  34         inc   @fb.row.length        ; @fb.row.length
     651A A108 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 651C 0460  28         b     @edkey.action.char.overwrite
     651E 65F8 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 6520 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6522 7100 
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
0206 6524 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6526 A206 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 6528 8820  54         c     @fb.row.dirty,@w$ffff
     652A A10A 
     652C 202C 
0211 652E 1604  14         jne   edkey.action.ins_line.insert
0212 6530 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6532 6B12 
0213 6534 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6536 A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6538 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     653A 67DE 
0219 653C C820  54         mov   @fb.topline,@parm1
     653E A104 
     6540 8350 
0220 6542 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6544 A106 
     6546 8350 
0221               
0222 6548 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     654A A204 
     654C 8352 
0223 654E 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6550 6AAC 
0224 6552 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     6554 A204 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 6556 C820  54         mov   @fb.topline,@parm1
     6558 A104 
     655A 8350 
0229 655C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     655E 67FA 
0230 6560 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6562 A116 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 6564 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6566 7100 
0236               
0237               
0238               
0239               
0240               
0241               
0242               *---------------------------------------------------------------
0243               * Enter
0244               *---------------------------------------------------------------
0245               edkey.action.enter:
0246                       ;-------------------------------------------------------
0247                       ; Crunch current line if dirty
0248                       ;-------------------------------------------------------
0249 6568 8820  54         c     @fb.row.dirty,@w$ffff
     656A A10A 
     656C 202C 
0250 656E 1606  14         jne   edkey.action.enter.upd_counter
0251 6570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6572 A206 
0252 6574 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6576 6B12 
0253 6578 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     657A A10A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 657C C120  34         mov   @fb.topline,tmp0
     657E A104 
0259 6580 A120  34         a     @fb.row,tmp0
     6582 A106 
0260 6584 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6586 A204 
0261 6588 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 658A 05A0  34         inc   @edb.lines            ; Total lines++
     658C A204 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 658E C120  34         mov   @fb.scrrows,tmp0
     6590 A118 
0271 6592 0604  14         dec   tmp0
0272 6594 8120  34         c     @fb.row,tmp0
     6596 A106 
0273 6598 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 659A C120  34         mov   @fb.scrrows,tmp0
     659C A118 
0278 659E C820  54         mov   @fb.topline,@parm1
     65A0 A104 
     65A2 8350 
0279 65A4 05A0  34         inc   @parm1
     65A6 8350 
0280 65A8 06A0  32         bl    @fb.refresh
     65AA 67FA 
0281 65AC 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 65AE 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65B0 A106 
0287 65B2 06A0  32         bl    @down                 ; Row++ VDP cursor
     65B4 2652 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 65B6 06A0  32         bl    @fb.get.firstnonblank
     65B8 686C 
0293 65BA C120  34         mov   @outparm1,tmp0
     65BC 8360 
0294 65BE C804  38         mov   tmp0,@fb.column
     65C0 A10C 
0295 65C2 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65C4 2664 
0296 65C6 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65C8 6C9C 
0297 65CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65CC 67DE 
0298 65CE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65D0 A116 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65D4 7100 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 65D6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65D8 A20A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 65DA 0204  20         li    tmp0,2000
     65DC 07D0 
0317               edkey.action.ins_onoff.loop:
0318 65DE 0604  14         dec   tmp0
0319 65E0 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 65E2 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65E4 722A 
0325               
0326               
0327               
0328               
0329               *---------------------------------------------------------------
0330               * Process character
0331               *---------------------------------------------------------------
0332               edkey.action.char:
0333 65E6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65E8 A206 
0334 65EA D805  38         movb  tmp1,@parm1           ; Store character for insert
     65EC 8350 
0335 65EE C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     65F0 A20A 
0336 65F2 1302  14         jeq   edkey.action.char.overwrite
0337                       ;-------------------------------------------------------
0338                       ; Insert mode
0339                       ;-------------------------------------------------------
0340               edkey.action.char.insert:
0341 65F4 0460  28         b     @edkey.action.ins_char
     65F6 64D6 
0342                       ;-------------------------------------------------------
0343                       ; Overwrite mode
0344                       ;-------------------------------------------------------
0345               edkey.action.char.overwrite:
0346 65F8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65FA 67DE 
0347 65FC C120  34         mov   @fb.current,tmp0      ; Get pointer
     65FE A102 
0348               
0349 6600 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6602 8350 
0350 6604 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6606 A10A 
0351 6608 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     660A A116 
0352               
0353 660C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     660E A10C 
0354 6610 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6612 832A 
0355                       ;-------------------------------------------------------
0356                       ; Update line length in frame buffer
0357                       ;-------------------------------------------------------
0358 6614 8820  54         c     @fb.column,@fb.row.length
     6616 A10C 
     6618 A108 
0359 661A 1103  14         jlt   edkey.action.char.exit
0360                                                   ; column < length line ? Skip processing
0361               
0362 661C C820  54         mov   @fb.column,@fb.row.length
     661E A10C 
     6620 A108 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 6622 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6624 7100 
**** **** ****     > tivi_b1.asm.8885
0041                       copy  "edkey.fb.misc.asm"   ; fb pane   - Actions for miscelanneous keys
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit TiVi
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 6626 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6628 2714 
0010 662A 0420  54         blwp  @0                    ; Exit
     662C 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 662E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6630 7100 
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Show/Hide command buffer pane
0022               ********|*****|*********************|**************************
0023               edkey.action.cmdb.toggle:
0024 6632 C120  34         mov   @cmdb.visible,tmp0
     6634 A302 
0025 6636 1603  14         jne   edkey.action.cmdb.hide
0026                       ;-------------------------------------------------------
0027                       ; Show pane
0028                       ;-------------------------------------------------------
0029               edkey.action.cmdb.show:
0030 6638 06A0  32         bl    @cmdb.show            ; Show command buffer pane
     663A 6CF4 
0031 663C 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 663E 06A0  32         bl    @cmdb.hide            ; Hide command buffer pane
     6640 6D2E 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 6642 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6644 7100 
0042               
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Framebuffer down 1 row
0047               *---------------------------------------------------------------
0048               edkey.action.fbdown:
0049 6646 05A0  34         inc   @fb.scrrows
     6648 A118 
0050 664A 0720  34         seto  @fb.dirty
     664C A116 
0051               
0052 664E 045B  20         b     *r11
0053               
0054               
0055               *---------------------------------------------------------------
0056               * Cycle colors
0057               ********|*****|*********************|**************************
0058               edkey.action.color.cycle:
0059 6650 0649  14         dect  stack
0060 6652 C64B  30         mov   r11,*stack            ; Push return address
0061               
0062 6654 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     6656 A012 
0063 6658 0284  22         ci    tmp0,3                ; 4th entry reached?
     665A 0003 
0064 665C 1102  14         jlt   !
0065 665E 04C4  14         clr   tmp0
0066 6660 1001  14         jmp   edkey.action.color.switch
0067 6662 0584  14 !       inc   tmp0
0068               *---------------------------------------------------------------
0069               * Do actual color switch
0070               ********|*****|*********************|**************************
0071               edkey.action.color.switch:
0072 6664 C804  38         mov   tmp0,@tv.colorscheme  ; Save color scheme index
     6666 A012 
0073 6668 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
0074 666A 0224  22         ai    tmp0,tv.data.colorscheme
     666C 7404 
0075                                                   ; Add base for color scheme data table
0076 666E D154  26         movb  *tmp0,tmp1            ; Get foreground / background color
0077                       ;-------------------------------------------------------
0078                       ; Dump cursor FG color to sprite table (SAT)
0079                       ;-------------------------------------------------------
0080 6670 C185  18         mov   tmp1,tmp2             ; Get work copy
0081 6672 0946  56         srl   tmp2,4                ; Move nibble to right
0082 6674 0246  22         andi  tmp2,>0f00
     6676 0F00 
0083 6678 D806  38         movb  tmp2,@ramsat+3        ; Update FG color in sprite table (SAT)
     667A 8383 
0084 667C D806  38         movb  tmp2,@tv.curshape+1   ; Save cursor color
     667E A015 
0085                       ;-------------------------------------------------------
0086                       ; Dump color combination to VDP color table
0087                       ;-------------------------------------------------------
0088 6680 0985  56         srl   tmp1,8                ; MSB to LSB
0089 6682 0265  22         ori   tmp1,>0700
     6684 0700 
0090 6686 C105  18         mov   tmp1,tmp0
0091 6688 06A0  32         bl    @putvrx
     668A 2312 
0092 668C C2F9  30         mov   *stack+,r11           ; Pop R11
0093 668E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6690 7100 
**** **** ****     > tivi_b1.asm.8885
0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6692 0204  20         li   tmp0,fdname0
     6694 756E 
0007 6696 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 6698 0204  20         li   tmp0,fdname1
     669A 74F2 
0010 669C 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 669E 0204  20         li   tmp0,fdname2
     66A0 7502 
0013 66A2 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 66A4 0204  20         li   tmp0,fdname3
     66A6 750C 
0016 66A8 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 66AA 0204  20         li   tmp0,fdname4
     66AC 751A 
0019 66AE 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 66B0 0204  20         li   tmp0,fdname5
     66B2 7528 
0022 66B4 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 66B6 0204  20         li   tmp0,fdname6
     66B8 7536 
0025 66BA 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 66BC 0204  20         li   tmp0,fdname7
     66BE 7544 
0028 66C0 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 66C2 0204  20         li   tmp0,fdname8
     66C4 7552 
0031 66C6 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 66C8 0204  20         li   tmp0,fdname9
     66CA 7560 
0034 66CC 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66CE 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66D0 6F88 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66D2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66D4 639A 
**** **** ****     > tivi_b1.asm.8885
0043                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Insert character
0007               *
0008               * @parm1 = high byte has character to insert
0009               *---------------------------------------------------------------
0010               edkey.cmdb.action.ins_char.ws:
0011 66D6 0204  20         li    tmp0,>2000            ; White space
     66D8 2000 
0012 66DA C804  38         mov   tmp0,@parm1
     66DC 8350 
0013               edkey.cmdb.action.ins_char:
0014 66DE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66E0 A310 
0015 66E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66E4 67DE 
0016                       ;-------------------------------------------------------
0017                       ; Prepare for insert operation
0018                       ;-------------------------------------------------------
0019               edkey.cmdb.action.skipsanity:
0020 66E6 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0021 66E8 61E0  34         s     @fb.column,tmp3
     66EA A10C 
0022 66EC A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0023 66EE C144  18         mov   tmp0,tmp1
0024 66F0 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0025 66F2 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     66F4 A10C 
0026 66F6 0586  14         inc   tmp2
0027                       ;-------------------------------------------------------
0028                       ; Loop from end of line until current character
0029                       ;-------------------------------------------------------
0030               edkey.cmdb.action.ins_char_loop:
0031 66F8 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0032 66FA 0604  14         dec   tmp0
0033 66FC 0605  14         dec   tmp1
0034 66FE 0606  14         dec   tmp2
0035 6700 16FB  14         jne   edkey.cmdb.action.ins_char_loop
0036                       ;-------------------------------------------------------
0037                       ; Set specified character on current position
0038                       ;-------------------------------------------------------
0039 6702 D560  46         movb  @parm1,*tmp1
     6704 8350 
0040                       ;-------------------------------------------------------
0041                       ; Save variables
0042                       ;-------------------------------------------------------
0043 6706 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6708 A10A 
0044 670A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     670C A116 
0045 670E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     6710 A108 
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               edkey.cmdb.action.ins_char.exit:
0050 6712 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6714 7100 
0051               
0052               
0053               
0054               *---------------------------------------------------------------
0055               * Process character
0056               *---------------------------------------------------------------
0057               edkey.cmdb.action.char:
0058 6716 0720  34         seto  @cmdb.dirty           ; Editor buffer dirty (text changed!)
     6718 A310 
0059 671A D805  38         movb  tmp1,@parm1           ; Store character for insert
     671C 8350 
0060                       ;-------------------------------------------------------
0061                       ; Only insert mode supported
0062                       ;-------------------------------------------------------
0063               edkey.cmdb.action.char.insert:
0064 671E 0460  28         b     @edkey.action.ins_char
     6720 64D6 
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               edkey.cmdb.action.char.exit:
0069 6722 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6724 7100 
**** **** ****     > tivi_b1.asm.8885
0044                       copy  "tivi.asm"            ; Main editor configuration
**** **** ****     > tivi.asm
0001               * FILE......: tivi.asm
0002               * Purpose...: TiVi Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize main editor
0012               ***************************************************************
0013               * bl @tivi.init
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
0026               tivi.init:
0027 6726 0649  14         dect  stack
0028 6728 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 672A 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     672C A012 
0033               
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               tivi.init.exit:
0038 672E 0460  28         b     @poprt                ; Return to caller
     6730 2210 
**** **** ****     > tivi_b1.asm.8885
0045                       copy  "mem.asm"             ; Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: TiVi Editor - Memory management (SAMS)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Memory Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.sams.layout
0010               * Setup SAMS memory pages for TiVi
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
0021 6732 0649  14         dect  stack
0022 6734 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 6736 06A0  32         bl    @sams.layout
     6738 2560 
0027 673A 740C                   data mem.sams.layout.data
0028               
0029 673C 06A0  32         bl    @sams.layout.copy
     673E 25C4 
0030 6740 A000                   data tv.sams.2000     ; Get SAMS windows
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 6742 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 6744 045B  20         b     *r11                  ; Return to caller
0037               
0038               
0039               
0040               ***************************************************************
0041               * mem.edb.sams.mappage
0042               * Activate editor buffer SAMS page for line
0043               ***************************************************************
0044               * bl  @mem.edb.sams.mappage
0045               *     data p0
0046               *--------------------------------------------------------------
0047               * p0 = Line number in editor buffer
0048               *--------------------------------------------------------------
0049               * bl  @xmem.edb.sams.mappage
0050               *
0051               * tmp0 = Line number in editor buffer
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * outparm1 = Pointer to line in editor buffer
0055               * outparm2 = SAMS page
0056               *--------------------------------------------------------------
0057               * Register usage
0058               * tmp0, tmp1
0059               ***************************************************************
0060               mem.edb.sams.mappage:
0061 6746 C13B  30         mov   *r11+,tmp0            ; Get p0
0062               xmem.edb.sams.mappage:
0063 6748 0649  14         dect  stack
0064 674A C64B  30         mov   r11,*stack            ; Push return address
0065 674C 0649  14         dect  stack
0066 674E C644  30         mov   tmp0,*stack           ; Push tmp0
0067 6750 0649  14         dect  stack
0068 6752 C645  30         mov   tmp1,*stack           ; Push tmp1
0069                       ;------------------------------------------------------
0070                       ; Sanity check
0071                       ;------------------------------------------------------
0072 6754 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6756 A204 
0073 6758 1104  14         jlt   mem.edb.sams.mappage.lookup
0074                                                   ; All checks passed, continue
0075                                                   ;--------------------------
0076                                                   ; Sanity check failed
0077                                                   ;--------------------------
0078 675A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     675C FFCE 
0079 675E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6760 2030 
0080                       ;------------------------------------------------------
0081                       ; Lookup SAMS page for line in parm1
0082                       ;------------------------------------------------------
0083               mem.edb.sams.mappage.lookup:
0084 6762 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6764 6A04 
0085                                                   ; \ i  parm1    = Line number
0086                                                   ; | o  outparm1 = Pointer to line
0087                                                   ; / o  outparm2 = SAMS page
0088               
0089 6766 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6768 8362 
0090 676A C160  34         mov   @outparm1,tmp1        ; Pointer to line
     676C 8360 
0091 676E 1308  14         jeq   mem.edb.sams.mappage.exit
0092                                                   ; Nothing to page-in if NULL pointer
0093                                                   ; (=empty line)
0094                       ;------------------------------------------------------
0095                       ; Determine if requested SAMS page is already active
0096                       ;------------------------------------------------------
0097 6770 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6772 A008 
0098 6774 1305  14         jeq   mem.edb.sams.mappage.exit
0099                                                   ; Request page already active. Exit.
0100                       ;------------------------------------------------------
0101                       ; Activate requested SAMS page
0102                       ;-----------------------------------------------------
0103 6776 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6778 24FA 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106               
0107 677A C820  54         mov   @outparm2,@tv.sams.c000
     677C 8362 
     677E A008 
0108                                                   ; Set page in shadow registers
0109                       ;------------------------------------------------------
0110                       ; Exit
0111                       ;------------------------------------------------------
0112               mem.edb.sams.mappage.exit:
0113 6780 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0114 6782 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0115 6784 C2F9  30         mov   *stack+,r11           ; Pop r11
0116 6786 045B  20         b     *r11                  ; Return to caller
0117               
0118               
0119               
**** **** ****     > tivi_b1.asm.8885
0046                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: TiVi Editor - Framebuffer module
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
0038 67A8 0204  20         li    tmp0,27
     67AA 001B 
0039 67AC C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
     67AE A118 
0040 67B0 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     67B2 A11A 
0041               
0042 67B4 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     67B6 A016 
0043 67B8 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     67BA A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 67BC 06A0  32         bl    @film
     67BE 2214 
0048 67C0 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     67C2 0000 
     67C4 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 67C6 0460  28         b     @poprt                ; Return to caller
     67C8 2210 
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
     67DC 2210 
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
     67F8 2210 
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
     681E 6BBA 
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
0185 682E 1113  14         jlt   !                     ; no, do next check
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
0197 6840 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6842 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6844 A10E 
0200 6846 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6848 A100 
0201               
0202 684A C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 684C 0205  20         li    tmp1,32               ; Clear with space
     684E 0020 
0204               
0205 6850 06A0  32         bl    @xfilm                ; \ Fill memory
     6852 221A 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 6854 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 6856 8820  54 !       c     @parm2,@fb.scrrows
     6858 8352 
     685A A118 
0214 685C 11DF  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 685E 0720  34         seto  @fb.dirty             ; Refresh screen
     6860 A116 
0221 6862 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 6864 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 6866 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 6868 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 686A 045B  20         b     *r11                  ; Return to caller
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
0239 686C 0649  14         dect  stack
0240 686E C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 6870 04E0  34         clr   @fb.column
     6872 A10C 
0245 6874 06A0  32         bl    @fb.calc_pointer
     6876 67DE 
0246 6878 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     687A 6C9C 
0247 687C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     687E A108 
0248 6880 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 6882 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6884 A102 
0251 6886 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 6888 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 688A 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 688C 0285  22         ci    tmp1,>2000            ; Whitespace?
     688E 2000 
0260 6890 1503  14         jgt   fb.get.firstnonblank.match
0261 6892 0606  14         dec   tmp2                  ; Counter--
0262 6894 16F9  14         jne   fb.get.firstnonblank.loop
0263 6896 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 6898 6120  34         s     @fb.current,tmp0      ; Calculate column
     689A A102 
0269 689C 0604  14         dec   tmp0
0270 689E C804  38         mov   tmp0,@outparm1        ; Save column
     68A0 8360 
0271 68A2 D805  38         movb  tmp1,@outparm2        ; Save character
     68A4 8362 
0272 68A6 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68A8 04E0  34         clr   @outparm1             ; X=0
     68AA 8360 
0278 68AC 04E0  34         clr   @outparm2             ; Null
     68AE 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 68B0 0460  28         b    @poprt                 ; Return to caller
     68B2 2210 
**** **** ****     > tivi_b1.asm.8885
0047                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: TiVi Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
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
0048               ***************************************************************
0049               idx.init:
0050 68B4 0649  14         dect  stack
0051 68B6 C64B  30         mov   r11,*stack            ; Save return address
0052 68B8 0649  14         dect  stack
0053 68BA C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 68BC 0204  20         li    tmp0,idx.top
     68BE B000 
0058 68C0 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     68C2 A202 
0059               
0060 68C4 C120  34         mov   @tv.sams.b000,tmp0
     68C6 A006 
0061 68C8 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     68CA A500 
0062 68CC C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     68CE A502 
0063 68D0 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     68D2 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 68D4 06A0  32         bl    @film
     68D6 2214 
0068 68D8 B000                   data idx.top,>00,idx.size
     68DA 0000 
     68DC 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 68DE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 68E0 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 68E2 045B  20         b     *r11                  ; Return to caller
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
0098               *--------------------------------------------------------------
0099               _idx.sams.mapcolumn.on:
0100 68E4 0649  14         dect  stack
0101 68E6 C64B  30         mov   r11,*stack            ; Push return address
0102 68E8 0649  14         dect  stack
0103 68EA C644  30         mov   tmp0,*stack           ; Push tmp0
0104 68EC 0649  14         dect  stack
0105 68EE C645  30         mov   tmp1,*stack           ; Push tmp1
0106 68F0 0649  14         dect  stack
0107 68F2 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 68F4 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     68F6 A502 
0112 68F8 0205  20         li    tmp1,idx.top
     68FA B000 
0113               
0114 68FC C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     68FE A504 
0115 6900 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6902 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6904 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6906 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6908 0005 
0121 690A 1104  14         jlt   !
0122 690C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     690E FFCE 
0123 6910 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6912 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6914 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6916 24FA 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6918 0584  14         inc   tmp0                  ; Next SAMS index page
0132 691A 0225  22         ai    tmp1,>1000            ; Next memory region
     691C 1000 
0133 691E 0606  14         dec   tmp2                  ; Update loop counter
0134 6920 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6922 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6924 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6926 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6928 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 692A 045B  20         b     *r11                  ; Return to caller
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
0157               *--------------------------------------------------------------
0158               _idx.sams.mapcolumn.off:
0159 692C 0649  14         dect  stack
0160 692E C64B  30         mov   r11,*stack            ; Push return address
0161 6930 0649  14         dect  stack
0162 6932 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6934 0649  14         dect  stack
0164 6936 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6938 0649  14         dect  stack
0166 693A C646  30         mov   tmp2,*stack           ; Push tmp2
0167 693C 0649  14         dect  stack
0168 693E C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 6940 0205  20         li    tmp1,idx.top
     6942 B000 
0173 6944 0206  20         li    tmp2,5                ; Always 5 pages
     6946 0005 
0174 6948 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     694A A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 694C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 694E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6950 24FA 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 6952 0225  22         ai    tmp1,>1000            ; Next memory region
     6954 1000 
0185 6956 0606  14         dec   tmp2                  ; Update loop counter
0186 6958 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 695A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 695C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 695E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6960 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6962 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6964 045B  20         b     *r11                  ; Return to caller
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
0218               *--------------------------------------------------------------
0219               idx._samspage.get:
0220 6966 0649  14         dect  stack
0221 6968 C64B  30         mov   r11,*stack            ; Save return address
0222 696A 0649  14         dect  stack
0223 696C C644  30         mov   tmp0,*stack           ; Push tmp0
0224 696E 0649  14         dect  stack
0225 6970 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6972 0649  14         dect  stack
0227 6974 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6976 C184  18         mov   tmp0,tmp2             ; Line number
0232 6978 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 697A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     697C 0800 
0234               
0235 697E 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 6980 0A16  56         sla   tmp2,1                ; line number * 2
0240 6982 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6984 8360 
0241               
0242 6986 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6988 A502 
0243 698A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     698C A500 
0244               
0245 698E 130E  14         jeq   idx._samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 6990 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6992 A500 
0251 6994 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in TiVi
     6996 A006 
0252               
0253 6998 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 699A 0205  20         li    tmp1,>b000            ; Memory window for index page
     699C B000 
0255               
0256 699E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     69A0 24FA 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 69A2 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     69A4 A504 
0263 69A6 1202  14         jle   idx._samspage.get.exit
0264                                                   ; No, exit
0265 69A8 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     69AA A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               idx._samspage.get.exit:
0270 69AC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 69AE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 69B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 69B2 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 69B4 045B  20         b     *r11                  ; Return to caller
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
0293               *--------------------------------------------------------------
0294               idx.entry.update:
0295 69B6 0649  14         dect  stack
0296 69B8 C64B  30         mov   r11,*stack            ; Save return address
0297 69BA 0649  14         dect  stack
0298 69BC C644  30         mov   tmp0,*stack           ; Push tmp0
0299 69BE 0649  14         dect  stack
0300 69C0 C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 69C2 C120  34         mov   @parm1,tmp0           ; Get line number
     69C4 8350 
0305 69C6 C160  34         mov   @parm2,tmp1           ; Get pointer
     69C8 8352 
0306 69CA 1310  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 69CC 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     69CE 0FFF 
0312 69D0 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 69D2 06E0  34         swpb  @parm3
     69D4 8354 
0317 69D6 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     69D8 8354 
0318                       ;------------------------------------------------------
0319                       ; Update index slot
0320                       ;------------------------------------------------------
0321               idx.entry.update.save:
0322 69DA 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     69DC 6966 
0323                                                   ; \ i  tmp0     = Line number
0324                                                   ; / o  outparm1 = Slot offset in SAMS page
0325               
0326 69DE C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     69E0 8360 
0327 69E2 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     69E4 B000 
0328 69E6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69E8 8360 
0329 69EA 1008  14         jmp   idx.entry.update.exit
0330                       ;------------------------------------------------------
0331                       ; Special handling for "null"-pointer
0332                       ;------------------------------------------------------
0333               idx.entry.update.clear:
0334 69EC 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     69EE 6966 
0335                                                   ; \ i  tmp0     = Line number
0336                                                   ; / o  outparm1 = Slot offset in SAMS page
0337               
0338 69F0 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     69F2 8360 
0339 69F4 04E4  34         clr   @idx.top(tmp0)        ; /
     69F6 B000 
0340 69F8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69FA 8360 
0341                       ;------------------------------------------------------
0342                       ; Exit
0343                       ;------------------------------------------------------
0344               idx.entry.update.exit:
0345 69FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0346 69FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0347 6A00 C2F9  30         mov   *stack+,r11           ; Pop r11
0348 6A02 045B  20         b     *r11                  ; Return to caller
0349               
0350               
0351               
0352               
0353               
0354               ***************************************************************
0355               * idx.pointer.get
0356               * Get pointer to editor buffer line content
0357               ***************************************************************
0358               * bl @idx.pointer.get
0359               *--------------------------------------------------------------
0360               * INPUT
0361               * @parm1 = Line number in editor buffer
0362               *--------------------------------------------------------------
0363               * OUTPUT
0364               * @outparm1 = Pointer to editor buffer line content
0365               * @outparm2 = SAMS page
0366               *--------------------------------------------------------------
0367               * Register usage
0368               * tmp0,tmp1,tmp2
0369               *--------------------------------------------------------------
0370               idx.pointer.get:
0371 6A04 0649  14         dect  stack
0372 6A06 C64B  30         mov   r11,*stack            ; Save return address
0373 6A08 0649  14         dect  stack
0374 6A0A C644  30         mov   tmp0,*stack           ; Push tmp0
0375 6A0C 0649  14         dect  stack
0376 6A0E C645  30         mov   tmp1,*stack           ; Push tmp1
0377 6A10 0649  14         dect  stack
0378 6A12 C646  30         mov   tmp2,*stack           ; Push tmp2
0379                       ;------------------------------------------------------
0380                       ; Get slot entry
0381                       ;------------------------------------------------------
0382 6A14 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A16 8350 
0383               
0384 6A18 06A0  32         bl    @idx._samspage.get    ; Get SAMS page with index slot
     6A1A 6966 
0385                                                   ; \ i  tmp0     = Line number
0386                                                   ; / o  outparm1 = Slot offset in SAMS page
0387               
0388 6A1C C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6A1E 8360 
0389 6A20 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A22 B000 
0390               
0391 6A24 130C  14         jeq   idx.pointer.get.parm.null
0392                                                   ; Skip if index slot empty
0393                       ;------------------------------------------------------
0394                       ; Calculate MSB (SAMS page)
0395                       ;------------------------------------------------------
0396 6A26 C185  18         mov   tmp1,tmp2             ; \
0397 6A28 0986  56         srl   tmp2,8                ; / Right align SAMS page
0398                       ;------------------------------------------------------
0399                       ; Calculate LSB (pointer address)
0400                       ;------------------------------------------------------
0401 6A2A 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A2C 00FF 
0402 6A2E 0A45  56         sla   tmp1,4                ; Multiply with 16
0403 6A30 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A32 C000 
0404                       ;------------------------------------------------------
0405                       ; Return parameters
0406                       ;------------------------------------------------------
0407               idx.pointer.get.parm:
0408 6A34 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A36 8360 
0409 6A38 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A3A 8362 
0410 6A3C 1004  14         jmp   idx.pointer.get.exit
0411                       ;------------------------------------------------------
0412                       ; Special handling for "null"-pointer
0413                       ;------------------------------------------------------
0414               idx.pointer.get.parm.null:
0415 6A3E 04E0  34         clr   @outparm1
     6A40 8360 
0416 6A42 04E0  34         clr   @outparm2
     6A44 8362 
0417                       ;------------------------------------------------------
0418                       ; Exit
0419                       ;------------------------------------------------------
0420               idx.pointer.get.exit:
0421 6A46 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0422 6A48 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0423 6A4A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0424 6A4C C2F9  30         mov   *stack+,r11           ; Pop r11
0425 6A4E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi_b1.asm.8885
0048                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: TiVi Editor - Delete index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * _idx.entry.delete.reorg
0014               * Reorganize index slot entries (single SAMS page)
0015               ***************************************************************
0016               * bl @_idx.entry.delete.reorg
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  Private, only to be called from idx_entry_delete
0020               *--------------------------------------------------------------
0021               _idx.entry.delete.reorg:
0022                       ;------------------------------------------------------
0023                       ; Reorganize index entries
0024                       ;------------------------------------------------------
0025 6A50 C924  54 !       mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     6A52 B002 
     6A54 B000 
0026 6A56 05C4  14         inct  tmp0                  ; Next index entry
0027 6A58 0606  14         dec   tmp2                  ; tmp2--
0028 6A5A 16FA  14         jne   -!                    ; Loop unless completed
0029 6A5C 045B  20         b     *r11                  ; Return to caller
0030               
0031               
0032               
0033               
0034               ***************************************************************
0035               * idx.entry.delete
0036               * Delete index entry - Close gap created by delete
0037               ***************************************************************
0038               * bl @idx.entry.delete
0039               *--------------------------------------------------------------
0040               * INPUT
0041               * @parm1    = Line number in editor buffer to delete
0042               * @parm2    = Line number of last line to check for reorg
0043               *--------------------------------------------------------------
0044               * Register usage
0045               * tmp0,tmp2
0046               *--------------------------------------------------------------
0047               idx.entry.delete:
0048 6A5E 0649  14         dect  stack
0049 6A60 C64B  30         mov   r11,*stack            ; Save return address
0050 6A62 0649  14         dect  stack
0051 6A64 C644  30         mov   tmp0,*stack           ; Push tmp0
0052 6A66 0649  14         dect  stack
0053 6A68 C645  30         mov   tmp1,*stack           ; Push tmp1
0054 6A6A 0649  14         dect  stack
0055 6A6C C646  30         mov   tmp2,*stack           ; Push tmp2
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6A6E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A70 8350 
0060               
0061 6A72 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     6A74 6966 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6A76 C120  34         mov   @outparm1,tmp0        ; Index offset
     6A78 8360 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6A7A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6A7C 8352 
0070 6A7E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6A80 8350 
0071 6A82 130D  14         jeq   idx.entry.delete.lastline
0072                                                   ; Special treatment if last line
0073                       ;------------------------------------------------------
0074                       ; Reorganize index entries
0075                       ;------------------------------------------------------
0076               idx.entry.delete.reorg:
0077 6A84 8820  54         c     @idx.sams.page,@idx.sams.hipage
     6A86 A500 
     6A88 A504 
0078 6A8A 1307  14         jeq   idx.entry.delete.reorg.simple
0079                                                   ; If only one SAMS index page or at last
0080                                                   ; SAMS index page then do simple reorg
0081                       ;------------------------------------------------------
0082                       ; Complex index reorganization (multiple SAMS pages)
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg.complex:
0085 6A8C 06A0  32         bl    @_idx.sams.mapcolumn.on
     6A8E 68E4 
0086                                                   ; Index in continious memory region
0087               
0088 6A90 06A0  32         bl    @_idx.entry.delete.reorg
     6A92 6A50 
0089                                                   ; Reorganize index
0090               
0091               
0092 6A94 06A0  32         bl    @_idx.sams.mapcolumn.off
     6A96 692C 
0093                                                   ; Restore memory window layout
0094               
0095 6A98 1002  14         jmp   idx.entry.delete.lastline
0096                       ;------------------------------------------------------
0097                       ; Simple index reorganization
0098                       ;------------------------------------------------------
0099               idx.entry.delete.reorg.simple:
0100 6A9A 06A0  32         bl    @_idx.entry.delete.reorg
     6A9C 6A50 
0101                       ;------------------------------------------------------
0102                       ; Last line
0103                       ;------------------------------------------------------
0104               idx.entry.delete.lastline:
0105 6A9E 04E4  34         clr   @idx.top(tmp0)
     6AA0 B000 
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               idx.entry.delete.exit:
0110 6AA2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0111 6AA4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0112 6AA6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0113 6AA8 C2F9  30         mov   *stack+,r11           ; Pop r11
0114 6AAA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi_b1.asm.8885
0049                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: TiVi Editor - Insert index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  TiVi Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * idx.entry.insert
0011               * Insert index entry
0012               ***************************************************************
0013               * bl @idx.entry.insert
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1    = Line number in editor buffer to insert
0017               * @parm2    = Line number of last line to check for reorg
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * NONE
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0,tmp2
0024               *--------------------------------------------------------------
0025               idx.entry.insert:
0026 6AAC C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6AAE 8352 
0027                       ;------------------------------------------------------
0028                       ; Calculate address of index entry and save pointer
0029                       ;------------------------------------------------------
0030 6AB0 0A14  56         sla   tmp0,1                ; line number * 2
0031                       ;------------------------------------------------------
0032                       ; Prepare for index reorg
0033                       ;------------------------------------------------------
0034 6AB2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6AB4 8352 
0035 6AB6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6AB8 8350 
0036 6ABA 1606  14         jne   idx.entry.insert.reorg
0037                       ;------------------------------------------------------
0038                       ; Special treatment if last line
0039                       ;------------------------------------------------------
0040 6ABC C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6ABE B000 
     6AC0 B002 
0041                                                   ; Move index entry
0042 6AC2 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     6AC4 B000 
0043               
0044 6AC6 1009  14         jmp   idx.entry.insert.exit
0045                       ;------------------------------------------------------
0046                       ; Reorganize index entries
0047                       ;------------------------------------------------------
0048               idx.entry.insert.reorg:
0049 6AC8 05C6  14         inct  tmp2                  ; Adjust one time
0050               
0051 6ACA C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6ACC B000 
     6ACE B002 
0052                                                   ; Move index entry
0053               
0054 6AD0 0644  14         dect  tmp0                  ; Previous index entry
0055 6AD2 0606  14         dec   tmp2                  ; tmp2--
0056 6AD4 16FA  14         jne   -!                    ; Loop unless completed
0057               
0058 6AD6 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     6AD8 B004 
0059                       ;------------------------------------------------------
0060                       ; Exit
0061                       ;------------------------------------------------------
0062               idx.entry.insert.exit:
0063 6ADA 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.8885
0050                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: TiVi Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Editor Buffer implementation
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
0026 6ADC 0649  14         dect  stack
0027 6ADE C64B  30         mov   r11,*stack            ; Save return address
0028 6AE0 0649  14         dect  stack
0029 6AE2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6AE4 0204  20         li    tmp0,edb.top          ; \
     6AE6 C000 
0034 6AE8 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6AEA A200 
0035 6AEC C804  38         mov   tmp0,@edb.next_free.ptr
     6AEE A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6AF0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6AF2 A20A 
0039 6AF4 04E0  34         clr   @edb.lines            ; Lines=0
     6AF6 A204 
0040 6AF8 04E0  34         clr   @edb.rle              ; RLE compression off
     6AFA A20C 
0041               
0042 6AFC 0204  20         li    tmp0,txt.newfile      ; "New file"
     6AFE 748C 
0043 6B00 C804  38         mov   tmp0,@edb.filename.ptr
     6B02 A20E 
0044               
0045 6B04 0204  20         li    tmp0,txt.filetype.none
     6B06 74D8 
0046 6B08 C804  38         mov   tmp0,@edb.filetype.ptr
     6B0A A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6B0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6B0E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B10 045B  20         b     *r11                  ; Return to caller
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
0081 6B12 0649  14         dect  stack
0082 6B14 C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6B16 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6B18 A10C 
     6B1A 8390 
0087 6B1C 04E0  34         clr   @fb.column
     6B1E A10C 
0088 6B20 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6B22 67DE 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6B24 04C4  14         clr   tmp0                  ; Counter
0093 6B26 C160  34         mov   @fb.current,tmp1      ; Get position
     6B28 A102 
0094 6B2A C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6B2C 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6B2E D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6B30 0986  56         srl   tmp2,8                ; Right justify
0102 6B32 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6B34 0584  14         inc   tmp0                  ; Increase string length
0104 6B36 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6B38 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6B3A A104 
     6B3C 8350 
0111 6B3E A820  54         a     @fb.row,@parm1        ; /
     6B40 A106 
     6B42 8350 
0112               
0113 6B44 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6B46 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6B48 C120  34         mov   @edb.next_free.ptr,tmp0
     6B4A A208 
0120 6B4C C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6B4E 8352 
0121               
0122 6B50 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6B52 24C2 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6B54 C820  54         mov   @waux1,@parm3
     6B56 833C 
     6B58 8354 
0128 6B5A 06A0  32         bl    @idx.entry.update     ; Update index
     6B5C 69B6 
0129                                                   ; \ i  parm1 = Line number in editor buffer
0130                                                   ; | i  parm2 = pointer to line in
0131                                                   ; |            editor buffer
0132                                                   ; / i  parm3 = SAMS page
0133               
0134                       ;------------------------------------------------------
0135                       ; 2. Switch to required SAMS page
0136                       ;------------------------------------------------------
0137 6B5E 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6B60 A212 
     6B62 8354 
0138 6B64 1308  14         jeq   !                     ; Yes, skip setting page
0139               
0140 6B66 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6B68 8354 
0141 6B6A C160  34         mov   @edb.next_free.ptr,tmp1
     6B6C A208 
0142                                                   ; Pointer to line in editor buffer
0143 6B6E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6B70 24FA 
0144                                                   ; \ i  tmp0 = SAMS page
0145                                                   ; / i  tmp1 = Memory address
0146               
0147 6B72 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6B74 A438 
0148               
0149                       ;------------------------------------------------------
0150                       ; 3. Set line prefix in editor buffer
0151                       ;------------------------------------------------------
0152 6B76 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6B78 8392 
0153 6B7A C160  34         mov   @edb.next_free.ptr,tmp1
     6B7C A208 
0154                                                   ; Address of line in editor buffer
0155               
0156 6B7E 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6B80 A208 
0157               
0158 6B82 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6B84 8394 
0159 6B86 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0160 6B88 06C6  14         swpb  tmp2
0161 6B8A DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0162 6B8C 06C6  14         swpb  tmp2
0163 6B8E 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0164               
0165                       ;------------------------------------------------------
0166                       ; 4. Copy line from framebuffer to editor buffer
0167                       ;------------------------------------------------------
0168               edb.line.pack.copyline:
0169 6B90 0286  22         ci    tmp2,2
     6B92 0002 
0170 6B94 1603  14         jne   edb.line.pack.copyline.checkbyte
0171 6B96 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0172 6B98 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0173 6B9A 1007  14         jmp   !
0174               edb.line.pack.copyline.checkbyte:
0175 6B9C 0286  22         ci    tmp2,1
     6B9E 0001 
0176 6BA0 1602  14         jne   edb.line.pack.copyline.block
0177 6BA2 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0178 6BA4 1002  14         jmp   !
0179               edb.line.pack.copyline.block:
0180 6BA6 06A0  32         bl    @xpym2m               ; Copy memory block
     6BA8 2464 
0181                                                   ; \ i  tmp0 = source
0182                                                   ; | i  tmp1 = destination
0183                                                   ; / i  tmp2 = bytes to copy
0184               
0185 6BAA A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6BAC 8394 
     6BAE A208 
0186                                                   ; Update pointer to next free line
0187               
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191               edb.line.pack.exit:
0192 6BB0 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6BB2 8390 
     6BB4 A10C 
0193 6BB6 0460  28         b     @poprt                ; Return to caller
     6BB8 2210 
0194               
0195               
0196               
0197               
0198               ***************************************************************
0199               * edb.line.unpack
0200               * Unpack specified line to framebuffer
0201               ***************************************************************
0202               *  bl   @edb.line.unpack
0203               *--------------------------------------------------------------
0204               * INPUT
0205               * @parm1 = Line to unpack in editor buffer
0206               * @parm2 = Target row in frame buffer
0207               *--------------------------------------------------------------
0208               * OUTPUT
0209               * none
0210               *--------------------------------------------------------------
0211               * Register usage
0212               * tmp0,tmp1,tmp2
0213               *--------------------------------------------------------------
0214               * Memory usage
0215               * rambuf    = Saved @parm1 of edb.line.unpack
0216               * rambuf+2  = Saved @parm2 of edb.line.unpack
0217               * rambuf+4  = Source memory address in editor buffer
0218               * rambuf+6  = Destination memory address in frame buffer
0219               * rambuf+8  = Length of line
0220               ********|*****|*********************|**************************
0221               edb.line.unpack:
0222 6BBA 0649  14         dect  stack
0223 6BBC C64B  30         mov   r11,*stack            ; Save return address
0224 6BBE 0649  14         dect  stack
0225 6BC0 C644  30         mov   tmp0,*stack           ; Push tmp0
0226 6BC2 0649  14         dect  stack
0227 6BC4 C645  30         mov   tmp1,*stack           ; Push tmp1
0228 6BC6 0649  14         dect  stack
0229 6BC8 C646  30         mov   tmp2,*stack           ; Push tmp2
0230                       ;------------------------------------------------------
0231                       ; Sanity check
0232                       ;------------------------------------------------------
0233 6BCA 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6BCC 8350 
     6BCE A204 
0234 6BD0 1104  14         jlt   !
0235 6BD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BD4 FFCE 
0236 6BD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BD8 2030 
0237                       ;------------------------------------------------------
0238                       ; Save parameters
0239                       ;------------------------------------------------------
0240 6BDA C820  54 !       mov   @parm1,@rambuf
     6BDC 8350 
     6BDE 8390 
0241 6BE0 C820  54         mov   @parm2,@rambuf+2
     6BE2 8352 
     6BE4 8392 
0242                       ;------------------------------------------------------
0243                       ; Calculate offset in frame buffer
0244                       ;------------------------------------------------------
0245 6BE6 C120  34         mov   @fb.colsline,tmp0
     6BE8 A10E 
0246 6BEA 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6BEC 8352 
0247 6BEE C1A0  34         mov   @fb.top.ptr,tmp2
     6BF0 A100 
0248 6BF2 A146  18         a     tmp2,tmp1             ; Add base to offset
0249 6BF4 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6BF6 8396 
0250                       ;------------------------------------------------------
0251                       ; Get pointer to line & page-in editor buffer page
0252                       ;------------------------------------------------------
0253 6BF8 C120  34         mov   @parm1,tmp0
     6BFA 8350 
0254 6BFC 06A0  32         bl    @xmem.edb.sams.mappage
     6BFE 6748 
0255                                                   ; Activate editor buffer SAMS page for line
0256                                                   ; \ i  tmp0     = Line number
0257                                                   ; | o  outparm1 = Pointer to line
0258                                                   ; / o  outparm2 = SAMS page
0259               
0260 6C00 C820  54         mov   @outparm2,@edb.sams.page
     6C02 8362 
     6C04 A212 
0261                                                   ; Save current SAMS page
0262                       ;------------------------------------------------------
0263                       ; Handle empty line
0264                       ;------------------------------------------------------
0265 6C06 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6C08 8360 
0266 6C0A 1603  14         jne   !                     ; Check if pointer is set
0267 6C0C 04E0  34         clr   @rambuf+8             ; Set length=0
     6C0E 8398 
0268 6C10 100F  14         jmp   edb.line.unpack.clear
0269                       ;------------------------------------------------------
0270                       ; Get line length
0271                       ;------------------------------------------------------
0272 6C12 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0273 6C14 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6C16 8398 
0274               
0275 6C18 05E0  34         inct  @outparm1             ; Skip line prefix
     6C1A 8360 
0276 6C1C C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6C1E 8360 
     6C20 8394 
0277                       ;------------------------------------------------------
0278                       ; Sanity check on line length
0279                       ;------------------------------------------------------
0280 6C22 0285  22         ci    tmp1,80               ; Sanity check on line length, crash
     6C24 0050 
0281 6C26 1204  14         jle   edb.line.unpack.clear ; if length > 80.
0282 6C28 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C2A FFCE 
0283 6C2C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C2E 2030 
0284                       ;------------------------------------------------------
0285                       ; Erase chars from last column until column 80
0286                       ;------------------------------------------------------
0287               edb.line.unpack.clear:
0288 6C30 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6C32 8396 
0289 6C34 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6C36 8398 
0290               
0291 6C38 04C5  14         clr   tmp1                  ; Fill with >00
0292 6C3A C1A0  34         mov   @fb.colsline,tmp2
     6C3C A10E 
0293 6C3E 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6C40 8398 
0294 6C42 0586  14         inc   tmp2
0295               
0296 6C44 06A0  32         bl    @xfilm                ; Fill CPU memory
     6C46 221A 
0297                                                   ; \ i  tmp0 = Target address
0298                                                   ; | i  tmp1 = Byte to fill
0299                                                   ; / i  tmp2 = Repeat count
0300                       ;------------------------------------------------------
0301                       ; Prepare for unpacking data
0302                       ;------------------------------------------------------
0303               edb.line.unpack.prepare:
0304 6C48 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6C4A 8398 
0305 6C4C 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0306 6C4E C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6C50 8394 
0307 6C52 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6C54 8396 
0308                       ;------------------------------------------------------
0309                       ; Check before copy
0310                       ;------------------------------------------------------
0311               edb.line.unpack.copy:
0312 6C56 0286  22         ci    tmp2,80               ; Check line length
     6C58 0050 
0313 6C5A 1204  14         jle   !
0314 6C5C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C5E FFCE 
0315 6C60 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C62 2030 
0316                       ;------------------------------------------------------
0317                       ; Copy memory block
0318                       ;------------------------------------------------------
0319 6C64 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6C66 2464 
0320                                                   ; \ i  tmp0 = Source address
0321                                                   ; | i  tmp1 = Target address
0322                                                   ; / i  tmp2 = Bytes to copy
0323                       ;------------------------------------------------------
0324                       ; Exit
0325                       ;------------------------------------------------------
0326               edb.line.unpack.exit:
0327 6C68 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0328 6C6A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0329 6C6C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0330 6C6E C2F9  30         mov   *stack+,r11           ; Pop r11
0331 6C70 045B  20         b     *r11                  ; Return to caller
0332               
0333               
0334               
0335               ***************************************************************
0336               * edb.line.getlength
0337               * Get length of specified line
0338               ***************************************************************
0339               *  bl   @edb.line.getlength
0340               *--------------------------------------------------------------
0341               * INPUT
0342               * @parm1 = Line number
0343               *--------------------------------------------------------------
0344               * OUTPUT
0345               * @outparm1 = Length of line
0346               * @outparm2 = SAMS page
0347               *--------------------------------------------------------------
0348               * Register usage
0349               * tmp0,tmp1
0350               *--------------------------------------------------------------
0351               * Remarks
0352               * Expects that the affected SAMS page is already paged-in!
0353               ********|*****|*********************|**************************
0354               edb.line.getlength:
0355 6C72 0649  14         dect  stack
0356 6C74 C64B  30         mov   r11,*stack            ; Push return address
0357 6C76 0649  14         dect  stack
0358 6C78 C644  30         mov   tmp0,*stack           ; Push tmp0
0359 6C7A 0649  14         dect  stack
0360 6C7C C645  30         mov   tmp1,*stack           ; Push tmp1
0361                       ;------------------------------------------------------
0362                       ; Initialisation
0363                       ;------------------------------------------------------
0364 6C7E 04E0  34         clr   @outparm1             ; Reset length
     6C80 8360 
0365 6C82 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6C84 8362 
0366                       ;------------------------------------------------------
0367                       ; Get length
0368                       ;------------------------------------------------------
0369 6C86 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6C88 6A04 
0370                                                   ; \ i  parm1    = Line number
0371                                                   ; | o  outparm1 = Pointer to line
0372                                                   ; / o  outparm2 = SAMS page
0373               
0374 6C8A C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6C8C 8360 
0375 6C8E 1302  14         jeq   edb.line.getlength.exit
0376                                                   ; Exit early if NULL pointer
0377                       ;------------------------------------------------------
0378                       ; Process line prefix
0379                       ;------------------------------------------------------
0380 6C90 C814  46         mov   *tmp0,@outparm1       ; Save length
     6C92 8360 
0381                       ;------------------------------------------------------
0382                       ; Exit
0383                       ;------------------------------------------------------
0384               edb.line.getlength.exit:
0385 6C94 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0386 6C96 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0387 6C98 C2F9  30         mov   *stack+,r11           ; Pop r11
0388 6C9A 045B  20         b     *r11                  ; Return to caller
0389               
0390               
0391               
0392               ***************************************************************
0393               * edb.line.getlength2
0394               * Get length of current row (as seen from editor buffer side)
0395               ***************************************************************
0396               *  bl   @edb.line.getlength2
0397               *--------------------------------------------------------------
0398               * INPUT
0399               * @fb.row = Row in frame buffer
0400               *--------------------------------------------------------------
0401               * OUTPUT
0402               * @fb.row.length = Length of row
0403               *--------------------------------------------------------------
0404               * Register usage
0405               * tmp0
0406               ********|*****|*********************|**************************
0407               edb.line.getlength2:
0408 6C9C 0649  14         dect  stack
0409 6C9E C64B  30         mov   r11,*stack            ; Save return address
0410                       ;------------------------------------------------------
0411                       ; Calculate line in editor buffer
0412                       ;------------------------------------------------------
0413 6CA0 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6CA2 A104 
0414 6CA4 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6CA6 A106 
0415                       ;------------------------------------------------------
0416                       ; Get length
0417                       ;------------------------------------------------------
0418 6CA8 C804  38         mov   tmp0,@parm1
     6CAA 8350 
0419 6CAC 06A0  32         bl    @edb.line.getlength
     6CAE 6C72 
0420 6CB0 C820  54         mov   @outparm1,@fb.row.length
     6CB2 8360 
     6CB4 A108 
0421                                                   ; Save row length
0422                       ;------------------------------------------------------
0423                       ; Exit
0424                       ;------------------------------------------------------
0425               edb.line.getlength2.exit:
0426 6CB6 0460  28         b     @poprt                ; Return to caller
     6CB8 2210 
0427               
**** **** ****     > tivi_b1.asm.8885
0051                       copy  "cmdb.asm"            ; Command Buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: TiVi Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Command Buffer implementation
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
0027 6CBA 0649  14         dect  stack
0028 6CBC C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6CBE 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6CC0 D000 
0033 6CC2 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6CC4 A300 
0034               
0035 6CC6 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6CC8 A302 
0036 6CCA 0204  20         li    tmp0,10
     6CCC 000A 
0037 6CCE C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6CD0 A304 
0038 6CD2 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6CD4 A306 
0039               
0040 6CD6 0204  20         li    tmp0,>1b02            ; Y=27, X=2
     6CD8 1B02 
0041 6CDA C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6CDC A308 
0042               
0043 6CDE 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6CE0 A30E 
0044 6CE2 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6CE4 A310 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6CE6 06A0  32         bl    @film
     6CE8 2214 
0049 6CEA D000             data  cmdb.top,>00,cmdb.size
     6CEC 0000 
     6CEE 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6CF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6CF2 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               
0060               
0061               ***************************************************************
0062               * cmdb.show
0063               * Show command buffer pane
0064               ***************************************************************
0065               * bl @cmdb.show
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
0078               cmdb.show:
0079 6CF4 0649  14         dect  stack
0080 6CF6 C64B  30         mov   r11,*stack            ; Save return address
0081 6CF8 0649  14         dect  stack
0082 6CFA C644  30         mov   tmp0,*stack           ; Push tmp0
0083                       ;------------------------------------------------------
0084                       ; Show command buffer pane
0085                       ;------------------------------------------------------
0086 6CFC C820  54         mov   @wyx,@cmdb.fb.yxsave
     6CFE 832A 
     6D00 A312 
0087                                                   ; Save YX position in frame buffer
0088               
0089 6D02 C120  34         mov   @fb.scrrows.max,tmp0
     6D04 A11A 
0090 6D06 6120  34         s     @cmdb.scrrows,tmp0
     6D08 A304 
0091 6D0A C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6D0C A118 
0092               
0093 6D0E 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0094 6D10 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0095 6D12 0584  14         inc   tmp0                  ; X=1
0096 6D14 C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
     6D16 A30C 
0097               
0098 6D18 0720  34         seto  @cmdb.visible         ; Show pane
     6D1A A302 
0099               
0100 6D1C 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6D1E 0001 
0101 6D20 C804  38         mov   tmp0,@tv.pane.focus   ; /
     6D22 A016 
0102               
0103 6D24 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6D26 A116 
0104               
0105               cmdb.show.exit:
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109 6D28 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0110 6D2A C2F9  30         mov   *stack+,r11           ; Pop r11
0111 6D2C 045B  20         b     *r11                  ; Return to caller
0112               
0113               
0114               
0115               ***************************************************************
0116               * cmdb.hide
0117               * Hide command buffer pane
0118               ***************************************************************
0119               * bl @cmdb.hide
0120               *--------------------------------------------------------------
0121               * INPUT
0122               * none
0123               *--------------------------------------------------------------
0124               * OUTPUT
0125               * none
0126               *--------------------------------------------------------------
0127               * Register usage
0128               * none
0129               *--------------------------------------------------------------
0130               * Hiding the command buffer automatically passes pane focus
0131               * to frame buffer.
0132               ********|*****|*********************|**************************
0133               cmdb.hide:
0134 6D2E 0649  14         dect  stack
0135 6D30 C64B  30         mov   r11,*stack            ; Save return address
0136                       ;------------------------------------------------------
0137                       ; Hide command buffer pane
0138                       ;------------------------------------------------------
0139 6D32 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6D34 A11A 
     6D36 A118 
0140                                                   ; Resize framebuffer
0141               
0142 6D38 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     6D3A A312 
     6D3C 832A 
0143               
0144 6D3E 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     6D40 A302 
0145 6D42 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6D44 A116 
0146 6D46 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6D48 A016 
0147               
0148               cmdb.hide.exit:
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152 6D4A C2F9  30         mov   *stack+,r11           ; Pop r11
0153 6D4C 045B  20         b     *r11                  ; Return to caller
0154               
0155               
0156               
0157               ***************************************************************
0158               * cmdb.refresh
0159               * Refresh command buffer content
0160               ***************************************************************
0161               * bl @cmdb.refresh
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
0172               * Notes
0173               ********|*****|*********************|**************************
0174               cmdb.refresh:
0175 6D4E 0649  14         dect  stack
0176 6D50 C64B  30         mov   r11,*stack            ; Save return address
0177 6D52 0649  14         dect  stack
0178 6D54 C644  30         mov   tmp0,*stack           ; Push tmp0
0179 6D56 0649  14         dect  stack
0180 6D58 C645  30         mov   tmp1,*stack           ; Push tmp1
0181 6D5A 0649  14         dect  stack
0182 6D5C C646  30         mov   tmp2,*stack           ; Push tmp2
0183                       ;------------------------------------------------------
0184                       ; Dump Command buffer content
0185                       ;------------------------------------------------------
0186 6D5E C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6D60 832A 
     6D62 A30A 
0187               
0188 6D64 C820  54         mov   @cmdb.yxtop,@wyx
     6D66 A30C 
     6D68 832A 
0189 6D6A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6D6C 23D8 
0190               
0191 6D6E C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6D70 A300 
0192 6D72 0206  20         li    tmp2,9*80
     6D74 02D0 
0193               
0194 6D76 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6D78 241C 
0195                                                   ; | i  tmp0 = VDP target address
0196                                                   ; | i  tmp1 = RAM source address
0197                                                   ; / i  tmp2 = Number of bytes to copy
0198               
0199                       ;------------------------------------------------------
0200                       ; Show command buffer prompt
0201                       ;------------------------------------------------------
0202 6D7A 06A0  32         bl    @putat
     6D7C 240E 
0203 6D7E 1B01                   byte 27,1
0204 6D80 7498                   data txt.cmdb.prompt
0205               
0206 6D82 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6D84 A30A 
     6D86 A114 
0207 6D88 C820  54         mov   @cmdb.yxsave,@wyx
     6D8A A30A 
     6D8C 832A 
0208                                                   ; Restore YX position
0209               cmdb.refresh.exit:
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213 6D8E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0214 6D90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0215 6D92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0216 6D94 C2F9  30         mov   *stack+,r11           ; Pop r11
0217 6D96 045B  20         b     *r11                  ; Return to caller
0218               
**** **** ****     > tivi_b1.asm.8885
0052                       copy  "fh.read.sams.asm"    ; File handler read file
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
0011               * Read file into editor buffer with SAMS support
0012               ***************************************************************
0013               *  bl   @fh.file.read.sams
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "loading indicator 1"
0018               * parm3 = Pointer to callback function "loading indicator 2"
0019               * parm4 = Pointer to callback function "loading indicator 3"
0020               * parm5 = Pointer to callback function "File I/O error handler"
0021               * parm6 = Not used yet (starting line in file)
0022               * parm7 = Not used yet (starting line in editor buffer)
0023               * parm8 = Not used yet (number of lines to read)
0024               *--------------------------------------------------------------
0025               * OUTPUT
0026               *--------------------------------------------------------------
0027               * Register usage
0028               * tmp0, tmp1, tmp2, tmp3, tmp4
0029               ********|*****|*********************|**************************
0030               fh.file.read.sams:
0031 6D98 0649  14         dect  stack
0032 6D9A C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6D9C 04E0  34         clr   @fh.rleonload         ; No RLE compression!
     6D9E A444 
0037 6DA0 04E0  34         clr   @fh.records           ; Reset records counter
     6DA2 A42E 
0038 6DA4 04E0  34         clr   @fh.counter           ; Clear internal counter
     6DA6 A434 
0039 6DA8 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6DAA A432 
0040 6DAC 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 6DAE 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6DB0 A42A 
0042 6DB2 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6DB4 A42C 
0043               
0044 6DB6 C120  34         mov   @edb.top.ptr,tmp0
     6DB8 A200 
0045 6DBA 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6DBC 24C2 
0046                                                   ; \ i  tmp0  = Memory address
0047                                                   ; | o  waux1 = SAMS page number
0048                                                   ; / o  waux2 = Address of SAMS register
0049               
0050 6DBE C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6DC0 833C 
     6DC2 A438 
0051 6DC4 C820  54         mov   @waux1,@fh.sams.hipage
     6DC6 833C 
     6DC8 A43A 
0052                                                   ; Set highest SAMS page in use
0053                       ;------------------------------------------------------
0054                       ; Save parameters / callback functions
0055                       ;------------------------------------------------------
0056 6DCA C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6DCC 8350 
     6DCE A436 
0057 6DD0 C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
     6DD2 8352 
     6DD4 A43C 
0058 6DD6 C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
     6DD8 8354 
     6DDA A43E 
0059 6DDC C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
     6DDE 8356 
     6DE0 A440 
0060 6DE2 C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
     6DE4 8358 
     6DE6 A442 
0061                       ;------------------------------------------------------
0062                       ; Sanity check
0063                       ;------------------------------------------------------
0064 6DE8 C120  34         mov   @fh.callback1,tmp0
     6DEA A43C 
0065 6DEC 0284  22         ci    tmp0,>6000            ; Insane address ?
     6DEE 6000 
0066 6DF0 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0067               
0068 6DF2 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6DF4 7FFF 
0069 6DF6 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0070               
0071 6DF8 C120  34         mov   @fh.callback2,tmp0
     6DFA A43E 
0072 6DFC 0284  22         ci    tmp0,>6000            ; Insane address ?
     6DFE 6000 
0073 6E00 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0074               
0075 6E02 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E04 7FFF 
0076 6E06 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0077               
0078 6E08 C120  34         mov   @fh.callback3,tmp0
     6E0A A440 
0079 6E0C 0284  22         ci    tmp0,>6000            ; Insane address ?
     6E0E 6000 
0080 6E10 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0081               
0082 6E12 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6E14 7FFF 
0083 6E16 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0084               
0085 6E18 1004  14         jmp   fh.file.read.sams.load1
0086                                                   ; All checks passed, continue.
0087                                                   ;--------------------------
0088                                                   ; Check failed, crash CPU!
0089                                                   ;--------------------------
0090               fh.file.read.crash:
0091 6E1A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E1C FFCE 
0092 6E1E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E20 2030 
0093                       ;------------------------------------------------------
0094                       ; Show "loading indicator 1"
0095                       ;------------------------------------------------------
0096               fh.file.read.sams.load1:
0097 6E22 C120  34         mov   @fh.callback1,tmp0
     6E24 A43C 
0098 6E26 0694  24         bl    *tmp0                 ; Run callback function
0099                       ;------------------------------------------------------
0100                       ; Copy PAB header to VDP
0101                       ;------------------------------------------------------
0102               fh.file.read.sams.pabheader:
0103 6E28 06A0  32         bl    @cpym2v
     6E2A 2416 
0104 6E2C 0A60                   data fh.vpab,fh.file.pab.header,9
     6E2E 6F7E 
     6E30 0009 
0105                                                   ; Copy PAB header to VDP
0106                       ;------------------------------------------------------
0107                       ; Append file descriptor to PAB header in VDP
0108                       ;------------------------------------------------------
0109 6E32 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6E34 0A69 
0110 6E36 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6E38 A436 
0111 6E3A D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0112 6E3C 0986  56         srl   tmp2,8                ; Right justify
0113 6E3E 0586  14         inc   tmp2                  ; Include length byte as well
0114 6E40 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6E42 241C 
0115                       ;------------------------------------------------------
0116                       ; Load GPL scratchpad layout
0117                       ;------------------------------------------------------
0118 6E44 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6E46 2AA0 
0119 6E48 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0120                       ;------------------------------------------------------
0121                       ; Open file
0122                       ;------------------------------------------------------
0123 6E4A 06A0  32         bl    @file.open
     6E4C 2BEE 
0124 6E4E 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0125 6E50 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6E52 2026 
0126 6E54 1602  14         jne   fh.file.read.sams.record
0127 6E56 0460  28         b     @fh.file.read.sams.error
     6E58 6F48 
0128                                                   ; Yes, IO error occured
0129                       ;------------------------------------------------------
0130                       ; Step 1: Read file record
0131                       ;------------------------------------------------------
0132               fh.file.read.sams.record:
0133 6E5A 05A0  34         inc   @fh.records           ; Update counter
     6E5C A42E 
0134 6E5E 04E0  34         clr   @fh.reclen            ; Reset record length
     6E60 A430 
0135               
0136 6E62 06A0  32         bl    @file.record.read     ; Read file record
     6E64 2C30 
0137 6E66 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0138                                                   ; |           (without +9 offset!)
0139                                                   ; | o  tmp0 = Status byte
0140                                                   ; | o  tmp1 = Bytes read
0141                                                   ; | o  tmp2 = Status register contents
0142                                                   ; /           upon DSRLNK return
0143               
0144 6E68 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6E6A A42A 
0145 6E6C C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6E6E A430 
0146 6E70 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6E72 A42C 
0147                       ;------------------------------------------------------
0148                       ; 1a: Calculate kilobytes processed
0149                       ;------------------------------------------------------
0150 6E74 A805  38         a     tmp1,@fh.counter
     6E76 A434 
0151 6E78 A160  34         a     @fh.counter,tmp1
     6E7A A434 
0152 6E7C 0285  22         ci    tmp1,1024
     6E7E 0400 
0153 6E80 1106  14         jlt   !
0154 6E82 05A0  34         inc   @fh.kilobytes
     6E84 A432 
0155 6E86 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6E88 FC00 
0156 6E8A C805  38         mov   tmp1,@fh.counter
     6E8C A434 
0157                       ;------------------------------------------------------
0158                       ; 1b: Load spectra scratchpad layout
0159                       ;------------------------------------------------------
0160 6E8E 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6E90 2A26 
0161 6E92 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E94 2AC2 
0162 6E96 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0163                       ;------------------------------------------------------
0164                       ; 1c: Check if a file error occured
0165                       ;------------------------------------------------------
0166               fh.file.read.sams.check_fioerr:
0167 6E98 C1A0  34         mov   @fh.ioresult,tmp2
     6E9A A42C 
0168 6E9C 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6E9E 2026 
0169 6EA0 1602  14         jne   fh.file.read.sams.check_setpage
0170                                                   ; No, goto (1d)
0171 6EA2 0460  28         b     @fh.file.read.sams.error
     6EA4 6F48 
0172                                                   ; Yes, so handle file error
0173                       ;------------------------------------------------------
0174                       ; 1d: Check if SAMS page needs to be set
0175                       ;------------------------------------------------------
0176               fh.file.read.sams.check_setpage:
0177 6EA6 C120  34         mov   @edb.next_free.ptr,tmp0
     6EA8 A208 
0178                                                   ;--------------------------
0179                                                   ; Sanity check
0180                                                   ;--------------------------
0181 6EAA 0284  22         ci    tmp0,edb.top + edb.size
     6EAC D000 
0182                                                   ; Insane address ?
0183 6EAE 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0184                                                   ;--------------------------
0185                                                   ; Check overflow
0186                                                   ;--------------------------
0187 6EB0 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6EB2 0FFF 
0188 6EB4 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6EB6 A430 
0189 6EB8 05C4  14         inct  tmp0                  ; +2 for line prefix
0190 6EBA 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6EBC 0FF0 
0191 6EBE 110E  14         jlt   fh.file.read.sams.process_line
0192                                                   ; Not yet so skip SAMS page switch
0193                       ;------------------------------------------------------
0194                       ; 1e: Increase SAMS page
0195                       ;------------------------------------------------------
0196 6EC0 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6EC2 A438 
0197 6EC4 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6EC6 A438 
     6EC8 A43A 
0198                                                   ; Set highest SAMS page
0199 6ECA C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6ECC A200 
     6ECE A208 
0200                                                   ; Start at top of SAMS page again
0201                       ;------------------------------------------------------
0202                       ; 1f: Switch to SAMS page
0203                       ;------------------------------------------------------
0204 6ED0 C120  34         mov   @fh.sams.page,tmp0
     6ED2 A438 
0205 6ED4 C160  34         mov   @edb.top.ptr,tmp1
     6ED6 A200 
0206 6ED8 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6EDA 24FA 
0207                                                   ; \ i  tmp0 = SAMS page number
0208                                                   ; / i  tmp1 = Memory address
0209                       ;------------------------------------------------------
0210                       ; Step 2: Process line
0211                       ;------------------------------------------------------
0212               fh.file.read.sams.process_line:
0213 6EDC 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6EDE 0960 
0214 6EE0 C160  34         mov   @edb.next_free.ptr,tmp1
     6EE2 A208 
0215                                                   ; RAM target in editor buffer
0216               
0217 6EE4 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6EE6 8352 
0218               
0219 6EE8 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6EEA A430 
0220 6EEC 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0221                                                   ; Handle empty line
0222                       ;------------------------------------------------------
0223                       ; 2a: Copy line from VDP to CPU editor buffer
0224                       ;------------------------------------------------------
0225                                                   ; Put line length word before string
0226 6EEE DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0227 6EF0 06C6  14         swpb  tmp2                  ; |
0228 6EF2 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0229 6EF4 06C6  14         swpb  tmp2                  ; /
0230               
0231 6EF6 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6EF8 A208 
0232 6EFA A806  38         a     tmp2,@edb.next_free.ptr
     6EFC A208 
0233                                                   ; Add line length
0234               
0235 6EFE 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6F00 2442 
0236                                                   ; \ i  tmp0 = VDP source address
0237                                                   ; | i  tmp1 = RAM target address
0238                                                   ; / i  tmp2 = Bytes to copy
0239               
0240                       ;------------------------------------------------------
0241                       ; 2b: Align pointer to multiple of 16 memory address
0242                       ;------------------------------------------------------
0243 6F02 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6F04 A208 
0244 6F06 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0245 6F08 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6F0A 000F 
0246 6F0C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6F0E A208 
0247               
0248               
0249                       ;------------------------------------------------------
0250                       ; Step 3: Update index
0251                       ;------------------------------------------------------
0252               fh.file.read.sams.prepindex:
0253 6F10 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6F12 A204 
     6F14 8350 
0254                                                   ; parm2 = Must allready be set!
0255 6F16 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6F18 A438 
     6F1A 8354 
0256               
0257 6F1C 1009  14         jmp   fh.file.read.sams.updindex
0258                                                   ; Update index
0259                       ;------------------------------------------------------
0260                       ; 3a: Special handling for empty line
0261                       ;------------------------------------------------------
0262               fh.file.read.sams.prepindex.emptyline:
0263 6F1E C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6F20 A42E 
     6F22 8350 
0264 6F24 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6F26 8350 
0265 6F28 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6F2A 8352 
0266 6F2C 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6F2E 8354 
0267                       ;------------------------------------------------------
0268                       ; 3b: Do actual index update
0269                       ;------------------------------------------------------
0270               fh.file.read.sams.updindex:
0271 6F30 06A0  32         bl    @idx.entry.update     ; Update index
     6F32 69B6 
0272                                                   ; \ i  parm1    = Line num in editor buffer
0273                                                   ; | i  parm2    = Pointer to line in editor
0274                                                   ; |               buffer
0275                                                   ; | i  parm3    = SAMS page
0276                                                   ; | o  outparm1 = Pointer to updated index
0277                                                   ; /               entry
0278               
0279 6F34 05A0  34         inc   @edb.lines            ; lines=lines+1
     6F36 A204 
0280                       ;------------------------------------------------------
0281                       ; Step 4: Display results
0282                       ;------------------------------------------------------
0283               fh.file.read.sams.display:
0284 6F38 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6F3A A43E 
0285 6F3C 0694  24         bl    *tmp0                 ; Run callback function
0286                       ;------------------------------------------------------
0287                       ; 4a: Next record
0288                       ;------------------------------------------------------
0289               fh.file.read.sams.next:
0290 6F3E 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6F40 2AA0 
0291 6F42 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0292               
0293 6F44 0460  28         b     @fh.file.read.sams.record
     6F46 6E5A 
0294                                                   ; Next record
0295                       ;------------------------------------------------------
0296                       ; Error handler
0297                       ;------------------------------------------------------
0298               fh.file.read.sams.error:
0299 6F48 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6F4A A42A 
0300 6F4C 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0301 6F4E 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6F50 0005 
0302 6F52 1309  14         jeq   fh.file.read.sams.eof
0303                                                   ; All good. File closed by DSRLNK
0304                       ;------------------------------------------------------
0305                       ; File error occured
0306                       ;------------------------------------------------------
0307 6F54 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F56 2AC2 
0308 6F58 3F00                   data scrpad.backup2   ; / >2100->8300
0309               
0310 6F5A 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F5C 6732 
0311               
0312 6F5E C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
     6F60 A442 
0313 6F62 0694  24         bl    *tmp0                 ; Run callback function
0314 6F64 100A  14         jmp   fh.file.read.sams.exit
0315                       ;------------------------------------------------------
0316                       ; End-Of-File reached
0317                       ;------------------------------------------------------
0318               fh.file.read.sams.eof:
0319 6F66 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F68 2AC2 
0320 6F6A 3F00                   data scrpad.backup2   ; / >2100->8300
0321               
0322 6F6C 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F6E 6732 
0323                       ;------------------------------------------------------
0324                       ; Show "loading indicator 3" (final)
0325                       ;------------------------------------------------------
0326 6F70 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     6F72 A206 
0327               
0328 6F74 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
     6F76 A440 
0329 6F78 0694  24         bl    *tmp0                 ; Run callback function
0330               *--------------------------------------------------------------
0331               * Exit
0332               *--------------------------------------------------------------
0333               fh.file.read.sams.exit:
0334 6F7A 0460  28         b     @poprt                ; Return to caller
     6F7C 2210 
0335               
0336               
0337               
0338               
0339               
0340               
0341               ***************************************************************
0342               * PAB for accessing DV/80 file
0343               ********|*****|*********************|**************************
0344               fh.file.pab.header:
0345 6F7E 0014             byte  io.op.open            ;  0    - OPEN
0346                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0347 6F80 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0348 6F82 5000             byte  80                    ;  4    - Record length (80 chars max)
0349                       byte  00                    ;  5    - Character count
0350 6F84 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0351 6F86 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0352                       ;------------------------------------------------------
0353                       ; File descriptor part (variable length)
0354                       ;------------------------------------------------------
0355                       ; byte  12                  ;  9    - File descriptor length
0356                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0357                                                   ;         (Device + '.' + File name)
**** **** ****     > tivi_b1.asm.8885
0053                       copy  "fm.load.asm"         ; File manager loadfile
**** **** ****     > fm.load.asm
0001               * FILE......: fm_load.asm
0002               * Purpose...: High-level file manager module
0003               
0004               *---------------------------------------------------------------
0005               * Load file into editor
0006               *---------------------------------------------------------------
0007               * bl    @fm.loadfile
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * tmp0  = Pointer to length-prefixed string containing both
0011               *         device and filename
0012               ********|*****|*********************|**************************
0013               fm.loadfile:
0014 6F88 0649  14         dect  stack
0015 6F8A C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6F8C C804  38         mov   tmp0,@parm1           ; Setup file to load
     6F8E 8350 
0018 6F90 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6F92 6ADC 
0019 6F94 06A0  32         bl    @idx.init             ; Initialize index
     6F96 68B4 
0020 6F98 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6F9A 6788 
0021 6F9C 06A0  32         bl    @cmdb.hide            ; Hide command buffer
     6F9E 6D2E 
0022 6FA0 C820  54         mov   @parm1,@edb.filename.ptr
     6FA2 8350 
     6FA4 A20E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6FA6 06A0  32         bl    @filv
     6FA8 226C 
0028 6FAA 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6FAC 0000 
     6FAE 0004 
0029               
0030 6FB0 C160  34         mov   @fb.scrrows,tmp1
     6FB2 A118 
0031 6FB4 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6FB6 A10E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6FB8 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6FBA 0050 
0035 6FBC 0205  20         li    tmp1,32               ; Character to fill
     6FBE 0020 
0036               
0037 6FC0 06A0  32         bl    @xfilv                ; Fill VDP memory
     6FC2 2272 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6FC4 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     6FC6 6FF8 
0045 6FC8 C804  38         mov   tmp0,@parm2           ; Register callback 1
     6FCA 8352 
0046               
0047 6FCC 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     6FCE 7030 
0048 6FD0 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6FD2 8354 
0049               
0050 6FD4 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     6FD6 7062 
0051 6FD8 C804  38         mov   tmp0,@parm4           ; Register callback 3
     6FDA 8356 
0052               
0053 6FDC 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     6FDE 7094 
0054 6FE0 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6FE2 8358 
0055               
0056 6FE4 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6FE6 6D98 
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
0068 6FE8 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6FEA A206 
0069                                                   ; longer dirty.
0070               
0071 6FEC 0204  20         li    tmp0,txt.filetype.DV80
     6FEE 74CC 
0072 6FF0 C804  38         mov   tmp0,@edb.filetype.ptr
     6FF2 A210 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6FF4 0460  28         b     @poprt                ; Return to caller
     6FF6 2210 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               *---------------------------------------------------------------
0085               * Is expected to be passed as parm2 to @tfh.file.read
0086               *---------------------------------------------------------------
0087               fm.loadfile.callback.indicator1:
0088 6FF8 0649  14         dect  stack
0089 6FFA C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Show loading indicators and file descriptor
0092                       ;------------------------------------------------------
0093 6FFC 06A0  32         bl    @hchar
     6FFE 2740 
0094 7000 1D03                   byte 29,3,32,77
     7002 204D 
0095 7004 FFFF                   data EOL
0096               
0097 7006 06A0  32         bl    @putat
     7008 240E 
0098 700A 1D03                   byte 29,3
0099 700C 7444                   data txt.loading      ; Display "Loading...."
0100               
0101 700E 8820  54         c     @fh.rleonload,@w$ffff
     7010 A444 
     7012 202C 
0102 7014 1604  14         jne   !
0103 7016 06A0  32         bl    @putat
     7018 240E 
0104 701A 1D44                   byte 29,68
0105 701C 7454                   data txt.rle          ; Display "RLE"
0106               
0107 701E 06A0  32 !       bl    @at
     7020 264C 
0108 7022 1D0E                   byte 29,14            ; Cursor YX position
0109 7024 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7026 8350 
0110 7028 06A0  32         bl    @xutst0               ; Display device/filename
     702A 23FE 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.callback.indicator1.exit:
0115 702C 0460  28         b     @poprt                ; Return to caller
     702E 2210 
0116               
0117               
0118               
0119               
0120               *---------------------------------------------------------------
0121               * Callback function "Show loading indicator 2"
0122               *---------------------------------------------------------------
0123               * Is expected to be passed as parm3 to @tfh.file.read
0124               *---------------------------------------------------------------
0125               fm.loadfile.callback.indicator2:
0126 7030 0649  14         dect  stack
0127 7032 C64B  30         mov   r11,*stack            ; Save return address
0128               
0129 7034 06A0  32         bl    @putnum
     7036 2A1C 
0130 7038 1D4B                   byte 29,75            ; Show lines read
0131 703A A204                   data edb.lines,rambuf,>3020
     703C 8390 
     703E 3020 
0132               
0133 7040 8220  34         c     @fh.kilobytes,tmp4
     7042 A432 
0134 7044 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0135               
0136 7046 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     7048 A432 
0137               
0138 704A 06A0  32         bl    @putnum
     704C 2A1C 
0139 704E 1D38                   byte 29,56            ; Show kilobytes read
0140 7050 A432                   data fh.kilobytes,rambuf,>3020
     7052 8390 
     7054 3020 
0141               
0142 7056 06A0  32         bl    @putat
     7058 240E 
0143 705A 1D3D                   byte 29,61
0144 705C 7450                   data txt.kb           ; Show "kb" string
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fm.loadfile.callback.indicator2.exit:
0149 705E 0460  28         b     @poprt                ; Return to caller
     7060 2210 
0150               
0151               
0152               
0153               
0154               
0155               *---------------------------------------------------------------
0156               * Callback function "Show loading indicator 3"
0157               *---------------------------------------------------------------
0158               * Is expected to be passed as parm4 to @tfh.file.read
0159               *---------------------------------------------------------------
0160               fm.loadfile.callback.indicator3:
0161 7062 0649  14         dect  stack
0162 7064 C64B  30         mov   r11,*stack            ; Save return address
0163               
0164               
0165 7066 06A0  32         bl    @hchar
     7068 2740 
0166 706A 1D03                   byte 29,3,32,50       ; Erase loading indicator
     706C 2032 
0167 706E FFFF                   data EOL
0168               
0169 7070 06A0  32         bl    @putnum
     7072 2A1C 
0170 7074 1D38                   byte 29,56            ; Show kilobytes read
0171 7076 A432                   data fh.kilobytes,rambuf,>3020
     7078 8390 
     707A 3020 
0172               
0173 707C 06A0  32         bl    @putat
     707E 240E 
0174 7080 1D3D                   byte 29,61
0175 7082 7450                   data txt.kb           ; Show "kb" string
0176               
0177 7084 06A0  32         bl    @putnum
     7086 2A1C 
0178 7088 1D4B                   byte 29,75            ; Show lines read
0179 708A A42E                   data fh.records,rambuf,>3020
     708C 8390 
     708E 3020 
0180                       ;------------------------------------------------------
0181                       ; Exit
0182                       ;------------------------------------------------------
0183               fm.loadfile.callback.indicator3.exit:
0184 7090 0460  28         b     @poprt                ; Return to caller
     7092 2210 
0185               
0186               
0187               
0188               *---------------------------------------------------------------
0189               * Callback function "File I/O error handler"
0190               *---------------------------------------------------------------
0191               * Is expected to be passed as parm5 to @tfh.file.read
0192               ********|*****|*********************|**************************
0193               fm.loadfile.callback.fioerr:
0194 7094 0649  14         dect  stack
0195 7096 C64B  30         mov   r11,*stack            ; Save return address
0196               
0197 7098 06A0  32         bl    @hchar
     709A 2740 
0198 709C 1D00                   byte 29,0,32,50       ; Erase loading indicator
     709E 2032 
0199 70A0 FFFF                   data EOL
0200               
0201                       ;------------------------------------------------------
0202                       ; Display I/O error message
0203                       ;------------------------------------------------------
0204 70A2 06A0  32         bl    @cpym2m
     70A4 245E 
0205 70A6 745F                   data txt.ioerr+1
0206 70A8 D000                   data cmdb.top
0207 70AA 0029                   data 41               ; Error message
0208               
0209               
0210 70AC C120  34         mov   @edb.filename.ptr,tmp0
     70AE A20E 
0211 70B0 D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 70B2 0986  56         srl   tmp2,8                ; Right align
0213 70B4 0584  14         inc   tmp0                  ; Skip length byte
0214 70B6 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     70B8 D02A 
0215               
0216 70BA 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     70BC 2464 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220               
0221               
0222 70BE 0204  20         li    tmp0,txt.newfile      ; New file
     70C0 748C 
0223 70C2 C804  38         mov   tmp0,@edb.filename.ptr
     70C4 A20E 
0224               
0225 70C6 0204  20         li    tmp0,txt.filetype.none
     70C8 74D8 
0226 70CA C804  38         mov   tmp0,@edb.filetype.ptr
     70CC A210 
0227                                                   ; Empty filetype string
0228               
0229 70CE C820  54         mov   @cmdb.scrrows,@parm1
     70D0 A304 
     70D2 8350 
0230 70D4 06A0  32         bl    @cmdb.show
     70D6 6CF4 
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               fm.loadfile.callback.fioerr.exit:
0235 70D8 0460  28         b     @poprt                ; Return to caller
     70DA 2210 
**** **** ****     > tivi_b1.asm.8885
0054                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: TiVi Editor - Keyboard handling (spectra2 user hook)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Keyboard handling (spectra2 user hook)
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011               hook.keyscan:
0012 70DC 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     70DE 2014 
0013 70E0 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 70E2 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     70E4 2014 
0019 70E6 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     70E8 833C 
     70EA 833E 
0020 70EC 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 70EE C820  54         mov   @waux1,@waux2         ; Save as previous key
     70F0 833C 
     70F2 833E 
0026 70F4 0460  28         b     @edkey.key.process    ; Process key
     70F6 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 70F8 04E0  34         clr   @waux1
     70FA 833C 
0032 70FC 04E0  34         clr   @waux2
     70FE 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 7100 0204  20         li    tmp0,2000             ; Avoid key bouncing
     7102 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 7104 0604  14         dec   tmp0
0043 7106 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 7108 0460  28         b     @hookok               ; Return
     710A 2C78 
**** **** ****     > tivi_b1.asm.8885
0055                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: TiVi Editor - VDP draw editor panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0010               ***************************************************************
0011               task.vdp.panes:
0012 710C C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     710E A116 
0013 7110 136E  14         jeq   task.vdp.panes.exit   ; No, skip update
0014                       ;------------------------------------------------------
0015                       ; Show banner line
0016                       ;------------------------------------------------------
0017 7112 06A0  32         bl    @pane.topline.draw
     7114 7272 
0018 7116 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7118 832A 
     711A A114 
0019                       ;------------------------------------------------------
0020                       ; Determine how many rows to copy
0021                       ;------------------------------------------------------
0022 711C 8820  54         c     @edb.lines,@fb.scrrows
     711E A204 
     7120 A118 
0023 7122 1103  14         jlt   task.vdp.panes.setrows.small
0024 7124 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7126 A118 
0025 7128 1003  14         jmp   task.vdp.panes.copy.framebuffer
0026                       ;------------------------------------------------------
0027                       ; Less lines in editor buffer as rows in frame buffer
0028                       ;------------------------------------------------------
0029               task.vdp.panes.setrows.small:
0030 712A C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     712C A204 
0031 712E 0585  14         inc   tmp1
0032                       ;------------------------------------------------------
0033                       ; Determine area to copy
0034                       ;------------------------------------------------------
0035               task.vdp.panes.copy.framebuffer:
0036 7130 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7132 A10E 
0037                                                   ; 16 bit part is in tmp2!
0038 7134 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     7136 0050 
0039 7138 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     713A A100 
0040                       ;------------------------------------------------------
0041                       ; Copy memory block
0042                       ;------------------------------------------------------
0043 713C 06A0  32         bl    @xpym2v               ; Copy to VDP
     713E 241C 
0044                                                   ; \ i  tmp0 = VDP target address
0045                                                   ; | i  tmp1 = RAM source address
0046                                                   ; / i  tmp2 = Bytes to copy
0047 7140 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7142 A116 
0048                       ;-------------------------------------------------------
0049                       ; Draw EOF marker at end-of-file
0050                       ;-------------------------------------------------------
0051 7144 C120  34         mov   @edb.lines,tmp0
     7146 A204 
0052 7148 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     714A A104 
0053 714C 05C4  14         inct  tmp0                  ; Y = Y + 2
0054 714E 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     7150 A118 
0055 7152 121C  14         jle   task.vdp.panes.draw_double.line
0056                       ;-------------------------------------------------------
0057                       ; Do actual drawing of EOF marker
0058                       ;-------------------------------------------------------
0059               task.vdp.panes.draw_marker:
0060 7154 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0061 7156 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7158 832A 
0062               
0063 715A 06A0  32         bl    @putstr
     715C 23FC 
0064 715E 742E                   data txt.marker       ; Display *EOF*
0065                       ;-------------------------------------------------------
0066                       ; Draw empty line after (and below) EOF marker
0067                       ;-------------------------------------------------------
0068 7160 06A0  32         bl    @setx
     7162 2662 
0069 7164 0005                   data  5               ; Cursor after *EOF* string
0070               
0071 7166 C120  34         mov   @wyx,tmp0
     7168 832A 
0072 716A 0984  56         srl   tmp0,8                ; Right justify
0073 716C 0584  14         inc   tmp0                  ; One time adjust
0074 716E 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     7170 A118 
0075 7172 1303  14         jeq   !
0076 7174 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7176 009B 
0077 7178 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0078 717A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     717C 004B 
0079                       ;-------------------------------------------------------
0080                       ; Draw 1 or 2 empty lines
0081                       ;-------------------------------------------------------
0082               task.vdp.panes.draw_marker.empty.line:
0083 717E 0604  14         dec   tmp0                  ; One time adjust
0084 7180 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7182 23D8 
0085 7184 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7186 0020 
0086 7188 06A0  32         bl    @xfilv                ; Fill VDP memory
     718A 2272 
0087                                                   ; i  tmp0 = VDP destination
0088                                                   ; i  tmp1 = byte to write
0089                                                   ; i  tmp2 = Number of bytes to write
0090                       ;-------------------------------------------------------
0091                       ; Draw "double" bottom line (above command buffer)
0092                       ;-------------------------------------------------------
0093               task.vdp.panes.draw_double.line:
0094 718C C120  34         mov   @fb.scrrows,tmp0
     718E A118 
0095 7190 0584  14         inc   tmp0                  ; 1st Line after frame buffer boundary
0096 7192 06C4  14         swpb  tmp0                  ; LSB to MSB
0097 7194 C804  38         mov   tmp0,@wyx             ; Save YX
     7196 832A 
0098               
0099 7198 C120  34         mov   @cmdb.visible,tmp0    ; Command buffer hidden ?
     719A A302 
0100 719C 1306  14         jeq   !                     ; Yes, full double line
0101                       ;-------------------------------------------------------
0102                       ; Double line with corners
0103                       ;-------------------------------------------------------
0104 719E 06A0  32         bl    @setx                 ; Set cursor to screen column 17
     71A0 2662 
0105 71A2 0001                   data 1
0106 71A4 0206  20         li    tmp2,78               ; Repeat 78x
     71A6 004E 
0107 71A8 1005  14         jmp   task.vdp.panes.draw_double.draw
0108                       ;-------------------------------------------------------
0109                       ; Continuous double line (80 characters)
0110                       ;-------------------------------------------------------
0111 71AA 06A0  32 !       bl    @setx                 ; Set cursor to screen column 0
     71AC 2662 
0112 71AE 0000                   data 0
0113 71B0 0206  20         li    tmp2,80               ; Repeat 80x
     71B2 0050 
0114                       ;-------------------------------------------------------
0115                       ; Do actual drawing
0116                       ;-------------------------------------------------------
0117               task.vdp.panes.draw_double.draw:
0118 71B4 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     71B6 23D8 
0119 71B8 0205  20         li    tmp1,3                ; Character to write (double line)
     71BA 0003 
0120 71BC 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     71BE 2272 
0121                                                   ; | i  tmp0 = VDP destination
0122                                                   ; | i  tmp1 = Byte to write
0123                                                   ; / i  tmp2 = Number of bstes to write
0124 71C0 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     71C2 A114 
     71C4 832A 
0125                       ;-------------------------------------------------------
0126                       ; Show command buffer
0127                       ;-------------------------------------------------------
0128 71C6 C120  34         mov   @cmdb.visible,tmp0     ; Show command buffer?
     71C8 A302 
0129 71CA 1311  14         jeq   task.vdp.panes.exit    ; No, skip
0130               
0131 71CC 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     71CE 6D4E 
0132               
0133 71D0 06A0  32         bl    @vchar
     71D2 2768 
0134 71D4 1200                   byte 18,0,4,1          ; Top left corner
     71D6 0401 
0135 71D8 124F                   byte 18,79,5,1         ; Top right corner
     71DA 0501 
0136 71DC 1300                   byte 19,0,6,9          ; Left vertical double line
     71DE 0609 
0137 71E0 134F                   byte 19,79,7,9         ; Right vertical double line
     71E2 0709 
0138 71E4 1C00                   byte 28,0,8,1          ; Bottom left corner
     71E6 0801 
0139 71E8 1C4F                   byte 28,79,9,1         ; Bottom right corner
     71EA 0901 
0140 71EC FFFF                   data EOL
0141                       ;------------------------------------------------------
0142                       ; Exit task
0143                       ;------------------------------------------------------
0144               task.vdp.panes.exit:
0145 71EE 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     71F0 729C 
0146 71F2 0460  28         b     @slotok
     71F4 2CF4 
**** **** ****     > tivi_b1.asm.8885
0056                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: TiVi Editor - VDP copy SAT
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
0010               ********|*****|*********************|**************************
0011               task.vdp.copy.sat:
0012 71F6 C120  34         mov   @tv.pane.focus,tmp0
     71F8 A016 
0013 71FA 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 71FC 0284  22         ci    tmp0,pane.focus.cmdb
     71FE 0001 
0016 7200 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 7202 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7204 FFCE 
0022 7206 06A0  32         bl    @cpu.crash            ; / Halt system.
     7208 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 720A C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     720C A308 
     720E 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7210 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     7212 202A 
0032 7214 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7216 266E 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7218 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     721A 8380 
0036               
0037 721C 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     721E 2416 
0038 7220 2000                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7222 8380 
     7224 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7226 0460  28         b     @slotok               ; Exit task
     7228 2CF4 
**** **** ****     > tivi_b1.asm.8885
0057                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: TiVi Editor - VDP sprite cursor
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        TiVi Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Update cursor shape (blink)
0010               ***************************************************************
0011               task.vdp.cursor:
0012 722A 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     722C A112 
0013 722E 1303  14         jeq   task.vdp.cursor.visible
0014 7230 04E0  34         clr   @ramsat+2              ; Hide cursor
     7232 8382 
0015 7234 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7236 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7238 A20A 
0019 723A 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 723C C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     723E A016 
0025 7240 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 7242 0284  22         ci    tmp0,pane.focus.cmdb
     7244 0001 
0028 7246 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 7248 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 724A 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 724C 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     724E 0100 
0040 7250 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 7252 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7254 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7256 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7258 A014 
0051 725A C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     725C A014 
     725E 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7260 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7262 2416 
0057 7264 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     7266 8380 
     7268 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 726A 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     726C 729C 
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               task.vdp.cursor.exit:
0068 726E 0460  28         b     @slotok                ; Exit task
     7270 2CF4 
**** **** ****     > tivi_b1.asm.8885
0058                       copy  "pane.topline.asm"    ; Pane banner top line
**** **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: TiVi Editor - Pane top line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Pane top line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.topline.draw
0010               * Draw TiVi status top line
0011               ***************************************************************
0012               * bl  @pane.topline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.topline.draw:
0021 7272 0649  14         dect  stack
0022 7274 C64B  30         mov   r11,*stack            ; Save return address
0023 7276 C820  54         mov   @wyx,@fb.yxsave
     7278 832A 
     727A A114 
0024                       ;------------------------------------------------------
0025                       ; Show banner (line above frame buffer, not part of it)
0026                       ;------------------------------------------------------
0027 727C 06A0  32         bl    @hchar
     727E 2740 
0028 7280 0000                   byte 0,0,1,34         ; Double line at top (left)
     7282 0122 
0029 7284 002E                   byte 0,46,1,34        ; Double line at top (right)
     7286 0122 
0030 7288 FFFF                   data EOL
0031               
0032 728A 06A0  32         bl    @putat
     728C 240E 
0033 728E 0022                   byte 0,34
0034 7290 74E4                   data txt.tivi         ; TiVi banner (middle)
0035                       ;------------------------------------------------------
0036                       ; Exit
0037                       ;------------------------------------------------------
0038               pane.topline.exit:
0039 7292 C820  54         mov   @fb.yxsave,@wyx
     7294 A114 
     7296 832A 
0040 7298 C2F9  30         mov   *stack+,r11           ; Pop r11
0041 729A 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.8885
0059                       copy  "pane.botline.asm"    ; Pane status bottom line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: TiVi Editor - Pane status bottom line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              TiVi Editor - Pane status bottom line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.botline.draw
0010               * Draw TiVi status bottom line
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
0021 729C 0649  14         dect  stack
0022 729E C64B  30         mov   r11,*stack            ; Save return address
0023 72A0 0649  14         dect  stack
0024 72A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 72A4 C820  54         mov   @wyx,@fb.yxsave
     72A6 832A 
     72A8 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 72AA 06A0  32         bl    @putat
     72AC 240E 
0032 72AE 1D00                   byte  29,0
0033 72B0 7488                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 72B2 06A0  32         bl    @at
     72B4 264C 
0039 72B6 1D03                   byte  29,3            ; Position cursor
0040 72B8 C160  34         mov   @edb.filename.ptr,tmp1
     72BA A20E 
0041                                                   ; Get string to display
0042 72BC 06A0  32         bl    @xutst0               ; Display string
     72BE 23FE 
0043               
0044 72C0 06A0  32         bl    @at
     72C2 264C 
0045 72C4 1D23                   byte  29,35           ; Position cursor
0046               
0047 72C6 C160  34         mov   @edb.filetype.ptr,tmp1
     72C8 A210 
0048                                                   ; Get string to display
0049 72CA 06A0  32         bl    @xutst0               ; Display Filetype string
     72CC 23FE 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 72CE C120  34         mov   @edb.insmode,tmp0
     72D0 A20A 
0055 72D2 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 72D4 06A0  32         bl    @putat
     72D6 240E 
0061 72D8 1D32                   byte  29,50
0062 72DA 743A                   data  txt.ovrwrite
0063 72DC 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 72DE 06A0  32         bl    @putat
     72E0 240E 
0069 72E2 1D32                   byte  29,50
0070 72E4 743E                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 72E6 C120  34         mov   @edb.dirty,tmp0
     72E8 A206 
0076 72EA 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 72EC 06A0  32         bl    @putat
     72EE 240E 
0081 72F0 1D36                   byte 29,54
0082 72F2 7442                   data txt.star
0083 72F4 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 72F6 1000  14         nop
0089               pane.botline.show_linecol:
0090 72F8 C820  54         mov   @fb.row,@parm1
     72FA A106 
     72FC 8350 
0091 72FE 06A0  32         bl    @fb.row2line
     7300 67CA 
0092 7302 05A0  34         inc   @outparm1
     7304 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7306 06A0  32         bl    @putnum
     7308 2A1C 
0097 730A 1D40                   byte  29,64           ; YX
0098 730C 8360                   data  outparm1,rambuf
     730E 8390 
0099 7310 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7312 06A0  32         bl    @putat
     7314 240E 
0105 7316 1D45                   byte  29,69
0106 7318 742C                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 731A 06A0  32         bl    @film
     731C 2214 
0111 731E 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     7320 0020 
     7322 000C 
0112               
0113 7324 C820  54         mov   @fb.column,@waux1
     7326 A10C 
     7328 833C 
0114 732A 05A0  34         inc   @waux1                ; Offset 1
     732C 833C 
0115               
0116 732E 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7330 299E 
0117 7332 833C                   data  waux1,rambuf
     7334 8390 
0118 7336 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 7338 06A0  32         bl    @trimnum              ; Trim number to the left
     733A 29F6 
0122 733C 8390                   data  rambuf,rambuf+6,32
     733E 8396 
     7340 0020 
0123               
0124 7342 0204  20         li    tmp0,>0200
     7344 0200 
0125 7346 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7348 8396 
0126               
0127 734A 06A0  32         bl    @putat
     734C 240E 
0128 734E 1D46                   byte 29,70
0129 7350 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7352 C820  54         mov   @fb.row,@parm1
     7354 A106 
     7356 8350 
0134 7358 06A0  32         bl    @fb.row2line
     735A 67CA 
0135 735C 8820  54         c     @edb.lines,@outparm1
     735E A204 
     7360 8360 
0136 7362 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 7364 06A0  32         bl    @putat
     7366 240E 
0139 7368 1D4B                   byte 29,75
0140 736A 7434                   data txt.bottom
0141               
0142 736C 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 736E C820  54         mov   @edb.lines,@waux1
     7370 A204 
     7372 833C 
0148 7374 05A0  34         inc   @waux1                ; Offset 1
     7376 833C 
0149 7378 06A0  32         bl    @putnum
     737A 2A1C 
0150 737C 1D4B                   byte 29,75            ; YX
0151 737E 833C                   data waux1,rambuf
     7380 8390 
0152 7382 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 7384 C820  54         mov   @fb.yxsave,@wyx
     7386 A114 
     7388 832A 
0159 738A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 738C C2F9  30         mov   *stack+,r11           ; Pop r11
0161 738E 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.8885
0060                       copy  "data.constants.asm"  ; Data segment - Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: TiVi Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               romsat:
0008 7390 0303             data  >0303,>000f           ; Cursor YX, initial shape and colour
     7392 000F 
0009               
0010               cursors:
0011 7394 0000             data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     7396 0000 
     7398 0000 
     739A 001C 
0012 739C 1010             data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     739E 1010 
     73A0 1010 
     73A2 1000 
0013 73A4 1C1C             data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     73A6 1C1C 
     73A8 1C1C 
     73AA 1C00 
0014               
0015               patterns:
0016 73AC 0000             data >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
     73AE FF00 
     73B0 00FF 
     73B2 0080 
0017 73B4 0080             data >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     73B6 0000 
     73B8 FF00 
     73BA FF00 
0018               patterns.box:
0019 73BC 0000             data >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     73BE 0000 
     73C0 FF00 
     73C2 FF00 
0020 73C4 0000             data >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     73C6 0000 
     73C8 FF80 
     73CA BFA0 
0021 73CC 0000             data >0000,>0000,>fc04,>f414 ; 05. Top right corner
     73CE 0000 
     73D0 FC04 
     73D2 F414 
0022 73D4 A0A0             data >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     73D6 A0A0 
     73D8 A0A0 
     73DA A0A0 
0023 73DC 1414             data >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     73DE 1414 
     73E0 1414 
     73E2 1414 
0024 73E4 A0A0             data >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     73E6 A0A0 
     73E8 BF80 
     73EA FF00 
0025 73EC 1414             data >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     73EE 1414 
     73F0 F404 
     73F2 FC00 
0026 73F4 0000             data >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     73F6 C0C0 
     73F8 C0C0 
     73FA 0080 
0027 73FC 0000             data >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     73FE 0F0F 
     7400 0F0F 
     7402 0000 
0028               
0029               
0030               tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
0031 7404 F404             data  >f404                 ; White      | Dark blue  | Dark blue
0032 7406 F101             data  >f101                 ; White      | Black      | Black
0033 7408 1707             data  >1707                 ; Black      | Cyan       | Cyan
0034 740A 1F0F             data  >1f0f                 ; Black      | White      | White
0035               
0036               
0037               ***************************************************************
0038               * SAMS page layout table for TiVi (16 words)
0039               *--------------------------------------------------------------
0040               mem.sams.layout.data:
0041 740C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     740E 0002 
0042 7410 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7412 0003 
0043 7414 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     7416 000A 
0044 7418 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     741A 0010 
0045 741C C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     741E 0030 
0046 7420 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7422 000D 
0047 7424 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     7426 000E 
0048 7428 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     742A 000F 
**** **** ****     > tivi_b1.asm.8885
0061                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: TiVi Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 742C 012C             byte  1
0009 742D ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 742E 052A             byte  5
0014 742F ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 7434 0520             byte  5
0019 7435 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 743A 034F             byte  3
0024 743B ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 743E 0349             byte  3
0029 743F ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 7442 012A             byte  1
0034 7443 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 7444 0A4C             byte  10
0039 7445 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 7450 026B             byte  2
0044 7451 ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 7454 0352             byte  3
0049 7455 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 7458 054C             byte  5
0054 7459 ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 745E 2921             byte  41
0059 745F ....             text  '! I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 7488 0223             byte  2
0064 7489 ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 748C 0A5B             byte  10
0069 748D ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.prompt
0074 7498 013E             byte  1
0075 7499 ....             text  '>'
0076                       even
0077               
0078               txt.cmdb.hint
0079 749A 2348             byte  35
0080 749B ....             text  'Hint: Type "help" for command list.'
0081                       even
0082               
0083               txt.cmdb.catalog
0084 74BE 0C46             byte  12
0085 74BF ....             text  'File catalog'
0086                       even
0087               
0088               
0089               
0090               txt.filetype.dv80
0091 74CC 0A44             byte  10
0092 74CD ....             text  'DIS/VAR80 '
0093                       even
0094               
0095               txt.filetype.none
0096 74D8 0A20             byte  10
0097 74D9 ....             text  '          '
0098                       even
0099               
0100               
0101 74E4 0C0A     txt.tivi     byte    12
0102                            byte    10
0103 74E6 ....                  text    'TiVi v1.00'
0104 74F0 0B00                  byte    11
0105                            even
0106               
0107               fdname1
0108 74F2 0E44             byte  14
0109 74F3 ....             text  'DSK1.TMS9900_C'
0110                       even
0111               
0112               fdname2
0113 7502 0944             byte  9
0114 7503 ....             text  'DSK1.NR80'
0115                       even
0116               
0117               fdname3
0118 750C 0C44             byte  12
0119 750D ....             text  'DSK5.XBEADOC'
0120                       even
0121               
0122               fdname4
0123 751A 0C44             byte  12
0124 751B ....             text  'DSK5.C99MAN1'
0125                       even
0126               
0127               fdname5
0128 7528 0C44             byte  12
0129 7529 ....             text  'DSK5.C99MAN2'
0130                       even
0131               
0132               fdname6
0133 7536 0C44             byte  12
0134 7537 ....             text  'DSK5.C99MAN3'
0135                       even
0136               
0137               fdname7
0138 7544 0D44             byte  13
0139 7545 ....             text  'DSK5.C99SPECS'
0140                       even
0141               
0142               fdname8
0143 7552 0D44             byte  13
0144 7553 ....             text  'DSK5.RANDOM#C'
0145                       even
0146               
0147               fdname9
0148 7560 0D44             byte  13
0149 7561 ....             text  'DSK5.INVADERS'
0150                       even
0151               
0152               fdname0
0153 756E 0944             byte  9
0154 756F ....             text  'DSK5.NR80'
0155                       even
0156               
0157               
0158               
0159               *---------------------------------------------------------------
0160               * Keyboard labels - Function keys
0161               *---------------------------------------------------------------
0162               txt.fctn.0
0163 7578 0866             byte  8
0164 7579 ....             text  'fctn + 0'
0165                       even
0166               
0167               txt.fctn.1
0168 7582 0866             byte  8
0169 7583 ....             text  'fctn + 1'
0170                       even
0171               
0172               txt.fctn.2
0173 758C 0866             byte  8
0174 758D ....             text  'fctn + 2'
0175                       even
0176               
0177               txt.fctn.3
0178 7596 0866             byte  8
0179 7597 ....             text  'fctn + 3'
0180                       even
0181               
0182               txt.fctn.4
0183 75A0 0866             byte  8
0184 75A1 ....             text  'fctn + 4'
0185                       even
0186               
0187               txt.fctn.5
0188 75AA 0866             byte  8
0189 75AB ....             text  'fctn + 5'
0190                       even
0191               
0192               txt.fctn.6
0193 75B4 0866             byte  8
0194 75B5 ....             text  'fctn + 6'
0195                       even
0196               
0197               txt.fctn.7
0198 75BE 0866             byte  8
0199 75BF ....             text  'fctn + 7'
0200                       even
0201               
0202               txt.fctn.8
0203 75C8 0866             byte  8
0204 75C9 ....             text  'fctn + 8'
0205                       even
0206               
0207               txt.fctn.9
0208 75D2 0866             byte  8
0209 75D3 ....             text  'fctn + 9'
0210                       even
0211               
0212               txt.fctn.a
0213 75DC 0866             byte  8
0214 75DD ....             text  'fctn + a'
0215                       even
0216               
0217               txt.fctn.b
0218 75E6 0866             byte  8
0219 75E7 ....             text  'fctn + b'
0220                       even
0221               
0222               txt.fctn.c
0223 75F0 0866             byte  8
0224 75F1 ....             text  'fctn + c'
0225                       even
0226               
0227               txt.fctn.d
0228 75FA 0866             byte  8
0229 75FB ....             text  'fctn + d'
0230                       even
0231               
0232               txt.fctn.e
0233 7604 0866             byte  8
0234 7605 ....             text  'fctn + e'
0235                       even
0236               
0237               txt.fctn.f
0238 760E 0866             byte  8
0239 760F ....             text  'fctn + f'
0240                       even
0241               
0242               txt.fctn.g
0243 7618 0866             byte  8
0244 7619 ....             text  'fctn + g'
0245                       even
0246               
0247               txt.fctn.h
0248 7622 0866             byte  8
0249 7623 ....             text  'fctn + h'
0250                       even
0251               
0252               txt.fctn.i
0253 762C 0866             byte  8
0254 762D ....             text  'fctn + i'
0255                       even
0256               
0257               txt.fctn.j
0258 7636 0866             byte  8
0259 7637 ....             text  'fctn + j'
0260                       even
0261               
0262               txt.fctn.k
0263 7640 0866             byte  8
0264 7641 ....             text  'fctn + k'
0265                       even
0266               
0267               txt.fctn.l
0268 764A 0866             byte  8
0269 764B ....             text  'fctn + l'
0270                       even
0271               
0272               txt.fctn.m
0273 7654 0866             byte  8
0274 7655 ....             text  'fctn + m'
0275                       even
0276               
0277               txt.fctn.n
0278 765E 0866             byte  8
0279 765F ....             text  'fctn + n'
0280                       even
0281               
0282               txt.fctn.o
0283 7668 0866             byte  8
0284 7669 ....             text  'fctn + o'
0285                       even
0286               
0287               txt.fctn.p
0288 7672 0866             byte  8
0289 7673 ....             text  'fctn + p'
0290                       even
0291               
0292               txt.fctn.q
0293 767C 0866             byte  8
0294 767D ....             text  'fctn + q'
0295                       even
0296               
0297               txt.fctn.r
0298 7686 0866             byte  8
0299 7687 ....             text  'fctn + r'
0300                       even
0301               
0302               txt.fctn.s
0303 7690 0866             byte  8
0304 7691 ....             text  'fctn + s'
0305                       even
0306               
0307               txt.fctn.t
0308 769A 0866             byte  8
0309 769B ....             text  'fctn + t'
0310                       even
0311               
0312               txt.fctn.u
0313 76A4 0866             byte  8
0314 76A5 ....             text  'fctn + u'
0315                       even
0316               
0317               txt.fctn.v
0318 76AE 0866             byte  8
0319 76AF ....             text  'fctn + v'
0320                       even
0321               
0322               txt.fctn.w
0323 76B8 0866             byte  8
0324 76B9 ....             text  'fctn + w'
0325                       even
0326               
0327               txt.fctn.x
0328 76C2 0866             byte  8
0329 76C3 ....             text  'fctn + x'
0330                       even
0331               
0332               txt.fctn.y
0333 76CC 0866             byte  8
0334 76CD ....             text  'fctn + y'
0335                       even
0336               
0337               txt.fctn.z
0338 76D6 0866             byte  8
0339 76D7 ....             text  'fctn + z'
0340                       even
0341               
0342               *---------------------------------------------------------------
0343               * Keyboard labels - Function keys extra
0344               *---------------------------------------------------------------
0345               txt.fctn.dot
0346 76E0 0866             byte  8
0347 76E1 ....             text  'fctn + .'
0348                       even
0349               
0350               txt.fctn.plus
0351 76EA 0866             byte  8
0352 76EB ....             text  'fctn + +'
0353                       even
0354               
0355               *---------------------------------------------------------------
0356               * Keyboard labels - Control keys
0357               *---------------------------------------------------------------
0358               txt.ctrl.0
0359 76F4 0863             byte  8
0360 76F5 ....             text  'ctrl + 0'
0361                       even
0362               
0363               txt.ctrl.1
0364 76FE 0863             byte  8
0365 76FF ....             text  'ctrl + 1'
0366                       even
0367               
0368               txt.ctrl.2
0369 7708 0863             byte  8
0370 7709 ....             text  'ctrl + 2'
0371                       even
0372               
0373               txt.ctrl.3
0374 7712 0863             byte  8
0375 7713 ....             text  'ctrl + 3'
0376                       even
0377               
0378               txt.ctrl.4
0379 771C 0863             byte  8
0380 771D ....             text  'ctrl + 4'
0381                       even
0382               
0383               txt.ctrl.5
0384 7726 0863             byte  8
0385 7727 ....             text  'ctrl + 5'
0386                       even
0387               
0388               txt.ctrl.6
0389 7730 0863             byte  8
0390 7731 ....             text  'ctrl + 6'
0391                       even
0392               
0393               txt.ctrl.7
0394 773A 0863             byte  8
0395 773B ....             text  'ctrl + 7'
0396                       even
0397               
0398               txt.ctrl.8
0399 7744 0863             byte  8
0400 7745 ....             text  'ctrl + 8'
0401                       even
0402               
0403               txt.ctrl.9
0404 774E 0863             byte  8
0405 774F ....             text  'ctrl + 9'
0406                       even
0407               
0408               txt.ctrl.a
0409 7758 0863             byte  8
0410 7759 ....             text  'ctrl + a'
0411                       even
0412               
0413               txt.ctrl.b
0414 7762 0863             byte  8
0415 7763 ....             text  'ctrl + b'
0416                       even
0417               
0418               txt.ctrl.c
0419 776C 0863             byte  8
0420 776D ....             text  'ctrl + c'
0421                       even
0422               
0423               txt.ctrl.d
0424 7776 0863             byte  8
0425 7777 ....             text  'ctrl + d'
0426                       even
0427               
0428               txt.ctrl.e
0429 7780 0863             byte  8
0430 7781 ....             text  'ctrl + e'
0431                       even
0432               
0433               txt.ctrl.f
0434 778A 0863             byte  8
0435 778B ....             text  'ctrl + f'
0436                       even
0437               
0438               txt.ctrl.g
0439 7794 0863             byte  8
0440 7795 ....             text  'ctrl + g'
0441                       even
0442               
0443               txt.ctrl.h
0444 779E 0863             byte  8
0445 779F ....             text  'ctrl + h'
0446                       even
0447               
0448               txt.ctrl.i
0449 77A8 0863             byte  8
0450 77A9 ....             text  'ctrl + i'
0451                       even
0452               
0453               txt.ctrl.j
0454 77B2 0863             byte  8
0455 77B3 ....             text  'ctrl + j'
0456                       even
0457               
0458               txt.ctrl.k
0459 77BC 0863             byte  8
0460 77BD ....             text  'ctrl + k'
0461                       even
0462               
0463               txt.ctrl.l
0464 77C6 0863             byte  8
0465 77C7 ....             text  'ctrl + l'
0466                       even
0467               
0468               txt.ctrl.m
0469 77D0 0863             byte  8
0470 77D1 ....             text  'ctrl + m'
0471                       even
0472               
0473               txt.ctrl.n
0474 77DA 0863             byte  8
0475 77DB ....             text  'ctrl + n'
0476                       even
0477               
0478               txt.ctrl.o
0479 77E4 0863             byte  8
0480 77E5 ....             text  'ctrl + o'
0481                       even
0482               
0483               txt.ctrl.p
0484 77EE 0863             byte  8
0485 77EF ....             text  'ctrl + p'
0486                       even
0487               
0488               txt.ctrl.q
0489 77F8 0863             byte  8
0490 77F9 ....             text  'ctrl + q'
0491                       even
0492               
0493               txt.ctrl.r
0494 7802 0863             byte  8
0495 7803 ....             text  'ctrl + r'
0496                       even
0497               
0498               txt.ctrl.s
0499 780C 0863             byte  8
0500 780D ....             text  'ctrl + s'
0501                       even
0502               
0503               txt.ctrl.t
0504 7816 0863             byte  8
0505 7817 ....             text  'ctrl + t'
0506                       even
0507               
0508               txt.ctrl.u
0509 7820 0863             byte  8
0510 7821 ....             text  'ctrl + u'
0511                       even
0512               
0513               txt.ctrl.v
0514 782A 0863             byte  8
0515 782B ....             text  'ctrl + v'
0516                       even
0517               
0518               txt.ctrl.w
0519 7834 0863             byte  8
0520 7835 ....             text  'ctrl + w'
0521                       even
0522               
0523               txt.ctrl.x
0524 783E 0863             byte  8
0525 783F ....             text  'ctrl + x'
0526                       even
0527               
0528               txt.ctrl.y
0529 7848 0863             byte  8
0530 7849 ....             text  'ctrl + y'
0531                       even
0532               
0533               txt.ctrl.z
0534 7852 0863             byte  8
0535 7853 ....             text  'ctrl + z'
0536                       even
0537               
0538               *---------------------------------------------------------------
0539               * Keyboard labels - control keys extra
0540               *---------------------------------------------------------------
0541               txt.ctrl.plus
0542 785C 0863             byte  8
0543 785D ....             text  'ctrl + +'
0544                       even
0545               
0546               *---------------------------------------------------------------
0547               * Special keys
0548               *---------------------------------------------------------------
0549               txt.enter
0550 7866 0565             byte  5
0551 7867 ....             text  'enter'
0552                       even
0553               
**** **** ****     > tivi_b1.asm.8885
0062                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: TiVi Editor - data segment (keyboard mapping)
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
0105 786C 0D00             data  key.enter, txt.enter, edkey.action.enter
     786E 7866 
     7870 6568 
0106 7872 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7874 7690 
     7876 615E 
0107 7878 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     787A 75FA 
     787C 6174 
0108 787E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7880 7604 
     7882 618C 
0109 7884 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7886 76C2 
     7888 61DE 
0110 788A 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     788C 7758 
     788E 624A 
0111 7890 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7892 778A 
     7894 6262 
0112 7896 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7898 780C 
     789A 6276 
0113 789C 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     789E 7776 
     78A0 62C8 
0114 78A2 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     78A4 7780 
     78A6 6328 
0115 78A8 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     78AA 783E 
     78AC 636E 
0116 78AE 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     78B0 7816 
     78B2 639A 
0117 78B4 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     78B6 7762 
     78B8 63CA 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 78BA 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     78BC 7582 
     78BE 640A 
0122 78C0 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     78C2 77BC 
     78C4 6442 
0123 78C6 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     78C8 7596 
     78CA 6476 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 78CC 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     78CE 758C 
     78D0 64CE 
0128 78D2 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     78D4 76E0 
     78D6 65D6 
0129 78D8 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     78DA 75AA 
     78DC 6524 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 78DE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     78E0 76EA 
     78E2 6626 
0134 78E4 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     78E6 75D2 
     78E8 6632 
0135 78EA 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     78EC 7852 
     78EE 6650 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 78F0 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     78F2 76F4 
     78F4 6692 
0140 78F6 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     78F8 76FE 
     78FA 6698 
0141 78FC B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     78FE 7708 
     7900 669E 
0142 7902 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7904 7712 
     7906 66A4 
0143 7908 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     790A 771C 
     790C 66AA 
0144 790E B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7910 7726 
     7912 66B0 
0145 7914 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7916 7730 
     7918 66B6 
0146 791A B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     791C 773A 
     791E 66BC 
0147 7920 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7922 7744 
     7924 66C2 
0148 7926 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7928 774E 
     792A 66C8 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 792C FFFF             data  EOL                           ; EOL
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
0164 792E 0D00             data  key.enter, txt.enter, edkey.action.enter
     7930 7866 
     7932 6568 
0165 7934 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7936 7690 
     7938 615E 
0166 793A 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     793C 75FA 
     793E 6174 
0167 7940 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     7942 7604 
     7944 662E 
0168 7946 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     7948 76C2 
     794A 662E 
0169 794C 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
     794E 7758 
     7950 662E 
0170 7952 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
     7954 778A 
     7956 662E 
0171 7958 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     795A 780C 
     795C 662E 
0172 795E 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     7960 7776 
     7962 662E 
0173 7964 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     7966 7780 
     7968 662E 
0174 796A 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     796C 783E 
     796E 662E 
0175 7970 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     7972 7816 
     7974 662E 
0176 7976 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     7978 7762 
     797A 662E 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 797C 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     797E 7582 
     7980 640A 
0181 7982 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7984 77BC 
     7986 6442 
0182 7988 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     798A 7596 
     798C 662E 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 798E 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7990 758C 
     7992 64CE 
0187 7994 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7996 76E0 
     7998 65D6 
0188 799A 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     799C 75AA 
     799E 662E 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 79A0 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     79A2 76EA 
     79A4 6626 
0193 79A6 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     79A8 75D2 
     79AA 6632 
0194 79AC 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     79AE 7852 
     79B0 6650 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 79B2 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     79B4 76F4 
     79B6 6692 
0199 79B8 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     79BA 76FE 
     79BC 6698 
0200 79BE B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     79C0 7708 
     79C2 669E 
0201 79C4 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     79C6 7712 
     79C8 66A4 
0202 79CA B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     79CC 771C 
     79CE 66AA 
0203 79D0 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     79D2 7726 
     79D4 66B0 
0204 79D6 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     79D8 7730 
     79DA 66B6 
0205 79DC B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     79DE 773A 
     79E0 66BC 
0206 79E2 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     79E4 7744 
     79E6 66C2 
0207 79E8 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     79EA 774E 
     79EC 66C8 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 79EE FFFF             data  EOL                           ; EOL
**** **** ****     > tivi_b1.asm.8885
0063               
0067 79F0 79F0                   data $                ; Bank 1 ROM size OK.
0069               
0070               *--------------------------------------------------------------
0071               * Video mode configuration
0072               *--------------------------------------------------------------
0073      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0074      0004     spfbck  equ   >04                   ; Screen background color.
0075      21F4     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0076      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0077      0050     colrow  equ   80                    ; Columns per row
0078      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0079      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0080      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0081      2000     sprsat  equ   >2000                 ; VDP sprite attribute table

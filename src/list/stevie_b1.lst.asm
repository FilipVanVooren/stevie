XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.158774
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200525-158774
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
0009               * File: equates.asm                 ; Version 200525-158774
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
0039               * a000-a0ff     256           stevie Editor shared structure
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
0137      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color
0138      A016     tv.pane.focus     equ  tv.top + 22     ; Identify pane that has focus
0139      A016     tv.end            equ  tv.top + 22     ; End of structure
0140      0000     pane.focus.fb     equ  0               ; Editor pane has focus
0141      0001     pane.focus.cmdb   equ  1               ; Command buffer pane has focus
0142               *--------------------------------------------------------------
0143               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0144               *--------------------------------------------------------------
0145      A100     fb.struct         equ  >a100           ; Structure begin
0146      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0147      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0148      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0149                                                      ; line X in editor buffer).
0150      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0151                                                      ; (offset 0 .. @fb.scrrows)
0152      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0153      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0154      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0155      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0156      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0157      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0158      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0159      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0160      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0161      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0162      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0163               *--------------------------------------------------------------
0164               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0165               *--------------------------------------------------------------
0166      A200     edb.struct        equ  >a200           ; Begin structure
0167      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0168      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0169      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0170      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0171      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0172      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0173      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0174      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0175                                                      ; with current filename.
0176      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0177                                                      ; with current file type.
0178      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0179      A214     edb.end           equ  edb.struct + 20 ; End of structure
0180               *--------------------------------------------------------------
0181               * Command buffer structure          @>a300-a3ff     (256 bytes)
0182               *--------------------------------------------------------------
0183      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0184      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer
0185      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0186      A304     cmdb.scrrows      equ  cmdb.struct + 4 ; Current size of cmdb pane (in rows)
0187      A306     cmdb.default      equ  cmdb.struct + 6 ; Default size of cmdb pane (in rows)
0188      A308     cmdb.cursor       equ  cmdb.struct + 8 ; Screen YX of cursor in cmdb pane
0189      A30A     cmdb.yxsave       equ  cmdb.struct + 10; Copy of WYX
0190      A30C     cmdb.yxtop        equ  cmdb.struct + 12; YX position of first row in cmdb pane
0191      A30E     cmdb.lines        equ  cmdb.struct + 14; Total lines in editor buffer
0192      A310     cmdb.dirty        equ  cmdb.struct + 16; Editor buffer dirty (Text changed!)
0193      A312     cmdb.fb.yxsave    equ  cmdb.struct + 18; Copy of FB WYX when entering cmdb pane
0194      A314     cmdb.end          equ  cmdb.struct + 20; End of structure
0195               *--------------------------------------------------------------
0196               * File handle structure             @>a400-a4ff     (256 bytes)
0197               *--------------------------------------------------------------
0198      A400     fh.struct         equ  >a400           ; stevie file handling structures
0199      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0200      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0201      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0202      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0203      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0204      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0205      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0206      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0207      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0208      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0209      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0210      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0211      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0212      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0213      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0214      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0215      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0216      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0217      A496     fh.end            equ  fh.struct +150  ; End of structure
0218      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0219      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0220               *--------------------------------------------------------------
0221               * Index structure                   @>a500-a5ff     (256 bytes)
0222               *--------------------------------------------------------------
0223      A500     idx.struct        equ  >a500           ; stevie index structure
0224      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0225      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0226      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0227               *--------------------------------------------------------------
0228               * Frame buffer                      @>a600-afff    (2560 bytes)
0229               *--------------------------------------------------------------
0230      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0231      0960     fb.size           equ  80*30           ; Frame buffer size
0232               *--------------------------------------------------------------
0233               * Index                             @>b000-bfff    (4096 bytes)
0234               *--------------------------------------------------------------
0235      B000     idx.top           equ  >b000           ; Top of index
0236      1000     idx.size          equ  4096            ; Index size
0237               *--------------------------------------------------------------
0238               * Editor buffer                     @>c000-cfff    (4096 bytes)
0239               *--------------------------------------------------------------
0240      C000     edb.top           equ  >c000           ; Editor buffer high memory
0241      1000     edb.size          equ  4096            ; Editor buffer size
0242               *--------------------------------------------------------------
0243               * Command buffer                    @>d000-dfff    (4096 bytes)
0244               *--------------------------------------------------------------
0245      D000     cmdb.top          equ  >d000           ; Top of command buffer
0246      1000     cmdb.size         equ  4096            ; Command buffer size
0247               *--------------------------------------------------------------
0248               * *** FREE ***                      @>f000-ffff    (4096 bytes)
0249               *--------------------------------------------------------------
**** **** ****     > stevie_b1.asm.158774
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
0031 6015 ....             text  'STEVIE 200525-158774'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.158774
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
     208E 2D6A 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @putat                ; Show crash message
     2092 2412 
0078 2094 0000                   data >0000,cpu.crash.msg.crashed
     2096 216A 
0079               
0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
     209A 2998 
0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 20A4 06A0  32         bl    @putat                ; Show caller message
     20A6 2412 
0090 20A8 0100                   data >0100,cpu.crash.msg.caller
     20AA 2180 
0091               
0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
     20AE 2998 
0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 20B8 06A0  32         bl    @putat
     20BA 2412 
0102 20BC 0300                   byte 3,0
0103 20BE 219A                   data cpu.crash.msg.wp
0104 20C0 06A0  32         bl    @putat
     20C2 2412 
0105 20C4 0400                   byte 4,0
0106 20C6 21A0                   data cpu.crash.msg.st
0107 20C8 06A0  32         bl    @putat
     20CA 2412 
0108 20CC 1600                   byte 22,0
0109 20CE 21A6                   data cpu.crash.msg.source
0110 20D0 06A0  32         bl    @putat
     20D2 2412 
0111 20D4 1700                   byte 23,0
0112 20D6 21C2                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
     20DA 2650 
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
     20FE 29A2 
0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
     2108 2666 
0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     210E 2400 
0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
     2114 2666 
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
     2124 2400 
0165 2126 2196                   data cpu.crash.msg.r
0166               
0167 2128 06A0  32         bl    @mknum
     212A 29A2 
0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
     2134 2914 
0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
     213E 2666 
0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 2142 06A0  32         bl    @putstr
     2144 2400 
0187 2146 2198                   data cpu.crash.msg.marker
0188               
0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
     214A 2666 
0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2150 2400 
0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 215A 06A0  32         bl    @down                 ; y=y+1
     215C 2656 
0202               
0203 215E 0586  14         inc   tmp2
0204 2160 0286  22         ci    tmp2,17
     2162 0011 
0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2168 2C78 
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
0243 21A6 1B53             byte  27
0244 21A7 ....             text  'Source    stevie_b1.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 21C2 1742             byte  23
0249 21C3 ....             text  'Build-ID  200525-158774'
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
0007 21DA 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21DC 000E 
     21DE 0106 
     21E0 0204 
     21E2 0020 
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
0032 21E4 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21E6 000E 
     21E8 0106 
     21EA 00F4 
     21EC 0028 
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
0058 21EE 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21F0 003F 
     21F2 0240 
     21F4 03F4 
     21F6 0050 
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
0084 21F8 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21FA 003F 
     21FC 0240 
     21FE 03F4 
     2200 0050 
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
0013 2202 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2204 16FD             data  >16fd                 ; |         jne   mcloop
0015 2206 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2208 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 220A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 220C C0F9  30 popr3   mov   *stack+,r3
0039 220E C0B9  30 popr2   mov   *stack+,r2
0040 2210 C079  30 popr1   mov   *stack+,r1
0041 2212 C039  30 popr0   mov   *stack+,r0
0042 2214 C2F9  30 poprt   mov   *stack+,r11
0043 2216 045B  20         b     *r11
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
0067 2218 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 221A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 221C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 221E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 2220 1604  14         jne   filchk                ; No, continue checking
0075               
0076 2222 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2224 FFCE 
0077 2226 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2228 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 222A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     222C 830B 
     222E 830A 
0082               
0083 2230 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2232 0001 
0084 2234 1602  14         jne   filchk2
0085 2236 DD05  32         movb  tmp1,*tmp0+
0086 2238 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 223A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     223C 0002 
0091 223E 1603  14         jne   filchk3
0092 2240 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 2242 DD05  32         movb  tmp1,*tmp0+
0094 2244 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 2246 C1C4  18 filchk3 mov   tmp0,tmp3
0099 2248 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     224A 0001 
0100 224C 1605  14         jne   fil16b
0101 224E DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 2250 0606  14         dec   tmp2
0103 2252 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2254 0002 
0104 2256 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2258 C1C6  18 fil16b  mov   tmp2,tmp3
0109 225A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     225C 0001 
0110 225E 1301  14         jeq   dofill
0111 2260 0606  14         dec   tmp2                  ; Make TMP2 even
0112 2262 CD05  34 dofill  mov   tmp1,*tmp0+
0113 2264 0646  14         dect  tmp2
0114 2266 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2268 C1C7  18         mov   tmp3,tmp3
0119 226A 1301  14         jeq   fil.$$
0120 226C DD05  32         movb  tmp1,*tmp0+
0121 226E 045B  20 fil.$$  b     *r11
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
0140 2270 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 2272 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 2274 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 2276 0264  22 xfilv   ori   tmp0,>4000
     2278 4000 
0147 227A 06C4  14         swpb  tmp0
0148 227C D804  38         movb  tmp0,@vdpa
     227E 8C02 
0149 2280 06C4  14         swpb  tmp0
0150 2282 D804  38         movb  tmp0,@vdpa
     2284 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 2286 020F  20         li    r15,vdpw              ; Set VDP write address
     2288 8C00 
0155 228A 06C5  14         swpb  tmp1
0156 228C C820  54         mov   @filzz,@mcloop        ; Setup move command
     228E 2296 
     2290 8320 
0157 2292 0460  28         b     @mcloop               ; Write data to VDP
     2294 8320 
0158               *--------------------------------------------------------------
0162 2296 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 2298 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     229A 4000 
0183 229C 06C4  14 vdra    swpb  tmp0
0184 229E D804  38         movb  tmp0,@vdpa
     22A0 8C02 
0185 22A2 06C4  14         swpb  tmp0
0186 22A4 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22A6 8C02 
0187 22A8 045B  20         b     *r11                  ; Exit
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
0198 22AA C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22AC C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22AE 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22B0 4000 
0204 22B2 06C4  14         swpb  tmp0                  ; \
0205 22B4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22B6 8C02 
0206 22B8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22BA D804  38         movb  tmp0,@vdpa            ; /
     22BC 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22BE 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22C0 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22C2 045B  20         b     *r11                  ; Exit
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
0232 22C4 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22C6 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22C8 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22CA 8C02 
0238 22CC 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22CE D804  38         movb  tmp0,@vdpa            ; /
     22D0 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22D2 D120  34         movb  @vdpr,tmp0            ; Read byte
     22D4 8800 
0244 22D6 0984  56         srl   tmp0,8                ; Right align
0245 22D8 045B  20         b     *r11                  ; Exit
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
0264 22DA C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22DC C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22DE C144  18         mov   tmp0,tmp1
0270 22E0 05C5  14         inct  tmp1
0271 22E2 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22E4 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22E6 FF00 
0273 22E8 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 22EA C805  38         mov   tmp1,@wbase           ; Store calculated base
     22EC 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 22EE 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     22F0 8000 
0279 22F2 0206  20         li    tmp2,8
     22F4 0008 
0280 22F6 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     22F8 830B 
0281 22FA 06C5  14         swpb  tmp1
0282 22FC D805  38         movb  tmp1,@vdpa
     22FE 8C02 
0283 2300 06C5  14         swpb  tmp1
0284 2302 D805  38         movb  tmp1,@vdpa
     2304 8C02 
0285 2306 0225  22         ai    tmp1,>0100
     2308 0100 
0286 230A 0606  14         dec   tmp2
0287 230C 16F4  14         jne   vidta1                ; Next register
0288 230E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2310 833A 
0289 2312 045B  20         b     *r11
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
0306 2314 C13B  30 putvr   mov   *r11+,tmp0
0307 2316 0264  22 putvrx  ori   tmp0,>8000
     2318 8000 
0308 231A 06C4  14         swpb  tmp0
0309 231C D804  38         movb  tmp0,@vdpa
     231E 8C02 
0310 2320 06C4  14         swpb  tmp0
0311 2322 D804  38         movb  tmp0,@vdpa
     2324 8C02 
0312 2326 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2328 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 232A C10E  18         mov   r14,tmp0
0322 232C 0984  56         srl   tmp0,8
0323 232E 06A0  32         bl    @putvrx               ; Write VR#0
     2330 2316 
0324 2332 0204  20         li    tmp0,>0100
     2334 0100 
0325 2336 D820  54         movb  @r14lb,@tmp0lb
     2338 831D 
     233A 8309 
0326 233C 06A0  32         bl    @putvrx               ; Write VR#1
     233E 2316 
0327 2340 0458  20         b     *tmp4                 ; Exit
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
0341 2342 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 2344 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 2346 C11B  26         mov   *r11,tmp0             ; Get P0
0344 2348 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     234A 7FFF 
0345 234C 2120  38         coc   @wbit0,tmp0
     234E 202A 
0346 2350 1604  14         jne   ldfnt1
0347 2352 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2354 8000 
0348 2356 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2358 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 235A C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     235C 23C4 
0353 235E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2360 9C02 
0354 2362 06C4  14         swpb  tmp0
0355 2364 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2366 9C02 
0356 2368 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     236A 9800 
0357 236C 06C5  14         swpb  tmp1
0358 236E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2370 9800 
0359 2372 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 2374 D805  38         movb  tmp1,@grmwa
     2376 9C02 
0364 2378 06C5  14         swpb  tmp1
0365 237A D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     237C 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 237E C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 2380 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     2382 2298 
0371 2384 05C8  14         inct  tmp4                  ; R11=R11+2
0372 2386 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 2388 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     238A 7FFF 
0374 238C C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     238E 23C6 
0375 2390 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     2392 23C8 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 2394 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 2396 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 2398 D120  34         movb  @grmrd,tmp0
     239A 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 239C 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     239E 202A 
0386 23A0 1603  14         jne   ldfnt3                ; No, so skip
0387 23A2 D1C4  18         movb  tmp0,tmp3
0388 23A4 0917  56         srl   tmp3,1
0389 23A6 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23A8 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23AA 8C00 
0394 23AC 0606  14         dec   tmp2
0395 23AE 16F2  14         jne   ldfnt2
0396 23B0 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23B2 020F  20         li    r15,vdpw              ; Set VDP write address
     23B4 8C00 
0398 23B6 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23B8 7FFF 
0399 23BA 0458  20         b     *tmp4                 ; Exit
0400 23BC D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23BE 200A 
     23C0 8C00 
0401 23C2 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23C4 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23C6 0200 
     23C8 0000 
0406 23CA 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23CC 01C0 
     23CE 0101 
0407 23D0 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23D2 02A0 
     23D4 0101 
0408 23D6 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23D8 00E0 
     23DA 0101 
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
0426 23DC C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23DE C3A0  34         mov   @wyx,r14              ; Get YX
     23E0 832A 
0428 23E2 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23E4 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23E6 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 23E8 C3A0  34         mov   @wyx,r14              ; Get YX
     23EA 832A 
0435 23EC 024E  22         andi  r14,>00ff             ; Remove Y
     23EE 00FF 
0436 23F0 A3CE  18         a     r14,r15               ; pos = pos + X
0437 23F2 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     23F4 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 23F6 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 23F8 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 23FA 020F  20         li    r15,vdpw              ; VDP write address
     23FC 8C00 
0444 23FE 045B  20         b     *r11
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
0459 2400 C17B  30 putstr  mov   *r11+,tmp1
0460 2402 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 2404 C1CB  18 xutstr  mov   r11,tmp3
0462 2406 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2408 23DC 
0463 240A C2C7  18         mov   tmp3,r11
0464 240C 0986  56         srl   tmp2,8                ; Right justify length byte
0465 240E 0460  28         b     @xpym2v               ; Display string
     2410 2420 
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
0480 2412 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2414 832A 
0481 2416 0460  28         b     @putstr
     2418 2400 
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
0020 241A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 241C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 241E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 2420 0264  22 xpym2v  ori   tmp0,>4000
     2422 4000 
0027 2424 06C4  14         swpb  tmp0
0028 2426 D804  38         movb  tmp0,@vdpa
     2428 8C02 
0029 242A 06C4  14         swpb  tmp0
0030 242C D804  38         movb  tmp0,@vdpa
     242E 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 2430 020F  20         li    r15,vdpw              ; Set VDP write address
     2432 8C00 
0035 2434 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2436 243E 
     2438 8320 
0036 243A 0460  28         b     @mcloop               ; Write data to VDP
     243C 8320 
0037 243E D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 2440 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2442 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2444 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2446 06C4  14 xpyv2m  swpb  tmp0
0027 2448 D804  38         movb  tmp0,@vdpa
     244A 8C02 
0028 244C 06C4  14         swpb  tmp0
0029 244E D804  38         movb  tmp0,@vdpa
     2450 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2452 020F  20         li    r15,vdpr              ; Set VDP read address
     2454 8800 
0034 2456 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2458 2460 
     245A 8320 
0035 245C 0460  28         b     @mcloop               ; Read data from VDP
     245E 8320 
0036 2460 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 2462 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 2464 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2466 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2468 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 246A 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 246C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     246E FFCE 
0034 2470 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2472 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2474 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2476 0001 
0039 2478 1603  14         jne   cpym0                 ; No, continue checking
0040 247A DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 247C 04C6  14         clr   tmp2                  ; Reset counter
0042 247E 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 2480 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2482 7FFF 
0047 2484 C1C4  18         mov   tmp0,tmp3
0048 2486 0247  22         andi  tmp3,1
     2488 0001 
0049 248A 1618  14         jne   cpyodd                ; Odd source address handling
0050 248C C1C5  18 cpym1   mov   tmp1,tmp3
0051 248E 0247  22         andi  tmp3,1
     2490 0001 
0052 2492 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2494 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2496 202A 
0057 2498 1605  14         jne   cpym3
0058 249A C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     249C 24C2 
     249E 8320 
0059 24A0 0460  28         b     @mcloop               ; Copy memory and exit
     24A2 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24A4 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24A6 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24A8 0001 
0065 24AA 1301  14         jeq   cpym4
0066 24AC 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24AE CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24B0 0646  14         dect  tmp2
0069 24B2 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24B4 C1C7  18         mov   tmp3,tmp3
0074 24B6 1301  14         jeq   cpymz
0075 24B8 D554  38         movb  *tmp0,*tmp1
0076 24BA 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24BC 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24BE 8000 
0081 24C0 10E9  14         jmp   cpym2
0082 24C2 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 24C4 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24C6 0649  14         dect  stack
0065 24C8 C64B  30         mov   r11,*stack            ; Push return address
0066 24CA 0649  14         dect  stack
0067 24CC C640  30         mov   r0,*stack             ; Push r0
0068 24CE 0649  14         dect  stack
0069 24D0 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24D2 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24D4 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24D6 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24D8 4000 
0077 24DA C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24DC 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 24DE 020C  20         li    r12,>1e00             ; SAMS CRU address
     24E0 1E00 
0082 24E2 04C0  14         clr   r0
0083 24E4 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24E6 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 24E8 D100  18         movb  r0,tmp0
0086 24EA 0984  56         srl   tmp0,8                ; Right align
0087 24EC C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     24EE 833C 
0088 24F0 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 24F2 C339  30         mov   *stack+,r12           ; Pop r12
0094 24F4 C039  30         mov   *stack+,r0            ; Pop r0
0095 24F6 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 24F8 045B  20         b     *r11                  ; Return to caller
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
0131 24FA C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 24FC C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 24FE 0649  14         dect  stack
0135 2500 C64B  30         mov   r11,*stack            ; Push return address
0136 2502 0649  14         dect  stack
0137 2504 C640  30         mov   r0,*stack             ; Push r0
0138 2506 0649  14         dect  stack
0139 2508 C64C  30         mov   r12,*stack            ; Push r12
0140 250A 0649  14         dect  stack
0141 250C C644  30         mov   tmp0,*stack           ; Push tmp0
0142 250E 0649  14         dect  stack
0143 2510 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2512 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2514 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 2516 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2518 001E 
0153 251A 150A  14         jgt   !
0154 251C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     251E 0004 
0155 2520 1107  14         jlt   !
0156 2522 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2524 0012 
0157 2526 1508  14         jgt   sams.page.set.switch_page
0158 2528 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     252A 0006 
0159 252C 1501  14         jgt   !
0160 252E 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 2530 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2532 FFCE 
0165 2534 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2536 2030 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 2538 020C  20         li    r12,>1e00             ; SAMS CRU address
     253A 1E00 
0171 253C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 253E 06C0  14         swpb  r0                    ; LSB to MSB
0173 2540 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 2542 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2544 4000 
0175 2546 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 2548 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 254A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 254C C339  30         mov   *stack+,r12           ; Pop r12
0183 254E C039  30         mov   *stack+,r0            ; Pop r0
0184 2550 C2F9  30         mov   *stack+,r11           ; Pop return address
0185 2552 045B  20         b     *r11                  ; Return to caller
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
0199 2554 020C  20         li    r12,>1e00             ; SAMS CRU address
     2556 1E00 
0200 2558 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 255A 045B  20         b     *r11                  ; Return to caller
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
0222 255C 020C  20         li    r12,>1e00             ; SAMS CRU address
     255E 1E00 
0223 2560 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 2562 045B  20         b     *r11                  ; Return to caller
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
0255 2564 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 2566 0649  14         dect  stack
0258 2568 C64B  30         mov   r11,*stack            ; Save return address
0259 256A 0649  14         dect  stack
0260 256C C644  30         mov   tmp0,*stack           ; Save tmp0
0261 256E 0649  14         dect  stack
0262 2570 C645  30         mov   tmp1,*stack           ; Save tmp1
0263 2572 0649  14         dect  stack
0264 2574 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 2576 0649  14         dect  stack
0266 2578 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 257A 0206  20         li    tmp2,8                ; Set loop counter
     257C 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 257E C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 2580 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 2582 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2584 24FE 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 2586 0606  14         dec   tmp2                  ; Next iteration
0283 2588 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 258A 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     258C 2554 
0289                                                   ; / activating changes.
0290               
0291 258E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 2590 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 2592 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 2594 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 2596 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 2598 045B  20         b     *r11                  ; Return to caller
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
0313 259A 0649  14         dect  stack
0314 259C C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 259E 06A0  32         bl    @sams.layout
     25A0 2564 
0319 25A2 25A8                   data sams.layout.standard
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.layout.reset.exit:
0324 25A4 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 25A6 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.layout.standard:
0330 25A8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25AA 0002 
0331 25AC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25AE 0003 
0332 25B0 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25B2 000A 
0333 25B4 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25B6 000B 
0334 25B8 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25BA 000C 
0335 25BC D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25BE 000D 
0336 25C0 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25C2 000E 
0337 25C4 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25C6 000F 
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
0358 25C8 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 25CA 0649  14         dect  stack
0361 25CC C64B  30         mov   r11,*stack            ; Push return address
0362 25CE 0649  14         dect  stack
0363 25D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0364 25D2 0649  14         dect  stack
0365 25D4 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 25D6 0649  14         dect  stack
0367 25D8 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 25DA 0649  14         dect  stack
0369 25DC C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 25DE 0205  20         li    tmp1,sams.layout.copy.data
     25E0 2600 
0374 25E2 0206  20         li    tmp2,8                ; Set loop counter
     25E4 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.layout.copy.loop:
0379 25E6 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 25E8 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     25EA 24C6 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 25EC CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     25EE 833C 
0385               
0386 25F0 0606  14         dec   tmp2                  ; Next iteration
0387 25F2 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.layout.copy.exit:
0392 25F4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 25F6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 25F8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 25FA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 25FC C2F9  30         mov   *stack+,r11           ; Pop r11
0397 25FE 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.layout.copy.data:
0402 2600 2000             data  >2000                 ; >2000-2fff
0403 2602 3000             data  >3000                 ; >3000-3fff
0404 2604 A000             data  >a000                 ; >a000-afff
0405 2606 B000             data  >b000                 ; >b000-bfff
0406 2608 C000             data  >c000                 ; >c000-cfff
0407 260A D000             data  >d000                 ; >d000-dfff
0408 260C E000             data  >e000                 ; >e000-efff
0409 260E F000             data  >f000                 ; >f000-ffff
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
0009 2610 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2612 FFBF 
0010 2614 0460  28         b     @putv01
     2616 2328 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2618 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     261A 0040 
0018 261C 0460  28         b     @putv01
     261E 2328 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2620 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2622 FFDF 
0026 2624 0460  28         b     @putv01
     2626 2328 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2628 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     262A 0020 
0034 262C 0460  28         b     @putv01
     262E 2328 
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
0010 2630 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2632 FFFE 
0011 2634 0460  28         b     @putv01
     2636 2328 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2638 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     263A 0001 
0019 263C 0460  28         b     @putv01
     263E 2328 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2640 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2642 FFFD 
0027 2644 0460  28         b     @putv01
     2646 2328 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2648 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     264A 0002 
0035 264C 0460  28         b     @putv01
     264E 2328 
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
0018 2650 C83B  50 at      mov   *r11+,@wyx
     2652 832A 
0019 2654 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2656 B820  54 down    ab    @hb$01,@wyx
     2658 201C 
     265A 832A 
0028 265C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 265E 7820  54 up      sb    @hb$01,@wyx
     2660 201C 
     2662 832A 
0037 2664 045B  20         b     *r11
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
0049 2666 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2668 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     266A 832A 
0051 266C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     266E 832A 
0052 2670 045B  20         b     *r11
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
0021 2672 C120  34 yx2px   mov   @wyx,tmp0
     2674 832A 
0022 2676 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2678 06C4  14         swpb  tmp0                  ; Y<->X
0024 267A 04C5  14         clr   tmp1                  ; Clear before copy
0025 267C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 267E 20A0  38         coc   @wbit1,config         ; f18a present ?
     2680 2028 
0030 2682 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2684 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2686 833A 
     2688 26B2 
0032 268A 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 268C 0A15  56         sla   tmp1,1                ; X = X * 2
0035 268E B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 2690 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2692 0500 
0037 2694 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2696 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2698 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 269A 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 269C D105  18         movb  tmp1,tmp0
0051 269E 06C4  14         swpb  tmp0                  ; X<->Y
0052 26A0 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26A2 202A 
0053 26A4 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26A6 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26A8 201C 
0059 26AA 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26AC 202E 
0060 26AE 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26B0 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26B2 0050            data   80
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
0013 26B4 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26B6 06A0  32         bl    @putvr                ; Write once
     26B8 2314 
0015 26BA 391C             data  >391c                 ; VR1/57, value 00011100
0016 26BC 06A0  32         bl    @putvr                ; Write twice
     26BE 2314 
0017 26C0 391C             data  >391c                 ; VR1/57, value 00011100
0018 26C2 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26C4 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26C6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26C8 2314 
0028 26CA 391C             data  >391c
0029 26CC 0458  20         b     *tmp4                 ; Exit
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
0040 26CE C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26D0 06A0  32         bl    @cpym2v
     26D2 241A 
0042 26D4 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26D6 2712 
     26D8 0006 
0043 26DA 06A0  32         bl    @putvr
     26DC 2314 
0044 26DE 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26E0 06A0  32         bl    @putvr
     26E2 2314 
0046 26E4 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 26E6 0204  20         li    tmp0,>3f00
     26E8 3F00 
0052 26EA 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     26EC 229C 
0053 26EE D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     26F0 8800 
0054 26F2 0984  56         srl   tmp0,8
0055 26F4 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     26F6 8800 
0056 26F8 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 26FA 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 26FC 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     26FE BFFF 
0060 2700 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2702 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2704 4000 
0063               f18chk_exit:
0064 2706 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2708 2270 
0065 270A 3F00             data  >3f00,>00,6
     270C 0000 
     270E 0006 
0066 2710 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2712 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2714 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2716 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2718 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 271A 06A0  32         bl    @putvr
     271C 2314 
0097 271E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2720 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2722 2314 
0100 2724 391C             data  >391c                 ; Lock the F18a
0101 2726 0458  20         b     *tmp4                 ; Exit
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
0120 2728 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 272A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     272C 2028 
0122 272E 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2730 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2732 8802 
0127 2734 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2736 2314 
0128 2738 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 273A 04C4  14         clr   tmp0
0130 273C D120  34         movb  @vdps,tmp0
     273E 8802 
0131 2740 0984  56         srl   tmp0,8
0132 2742 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2744 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2746 832A 
0018 2748 D17B  28         movb  *r11+,tmp1
0019 274A 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 274C D1BB  28         movb  *r11+,tmp2
0021 274E 0986  56         srl   tmp2,8                ; Repeat count
0022 2750 C1CB  18         mov   r11,tmp3
0023 2752 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2754 23DC 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2756 020B  20         li    r11,hchar1
     2758 275E 
0028 275A 0460  28         b     @xfilv                ; Draw
     275C 2276 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 275E 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     2760 202C 
0033 2762 1302  14         jeq   hchar2                ; Yes, exit
0034 2764 C2C7  18         mov   tmp3,r11
0035 2766 10EE  14         jmp   hchar                 ; Next one
0036 2768 05C7  14 hchar2  inct  tmp3
0037 276A 0457  20         b     *tmp3                 ; Exit
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
0017 276C C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     276E 832A 
0018 2770 C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 2772 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     2774 833A 
0020 2776 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2778 23DC 
0021 277A D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 277C D1B7  28         movb  *tmp3+,tmp2
0023 277E 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 2780 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     2782 2298 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 2784 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 2786 A108  18         a     tmp4,tmp0             ; Next row
0033 2788 0606  14         dec   tmp2
0034 278A 16FA  14         jne   vchar2
0035 278C 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     278E 202C 
0036 2790 1303  14         jeq   vchar3                ; Yes, exit
0037 2792 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     2794 832A 
0038 2796 10ED  14         jmp   vchar1                ; Next one
0039 2798 05C7  14 vchar3  inct  tmp3
0040 279A 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 279C C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 279E C804  38         mov   tmp0,@wyx             ; Set cursor position
     27A0 832A 
0051 27A2 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 27A4 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     27A6 833A 
0053 27A8 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27AA 23DC 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 27AC 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     27AE 2298 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 27B0 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 27B2 A120  34         a     @wcolmn,tmp0          ; Next row
     27B4 833A 
0063 27B6 0606  14         dec   tmp2
0064 27B8 16F9  14         jne   xvcha1
0065 27BA 0458  20         b     *tmp4                 ; Exit
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
0016 27BC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BE 202A 
0017 27C0 020C  20         li    r12,>0024
     27C2 0024 
0018 27C4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C6 2854 
0019 27C8 04C6  14         clr   tmp2
0020 27CA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CC 04CC  14         clr   r12
0025 27CE 1F08  20         tb    >0008                 ; Shift-key ?
0026 27D0 1302  14         jeq   realk1                ; No
0027 27D2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D4 2884 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D8 1302  14         jeq   realk2                ; No
0033 27DA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DC 28B4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27E0 1302  14         jeq   realk3                ; No
0039 27E2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E4 28E4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27E8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27EA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27EC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27EE 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27F0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27F2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F4 0006 
0052 27F6 0606  14 realk5  dec   tmp2
0053 27F8 020C  20         li    r12,>24               ; CRU address for P2-P4
     27FA 0024 
0054 27FC 06C6  14         swpb  tmp2
0055 27FE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 2800 06C6  14         swpb  tmp2
0057 2802 020C  20         li    r12,6                 ; CRU read address
     2804 0006 
0058 2806 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 2808 0547  14         inv   tmp3                  ;
0060 280A 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     280C FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 280E 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 2810 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 2812 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2814 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2816 0285  22         ci    tmp1,8
     2818 0008 
0069 281A 1AFA  14         jl    realk6
0070 281C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 281E 1BEB  14         jh    realk5                ; No, next column
0072 2820 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2822 C206  18 realk8  mov   tmp2,tmp4
0077 2824 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2826 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2828 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 282A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 282C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 282E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 2830 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2832 202A 
0087 2834 1608  14         jne   realka                ; No, continue saving key
0088 2836 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2838 287E 
0089 283A 1A05  14         jl    realka
0090 283C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     283E 287C 
0091 2840 1B02  14         jh    realka                ; No, continue
0092 2842 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2844 E000 
0093 2846 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2848 833C 
0094 284A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     284C 2014 
0095 284E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     2850 8C00 
0096 2852 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2854 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2856 0000 
     2858 FF0D 
     285A 203D 
0099 285C ....             text  'xws29ol.'
0100 2864 ....             text  'ced38ik,'
0101 286C ....             text  'vrf47ujm'
0102 2874 ....             text  'btg56yhn'
0103 287C ....             text  'zqa10p;/'
0104 2884 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2886 0000 
     2888 FF0D 
     288A 202B 
0105 288C ....             text  'XWS@(OL>'
0106 2894 ....             text  'CED#*IK<'
0107 289C ....             text  'VRF$&UJM'
0108 28A4 ....             text  'BTG%^YHN'
0109 28AC ....             text  'ZQA!)P:-'
0110 28B4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B6 0000 
     28B8 FF0D 
     28BA 2005 
0111 28BC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28BE 0804 
     28C0 0F27 
     28C2 C2B9 
0112 28C4 600B             data  >600b,>0907,>063f,>c1B8
     28C6 0907 
     28C8 063F 
     28CA C1B8 
0113 28CC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28CE 7B02 
     28D0 015F 
     28D2 C0C3 
0114 28D4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D6 7D0E 
     28D8 0CC6 
     28DA BFC4 
0115 28DC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28DE 7C03 
     28E0 BC22 
     28E2 BDBA 
0116 28E4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E6 0000 
     28E8 FF0D 
     28EA 209D 
0117 28EC 9897             data  >9897,>93b2,>9f8f,>8c9B
     28EE 93B2 
     28F0 9F8F 
     28F2 8C9B 
0118 28F4 8385             data  >8385,>84b3,>9e89,>8b80
     28F6 84B3 
     28F8 9E89 
     28FA 8B80 
0119 28FC 9692             data  >9692,>86b4,>b795,>8a8D
     28FE 86B4 
     2900 B795 
     2902 8A8D 
0120 2904 8294             data  >8294,>87b5,>b698,>888E
     2906 87B5 
     2908 B698 
     290A 888E 
0121 290C 9A91             data  >9a91,>81b1,>b090,>9cBB
     290E 81B1 
     2910 B090 
     2912 9CBB 
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
0023 2914 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2916 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2918 8340 
0025 291A 04E0  34         clr   @waux1
     291C 833C 
0026 291E 04E0  34         clr   @waux2
     2920 833E 
0027 2922 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2924 833C 
0028 2926 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2928 0205  20         li    tmp1,4                ; 4 nibbles
     292A 0004 
0033 292C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 292E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2930 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2932 0286  22         ci    tmp2,>000a
     2934 000A 
0039 2936 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2938 C21B  26         mov   *r11,tmp4
0045 293A 0988  56         srl   tmp4,8                ; Right justify
0046 293C 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     293E FFF6 
0047 2940 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2942 C21B  26         mov   *r11,tmp4
0054 2944 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2946 00FF 
0055               
0056 2948 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 294A 06C6  14         swpb  tmp2
0058 294C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 294E 0944  56         srl   tmp0,4                ; Next nibble
0060 2950 0605  14         dec   tmp1
0061 2952 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2954 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2956 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2958 C160  34         mov   @waux3,tmp1           ; Get pointer
     295A 8340 
0067 295C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 295E 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2960 C120  34         mov   @waux2,tmp0
     2962 833E 
0070 2964 06C4  14         swpb  tmp0
0071 2966 DD44  32         movb  tmp0,*tmp1+
0072 2968 06C4  14         swpb  tmp0
0073 296A DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 296C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     296E 8340 
0078 2970 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2972 2020 
0079 2974 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2976 C120  34         mov   @waux1,tmp0
     2978 833C 
0084 297A 06C4  14         swpb  tmp0
0085 297C DD44  32         movb  tmp0,*tmp1+
0086 297E 06C4  14         swpb  tmp0
0087 2980 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2982 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2984 202A 
0092 2986 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2988 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 298A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     298C 7FFF 
0098 298E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2990 8340 
0099 2992 0460  28         b     @xutst0               ; Display string
     2994 2402 
0100 2996 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2998 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     299A 832A 
0122 299C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     299E 8000 
0123 29A0 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A2 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A4 0005 
0020 29A6 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A8 C155  26         mov   *tmp1,tmp1            ; /
0022 29AA C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29AC 0228  22         ai    tmp4,4                ; Get end of buffer
     29AE 0004 
0024 29B0 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B2 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B4 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B6 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B8 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29BA B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29BC D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29BE C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29C0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C2 0607  14         dec   tmp3                  ; Decrease counter
0036 29C4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C6 0207  20         li    tmp3,4                ; Check first 4 digits
     29C8 0004 
0041 29CA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29CC C11B  26         mov   *r11,tmp0
0043 29CE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29D0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D4 05CB  14 mknum3  inct  r11
0047 29D6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D8 202A 
0048 29DA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29DC 045B  20         b     *r11                  ; Exit
0050 29DE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29E0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E2 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E8 7FFF 
0058 29EA C10B  18         mov   r11,tmp0
0059 29EC 0224  22         ai    tmp0,-4
     29EE FFFC 
0060 29F0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F2 0206  20         li    tmp2,>0500            ; String length = 5
     29F4 0500 
0062 29F6 0460  28         b     @xutstr               ; Display string
     29F8 2404 
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
0092 29FA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29FC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29FE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 2A00 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 2A02 0207  20         li    tmp3,5                ; Set counter
     2A04 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A06 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A08 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A0A 0584  14         inc   tmp0                  ; Next character
0104 2A0C 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A0E 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A10 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A12 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A14 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A16 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A18 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A1A 0607  14         dec   tmp3                  ; Last character ?
0120 2A1C 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A1E 045B  20         b     *r11                  ; Return
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
0138 2A20 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A22 832A 
0139 2A24 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A26 8000 
0140 2A28 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A2A C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2A2C 3E00 
0023 2A2E C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2A30 3E02 
0024 2A32 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A34 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A36 0200  20         li    r0,>8306              ; Scratpad source address
     2A38 8306 
0029 2A3A 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A3C 3E06 
0030 2A3E 0202  20         li    r2,62                 ; Loop counter
     2A40 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A42 CC70  46         mov   *r0+,*r1+
0036 2A44 CC70  46         mov   *r0+,*r1+
0037 2A46 0642  14         dect  r2
0038 2A48 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A4A C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A4C 83FE 
     2A4E 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A50 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A52 3E00 
0045 2A54 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A56 3E02 
0046 2A58 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A5A 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A5C 045B  20         b     *r11                  ; Return to caller
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
0070 2A5E C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A60 3E00 
     2A62 8300 
0071 2A64 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A66 3E02 
     2A68 8302 
0072 2A6A C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A6C 3E04 
     2A6E 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A70 C800  38         mov   r0,@cpu.scrpad.tgt
     2A72 3E00 
0077 2A74 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A76 3E02 
0078 2A78 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A7A 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A7C 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A7E 3E06 
0083 2A80 0201  20         li    r1,>8306
     2A82 8306 
0084 2A84 0202  20         li    r2,62
     2A86 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A88 CC70  46         mov   *r0+,*r1+
0090 2A8A CC70  46         mov   *r0+,*r1+
0091 2A8C 0642  14         dect  r2
0092 2A8E 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A90 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A92 3EFE 
     2A94 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A96 C020  34         mov   @cpu.scrpad.tgt,r0
     2A98 3E00 
0099 2A9A C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A9C 3E02 
0100 2A9E C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2AA0 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2AA2 045B  20         b     *r11                  ; Return to caller
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
0025 2AA4 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2AA6 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2AA8 8300 
0031 2AAA C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2AAC 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2AAE 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2AB0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2AB2 0606  14         dec   tmp2
0038 2AB4 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2AB6 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2AB8 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2ABA 2AC0 
0044                                                   ; R14=PC
0045 2ABC 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2ABE 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2AC0 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2AC2 2A5E 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2AC4 045B  20         b     *r11                  ; Return to caller
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
0078 2AC6 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2AC8 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2ACA 8300 
0084 2ACC 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2ACE 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2AD0 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2AD2 0606  14         dec   tmp2
0090 2AD4 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AD6 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AD8 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2ADA 045B  20         b     *r11                  ; Return to caller
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
0041 2ADC A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2ADE 2AE0             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2AE0 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2AE2 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2AE4 8322 
0049 2AE6 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2AE8 2026 
0050 2AEA C020  34         mov   @>8356,r0             ; get ptr to pab
     2AEC 8356 
0051 2AEE C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2AF0 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AF2 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AF4 06C0  14         swpb  r0                    ;
0059 2AF6 D800  38         movb  r0,@vdpa              ; send low byte
     2AF8 8C02 
0060 2AFA 06C0  14         swpb  r0                    ;
0061 2AFC D800  38         movb  r0,@vdpa              ; send high byte
     2AFE 8C02 
0062 2B00 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2B02 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B04 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2B06 0704  14         seto  r4                    ; init counter
0070 2B08 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2B0A A420 
0071 2B0C 0580  14 !       inc   r0                    ; point to next char of name
0072 2B0E 0584  14         inc   r4                    ; incr char counter
0073 2B10 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2B12 0007 
0074 2B14 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2B16 80C4  18         c     r4,r3                 ; end of name?
0077 2B18 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2B1A 06C0  14         swpb  r0                    ;
0082 2B1C D800  38         movb  r0,@vdpa              ; send low byte
     2B1E 8C02 
0083 2B20 06C0  14         swpb  r0                    ;
0084 2B22 D800  38         movb  r0,@vdpa              ; send high byte
     2B24 8C02 
0085 2B26 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B28 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2B2A DC81  32         movb  r1,*r2+               ; move into buffer
0092 2B2C 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2B2E 2BF0 
0093 2B30 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B32 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B34 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B36 04E0  34         clr   @>83d0
     2B38 83D0 
0102 2B3A C804  38         mov   r4,@>8354             ; save name length for search
     2B3C 8354 
0103 2B3E 0584  14         inc   r4                    ; adjust for dot
0104 2B40 A804  38         a     r4,@>8356             ; point to position after name
     2B42 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B44 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B46 83E0 
0110 2B48 04C1  14         clr   r1                    ; version found of dsr
0111 2B4A 020C  20         li    r12,>0f00             ; init cru addr
     2B4C 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B4E C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B50 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B52 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B54 022C  22         ai    r12,>0100             ; next rom to turn on
     2B56 0100 
0125 2B58 04E0  34         clr   @>83d0                ; clear in case we are done
     2B5A 83D0 
0126 2B5C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B5E 2000 
0127 2B60 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B62 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B64 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B66 1D00  20         sbo   0                     ; turn on rom
0134 2B68 0202  20         li    r2,>4000              ; start at beginning of rom
     2B6A 4000 
0135 2B6C 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B6E 2BEC 
0136 2B70 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B72 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B74 A40A 
0146 2B76 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B78 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B7A 83D2 
0152                                                   ; subprogram
0153               
0154 2B7C 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B7E C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B80 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B82 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B84 83D2 
0163                                                   ; subprogram
0164               
0165 2B86 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B88 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B8A 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B8C D160  34         movb  @>8355,r5             ; get length as counter
     2B8E 8355 
0175 2B90 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B92 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B94 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B96 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B98 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B9A A420 
0186 2B9C 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B9E 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2BA0 0605  14         dec   r5                    ; loop until full length checked
0191 2BA2 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2BA4 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2BA6 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2BA8 0581  14         inc   r1                    ; next version found
0203 2BAA 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2BAC 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2BAE 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2BB0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BB2 A400 
0212 2BB4 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2BB6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BB8 8322 
0214                                                   ; (8 or >a)
0215 2BBA 0281  22         ci    r1,8                  ; was it 8?
     2BBC 0008 
0216 2BBE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2BC0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BC2 8350 
0218                                                   ; Get error byte from @>8350
0219 2BC4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2BC6 06C0  14         swpb  r0                    ;
0227 2BC8 D800  38         movb  r0,@vdpa              ; send low byte
     2BCA 8C02 
0228 2BCC 06C0  14         swpb  r0                    ;
0229 2BCE D800  38         movb  r0,@vdpa              ; send high byte
     2BD0 8C02 
0230 2BD2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BD4 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BD6 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BD8 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BDA 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BDC 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BDE A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BE0 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2BE2 06C1  14         swpb  r1                    ; put error in hi byte
0252 2BE4 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2BE6 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2BE8 2026 
0254 2BEA 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2BEC AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2BEE 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2BF0 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 2BF2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BF4 C04B  18         mov   r11,r1                ; Save return address
0049 2BF6 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BF8 A428 
0050 2BFA C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BFC 04C5  14         clr   tmp1                  ; io.op.open
0052 2BFE 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C00 22AE 
0053               file.open_init:
0054 2C02 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C04 0009 
0055 2C06 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C08 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2C0A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C0C 2ADC 
0061 2C0E 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2C10 1029  14         jmp   file.record.pab.details
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
0090 2C12 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2C14 C04B  18         mov   r11,r1                ; Save return address
0096 2C16 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C18 A428 
0097 2C1A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2C1C 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C1E 0001 
0099 2C20 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C22 22AE 
0100               file.close_init:
0101 2C24 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C26 0009 
0102 2C28 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C2A 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2C2C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C2E 2ADC 
0108 2C30 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C32 1018  14         jmp   file.record.pab.details
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
0139 2C34 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C36 C04B  18         mov   r11,r1                ; Save return address
0145 2C38 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C3A A428 
0146 2C3C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C3E 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C40 0002 
0148 2C42 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C44 22AE 
0149               file.record.read_init:
0150 2C46 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C48 0009 
0151 2C4A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C4C 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C4E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C50 2ADC 
0157 2C52 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C54 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C56 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C58 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C5A 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C5C 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C5E 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C60 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C62 1000  14         nop
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
0211 2C64 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C66 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C68 A428 
0219 2C6A 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C6C 0005 
0220 2C6E 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C70 22C6 
0221 2C72 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C74 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 2C76 0451  20         b     *r1                   ; Return to caller
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
0020 2C78 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C7A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C7C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C7E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C80 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C82 2026 
0029 2C84 1602  14         jne   tmgr1a                ; No, so move on
0030 2C86 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C88 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C8A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C8C 202A 
0035 2C8E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C90 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C92 201A 
0048 2C94 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C96 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C98 2018 
0050 2C9A 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C9C 0460  28         b     @kthread              ; Run kernel thread
     2C9E 2D16 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2CA0 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2CA2 201E 
0056 2CA4 13EB  14         jeq   tmgr1
0057 2CA6 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CA8 201C 
0058 2CAA 16E8  14         jne   tmgr1
0059 2CAC C120  34         mov   @wtiusr,tmp0
     2CAE 832E 
0060 2CB0 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CB2 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CB4 2D14 
0065 2CB6 C10A  18         mov   r10,tmp0
0066 2CB8 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CBA 00FF 
0067 2CBC 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CBE 2026 
0068 2CC0 1303  14         jeq   tmgr5
0069 2CC2 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CC4 003C 
0070 2CC6 1002  14         jmp   tmgr6
0071 2CC8 0284  22 tmgr5   ci    tmp0,50
     2CCA 0032 
0072 2CCC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CCE 1001  14         jmp   tmgr8
0074 2CD0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CD2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CD4 832C 
0079 2CD6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CD8 FF00 
0080 2CDA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CDC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CDE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CE0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CE2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CE4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CE6 830C 
     2CE8 830D 
0089 2CEA 1608  14         jne   tmgr10                ; No, get next slot
0090 2CEC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CEE FF00 
0091 2CF0 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CF2 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CF4 8330 
0096 2CF6 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CF8 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CFA 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CFC 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CFE 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D00 8315 
     2D02 8314 
0103 2D04 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D06 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D08 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D0A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D0C 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D0E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D10 FF00 
0109 2D12 10B4  14         jmp   tmgr1
0110 2D14 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2D16 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D18 201A 
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
0041 2D1A 06A0  32         bl    @realkb               ; Scan full keyboard
     2D1C 27BC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D1E 0460  28         b     @tmgr3                ; Exit
     2D20 2CA0 
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
0017 2D22 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D24 832E 
0018 2D26 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D28 201C 
0019 2D2A 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C7C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D2C 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D2E 832E 
0029 2D30 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D32 FEFF 
0030 2D34 045B  20         b     *r11                  ; Return
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
0017 2D36 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D38 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D3A C184  18         mov   tmp0,tmp2
0023 2D3C 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D3E A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D40 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D42 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D44 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D46 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D48 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D4A 202C 
0035 2D4C 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D4E 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D50 05CB  14 mkslo1  inct  r11
0041 2D52 045B  20         b     *r11                  ; Exit
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
0052 2D54 C13B  30 clslot  mov   *r11+,tmp0
0053 2D56 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D58 A120  34         a     @wtitab,tmp0          ; Add table base
     2D5A 832C 
0055 2D5C 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D5E 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D60 045B  20         b     *r11                  ; Exit
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
0250 2D62 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D64 2A2A 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D66 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D68 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D6A 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D6C 0000 
0261 2D6E 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D70 8300 
0262 2D72 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D74 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D76 0202  20 runli2  li    r2,>8308
     2D78 8308 
0267 2D7A 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D7C 0282  22         ci    r2,>8400
     2D7E 8400 
0269 2D80 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D82 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D84 FFFF 
0274 2D86 1602  14         jne   runli4                ; No, continue
0275 2D88 0420  54         blwp  @0                    ; Yes, bye bye
     2D8A 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D8C C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D8E 833C 
0280 2D90 04C1  14         clr   r1                    ; Reset counter
0281 2D92 0202  20         li    r2,10                 ; We test 10 times
     2D94 000A 
0282 2D96 C0E0  34 runli5  mov   @vdps,r3
     2D98 8802 
0283 2D9A 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D9C 202A 
0284 2D9E 1302  14         jeq   runli6
0285 2DA0 0581  14         inc   r1                    ; Increase counter
0286 2DA2 10F9  14         jmp   runli5
0287 2DA4 0602  14 runli6  dec   r2                    ; Next test
0288 2DA6 16F7  14         jne   runli5
0289 2DA8 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DAA 1250 
0290 2DAC 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2DAE 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DB0 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2DB2 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2DB4 2202 
0296 2DB6 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2DB8 8322 
0297 2DBA CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2DBC CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2DBE CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2DC0 04C1  14 runli9  clr   r1
0304 2DC2 04C2  14         clr   r2
0305 2DC4 04C3  14         clr   r3
0306 2DC6 0209  20         li    stack,>8400           ; Set stack
     2DC8 8400 
0307 2DCA 020F  20         li    r15,vdpw              ; Set VDP write address
     2DCC 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2DCE 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DD0 4A4A 
0316 2DD2 1605  14         jne   runlia
0317 2DD4 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DD6 2270 
0318 2DD8 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DDA 0000 
     2DDC 3FFF 
0323 2DDE 06A0  32 runlia  bl    @filv
     2DE0 2270 
0324 2DE2 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DE4 00F4 
     2DE6 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2DE8 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DEA 26B4 
0332 2DEC 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DEE 26CE 
0333 2DF0 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DF2 26C4 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0339               *       <<skipped>>
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 2DF4 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DF6 22DA 
0347 2DF8 73B4             data  spvmod                ; Equate selected video mode table
0348 2DFA 0204  20         li    tmp0,spfont           ; Get font option
     2DFC 000C 
0349 2DFE 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 2E00 1304  14         jeq   runlid                ; Yes, skip it
0351 2E02 06A0  32         bl    @ldfnt
     2E04 2342 
0352 2E06 1100             data  fntadr,spfont         ; Load specified font
     2E08 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 2E0A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E0C 4A4A 
0357 2E0E 1602  14         jne   runlie                ; No, continue
0358 2E10 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E12 2090 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 2E14 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E16 0040 
0363 2E18 0460  28         b     @main                 ; Give control to main program
     2E1A 6050 
**** **** ****     > stevie_b1.asm.158774
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
     6064 2610 
0042 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26B4 
0043 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 2314 
0044 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0045               
0046 6070 06A0  32         bl    @putvr                ; Turn on position based attributes
     6072 2314 
0047 6074 3202                   data >3202            ; F18a VR50 (>32), bit 2
0048               
0049 6076 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     6078 2314 
0050 607A 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0051               
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 607C 06A0  32         bl    @filv
     607E 2270 
0056 6080 0000                   data >0000,32,30*80   ; Clear screen
     6082 0020 
     6084 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize position-based colors (VDP TAT)
0059                       ;------------------------------------------------------
0060 6086 06A0  32         bl    @filv
     6088 2270 
0061 608A 1800                   data >1800,>f0,29*80  ; Colors for frame buffer area
     608C 00F0 
     608E 0910 
0062               
0063 6090 06A0  32         bl    @filv
     6092 2270 
0064 6094 2110                   data >2110,>1f,1*80   ; Colors for bottom line pane
     6096 001F 
     6098 0050 
0065                       ;------------------------------------------------------
0066                       ; Complete F18A VDP setup
0067                       ;------------------------------------------------------
0068 609A 06A0  32         bl    @scron                ; Turn screen on
     609C 2618 
0069                       ;------------------------------------------------------
0070                       ; Initialize high memory expansion
0071                       ;------------------------------------------------------
0072 609E 06A0  32         bl    @film
     60A0 2218 
0073 60A2 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     60A4 0000 
     60A6 6000 
0074                       ;------------------------------------------------------
0075                       ; Setup SAMS windows
0076                       ;------------------------------------------------------
0077 60A8 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     60AA 6708 
0078                       ;------------------------------------------------------
0079                       ; Setup cursor, screen, etc.
0080                       ;------------------------------------------------------
0081 60AC 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     60AE 2630 
0082 60B0 06A0  32         bl    @s8x8                 ; Small sprite
     60B2 2640 
0083               
0084 60B4 06A0  32         bl    @cpym2m
     60B6 2462 
0085 60B8 73BE                   data romsat,ramsat,4  ; Load sprite SAT
     60BA 8380 
     60BC 0004 
0086               
0087 60BE C820  54         mov   @romsat+2,@tv.curshape
     60C0 73C0 
     60C2 A014 
0088                                                   ; Save cursor shape & color
0089               
0090 60C4 06A0  32         bl    @cpym2v
     60C6 241A 
0091 60C8 2800                   data sprpdt,cursors,3*8
     60CA 73C2 
     60CC 0018 
0092                                                   ; Load sprite cursor patterns
0093               
0094 60CE 06A0  32         bl    @cpym2v
     60D0 241A 
0095 60D2 1008                   data >1008,patterns,11*8
     60D4 73DA 
     60D6 0058 
0096                                                   ; Load character patterns
0097               *--------------------------------------------------------------
0098               * Initialize
0099               *--------------------------------------------------------------
0100 60D8 06A0  32         bl    @stevie.init          ; Initialize Stevie editor config
     60DA 66FC 
0101 60DC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60DE 6C90 
0102 60E0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60E2 6AB2 
0103 60E4 06A0  32         bl    @idx.init             ; Initialize index
     60E6 688A 
0104 60E8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60EA 675E 
0105                       ;-------------------------------------------------------
0106                       ; Setup editor tasks & hook
0107                       ;-------------------------------------------------------
0108 60EC 0204  20         li    tmp0,>0200
     60EE 0200 
0109 60F0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60F2 8314 
0110               
0111 60F4 06A0  32         bl    @at
     60F6 2650 
0112 60F8 0000                   data  >0000           ; Cursor YX position = >0000
0113               
0114 60FA 0204  20         li    tmp0,timers
     60FC 8370 
0115 60FE C804  38         mov   tmp0,@wtitab
     6100 832C 
0116               
0117 6102 06A0  32         bl    @mkslot
     6104 2D36 
0118 6106 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     6108 7086 
0119 610A 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     610C 7118 
0120 610E 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     6110 714C 
0121 6112 FFFF                   data eol
0122               
0123 6114 06A0  32         bl    @mkhook
     6116 2D22 
0124 6118 7056                   data hook.keyscan     ; Setup user hook
0125               
0126 611A 0460  28         b     @tmgr                 ; Start timers and kthread
     611C 2C78 
0127               
0128               
**** **** ****     > stevie_b1.asm.158774
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
0012               
0013 6128 C1A0  34         mov   @tv.pane.focus,tmp2
     612A A016 
0014 612C 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     612E 0000 
0015 6130 1307  14         jeq   edkey.key.process.loadmap.editor
0016                                                   ; Yes, so load editor keymap
0017               
0018 6132 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6134 0001 
0019 6136 1307  14         jeq   edkey.key.process.loadmap.cmdb
0020                                                   ; Yes, so load CMDB keymap
0021                       ;-------------------------------------------------------
0022                       ; Pane without focus, crash
0023                       ;-------------------------------------------------------
0024 6138 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     613A FFCE 
0025 613C 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     613E 2030 
0026                       ;-------------------------------------------------------
0027                       ; Use editor keyboard map
0028                       ;-------------------------------------------------------
0029               edkey.key.process.loadmap.editor:
0030 6140 0206  20         li    tmp2,keymap_actions.editor
     6142 78CA 
0031 6144 1003  14         jmp   edkey.key.check_next
0032                       ;-------------------------------------------------------
0033                       ; Use CMDB keyboard map
0034                       ;-------------------------------------------------------
0035               edkey.key.process.loadmap.cmdb:
0036 6146 0206  20         li    tmp2,keymap_actions.cmdb
     6148 798C 
0037 614A 1600  14         jne   edkey.key.check_next
0038                       ;-------------------------------------------------------
0039                       ; Iterate over keyboard map for matching action key
0040                       ;-------------------------------------------------------
0041               edkey.key.check_next:
0042 614C 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0043 614E 1309  14         jeq   edkey.key.process.addbuffer
0044                                                   ; Yes, means no action key pressed, so
0045                                                   ; add character to buffer
0046                       ;-------------------------------------------------------
0047                       ; Check for action key match
0048                       ;-------------------------------------------------------
0049 6150 8585  30         c     tmp1,*tmp2            ; Action key matched?
0050 6152 1303  14         jeq   edkey.key.process.action
0051                                                   ; Yes, do action
0052 6154 0226  22         ai    tmp2,6                ; Skip current entry
     6156 0006 
0053 6158 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0054                       ;-------------------------------------------------------
0055                       ; Trigger keyboard action
0056                       ;-------------------------------------------------------
0057               edkey.key.process.action:
0058 615A 0226  22         ai    tmp2,4                ; Move to action address
     615C 0004 
0059 615E C196  26         mov   *tmp2,tmp2            ; Get action address
0060 6160 0456  20         b     *tmp2                 ; Process key action
0061                       ;-------------------------------------------------------
0062                       ; Add character to buffer
0063                       ;-------------------------------------------------------
0064               edkey.key.process.addbuffer:
0065 6162 C120  34         mov  @tv.pane.focus,tmp0    ; Framebuffer has focus?
     6164 A016 
0066 6166 1602  14         jne  !
0067                       ;-------------------------------------------------------
0068                       ; Frame buffer
0069                       ;-------------------------------------------------------
0070 6168 0460  28         b    @edkey.action.char     ; Add character to buffer
     616A 65FE 
0071                       ;-------------------------------------------------------
0072                       ; CMDB buffer
0073                       ;-------------------------------------------------------
0074 616C 0285  22 !       ci   tmp1,pane.focus.cmdb   ; CMDB has focus ?
     616E 0001 
0075 6170 1602  14         jne  edkey.key.process.crash
0076 6172 0460  28         b    @edkey.cmdb.action.char
     6174 66EC 
0077                                                   ; Add character to buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 6176 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6178 FFCE 
0083 617A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     617C 2030 
**** **** ****     > stevie_b1.asm.158774
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
     6192 707A 
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
     61AA 707A 
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
     61B6 6AE8 
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
     61D0 67D0 
0068 61D2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61D4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61D6 A106 
0074 61D8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61DA 265E 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61DC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61DE 6C72 
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
     61F4 2668 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61F8 67B4 
0093 61FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61FC 707A 
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
     6210 6AE8 
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
     623C 67D0 
0135 623E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6240 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6242 A106 
0141 6244 06A0  32         bl    @down                 ; Row++ VDP cursor
     6246 2656 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6248 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     624A 6C72 
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
     6260 2668 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6262 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6264 67B4 
0162 6266 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6268 707A 
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
     627C 67B4 
0175 627E 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6280 707A 
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
     628C 2668 
0184 628E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6290 67B4 
0185 6292 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6294 707A 
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
     62DE 2668 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62E0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62E2 67B4 
0253 62E4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62E6 707A 
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
     633E 2668 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6340 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6342 67B4 
0336 6344 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6346 707A 
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
     636A 6AE8 
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
     6378 67D0 
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
     63A8 6AE8 
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
     63B4 707A 
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
     63C0 6AE8 
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
     63D0 67D0 
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
     63E0 707A 
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
     63EC 6AE8 
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
     640C 67D0 
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
     6420 707A 
**** **** ****     > stevie_b1.asm.158774
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
     6428 67B4 
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
     6458 707A 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 645A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     645C A206 
0055 645E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6460 67B4 
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
     648C 707A 
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
     64A2 67B4 
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
     64BC 6A34 
0109 64BE 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64C0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64C2 C820  54         mov   @fb.topline,@parm1
     64C4 A104 
     64C6 8350 
0114 64C8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64CA 67D0 
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
     64F4 67B4 
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
     653A 707A 
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
     654A 6AE8 
0213 654C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     654E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6550 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6552 67B4 
0219 6554 C820  54         mov   @fb.topline,@parm1
     6556 A104 
     6558 8350 
0220 655A A820  54         a     @fb.row,@parm1        ; Line number to insert
     655C A106 
     655E 8350 
0221               
0222 6560 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6562 A204 
     6564 8352 
0223 6566 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6568 6A82 
0224 656A 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     656C A204 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 656E C820  54         mov   @fb.topline,@parm1
     6570 A104 
     6572 8350 
0229 6574 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6576 67D0 
0230 6578 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     657A A116 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 657C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     657E 707A 
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
0249 6580 8820  54         c     @fb.row.dirty,@w$ffff
     6582 A10A 
     6584 202C 
0250 6586 1606  14         jne   edkey.action.enter.upd_counter
0251 6588 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     658A A206 
0252 658C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     658E 6AE8 
0253 6590 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6592 A10A 
0254                       ;-------------------------------------------------------
0255                       ; Update line counter
0256                       ;-------------------------------------------------------
0257               edkey.action.enter.upd_counter:
0258 6594 C120  34         mov   @fb.topline,tmp0
     6596 A104 
0259 6598 A120  34         a     @fb.row,tmp0
     659A A106 
0260 659C 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     659E A204 
0261 65A0 1602  14         jne   edkey.action.newline  ; No, continue newline
0262 65A2 05A0  34         inc   @edb.lines            ; Total lines++
     65A4 A204 
0263                       ;-------------------------------------------------------
0264                       ; Process newline
0265                       ;-------------------------------------------------------
0266               edkey.action.newline:
0267                       ;-------------------------------------------------------
0268                       ; Scroll 1 line if cursor at bottom row of screen
0269                       ;-------------------------------------------------------
0270 65A6 C120  34         mov   @fb.scrrows,tmp0
     65A8 A118 
0271 65AA 0604  14         dec   tmp0
0272 65AC 8120  34         c     @fb.row,tmp0
     65AE A106 
0273 65B0 110A  14         jlt   edkey.action.newline.down
0274                       ;-------------------------------------------------------
0275                       ; Scroll
0276                       ;-------------------------------------------------------
0277 65B2 C120  34         mov   @fb.scrrows,tmp0
     65B4 A118 
0278 65B6 C820  54         mov   @fb.topline,@parm1
     65B8 A104 
     65BA 8350 
0279 65BC 05A0  34         inc   @parm1
     65BE 8350 
0280 65C0 06A0  32         bl    @fb.refresh
     65C2 67D0 
0281 65C4 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 65C6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65C8 A106 
0287 65CA 06A0  32         bl    @down                 ; Row++ VDP cursor
     65CC 2656 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 65CE 06A0  32         bl    @fb.get.firstnonblank
     65D0 6842 
0293 65D2 C120  34         mov   @outparm1,tmp0
     65D4 8360 
0294 65D6 C804  38         mov   tmp0,@fb.column
     65D8 A10C 
0295 65DA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65DC 2668 
0296 65DE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65E0 6C72 
0297 65E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65E4 67B4 
0298 65E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65E8 A116 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65EA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65EC 707A 
0304               
0305               
0306               
0307               
0308               *---------------------------------------------------------------
0309               * Toggle insert/overwrite mode
0310               *---------------------------------------------------------------
0311               edkey.action.ins_onoff:
0312 65EE 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65F0 A20A 
0313                       ;-------------------------------------------------------
0314                       ; Delay
0315                       ;-------------------------------------------------------
0316 65F2 0204  20         li    tmp0,2000
     65F4 07D0 
0317               edkey.action.ins_onoff.loop:
0318 65F6 0604  14         dec   tmp0
0319 65F8 16FE  14         jne   edkey.action.ins_onoff.loop
0320                       ;-------------------------------------------------------
0321                       ; Exit
0322                       ;-------------------------------------------------------
0323               edkey.action.ins_onoff.exit:
0324 65FA 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65FC 714C 
0325               
0326               
0327               
0328               
0329               *---------------------------------------------------------------
0330               * Process character
0331               *---------------------------------------------------------------
0332               edkey.action.char:
0333 65FE 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6600 A206 
0334 6602 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6604 8350 
0335 6606 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6608 A20A 
0336 660A 1302  14         jeq   edkey.action.char.overwrite
0337                       ;-------------------------------------------------------
0338                       ; Insert mode
0339                       ;-------------------------------------------------------
0340               edkey.action.char.insert:
0341 660C 0460  28         b     @edkey.action.ins_char
     660E 64EE 
0342                       ;-------------------------------------------------------
0343                       ; Overwrite mode
0344                       ;-------------------------------------------------------
0345               edkey.action.char.overwrite:
0346 6610 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6612 67B4 
0347 6614 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6616 A102 
0348               
0349 6618 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     661A 8350 
0350 661C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     661E A10A 
0351 6620 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6622 A116 
0352               
0353 6624 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6626 A10C 
0354 6628 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     662A 832A 
0355                       ;-------------------------------------------------------
0356                       ; Update line length in frame buffer
0357                       ;-------------------------------------------------------
0358 662C 8820  54         c     @fb.column,@fb.row.length
     662E A10C 
     6630 A108 
0359 6632 1103  14         jlt   edkey.action.char.exit
0360                                                   ; column < length line ? Skip processing
0361               
0362 6634 C820  54         mov   @fb.column,@fb.row.length
     6636 A10C 
     6638 A108 
0363                       ;-------------------------------------------------------
0364                       ; Exit
0365                       ;-------------------------------------------------------
0366               edkey.action.char.exit:
0367 663A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     663C 707A 
**** **** ****     > stevie_b1.asm.158774
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
     6640 2718 
0010 6642 0420  54         blwp  @0                    ; Exit
     6644 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 6646 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6648 707A 
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Show/Hide command buffer pane
0022               ********|*****|*********************|**************************
0023               edkey.action.cmdb.toggle:
0024 664A C120  34         mov   @cmdb.visible,tmp0
     664C A302 
0025 664E 1603  14         jne   edkey.action.cmdb.hide
0026                       ;-------------------------------------------------------
0027                       ; Show pane
0028                       ;-------------------------------------------------------
0029               edkey.action.cmdb.show:
0030 6650 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6652 7266 
0031 6654 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 6656 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6658 72A0 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 665A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665C 707A 
0042               
0043               
0044               
0045               *---------------------------------------------------------------
0046               * Framebuffer down 1 row
0047               *---------------------------------------------------------------
0048               edkey.action.fbdown:
0049 665E 05A0  34         inc   @fb.scrrows
     6660 A118 
0050 6662 0720  34         seto  @fb.dirty
     6664 A116 
0051               
0052 6666 045B  20         b     *r11
0053               
**** **** ****     > stevie_b1.asm.158774
0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6668 0204  20         li   tmp0,fdname0
     666A 75C6 
0007 666C 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 666E 0204  20         li   tmp0,fdname1
     6670 7522 
0010 6672 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6674 0204  20         li   tmp0,fdname2
     6676 7536 
0013 6678 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 667A 0204  20         li   tmp0,fdname3
     667C 7546 
0016 667E 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 6680 0204  20         li   tmp0,fdname4
     6682 7554 
0019 6684 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6686 0204  20         li   tmp0,fdname5
     6688 7566 
0022 668A 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 668C 0204  20         li   tmp0,fdname6
     668E 7578 
0025 6690 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 6692 0204  20         li   tmp0,fdname7
     6694 758A 
0028 6696 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6698 0204  20         li   tmp0,fdname8
     669A 759E 
0031 669C 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 669E 0204  20         li   tmp0,fdname9
     66A0 75B2 
0034 66A2 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66A4 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66A6 6F04 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66A8 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66AA 63B6 
**** **** ****     > stevie_b1.asm.158774
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
0011 66AC 0204  20         li    tmp0,>2000            ; White space
     66AE 2000 
0012 66B0 C804  38         mov   tmp0,@parm1
     66B2 8350 
0013               edkey.cmdb.action.ins_char:
0014 66B4 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66B6 A310 
0015 66B8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     66BA 67B4 
0016                       ;-------------------------------------------------------
0017                       ; Prepare for insert operation
0018                       ;-------------------------------------------------------
0019               edkey.cmdb.action.skipsanity:
0020 66BC C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0021 66BE 61E0  34         s     @fb.column,tmp3
     66C0 A10C 
0022 66C2 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0023 66C4 C144  18         mov   tmp0,tmp1
0024 66C6 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0025 66C8 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     66CA A10C 
0026 66CC 0586  14         inc   tmp2
0027                       ;-------------------------------------------------------
0028                       ; Loop from end of line until current character
0029                       ;-------------------------------------------------------
0030               edkey.cmdb.action.ins_char_loop:
0031 66CE D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0032 66D0 0604  14         dec   tmp0
0033 66D2 0605  14         dec   tmp1
0034 66D4 0606  14         dec   tmp2
0035 66D6 16FB  14         jne   edkey.cmdb.action.ins_char_loop
0036                       ;-------------------------------------------------------
0037                       ; Set specified character on current position
0038                       ;-------------------------------------------------------
0039 66D8 D560  46         movb  @parm1,*tmp1
     66DA 8350 
0040                       ;-------------------------------------------------------
0041                       ; Save variables
0042                       ;-------------------------------------------------------
0043 66DC 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     66DE A10A 
0044 66E0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66E2 A116 
0045 66E4 05A0  34         inc   @fb.row.length        ; @fb.row.length
     66E6 A108 
0046                       ;-------------------------------------------------------
0047                       ; Exit
0048                       ;-------------------------------------------------------
0049               edkey.cmdb.action.ins_char.exit:
0050 66E8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66EA 707A 
0051               
0052               
0053               
0054               *---------------------------------------------------------------
0055               * Process character
0056               *---------------------------------------------------------------
0057               edkey.cmdb.action.char:
0058 66EC 0720  34         seto  @cmdb.dirty           ; Editor buffer dirty (text changed!)
     66EE A310 
0059 66F0 D805  38         movb  tmp1,@parm1           ; Store character for insert
     66F2 8350 
0060                       ;-------------------------------------------------------
0061                       ; Only insert mode supported
0062                       ;-------------------------------------------------------
0063               edkey.cmdb.action.char.insert:
0064 66F4 0460  28         b     @edkey.action.ins_char
     66F6 64EE 
0065                       ;-------------------------------------------------------
0066                       ; Exit
0067                       ;-------------------------------------------------------
0068               edkey.cmdb.action.char.exit:
0069 66F8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66FA 707A 
**** **** ****     > stevie_b1.asm.158774
0044                       copy  "stevie.asm"          ; Main editor configuration
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
0027 66FC 0649  14         dect  stack
0028 66FE C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6700 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     6702 A012 
0033                       ;------------------------------------------------------
0034                       ; Exit
0035                       ;------------------------------------------------------
0036               stevie.init.exit:
0037 6704 0460  28         b     @poprt                ; Return to caller
     6706 2214 
**** **** ****     > stevie_b1.asm.158774
0045                       copy  "mem.asm"             ; Memory Management
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
0021 6708 0649  14         dect  stack
0022 670A C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 670C 06A0  32         bl    @sams.layout
     670E 2564 
0027 6710 7432                   data mem.sams.layout.data
0028               
0029 6712 06A0  32         bl    @sams.layout.copy
     6714 25C8 
0030 6716 A000                   data tv.sams.2000     ; Get SAMS windows
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 6718 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 671A 045B  20         b     *r11                  ; Return to caller
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
0061 671C C13B  30         mov   *r11+,tmp0            ; Get p0
0062               xmem.edb.sams.mappage:
0063 671E 0649  14         dect  stack
0064 6720 C64B  30         mov   r11,*stack            ; Push return address
0065 6722 0649  14         dect  stack
0066 6724 C644  30         mov   tmp0,*stack           ; Push tmp0
0067 6726 0649  14         dect  stack
0068 6728 C645  30         mov   tmp1,*stack           ; Push tmp1
0069                       ;------------------------------------------------------
0070                       ; Sanity check
0071                       ;------------------------------------------------------
0072 672A 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     672C A204 
0073 672E 1104  14         jlt   mem.edb.sams.mappage.lookup
0074                                                   ; All checks passed, continue
0075                                                   ;--------------------------
0076                                                   ; Sanity check failed
0077                                                   ;--------------------------
0078 6730 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6732 FFCE 
0079 6734 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6736 2030 
0080                       ;------------------------------------------------------
0081                       ; Lookup SAMS page for line in parm1
0082                       ;------------------------------------------------------
0083               mem.edb.sams.mappage.lookup:
0084 6738 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     673A 69DA 
0085                                                   ; \ i  parm1    = Line number
0086                                                   ; | o  outparm1 = Pointer to line
0087                                                   ; / o  outparm2 = SAMS page
0088               
0089 673C C120  34         mov   @outparm2,tmp0        ; SAMS page
     673E 8362 
0090 6740 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6742 8360 
0091 6744 1308  14         jeq   mem.edb.sams.mappage.exit
0092                                                   ; Nothing to page-in if NULL pointer
0093                                                   ; (=empty line)
0094                       ;------------------------------------------------------
0095                       ; Determine if requested SAMS page is already active
0096                       ;------------------------------------------------------
0097 6746 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6748 A008 
0098 674A 1305  14         jeq   mem.edb.sams.mappage.exit
0099                                                   ; Request page already active. Exit.
0100                       ;------------------------------------------------------
0101                       ; Activate requested SAMS page
0102                       ;-----------------------------------------------------
0103 674C 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     674E 24FE 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106               
0107 6750 C820  54         mov   @outparm2,@tv.sams.c000
     6752 8362 
     6754 A008 
0108                                                   ; Set page in shadow registers
0109                       ;------------------------------------------------------
0110                       ; Exit
0111                       ;------------------------------------------------------
0112               mem.edb.sams.mappage.exit:
0113 6756 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0114 6758 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0115 675A C2F9  30         mov   *stack+,r11           ; Pop r11
0116 675C 045B  20         b     *r11                  ; Return to caller
0117               
0118               
0119               
**** **** ****     > stevie_b1.asm.158774
0046                       copy  "fb.asm"              ; Framebuffer
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
0024 675E 0649  14         dect  stack
0025 6760 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 6762 0204  20         li    tmp0,fb.top
     6764 A600 
0030 6766 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     6768 A100 
0031 676A 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     676C A104 
0032 676E 04E0  34         clr   @fb.row               ; Current row=0
     6770 A106 
0033 6772 04E0  34         clr   @fb.column            ; Current column=0
     6774 A10C 
0034               
0035 6776 0204  20         li    tmp0,80
     6778 0050 
0036 677A C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     677C A10E 
0037               
0038 677E 0204  20         li    tmp0,29
     6780 001D 
0039 6782 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     6784 A118 
0040 6786 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6788 A11A 
0041               
0042 678A 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     678C A016 
0043 678E 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     6790 A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 6792 06A0  32         bl    @film
     6794 2218 
0048 6796 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     6798 0000 
     679A 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 679C 0460  28         b     @poprt                ; Return to caller
     679E 2214 
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
0078 67A0 0649  14         dect  stack
0079 67A2 C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67A4 C120  34         mov   @parm1,tmp0
     67A6 8350 
0084 67A8 A120  34         a     @fb.topline,tmp0
     67AA A104 
0085 67AC C804  38         mov   tmp0,@outparm1
     67AE 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67B0 0460  28         b    @poprt                 ; Return to caller
     67B2 2214 
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
0118 67B4 0649  14         dect  stack
0119 67B6 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 67B8 C1A0  34         mov   @fb.row,tmp2
     67BA A106 
0124 67BC 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     67BE A10E 
0125 67C0 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     67C2 A10C 
0126 67C4 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     67C6 A100 
0127 67C8 C807  38         mov   tmp3,@fb.current
     67CA A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 67CC 0460  28         b    @poprt                 ; Return to caller
     67CE 2214 
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
0153 67D0 0649  14         dect  stack
0154 67D2 C64B  30         mov   r11,*stack            ; Push return address
0155 67D4 0649  14         dect  stack
0156 67D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0157 67D8 0649  14         dect  stack
0158 67DA C645  30         mov   tmp1,*stack           ; Push tmp1
0159 67DC 0649  14         dect  stack
0160 67DE C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 67E0 C820  54         mov   @parm1,@fb.topline
     67E2 8350 
     67E4 A104 
0165 67E6 04E0  34         clr   @parm2                ; Target row in frame buffer
     67E8 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 67EA 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     67EC 8350 
     67EE A204 
0170 67F0 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 67F2 06A0  32         bl    @edb.line.unpack      ; Unpack line
     67F4 6B90 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 67F6 05A0  34         inc   @parm1                ; Next line in editor buffer
     67F8 8350 
0180 67FA 05A0  34         inc   @parm2                ; Next row in frame buffer
     67FC 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 67FE 8820  54         c     @parm1,@edb.lines
     6800 8350 
     6802 A204 
0185 6804 1113  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 6806 C120  34         mov   @parm2,tmp0           ; Current row
     6808 8352 
0192 680A C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     680C A118 
0193 680E 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 6810 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6812 A10E 
0195               
0196 6814 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 6816 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 6818 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     681A A10E 
0200 681C A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     681E A100 
0201               
0202 6820 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 6822 0205  20         li    tmp1,32               ; Clear with space
     6824 0020 
0204               
0205 6826 06A0  32         bl    @xfilm                ; \ Fill memory
     6828 221E 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 682A 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 682C 8820  54 !       c     @parm2,@fb.scrrows
     682E 8352 
     6830 A118 
0214 6832 11DF  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 6834 0720  34         seto  @fb.dirty             ; Refresh screen
     6836 A116 
0221 6838 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 683A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 683C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 683E C2F9  30         mov   *stack+,r11           ; Pop r11
0225 6840 045B  20         b     *r11                  ; Return to caller
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
0239 6842 0649  14         dect  stack
0240 6844 C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 6846 04E0  34         clr   @fb.column
     6848 A10C 
0245 684A 06A0  32         bl    @fb.calc_pointer
     684C 67B4 
0246 684E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6850 6C72 
0247 6852 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6854 A108 
0248 6856 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 6858 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     685A A102 
0251 685C 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 685E D174  28         movb  *tmp0+,tmp1           ; Get character
0257 6860 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 6862 0285  22         ci    tmp1,>2000            ; Whitespace?
     6864 2000 
0260 6866 1503  14         jgt   fb.get.firstnonblank.match
0261 6868 0606  14         dec   tmp2                  ; Counter--
0262 686A 16F9  14         jne   fb.get.firstnonblank.loop
0263 686C 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 686E 6120  34         s     @fb.current,tmp0      ; Calculate column
     6870 A102 
0269 6872 0604  14         dec   tmp0
0270 6874 C804  38         mov   tmp0,@outparm1        ; Save column
     6876 8360 
0271 6878 D805  38         movb  tmp1,@outparm2        ; Save character
     687A 8362 
0272 687C 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 687E 04E0  34         clr   @outparm1             ; X=0
     6880 8360 
0278 6882 04E0  34         clr   @outparm2             ; Null
     6884 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 6886 0460  28         b    @poprt                 ; Return to caller
     6888 2214 
**** **** ****     > stevie_b1.asm.158774
0047                       copy  "idx.asm"             ; Index management
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
0048               ***************************************************************
0049               idx.init:
0050 688A 0649  14         dect  stack
0051 688C C64B  30         mov   r11,*stack            ; Save return address
0052 688E 0649  14         dect  stack
0053 6890 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 6892 0204  20         li    tmp0,idx.top
     6894 B000 
0058 6896 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6898 A202 
0059               
0060 689A C120  34         mov   @tv.sams.b000,tmp0
     689C A006 
0061 689E C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     68A0 A500 
0062 68A2 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     68A4 A502 
0063 68A6 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     68A8 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 68AA 06A0  32         bl    @film
     68AC 2218 
0068 68AE B000                   data idx.top,>00,idx.size
     68B0 0000 
     68B2 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 68B4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 68B6 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 68B8 045B  20         b     *r11                  ; Return to caller
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
0100 68BA 0649  14         dect  stack
0101 68BC C64B  30         mov   r11,*stack            ; Push return address
0102 68BE 0649  14         dect  stack
0103 68C0 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 68C2 0649  14         dect  stack
0105 68C4 C645  30         mov   tmp1,*stack           ; Push tmp1
0106 68C6 0649  14         dect  stack
0107 68C8 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 68CA C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     68CC A502 
0112 68CE 0205  20         li    tmp1,idx.top
     68D0 B000 
0113               
0114 68D2 C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     68D4 A504 
0115 68D6 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 68D8 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     68DA A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 68DC 0286  22         ci    tmp2,5                ; Crash if too many index pages
     68DE 0005 
0121 68E0 1104  14         jlt   !
0122 68E2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     68E4 FFCE 
0123 68E6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     68E8 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 68EA 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     68EC 24FE 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 68EE 0584  14         inc   tmp0                  ; Next SAMS index page
0132 68F0 0225  22         ai    tmp1,>1000            ; Next memory region
     68F2 1000 
0133 68F4 0606  14         dec   tmp2                  ; Update loop counter
0134 68F6 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 68F8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 68FA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 68FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 68FE C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6900 045B  20         b     *r11                  ; Return to caller
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
0159 6902 0649  14         dect  stack
0160 6904 C64B  30         mov   r11,*stack            ; Push return address
0161 6906 0649  14         dect  stack
0162 6908 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 690A 0649  14         dect  stack
0164 690C C645  30         mov   tmp1,*stack           ; Push tmp1
0165 690E 0649  14         dect  stack
0166 6910 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 6912 0649  14         dect  stack
0168 6914 C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 6916 0205  20         li    tmp1,idx.top
     6918 B000 
0173 691A 0206  20         li    tmp2,5                ; Always 5 pages
     691C 0005 
0174 691E 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6920 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 6922 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 6924 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6926 24FE 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 6928 0225  22         ai    tmp1,>1000            ; Next memory region
     692A 1000 
0185 692C 0606  14         dec   tmp2                  ; Update loop counter
0186 692E 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6930 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 6932 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 6934 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6936 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6938 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 693A 045B  20         b     *r11                  ; Return to caller
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
0220 693C 0649  14         dect  stack
0221 693E C64B  30         mov   r11,*stack            ; Save return address
0222 6940 0649  14         dect  stack
0223 6942 C644  30         mov   tmp0,*stack           ; Push tmp0
0224 6944 0649  14         dect  stack
0225 6946 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6948 0649  14         dect  stack
0227 694A C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 694C C184  18         mov   tmp0,tmp2             ; Line number
0232 694E 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6950 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6952 0800 
0234               
0235 6954 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 6956 0A16  56         sla   tmp2,1                ; line number * 2
0240 6958 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     695A 8360 
0241               
0242 695C A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     695E A502 
0243 6960 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6962 A500 
0244               
0245 6964 130E  14         jeq   idx._samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 6966 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6968 A500 
0251 696A C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in stevie
     696C A006 
0252               
0253 696E C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6970 0205  20         li    tmp1,>b000            ; Memory window for index page
     6972 B000 
0255               
0256 6974 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6976 24FE 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 6978 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     697A A504 
0263 697C 1202  14         jle   idx._samspage.get.exit
0264                                                   ; No, exit
0265 697E C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6980 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               idx._samspage.get.exit:
0270 6982 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 6984 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6986 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6988 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 698A 045B  20         b     *r11                  ; Return to caller
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
0295 698C 0649  14         dect  stack
0296 698E C64B  30         mov   r11,*stack            ; Save return address
0297 6990 0649  14         dect  stack
0298 6992 C644  30         mov   tmp0,*stack           ; Push tmp0
0299 6994 0649  14         dect  stack
0300 6996 C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 6998 C120  34         mov   @parm1,tmp0           ; Get line number
     699A 8350 
0305 699C C160  34         mov   @parm2,tmp1           ; Get pointer
     699E 8352 
0306 69A0 1310  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 69A2 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     69A4 0FFF 
0312 69A6 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 69A8 06E0  34         swpb  @parm3
     69AA 8354 
0317 69AC D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     69AE 8354 
0318                       ;------------------------------------------------------
0319                       ; Update index slot
0320                       ;------------------------------------------------------
0321               idx.entry.update.save:
0322 69B0 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     69B2 693C 
0323                                                   ; \ i  tmp0     = Line number
0324                                                   ; / o  outparm1 = Slot offset in SAMS page
0325               
0326 69B4 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     69B6 8360 
0327 69B8 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     69BA B000 
0328 69BC C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69BE 8360 
0329 69C0 1008  14         jmp   idx.entry.update.exit
0330                       ;------------------------------------------------------
0331                       ; Special handling for "null"-pointer
0332                       ;------------------------------------------------------
0333               idx.entry.update.clear:
0334 69C2 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     69C4 693C 
0335                                                   ; \ i  tmp0     = Line number
0336                                                   ; / o  outparm1 = Slot offset in SAMS page
0337               
0338 69C6 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     69C8 8360 
0339 69CA 04E4  34         clr   @idx.top(tmp0)        ; /
     69CC B000 
0340 69CE C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69D0 8360 
0341                       ;------------------------------------------------------
0342                       ; Exit
0343                       ;------------------------------------------------------
0344               idx.entry.update.exit:
0345 69D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0346 69D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0347 69D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0348 69D8 045B  20         b     *r11                  ; Return to caller
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
0371 69DA 0649  14         dect  stack
0372 69DC C64B  30         mov   r11,*stack            ; Save return address
0373 69DE 0649  14         dect  stack
0374 69E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0375 69E2 0649  14         dect  stack
0376 69E4 C645  30         mov   tmp1,*stack           ; Push tmp1
0377 69E6 0649  14         dect  stack
0378 69E8 C646  30         mov   tmp2,*stack           ; Push tmp2
0379                       ;------------------------------------------------------
0380                       ; Get slot entry
0381                       ;------------------------------------------------------
0382 69EA C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     69EC 8350 
0383               
0384 69EE 06A0  32         bl    @idx._samspage.get    ; Get SAMS page with index slot
     69F0 693C 
0385                                                   ; \ i  tmp0     = Line number
0386                                                   ; / o  outparm1 = Slot offset in SAMS page
0387               
0388 69F2 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     69F4 8360 
0389 69F6 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     69F8 B000 
0390               
0391 69FA 130C  14         jeq   idx.pointer.get.parm.null
0392                                                   ; Skip if index slot empty
0393                       ;------------------------------------------------------
0394                       ; Calculate MSB (SAMS page)
0395                       ;------------------------------------------------------
0396 69FC C185  18         mov   tmp1,tmp2             ; \
0397 69FE 0986  56         srl   tmp2,8                ; / Right align SAMS page
0398                       ;------------------------------------------------------
0399                       ; Calculate LSB (pointer address)
0400                       ;------------------------------------------------------
0401 6A00 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A02 00FF 
0402 6A04 0A45  56         sla   tmp1,4                ; Multiply with 16
0403 6A06 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A08 C000 
0404                       ;------------------------------------------------------
0405                       ; Return parameters
0406                       ;------------------------------------------------------
0407               idx.pointer.get.parm:
0408 6A0A C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A0C 8360 
0409 6A0E C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A10 8362 
0410 6A12 1004  14         jmp   idx.pointer.get.exit
0411                       ;------------------------------------------------------
0412                       ; Special handling for "null"-pointer
0413                       ;------------------------------------------------------
0414               idx.pointer.get.parm.null:
0415 6A14 04E0  34         clr   @outparm1
     6A16 8360 
0416 6A18 04E0  34         clr   @outparm2
     6A1A 8362 
0417                       ;------------------------------------------------------
0418                       ; Exit
0419                       ;------------------------------------------------------
0420               idx.pointer.get.exit:
0421 6A1C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0422 6A1E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0423 6A20 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0424 6A22 C2F9  30         mov   *stack+,r11           ; Pop r11
0425 6A24 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.158774
0048                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0020               *--------------------------------------------------------------
0021               _idx.entry.delete.reorg:
0022                       ;------------------------------------------------------
0023                       ; Reorganize index entries
0024                       ;------------------------------------------------------
0025 6A26 C924  54 !       mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     6A28 B002 
     6A2A B000 
0026 6A2C 05C4  14         inct  tmp0                  ; Next index entry
0027 6A2E 0606  14         dec   tmp2                  ; tmp2--
0028 6A30 16FA  14         jne   -!                    ; Loop unless completed
0029 6A32 045B  20         b     *r11                  ; Return to caller
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
0048 6A34 0649  14         dect  stack
0049 6A36 C64B  30         mov   r11,*stack            ; Save return address
0050 6A38 0649  14         dect  stack
0051 6A3A C644  30         mov   tmp0,*stack           ; Push tmp0
0052 6A3C 0649  14         dect  stack
0053 6A3E C645  30         mov   tmp1,*stack           ; Push tmp1
0054 6A40 0649  14         dect  stack
0055 6A42 C646  30         mov   tmp2,*stack           ; Push tmp2
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6A44 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A46 8350 
0060               
0061 6A48 06A0  32         bl    @idx._samspage.get    ; Get SAMS page for index
     6A4A 693C 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6A4C C120  34         mov   @outparm1,tmp0        ; Index offset
     6A4E 8360 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6A50 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6A52 8352 
0070 6A54 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6A56 8350 
0071 6A58 130D  14         jeq   idx.entry.delete.lastline
0072                                                   ; Special treatment if last line
0073                       ;------------------------------------------------------
0074                       ; Reorganize index entries
0075                       ;------------------------------------------------------
0076               idx.entry.delete.reorg:
0077 6A5A 8820  54         c     @idx.sams.page,@idx.sams.hipage
     6A5C A500 
     6A5E A504 
0078 6A60 1307  14         jeq   idx.entry.delete.reorg.simple
0079                                                   ; If only one SAMS index page or at last
0080                                                   ; SAMS index page then do simple reorg
0081                       ;------------------------------------------------------
0082                       ; Complex index reorganization (multiple SAMS pages)
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg.complex:
0085 6A62 06A0  32         bl    @_idx.sams.mapcolumn.on
     6A64 68BA 
0086                                                   ; Index in continious memory region
0087               
0088 6A66 06A0  32         bl    @_idx.entry.delete.reorg
     6A68 6A26 
0089                                                   ; Reorganize index
0090               
0091               
0092 6A6A 06A0  32         bl    @_idx.sams.mapcolumn.off
     6A6C 6902 
0093                                                   ; Restore memory window layout
0094               
0095 6A6E 1002  14         jmp   idx.entry.delete.lastline
0096                       ;------------------------------------------------------
0097                       ; Simple index reorganization
0098                       ;------------------------------------------------------
0099               idx.entry.delete.reorg.simple:
0100 6A70 06A0  32         bl    @_idx.entry.delete.reorg
     6A72 6A26 
0101                       ;------------------------------------------------------
0102                       ; Last line
0103                       ;------------------------------------------------------
0104               idx.entry.delete.lastline:
0105 6A74 04E4  34         clr   @idx.top(tmp0)
     6A76 B000 
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               idx.entry.delete.exit:
0110 6A78 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0111 6A7A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0112 6A7C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0113 6A7E C2F9  30         mov   *stack+,r11           ; Pop r11
0114 6A80 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.158774
0049                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Stevie Editor - Insert index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
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
0026 6A82 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6A84 8352 
0027                       ;------------------------------------------------------
0028                       ; Calculate address of index entry and save pointer
0029                       ;------------------------------------------------------
0030 6A86 0A14  56         sla   tmp0,1                ; line number * 2
0031                       ;------------------------------------------------------
0032                       ; Prepare for index reorg
0033                       ;------------------------------------------------------
0034 6A88 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6A8A 8352 
0035 6A8C 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6A8E 8350 
0036 6A90 1606  14         jne   idx.entry.insert.reorg
0037                       ;------------------------------------------------------
0038                       ; Special treatment if last line
0039                       ;------------------------------------------------------
0040 6A92 C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6A94 B000 
     6A96 B002 
0041                                                   ; Move index entry
0042 6A98 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     6A9A B000 
0043               
0044 6A9C 1009  14         jmp   idx.entry.insert.exit
0045                       ;------------------------------------------------------
0046                       ; Reorganize index entries
0047                       ;------------------------------------------------------
0048               idx.entry.insert.reorg:
0049 6A9E 05C6  14         inct  tmp2                  ; Adjust one time
0050               
0051 6AA0 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6AA2 B000 
     6AA4 B002 
0052                                                   ; Move index entry
0053               
0054 6AA6 0644  14         dect  tmp0                  ; Previous index entry
0055 6AA8 0606  14         dec   tmp2                  ; tmp2--
0056 6AAA 16FA  14         jne   -!                    ; Loop unless completed
0057               
0058 6AAC 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     6AAE B004 
0059                       ;------------------------------------------------------
0060                       ; Exit
0061                       ;------------------------------------------------------
0062               idx.entry.insert.exit:
0063 6AB0 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.158774
0050                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: stevie Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        stevie Editor - Editor Buffer implementation
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
0026 6AB2 0649  14         dect  stack
0027 6AB4 C64B  30         mov   r11,*stack            ; Save return address
0028 6AB6 0649  14         dect  stack
0029 6AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6ABA 0204  20         li    tmp0,edb.top          ; \
     6ABC C000 
0034 6ABE C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6AC0 A200 
0035 6AC2 C804  38         mov   tmp0,@edb.next_free.ptr
     6AC4 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6AC6 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6AC8 A20A 
0039 6ACA 04E0  34         clr   @edb.lines            ; Lines=0
     6ACC A204 
0040 6ACE 04E0  34         clr   @edb.rle              ; RLE compression off
     6AD0 A20C 
0041               
0042 6AD2 0204  20         li    tmp0,txt.newfile      ; "New file"
     6AD4 74BA 
0043 6AD6 C804  38         mov   tmp0,@edb.filename.ptr
     6AD8 A20E 
0044               
0045 6ADA 0204  20         li    tmp0,txt.filetype.none
     6ADC 7506 
0046 6ADE C804  38         mov   tmp0,@edb.filetype.ptr
     6AE0 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6AE2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6AE4 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6AE6 045B  20         b     *r11                  ; Return to caller
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
0081 6AE8 0649  14         dect  stack
0082 6AEA C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6AEC C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6AEE A10C 
     6AF0 8390 
0087 6AF2 04E0  34         clr   @fb.column
     6AF4 A10C 
0088 6AF6 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6AF8 67B4 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6AFA 04C4  14         clr   tmp0                  ; Counter
0093 6AFC C160  34         mov   @fb.current,tmp1      ; Get position
     6AFE A102 
0094 6B00 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6B02 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6B04 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6B06 0986  56         srl   tmp2,8                ; Right justify
0102 6B08 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6B0A 0584  14         inc   tmp0                  ; Increase string length
0104 6B0C 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6B0E C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6B10 A104 
     6B12 8350 
0111 6B14 A820  54         a     @fb.row,@parm1        ; /
     6B16 A106 
     6B18 8350 
0112               
0113 6B1A C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6B1C 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6B1E C120  34         mov   @edb.next_free.ptr,tmp0
     6B20 A208 
0120 6B22 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6B24 8352 
0121               
0122 6B26 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6B28 24C6 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6B2A C820  54         mov   @waux1,@parm3
     6B2C 833C 
     6B2E 8354 
0128 6B30 06A0  32         bl    @idx.entry.update     ; Update index
     6B32 698C 
0129                                                   ; \ i  parm1 = Line number in editor buffer
0130                                                   ; | i  parm2 = pointer to line in
0131                                                   ; |            editor buffer
0132                                                   ; / i  parm3 = SAMS page
0133               
0134                       ;------------------------------------------------------
0135                       ; 2. Switch to required SAMS page
0136                       ;------------------------------------------------------
0137 6B34 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6B36 A212 
     6B38 8354 
0138 6B3A 1308  14         jeq   !                     ; Yes, skip setting page
0139               
0140 6B3C C120  34         mov   @parm3,tmp0           ; get SAMS page
     6B3E 8354 
0141 6B40 C160  34         mov   @edb.next_free.ptr,tmp1
     6B42 A208 
0142                                                   ; Pointer to line in editor buffer
0143 6B44 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6B46 24FE 
0144                                                   ; \ i  tmp0 = SAMS page
0145                                                   ; / i  tmp1 = Memory address
0146               
0147 6B48 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6B4A A438 
0148               
0149                       ;------------------------------------------------------
0150                       ; 3. Set line prefix in editor buffer
0151                       ;------------------------------------------------------
0152 6B4C C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6B4E 8392 
0153 6B50 C160  34         mov   @edb.next_free.ptr,tmp1
     6B52 A208 
0154                                                   ; Address of line in editor buffer
0155               
0156 6B54 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6B56 A208 
0157               
0158 6B58 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6B5A 8394 
0159 6B5C 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0160 6B5E 06C6  14         swpb  tmp2
0161 6B60 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0162 6B62 06C6  14         swpb  tmp2
0163 6B64 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0164               
0165                       ;------------------------------------------------------
0166                       ; 4. Copy line from framebuffer to editor buffer
0167                       ;------------------------------------------------------
0168               edb.line.pack.copyline:
0169 6B66 0286  22         ci    tmp2,2
     6B68 0002 
0170 6B6A 1603  14         jne   edb.line.pack.copyline.checkbyte
0171 6B6C DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0172 6B6E DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0173 6B70 1007  14         jmp   !
0174               edb.line.pack.copyline.checkbyte:
0175 6B72 0286  22         ci    tmp2,1
     6B74 0001 
0176 6B76 1602  14         jne   edb.line.pack.copyline.block
0177 6B78 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0178 6B7A 1002  14         jmp   !
0179               edb.line.pack.copyline.block:
0180 6B7C 06A0  32         bl    @xpym2m               ; Copy memory block
     6B7E 2468 
0181                                                   ; \ i  tmp0 = source
0182                                                   ; | i  tmp1 = destination
0183                                                   ; / i  tmp2 = bytes to copy
0184               
0185 6B80 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6B82 8394 
     6B84 A208 
0186                                                   ; Update pointer to next free line
0187               
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191               edb.line.pack.exit:
0192 6B86 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6B88 8390 
     6B8A A10C 
0193 6B8C 0460  28         b     @poprt                ; Return to caller
     6B8E 2214 
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
0222 6B90 0649  14         dect  stack
0223 6B92 C64B  30         mov   r11,*stack            ; Save return address
0224 6B94 0649  14         dect  stack
0225 6B96 C644  30         mov   tmp0,*stack           ; Push tmp0
0226 6B98 0649  14         dect  stack
0227 6B9A C645  30         mov   tmp1,*stack           ; Push tmp1
0228 6B9C 0649  14         dect  stack
0229 6B9E C646  30         mov   tmp2,*stack           ; Push tmp2
0230                       ;------------------------------------------------------
0231                       ; Sanity check
0232                       ;------------------------------------------------------
0233 6BA0 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6BA2 8350 
     6BA4 A204 
0234 6BA6 1104  14         jlt   !
0235 6BA8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BAA FFCE 
0236 6BAC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BAE 2030 
0237                       ;------------------------------------------------------
0238                       ; Save parameters
0239                       ;------------------------------------------------------
0240 6BB0 C820  54 !       mov   @parm1,@rambuf
     6BB2 8350 
     6BB4 8390 
0241 6BB6 C820  54         mov   @parm2,@rambuf+2
     6BB8 8352 
     6BBA 8392 
0242                       ;------------------------------------------------------
0243                       ; Calculate offset in frame buffer
0244                       ;------------------------------------------------------
0245 6BBC C120  34         mov   @fb.colsline,tmp0
     6BBE A10E 
0246 6BC0 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6BC2 8352 
0247 6BC4 C1A0  34         mov   @fb.top.ptr,tmp2
     6BC6 A100 
0248 6BC8 A146  18         a     tmp2,tmp1             ; Add base to offset
0249 6BCA C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6BCC 8396 
0250                       ;------------------------------------------------------
0251                       ; Get pointer to line & page-in editor buffer page
0252                       ;------------------------------------------------------
0253 6BCE C120  34         mov   @parm1,tmp0
     6BD0 8350 
0254 6BD2 06A0  32         bl    @xmem.edb.sams.mappage
     6BD4 671E 
0255                                                   ; Activate editor buffer SAMS page for line
0256                                                   ; \ i  tmp0     = Line number
0257                                                   ; | o  outparm1 = Pointer to line
0258                                                   ; / o  outparm2 = SAMS page
0259               
0260 6BD6 C820  54         mov   @outparm2,@edb.sams.page
     6BD8 8362 
     6BDA A212 
0261                                                   ; Save current SAMS page
0262                       ;------------------------------------------------------
0263                       ; Handle empty line
0264                       ;------------------------------------------------------
0265 6BDC C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6BDE 8360 
0266 6BE0 1603  14         jne   !                     ; Check if pointer is set
0267 6BE2 04E0  34         clr   @rambuf+8             ; Set length=0
     6BE4 8398 
0268 6BE6 100F  14         jmp   edb.line.unpack.clear
0269                       ;------------------------------------------------------
0270                       ; Get line length
0271                       ;------------------------------------------------------
0272 6BE8 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0273 6BEA C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6BEC 8398 
0274               
0275 6BEE 05E0  34         inct  @outparm1             ; Skip line prefix
     6BF0 8360 
0276 6BF2 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6BF4 8360 
     6BF6 8394 
0277                       ;------------------------------------------------------
0278                       ; Sanity check on line length
0279                       ;------------------------------------------------------
0280 6BF8 0285  22         ci    tmp1,80               ; Sanity check on line length, crash
     6BFA 0050 
0281 6BFC 1204  14         jle   edb.line.unpack.clear ; if length > 80.
0282 6BFE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C00 FFCE 
0283 6C02 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C04 2030 
0284                       ;------------------------------------------------------
0285                       ; Erase chars from last column until column 80
0286                       ;------------------------------------------------------
0287               edb.line.unpack.clear:
0288 6C06 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6C08 8396 
0289 6C0A A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6C0C 8398 
0290               
0291 6C0E 04C5  14         clr   tmp1                  ; Fill with >00
0292 6C10 C1A0  34         mov   @fb.colsline,tmp2
     6C12 A10E 
0293 6C14 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6C16 8398 
0294 6C18 0586  14         inc   tmp2
0295               
0296 6C1A 06A0  32         bl    @xfilm                ; Fill CPU memory
     6C1C 221E 
0297                                                   ; \ i  tmp0 = Target address
0298                                                   ; | i  tmp1 = Byte to fill
0299                                                   ; / i  tmp2 = Repeat count
0300                       ;------------------------------------------------------
0301                       ; Prepare for unpacking data
0302                       ;------------------------------------------------------
0303               edb.line.unpack.prepare:
0304 6C1E C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6C20 8398 
0305 6C22 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0306 6C24 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6C26 8394 
0307 6C28 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6C2A 8396 
0308                       ;------------------------------------------------------
0309                       ; Check before copy
0310                       ;------------------------------------------------------
0311               edb.line.unpack.copy:
0312 6C2C 0286  22         ci    tmp2,80               ; Check line length
     6C2E 0050 
0313 6C30 1204  14         jle   !
0314 6C32 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C34 FFCE 
0315 6C36 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C38 2030 
0316                       ;------------------------------------------------------
0317                       ; Copy memory block
0318                       ;------------------------------------------------------
0319 6C3A 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6C3C 2468 
0320                                                   ; \ i  tmp0 = Source address
0321                                                   ; | i  tmp1 = Target address
0322                                                   ; / i  tmp2 = Bytes to copy
0323                       ;------------------------------------------------------
0324                       ; Exit
0325                       ;------------------------------------------------------
0326               edb.line.unpack.exit:
0327 6C3E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0328 6C40 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0329 6C42 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0330 6C44 C2F9  30         mov   *stack+,r11           ; Pop r11
0331 6C46 045B  20         b     *r11                  ; Return to caller
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
0355 6C48 0649  14         dect  stack
0356 6C4A C64B  30         mov   r11,*stack            ; Push return address
0357 6C4C 0649  14         dect  stack
0358 6C4E C644  30         mov   tmp0,*stack           ; Push tmp0
0359 6C50 0649  14         dect  stack
0360 6C52 C645  30         mov   tmp1,*stack           ; Push tmp1
0361                       ;------------------------------------------------------
0362                       ; Initialisation
0363                       ;------------------------------------------------------
0364 6C54 04E0  34         clr   @outparm1             ; Reset length
     6C56 8360 
0365 6C58 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6C5A 8362 
0366                       ;------------------------------------------------------
0367                       ; Get length
0368                       ;------------------------------------------------------
0369 6C5C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6C5E 69DA 
0370                                                   ; \ i  parm1    = Line number
0371                                                   ; | o  outparm1 = Pointer to line
0372                                                   ; / o  outparm2 = SAMS page
0373               
0374 6C60 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6C62 8360 
0375 6C64 1302  14         jeq   edb.line.getlength.exit
0376                                                   ; Exit early if NULL pointer
0377                       ;------------------------------------------------------
0378                       ; Process line prefix
0379                       ;------------------------------------------------------
0380 6C66 C814  46         mov   *tmp0,@outparm1       ; Save length
     6C68 8360 
0381                       ;------------------------------------------------------
0382                       ; Exit
0383                       ;------------------------------------------------------
0384               edb.line.getlength.exit:
0385 6C6A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0386 6C6C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0387 6C6E C2F9  30         mov   *stack+,r11           ; Pop r11
0388 6C70 045B  20         b     *r11                  ; Return to caller
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
0408 6C72 0649  14         dect  stack
0409 6C74 C64B  30         mov   r11,*stack            ; Save return address
0410                       ;------------------------------------------------------
0411                       ; Calculate line in editor buffer
0412                       ;------------------------------------------------------
0413 6C76 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6C78 A104 
0414 6C7A A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6C7C A106 
0415                       ;------------------------------------------------------
0416                       ; Get length
0417                       ;------------------------------------------------------
0418 6C7E C804  38         mov   tmp0,@parm1
     6C80 8350 
0419 6C82 06A0  32         bl    @edb.line.getlength
     6C84 6C48 
0420 6C86 C820  54         mov   @outparm1,@fb.row.length
     6C88 8360 
     6C8A A108 
0421                                                   ; Save row length
0422                       ;------------------------------------------------------
0423                       ; Exit
0424                       ;------------------------------------------------------
0425               edb.line.getlength2.exit:
0426 6C8C 0460  28         b     @poprt                ; Return to caller
     6C8E 2214 
0427               
**** **** ****     > stevie_b1.asm.158774
0051                       copy  "cmdb.asm"            ; Command Buffer
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
0027 6C90 0649  14         dect  stack
0028 6C92 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6C94 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6C96 D000 
0033 6C98 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6C9A A300 
0034               
0035 6C9C 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6C9E A302 
0036 6CA0 0204  20         li    tmp0,10
     6CA2 000A 
0037 6CA4 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6CA6 A304 
0038 6CA8 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6CAA A306 
0039               
0040 6CAC 0204  20         li    tmp0,>1b02            ; Y=27, X=2
     6CAE 1B02 
0041 6CB0 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6CB2 A308 
0042               
0043 6CB4 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6CB6 A30E 
0044 6CB8 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6CBA A310 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6CBC 06A0  32         bl    @film
     6CBE 2218 
0049 6CC0 D000             data  cmdb.top,>00,cmdb.size
     6CC2 0000 
     6CC4 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6CC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6CC8 045B  20         b     *r11                  ; Return to caller
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
0082 6CCA 0649  14         dect  stack
0083 6CCC C64B  30         mov   r11,*stack            ; Save return address
0084 6CCE 0649  14         dect  stack
0085 6CD0 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6CD2 0649  14         dect  stack
0087 6CD4 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6CD6 0649  14         dect  stack
0089 6CD8 C646  30         mov   tmp2,*stack           ; Push tmp2
0090                       ;------------------------------------------------------
0091                       ; Dump Command buffer content
0092                       ;------------------------------------------------------
0093 6CDA C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6CDC 832A 
     6CDE A30A 
0094               
0095 6CE0 C820  54         mov   @cmdb.yxtop,@wyx
     6CE2 A30C 
     6CE4 832A 
0096 6CE6 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6CE8 23DC 
0097               
0098 6CEA C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6CEC A300 
0099 6CEE 0206  20         li    tmp2,9*80
     6CF0 02D0 
0100               
0101 6CF2 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6CF4 2420 
0102                                                   ; | i  tmp0 = VDP target address
0103                                                   ; | i  tmp1 = RAM source address
0104                                                   ; / i  tmp2 = Number of bytes to copy
0105               
0106                       ;------------------------------------------------------
0107                       ; Show command buffer prompt
0108                       ;------------------------------------------------------
0109 6CF6 06A0  32         bl    @putat
     6CF8 2412 
0110 6CFA 1B01                   byte 27,1
0111 6CFC 74C6                   data txt.cmdb.prompt
0112               
0113 6CFE C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6D00 A30A 
     6D02 A114 
0114 6D04 C820  54         mov   @cmdb.yxsave,@wyx
     6D06 A30A 
     6D08 832A 
0115                                                   ; Restore YX position
0116               cmdb.refresh.exit:
0117                       ;------------------------------------------------------
0118                       ; Exit
0119                       ;------------------------------------------------------
0120 6D0A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6D0C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6D0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6D10 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6D12 045B  20         b     *r11                  ; Return to caller
0125               
**** **** ****     > stevie_b1.asm.158774
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
0031 6D14 0649  14         dect  stack
0032 6D16 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6D18 04E0  34         clr   @fh.rleonload         ; No RLE compression!
     6D1A A444 
0037 6D1C 04E0  34         clr   @fh.records           ; Reset records counter
     6D1E A42E 
0038 6D20 04E0  34         clr   @fh.counter           ; Clear internal counter
     6D22 A434 
0039 6D24 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6D26 A432 
0040 6D28 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 6D2A 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6D2C A42A 
0042 6D2E 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6D30 A42C 
0043               
0044 6D32 C120  34         mov   @edb.top.ptr,tmp0
     6D34 A200 
0045 6D36 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6D38 24C6 
0046                                                   ; \ i  tmp0  = Memory address
0047                                                   ; | o  waux1 = SAMS page number
0048                                                   ; / o  waux2 = Address of SAMS register
0049               
0050 6D3A C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6D3C 833C 
     6D3E A438 
0051 6D40 C820  54         mov   @waux1,@fh.sams.hipage
     6D42 833C 
     6D44 A43A 
0052                                                   ; Set highest SAMS page in use
0053                       ;------------------------------------------------------
0054                       ; Save parameters / callback functions
0055                       ;------------------------------------------------------
0056 6D46 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6D48 8350 
     6D4A A436 
0057 6D4C C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
     6D4E 8352 
     6D50 A43C 
0058 6D52 C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
     6D54 8354 
     6D56 A43E 
0059 6D58 C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
     6D5A 8356 
     6D5C A440 
0060 6D5E C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
     6D60 8358 
     6D62 A442 
0061                       ;------------------------------------------------------
0062                       ; Sanity check
0063                       ;------------------------------------------------------
0064 6D64 C120  34         mov   @fh.callback1,tmp0
     6D66 A43C 
0065 6D68 0284  22         ci    tmp0,>6000            ; Insane address ?
     6D6A 6000 
0066 6D6C 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0067               
0068 6D6E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6D70 7FFF 
0069 6D72 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0070               
0071 6D74 C120  34         mov   @fh.callback2,tmp0
     6D76 A43E 
0072 6D78 0284  22         ci    tmp0,>6000            ; Insane address ?
     6D7A 6000 
0073 6D7C 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0074               
0075 6D7E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6D80 7FFF 
0076 6D82 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0077               
0078 6D84 C120  34         mov   @fh.callback3,tmp0
     6D86 A440 
0079 6D88 0284  22         ci    tmp0,>6000            ; Insane address ?
     6D8A 6000 
0080 6D8C 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0081               
0082 6D8E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6D90 7FFF 
0083 6D92 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0084               
0085 6D94 1004  14         jmp   fh.file.read.sams.load1
0086                                                   ; All checks passed, continue.
0087                                                   ;--------------------------
0088                                                   ; Check failed, crash CPU!
0089                                                   ;--------------------------
0090               fh.file.read.crash:
0091 6D96 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D98 FFCE 
0092 6D9A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D9C 2030 
0093                       ;------------------------------------------------------
0094                       ; Show "loading indicator 1"
0095                       ;------------------------------------------------------
0096               fh.file.read.sams.load1:
0097 6D9E C120  34         mov   @fh.callback1,tmp0
     6DA0 A43C 
0098 6DA2 0694  24         bl    *tmp0                 ; Run callback function
0099                       ;------------------------------------------------------
0100                       ; Copy PAB header to VDP
0101                       ;------------------------------------------------------
0102               fh.file.read.sams.pabheader:
0103 6DA4 06A0  32         bl    @cpym2v
     6DA6 241A 
0104 6DA8 0A60                   data fh.vpab,fh.file.pab.header,9
     6DAA 6EFA 
     6DAC 0009 
0105                                                   ; Copy PAB header to VDP
0106                       ;------------------------------------------------------
0107                       ; Append file descriptor to PAB header in VDP
0108                       ;------------------------------------------------------
0109 6DAE 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6DB0 0A69 
0110 6DB2 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6DB4 A436 
0111 6DB6 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0112 6DB8 0986  56         srl   tmp2,8                ; Right justify
0113 6DBA 0586  14         inc   tmp2                  ; Include length byte as well
0114 6DBC 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6DBE 2420 
0115                       ;------------------------------------------------------
0116                       ; Load GPL scratchpad layout
0117                       ;------------------------------------------------------
0118 6DC0 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6DC2 2AA4 
0119 6DC4 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0120                       ;------------------------------------------------------
0121                       ; Open file
0122                       ;------------------------------------------------------
0123 6DC6 06A0  32         bl    @file.open
     6DC8 2BF2 
0124 6DCA 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0125 6DCC 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6DCE 2026 
0126 6DD0 1602  14         jne   fh.file.read.sams.record
0127 6DD2 0460  28         b     @fh.file.read.sams.error
     6DD4 6EC4 
0128                                                   ; Yes, IO error occured
0129                       ;------------------------------------------------------
0130                       ; Step 1: Read file record
0131                       ;------------------------------------------------------
0132               fh.file.read.sams.record:
0133 6DD6 05A0  34         inc   @fh.records           ; Update counter
     6DD8 A42E 
0134 6DDA 04E0  34         clr   @fh.reclen            ; Reset record length
     6DDC A430 
0135               
0136 6DDE 06A0  32         bl    @file.record.read     ; Read file record
     6DE0 2C34 
0137 6DE2 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0138                                                   ; |           (without +9 offset!)
0139                                                   ; | o  tmp0 = Status byte
0140                                                   ; | o  tmp1 = Bytes read
0141                                                   ; | o  tmp2 = Status register contents
0142                                                   ; /           upon DSRLNK return
0143               
0144 6DE4 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6DE6 A42A 
0145 6DE8 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6DEA A430 
0146 6DEC C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6DEE A42C 
0147                       ;------------------------------------------------------
0148                       ; 1a: Calculate kilobytes processed
0149                       ;------------------------------------------------------
0150 6DF0 A805  38         a     tmp1,@fh.counter
     6DF2 A434 
0151 6DF4 A160  34         a     @fh.counter,tmp1
     6DF6 A434 
0152 6DF8 0285  22         ci    tmp1,1024
     6DFA 0400 
0153 6DFC 1106  14         jlt   !
0154 6DFE 05A0  34         inc   @fh.kilobytes
     6E00 A432 
0155 6E02 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6E04 FC00 
0156 6E06 C805  38         mov   tmp1,@fh.counter
     6E08 A434 
0157                       ;------------------------------------------------------
0158                       ; 1b: Load spectra scratchpad layout
0159                       ;------------------------------------------------------
0160 6E0A 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6E0C 2A2A 
0161 6E0E 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E10 2AC6 
0162 6E12 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0163                       ;------------------------------------------------------
0164                       ; 1c: Check if a file error occured
0165                       ;------------------------------------------------------
0166               fh.file.read.sams.check_fioerr:
0167 6E14 C1A0  34         mov   @fh.ioresult,tmp2
     6E16 A42C 
0168 6E18 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6E1A 2026 
0169 6E1C 1602  14         jne   fh.file.read.sams.check_setpage
0170                                                   ; No, goto (1d)
0171 6E1E 0460  28         b     @fh.file.read.sams.error
     6E20 6EC4 
0172                                                   ; Yes, so handle file error
0173                       ;------------------------------------------------------
0174                       ; 1d: Check if SAMS page needs to be set
0175                       ;------------------------------------------------------
0176               fh.file.read.sams.check_setpage:
0177 6E22 C120  34         mov   @edb.next_free.ptr,tmp0
     6E24 A208 
0178                                                   ;--------------------------
0179                                                   ; Sanity check
0180                                                   ;--------------------------
0181 6E26 0284  22         ci    tmp0,edb.top + edb.size
     6E28 D000 
0182                                                   ; Insane address ?
0183 6E2A 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0184                                                   ;--------------------------
0185                                                   ; Check overflow
0186                                                   ;--------------------------
0187 6E2C 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6E2E 0FFF 
0188 6E30 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6E32 A430 
0189 6E34 05C4  14         inct  tmp0                  ; +2 for line prefix
0190 6E36 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6E38 0FF0 
0191 6E3A 110E  14         jlt   fh.file.read.sams.process_line
0192                                                   ; Not yet so skip SAMS page switch
0193                       ;------------------------------------------------------
0194                       ; 1e: Increase SAMS page
0195                       ;------------------------------------------------------
0196 6E3C 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6E3E A438 
0197 6E40 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6E42 A438 
     6E44 A43A 
0198                                                   ; Set highest SAMS page
0199 6E46 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6E48 A200 
     6E4A A208 
0200                                                   ; Start at top of SAMS page again
0201                       ;------------------------------------------------------
0202                       ; 1f: Switch to SAMS page
0203                       ;------------------------------------------------------
0204 6E4C C120  34         mov   @fh.sams.page,tmp0
     6E4E A438 
0205 6E50 C160  34         mov   @edb.top.ptr,tmp1
     6E52 A200 
0206 6E54 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E56 24FE 
0207                                                   ; \ i  tmp0 = SAMS page number
0208                                                   ; / i  tmp1 = Memory address
0209                       ;------------------------------------------------------
0210                       ; Step 2: Process line
0211                       ;------------------------------------------------------
0212               fh.file.read.sams.process_line:
0213 6E58 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6E5A 0960 
0214 6E5C C160  34         mov   @edb.next_free.ptr,tmp1
     6E5E A208 
0215                                                   ; RAM target in editor buffer
0216               
0217 6E60 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6E62 8352 
0218               
0219 6E64 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6E66 A430 
0220 6E68 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0221                                                   ; Handle empty line
0222                       ;------------------------------------------------------
0223                       ; 2a: Copy line from VDP to CPU editor buffer
0224                       ;------------------------------------------------------
0225                                                   ; Put line length word before string
0226 6E6A DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0227 6E6C 06C6  14         swpb  tmp2                  ; |
0228 6E6E DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0229 6E70 06C6  14         swpb  tmp2                  ; /
0230               
0231 6E72 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6E74 A208 
0232 6E76 A806  38         a     tmp2,@edb.next_free.ptr
     6E78 A208 
0233                                                   ; Add line length
0234               
0235 6E7A 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6E7C 2446 
0236                                                   ; \ i  tmp0 = VDP source address
0237                                                   ; | i  tmp1 = RAM target address
0238                                                   ; / i  tmp2 = Bytes to copy
0239               
0240                       ;------------------------------------------------------
0241                       ; 2b: Align pointer to multiple of 16 memory address
0242                       ;------------------------------------------------------
0243 6E7E C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6E80 A208 
0244 6E82 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0245 6E84 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6E86 000F 
0246 6E88 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6E8A A208 
0247               
0248               
0249                       ;------------------------------------------------------
0250                       ; Step 3: Update index
0251                       ;------------------------------------------------------
0252               fh.file.read.sams.prepindex:
0253 6E8C C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6E8E A204 
     6E90 8350 
0254                                                   ; parm2 = Must allready be set!
0255 6E92 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6E94 A438 
     6E96 8354 
0256               
0257 6E98 1009  14         jmp   fh.file.read.sams.updindex
0258                                                   ; Update index
0259                       ;------------------------------------------------------
0260                       ; 3a: Special handling for empty line
0261                       ;------------------------------------------------------
0262               fh.file.read.sams.prepindex.emptyline:
0263 6E9A C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6E9C A42E 
     6E9E 8350 
0264 6EA0 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6EA2 8350 
0265 6EA4 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6EA6 8352 
0266 6EA8 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6EAA 8354 
0267                       ;------------------------------------------------------
0268                       ; 3b: Do actual index update
0269                       ;------------------------------------------------------
0270               fh.file.read.sams.updindex:
0271 6EAC 06A0  32         bl    @idx.entry.update     ; Update index
     6EAE 698C 
0272                                                   ; \ i  parm1    = Line num in editor buffer
0273                                                   ; | i  parm2    = Pointer to line in editor
0274                                                   ; |               buffer
0275                                                   ; | i  parm3    = SAMS page
0276                                                   ; | o  outparm1 = Pointer to updated index
0277                                                   ; /               entry
0278               
0279 6EB0 05A0  34         inc   @edb.lines            ; lines=lines+1
     6EB2 A204 
0280                       ;------------------------------------------------------
0281                       ; Step 4: Display results
0282                       ;------------------------------------------------------
0283               fh.file.read.sams.display:
0284 6EB4 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6EB6 A43E 
0285 6EB8 0694  24         bl    *tmp0                 ; Run callback function
0286                       ;------------------------------------------------------
0287                       ; 4a: Next record
0288                       ;------------------------------------------------------
0289               fh.file.read.sams.next:
0290 6EBA 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6EBC 2AA4 
0291 6EBE 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0292               
0293 6EC0 0460  28         b     @fh.file.read.sams.record
     6EC2 6DD6 
0294                                                   ; Next record
0295                       ;------------------------------------------------------
0296                       ; Error handler
0297                       ;------------------------------------------------------
0298               fh.file.read.sams.error:
0299 6EC4 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6EC6 A42A 
0300 6EC8 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0301 6ECA 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6ECC 0005 
0302 6ECE 1309  14         jeq   fh.file.read.sams.eof
0303                                                   ; All good. File closed by DSRLNK
0304                       ;------------------------------------------------------
0305                       ; File error occured
0306                       ;------------------------------------------------------
0307 6ED0 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6ED2 2AC6 
0308 6ED4 3F00                   data scrpad.backup2   ; / >2100->8300
0309               
0310 6ED6 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6ED8 6708 
0311               
0312 6EDA C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
     6EDC A442 
0313 6EDE 0694  24         bl    *tmp0                 ; Run callback function
0314 6EE0 100A  14         jmp   fh.file.read.sams.exit
0315                       ;------------------------------------------------------
0316                       ; End-Of-File reached
0317                       ;------------------------------------------------------
0318               fh.file.read.sams.eof:
0319 6EE2 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6EE4 2AC6 
0320 6EE6 3F00                   data scrpad.backup2   ; / >2100->8300
0321               
0322 6EE8 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6EEA 6708 
0323                       ;------------------------------------------------------
0324                       ; Show "loading indicator 3" (final)
0325                       ;------------------------------------------------------
0326 6EEC 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     6EEE A206 
0327               
0328 6EF0 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
     6EF2 A440 
0329 6EF4 0694  24         bl    *tmp0                 ; Run callback function
0330               *--------------------------------------------------------------
0331               * Exit
0332               *--------------------------------------------------------------
0333               fh.file.read.sams.exit:
0334 6EF6 0460  28         b     @poprt                ; Return to caller
     6EF8 2214 
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
0345 6EFA 0014             byte  io.op.open            ;  0    - OPEN
0346                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0347 6EFC 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0348 6EFE 5000             byte  80                    ;  4    - Record length (80 chars max)
0349                       byte  00                    ;  5    - Character count
0350 6F00 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0351 6F02 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0352                       ;------------------------------------------------------
0353                       ; File descriptor part (variable length)
0354                       ;------------------------------------------------------
0355                       ; byte  12                  ;  9    - File descriptor length
0356                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0357                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.158774
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
0014 6F04 0649  14         dect  stack
0015 6F06 C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6F08 C804  38         mov   tmp0,@parm1           ; Setup file to load
     6F0A 8350 
0018 6F0C 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6F0E 6AB2 
0019 6F10 06A0  32         bl    @idx.init             ; Initialize index
     6F12 688A 
0020 6F14 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6F16 675E 
0021 6F18 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6F1A 72A0 
0022 6F1C C820  54         mov   @parm1,@edb.filename.ptr
     6F1E 8350 
     6F20 A20E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6F22 06A0  32         bl    @filv
     6F24 2270 
0028 6F26 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6F28 0000 
     6F2A 0004 
0029               
0030 6F2C C160  34         mov   @fb.scrrows,tmp1
     6F2E A118 
0031 6F30 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6F32 A10E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6F34 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0035 6F36 0205  20         li    tmp1,32               ; Character to fill
     6F38 0020 
0036               
0037 6F3A 06A0  32         bl    @xfilv                ; Fill VDP memory
     6F3C 2276 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6F3E 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     6F40 6F72 
0045 6F42 C804  38         mov   tmp0,@parm2           ; Register callback 1
     6F44 8352 
0046               
0047 6F46 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     6F48 6FAA 
0048 6F4A C804  38         mov   tmp0,@parm3           ; Register callback 2
     6F4C 8354 
0049               
0050 6F4E 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     6F50 6FDC 
0051 6F52 C804  38         mov   tmp0,@parm4           ; Register callback 3
     6F54 8356 
0052               
0053 6F56 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     6F58 700E 
0054 6F5A C804  38         mov   tmp0,@parm5           ; Register callback 4
     6F5C 8358 
0055               
0056 6F5E 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6F60 6D14 
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
0068 6F62 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6F64 A206 
0069                                                   ; longer dirty.
0070               
0071 6F66 0204  20         li    tmp0,txt.filetype.DV80
     6F68 74FA 
0072 6F6A C804  38         mov   tmp0,@edb.filetype.ptr
     6F6C A210 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6F6E 0460  28         b     @poprt                ; Return to caller
     6F70 2214 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               *---------------------------------------------------------------
0085               * Is expected to be passed as parm2 to @tfh.file.read
0086               *---------------------------------------------------------------
0087               fm.loadfile.callback.indicator1:
0088 6F72 0649  14         dect  stack
0089 6F74 C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Show loading indicators and file descriptor
0092                       ;------------------------------------------------------
0093 6F76 06A0  32         bl    @hchar
     6F78 2744 
0094 6F7A 1D03                   byte 29,3,32,77
     6F7C 204D 
0095 6F7E FFFF                   data EOL
0096               
0097 6F80 06A0  32         bl    @putat
     6F82 2412 
0098 6F84 1D03                   byte 29,3
0099 6F86 7472                   data txt.loading      ; Display "Loading...."
0100               
0101 6F88 8820  54         c     @fh.rleonload,@w$ffff
     6F8A A444 
     6F8C 202C 
0102 6F8E 1604  14         jne   !
0103 6F90 06A0  32         bl    @putat
     6F92 2412 
0104 6F94 1D44                   byte 29,68
0105 6F96 7482                   data txt.rle          ; Display "RLE"
0106               
0107 6F98 06A0  32 !       bl    @at
     6F9A 2650 
0108 6F9C 1D0E                   byte 29,14            ; Cursor YX position
0109 6F9E C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     6FA0 8350 
0110 6FA2 06A0  32         bl    @xutst0               ; Display device/filename
     6FA4 2402 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.callback.indicator1.exit:
0115 6FA6 0460  28         b     @poprt                ; Return to caller
     6FA8 2214 
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
0126 6FAA 0649  14         dect  stack
0127 6FAC C64B  30         mov   r11,*stack            ; Save return address
0128               
0129 6FAE 06A0  32         bl    @putnum
     6FB0 2A20 
0130 6FB2 1D4B                   byte 29,75            ; Show lines read
0131 6FB4 A204                   data edb.lines,rambuf,>3020
     6FB6 8390 
     6FB8 3020 
0132               
0133 6FBA 8220  34         c     @fh.kilobytes,tmp4
     6FBC A432 
0134 6FBE 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0135               
0136 6FC0 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     6FC2 A432 
0137               
0138 6FC4 06A0  32         bl    @putnum
     6FC6 2A20 
0139 6FC8 1D38                   byte 29,56            ; Show kilobytes read
0140 6FCA A432                   data fh.kilobytes,rambuf,>3020
     6FCC 8390 
     6FCE 3020 
0141               
0142 6FD0 06A0  32         bl    @putat
     6FD2 2412 
0143 6FD4 1D3D                   byte 29,61
0144 6FD6 747E                   data txt.kb           ; Show "kb" string
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fm.loadfile.callback.indicator2.exit:
0149 6FD8 0460  28         b     @poprt                ; Return to caller
     6FDA 2214 
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
0161 6FDC 0649  14         dect  stack
0162 6FDE C64B  30         mov   r11,*stack            ; Save return address
0163               
0164               
0165 6FE0 06A0  32         bl    @hchar
     6FE2 2744 
0166 6FE4 1D03                   byte 29,3,32,50       ; Erase loading indicator
     6FE6 2032 
0167 6FE8 FFFF                   data EOL
0168               
0169 6FEA 06A0  32         bl    @putnum
     6FEC 2A20 
0170 6FEE 1D38                   byte 29,56            ; Show kilobytes read
0171 6FF0 A432                   data fh.kilobytes,rambuf,>3020
     6FF2 8390 
     6FF4 3020 
0172               
0173 6FF6 06A0  32         bl    @putat
     6FF8 2412 
0174 6FFA 1D3D                   byte 29,61
0175 6FFC 747E                   data txt.kb           ; Show "kb" string
0176               
0177 6FFE 06A0  32         bl    @putnum
     7000 2A20 
0178 7002 1D4B                   byte 29,75            ; Show lines read
0179 7004 A42E                   data fh.records,rambuf,>3020
     7006 8390 
     7008 3020 
0180                       ;------------------------------------------------------
0181                       ; Exit
0182                       ;------------------------------------------------------
0183               fm.loadfile.callback.indicator3.exit:
0184 700A 0460  28         b     @poprt                ; Return to caller
     700C 2214 
0185               
0186               
0187               
0188               *---------------------------------------------------------------
0189               * Callback function "File I/O error handler"
0190               *---------------------------------------------------------------
0191               * Is expected to be passed as parm5 to @tfh.file.read
0192               ********|*****|*********************|**************************
0193               fm.loadfile.callback.fioerr:
0194 700E 0649  14         dect  stack
0195 7010 C64B  30         mov   r11,*stack            ; Save return address
0196               
0197 7012 06A0  32         bl    @hchar
     7014 2744 
0198 7016 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7018 2032 
0199 701A FFFF                   data EOL
0200               
0201                       ;------------------------------------------------------
0202                       ; Display I/O error message
0203                       ;------------------------------------------------------
0204 701C 06A0  32         bl    @cpym2m
     701E 2462 
0205 7020 748D                   data txt.ioerr+1
0206 7022 D000                   data cmdb.top
0207 7024 0029                   data 41               ; Error message
0208               
0209               
0210 7026 C120  34         mov   @edb.filename.ptr,tmp0
     7028 A20E 
0211 702A D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 702C 0986  56         srl   tmp2,8                ; Right align
0213 702E 0584  14         inc   tmp0                  ; Skip length byte
0214 7030 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     7032 D02A 
0215               
0216 7034 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     7036 2468 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220               
0221               
0222 7038 0204  20         li    tmp0,txt.newfile      ; New file
     703A 74BA 
0223 703C C804  38         mov   tmp0,@edb.filename.ptr
     703E A20E 
0224               
0225 7040 0204  20         li    tmp0,txt.filetype.none
     7042 7506 
0226 7044 C804  38         mov   tmp0,@edb.filetype.ptr
     7046 A210 
0227                                                   ; Empty filetype string
0228               
0229 7048 C820  54         mov   @cmdb.scrrows,@parm1
     704A A304 
     704C 8350 
0230 704E 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     7050 7266 
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               fm.loadfile.callback.fioerr.exit:
0235 7052 0460  28         b     @poprt                ; Return to caller
     7054 2214 
**** **** ****     > stevie_b1.asm.158774
0054                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 7056 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7058 2014 
0013 705A 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 705C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     705E 2014 
0019 7060 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7062 833C 
     7064 833E 
0020 7066 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 7068 C820  54         mov   @waux1,@waux2         ; Save as previous key
     706A 833C 
     706C 833E 
0026 706E 0460  28         b     @edkey.key.process    ; Process key
     7070 611E 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 7072 04E0  34         clr   @waux1
     7074 833C 
0032 7076 04E0  34         clr   @waux2
     7078 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 707A 0204  20         li    tmp0,2000             ; Avoid key bouncing
     707C 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 707E 0604  14         dec   tmp0
0043 7080 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 7082 0460  28         b     @hookok               ; Return
     7084 2C7C 
**** **** ****     > stevie_b1.asm.158774
0055                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0012 7086 C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7088 A116 
0013 708A 1342  14         jeq   task.vdp.panes.exit   ; No, skip update
0014 708C C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     708E 832A 
     7090 A114 
0015                       ;------------------------------------------------------
0016                       ; Determine how many rows to copy
0017                       ;------------------------------------------------------
0018 7092 8820  54         c     @edb.lines,@fb.scrrows
     7094 A204 
     7096 A118 
0019 7098 1103  14         jlt   task.vdp.panes.setrows.small
0020 709A C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     709C A118 
0021 709E 1003  14         jmp   task.vdp.panes.copy.framebuffer
0022                       ;------------------------------------------------------
0023                       ; Less lines in editor buffer as rows in frame buffer
0024                       ;------------------------------------------------------
0025               task.vdp.panes.setrows.small:
0026 70A0 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     70A2 A204 
0027 70A4 0585  14         inc   tmp1
0028                       ;------------------------------------------------------
0029                       ; Determine area to copy
0030                       ;------------------------------------------------------
0031               task.vdp.panes.copy.framebuffer:
0032 70A6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     70A8 A10E 
0033                                                   ; 16 bit part is in tmp2!
0034 70AA 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0035 70AC C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     70AE A100 
0036                       ;------------------------------------------------------
0037                       ; Copy memory block
0038                       ;------------------------------------------------------
0039 70B0 06A0  32         bl    @xpym2v               ; Copy to VDP
     70B2 2420 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = RAM source address
0042                                                   ; / i  tmp2 = Bytes to copy
0043 70B4 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     70B6 A116 
0044                       ;-------------------------------------------------------
0045                       ; Draw EOF marker at end-of-file
0046                       ;-------------------------------------------------------
0047 70B8 C120  34         mov   @edb.lines,tmp0
     70BA A204 
0048 70BC 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     70BE A104 
0049 70C0 0584  14         inc   tmp0                  ; Y = Y + 1
0050 70C2 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     70C4 A118 
0051 70C6 121F  14         jle   task.vdp.panes.draw.cmdb
0052                       ;-------------------------------------------------------
0053                       ; Do actual drawing of EOF marker
0054                       ;-------------------------------------------------------
0055               task.vdp.panes.draw_marker:
0056 70C8 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0057 70CA C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     70CC 832A 
0058               
0059 70CE 06A0  32         bl    @putstr
     70D0 2400 
0060 70D2 745C                   data txt.marker       ; Display *EOF*
0061                       ;-------------------------------------------------------
0062                       ; Draw empty line after (and below) EOF marker
0063                       ;-------------------------------------------------------
0064 70D4 06A0  32         bl    @setx
     70D6 2666 
0065 70D8 0005                   data  5               ; Cursor after *EOF* string
0066               
0067 70DA C120  34         mov   @wyx,tmp0
     70DC 832A 
0068 70DE 0984  56         srl   tmp0,8                ; Right justify
0069 70E0 0584  14         inc   tmp0                  ; One time adjust
0070 70E2 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     70E4 A118 
0071 70E6 1303  14         jeq   !
0072 70E8 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     70EA 009B 
0073 70EC 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0074 70EE 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     70F0 004B 
0075                       ;-------------------------------------------------------
0076                       ; Draw 1 or 2 empty lines
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.draw_marker.empty.line:
0079 70F2 0604  14         dec   tmp0                  ; One time adjust
0080 70F4 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     70F6 23DC 
0081                                                   ; \ i  @wyx = Cursor position
0082                                                   ; / o  tmp0 = VDP address
0083               
0084 70F8 0205  20         li    tmp1,32               ; Character to write (whitespace)
     70FA 0020 
0085 70FC 06A0  32         bl    @xfilv                ; Fill VDP memory
     70FE 2276 
0086                                                   ; \ i  tmp0 = VDP destination
0087                                                   ; | i  tmp1 = byte to write
0088                                                   ; / i  tmp2 = Number of bytes to write
0089               
0090 7100 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7102 A114 
     7104 832A 
0091                       ;-------------------------------------------------------
0092                       ; Show command buffer
0093                       ;-------------------------------------------------------
0094               task.vdp.panes.draw.cmdb:
0095 7106 C120  34         mov   @cmdb.visible,tmp0    ; Show command buffer?
     7108 A302 
0096 710A 1302  14         jeq   task.vdp.panes.exit   ; No, skip
0097 710C 06A0  32         bl    @pane.cmdb.draw       ; Draw command buffer
     710E 722E 
0098                       ;------------------------------------------------------
0099                       ; Exit task
0100                       ;------------------------------------------------------
0101               task.vdp.panes.exit:
0102 7110 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     7112 72C0 
0103 7114 0460  28         b     @slotok
     7116 2CF8 
**** **** ****     > stevie_b1.asm.158774
0056                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 7118 C120  34         mov   @tv.pane.focus,tmp0
     711A A016 
0013 711C 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 711E 0284  22         ci    tmp0,pane.focus.cmdb
     7120 0001 
0016 7122 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 7124 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7126 FFCE 
0022 7128 06A0  32         bl    @cpu.crash            ; / Halt system.
     712A 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 712C C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     712E A308 
     7130 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7132 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     7134 202A 
0032 7136 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7138 2672 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 713A C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     713C 8380 
0036               
0037 713E 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7140 241A 
0038 7142 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7144 8380 
     7146 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7148 0460  28         b     @slotok               ; Exit task
     714A 2CF8 
**** **** ****     > stevie_b1.asm.158774
0057                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 714C 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     714E A112 
0013 7150 1303  14         jeq   task.vdp.cursor.visible
0014 7152 04E0  34         clr   @ramsat+2              ; Hide cursor
     7154 8382 
0015 7156 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7158 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     715A A20A 
0019 715C 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 715E C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7160 A016 
0025 7162 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 7164 0284  22         ci    tmp0,pane.focus.cmdb
     7166 0001 
0028 7168 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 716A 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 716C 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 716E 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7170 0100 
0040 7172 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 7174 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7176 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7178 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     717A A014 
0051 717C C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     717E A014 
     7180 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7182 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7184 241A 
0057 7186 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     7188 8380 
     718A 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 718C 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     718E 72C0 
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               task.vdp.cursor.exit:
0068 7190 0460  28         b     @slotok                ; Exit task
     7192 2CF8 
**** **** ****     > stevie_b1.asm.158774
0058                       copy  "pane.utils.asm"      ; Utilities used in panes
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Stevie Editor - Utilities used in panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Utilities used in panes
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.action.color.cycle
0010               * Cycle through available color scheme
0011               ***************************************************************
0012               * bl  @pane.action.color.cycle
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.action.colorscheme.cycle:
0021 7194 0649  14         dect  stack
0022 7196 C64B  30         mov   r11,*stack            ; Push return address
0023 7198 0649  14         dect  stack
0024 719A C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 719C C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     719E A012 
0027 71A0 0284  22         ci    tmp0,tv.colorscheme.entries
     71A2 0004 
0028                                                   ; Last entry reached?
0029 71A4 1102  14         jlt   !
0030 71A6 04C4  14         clr   tmp0
0031 71A8 1001  14         jmp   pane.action.colorscheme.switch
0032 71AA 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 71AC C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     71AE A012 
0038 71B0 06A0  32         bl    @pane.action.colorscheme.load
     71B2 71BA 
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               pane.action.colorscheme.cycle.exit:
0043 71B4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0044 71B6 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 71B8 045B  20         b     *r11                  ; Return to caller
0046               
0047               
0048               
0049               
0050               
0051               ***************************************************************
0052               * pane.action.color.load
0053               * Load color scheme
0054               ***************************************************************
0055               * bl  @pane.action.colorscheme.load
0056               *--------------------------------------------------------------
0057               * INPUT
0058               * @tv.colorscheme = Index into color scheme table
0059               *--------------------------------------------------------------
0060               * OUTPUT
0061               * none
0062               *--------------------------------------------------------------
0063               * Register usage
0064               * tmp0,tmp1,tmp2,tmp3
0065               ********|*****|*********************|**************************
0066               pane.action.colorscheme.load:
0067 71BA 0649  14         dect  stack
0068 71BC C64B  30         mov   r11,*stack            ; Save return address
0069 71BE 0649  14         dect  stack
0070 71C0 C644  30         mov   tmp0,*stack           ; Push tmp0
0071 71C2 0649  14         dect  stack
0072 71C4 C645  30         mov   tmp1,*stack           ; Push tmp1
0073 71C6 0649  14         dect  stack
0074 71C8 C646  30         mov   tmp2,*stack           ; Push tmp2
0075 71CA 0649  14         dect  stack
0076 71CC C647  30         mov   tmp3,*stack           ; Push tmp3
0077 71CE 06A0  32         bl    @scroff               ; Turn screen off
     71D0 2610 
0078                       ;-------------------------------------------------------
0079                       ; Get foreground/background color
0080                       ;-------------------------------------------------------
0081 71D2 C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     71D4 A012 
0082 71D6 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
0083 71D8 0224  22         ai    tmp0,tv.colorscheme.table
     71DA 7452 
0084                                                   ; Add base for color scheme data table
0085 71DC C1D4  26         mov   *tmp0,tmp3            ; Get fg/bg color
0086                       ;-------------------------------------------------------
0087                       ; Dump cursor FG color to sprite table (SAT)
0088                       ;-------------------------------------------------------
0089 71DE C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0090 71E0 0945  56         srl   tmp1,4                ; Move nibble to right
0091 71E2 0245  22         andi  tmp1,>0f00
     71E4 0F00 
0092 71E6 D805  38         movb  tmp1,@ramsat+3        ; Update FG color in sprite table (SAT)
     71E8 8383 
0093 71EA D805  38         movb  tmp1,@tv.curshape+1   ; Save cursor color
     71EC A015 
0094                       ;-------------------------------------------------------
0095                       ; Dump colors to VDP register 7 (text mode)
0096                       ;-------------------------------------------------------
0097 71EE C147  18         mov   tmp3,tmp1             ; Get work copy
0098 71F0 0985  56         srl   tmp1,8                ; MSB to LSB
0099 71F2 0265  22         ori   tmp1,>0700
     71F4 0700 
0100 71F6 C105  18         mov   tmp1,tmp0
0101 71F8 06A0  32         bl    @putvrx               ; Write VDP register
     71FA 2316 
0102                       ;-------------------------------------------------------
0103                       ; Dump colors for frame buffer pane (TAT)
0104                       ;-------------------------------------------------------
0105 71FC 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     71FE 1800 
0106 7200 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0107 7202 0985  56         srl   tmp1,8                ; MSB to LSB
0108 7204 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     7206 0910 
0109 7208 06A0  32         bl    @xfilv                ; Fill colors
     720A 2276 
0110                                                   ; i \  tmp0 = start address
0111                                                   ; i |  tmp1 = byte to fill
0112                                                   ; i /  tmp2 = number of bytes to fill
0113                       ;-------------------------------------------------------
0114                       ; Dump colors for bottom status line pane (TAT)
0115                       ;-------------------------------------------------------
0116 720C 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     720E 2110 
0117 7210 C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0118 7212 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     7214 00FF 
0119 7216 0206  20         li    tmp2,80               ; Number of bytes to fill
     7218 0050 
0120 721A 06A0  32         bl    @xfilv                ; Fill colors
     721C 2276 
0121                                                   ; i \  tmp0 = start address
0122                                                   ; i |  tmp1 = byte to fill
0123                                                   ; i /  tmp2 = number of bytes to fill
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               pane.action.colorscheme.load.exit:
0128 721E 06A0  32         bl    @scron                ; Turn screen on
     7220 2618 
0129 7222 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0130 7224 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 7226 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 7228 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 722A C2F9  30         mov   *stack+,r11           ; Pop R11
0134 722C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.158774
0059                       copy  "pane.cmdb.asm"       ; Command buffer pane
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
0021 722E 0649  14         dect  stack
0022 7230 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Draw command buffer
0025                       ;------------------------------------------------------
0026 7232 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     7234 6CCA 
0027               
0028 7236 06A0  32         bl    @vchar
     7238 276C 
0029 723A 1200                   byte 18,0,4,1          ; Top left corner
     723C 0401 
0030 723E 124F                   byte 18,79,5,1         ; Top right corner
     7240 0501 
0031 7242 1300                   byte 19,0,6,9          ; Left vertical double line
     7244 0609 
0032 7246 134F                   byte 19,79,7,9         ; Right vertical double line
     7248 0709 
0033 724A 1C00                   byte 28,0,8,1          ; Bottom left corner
     724C 0801 
0034 724E 1C4F                   byte 28,79,9,1         ; Bottom right corner
     7250 0901 
0035 7252 FFFF                   data EOL
0036               
0037 7254 06A0  32         bl    @hchar
     7256 2744 
0038 7258 1201                   byte 18,1,3,78         ; Horizontal top line
     725A 034E 
0039 725C 1C01                   byte 28,1,3,78         ; Horizontal bottom line
     725E 034E 
0040 7260 FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               pane.cmdb.exit:
0045 7262 C2F9  30         mov   *stack+,r11           ; Pop r11
0046 7264 045B  20         b     *r11                  ; Return
0047               
0048               
0049               ***************************************************************
0050               * pane.cmdb.show
0051               * Show command buffer pane
0052               ***************************************************************
0053               * bl @pane.cmdb.show
0054               *--------------------------------------------------------------
0055               * INPUT
0056               * none
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * none
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * none
0063               *--------------------------------------------------------------
0064               * Notes
0065               ********|*****|*********************|**************************
0066               pane.cmdb.show:
0067 7266 0649  14         dect  stack
0068 7268 C64B  30         mov   r11,*stack            ; Save return address
0069 726A 0649  14         dect  stack
0070 726C C644  30         mov   tmp0,*stack           ; Push tmp0
0071                       ;------------------------------------------------------
0072                       ; Show command buffer pane
0073                       ;------------------------------------------------------
0074 726E C820  54         mov   @wyx,@cmdb.fb.yxsave
     7270 832A 
     7272 A312 
0075                                                   ; Save YX position in frame buffer
0076               
0077 7274 C120  34         mov   @fb.scrrows.max,tmp0
     7276 A11A 
0078 7278 6120  34         s     @cmdb.scrrows,tmp0
     727A A304 
0079 727C C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     727E A118 
0080               
0081 7280 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0082 7282 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0083 7284 0584  14         inc   tmp0                  ; X=1
0084 7286 C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
     7288 A30C 
0085               
0086 728A 0720  34         seto  @cmdb.visible         ; Show pane
     728C A302 
0087               
0088 728E 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7290 0001 
0089 7292 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7294 A016 
0090               
0091 7296 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7298 A116 
0092               
0093               pane.cmdb.show.exit:
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097 729A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0098 729C C2F9  30         mov   *stack+,r11           ; Pop r11
0099 729E 045B  20         b     *r11                  ; Return to caller
0100               
0101               
0102               
0103               ***************************************************************
0104               * pane.cmdb.hide
0105               * Hide command buffer pane
0106               ***************************************************************
0107               * bl @pane.cmdb.hide
0108               *--------------------------------------------------------------
0109               * INPUT
0110               * none
0111               *--------------------------------------------------------------
0112               * OUTPUT
0113               * none
0114               *--------------------------------------------------------------
0115               * Register usage
0116               * none
0117               *--------------------------------------------------------------
0118               * Hiding the command buffer automatically passes pane focus
0119               * to frame buffer.
0120               ********|*****|*********************|**************************
0121               pane.cmdb.hide:
0122 72A0 0649  14         dect  stack
0123 72A2 C64B  30         mov   r11,*stack            ; Save return address
0124                       ;------------------------------------------------------
0125                       ; Hide command buffer pane
0126                       ;------------------------------------------------------
0127 72A4 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     72A6 A11A 
     72A8 A118 
0128                                                   ; Resize framebuffer
0129               
0130 72AA C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     72AC A312 
     72AE 832A 
0131               
0132 72B0 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     72B2 A302 
0133 72B4 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     72B6 A116 
0134 72B8 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     72BA A016 
0135               
0136               pane.cmdb.hide.exit:
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140 72BC C2F9  30         mov   *stack+,r11           ; Pop r11
0141 72BE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.158774
0060                       copy  "pane.botline.asm"    ; Status line pane
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
0021 72C0 0649  14         dect  stack
0022 72C2 C64B  30         mov   r11,*stack            ; Save return address
0023 72C4 0649  14         dect  stack
0024 72C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 72C8 C820  54         mov   @wyx,@fb.yxsave
     72CA 832A 
     72CC A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 72CE 06A0  32         bl    @putat
     72D0 2412 
0032 72D2 1D00                   byte  29,0
0033 72D4 74B6                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 72D6 06A0  32         bl    @at
     72D8 2650 
0039 72DA 1D03                   byte  29,3            ; Position cursor
0040 72DC C160  34         mov   @edb.filename.ptr,tmp1
     72DE A20E 
0041                                                   ; Get string to display
0042 72E0 06A0  32         bl    @xutst0               ; Display string
     72E2 2402 
0043               
0044 72E4 06A0  32         bl    @at
     72E6 2650 
0045 72E8 1D23                   byte  29,35           ; Position cursor
0046               
0047 72EA C160  34         mov   @edb.filetype.ptr,tmp1
     72EC A210 
0048                                                   ; Get string to display
0049 72EE 06A0  32         bl    @xutst0               ; Display Filetype string
     72F0 2402 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 72F2 C120  34         mov   @edb.insmode,tmp0
     72F4 A20A 
0055 72F6 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 72F8 06A0  32         bl    @putat
     72FA 2412 
0061 72FC 1D32                   byte  29,50
0062 72FE 7468                   data  txt.ovrwrite
0063 7300 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 7302 06A0  32         bl    @putat
     7304 2412 
0069 7306 1D32                   byte  29,50
0070 7308 746C                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 730A C120  34         mov   @edb.dirty,tmp0
     730C A206 
0076 730E 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7310 06A0  32         bl    @putat
     7312 2412 
0081 7314 1D36                   byte 29,54
0082 7316 7470                   data txt.star
0083 7318 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 731A 1000  14         nop
0089               pane.botline.show_linecol:
0090 731C C820  54         mov   @fb.row,@parm1
     731E A106 
     7320 8350 
0091 7322 06A0  32         bl    @fb.row2line
     7324 67A0 
0092 7326 05A0  34         inc   @outparm1
     7328 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 732A 06A0  32         bl    @putnum
     732C 2A20 
0097 732E 1D40                   byte  29,64           ; YX
0098 7330 8360                   data  outparm1,rambuf
     7332 8390 
0099 7334 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7336 06A0  32         bl    @putat
     7338 2412 
0105 733A 1D45                   byte  29,69
0106 733C 745A                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 733E 06A0  32         bl    @film
     7340 2218 
0111 7342 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     7344 0020 
     7346 000C 
0112               
0113 7348 C820  54         mov   @fb.column,@waux1
     734A A10C 
     734C 833C 
0114 734E 05A0  34         inc   @waux1                ; Offset 1
     7350 833C 
0115               
0116 7352 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7354 29A2 
0117 7356 833C                   data  waux1,rambuf
     7358 8390 
0118 735A 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 735C 06A0  32         bl    @trimnum              ; Trim number to the left
     735E 29FA 
0122 7360 8390                   data  rambuf,rambuf+6,32
     7362 8396 
     7364 0020 
0123               
0124 7366 0204  20         li    tmp0,>0200
     7368 0200 
0125 736A D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     736C 8396 
0126               
0127 736E 06A0  32         bl    @putat
     7370 2412 
0128 7372 1D46                   byte 29,70
0129 7374 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7376 C820  54         mov   @fb.row,@parm1
     7378 A106 
     737A 8350 
0134 737C 06A0  32         bl    @fb.row2line
     737E 67A0 
0135 7380 8820  54         c     @edb.lines,@outparm1
     7382 A204 
     7384 8360 
0136 7386 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 7388 06A0  32         bl    @putat
     738A 2412 
0139 738C 1D4B                   byte 29,75
0140 738E 7462                   data txt.bottom
0141               
0142 7390 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 7392 C820  54         mov   @edb.lines,@waux1
     7394 A204 
     7396 833C 
0148 7398 05A0  34         inc   @waux1                ; Offset 1
     739A 833C 
0149 739C 06A0  32         bl    @putnum
     739E 2A20 
0150 73A0 1D4B                   byte 29,75            ; YX
0151 73A2 833C                   data waux1,rambuf
     73A4 8390 
0152 73A6 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 73A8 C820  54         mov   @fb.yxsave,@wyx
     73AA A114 
     73AC 832A 
0159 73AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 73B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 73B2 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.158774
0061                       copy  "data.constants.asm"  ; Data segment - Constants
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
0033 73B4 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     73B6 003F 
     73B8 0243 
     73BA 05F4 
     73BC 0050 
0034               
0035               romsat:
0036 73BE 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     73C0 0001 
0037               
0038               cursors:
0039 73C2 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     73C4 0000 
     73C6 0000 
     73C8 001C 
0040 73CA 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     73CC 1010 
     73CE 1010 
     73D0 1000 
0041 73D2 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     73D4 1C1C 
     73D6 1C1C 
     73D8 1C00 
0042               
0043               patterns:
0044 73DA 0000             data  >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
     73DC FF00 
     73DE 00FF 
     73E0 0080 
0045 73E2 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     73E4 0000 
     73E6 FF00 
     73E8 FF00 
0046               patterns.box:
0047 73EA 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     73EC 0000 
     73EE FF00 
     73F0 FF00 
0048 73F2 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     73F4 0000 
     73F6 FF80 
     73F8 BFA0 
0049 73FA 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     73FC 0000 
     73FE FC04 
     7400 F414 
0050 7402 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7404 A0A0 
     7406 A0A0 
     7408 A0A0 
0051 740A 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     740C 1414 
     740E 1414 
     7410 1414 
0052 7412 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7414 A0A0 
     7416 BF80 
     7418 FF00 
0053 741A 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     741C 1414 
     741E F404 
     7420 FC00 
0054 7422 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7424 C0C0 
     7426 C0C0 
     7428 0080 
0055 742A 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     742C 0F0F 
     742E 0F0F 
     7430 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 7432 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7434 0002 
0065 7436 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     7438 0003 
0066 743A A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     743C 000A 
0067               
0068 743E B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     7440 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 7442 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     7444 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 7446 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     7448 000D 
0077 744A E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     744C 000E 
0078 744E F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     7450 000F 
0079               
0080               
0081               
0082               
0083               
0084               ***************************************************************
0085               * Stevie color schemes table
0086               *--------------------------------------------------------------
0087               * MSB  high-nibble    Foreground color frame buffer and cursor sprite
0088               * MSB  low-nibble     Background color frame buffer and background pane
0089               * LSB  high-nibble    Foreground color bottom line pane
0090               * LSB  low-nibble     Background color bottom line pane
0091               *--------------------------------------------------------------
0092      0004     tv.colorscheme.entries   equ 4      ; Entries in table
0093               tv.colorscheme.table:               ; Foreground | Background | Bg. Pane
0094 7452 F41C             data  >f41c                 ; White      | Dark blue  | Dark blue
0095 7454 F13A             data  >f13a                 ; White      | Black      | Black
0096 7456 174B             data  >174b                 ; Black      | Cyan       | Cyan
0097 7458 1F53             data  >1f53                 ; Black      | White      | White
0098               
**** **** ****     > stevie_b1.asm.158774
0062                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 745A 012C             byte  1
0009 745B ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 745C 052A             byte  5
0014 745D ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 7462 0520             byte  5
0019 7463 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 7468 034F             byte  3
0024 7469 ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 746C 0349             byte  3
0029 746D ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 7470 012A             byte  1
0034 7471 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 7472 0A4C             byte  10
0039 7473 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 747E 026B             byte  2
0044 747F ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 7482 0352             byte  3
0049 7483 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 7486 054C             byte  5
0054 7487 ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 748C 2921             byte  41
0059 748D ....             text  '! I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 74B6 0223             byte  2
0064 74B7 ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 74BA 0A5B             byte  10
0069 74BB ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.prompt
0074 74C6 013E             byte  1
0075 74C7 ....             text  '>'
0076                       even
0077               
0078               txt.cmdb.hint
0079 74C8 2348             byte  35
0080 74C9 ....             text  'Hint: Type "help" for command list.'
0081                       even
0082               
0083               txt.cmdb.catalog
0084 74EC 0C46             byte  12
0085 74ED ....             text  'File catalog'
0086                       even
0087               
0088               
0089               
0090               txt.filetype.dv80
0091 74FA 0A44             byte  10
0092 74FB ....             text  'DIS/VAR80 '
0093                       even
0094               
0095               txt.filetype.none
0096 7506 0A20             byte  10
0097 7507 ....             text  '          '
0098                       even
0099               
0100               
0101 7512 0C0A     txt.stevie     byte    12
0102                            byte    10
0103 7514 ....                  text    'stevie v1.00'
0104 7520 0B00                  byte    11
0105                            even
0106               
0107               fdname1
0108 7522 1354             byte  19
0109 7523 ....             text  'TIPI.TIVI.TMS9900_C'
0110                       even
0111               
0112               fdname2
0113 7536 0E54             byte  14
0114 7537 ....             text  'TIPI.TIVI.NR80'
0115                       even
0116               
0117               fdname3
0118 7546 0C44             byte  12
0119 7547 ....             text  'DSK1.XBEADOC'
0120                       even
0121               
0122               fdname4
0123 7554 1154             byte  17
0124 7555 ....             text  'TIPI.TIVI.C99MAN1'
0125                       even
0126               
0127               fdname5
0128 7566 1154             byte  17
0129 7567 ....             text  'TIPI.TIVI.C99MAN2'
0130                       even
0131               
0132               fdname6
0133 7578 1154             byte  17
0134 7579 ....             text  'TIPI.TIVI.C99MAN3'
0135                       even
0136               
0137               fdname7
0138 758A 1254             byte  18
0139 758B ....             text  'TIPI.TIVI.C99SPECS'
0140                       even
0141               
0142               fdname8
0143 759E 1254             byte  18
0144 759F ....             text  'TIPI.TIVI.RANDOM#C'
0145                       even
0146               
0147               fdname9
0148 75B2 1254             byte  18
0149 75B3 ....             text  'TIPI.TIVI.INVADERS'
0150                       even
0151               
0152               fdname0
0153 75C6 0E54             byte  14
0154 75C7 ....             text  'TIPI.TIVI.NR80'
0155                       even
0156               
0157               
0158               
0159               *---------------------------------------------------------------
0160               * Keyboard labels - Function keys
0161               *---------------------------------------------------------------
0162               txt.fctn.0
0163 75D6 0866             byte  8
0164 75D7 ....             text  'fctn + 0'
0165                       even
0166               
0167               txt.fctn.1
0168 75E0 0866             byte  8
0169 75E1 ....             text  'fctn + 1'
0170                       even
0171               
0172               txt.fctn.2
0173 75EA 0866             byte  8
0174 75EB ....             text  'fctn + 2'
0175                       even
0176               
0177               txt.fctn.3
0178 75F4 0866             byte  8
0179 75F5 ....             text  'fctn + 3'
0180                       even
0181               
0182               txt.fctn.4
0183 75FE 0866             byte  8
0184 75FF ....             text  'fctn + 4'
0185                       even
0186               
0187               txt.fctn.5
0188 7608 0866             byte  8
0189 7609 ....             text  'fctn + 5'
0190                       even
0191               
0192               txt.fctn.6
0193 7612 0866             byte  8
0194 7613 ....             text  'fctn + 6'
0195                       even
0196               
0197               txt.fctn.7
0198 761C 0866             byte  8
0199 761D ....             text  'fctn + 7'
0200                       even
0201               
0202               txt.fctn.8
0203 7626 0866             byte  8
0204 7627 ....             text  'fctn + 8'
0205                       even
0206               
0207               txt.fctn.9
0208 7630 0866             byte  8
0209 7631 ....             text  'fctn + 9'
0210                       even
0211               
0212               txt.fctn.a
0213 763A 0866             byte  8
0214 763B ....             text  'fctn + a'
0215                       even
0216               
0217               txt.fctn.b
0218 7644 0866             byte  8
0219 7645 ....             text  'fctn + b'
0220                       even
0221               
0222               txt.fctn.c
0223 764E 0866             byte  8
0224 764F ....             text  'fctn + c'
0225                       even
0226               
0227               txt.fctn.d
0228 7658 0866             byte  8
0229 7659 ....             text  'fctn + d'
0230                       even
0231               
0232               txt.fctn.e
0233 7662 0866             byte  8
0234 7663 ....             text  'fctn + e'
0235                       even
0236               
0237               txt.fctn.f
0238 766C 0866             byte  8
0239 766D ....             text  'fctn + f'
0240                       even
0241               
0242               txt.fctn.g
0243 7676 0866             byte  8
0244 7677 ....             text  'fctn + g'
0245                       even
0246               
0247               txt.fctn.h
0248 7680 0866             byte  8
0249 7681 ....             text  'fctn + h'
0250                       even
0251               
0252               txt.fctn.i
0253 768A 0866             byte  8
0254 768B ....             text  'fctn + i'
0255                       even
0256               
0257               txt.fctn.j
0258 7694 0866             byte  8
0259 7695 ....             text  'fctn + j'
0260                       even
0261               
0262               txt.fctn.k
0263 769E 0866             byte  8
0264 769F ....             text  'fctn + k'
0265                       even
0266               
0267               txt.fctn.l
0268 76A8 0866             byte  8
0269 76A9 ....             text  'fctn + l'
0270                       even
0271               
0272               txt.fctn.m
0273 76B2 0866             byte  8
0274 76B3 ....             text  'fctn + m'
0275                       even
0276               
0277               txt.fctn.n
0278 76BC 0866             byte  8
0279 76BD ....             text  'fctn + n'
0280                       even
0281               
0282               txt.fctn.o
0283 76C6 0866             byte  8
0284 76C7 ....             text  'fctn + o'
0285                       even
0286               
0287               txt.fctn.p
0288 76D0 0866             byte  8
0289 76D1 ....             text  'fctn + p'
0290                       even
0291               
0292               txt.fctn.q
0293 76DA 0866             byte  8
0294 76DB ....             text  'fctn + q'
0295                       even
0296               
0297               txt.fctn.r
0298 76E4 0866             byte  8
0299 76E5 ....             text  'fctn + r'
0300                       even
0301               
0302               txt.fctn.s
0303 76EE 0866             byte  8
0304 76EF ....             text  'fctn + s'
0305                       even
0306               
0307               txt.fctn.t
0308 76F8 0866             byte  8
0309 76F9 ....             text  'fctn + t'
0310                       even
0311               
0312               txt.fctn.u
0313 7702 0866             byte  8
0314 7703 ....             text  'fctn + u'
0315                       even
0316               
0317               txt.fctn.v
0318 770C 0866             byte  8
0319 770D ....             text  'fctn + v'
0320                       even
0321               
0322               txt.fctn.w
0323 7716 0866             byte  8
0324 7717 ....             text  'fctn + w'
0325                       even
0326               
0327               txt.fctn.x
0328 7720 0866             byte  8
0329 7721 ....             text  'fctn + x'
0330                       even
0331               
0332               txt.fctn.y
0333 772A 0866             byte  8
0334 772B ....             text  'fctn + y'
0335                       even
0336               
0337               txt.fctn.z
0338 7734 0866             byte  8
0339 7735 ....             text  'fctn + z'
0340                       even
0341               
0342               *---------------------------------------------------------------
0343               * Keyboard labels - Function keys extra
0344               *---------------------------------------------------------------
0345               txt.fctn.dot
0346 773E 0866             byte  8
0347 773F ....             text  'fctn + .'
0348                       even
0349               
0350               txt.fctn.plus
0351 7748 0866             byte  8
0352 7749 ....             text  'fctn + +'
0353                       even
0354               
0355               *---------------------------------------------------------------
0356               * Keyboard labels - Control keys
0357               *---------------------------------------------------------------
0358               txt.ctrl.0
0359 7752 0863             byte  8
0360 7753 ....             text  'ctrl + 0'
0361                       even
0362               
0363               txt.ctrl.1
0364 775C 0863             byte  8
0365 775D ....             text  'ctrl + 1'
0366                       even
0367               
0368               txt.ctrl.2
0369 7766 0863             byte  8
0370 7767 ....             text  'ctrl + 2'
0371                       even
0372               
0373               txt.ctrl.3
0374 7770 0863             byte  8
0375 7771 ....             text  'ctrl + 3'
0376                       even
0377               
0378               txt.ctrl.4
0379 777A 0863             byte  8
0380 777B ....             text  'ctrl + 4'
0381                       even
0382               
0383               txt.ctrl.5
0384 7784 0863             byte  8
0385 7785 ....             text  'ctrl + 5'
0386                       even
0387               
0388               txt.ctrl.6
0389 778E 0863             byte  8
0390 778F ....             text  'ctrl + 6'
0391                       even
0392               
0393               txt.ctrl.7
0394 7798 0863             byte  8
0395 7799 ....             text  'ctrl + 7'
0396                       even
0397               
0398               txt.ctrl.8
0399 77A2 0863             byte  8
0400 77A3 ....             text  'ctrl + 8'
0401                       even
0402               
0403               txt.ctrl.9
0404 77AC 0863             byte  8
0405 77AD ....             text  'ctrl + 9'
0406                       even
0407               
0408               txt.ctrl.a
0409 77B6 0863             byte  8
0410 77B7 ....             text  'ctrl + a'
0411                       even
0412               
0413               txt.ctrl.b
0414 77C0 0863             byte  8
0415 77C1 ....             text  'ctrl + b'
0416                       even
0417               
0418               txt.ctrl.c
0419 77CA 0863             byte  8
0420 77CB ....             text  'ctrl + c'
0421                       even
0422               
0423               txt.ctrl.d
0424 77D4 0863             byte  8
0425 77D5 ....             text  'ctrl + d'
0426                       even
0427               
0428               txt.ctrl.e
0429 77DE 0863             byte  8
0430 77DF ....             text  'ctrl + e'
0431                       even
0432               
0433               txt.ctrl.f
0434 77E8 0863             byte  8
0435 77E9 ....             text  'ctrl + f'
0436                       even
0437               
0438               txt.ctrl.g
0439 77F2 0863             byte  8
0440 77F3 ....             text  'ctrl + g'
0441                       even
0442               
0443               txt.ctrl.h
0444 77FC 0863             byte  8
0445 77FD ....             text  'ctrl + h'
0446                       even
0447               
0448               txt.ctrl.i
0449 7806 0863             byte  8
0450 7807 ....             text  'ctrl + i'
0451                       even
0452               
0453               txt.ctrl.j
0454 7810 0863             byte  8
0455 7811 ....             text  'ctrl + j'
0456                       even
0457               
0458               txt.ctrl.k
0459 781A 0863             byte  8
0460 781B ....             text  'ctrl + k'
0461                       even
0462               
0463               txt.ctrl.l
0464 7824 0863             byte  8
0465 7825 ....             text  'ctrl + l'
0466                       even
0467               
0468               txt.ctrl.m
0469 782E 0863             byte  8
0470 782F ....             text  'ctrl + m'
0471                       even
0472               
0473               txt.ctrl.n
0474 7838 0863             byte  8
0475 7839 ....             text  'ctrl + n'
0476                       even
0477               
0478               txt.ctrl.o
0479 7842 0863             byte  8
0480 7843 ....             text  'ctrl + o'
0481                       even
0482               
0483               txt.ctrl.p
0484 784C 0863             byte  8
0485 784D ....             text  'ctrl + p'
0486                       even
0487               
0488               txt.ctrl.q
0489 7856 0863             byte  8
0490 7857 ....             text  'ctrl + q'
0491                       even
0492               
0493               txt.ctrl.r
0494 7860 0863             byte  8
0495 7861 ....             text  'ctrl + r'
0496                       even
0497               
0498               txt.ctrl.s
0499 786A 0863             byte  8
0500 786B ....             text  'ctrl + s'
0501                       even
0502               
0503               txt.ctrl.t
0504 7874 0863             byte  8
0505 7875 ....             text  'ctrl + t'
0506                       even
0507               
0508               txt.ctrl.u
0509 787E 0863             byte  8
0510 787F ....             text  'ctrl + u'
0511                       even
0512               
0513               txt.ctrl.v
0514 7888 0863             byte  8
0515 7889 ....             text  'ctrl + v'
0516                       even
0517               
0518               txt.ctrl.w
0519 7892 0863             byte  8
0520 7893 ....             text  'ctrl + w'
0521                       even
0522               
0523               txt.ctrl.x
0524 789C 0863             byte  8
0525 789D ....             text  'ctrl + x'
0526                       even
0527               
0528               txt.ctrl.y
0529 78A6 0863             byte  8
0530 78A7 ....             text  'ctrl + y'
0531                       even
0532               
0533               txt.ctrl.z
0534 78B0 0863             byte  8
0535 78B1 ....             text  'ctrl + z'
0536                       even
0537               
0538               *---------------------------------------------------------------
0539               * Keyboard labels - control keys extra
0540               *---------------------------------------------------------------
0541               txt.ctrl.plus
0542 78BA 0863             byte  8
0543 78BB ....             text  'ctrl + +'
0544                       even
0545               
0546               *---------------------------------------------------------------
0547               * Special keys
0548               *---------------------------------------------------------------
0549               txt.enter
0550 78C4 0565             byte  5
0551 78C5 ....             text  'enter'
0552                       even
0553               
**** **** ****     > stevie_b1.asm.158774
0063                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 78CA 0D00             data  key.enter, txt.enter, edkey.action.enter
     78CC 78C4 
     78CE 6580 
0106 78D0 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     78D2 76EE 
     78D4 617E 
0107 78D6 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     78D8 7658 
     78DA 6194 
0108 78DC 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     78DE 7662 
     78E0 61AC 
0109 78E2 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     78E4 7720 
     78E6 61FE 
0110 78E8 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     78EA 77B6 
     78EC 626A 
0111 78EE 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     78F0 77E8 
     78F2 6282 
0112 78F4 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     78F6 786A 
     78F8 6296 
0113 78FA 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     78FC 77D4 
     78FE 62E8 
0114 7900 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7902 77DE 
     7904 6348 
0115 7906 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7908 789C 
     790A 638A 
0116 790C 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     790E 7874 
     7910 63B6 
0117 7912 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7914 77C0 
     7916 63E2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7918 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     791A 75E0 
     791C 6422 
0122 791E 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7920 781A 
     7922 645A 
0123 7924 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7926 75F4 
     7928 648E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 792A 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     792C 75EA 
     792E 64E6 
0128 7930 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7932 773E 
     7934 65EE 
0129 7936 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7938 7608 
     793A 653C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 793C 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     793E 7748 
     7940 663E 
0134 7942 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7944 7630 
     7946 664A 
0135 7948 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     794A 78B0 
     794C 7194 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 794E B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7950 7752 
     7952 6668 
0140 7954 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7956 775C 
     7958 666E 
0141 795A B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     795C 7766 
     795E 6674 
0142 7960 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7962 7770 
     7964 667A 
0143 7966 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7968 777A 
     796A 6680 
0144 796C B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     796E 7784 
     7970 6686 
0145 7972 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7974 778E 
     7976 668C 
0146 7978 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     797A 7798 
     797C 6692 
0147 797E 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7980 77A2 
     7982 6698 
0148 7984 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7986 77AC 
     7988 669E 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 798A FFFF             data  EOL                           ; EOL
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
0164 798C 0D00             data  key.enter, txt.enter, edkey.action.enter
     798E 78C4 
     7990 6580 
0165 7992 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7994 76EE 
     7996 617E 
0166 7998 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     799A 7658 
     799C 6194 
0167 799E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     79A0 7662 
     79A2 6646 
0168 79A4 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     79A6 7720 
     79A8 6646 
0169 79AA 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
     79AC 77B6 
     79AE 6646 
0170 79B0 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
     79B2 77E8 
     79B4 6646 
0171 79B6 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     79B8 786A 
     79BA 6646 
0172 79BC 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     79BE 77D4 
     79C0 6646 
0173 79C2 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     79C4 77DE 
     79C6 6646 
0174 79C8 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     79CA 789C 
     79CC 6646 
0175 79CE 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     79D0 7874 
     79D2 6646 
0176 79D4 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     79D6 77C0 
     79D8 6646 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 79DA 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     79DC 75E0 
     79DE 6422 
0181 79E0 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     79E2 781A 
     79E4 645A 
0182 79E6 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     79E8 75F4 
     79EA 6646 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 79EC 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     79EE 75EA 
     79F0 64E6 
0187 79F2 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     79F4 773E 
     79F6 65EE 
0188 79F8 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     79FA 7608 
     79FC 6646 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 79FE 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7A00 7748 
     7A02 663E 
0193 7A04 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7A06 7630 
     7A08 664A 
0194 7A0A 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7A0C 78B0 
     7A0E 7194 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 7A10 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7A12 7752 
     7A14 6668 
0199 7A16 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7A18 775C 
     7A1A 666E 
0200 7A1C B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7A1E 7766 
     7A20 6674 
0201 7A22 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7A24 7770 
     7A26 667A 
0202 7A28 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7A2A 777A 
     7A2C 6680 
0203 7A2E B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7A30 7784 
     7A32 6686 
0204 7A34 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7A36 778E 
     7A38 668C 
0205 7A3A B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7A3C 7798 
     7A3E 6692 
0206 7A40 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7A42 77A2 
     7A44 6698 
0207 7A46 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7A48 77AC 
     7A4A 669E 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 7A4C FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.158774
0064               
0068 7A4E 7A4E                   data $                ; Bank 1 ROM size OK.
0070               
0071               *--------------------------------------------------------------
0072               * Video mode configuration
0073               *--------------------------------------------------------------
0074      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0075      0004     spfbck  equ   >04                   ; Screen background color.
0076      73B4     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0077      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0078      0050     colrow  equ   80                    ; Columns per row
0079      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0080      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0081      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0082      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.210353
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm                 ; Version 200607-210353
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
0009               * File: equates.asm                 ; Version 200607-210353
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
0215      A444     fh.free           equ  fh.struct + 68  ; no longer used
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
**** **** ****     > stevie_b1.asm.210353
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
0031 6015 ....             text  'STEVIE 200607-210353'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > stevie_b1.asm.210353
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
0260 21DB ....             text  'Build-ID  200607-210353'
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
0350 2E1C 7416             data  spvmod                ; Equate selected video mode table
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
**** **** ****     > stevie_b1.asm.210353
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
     60AA 6708 
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
0085 60B8 7420                   data romsat,ramsat,4  ; Load sprite SAT
     60BA 8380 
     60BC 0004 
0086               
0087 60BE C820  54         mov   @romsat+2,@tv.curshape
     60C0 7422 
     60C2 A014 
0088                                                   ; Save cursor shape & color
0089               
0090 60C4 06A0  32         bl    @cpym2v
     60C6 2432 
0091 60C8 2800                   data sprpdt,cursors,3*8
     60CA 7424 
     60CC 0018 
0092                                                   ; Load sprite cursor patterns
0093               
0094 60CE 06A0  32         bl    @cpym2v
     60D0 2432 
0095 60D2 1008                   data >1008,patterns,11*8
     60D4 743C 
     60D6 0058 
0096                                                   ; Load character patterns
0097               *--------------------------------------------------------------
0098               * Initialize
0099               *--------------------------------------------------------------
0100 60D8 06A0  32         bl    @stevie.init          ; Initialize Stevie editor config
     60DA 66FC 
0101 60DC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60DE 6CD4 
0102 60E0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60E2 6AEE 
0103 60E4 06A0  32         bl    @idx.init             ; Initialize index
     60E6 6890 
0104 60E8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60EA 6764 
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
     6108 70B2 
0119 610A 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     610C 7144 
0120 610E 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     6110 7178 
0121 6112 FFFF                   data eol
0122               
0123 6114 06A0  32         bl    @mkhook
     6116 2D40 
0124 6118 7082                   data hook.keyscan     ; Setup user hook
0125               
0126 611A 0460  28         b     @tmgr                 ; Start timers and kthread
     611C 2C96 
0127               
0128               
**** **** ****     > stevie_b1.asm.210353
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
     6142 792C 
0031 6144 1003  14         jmp   edkey.key.check_next
0032                       ;-------------------------------------------------------
0033                       ; Use CMDB keyboard map
0034                       ;-------------------------------------------------------
0035               edkey.key.process.loadmap.cmdb:
0036 6146 0206  20         li    tmp2,keymap_actions.cmdb
     6148 79EE 
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
**** **** ****     > stevie_b1.asm.210353
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
     6192 70A6 
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
     61AA 70A6 
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
     61B6 6B24 
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
     61D0 67D6 
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
     61DE 6CB6 
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
     61F8 67BA 
0093 61FA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61FC 70A6 
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
     6210 6B24 
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
     623C 67D6 
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
     624A 6CB6 
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
     6264 67BA 
0162 6266 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6268 70A6 
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
     627C 67BA 
0175 627E 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6280 70A6 
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
     6290 67BA 
0185 6292 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6294 70A6 
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
     62E2 67BA 
0253 62E4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62E6 70A6 
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
     6342 67BA 
0336 6344 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6346 70A6 
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
     636A 6B24 
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
     6378 67D6 
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
     63A8 6B24 
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
     63B4 70A6 
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
     63C0 6B24 
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
     63D0 67D6 
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
     63E0 70A6 
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
     63EC 6B24 
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
     640C 67D6 
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
     6420 70A6 
**** **** ****     > stevie_b1.asm.210353
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
     6428 67BA 
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
     6458 70A6 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 645A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     645C A206 
0055 645E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6460 67BA 
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
     648C 70A6 
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
     64A2 67BA 
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
     64BC 6A3E 
0109 64BE 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64C0 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64C2 C820  54         mov   @fb.topline,@parm1
     64C4 A104 
     64C6 8350 
0114 64C8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64CA 67D6 
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
     64F4 67BA 
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
     653A 70A6 
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
     654A 6B24 
0213 654C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     654E A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6550 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6552 67BA 
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
     6568 6AA0 
0224 656A 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     656C A204 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 656E C820  54         mov   @fb.topline,@parm1
     6570 A104 
     6572 8350 
0229 6574 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6576 67D6 
0230 6578 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     657A A116 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 657C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     657E 70A6 
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
     658E 6B24 
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
     65C2 67D6 
0281 65C4 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 65C6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65C8 A106 
0287 65CA 06A0  32         bl    @down                 ; Row++ VDP cursor
     65CC 2674 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 65CE 06A0  32         bl    @fb.get.firstnonblank
     65D0 6848 
0293 65D2 C120  34         mov   @outparm1,tmp0
     65D4 8360 
0294 65D6 C804  38         mov   tmp0,@fb.column
     65D8 A10C 
0295 65DA 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65DC 2686 
0296 65DE 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65E0 6CB6 
0297 65E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65E4 67BA 
0298 65E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65E8 A116 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65EA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65EC 70A6 
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
     65FC 7178 
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
     6612 67BA 
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
     663C 70A6 
**** **** ****     > stevie_b1.asm.210353
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
     6648 70A6 
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
     6652 72C8 
0031 6654 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 6656 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6658 7302 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 665A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665C 70A6 
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
**** **** ****     > stevie_b1.asm.210353
0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6668 0204  20         li   tmp0,fdname0
     666A 761E 
0007 666C 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 666E 0204  20         li   tmp0,fdname1
     6670 7584 
0010 6672 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 6674 0204  20         li   tmp0,fdname2
     6676 758E 
0013 6678 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 667A 0204  20         li   tmp0,fdname3
     667C 759E 
0016 667E 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 6680 0204  20         li   tmp0,fdname4
     6682 75AC 
0019 6684 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 6686 0204  20         li   tmp0,fdname5
     6688 75BE 
0022 668A 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 668C 0204  20         li   tmp0,fdname6
     668E 75D0 
0025 6690 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 6692 0204  20         li   tmp0,fdname7
     6694 75E2 
0028 6696 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 6698 0204  20         li   tmp0,fdname8
     669A 75F6 
0031 669C 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 669E 0204  20         li   tmp0,fdname9
     66A0 760A 
0034 66A2 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66A4 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66A6 6F40 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66A8 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66AA 63B6 
**** **** ****     > stevie_b1.asm.210353
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
     66BA 67BA 
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
     66EA 70A6 
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
     66FA 70A6 
**** **** ****     > stevie_b1.asm.210353
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
     6706 222C 
**** **** ****     > stevie_b1.asm.210353
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
     670E 2582 
0027 6710 7494                   data mem.sams.layout.data
0028               
0029 6712 06A0  32         bl    @sams.layout.copy
     6714 25E6 
0030 6716 A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 6718 C820  54         mov   @tv.sams.c000,@edb.sams.page
     671A A008 
     671C A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 671E C2F9  30         mov   *stack+,r11           ; Pop r11
0039 6720 045B  20         b     *r11                  ; Return to caller
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
0064 6722 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 6724 0649  14         dect  stack
0067 6726 C64B  30         mov   r11,*stack            ; Push return address
0068 6728 0649  14         dect  stack
0069 672A C644  30         mov   tmp0,*stack           ; Push tmp0
0070 672C 0649  14         dect  stack
0071 672E C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 6730 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6732 A204 
0076 6734 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 6736 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6738 FFCE 
0082 673A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     673C 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 673E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6740 69E4 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 6742 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6744 8362 
0093 6746 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6748 8360 
0094 674A 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 674C 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     674E A008 
0101 6750 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 6752 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6754 2516 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 6756 C820  54         mov   @outparm2,@tv.sams.c000
     6758 8362 
     675A A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 675C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 675E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 6760 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 6762 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.210353
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
0024 6764 0649  14         dect  stack
0025 6766 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 6768 0204  20         li    tmp0,fb.top
     676A A600 
0030 676C C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     676E A100 
0031 6770 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     6772 A104 
0032 6774 04E0  34         clr   @fb.row               ; Current row=0
     6776 A106 
0033 6778 04E0  34         clr   @fb.column            ; Current column=0
     677A A10C 
0034               
0035 677C 0204  20         li    tmp0,80
     677E 0050 
0036 6780 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     6782 A10E 
0037               
0038 6784 0204  20         li    tmp0,29
     6786 001D 
0039 6788 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     678A A118 
0040 678C C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     678E A11A 
0041               
0042 6790 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     6792 A016 
0043 6794 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     6796 A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 6798 06A0  32         bl    @film
     679A 2230 
0048 679C A600             data  fb.top,>00,fb.size    ; Clear it all the way
     679E 0000 
     67A0 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 67A2 0460  28         b     @poprt                ; Return to caller
     67A4 222C 
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
0078 67A6 0649  14         dect  stack
0079 67A8 C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67AA C120  34         mov   @parm1,tmp0
     67AC 8350 
0084 67AE A120  34         a     @fb.topline,tmp0
     67B0 A104 
0085 67B2 C804  38         mov   tmp0,@outparm1
     67B4 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67B6 0460  28         b    @poprt                 ; Return to caller
     67B8 222C 
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
0118 67BA 0649  14         dect  stack
0119 67BC C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 67BE C1A0  34         mov   @fb.row,tmp2
     67C0 A106 
0124 67C2 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     67C4 A10E 
0125 67C6 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     67C8 A10C 
0126 67CA A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     67CC A100 
0127 67CE C807  38         mov   tmp3,@fb.current
     67D0 A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 67D2 0460  28         b    @poprt                 ; Return to caller
     67D4 222C 
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
0153 67D6 0649  14         dect  stack
0154 67D8 C64B  30         mov   r11,*stack            ; Push return address
0155 67DA 0649  14         dect  stack
0156 67DC C644  30         mov   tmp0,*stack           ; Push tmp0
0157 67DE 0649  14         dect  stack
0158 67E0 C645  30         mov   tmp1,*stack           ; Push tmp1
0159 67E2 0649  14         dect  stack
0160 67E4 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 67E6 C820  54         mov   @parm1,@fb.topline
     67E8 8350 
     67EA A104 
0165 67EC 04E0  34         clr   @parm2                ; Target row in frame buffer
     67EE 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 67F0 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     67F2 8350 
     67F4 A204 
0170 67F6 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 67F8 06A0  32         bl    @edb.line.unpack      ; Unpack line
     67FA 6BD4 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 67FC 05A0  34         inc   @parm1                ; Next line in editor buffer
     67FE 8350 
0180 6800 05A0  34         inc   @parm2                ; Next row in frame buffer
     6802 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 6804 8820  54         c     @parm1,@edb.lines
     6806 8350 
     6808 A204 
0185 680A 1113  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 680C C120  34         mov   @parm2,tmp0           ; Current row
     680E 8352 
0192 6810 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6812 A118 
0193 6814 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 6816 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6818 A10E 
0195               
0196 681A C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 681C 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 681E 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6820 A10E 
0200 6822 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6824 A100 
0201               
0202 6826 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 6828 0205  20         li    tmp1,32               ; Clear with space
     682A 0020 
0204               
0205 682C 06A0  32         bl    @xfilm                ; \ Fill memory
     682E 2236 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 6830 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 6832 8820  54 !       c     @parm2,@fb.scrrows
     6834 8352 
     6836 A118 
0214 6838 11DF  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 683A 0720  34         seto  @fb.dirty             ; Refresh screen
     683C A116 
0221 683E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 6840 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 6842 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 6844 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 6846 045B  20         b     *r11                  ; Return to caller
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
0239 6848 0649  14         dect  stack
0240 684A C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 684C 04E0  34         clr   @fb.column
     684E A10C 
0245 6850 06A0  32         bl    @fb.calc_pointer
     6852 67BA 
0246 6854 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6856 6CB6 
0247 6858 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     685A A108 
0248 685C 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 685E C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6860 A102 
0251 6862 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 6864 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 6866 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 6868 0285  22         ci    tmp1,>2000            ; Whitespace?
     686A 2000 
0260 686C 1503  14         jgt   fb.get.firstnonblank.match
0261 686E 0606  14         dec   tmp2                  ; Counter--
0262 6870 16F9  14         jne   fb.get.firstnonblank.loop
0263 6872 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 6874 6120  34         s     @fb.current,tmp0      ; Calculate column
     6876 A102 
0269 6878 0604  14         dec   tmp0
0270 687A C804  38         mov   tmp0,@outparm1        ; Save column
     687C 8360 
0271 687E D805  38         movb  tmp1,@outparm2        ; Save character
     6880 8362 
0272 6882 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 6884 04E0  34         clr   @outparm1             ; X=0
     6886 8360 
0278 6888 04E0  34         clr   @outparm2             ; Null
     688A 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 688C 0460  28         b    @poprt                 ; Return to caller
     688E 222C 
**** **** ****     > stevie_b1.asm.210353
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
0050 6890 0649  14         dect  stack
0051 6892 C64B  30         mov   r11,*stack            ; Save return address
0052 6894 0649  14         dect  stack
0053 6896 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 6898 0204  20         li    tmp0,idx.top
     689A B000 
0058 689C C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     689E A202 
0059               
0060 68A0 C120  34         mov   @tv.sams.b000,tmp0
     68A2 A006 
0061 68A4 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     68A6 A500 
0062 68A8 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     68AA A502 
0063 68AC C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     68AE A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 68B0 06A0  32         bl    @film
     68B2 2230 
0068 68B4 B000                   data idx.top,>00,idx.size
     68B6 0000 
     68B8 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 68BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 68BC C2F9  30         mov   *stack+,r11           ; Pop r11
0076 68BE 045B  20         b     *r11                  ; Return to caller
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
0100 68C0 0649  14         dect  stack
0101 68C2 C64B  30         mov   r11,*stack            ; Push return address
0102 68C4 0649  14         dect  stack
0103 68C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 68C8 0649  14         dect  stack
0105 68CA C645  30         mov   tmp1,*stack           ; Push tmp1
0106 68CC 0649  14         dect  stack
0107 68CE C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 68D0 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     68D2 A502 
0112 68D4 0205  20         li    tmp1,idx.top
     68D6 B000 
0113               
0114 68D8 C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     68DA A504 
0115 68DC 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 68DE 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     68E0 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 68E2 0286  22         ci    tmp2,5                ; Crash if too many index pages
     68E4 0005 
0121 68E6 1104  14         jlt   !
0122 68E8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     68EA FFCE 
0123 68EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     68EE 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 68F0 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     68F2 2516 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 68F4 0584  14         inc   tmp0                  ; Next SAMS index page
0132 68F6 0225  22         ai    tmp1,>1000            ; Next memory region
     68F8 1000 
0133 68FA 0606  14         dec   tmp2                  ; Update loop counter
0134 68FC 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 68FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6900 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6902 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6904 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6906 045B  20         b     *r11                  ; Return to caller
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
0159 6908 0649  14         dect  stack
0160 690A C64B  30         mov   r11,*stack            ; Push return address
0161 690C 0649  14         dect  stack
0162 690E C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6910 0649  14         dect  stack
0164 6912 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6914 0649  14         dect  stack
0166 6916 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 6918 0649  14         dect  stack
0168 691A C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 691C 0205  20         li    tmp1,idx.top
     691E B000 
0173 6920 0206  20         li    tmp2,5                ; Always 5 pages
     6922 0005 
0174 6924 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6926 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 6928 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 692A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     692C 2516 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 692E 0225  22         ai    tmp1,>1000            ; Next memory region
     6930 1000 
0185 6932 0606  14         dec   tmp2                  ; Update loop counter
0186 6934 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6936 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 6938 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 693A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 693C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 693E C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6940 045B  20         b     *r11                  ; Return to caller
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
0219               _idx.samspage.get:
0220 6942 0649  14         dect  stack
0221 6944 C64B  30         mov   r11,*stack            ; Save return address
0222 6946 0649  14         dect  stack
0223 6948 C644  30         mov   tmp0,*stack           ; Push tmp0
0224 694A 0649  14         dect  stack
0225 694C C645  30         mov   tmp1,*stack           ; Push tmp1
0226 694E 0649  14         dect  stack
0227 6950 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6952 C184  18         mov   tmp0,tmp2             ; Line number
0232 6954 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6956 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6958 0800 
0234               
0235 695A 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 695C 0A16  56         sla   tmp2,1                ; line number * 2
0240 695E C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6960 8360 
0241               
0242 6962 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6964 A502 
0243 6966 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6968 A500 
0244               
0245 696A 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 696C C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     696E A500 
0251 6970 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in stevie
     6972 A006 
0252               
0253 6974 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6976 0205  20         li    tmp1,>b000            ; Memory window for index page
     6978 B000 
0255               
0256 697A 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     697C 2516 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 697E 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     6980 A504 
0263 6982 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 6984 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6986 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 6988 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 698A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 698C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 698E C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6990 045B  20         b     *r11                  ; Return to caller
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
0295 6992 0649  14         dect  stack
0296 6994 C64B  30         mov   r11,*stack            ; Save return address
0297 6996 0649  14         dect  stack
0298 6998 C644  30         mov   tmp0,*stack           ; Push tmp0
0299 699A 0649  14         dect  stack
0300 699C C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 699E C120  34         mov   @parm1,tmp0           ; Get line number
     69A0 8350 
0305 69A2 C160  34         mov   @parm2,tmp1           ; Get pointer
     69A4 8352 
0306 69A6 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 69A8 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     69AA 0FFF 
0312 69AC 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 69AE 06E0  34         swpb  @parm3
     69B0 8354 
0317 69B2 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     69B4 8354 
0318 69B6 06E0  34         swpb  @parm3                ; \ Restore original order again,
     69B8 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 69BA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     69BC 6942 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 69BE C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     69C0 8360 
0329 69C2 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     69C4 B000 
0330 69C6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69C8 8360 
0331 69CA 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 69CC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     69CE 6942 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 69D0 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     69D2 8360 
0341 69D4 04E4  34         clr   @idx.top(tmp0)        ; /
     69D6 B000 
0342 69D8 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     69DA 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 69DC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 69DE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 69E0 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 69E2 045B  20         b     *r11                  ; Return to caller
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
0371               *--------------------------------------------------------------
0372               idx.pointer.get:
0373 69E4 0649  14         dect  stack
0374 69E6 C64B  30         mov   r11,*stack            ; Save return address
0375 69E8 0649  14         dect  stack
0376 69EA C644  30         mov   tmp0,*stack           ; Push tmp0
0377 69EC 0649  14         dect  stack
0378 69EE C645  30         mov   tmp1,*stack           ; Push tmp1
0379 69F0 0649  14         dect  stack
0380 69F2 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 69F4 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     69F6 8350 
0385               
0386 69F8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     69FA 6942 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 69FC C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     69FE 8360 
0391 6A00 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6A02 B000 
0392               
0393 6A04 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6A06 C185  18         mov   tmp1,tmp2             ; \
0399 6A08 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6A0A 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6A0C 00FF 
0404 6A0E 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6A10 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6A12 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6A14 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6A16 8360 
0411 6A18 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6A1A 8362 
0412 6A1C 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6A1E 04E0  34         clr   @outparm1
     6A20 8360 
0418 6A22 04E0  34         clr   @outparm2
     6A24 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6A26 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6A28 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6A2A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6A2C C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6A2E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
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
0025 6A30 C924  54 !       mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     6A32 B002 
     6A34 B000 
0026 6A36 05C4  14         inct  tmp0                  ; Next index entry
0027 6A38 0606  14         dec   tmp2                  ; tmp2--
0028 6A3A 16FA  14         jne   -!                    ; Loop unless completed
0029 6A3C 045B  20         b     *r11                  ; Return to caller
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
0048 6A3E 0649  14         dect  stack
0049 6A40 C64B  30         mov   r11,*stack            ; Save return address
0050 6A42 0649  14         dect  stack
0051 6A44 C644  30         mov   tmp0,*stack           ; Push tmp0
0052 6A46 0649  14         dect  stack
0053 6A48 C645  30         mov   tmp1,*stack           ; Push tmp1
0054 6A4A 0649  14         dect  stack
0055 6A4C C646  30         mov   tmp2,*stack           ; Push tmp2
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 6A4E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6A50 8350 
0060               
0061 6A52 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A54 6942 
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 6A56 C120  34         mov   @outparm1,tmp0        ; Index offset
     6A58 8360 
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 6A5A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6A5C 8352 
0070 6A5E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6A60 8350 
0071 6A62 130D  14         jeq   idx.entry.delete.lastline
0072                                                   ; Special treatment if last line
0073                       ;------------------------------------------------------
0074                       ; Reorganize index entries
0075                       ;------------------------------------------------------
0076               idx.entry.delete.reorg:
0077 6A64 8820  54         c     @idx.sams.page,@idx.sams.hipage
     6A66 A500 
     6A68 A504 
0078 6A6A 1307  14         jeq   idx.entry.delete.reorg.simple
0079                                                   ; If only one SAMS index page or at last
0080                                                   ; SAMS index page then do simple reorg
0081                       ;------------------------------------------------------
0082                       ; Complex index reorganization (multiple SAMS pages)
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg.complex:
0085 6A6C 06A0  32         bl    @_idx.sams.mapcolumn.on
     6A6E 68C0 
0086                                                   ; Index in continious memory region
0087               
0088 6A70 06A0  32         bl    @_idx.entry.delete.reorg
     6A72 6A30 
0089                                                   ; Reorganize index
0090               
0091               
0092 6A74 06A0  32         bl    @_idx.sams.mapcolumn.off
     6A76 6908 
0093                                                   ; Restore memory window layout
0094               
0095 6A78 1002  14         jmp   idx.entry.delete.lastline
0096                       ;------------------------------------------------------
0097                       ; Simple index reorganization
0098                       ;------------------------------------------------------
0099               idx.entry.delete.reorg.simple:
0100 6A7A 06A0  32         bl    @_idx.entry.delete.reorg
     6A7C 6A30 
0101                       ;------------------------------------------------------
0102                       ; Last line
0103                       ;------------------------------------------------------
0104               idx.entry.delete.lastline:
0105 6A7E 04E4  34         clr   @idx.top(tmp0)
     6A80 B000 
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               idx.entry.delete.exit:
0110 6A82 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0111 6A84 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0112 6A86 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0113 6A88 C2F9  30         mov   *stack+,r11           ; Pop r11
0114 6A8A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
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
0020               *--------------------------------------------------------------
0021               _idx.entry.insert.reorg:
0022                       ;------------------------------------------------------
0023                       ; Reorganize index entries
0024                       ;------------------------------------------------------
0025 6A8C 05C6  14         inct  tmp2                  ; Adjust one time
0026 6A8E C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6A90 B000 
     6A92 B002 
0027                                                   ; Move index entry
0028               
0029 6A94 0644  14         dect  tmp0                  ; Previous index entry
0030 6A96 0606  14         dec   tmp2                  ; tmp2--
0031 6A98 16FA  14         jne   -!                    ; Loop unless completed
0032               
0033 6A9A 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     6A9C B004 
0034 6A9E 045B  20         b     *r11                  ; Return to caller
0035               
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * idx.entry.insert
0042               * Insert index entry
0043               ***************************************************************
0044               * bl @idx.entry.insert
0045               *--------------------------------------------------------------
0046               * INPUT
0047               * @parm1    = Line number in editor buffer to insert
0048               * @parm2    = Line number of last line to check for reorg
0049               *--------------------------------------------------------------
0050               * OUTPUT
0051               * NONE
0052               *--------------------------------------------------------------
0053               * Register usage
0054               * tmp0,tmp2
0055               *--------------------------------------------------------------
0056               idx.entry.insert:
0057 6AA0 0649  14         dect  stack
0058 6AA2 C64B  30         mov   r11,*stack            ; Save return address
0059 6AA4 0649  14         dect  stack
0060 6AA6 C644  30         mov   tmp0,*stack           ; Push tmp0
0061 6AA8 0649  14         dect  stack
0062 6AAA C645  30         mov   tmp1,*stack           ; Push tmp1
0063 6AAC 0649  14         dect  stack
0064 6AAE C646  30         mov   tmp2,*stack           ; Push tmp2
0065                       ;------------------------------------------------------
0066                       ; Get index slot
0067                       ;------------------------------------------------------
0068 6AB0 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6AB2 8350 
0069               
0070 6AB4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6AB6 6942 
0071                                                   ; \ i  tmp0     = Line number
0072                                                   ; / o  outparm1 = Slot offset in SAMS page
0073               
0074 6AB8 C120  34         mov   @outparm1,tmp0        ; Index offset
     6ABA 8360 
0075 6ABC C120  34         mov   @outparm1,tmp0        ; Index offset
     6ABE 8360 
0076                       ;------------------------------------------------------
0077                       ; Prepare for index reorg
0078                       ;------------------------------------------------------
0079 6AC0 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6AC2 8352 
0080 6AC4 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6AC6 8350 
0081 6AC8 130B  14         jeq   idx.entry.insert.reorg.simple
0082                                                   ; Special treatment if last line
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.insert.reorg:
0087 6ACA 8820  54         c     @idx.sams.page,@idx.sams.hipage
     6ACC A500 
     6ACE A504 
0088 6AD0 1307  14         jeq   idx.entry.insert.reorg.simple
0089                                                   ; If only one SAMS index page or at last
0090                                                   ; SAMS index page then do simple reorg
0091                       ;------------------------------------------------------
0092                       ; Complex index reorganization (multiple SAMS pages)
0093                       ;------------------------------------------------------
0094               idx.entry.insert.reorg.complex:
0095 6AD2 06A0  32         bl    @_idx.sams.mapcolumn.on
     6AD4 68C0 
0096                                                   ; Index in continious memory region
0097               
0098 6AD6 06A0  32         bl    @_idx.entry.insert.reorg
     6AD8 6A8C 
0099                                                   ; Reorganize index
0100               
0101 6ADA 06A0  32         bl    @_idx.sams.mapcolumn.off
     6ADC 6908 
0102                                                   ; Restore memory window layout
0103               
0104 6ADE 1002  14         jmp   idx.entry.insert.exit
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg.simple:
0109 6AE0 06A0  32         bl    @_idx.entry.insert.reorg
     6AE2 6A8C 
0110                       ;------------------------------------------------------
0111                       ; Exit
0112                       ;------------------------------------------------------
0113               idx.entry.insert.exit:
0114 6AE4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0115 6AE6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0116 6AE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0117 6AEA C2F9  30         mov   *stack+,r11           ; Pop r11
0118 6AEC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
0050                       copy  "edb.asm"             ; Editor Buffer
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
0026 6AEE 0649  14         dect  stack
0027 6AF0 C64B  30         mov   r11,*stack            ; Save return address
0028 6AF2 0649  14         dect  stack
0029 6AF4 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6AF6 0204  20         li    tmp0,edb.top          ; \
     6AF8 C000 
0034 6AFA C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6AFC A200 
0035 6AFE C804  38         mov   tmp0,@edb.next_free.ptr
     6B00 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6B02 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6B04 A20A 
0039 6B06 04E0  34         clr   @edb.lines            ; Lines=0
     6B08 A204 
0040 6B0A 04E0  34         clr   @edb.rle              ; RLE compression off
     6B0C A20C 
0041               
0042 6B0E 0204  20         li    tmp0,txt.newfile      ; "New file"
     6B10 751C 
0043 6B12 C804  38         mov   tmp0,@edb.filename.ptr
     6B14 A20E 
0044               
0045 6B16 0204  20         li    tmp0,txt.filetype.none
     6B18 7568 
0046 6B1A C804  38         mov   tmp0,@edb.filetype.ptr
     6B1C A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6B1E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6B20 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6B22 045B  20         b     *r11                  ; Return to caller
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
0081 6B24 0649  14         dect  stack
0082 6B26 C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6B28 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6B2A A10C 
     6B2C 8390 
0087 6B2E 04E0  34         clr   @fb.column
     6B30 A10C 
0088 6B32 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6B34 67BA 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6B36 04C4  14         clr   tmp0                  ; Counter
0093 6B38 C160  34         mov   @fb.current,tmp1      ; Get position
     6B3A A102 
0094 6B3C C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6B3E 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6B40 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6B42 0986  56         srl   tmp2,8                ; Right justify
0102 6B44 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6B46 0584  14         inc   tmp0                  ; Increase string length
0104 6B48 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6B4A C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6B4C A104 
     6B4E 8350 
0111 6B50 A820  54         a     @fb.row,@parm1        ; /
     6B52 A106 
     6B54 8350 
0112               
0113 6B56 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6B58 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6B5A C120  34         mov   @edb.next_free.ptr,tmp0
     6B5C A208 
0120 6B5E C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6B60 8352 
0121               
0122 6B62 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6B64 24DE 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6B66 C820  54         mov   @waux1,@parm3         ; Setup parm3
     6B68 833C 
     6B6A 8354 
0128               
0129 6B6C 06A0  32         bl    @idx.entry.update     ; Update index
     6B6E 6992 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6B70 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6B72 A212 
     6B74 8354 
0139 6B76 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6B78 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6B7A 8354 
0142 6B7C C160  34         mov   @edb.next_free.ptr,tmp1
     6B7E A208 
0143                                                   ; Pointer to line in editor buffer
0144 6B80 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6B82 2516 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6B84 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6B86 A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6B88 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6B8A 8392 
0155 6B8C C160  34         mov   @edb.next_free.ptr,tmp1
     6B8E A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6B90 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6B92 A208 
0159               
0160 6B94 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6B96 8394 
0161 6B98 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6B9A 06C6  14         swpb  tmp2
0163 6B9C DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6B9E 06C6  14         swpb  tmp2
0165 6BA0 1314  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6BA2 0286  22         ci    tmp2,2
     6BA4 0002 
0172 6BA6 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6BA8 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6BAA DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6BAC 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6BAE 0286  22         ci    tmp2,1
     6BB0 0001 
0179 6BB2 1602  14         jne   edb.line.pack.copyline.block
0180 6BB4 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6BB6 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6BB8 06A0  32         bl    @xpym2m               ; Copy memory block
     6BBA 2480 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6BBC C120  34 !       mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6BBE A208 
0192 6BC0 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0193 6BC2 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6BC4 000F 
0194 6BC6 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6BC8 A208 
0195                       ;------------------------------------------------------
0196                       ; Exit
0197                       ;------------------------------------------------------
0198               edb.line.pack.exit:
0199 6BCA C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6BCC 8390 
     6BCE A10C 
0200 6BD0 0460  28         b     @poprt                ; Return to caller
     6BD2 222C 
0201               
0202               
0203               
0204               
0205               ***************************************************************
0206               * edb.line.unpack
0207               * Unpack specified line to framebuffer
0208               ***************************************************************
0209               *  bl   @edb.line.unpack
0210               *--------------------------------------------------------------
0211               * INPUT
0212               * @parm1 = Line to unpack in editor buffer
0213               * @parm2 = Target row in frame buffer
0214               *--------------------------------------------------------------
0215               * OUTPUT
0216               * none
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * tmp0,tmp1,tmp2
0220               *--------------------------------------------------------------
0221               * Memory usage
0222               * rambuf    = Saved @parm1 of edb.line.unpack
0223               * rambuf+2  = Saved @parm2 of edb.line.unpack
0224               * rambuf+4  = Source memory address in editor buffer
0225               * rambuf+6  = Destination memory address in frame buffer
0226               * rambuf+8  = Length of line
0227               ********|*****|*********************|**************************
0228               edb.line.unpack:
0229 6BD4 0649  14         dect  stack
0230 6BD6 C64B  30         mov   r11,*stack            ; Save return address
0231 6BD8 0649  14         dect  stack
0232 6BDA C644  30         mov   tmp0,*stack           ; Push tmp0
0233 6BDC 0649  14         dect  stack
0234 6BDE C645  30         mov   tmp1,*stack           ; Push tmp1
0235 6BE0 0649  14         dect  stack
0236 6BE2 C646  30         mov   tmp2,*stack           ; Push tmp2
0237                       ;------------------------------------------------------
0238                       ; Sanity check
0239                       ;------------------------------------------------------
0240 6BE4 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6BE6 8350 
     6BE8 A204 
0241 6BEA 1104  14         jlt   !
0242 6BEC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BEE FFCE 
0243 6BF0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BF2 2030 
0244                       ;------------------------------------------------------
0245                       ; Save parameters
0246                       ;------------------------------------------------------
0247 6BF4 C820  54 !       mov   @parm1,@rambuf
     6BF6 8350 
     6BF8 8390 
0248 6BFA C820  54         mov   @parm2,@rambuf+2
     6BFC 8352 
     6BFE 8392 
0249                       ;------------------------------------------------------
0250                       ; Calculate offset in frame buffer
0251                       ;------------------------------------------------------
0252 6C00 C120  34         mov   @fb.colsline,tmp0
     6C02 A10E 
0253 6C04 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6C06 8352 
0254 6C08 C1A0  34         mov   @fb.top.ptr,tmp2
     6C0A A100 
0255 6C0C A146  18         a     tmp2,tmp1             ; Add base to offset
0256 6C0E C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6C10 8396 
0257                       ;------------------------------------------------------
0258                       ; Get pointer to line & page-in editor buffer page
0259                       ;------------------------------------------------------
0260 6C12 C120  34         mov   @parm1,tmp0
     6C14 8350 
0261 6C16 06A0  32         bl    @xmem.edb.sams.mappage
     6C18 6724 
0262                                                   ; Activate editor buffer SAMS page for line
0263                                                   ; \ i  tmp0     = Line number
0264                                                   ; | o  outparm1 = Pointer to line
0265                                                   ; / o  outparm2 = SAMS page
0266               
0267 6C1A C820  54         mov   @outparm2,@edb.sams.page
     6C1C 8362 
     6C1E A212 
0268                                                   ; Save current SAMS page
0269                       ;------------------------------------------------------
0270                       ; Handle empty line
0271                       ;------------------------------------------------------
0272 6C20 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6C22 8360 
0273 6C24 1603  14         jne   !                     ; Check if pointer is set
0274 6C26 04E0  34         clr   @rambuf+8             ; Set length=0
     6C28 8398 
0275 6C2A 100F  14         jmp   edb.line.unpack.clear
0276                       ;------------------------------------------------------
0277                       ; Get line length
0278                       ;------------------------------------------------------
0279 6C2C C154  26 !       mov   *tmp0,tmp1            ; Get line length
0280 6C2E C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6C30 8398 
0281               
0282 6C32 05E0  34         inct  @outparm1             ; Skip line prefix
     6C34 8360 
0283 6C36 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6C38 8360 
     6C3A 8394 
0284                       ;------------------------------------------------------
0285                       ; Sanity check on line length
0286                       ;------------------------------------------------------
0287 6C3C 0285  22         ci    tmp1,80               ; Sanity check on line length, crash
     6C3E 0050 
0288 6C40 1204  14         jle   edb.line.unpack.clear ; if length > 80.
0289 6C42 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C44 FFCE 
0290 6C46 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C48 2030 
0291                       ;------------------------------------------------------
0292                       ; Erase chars from last column until column 80
0293                       ;------------------------------------------------------
0294               edb.line.unpack.clear:
0295 6C4A C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6C4C 8396 
0296 6C4E A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6C50 8398 
0297               
0298 6C52 04C5  14         clr   tmp1                  ; Fill with >00
0299 6C54 C1A0  34         mov   @fb.colsline,tmp2
     6C56 A10E 
0300 6C58 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6C5A 8398 
0301 6C5C 0586  14         inc   tmp2
0302               
0303 6C5E 06A0  32         bl    @xfilm                ; Fill CPU memory
     6C60 2236 
0304                                                   ; \ i  tmp0 = Target address
0305                                                   ; | i  tmp1 = Byte to fill
0306                                                   ; / i  tmp2 = Repeat count
0307                       ;------------------------------------------------------
0308                       ; Prepare for unpacking data
0309                       ;------------------------------------------------------
0310               edb.line.unpack.prepare:
0311 6C62 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6C64 8398 
0312 6C66 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0313 6C68 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6C6A 8394 
0314 6C6C C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6C6E 8396 
0315                       ;------------------------------------------------------
0316                       ; Check before copy
0317                       ;------------------------------------------------------
0318               edb.line.unpack.copy:
0319 6C70 0286  22         ci    tmp2,80               ; Check line length
     6C72 0050 
0320 6C74 1204  14         jle   !
0321 6C76 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C78 FFCE 
0322 6C7A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C7C 2030 
0323                       ;------------------------------------------------------
0324                       ; Copy memory block
0325                       ;------------------------------------------------------
0326 6C7E 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6C80 2480 
0327                                                   ; \ i  tmp0 = Source address
0328                                                   ; | i  tmp1 = Target address
0329                                                   ; / i  tmp2 = Bytes to copy
0330                       ;------------------------------------------------------
0331                       ; Exit
0332                       ;------------------------------------------------------
0333               edb.line.unpack.exit:
0334 6C82 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0335 6C84 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0336 6C86 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0337 6C88 C2F9  30         mov   *stack+,r11           ; Pop r11
0338 6C8A 045B  20         b     *r11                  ; Return to caller
0339               
0340               
0341               
0342               ***************************************************************
0343               * edb.line.getlength
0344               * Get length of specified line
0345               ***************************************************************
0346               *  bl   @edb.line.getlength
0347               *--------------------------------------------------------------
0348               * INPUT
0349               * @parm1 = Line number
0350               *--------------------------------------------------------------
0351               * OUTPUT
0352               * @outparm1 = Length of line
0353               * @outparm2 = SAMS page
0354               *--------------------------------------------------------------
0355               * Register usage
0356               * tmp0,tmp1
0357               *--------------------------------------------------------------
0358               * Remarks
0359               * Expects that the affected SAMS page is already paged-in!
0360               ********|*****|*********************|**************************
0361               edb.line.getlength:
0362 6C8C 0649  14         dect  stack
0363 6C8E C64B  30         mov   r11,*stack            ; Push return address
0364 6C90 0649  14         dect  stack
0365 6C92 C644  30         mov   tmp0,*stack           ; Push tmp0
0366 6C94 0649  14         dect  stack
0367 6C96 C645  30         mov   tmp1,*stack           ; Push tmp1
0368                       ;------------------------------------------------------
0369                       ; Initialisation
0370                       ;------------------------------------------------------
0371 6C98 04E0  34         clr   @outparm1             ; Reset length
     6C9A 8360 
0372 6C9C 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6C9E 8362 
0373                       ;------------------------------------------------------
0374                       ; Get length
0375                       ;------------------------------------------------------
0376 6CA0 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6CA2 69E4 
0377                                                   ; \ i  parm1    = Line number
0378                                                   ; | o  outparm1 = Pointer to line
0379                                                   ; / o  outparm2 = SAMS page
0380               
0381 6CA4 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6CA6 8360 
0382 6CA8 1302  14         jeq   edb.line.getlength.exit
0383                                                   ; Exit early if NULL pointer
0384                       ;------------------------------------------------------
0385                       ; Process line prefix
0386                       ;------------------------------------------------------
0387 6CAA C814  46         mov   *tmp0,@outparm1       ; Save length
     6CAC 8360 
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               edb.line.getlength.exit:
0392 6CAE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0393 6CB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0394 6CB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0395 6CB4 045B  20         b     *r11                  ; Return to caller
0396               
0397               
0398               
0399               ***************************************************************
0400               * edb.line.getlength2
0401               * Get length of current row (as seen from editor buffer side)
0402               ***************************************************************
0403               *  bl   @edb.line.getlength2
0404               *--------------------------------------------------------------
0405               * INPUT
0406               * @fb.row = Row in frame buffer
0407               *--------------------------------------------------------------
0408               * OUTPUT
0409               * @fb.row.length = Length of row
0410               *--------------------------------------------------------------
0411               * Register usage
0412               * tmp0
0413               ********|*****|*********************|**************************
0414               edb.line.getlength2:
0415 6CB6 0649  14         dect  stack
0416 6CB8 C64B  30         mov   r11,*stack            ; Save return address
0417                       ;------------------------------------------------------
0418                       ; Calculate line in editor buffer
0419                       ;------------------------------------------------------
0420 6CBA C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6CBC A104 
0421 6CBE A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6CC0 A106 
0422                       ;------------------------------------------------------
0423                       ; Get length
0424                       ;------------------------------------------------------
0425 6CC2 C804  38         mov   tmp0,@parm1
     6CC4 8350 
0426 6CC6 06A0  32         bl    @edb.line.getlength
     6CC8 6C8C 
0427 6CCA C820  54         mov   @outparm1,@fb.row.length
     6CCC 8360 
     6CCE A108 
0428                                                   ; Save row length
0429                       ;------------------------------------------------------
0430                       ; Exit
0431                       ;------------------------------------------------------
0432               edb.line.getlength2.exit:
0433 6CD0 0460  28         b     @poprt                ; Return to caller
     6CD2 222C 
0434               
**** **** ****     > stevie_b1.asm.210353
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
0027 6CD4 0649  14         dect  stack
0028 6CD6 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6CD8 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6CDA D000 
0033 6CDC C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6CDE A300 
0034               
0035 6CE0 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6CE2 A302 
0036 6CE4 0204  20         li    tmp0,10
     6CE6 000A 
0037 6CE8 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6CEA A304 
0038 6CEC C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6CEE A306 
0039               
0040 6CF0 0204  20         li    tmp0,>1b02            ; Y=27, X=2
     6CF2 1B02 
0041 6CF4 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6CF6 A308 
0042               
0043 6CF8 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6CFA A30E 
0044 6CFC 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6CFE A310 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6D00 06A0  32         bl    @film
     6D02 2230 
0049 6D04 D000             data  cmdb.top,>00,cmdb.size
     6D06 0000 
     6D08 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6D0A C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6D0C 045B  20         b     *r11                  ; Return to caller
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
0082 6D0E 0649  14         dect  stack
0083 6D10 C64B  30         mov   r11,*stack            ; Save return address
0084 6D12 0649  14         dect  stack
0085 6D14 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6D16 0649  14         dect  stack
0087 6D18 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6D1A 0649  14         dect  stack
0089 6D1C C646  30         mov   tmp2,*stack           ; Push tmp2
0090                       ;------------------------------------------------------
0091                       ; Dump Command buffer content
0092                       ;------------------------------------------------------
0093 6D1E C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6D20 832A 
     6D22 A30A 
0094               
0095 6D24 C820  54         mov   @cmdb.yxtop,@wyx
     6D26 A30C 
     6D28 832A 
0096 6D2A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6D2C 23F4 
0097               
0098 6D2E C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6D30 A300 
0099 6D32 0206  20         li    tmp2,9*80
     6D34 02D0 
0100               
0101 6D36 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6D38 2438 
0102                                                   ; | i  tmp0 = VDP target address
0103                                                   ; | i  tmp1 = RAM source address
0104                                                   ; / i  tmp2 = Number of bytes to copy
0105               
0106                       ;------------------------------------------------------
0107                       ; Show command buffer prompt
0108                       ;------------------------------------------------------
0109 6D3A 06A0  32         bl    @putat
     6D3C 242A 
0110 6D3E 1B01                   byte 27,1
0111 6D40 7528                   data txt.cmdb.prompt
0112               
0113 6D42 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6D44 A30A 
     6D46 A114 
0114 6D48 C820  54         mov   @cmdb.yxsave,@wyx
     6D4A A30A 
     6D4C 832A 
0115                                                   ; Restore YX position
0116               cmdb.refresh.exit:
0117                       ;------------------------------------------------------
0118                       ; Exit
0119                       ;------------------------------------------------------
0120 6D4E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6D50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6D52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6D54 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6D56 045B  20         b     *r11                  ; Return to caller
0125               
**** **** ****     > stevie_b1.asm.210353
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
0028 6D58 0649  14         dect  stack
0029 6D5A C64B  30         mov   r11,*stack            ; Save return address
0030                       ;------------------------------------------------------
0031                       ; Initialisation
0032                       ;------------------------------------------------------
0033 6D5C 04E0  34         clr   @fh.records           ; Reset records counter
     6D5E A42E 
0034 6D60 04E0  34         clr   @fh.counter           ; Clear internal counter
     6D62 A434 
0035 6D64 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6D66 A432 
0036 6D68 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0037 6D6A 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6D6C A42A 
0038 6D6E 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6D70 A42C 
0039               
0040 6D72 C120  34         mov   @edb.top.ptr,tmp0
     6D74 A200 
0041 6D76 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6D78 24DE 
0042                                                   ; \ i  tmp0  = Memory address
0043                                                   ; | o  waux1 = SAMS page number
0044                                                   ; / o  waux2 = Address of SAMS register
0045               
0046 6D7A C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6D7C 833C 
     6D7E A438 
0047 6D80 C820  54         mov   @waux1,@fh.sams.hipage
     6D82 833C 
     6D84 A43A 
0048                                                   ; Set highest SAMS page in use
0049                       ;------------------------------------------------------
0050                       ; Save parameters / callback functions
0051                       ;------------------------------------------------------
0052 6D86 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6D88 8350 
     6D8A A436 
0053 6D8C C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6D8E 8352 
     6D90 A43C 
0054 6D92 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6D94 8354 
     6D96 A43E 
0055 6D98 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6D9A 8356 
     6D9C A440 
0056 6D9E C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6DA0 8358 
     6DA2 A442 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 6DA4 C120  34         mov   @fh.callback1,tmp0
     6DA6 A43C 
0061 6DA8 0284  22         ci    tmp0,>6000            ; Insane address ?
     6DAA 6000 
0062 6DAC 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0063               
0064 6DAE 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6DB0 7FFF 
0065 6DB2 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0066               
0067 6DB4 C120  34         mov   @fh.callback2,tmp0
     6DB6 A43E 
0068 6DB8 0284  22         ci    tmp0,>6000            ; Insane address ?
     6DBA 6000 
0069 6DBC 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0070               
0071 6DBE 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6DC0 7FFF 
0072 6DC2 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6DC4 C120  34         mov   @fh.callback3,tmp0
     6DC6 A440 
0075 6DC8 0284  22         ci    tmp0,>6000            ; Insane address ?
     6DCA 6000 
0076 6DCC 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0077               
0078 6DCE 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6DD0 7FFF 
0079 6DD2 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6DD4 1004  14         jmp   fh.file.read.sams.load1
0082                                                   ; All checks passed, continue.
0083                                                   ;--------------------------
0084                                                   ; Check failed, crash CPU!
0085                                                   ;--------------------------
0086               fh.file.read.crash:
0087 6DD6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DD8 FFCE 
0088 6DDA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DDC 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.read.sams.load1:
0093 6DDE C120  34         mov   @fh.callback1,tmp0
     6DE0 A43C 
0094 6DE2 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.read.sams.pabheader:
0099 6DE4 06A0  32         bl    @cpym2v
     6DE6 2432 
0100 6DE8 0A60                   data fh.vpab,fh.file.pab.header,9
     6DEA 6F36 
     6DEC 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 6DEE 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6DF0 0A69 
0106 6DF2 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6DF4 A436 
0107 6DF6 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 6DF8 0986  56         srl   tmp2,8                ; Right justify
0109 6DFA 0586  14         inc   tmp2                  ; Include length byte as well
0110 6DFC 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6DFE 2438 
0111                       ;------------------------------------------------------
0112                       ; Load GPL scratchpad layout
0113                       ;------------------------------------------------------
0114 6E00 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6E02 2AC2 
0115 6E04 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0116                       ;------------------------------------------------------
0117                       ; Open file
0118                       ;------------------------------------------------------
0119 6E06 06A0  32         bl    @file.open
     6E08 2C10 
0120 6E0A 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0121 6E0C 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6E0E 2026 
0122 6E10 1602  14         jne   fh.file.read.sams.record
0123 6E12 0460  28         b     @fh.file.read.sams.error
     6E14 6F04 
0124                                                   ; Yes, IO error occured
0125                       ;------------------------------------------------------
0126                       ; Step 1: Read file record
0127                       ;------------------------------------------------------
0128               fh.file.read.sams.record:
0129 6E16 05A0  34         inc   @fh.records           ; Update counter
     6E18 A42E 
0130 6E1A 04E0  34         clr   @fh.reclen            ; Reset record length
     6E1C A430 
0131               
0132 6E1E 06A0  32         bl    @file.record.read     ; Read file record
     6E20 2C52 
0133 6E22 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0134                                                   ; |           (without +9 offset!)
0135                                                   ; | o  tmp0 = Status byte
0136                                                   ; | o  tmp1 = Bytes read
0137                                                   ; | o  tmp2 = Status register contents
0138                                                   ; /           upon DSRLNK return
0139               
0140 6E24 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6E26 A42A 
0141 6E28 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6E2A A430 
0142 6E2C C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6E2E A42C 
0143                       ;------------------------------------------------------
0144                       ; 1a: Calculate kilobytes processed
0145                       ;------------------------------------------------------
0146 6E30 A805  38         a     tmp1,@fh.counter
     6E32 A434 
0147 6E34 A160  34         a     @fh.counter,tmp1
     6E36 A434 
0148 6E38 0285  22         ci    tmp1,1024
     6E3A 0400 
0149 6E3C 1106  14         jlt   !
0150 6E3E 05A0  34         inc   @fh.kilobytes
     6E40 A432 
0151 6E42 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6E44 FC00 
0152 6E46 C805  38         mov   tmp1,@fh.counter
     6E48 A434 
0153                       ;------------------------------------------------------
0154                       ; 1b: Load spectra scratchpad layout
0155                       ;------------------------------------------------------
0156 6E4A 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6E4C 2A48 
0157 6E4E 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E50 2AE4 
0158 6E52 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0159                       ;------------------------------------------------------
0160                       ; 1c: Check if a file error occured
0161                       ;------------------------------------------------------
0162               fh.file.read.sams.check_fioerr:
0163 6E54 C1A0  34         mov   @fh.ioresult,tmp2
     6E56 A42C 
0164 6E58 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6E5A 2026 
0165 6E5C 1602  14         jne   fh.file.read.sams.check_setpage
0166                                                   ; No, goto (1d)
0167 6E5E 0460  28         b     @fh.file.read.sams.error
     6E60 6F04 
0168                                                   ; Yes, so handle file error
0169                       ;------------------------------------------------------
0170                       ; 1d: Check if SAMS page needs to be set
0171                       ;------------------------------------------------------
0172               fh.file.read.sams.check_setpage:
0173 6E62 C120  34         mov   @edb.next_free.ptr,tmp0
     6E64 A208 
0174                                                   ;--------------------------
0175                                                   ; Sanity check
0176                                                   ;--------------------------
0177 6E66 0284  22         ci    tmp0,edb.top + edb.size
     6E68 D000 
0178                                                   ; Insane address ?
0179 6E6A 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0180                                                   ;--------------------------
0181                                                   ; Check overflow
0182                                                   ;--------------------------
0183 6E6C 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6E6E 0FFF 
0184 6E70 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6E72 A430 
0185 6E74 05C4  14         inct  tmp0                  ; +2 for line prefix
0186 6E76 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6E78 0FF0 
0187 6E7A 110E  14         jlt   fh.file.read.sams.process_line
0188                                                   ; Not yet so skip SAMS page switch
0189                       ;------------------------------------------------------
0190                       ; 1e: Increase SAMS page
0191                       ;------------------------------------------------------
0192 6E7C 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6E7E A438 
0193 6E80 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     6E82 A438 
     6E84 A43A 
0194                                                   ; Set highest SAMS page
0195 6E86 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6E88 A200 
     6E8A A208 
0196                                                   ; Start at top of SAMS page again
0197                       ;------------------------------------------------------
0198                       ; 1f: Switch to SAMS page
0199                       ;------------------------------------------------------
0200 6E8C C120  34         mov   @fh.sams.page,tmp0
     6E8E A438 
0201 6E90 C160  34         mov   @edb.top.ptr,tmp1
     6E92 A200 
0202 6E94 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6E96 2516 
0203                                                   ; \ i  tmp0 = SAMS page number
0204                                                   ; / i  tmp1 = Memory address
0205                       ;------------------------------------------------------
0206                       ; Step 2: Process line
0207                       ;------------------------------------------------------
0208               fh.file.read.sams.process_line:
0209 6E98 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6E9A 0960 
0210 6E9C C160  34         mov   @edb.next_free.ptr,tmp1
     6E9E A208 
0211                                                   ; RAM target in editor buffer
0212               
0213 6EA0 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6EA2 8352 
0214               
0215 6EA4 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6EA6 A430 
0216 6EA8 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0217                                                   ; Handle empty line
0218                       ;------------------------------------------------------
0219                       ; 2a: Copy line from VDP to CPU editor buffer
0220                       ;------------------------------------------------------
0221                                                   ; Put line length word before string
0222 6EAA DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0223 6EAC 06C6  14         swpb  tmp2                  ; |
0224 6EAE DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0225 6EB0 06C6  14         swpb  tmp2                  ; /
0226               
0227 6EB2 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6EB4 A208 
0228 6EB6 A806  38         a     tmp2,@edb.next_free.ptr
     6EB8 A208 
0229                                                   ; Add line length
0230               
0231 6EBA 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6EBC 245E 
0232                                                   ; \ i  tmp0 = VDP source address
0233                                                   ; | i  tmp1 = RAM target address
0234                                                   ; / i  tmp2 = Bytes to copy
0235                       ;------------------------------------------------------
0236                       ; 2b: Align pointer to multiple of 16 memory address
0237                       ;------------------------------------------------------
0238 6EBE C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6EC0 A208 
0239 6EC2 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0240 6EC4 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6EC6 000F 
0241 6EC8 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6ECA A208 
0242                       ;------------------------------------------------------
0243                       ; Step 3: Update index
0244                       ;------------------------------------------------------
0245               fh.file.read.sams.prepindex:
0246 6ECC C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6ECE A204 
     6ED0 8350 
0247                                                   ; parm2 = Must allready be set!
0248 6ED2 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6ED4 A438 
     6ED6 8354 
0249               
0250 6ED8 1009  14         jmp   fh.file.read.sams.updindex
0251                                                   ; Update index
0252                       ;------------------------------------------------------
0253                       ; 3a: Special handling for empty line
0254                       ;------------------------------------------------------
0255               fh.file.read.sams.prepindex.emptyline:
0256 6EDA C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6EDC A42E 
     6EDE 8350 
0257 6EE0 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6EE2 8350 
0258 6EE4 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6EE6 8352 
0259 6EE8 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6EEA 8354 
0260                       ;------------------------------------------------------
0261                       ; 3b: Do actual index update
0262                       ;------------------------------------------------------
0263               fh.file.read.sams.updindex:
0264 6EEC 06A0  32         bl    @idx.entry.update     ; Update index
     6EEE 6992 
0265                                                   ; \ i  parm1    = Line num in editor buffer
0266                                                   ; | i  parm2    = Pointer to line in editor
0267                                                   ; |               buffer
0268                                                   ; | i  parm3    = SAMS page
0269                                                   ; | o  outparm1 = Pointer to updated index
0270                                                   ; /               entry
0271               
0272 6EF0 05A0  34         inc   @edb.lines            ; lines=lines+1
     6EF2 A204 
0273                       ;------------------------------------------------------
0274                       ; Step 4: Callback "Read line from file"
0275                       ;------------------------------------------------------
0276               fh.file.read.sams.display:
0277 6EF4 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6EF6 A43E 
0278 6EF8 0694  24         bl    *tmp0                 ; Run callback function
0279                       ;------------------------------------------------------
0280                       ; 4a: Next record
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.next:
0283 6EFA 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6EFC 2AC2 
0284 6EFE 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0285               
0286 6F00 0460  28         b     @fh.file.read.sams.record
     6F02 6E16 
0287                                                   ; Next record
0288                       ;------------------------------------------------------
0289                       ; Error handler
0290                       ;------------------------------------------------------
0291               fh.file.read.sams.error:
0292 6F04 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6F06 A42A 
0293 6F08 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0294 6F0A 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6F0C 0005 
0295 6F0E 1309  14         jeq   fh.file.read.sams.eof
0296                                                   ; All good. File closed by DSRLNK
0297                       ;------------------------------------------------------
0298                       ; File error occured
0299                       ;------------------------------------------------------
0300 6F10 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F12 2AE4 
0301 6F14 3F00                   data scrpad.backup2   ; / >2100->8300
0302               
0303 6F16 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F18 6708 
0304                       ;------------------------------------------------------
0305                       ; Callback "File I/O error"
0306                       ;------------------------------------------------------
0307 6F1A C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     6F1C A442 
0308 6F1E 0694  24         bl    *tmp0                 ; Run callback function
0309 6F20 1008  14         jmp   fh.file.read.sams.exit
0310                       ;------------------------------------------------------
0311                       ; End-Of-File reached
0312                       ;------------------------------------------------------
0313               fh.file.read.sams.eof:
0314 6F22 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6F24 2AE4 
0315 6F26 3F00                   data scrpad.backup2   ; / >2100->8300
0316               
0317 6F28 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     6F2A 6708 
0318                       ;------------------------------------------------------
0319                       ; Callback "Close file"
0320                       ;------------------------------------------------------
0321 6F2C C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     6F2E A440 
0322 6F30 0694  24         bl    *tmp0                 ; Run callback function
0323               *--------------------------------------------------------------
0324               * Exit
0325               *--------------------------------------------------------------
0326               fh.file.read.sams.exit:
0327 6F32 C2F9  30         mov   *stack+,r11           ; Pop r11
0328 6F34 045B  20         b     *r11                  ; Return to caller
0329               
0330               
0331               
0332               ***************************************************************
0333               * PAB for accessing DV/80 file
0334               ********|*****|*********************|**************************
0335               fh.file.pab.header:
0336 6F36 0014             byte  io.op.open            ;  0    - OPEN
0337                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0338 6F38 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0339 6F3A 5000             byte  80                    ;  4    - Record length (80 chars max)
0340                       byte  00                    ;  5    - Character count
0341 6F3C 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0342 6F3E 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0343                       ;------------------------------------------------------
0344                       ; File descriptor part (variable length)
0345                       ;------------------------------------------------------
0346                       ; byte  12                  ;  9    - File descriptor length
0347                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0348                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.210353
0053                       copy  "fm.load.asm"         ; File manager loadfile
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
0014 6F40 0649  14         dect  stack
0015 6F42 C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6F44 C804  38         mov   tmp0,@parm1           ; Setup file to load
     6F46 8350 
0018 6F48 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6F4A 6AEE 
0019 6F4C 06A0  32         bl    @idx.init             ; Initialize index
     6F4E 6890 
0020 6F50 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6F52 6764 
0021 6F54 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6F56 7302 
0022 6F58 C820  54         mov   @parm1,@edb.filename.ptr
     6F5A 8350 
     6F5C A20E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6F5E 06A0  32         bl    @filv
     6F60 2288 
0028 6F62 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6F64 0000 
     6F66 0004 
0029               
0030 6F68 C160  34         mov   @fb.scrrows,tmp1
     6F6A A118 
0031 6F6C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6F6E A10E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6F70 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0035 6F72 0205  20         li    tmp1,32               ; Character to fill
     6F74 0020 
0036               
0037 6F76 06A0  32         bl    @xfilv                ; Fill VDP memory
     6F78 228E 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6F7A 0204  20         li    tmp0,fm.loadfile.cb.indicator1
     6F7C 6FAE 
0045 6F7E C804  38         mov   tmp0,@parm2           ; Register callback 1
     6F80 8352 
0046               
0047 6F82 0204  20         li    tmp0,fm.loadfile.cb.indicator2
     6F84 6FD6 
0048 6F86 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6F88 8354 
0049               
0050 6F8A 0204  20         li    tmp0,fm.loadfile.cb.indicator3
     6F8C 7008 
0051 6F8E C804  38         mov   tmp0,@parm4           ; Register callback 3
     6F90 8356 
0052               
0053 6F92 0204  20         li    tmp0,fm.loadfile.cb.fioerr
     6F94 703A 
0054 6F96 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6F98 8358 
0055               
0056 6F9A 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6F9C 6D58 
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
0068 6F9E 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6FA0 A206 
0069                                                   ; longer dirty.
0070               
0071 6FA2 0204  20         li    tmp0,txt.filetype.DV80
     6FA4 755C 
0072 6FA6 C804  38         mov   tmp0,@edb.filetype.ptr
     6FA8 A210 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6FAA 0460  28         b     @poprt                ; Return to caller
     6FAC 222C 
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
0089 6FAE 0649  14         dect  stack
0090 6FB0 C64B  30         mov   r11,*stack            ; Save return address
0091                       ;------------------------------------------------------
0092                       ; Show loading indicators and file descriptor
0093                       ;------------------------------------------------------
0094 6FB2 06A0  32         bl    @hchar
     6FB4 2762 
0095 6FB6 1D03                   byte 29,3,32,77
     6FB8 204D 
0096 6FBA FFFF                   data EOL
0097               
0098 6FBC 06A0  32         bl    @putat
     6FBE 242A 
0099 6FC0 1D03                   byte 29,3
0100 6FC2 74D4                   data txt.loading      ; Display "Loading...."
0101               
0102 6FC4 06A0  32         bl    @at
     6FC6 266E 
0103 6FC8 1D0E                   byte 29,14            ; Cursor YX position
0104 6FCA C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     6FCC 8350 
0105 6FCE 06A0  32         bl    @xutst0               ; Display device/filename
     6FD0 241A 
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               fm.loadfile.cb.indicator1.exit:
0110 6FD2 0460  28         b     @poprt                ; Return to caller
     6FD4 222C 
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
0122 6FD6 0649  14         dect  stack
0123 6FD8 C64B  30         mov   r11,*stack            ; Save return address
0124               
0125 6FDA 06A0  32         bl    @putnum
     6FDC 2A3E 
0126 6FDE 1D4B                   byte 29,75            ; Show lines read
0127 6FE0 A204                   data edb.lines,rambuf,>3020
     6FE2 8390 
     6FE4 3020 
0128               
0129 6FE6 8220  34         c     @fh.kilobytes,tmp4
     6FE8 A432 
0130 6FEA 130C  14         jeq   fm.loadfile.cb.indicator2.exit
0131               
0132 6FEC C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     6FEE A432 
0133               
0134 6FF0 06A0  32         bl    @putnum
     6FF2 2A3E 
0135 6FF4 1D38                   byte 29,56            ; Show kilobytes read
0136 6FF6 A432                   data fh.kilobytes,rambuf,>3020
     6FF8 8390 
     6FFA 3020 
0137               
0138 6FFC 06A0  32         bl    @putat
     6FFE 242A 
0139 7000 1D3D                   byte 29,61
0140 7002 74E0                   data txt.kb           ; Show "kb" string
0141                       ;------------------------------------------------------
0142                       ; Exit
0143                       ;------------------------------------------------------
0144               fm.loadfile.cb.indicator2.exit:
0145 7004 0460  28         b     @poprt                ; Return to caller
     7006 222C 
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
0158 7008 0649  14         dect  stack
0159 700A C64B  30         mov   r11,*stack            ; Save return address
0160               
0161               
0162 700C 06A0  32         bl    @hchar
     700E 2762 
0163 7010 1D03                   byte 29,3,32,50       ; Erase loading indicator
     7012 2032 
0164 7014 FFFF                   data EOL
0165               
0166 7016 06A0  32         bl    @putnum
     7018 2A3E 
0167 701A 1D38                   byte 29,56            ; Show kilobytes read
0168 701C A432                   data fh.kilobytes,rambuf,>3020
     701E 8390 
     7020 3020 
0169               
0170 7022 06A0  32         bl    @putat
     7024 242A 
0171 7026 1D3D                   byte 29,61
0172 7028 74E0                   data txt.kb           ; Show "kb" string
0173               
0174 702A 06A0  32         bl    @putnum
     702C 2A3E 
0175 702E 1D4B                   byte 29,75            ; Show lines read
0176 7030 A42E                   data fh.records,rambuf,>3020
     7032 8390 
     7034 3020 
0177                       ;------------------------------------------------------
0178                       ; Exit
0179                       ;------------------------------------------------------
0180               fm.loadfile.cb.indicator3.exit:
0181 7036 0460  28         b     @poprt                ; Return to caller
     7038 222C 
0182               
0183               
0184               
0185               *---------------------------------------------------------------
0186               * Callback function "File I/O error handler"
0187               *---------------------------------------------------------------
0188               * Is expected to be passed as parm5 to @tfh.file.read
0189               ********|*****|*********************|**************************
0190               fm.loadfile.cb.fioerr:
0191 703A 0649  14         dect  stack
0192 703C C64B  30         mov   r11,*stack            ; Save return address
0193               
0194 703E 06A0  32         bl    @hchar
     7040 2762 
0195 7042 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7044 2032 
0196 7046 FFFF                   data EOL
0197               
0198                       ;------------------------------------------------------
0199                       ; Display I/O error message
0200                       ;------------------------------------------------------
0201 7048 06A0  32         bl    @cpym2m
     704A 247A 
0202 704C 74EF                   data txt.ioerr+1
0203 704E D000                   data cmdb.top
0204 7050 0029                   data 41               ; Error message
0205               
0206               
0207 7052 C120  34         mov   @edb.filename.ptr,tmp0
     7054 A20E 
0208 7056 D194  26         movb  *tmp0,tmp2            ; Get length byte
0209 7058 0986  56         srl   tmp2,8                ; Right align
0210 705A 0584  14         inc   tmp0                  ; Skip length byte
0211 705C 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     705E D02A 
0212               
0213 7060 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     7062 2480 
0214                                                   ; | i  tmp0 = ROM/RAM source
0215                                                   ; | i  tmp1 = RAM destination
0216                                                   ; / i  tmp2 = Bytes top copy
0217               
0218               
0219 7064 0204  20         li    tmp0,txt.newfile      ; New file
     7066 751C 
0220 7068 C804  38         mov   tmp0,@edb.filename.ptr
     706A A20E 
0221               
0222 706C 0204  20         li    tmp0,txt.filetype.none
     706E 7568 
0223 7070 C804  38         mov   tmp0,@edb.filetype.ptr
     7072 A210 
0224                                                   ; Empty filetype string
0225               
0226 7074 C820  54         mov   @cmdb.scrrows,@parm1
     7076 A304 
     7078 8350 
0227 707A 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     707C 72C8 
0228                       ;------------------------------------------------------
0229                       ; Exit
0230                       ;------------------------------------------------------
0231               fm.loadfile.cb.fioerr.exit:
0232 707E 0460  28         b     @poprt                ; Return to caller
     7080 222C 
**** **** ****     > stevie_b1.asm.210353
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
0012 7082 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7084 2014 
0013 7086 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 7088 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     708A 2014 
0019 708C 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     708E 833C 
     7090 833E 
0020 7092 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 7094 C820  54         mov   @waux1,@waux2         ; Save as previous key
     7096 833C 
     7098 833E 
0026 709A 0460  28         b     @edkey.key.process    ; Process key
     709C 611E 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 709E 04E0  34         clr   @waux1
     70A0 833C 
0032 70A2 04E0  34         clr   @waux2
     70A4 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 70A6 0204  20         li    tmp0,2000             ; Avoid key bouncing
     70A8 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 70AA 0604  14         dec   tmp0
0043 70AC 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 70AE 0460  28         b     @hookok               ; Return
     70B0 2C9A 
**** **** ****     > stevie_b1.asm.210353
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
0012 70B2 C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     70B4 A116 
0013 70B6 1342  14         jeq   task.vdp.panes.exit   ; No, skip update
0014 70B8 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     70BA 832A 
     70BC A114 
0015                       ;------------------------------------------------------
0016                       ; Determine how many rows to copy
0017                       ;------------------------------------------------------
0018 70BE 8820  54         c     @edb.lines,@fb.scrrows
     70C0 A204 
     70C2 A118 
0019 70C4 1103  14         jlt   task.vdp.panes.setrows.small
0020 70C6 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     70C8 A118 
0021 70CA 1003  14         jmp   task.vdp.panes.copy.framebuffer
0022                       ;------------------------------------------------------
0023                       ; Less lines in editor buffer as rows in frame buffer
0024                       ;------------------------------------------------------
0025               task.vdp.panes.setrows.small:
0026 70CC C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     70CE A204 
0027 70D0 0585  14         inc   tmp1
0028                       ;------------------------------------------------------
0029                       ; Determine area to copy
0030                       ;------------------------------------------------------
0031               task.vdp.panes.copy.framebuffer:
0032 70D2 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     70D4 A10E 
0033                                                   ; 16 bit part is in tmp2!
0034 70D6 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0035 70D8 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     70DA A100 
0036                       ;------------------------------------------------------
0037                       ; Copy memory block
0038                       ;------------------------------------------------------
0039 70DC 06A0  32         bl    @xpym2v               ; Copy to VDP
     70DE 2438 
0040                                                   ; \ i  tmp0 = VDP target address
0041                                                   ; | i  tmp1 = RAM source address
0042                                                   ; / i  tmp2 = Bytes to copy
0043 70E0 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     70E2 A116 
0044                       ;-------------------------------------------------------
0045                       ; Draw EOF marker at end-of-file
0046                       ;-------------------------------------------------------
0047 70E4 C120  34         mov   @edb.lines,tmp0
     70E6 A204 
0048 70E8 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     70EA A104 
0049 70EC 0584  14         inc   tmp0                  ; Y = Y + 1
0050 70EE 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     70F0 A118 
0051 70F2 121F  14         jle   task.vdp.panes.draw.cmdb
0052                       ;-------------------------------------------------------
0053                       ; Do actual drawing of EOF marker
0054                       ;-------------------------------------------------------
0055               task.vdp.panes.draw_marker:
0056 70F4 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0057 70F6 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     70F8 832A 
0058               
0059 70FA 06A0  32         bl    @putstr
     70FC 2418 
0060 70FE 74BE                   data txt.marker       ; Display *EOF*
0061                       ;-------------------------------------------------------
0062                       ; Draw empty line after (and below) EOF marker
0063                       ;-------------------------------------------------------
0064 7100 06A0  32         bl    @setx
     7102 2684 
0065 7104 0005                   data  5               ; Cursor after *EOF* string
0066               
0067 7106 C120  34         mov   @wyx,tmp0
     7108 832A 
0068 710A 0984  56         srl   tmp0,8                ; Right justify
0069 710C 0584  14         inc   tmp0                  ; One time adjust
0070 710E 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     7110 A118 
0071 7112 1303  14         jeq   !
0072 7114 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7116 009B 
0073 7118 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0074 711A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     711C 004B 
0075                       ;-------------------------------------------------------
0076                       ; Draw 1 or 2 empty lines
0077                       ;-------------------------------------------------------
0078               task.vdp.panes.draw_marker.empty.line:
0079 711E 0604  14         dec   tmp0                  ; One time adjust
0080 7120 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7122 23F4 
0081                                                   ; \ i  @wyx = Cursor position
0082                                                   ; / o  tmp0 = VDP address
0083               
0084 7124 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7126 0020 
0085 7128 06A0  32         bl    @xfilv                ; Fill VDP memory
     712A 228E 
0086                                                   ; \ i  tmp0 = VDP destination
0087                                                   ; | i  tmp1 = byte to write
0088                                                   ; / i  tmp2 = Number of bytes to write
0089               
0090 712C C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     712E A114 
     7130 832A 
0091                       ;-------------------------------------------------------
0092                       ; Show command buffer
0093                       ;-------------------------------------------------------
0094               task.vdp.panes.draw.cmdb:
0095 7132 C120  34         mov   @cmdb.visible,tmp0    ; Show command buffer?
     7134 A302 
0096 7136 1302  14         jeq   task.vdp.panes.exit   ; No, skip
0097 7138 06A0  32         bl    @pane.cmdb.draw       ; Draw command buffer
     713A 7290 
0098                       ;------------------------------------------------------
0099                       ; Exit task
0100                       ;------------------------------------------------------
0101               task.vdp.panes.exit:
0102 713C 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     713E 7322 
0103 7140 0460  28         b     @slotok
     7142 2D16 
**** **** ****     > stevie_b1.asm.210353
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
0012 7144 C120  34         mov   @tv.pane.focus,tmp0
     7146 A016 
0013 7148 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 714A 0284  22         ci    tmp0,pane.focus.cmdb
     714C 0001 
0016 714E 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 7150 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7152 FFCE 
0022 7154 06A0  32         bl    @cpu.crash            ; / Halt system.
     7156 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7158 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     715A A308 
     715C 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 715E E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     7160 202A 
0032 7162 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     7164 2690 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7166 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7168 8380 
0036               
0037 716A 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     716C 2432 
0038 716E 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7170 8380 
     7172 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7174 0460  28         b     @slotok               ; Exit task
     7176 2D16 
**** **** ****     > stevie_b1.asm.210353
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
0012 7178 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     717A A112 
0013 717C 1303  14         jeq   task.vdp.cursor.visible
0014 717E 04E0  34         clr   @ramsat+2              ; Hide cursor
     7180 8382 
0015 7182 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7184 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7186 A20A 
0019 7188 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 718A C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     718C A016 
0025 718E 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 7190 0284  22         ci    tmp0,pane.focus.cmdb
     7192 0001 
0028 7194 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 7196 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 7198 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 719A 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     719C 0100 
0040 719E 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 71A0 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     71A2 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 71A4 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     71A6 A014 
0051 71A8 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     71AA A014 
     71AC 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 71AE 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     71B0 2432 
0057 71B2 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     71B4 8380 
     71B6 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 71B8 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     71BA 7322 
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               task.vdp.cursor.exit:
0068 71BC 0460  28         b     @slotok                ; Exit task
     71BE 2D16 
**** **** ****     > stevie_b1.asm.210353
0058               
0059                       copy  "pane.utils.colorscheme.asm"
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
0021 71C0 0649  14         dect  stack
0022 71C2 C64B  30         mov   r11,*stack            ; Push return address
0023 71C4 0649  14         dect  stack
0024 71C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 71C8 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     71CA A012 
0027 71CC 0284  22         ci    tmp0,tv.colorscheme.entries
     71CE 0004 
0028                                                   ; Last entry reached?
0029 71D0 1102  14         jlt   !
0030 71D2 04C4  14         clr   tmp0
0031 71D4 1001  14         jmp   pane.action.colorscheme.switch
0032 71D6 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 71D8 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     71DA A012 
0038 71DC 06A0  32         bl    @pane.action.colorscheme.load
     71DE 71E6 
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               pane.action.colorscheme.cycle.exit:
0043 71E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0044 71E2 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 71E4 045B  20         b     *r11                  ; Return to caller
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
0067 71E6 0649  14         dect  stack
0068 71E8 C64B  30         mov   r11,*stack            ; Save return address
0069 71EA 0649  14         dect  stack
0070 71EC C644  30         mov   tmp0,*stack           ; Push tmp0
0071 71EE 0649  14         dect  stack
0072 71F0 C645  30         mov   tmp1,*stack           ; Push tmp1
0073 71F2 0649  14         dect  stack
0074 71F4 C646  30         mov   tmp2,*stack           ; Push tmp2
0075 71F6 0649  14         dect  stack
0076 71F8 C647  30         mov   tmp3,*stack           ; Push tmp3
0077 71FA 06A0  32         bl    @scroff               ; Turn screen off
     71FC 262E 
0078                       ;-------------------------------------------------------
0079                       ; Get foreground/background color
0080                       ;-------------------------------------------------------
0081 71FE C120  34         mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7200 A012 
0082 7202 0A14  56         sla   tmp0,1                ; Offset into color scheme data table
0083 7204 0224  22         ai    tmp0,tv.colorscheme.table
     7206 74B4 
0084                                                   ; Add base for color scheme data table
0085 7208 C1D4  26         mov   *tmp0,tmp3            ; Get fg/bg color
0086                       ;-------------------------------------------------------
0087                       ; Dump cursor FG color to sprite table (SAT)
0088                       ;-------------------------------------------------------
0089 720A C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0090 720C 0945  56         srl   tmp1,4                ; Move nibble to right
0091 720E 0245  22         andi  tmp1,>0f00
     7210 0F00 
0092 7212 D805  38         movb  tmp1,@ramsat+3        ; Update FG color in sprite table (SAT)
     7214 8383 
0093 7216 D805  38         movb  tmp1,@tv.curshape+1   ; Save cursor color
     7218 A015 
0094                       ;-------------------------------------------------------
0095                       ; Dump colors to VDP register 7 (text mode)
0096                       ;-------------------------------------------------------
0097 721A C147  18         mov   tmp3,tmp1             ; Get work copy
0098 721C 0985  56         srl   tmp1,8                ; MSB to LSB
0099 721E 0265  22         ori   tmp1,>0700
     7220 0700 
0100 7222 C105  18         mov   tmp1,tmp0
0101 7224 06A0  32         bl    @putvrx               ; Write VDP register
     7226 232E 
0102                       ;-------------------------------------------------------
0103                       ; Dump colors for frame buffer pane (TAT)
0104                       ;-------------------------------------------------------
0105 7228 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     722A 1800 
0106 722C C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0107 722E 0985  56         srl   tmp1,8                ; MSB to LSB
0108 7230 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     7232 0910 
0109 7234 06A0  32         bl    @xfilv                ; Fill colors
     7236 228E 
0110                                                   ; i \  tmp0 = start address
0111                                                   ; i |  tmp1 = byte to fill
0112                                                   ; i /  tmp2 = number of bytes to fill
0113                       ;-------------------------------------------------------
0114                       ; Dump colors for bottom status line pane (TAT)
0115                       ;-------------------------------------------------------
0116 7238 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     723A 2110 
0117 723C C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0118 723E 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     7240 00FF 
0119 7242 0206  20         li    tmp2,80               ; Number of bytes to fill
     7244 0050 
0120 7246 06A0  32         bl    @xfilv                ; Fill colors
     7248 228E 
0121                                                   ; i \  tmp0 = start address
0122                                                   ; i |  tmp1 = byte to fill
0123                                                   ; i /  tmp2 = number of bytes to fill
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               pane.action.colorscheme.load.exit:
0128 724A 06A0  32         bl    @scron                ; Turn screen on
     724C 2636 
0129 724E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0130 7250 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 7252 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 7254 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 7256 C2F9  30         mov   *stack+,r11           ; Pop R11
0134 7258 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
0060                                                   ; Colorscheme handling in panges
0061                       copy  "pane.utils.tipiclock.asm"
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
0021 725A 0649  14         dect  stack
0022 725C C64B  30         mov   r11,*stack            ; Push return address
0023 725E 0649  14         dect  stack
0024 7260 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 7262 0204  20         li    tmp0,fdname.clock
     7264 762E 
0029 7266 C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     7268 8350 
0030               
0031 726A 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     726C 728C 
0032 726E C804  38         mov   tmp0,@parm2           ; Register callback 1
     7270 8352 
0033 7272 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7274 8354 
0034 7276 C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     7278 8358 
0035               
0036 727A 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     727C 728E 
0037 727E C804  38         mov   tmp0,@parm4           ; Register callback 3
     7280 8356 
0038               
0039 7282 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     7284 6D58 
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
0055 7286 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 7288 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 728A 045B  20         b     *r11                  ; Return to caller
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
0070 728C 069B  24         bl    *r11                  ; Return to caller
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
0083 728E 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
0062                                                   ; Colorscheme
0063               
0064                       copy  "pane.cmdb.asm"       ; Command buffer pane
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
0021 7290 0649  14         dect  stack
0022 7292 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Draw command buffer
0025                       ;------------------------------------------------------
0026 7294 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     7296 6D0E 
0027               
0028 7298 06A0  32         bl    @vchar
     729A 278A 
0029 729C 1200                   byte 18,0,4,1          ; Top left corner
     729E 0401 
0030 72A0 124F                   byte 18,79,5,1         ; Top right corner
     72A2 0501 
0031 72A4 1300                   byte 19,0,6,9          ; Left vertical double line
     72A6 0609 
0032 72A8 134F                   byte 19,79,7,9         ; Right vertical double line
     72AA 0709 
0033 72AC 1C00                   byte 28,0,8,1          ; Bottom left corner
     72AE 0801 
0034 72B0 1C4F                   byte 28,79,9,1         ; Bottom right corner
     72B2 0901 
0035 72B4 FFFF                   data EOL
0036               
0037 72B6 06A0  32         bl    @hchar
     72B8 2762 
0038 72BA 1201                   byte 18,1,3,78         ; Horizontal top line
     72BC 034E 
0039 72BE 1C01                   byte 28,1,3,78         ; Horizontal bottom line
     72C0 034E 
0040 72C2 FFFF                   data EOL
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               pane.cmdb.exit:
0045 72C4 C2F9  30         mov   *stack+,r11           ; Pop r11
0046 72C6 045B  20         b     *r11                  ; Return
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
0067 72C8 0649  14         dect  stack
0068 72CA C64B  30         mov   r11,*stack            ; Save return address
0069 72CC 0649  14         dect  stack
0070 72CE C644  30         mov   tmp0,*stack           ; Push tmp0
0071                       ;------------------------------------------------------
0072                       ; Show command buffer pane
0073                       ;------------------------------------------------------
0074 72D0 C820  54         mov   @wyx,@cmdb.fb.yxsave
     72D2 832A 
     72D4 A312 
0075                                                   ; Save YX position in frame buffer
0076               
0077 72D6 C120  34         mov   @fb.scrrows.max,tmp0
     72D8 A11A 
0078 72DA 6120  34         s     @cmdb.scrrows,tmp0
     72DC A304 
0079 72DE C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     72E0 A118 
0080               
0081 72E2 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0082 72E4 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0083 72E6 0584  14         inc   tmp0                  ; X=1
0084 72E8 C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
     72EA A30C 
0085               
0086 72EC 0720  34         seto  @cmdb.visible         ; Show pane
     72EE A302 
0087               
0088 72F0 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     72F2 0001 
0089 72F4 C804  38         mov   tmp0,@tv.pane.focus   ; /
     72F6 A016 
0090               
0091 72F8 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     72FA A116 
0092               
0093               pane.cmdb.show.exit:
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097 72FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0098 72FE C2F9  30         mov   *stack+,r11           ; Pop r11
0099 7300 045B  20         b     *r11                  ; Return to caller
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
0122 7302 0649  14         dect  stack
0123 7304 C64B  30         mov   r11,*stack            ; Save return address
0124                       ;------------------------------------------------------
0125                       ; Hide command buffer pane
0126                       ;------------------------------------------------------
0127 7306 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7308 A11A 
     730A A118 
0128                                                   ; Resize framebuffer
0129               
0130 730C C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     730E A312 
     7310 832A 
0131               
0132 7312 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7314 A302 
0133 7316 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7318 A116 
0134 731A 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     731C A016 
0135               
0136               pane.cmdb.hide.exit:
0137                       ;------------------------------------------------------
0138                       ; Exit
0139                       ;------------------------------------------------------
0140 731E C2F9  30         mov   *stack+,r11           ; Pop r11
0141 7320 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.210353
0065                       copy  "pane.botline.asm"    ; Status line pane
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
0021 7322 0649  14         dect  stack
0022 7324 C64B  30         mov   r11,*stack            ; Save return address
0023 7326 0649  14         dect  stack
0024 7328 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 732A C820  54         mov   @wyx,@fb.yxsave
     732C 832A 
     732E A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 7330 06A0  32         bl    @putat
     7332 242A 
0032 7334 1D00                   byte  29,0
0033 7336 7518                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 7338 06A0  32         bl    @at
     733A 266E 
0039 733C 1D03                   byte  29,3            ; Position cursor
0040 733E C160  34         mov   @edb.filename.ptr,tmp1
     7340 A20E 
0041                                                   ; Get string to display
0042 7342 06A0  32         bl    @xutst0               ; Display string
     7344 241A 
0043               
0044 7346 06A0  32         bl    @at
     7348 266E 
0045 734A 1D23                   byte  29,35           ; Position cursor
0046               
0047 734C C160  34         mov   @edb.filetype.ptr,tmp1
     734E A210 
0048                                                   ; Get string to display
0049 7350 06A0  32         bl    @xutst0               ; Display Filetype string
     7352 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 7354 C120  34         mov   @edb.insmode,tmp0
     7356 A20A 
0055 7358 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 735A 06A0  32         bl    @putat
     735C 242A 
0061 735E 1D32                   byte  29,50
0062 7360 74CA                   data  txt.ovrwrite
0063 7362 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 7364 06A0  32         bl    @putat
     7366 242A 
0069 7368 1D32                   byte  29,50
0070 736A 74CE                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 736C C120  34         mov   @edb.dirty,tmp0
     736E A206 
0076 7370 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7372 06A0  32         bl    @putat
     7374 242A 
0081 7376 1D36                   byte 29,54
0082 7378 74D2                   data txt.star
0083 737A 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 737C 1000  14         nop
0089               pane.botline.show_linecol:
0090 737E C820  54         mov   @fb.row,@parm1
     7380 A106 
     7382 8350 
0091 7384 06A0  32         bl    @fb.row2line
     7386 67A6 
0092 7388 05A0  34         inc   @outparm1
     738A 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 738C 06A0  32         bl    @putnum
     738E 2A3E 
0097 7390 1D40                   byte  29,64           ; YX
0098 7392 8360                   data  outparm1,rambuf
     7394 8390 
0099 7396 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7398 06A0  32         bl    @putat
     739A 242A 
0105 739C 1D45                   byte  29,69
0106 739E 74BC                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 73A0 06A0  32         bl    @film
     73A2 2230 
0111 73A4 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     73A6 0020 
     73A8 000C 
0112               
0113 73AA C820  54         mov   @fb.column,@waux1
     73AC A10C 
     73AE 833C 
0114 73B0 05A0  34         inc   @waux1                ; Offset 1
     73B2 833C 
0115               
0116 73B4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     73B6 29C0 
0117 73B8 833C                   data  waux1,rambuf
     73BA 8390 
0118 73BC 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 73BE 06A0  32         bl    @trimnum              ; Trim number to the left
     73C0 2A18 
0122 73C2 8390                   data  rambuf,rambuf+6,32
     73C4 8396 
     73C6 0020 
0123               
0124 73C8 0204  20         li    tmp0,>0200
     73CA 0200 
0125 73CC D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     73CE 8396 
0126               
0127 73D0 06A0  32         bl    @putat
     73D2 242A 
0128 73D4 1D46                   byte 29,70
0129 73D6 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 73D8 C820  54         mov   @fb.row,@parm1
     73DA A106 
     73DC 8350 
0134 73DE 06A0  32         bl    @fb.row2line
     73E0 67A6 
0135 73E2 8820  54         c     @edb.lines,@outparm1
     73E4 A204 
     73E6 8360 
0136 73E8 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 73EA 06A0  32         bl    @putat
     73EC 242A 
0139 73EE 1D4B                   byte 29,75
0140 73F0 74C4                   data txt.bottom
0141               
0142 73F2 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 73F4 C820  54         mov   @edb.lines,@waux1
     73F6 A204 
     73F8 833C 
0148 73FA 05A0  34         inc   @waux1                ; Offset 1
     73FC 833C 
0149 73FE 06A0  32         bl    @putnum
     7400 2A3E 
0150 7402 1D4B                   byte 29,75            ; YX
0151 7404 833C                   data waux1,rambuf
     7406 8390 
0152 7408 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 740A C820  54         mov   @fb.yxsave,@wyx
     740C A114 
     740E 832A 
0159 7410 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 7412 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7414 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.210353
0066                       copy  "data.constants.asm"  ; Data segment - Constants
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
0033 7416 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     7418 003F 
     741A 0243 
     741C 05F4 
     741E 0050 
0034               
0035               romsat:
0036 7420 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     7422 0001 
0037               
0038               cursors:
0039 7424 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     7426 0000 
     7428 0000 
     742A 001C 
0040 742C 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     742E 1010 
     7430 1010 
     7432 1000 
0041 7434 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     7436 1C1C 
     7438 1C1C 
     743A 1C00 
0042               
0043               patterns:
0044 743C 0000             data  >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
     743E FF00 
     7440 00FF 
     7442 0080 
0045 7444 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     7446 0000 
     7448 FF00 
     744A FF00 
0046               patterns.box:
0047 744C 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     744E 0000 
     7450 FF00 
     7452 FF00 
0048 7454 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     7456 0000 
     7458 FF80 
     745A BFA0 
0049 745C 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     745E 0000 
     7460 FC04 
     7462 F414 
0050 7464 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     7466 A0A0 
     7468 A0A0 
     746A A0A0 
0051 746C 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     746E 1414 
     7470 1414 
     7472 1414 
0052 7474 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     7476 A0A0 
     7478 BF80 
     747A FF00 
0053 747C 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     747E 1414 
     7480 F404 
     7482 FC00 
0054 7484 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     7486 C0C0 
     7488 C0C0 
     748A 0080 
0055 748C 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     748E 0F0F 
     7490 0F0F 
     7492 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 7494 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     7496 0002 
0065 7498 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     749A 0003 
0066 749C A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     749E 000A 
0067               
0068 74A0 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     74A2 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 74A4 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     74A6 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 74A8 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     74AA 000D 
0077 74AC E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     74AE 000E 
0078 74B0 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     74B2 000F 
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
0094 74B4 F41C             data  >f41c                 ; White      | Dark blue  | Dark blue
0095 74B6 F13A             data  >f13a                 ; White      | Black      | Black
0096 74B8 174B             data  >174b                 ; Black      | Cyan       | Cyan
0097 74BA 1F53             data  >1f53                 ; Black      | White      | White
0098               
**** **** ****     > stevie_b1.asm.210353
0067                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 74BC 012C             byte  1
0009 74BD ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 74BE 052A             byte  5
0014 74BF ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 74C4 0520             byte  5
0019 74C5 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 74CA 034F             byte  3
0024 74CB ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 74CE 0349             byte  3
0029 74CF ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 74D2 012A             byte  1
0034 74D3 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 74D4 0A4C             byte  10
0039 74D5 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 74E0 026B             byte  2
0044 74E1 ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 74E4 0352             byte  3
0049 74E5 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 74E8 054C             byte  5
0054 74E9 ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 74EE 2921             byte  41
0059 74EF ....             text  '! I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 7518 0223             byte  2
0064 7519 ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 751C 0A5B             byte  10
0069 751D ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.prompt
0074 7528 013E             byte  1
0075 7529 ....             text  '>'
0076                       even
0077               
0078               txt.cmdb.hint
0079 752A 2348             byte  35
0080 752B ....             text  'Hint: Type "help" for command list.'
0081                       even
0082               
0083               txt.cmdb.catalog
0084 754E 0C46             byte  12
0085 754F ....             text  'File catalog'
0086                       even
0087               
0088               
0089               
0090               txt.filetype.dv80
0091 755C 0A44             byte  10
0092 755D ....             text  'DIS/VAR80 '
0093                       even
0094               
0095               txt.filetype.none
0096 7568 0A20             byte  10
0097 7569 ....             text  '          '
0098                       even
0099               
0100               
0101 7574 0C0A     txt.stevie         byte    12
0102                                  byte    10
0103 7576 ....                        text    'stevie v1.00'
0104 7582 0B00                        byte    11
0105                                  even
0106               
0107               fdname1
0108 7584 0850             byte  8
0109 7585 ....             text  'PI.CLOCK'
0110                       even
0111               
0112               fdname2
0113 758E 0E54             byte  14
0114 758F ....             text  'TIPI.TIVI.NR80'
0115                       even
0116               
0117               fdname3
0118 759E 0C44             byte  12
0119 759F ....             text  'DSK1.XBEADOC'
0120                       even
0121               
0122               fdname4
0123 75AC 1154             byte  17
0124 75AD ....             text  'TIPI.TIVI.C99MAN1'
0125                       even
0126               
0127               fdname5
0128 75BE 1154             byte  17
0129 75BF ....             text  'TIPI.TIVI.C99MAN2'
0130                       even
0131               
0132               fdname6
0133 75D0 1154             byte  17
0134 75D1 ....             text  'TIPI.TIVI.C99MAN3'
0135                       even
0136               
0137               fdname7
0138 75E2 1254             byte  18
0139 75E3 ....             text  'TIPI.TIVI.C99SPECS'
0140                       even
0141               
0142               fdname8
0143 75F6 1254             byte  18
0144 75F7 ....             text  'TIPI.TIVI.RANDOM#C'
0145                       even
0146               
0147               fdname9
0148 760A 1254             byte  18
0149 760B ....             text  'TIPI.TIVI.INVADERS'
0150                       even
0151               
0152               fdname0
0153 761E 0E54             byte  14
0154 761F ....             text  'TIPI.TIVI.NR80'
0155                       even
0156               
0157               fdname.clock
0158 762E 0850             byte  8
0159 762F ....             text  'PI.CLOCK'
0160                       even
0161               
0162               
0163               
0164               *---------------------------------------------------------------
0165               * Keyboard labels - Function keys
0166               *---------------------------------------------------------------
0167               txt.fctn.0
0168 7638 0866             byte  8
0169 7639 ....             text  'fctn + 0'
0170                       even
0171               
0172               txt.fctn.1
0173 7642 0866             byte  8
0174 7643 ....             text  'fctn + 1'
0175                       even
0176               
0177               txt.fctn.2
0178 764C 0866             byte  8
0179 764D ....             text  'fctn + 2'
0180                       even
0181               
0182               txt.fctn.3
0183 7656 0866             byte  8
0184 7657 ....             text  'fctn + 3'
0185                       even
0186               
0187               txt.fctn.4
0188 7660 0866             byte  8
0189 7661 ....             text  'fctn + 4'
0190                       even
0191               
0192               txt.fctn.5
0193 766A 0866             byte  8
0194 766B ....             text  'fctn + 5'
0195                       even
0196               
0197               txt.fctn.6
0198 7674 0866             byte  8
0199 7675 ....             text  'fctn + 6'
0200                       even
0201               
0202               txt.fctn.7
0203 767E 0866             byte  8
0204 767F ....             text  'fctn + 7'
0205                       even
0206               
0207               txt.fctn.8
0208 7688 0866             byte  8
0209 7689 ....             text  'fctn + 8'
0210                       even
0211               
0212               txt.fctn.9
0213 7692 0866             byte  8
0214 7693 ....             text  'fctn + 9'
0215                       even
0216               
0217               txt.fctn.a
0218 769C 0866             byte  8
0219 769D ....             text  'fctn + a'
0220                       even
0221               
0222               txt.fctn.b
0223 76A6 0866             byte  8
0224 76A7 ....             text  'fctn + b'
0225                       even
0226               
0227               txt.fctn.c
0228 76B0 0866             byte  8
0229 76B1 ....             text  'fctn + c'
0230                       even
0231               
0232               txt.fctn.d
0233 76BA 0866             byte  8
0234 76BB ....             text  'fctn + d'
0235                       even
0236               
0237               txt.fctn.e
0238 76C4 0866             byte  8
0239 76C5 ....             text  'fctn + e'
0240                       even
0241               
0242               txt.fctn.f
0243 76CE 0866             byte  8
0244 76CF ....             text  'fctn + f'
0245                       even
0246               
0247               txt.fctn.g
0248 76D8 0866             byte  8
0249 76D9 ....             text  'fctn + g'
0250                       even
0251               
0252               txt.fctn.h
0253 76E2 0866             byte  8
0254 76E3 ....             text  'fctn + h'
0255                       even
0256               
0257               txt.fctn.i
0258 76EC 0866             byte  8
0259 76ED ....             text  'fctn + i'
0260                       even
0261               
0262               txt.fctn.j
0263 76F6 0866             byte  8
0264 76F7 ....             text  'fctn + j'
0265                       even
0266               
0267               txt.fctn.k
0268 7700 0866             byte  8
0269 7701 ....             text  'fctn + k'
0270                       even
0271               
0272               txt.fctn.l
0273 770A 0866             byte  8
0274 770B ....             text  'fctn + l'
0275                       even
0276               
0277               txt.fctn.m
0278 7714 0866             byte  8
0279 7715 ....             text  'fctn + m'
0280                       even
0281               
0282               txt.fctn.n
0283 771E 0866             byte  8
0284 771F ....             text  'fctn + n'
0285                       even
0286               
0287               txt.fctn.o
0288 7728 0866             byte  8
0289 7729 ....             text  'fctn + o'
0290                       even
0291               
0292               txt.fctn.p
0293 7732 0866             byte  8
0294 7733 ....             text  'fctn + p'
0295                       even
0296               
0297               txt.fctn.q
0298 773C 0866             byte  8
0299 773D ....             text  'fctn + q'
0300                       even
0301               
0302               txt.fctn.r
0303 7746 0866             byte  8
0304 7747 ....             text  'fctn + r'
0305                       even
0306               
0307               txt.fctn.s
0308 7750 0866             byte  8
0309 7751 ....             text  'fctn + s'
0310                       even
0311               
0312               txt.fctn.t
0313 775A 0866             byte  8
0314 775B ....             text  'fctn + t'
0315                       even
0316               
0317               txt.fctn.u
0318 7764 0866             byte  8
0319 7765 ....             text  'fctn + u'
0320                       even
0321               
0322               txt.fctn.v
0323 776E 0866             byte  8
0324 776F ....             text  'fctn + v'
0325                       even
0326               
0327               txt.fctn.w
0328 7778 0866             byte  8
0329 7779 ....             text  'fctn + w'
0330                       even
0331               
0332               txt.fctn.x
0333 7782 0866             byte  8
0334 7783 ....             text  'fctn + x'
0335                       even
0336               
0337               txt.fctn.y
0338 778C 0866             byte  8
0339 778D ....             text  'fctn + y'
0340                       even
0341               
0342               txt.fctn.z
0343 7796 0866             byte  8
0344 7797 ....             text  'fctn + z'
0345                       even
0346               
0347               *---------------------------------------------------------------
0348               * Keyboard labels - Function keys extra
0349               *---------------------------------------------------------------
0350               txt.fctn.dot
0351 77A0 0866             byte  8
0352 77A1 ....             text  'fctn + .'
0353                       even
0354               
0355               txt.fctn.plus
0356 77AA 0866             byte  8
0357 77AB ....             text  'fctn + +'
0358                       even
0359               
0360               *---------------------------------------------------------------
0361               * Keyboard labels - Control keys
0362               *---------------------------------------------------------------
0363               txt.ctrl.0
0364 77B4 0863             byte  8
0365 77B5 ....             text  'ctrl + 0'
0366                       even
0367               
0368               txt.ctrl.1
0369 77BE 0863             byte  8
0370 77BF ....             text  'ctrl + 1'
0371                       even
0372               
0373               txt.ctrl.2
0374 77C8 0863             byte  8
0375 77C9 ....             text  'ctrl + 2'
0376                       even
0377               
0378               txt.ctrl.3
0379 77D2 0863             byte  8
0380 77D3 ....             text  'ctrl + 3'
0381                       even
0382               
0383               txt.ctrl.4
0384 77DC 0863             byte  8
0385 77DD ....             text  'ctrl + 4'
0386                       even
0387               
0388               txt.ctrl.5
0389 77E6 0863             byte  8
0390 77E7 ....             text  'ctrl + 5'
0391                       even
0392               
0393               txt.ctrl.6
0394 77F0 0863             byte  8
0395 77F1 ....             text  'ctrl + 6'
0396                       even
0397               
0398               txt.ctrl.7
0399 77FA 0863             byte  8
0400 77FB ....             text  'ctrl + 7'
0401                       even
0402               
0403               txt.ctrl.8
0404 7804 0863             byte  8
0405 7805 ....             text  'ctrl + 8'
0406                       even
0407               
0408               txt.ctrl.9
0409 780E 0863             byte  8
0410 780F ....             text  'ctrl + 9'
0411                       even
0412               
0413               txt.ctrl.a
0414 7818 0863             byte  8
0415 7819 ....             text  'ctrl + a'
0416                       even
0417               
0418               txt.ctrl.b
0419 7822 0863             byte  8
0420 7823 ....             text  'ctrl + b'
0421                       even
0422               
0423               txt.ctrl.c
0424 782C 0863             byte  8
0425 782D ....             text  'ctrl + c'
0426                       even
0427               
0428               txt.ctrl.d
0429 7836 0863             byte  8
0430 7837 ....             text  'ctrl + d'
0431                       even
0432               
0433               txt.ctrl.e
0434 7840 0863             byte  8
0435 7841 ....             text  'ctrl + e'
0436                       even
0437               
0438               txt.ctrl.f
0439 784A 0863             byte  8
0440 784B ....             text  'ctrl + f'
0441                       even
0442               
0443               txt.ctrl.g
0444 7854 0863             byte  8
0445 7855 ....             text  'ctrl + g'
0446                       even
0447               
0448               txt.ctrl.h
0449 785E 0863             byte  8
0450 785F ....             text  'ctrl + h'
0451                       even
0452               
0453               txt.ctrl.i
0454 7868 0863             byte  8
0455 7869 ....             text  'ctrl + i'
0456                       even
0457               
0458               txt.ctrl.j
0459 7872 0863             byte  8
0460 7873 ....             text  'ctrl + j'
0461                       even
0462               
0463               txt.ctrl.k
0464 787C 0863             byte  8
0465 787D ....             text  'ctrl + k'
0466                       even
0467               
0468               txt.ctrl.l
0469 7886 0863             byte  8
0470 7887 ....             text  'ctrl + l'
0471                       even
0472               
0473               txt.ctrl.m
0474 7890 0863             byte  8
0475 7891 ....             text  'ctrl + m'
0476                       even
0477               
0478               txt.ctrl.n
0479 789A 0863             byte  8
0480 789B ....             text  'ctrl + n'
0481                       even
0482               
0483               txt.ctrl.o
0484 78A4 0863             byte  8
0485 78A5 ....             text  'ctrl + o'
0486                       even
0487               
0488               txt.ctrl.p
0489 78AE 0863             byte  8
0490 78AF ....             text  'ctrl + p'
0491                       even
0492               
0493               txt.ctrl.q
0494 78B8 0863             byte  8
0495 78B9 ....             text  'ctrl + q'
0496                       even
0497               
0498               txt.ctrl.r
0499 78C2 0863             byte  8
0500 78C3 ....             text  'ctrl + r'
0501                       even
0502               
0503               txt.ctrl.s
0504 78CC 0863             byte  8
0505 78CD ....             text  'ctrl + s'
0506                       even
0507               
0508               txt.ctrl.t
0509 78D6 0863             byte  8
0510 78D7 ....             text  'ctrl + t'
0511                       even
0512               
0513               txt.ctrl.u
0514 78E0 0863             byte  8
0515 78E1 ....             text  'ctrl + u'
0516                       even
0517               
0518               txt.ctrl.v
0519 78EA 0863             byte  8
0520 78EB ....             text  'ctrl + v'
0521                       even
0522               
0523               txt.ctrl.w
0524 78F4 0863             byte  8
0525 78F5 ....             text  'ctrl + w'
0526                       even
0527               
0528               txt.ctrl.x
0529 78FE 0863             byte  8
0530 78FF ....             text  'ctrl + x'
0531                       even
0532               
0533               txt.ctrl.y
0534 7908 0863             byte  8
0535 7909 ....             text  'ctrl + y'
0536                       even
0537               
0538               txt.ctrl.z
0539 7912 0863             byte  8
0540 7913 ....             text  'ctrl + z'
0541                       even
0542               
0543               *---------------------------------------------------------------
0544               * Keyboard labels - control keys extra
0545               *---------------------------------------------------------------
0546               txt.ctrl.plus
0547 791C 0863             byte  8
0548 791D ....             text  'ctrl + +'
0549                       even
0550               
0551               *---------------------------------------------------------------
0552               * Special keys
0553               *---------------------------------------------------------------
0554               txt.enter
0555 7926 0565             byte  5
0556 7927 ....             text  'enter'
0557                       even
0558               
**** **** ****     > stevie_b1.asm.210353
0068                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 792C 0D00             data  key.enter, txt.enter, edkey.action.enter
     792E 7926 
     7930 6580 
0106 7932 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7934 7750 
     7936 617E 
0107 7938 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     793A 76BA 
     793C 6194 
0108 793E 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7940 76C4 
     7942 61AC 
0109 7944 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7946 7782 
     7948 61FE 
0110 794A 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     794C 7818 
     794E 626A 
0111 7950 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7952 784A 
     7954 6282 
0112 7956 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7958 78CC 
     795A 6296 
0113 795C 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     795E 7836 
     7960 62E8 
0114 7962 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7964 7840 
     7966 6348 
0115 7968 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     796A 78FE 
     796C 638A 
0116 796E 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7970 78D6 
     7972 63B6 
0117 7974 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7976 7822 
     7978 63E2 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 797A 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     797C 7642 
     797E 6422 
0122 7980 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7982 787C 
     7984 645A 
0123 7986 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7988 7656 
     798A 648E 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 798C 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     798E 764C 
     7990 64E6 
0128 7992 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7994 77A0 
     7996 65EE 
0129 7998 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     799A 766A 
     799C 653C 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 799E 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     79A0 77AA 
     79A2 663E 
0134 79A4 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     79A6 7692 
     79A8 664A 
0135 79AA 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     79AC 7912 
     79AE 71C0 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 79B0 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     79B2 77B4 
     79B4 6668 
0140 79B6 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     79B8 77BE 
     79BA 666E 
0141 79BC B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     79BE 77C8 
     79C0 6674 
0142 79C2 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     79C4 77D2 
     79C6 667A 
0143 79C8 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     79CA 77DC 
     79CC 6680 
0144 79CE B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     79D0 77E6 
     79D2 6686 
0145 79D4 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     79D6 77F0 
     79D8 668C 
0146 79DA B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     79DC 77FA 
     79DE 6692 
0147 79E0 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     79E2 7804 
     79E4 6698 
0148 79E6 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     79E8 780E 
     79EA 669E 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 79EC FFFF             data  EOL                           ; EOL
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
0164 79EE 0D00             data  key.enter, txt.enter, edkey.action.enter
     79F0 7926 
     79F2 6580 
0165 79F4 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     79F6 7750 
     79F8 617E 
0166 79FA 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     79FC 76BA 
     79FE 6194 
0167 7A00 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     7A02 76C4 
     7A04 6646 
0168 7A06 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     7A08 7782 
     7A0A 6646 
0169 7A0C 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
     7A0E 7818 
     7A10 6646 
0170 7A12 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
     7A14 784A 
     7A16 6646 
0171 7A18 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     7A1A 78CC 
     7A1C 6646 
0172 7A1E 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     7A20 7836 
     7A22 6646 
0173 7A24 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     7A26 7840 
     7A28 6646 
0174 7A2A 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     7A2C 78FE 
     7A2E 6646 
0175 7A30 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     7A32 78D6 
     7A34 6646 
0176 7A36 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     7A38 7822 
     7A3A 6646 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 7A3C 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7A3E 7642 
     7A40 6422 
0181 7A42 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7A44 787C 
     7A46 645A 
0182 7A48 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     7A4A 7656 
     7A4C 6646 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 7A4E 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7A50 764C 
     7A52 64E6 
0187 7A54 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7A56 77A0 
     7A58 65EE 
0188 7A5A 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     7A5C 766A 
     7A5E 6646 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 7A60 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7A62 77AA 
     7A64 663E 
0193 7A66 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7A68 7692 
     7A6A 664A 
0194 7A6C 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7A6E 7912 
     7A70 71C0 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 7A72 B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7A74 77B4 
     7A76 6668 
0199 7A78 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7A7A 77BE 
     7A7C 666E 
0200 7A7E B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     7A80 77C8 
     7A82 6674 
0201 7A84 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7A86 77D2 
     7A88 667A 
0202 7A8A B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7A8C 77DC 
     7A8E 6680 
0203 7A90 B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     7A92 77E6 
     7A94 6686 
0204 7A96 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     7A98 77F0 
     7A9A 668C 
0205 7A9C B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     7A9E 77FA 
     7AA0 6692 
0206 7AA2 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     7AA4 7804 
     7AA6 6698 
0207 7AA8 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     7AAA 780E 
     7AAC 669E 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 7AAE FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.210353
0069               
0073 7AB0 7AB0                   data $                ; Bank 1 ROM size OK.
0075               
0076               *--------------------------------------------------------------
0077               * Video mode configuration
0078               *--------------------------------------------------------------
0079      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0080      0004     spfbck  equ   >04                   ; Screen background color.
0081      7416     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0082      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0083      0050     colrow  equ   80                    ; Columns per row
0084      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0085      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0086      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0087      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

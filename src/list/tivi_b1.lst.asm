XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.asm.26425
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi_b1.asm                 ; Version 200421-26425
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
0009               * File: equates.asm                 ; Version 200421-26425
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
0044               * a500-afff    2792           *FREE*
0045               *
0046               * b000-bfff    4096           Command buffer
0047               * c000-cfff    4096           Index
0048               * d000-dfff    4096           Editor buffer page
0049               * e000-efff    4096           *FREE*
0050               * f000-ffff    4096           Shadow index
0051               *
0052               *
0053               * VDP RAM
0054               *
0055               * Mem range   Bytes    Hex    Purpose
0056               * =========   =====   =====   =================================
0057               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0058               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0059               * 0fc0                        PCT - Pattern Color Table
0060               * 1000                        PDT - Pattern Descriptor Table
0061               * 1800                        SPT - Sprite Pattern Table
0062               * 2000                        SAT - Sprite Attribute List
0063               *--------------------------------------------------------------
0064               * Skip unused spectra2 code modules for reduced code size
0065               *--------------------------------------------------------------
0066      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0067      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0068      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0069      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0070      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0071      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0072      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0073      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0074      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0075      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0076      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0077      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0078      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0079      0001     skip_random_generator     equ  1       ; Skip random functions
0080      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0081               *--------------------------------------------------------------
0082               * SPECTRA2 / TiVi startup options
0083               *--------------------------------------------------------------
0084      0001     debug                     equ  1       ; Turn on spectra2 debugging
0085      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0086                                                      ; memory address @cpu.scrpad.tgt
0087      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0088      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0089      6050     kickstart.code2           equ  >6050   ; Uniform aorg entry addr start of code
0090               *--------------------------------------------------------------
0091               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0092               *--------------------------------------------------------------
0093               ;                 equ  >8342           ; >8342-834F **free***
0094      8350     parm1             equ  >8350           ; Function parameter 1
0095      8352     parm2             equ  >8352           ; Function parameter 2
0096      8354     parm3             equ  >8354           ; Function parameter 3
0097      8356     parm4             equ  >8356           ; Function parameter 4
0098      8358     parm5             equ  >8358           ; Function parameter 5
0099      835A     parm6             equ  >835a           ; Function parameter 6
0100      835C     parm7             equ  >835c           ; Function parameter 7
0101      835E     parm8             equ  >835e           ; Function parameter 8
0102      8360     outparm1          equ  >8360           ; Function output parameter 1
0103      8362     outparm2          equ  >8362           ; Function output parameter 2
0104      8364     outparm3          equ  >8364           ; Function output parameter 3
0105      8366     outparm4          equ  >8366           ; Function output parameter 4
0106      8368     outparm5          equ  >8368           ; Function output parameter 5
0107      836A     outparm6          equ  >836a           ; Function output parameter 6
0108      836C     outparm7          equ  >836c           ; Function output parameter 7
0109      836E     outparm8          equ  >836e           ; Function output parameter 8
0110      8370     timers            equ  >8370           ; Timer table
0111      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0112      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0113               *--------------------------------------------------------------
0114               * Scratchpad backup 1               @>3e00-3eff     (256 bytes)
0115               * Scratchpad backup 2               @>3f00-3fff     (256 bytes)
0116               *--------------------------------------------------------------
0117      3E00     cpu.scrpad.tgt    equ  >3e00           ; Destination cpu.scrpad.backup/restore
0118      3E00     scrpad.backup1    equ  >3e00           ; Backup GPL layout
0119      3F00     scrpad.backup2    equ  >3f00           ; Backup spectra2 layout
0120               *--------------------------------------------------------------
0121               * TiVi Editor shared structures     @>a000-a0ff     (256 bytes)
0122               *--------------------------------------------------------------
0123      A000     tv.top            equ  >a000           ; Structure begin
0124      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS shadow register memory >2000-2fff
0125      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS shadow register memory >3000-3fff
0126      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS shadow register memory >a000-afff
0127      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS shadow register memory >b000-bfff
0128      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS shadow register memory >c000-cfff
0129      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS shadow register memory >d000-dfff
0130      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS shadow register memory >e000-efff
0131      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS shadow register memory >f000-ffff
0132      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0133      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-4)
0134      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color
0135      A016     tv.pane.focus     equ  tv.top + 22     ; Identify pane that has focus
0136      A016     tv.end            equ  tv.top + 22     ; End of structure
0137      0000     pane.focus.fb     equ  0               ; Editor pane has focus
0138      0001     pane.focus.cmdb   equ  1               ; Command buffer pane has focus
0139               *--------------------------------------------------------------
0140               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0141               *--------------------------------------------------------------
0142      A100     fb.struct         equ  >a100           ; Structure begin
0143      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0144      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0145      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0146                                                      ; line X in editor buffer).
0147      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0148                                                      ; (offset 0 .. @fb.scrrows)
0149      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0150      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0151      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0152      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0153      A110     fb.free           equ  fb.struct + 16  ; **** free ****
0154      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0155      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0156      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0157      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0158      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0159      A11C     fb.end            equ  fb.struct + 28  ; End of structure
0160               *--------------------------------------------------------------
0161               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0162               *--------------------------------------------------------------
0163      A200     edb.struct        equ  >a200           ; Begin structure
0164      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0165      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0166      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0167      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0168      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0169      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0170      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0171      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0172                                                      ; with current filename.
0173      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0174                                                      ; with current file type.
0175      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0176      A214     edb.end           equ  edb.struct + 20 ; End of structure
0177               *--------------------------------------------------------------
0178               * Command buffer structure          @>a300-a3ff     (256 bytes)
0179               *--------------------------------------------------------------
0180      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0181      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer
0182      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0183      A304     cmdb.scrrows      equ  cmdb.struct + 4 ; Current size of cmdb pane (in rows)
0184      A306     cmdb.default      equ  cmdb.struct + 6 ; Default size of cmdb pane (in rows)
0185      A308     cmdb.cursor       equ  cmdb.struct + 8 ; Screen YX of cursor in cmdb pane
0186      A30A     cmdb.yxsave       equ  cmdb.struct + 10; Copy of WYX
0187      A30C     cmdb.yxtop        equ  cmdb.struct + 12; YX position of first row in cmdb pane
0188      A30E     cmdb.lines        equ  cmdb.struct + 14; Total lines in editor buffer
0189      A310     cmdb.dirty        equ  cmdb.struct + 16; Editor buffer dirty (Text changed!)
0190      A312     cmdb.fb.yxsave    equ  cmdb.struct + 18; Copy of FB WYX when entering cmdb pane
0191      A314     cmdb.end          equ  cmdb.struct + 20; End of structure
0192               *--------------------------------------------------------------
0193               * File handle structure             @>a400-a4ff     (256 bytes)
0194               *--------------------------------------------------------------
0195      A400     fh.struct         equ  >a400           ; TiVi file handling structures
0196      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0197      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0198      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0199      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0200      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0201      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0202      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0203      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0204      A434     fh.counter        equ  fh.struct + 52  ; Counter used in TiVi file operations
0205      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0206      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0207      A43A     fh.sams.hpage     equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0208      A43C     fh.callback1      equ  fh.struct + 60  ; Pointer to callback function 1
0209      A43E     fh.callback2      equ  fh.struct + 62  ; Pointer to callback function 2
0210      A440     fh.callback3      equ  fh.struct + 64  ; Pointer to callback function 3
0211      A442     fh.callback4      equ  fh.struct + 66  ; Pointer to callback function 4
0212      A444     fh.rleonload      equ  fh.struct + 68  ; RLE compression needed during file load
0213      A446     fh.membuffer      equ  fh.struct + 70  ; 80 bytes file memory buffer
0214      A496     fh.end            equ  fh.struct +150  ; End of structure
0215      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0216      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0217               *--------------------------------------------------------------
0218               * Frame buffer                      @>a600-afff    (2560 bytes)
0219               *--------------------------------------------------------------
0220      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0221      0960     fb.size           equ  80*30           ; Frame buffer size
0222               *--------------------------------------------------------------
0223               * Command buffer                    @>b000-bfff    (4096 bytes)
0224               *--------------------------------------------------------------
0225      B000     cmdb.top          equ  >b000           ; Top of command buffer
0226      1000     cmdb.size         equ  4096            ; Command buffer size
0227               *--------------------------------------------------------------
0228               * Index                             @>c000-cfff    (4096 bytes)
0229               *--------------------------------------------------------------
0230      C000     idx.top           equ  >c000           ; Top of index
0231      1000     idx.size          equ  4096            ; Index size
0232               *--------------------------------------------------------------
0233               * Editor buffer                     @>d000-dfff    (4096 bytes)
0234               *--------------------------------------------------------------
0235      D000     edb.top           equ  >d000           ; Editor buffer high memory
0236      1000     edb.size          equ  4096            ; Editor buffer size
0237               *--------------------------------------------------------------
0238               * *** FREE ***                      @>f000-ffff    (4096 bytes)
0239               *--------------------------------------------------------------
**** **** ****     > tivi_b1.asm.26425
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
0030 6014 1154             byte  17
0031 6015 ....             text  'TIVI 200421-26425'
0032                       even
0033               
0041               
0042               *--------------------------------------------------------------
0043               * Kickstart bank 0
0044               ********|*****|*********************|**************************
0045                       aorg  kickstart.code1
0046 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
**** **** ****     > tivi_b1.asm.26425
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
     208E 2D68 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @putat                ; Show crash message
     2092 2410 
0078 2094 0000                   data >0000,cpu.crash.msg.crashed
     2096 216A 
0079               
0080 2098 06A0  32         bl    @puthex               ; Put hex value on screen
     209A 2996 
0081 209C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 209E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 20A0 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 20A2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 20A4 06A0  32         bl    @putat                ; Show caller message
     20A6 2410 
0090 20A8 0100                   data >0100,cpu.crash.msg.caller
     20AA 2180 
0091               
0092 20AC 06A0  32         bl    @puthex               ; Put hex value on screen
     20AE 2996 
0093 20B0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 20B2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 20B4 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 20B6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 20B8 06A0  32         bl    @putat
     20BA 2410 
0102 20BC 0300                   byte 3,0
0103 20BE 219A                   data cpu.crash.msg.wp
0104 20C0 06A0  32         bl    @putat
     20C2 2410 
0105 20C4 0400                   byte 4,0
0106 20C6 21A0                   data cpu.crash.msg.st
0107 20C8 06A0  32         bl    @putat
     20CA 2410 
0108 20CC 1600                   byte 22,0
0109 20CE 21A6                   data cpu.crash.msg.source
0110 20D0 06A0  32         bl    @putat
     20D2 2410 
0111 20D4 1700                   byte 23,0
0112 20D6 21C0                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 20D8 06A0  32         bl    @at                   ; Put cursor at YX
     20DA 264E 
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
     20FE 29A0 
0143 2100 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 2102 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 2104 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 2106 06A0  32         bl    @setx                 ; Set cursor X position
     2108 2664 
0149 210A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 210C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     210E 23FE 
0153 2110 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 2112 06A0  32         bl    @setx                 ; Set cursor X position
     2114 2664 
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
     2124 23FE 
0165 2126 2196                   data cpu.crash.msg.r
0166               
0167 2128 06A0  32         bl    @mknum
     212A 29A0 
0168 212C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 212E 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 2130 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 2132 06A0  32         bl    @mkhex                ; Convert hex word to string
     2134 2912 
0177 2136 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 2138 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 213A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 213C 06A0  32         bl    @setx                 ; Set cursor X position
     213E 2664 
0183 2140 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 2142 06A0  32         bl    @putstr
     2144 23FE 
0187 2146 2198                   data cpu.crash.msg.marker
0188               
0189 2148 06A0  32         bl    @setx                 ; Set cursor X position
     214A 2664 
0190 214C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 214E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2150 23FE 
0194 2152 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 2154 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 2156 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 2158 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 215A 06A0  32         bl    @down                 ; y=y+1
     215C 2654 
0202               
0203 215E 0586  14         inc   tmp2
0204 2160 0286  22         ci    tmp2,17
     2162 0011 
0205 2164 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 2166 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2168 2C76 
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
0248 21C0 1642             byte  22
0249 21C1 ....             text  'Build-ID  200421-26425'
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
0007 21D8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21DA 000E 
     21DC 0106 
     21DE 0204 
     21E0 0020 
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
0032 21E2 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21E4 000E 
     21E6 0106 
     21E8 00F4 
     21EA 0028 
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
0058 21EC 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21EE 003F 
     21F0 0240 
     21F2 03F4 
     21F4 0050 
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
0084 21F6 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     21F8 003F 
     21FA 0240 
     21FC 03F4 
     21FE 0050 
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
0013 2200 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2202 16FD             data  >16fd                 ; |         jne   mcloop
0015 2204 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2206 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2208 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 220A C0F9  30 popr3   mov   *stack+,r3
0039 220C C0B9  30 popr2   mov   *stack+,r2
0040 220E C079  30 popr1   mov   *stack+,r1
0041 2210 C039  30 popr0   mov   *stack+,r0
0042 2212 C2F9  30 poprt   mov   *stack+,r11
0043 2214 045B  20         b     *r11
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
0067 2216 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 2218 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 221A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 221C C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 221E 1604  14         jne   filchk                ; No, continue checking
0075               
0076 2220 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2222 FFCE 
0077 2224 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2226 2030 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 2228 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     222A 830B 
     222C 830A 
0082               
0083 222E 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2230 0001 
0084 2232 1602  14         jne   filchk2
0085 2234 DD05  32         movb  tmp1,*tmp0+
0086 2236 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 2238 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     223A 0002 
0091 223C 1603  14         jne   filchk3
0092 223E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 2240 DD05  32         movb  tmp1,*tmp0+
0094 2242 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 2244 C1C4  18 filchk3 mov   tmp0,tmp3
0099 2246 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2248 0001 
0100 224A 1605  14         jne   fil16b
0101 224C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 224E 0606  14         dec   tmp2
0103 2250 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2252 0002 
0104 2254 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 2256 C1C6  18 fil16b  mov   tmp2,tmp3
0109 2258 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     225A 0001 
0110 225C 1301  14         jeq   dofill
0111 225E 0606  14         dec   tmp2                  ; Make TMP2 even
0112 2260 CD05  34 dofill  mov   tmp1,*tmp0+
0113 2262 0646  14         dect  tmp2
0114 2264 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 2266 C1C7  18         mov   tmp3,tmp3
0119 2268 1301  14         jeq   fil.$$
0120 226A DD05  32         movb  tmp1,*tmp0+
0121 226C 045B  20 fil.$$  b     *r11
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
0140 226E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 2270 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 2272 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 2274 0264  22 xfilv   ori   tmp0,>4000
     2276 4000 
0147 2278 06C4  14         swpb  tmp0
0148 227A D804  38         movb  tmp0,@vdpa
     227C 8C02 
0149 227E 06C4  14         swpb  tmp0
0150 2280 D804  38         movb  tmp0,@vdpa
     2282 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 2284 020F  20         li    r15,vdpw              ; Set VDP write address
     2286 8C00 
0155 2288 06C5  14         swpb  tmp1
0156 228A C820  54         mov   @filzz,@mcloop        ; Setup move command
     228C 2294 
     228E 8320 
0157 2290 0460  28         b     @mcloop               ; Write data to VDP
     2292 8320 
0158               *--------------------------------------------------------------
0162 2294 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 2296 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     2298 4000 
0183 229A 06C4  14 vdra    swpb  tmp0
0184 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0185 22A0 06C4  14         swpb  tmp0
0186 22A2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22A4 8C02 
0187 22A6 045B  20         b     *r11                  ; Exit
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
0198 22A8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 22AA C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 22AC 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22AE 4000 
0204 22B0 06C4  14         swpb  tmp0                  ; \
0205 22B2 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22B4 8C02 
0206 22B6 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 22B8 D804  38         movb  tmp0,@vdpa            ; /
     22BA 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 22BC 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 22BE D7C5  30         movb  tmp1,*r15             ; Write byte
0213 22C0 045B  20         b     *r11                  ; Exit
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
0232 22C2 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 22C4 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 22C6 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22C8 8C02 
0238 22CA 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 22CC D804  38         movb  tmp0,@vdpa            ; /
     22CE 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 22D0 D120  34         movb  @vdpr,tmp0            ; Read byte
     22D2 8800 
0244 22D4 0984  56         srl   tmp0,8                ; Right align
0245 22D6 045B  20         b     *r11                  ; Exit
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
0264 22D8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 22DA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 22DC C144  18         mov   tmp0,tmp1
0270 22DE 05C5  14         inct  tmp1
0271 22E0 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 22E2 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     22E4 FF00 
0273 22E6 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 22E8 C805  38         mov   tmp1,@wbase           ; Store calculated base
     22EA 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 22EC 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     22EE 8000 
0279 22F0 0206  20         li    tmp2,8
     22F2 0008 
0280 22F4 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     22F6 830B 
0281 22F8 06C5  14         swpb  tmp1
0282 22FA D805  38         movb  tmp1,@vdpa
     22FC 8C02 
0283 22FE 06C5  14         swpb  tmp1
0284 2300 D805  38         movb  tmp1,@vdpa
     2302 8C02 
0285 2304 0225  22         ai    tmp1,>0100
     2306 0100 
0286 2308 0606  14         dec   tmp2
0287 230A 16F4  14         jne   vidta1                ; Next register
0288 230C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     230E 833A 
0289 2310 045B  20         b     *r11
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
0306 2312 C13B  30 putvr   mov   *r11+,tmp0
0307 2314 0264  22 putvrx  ori   tmp0,>8000
     2316 8000 
0308 2318 06C4  14         swpb  tmp0
0309 231A D804  38         movb  tmp0,@vdpa
     231C 8C02 
0310 231E 06C4  14         swpb  tmp0
0311 2320 D804  38         movb  tmp0,@vdpa
     2322 8C02 
0312 2324 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 2326 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 2328 C10E  18         mov   r14,tmp0
0322 232A 0984  56         srl   tmp0,8
0323 232C 06A0  32         bl    @putvrx               ; Write VR#0
     232E 2314 
0324 2330 0204  20         li    tmp0,>0100
     2332 0100 
0325 2334 D820  54         movb  @r14lb,@tmp0lb
     2336 831D 
     2338 8309 
0326 233A 06A0  32         bl    @putvrx               ; Write VR#1
     233C 2314 
0327 233E 0458  20         b     *tmp4                 ; Exit
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
0341 2340 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 2342 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 2344 C11B  26         mov   *r11,tmp0             ; Get P0
0344 2346 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2348 7FFF 
0345 234A 2120  38         coc   @wbit0,tmp0
     234C 202A 
0346 234E 1604  14         jne   ldfnt1
0347 2350 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2352 8000 
0348 2354 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2356 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 2358 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     235A 23C2 
0353 235C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     235E 9C02 
0354 2360 06C4  14         swpb  tmp0
0355 2362 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2364 9C02 
0356 2366 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2368 9800 
0357 236A 06C5  14         swpb  tmp1
0358 236C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     236E 9800 
0359 2370 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 2372 D805  38         movb  tmp1,@grmwa
     2374 9C02 
0364 2376 06C5  14         swpb  tmp1
0365 2378 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     237A 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 237C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 237E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     2380 2296 
0371 2382 05C8  14         inct  tmp4                  ; R11=R11+2
0372 2384 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 2386 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     2388 7FFF 
0374 238A C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     238C 23C4 
0375 238E C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     2390 23C6 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 2392 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 2394 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 2396 D120  34         movb  @grmrd,tmp0
     2398 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 239A 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     239C 202A 
0386 239E 1603  14         jne   ldfnt3                ; No, so skip
0387 23A0 D1C4  18         movb  tmp0,tmp3
0388 23A2 0917  56         srl   tmp3,1
0389 23A4 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 23A6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23A8 8C00 
0394 23AA 0606  14         dec   tmp2
0395 23AC 16F2  14         jne   ldfnt2
0396 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0397 23B0 020F  20         li    r15,vdpw              ; Set VDP write address
     23B2 8C00 
0398 23B4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23B6 7FFF 
0399 23B8 0458  20         b     *tmp4                 ; Exit
0400 23BA D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23BC 200A 
     23BE 8C00 
0401 23C0 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 23C2 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23C4 0200 
     23C6 0000 
0406 23C8 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23CA 01C0 
     23CC 0101 
0407 23CE 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23D0 02A0 
     23D2 0101 
0408 23D4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23D6 00E0 
     23D8 0101 
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
0426 23DA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 23DC C3A0  34         mov   @wyx,r14              ; Get YX
     23DE 832A 
0428 23E0 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 23E2 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     23E4 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 23E6 C3A0  34         mov   @wyx,r14              ; Get YX
     23E8 832A 
0435 23EA 024E  22         andi  r14,>00ff             ; Remove Y
     23EC 00FF 
0436 23EE A3CE  18         a     r14,r15               ; pos = pos + X
0437 23F0 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     23F2 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 23F4 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 23F6 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 23F8 020F  20         li    r15,vdpw              ; VDP write address
     23FA 8C00 
0444 23FC 045B  20         b     *r11
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
0459 23FE C17B  30 putstr  mov   *r11+,tmp1
0460 2400 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 2402 C1CB  18 xutstr  mov   r11,tmp3
0462 2404 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2406 23DA 
0463 2408 C2C7  18         mov   tmp3,r11
0464 240A 0986  56         srl   tmp2,8                ; Right justify length byte
0465 240C 0460  28         b     @xpym2v               ; Display string
     240E 241E 
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
0480 2410 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2412 832A 
0481 2414 0460  28         b     @putstr
     2416 23FE 
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
0020 2418 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 241A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 241C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 241E 0264  22 xpym2v  ori   tmp0,>4000
     2420 4000 
0027 2422 06C4  14         swpb  tmp0
0028 2424 D804  38         movb  tmp0,@vdpa
     2426 8C02 
0029 2428 06C4  14         swpb  tmp0
0030 242A D804  38         movb  tmp0,@vdpa
     242C 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 242E 020F  20         li    r15,vdpw              ; Set VDP write address
     2430 8C00 
0035 2432 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2434 243C 
     2436 8320 
0036 2438 0460  28         b     @mcloop               ; Write data to VDP
     243A 8320 
0037 243C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 243E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2440 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2442 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2444 06C4  14 xpyv2m  swpb  tmp0
0027 2446 D804  38         movb  tmp0,@vdpa
     2448 8C02 
0028 244A 06C4  14         swpb  tmp0
0029 244C D804  38         movb  tmp0,@vdpa
     244E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2450 020F  20         li    r15,vdpr              ; Set VDP read address
     2452 8800 
0034 2454 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2456 245E 
     2458 8320 
0035 245A 0460  28         b     @mcloop               ; Read data from VDP
     245C 8320 
0036 245E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 2460 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 2462 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 2464 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 2466 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 2468 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 246A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     246C FFCE 
0034 246E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2470 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2472 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2474 0001 
0039 2476 1603  14         jne   cpym0                 ; No, continue checking
0040 2478 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 247A 04C6  14         clr   tmp2                  ; Reset counter
0042 247C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 247E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     2480 7FFF 
0047 2482 C1C4  18         mov   tmp0,tmp3
0048 2484 0247  22         andi  tmp3,1
     2486 0001 
0049 2488 1618  14         jne   cpyodd                ; Odd source address handling
0050 248A C1C5  18 cpym1   mov   tmp1,tmp3
0051 248C 0247  22         andi  tmp3,1
     248E 0001 
0052 2490 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2492 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2494 202A 
0057 2496 1605  14         jne   cpym3
0058 2498 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     249A 24C0 
     249C 8320 
0059 249E 0460  28         b     @mcloop               ; Copy memory and exit
     24A0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24A2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24A4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24A6 0001 
0065 24A8 1301  14         jeq   cpym4
0066 24AA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24AC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24AE 0646  14         dect  tmp2
0069 24B0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24B2 C1C7  18         mov   tmp3,tmp3
0074 24B4 1301  14         jeq   cpymz
0075 24B6 D554  38         movb  *tmp0,*tmp1
0076 24B8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24BA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24BC 8000 
0081 24BE 10E9  14         jmp   cpym2
0082 24C0 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 24C2 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 24C4 0649  14         dect  stack
0065 24C6 C64B  30         mov   r11,*stack            ; Push return address
0066 24C8 0649  14         dect  stack
0067 24CA C640  30         mov   r0,*stack             ; Push r0
0068 24CC 0649  14         dect  stack
0069 24CE C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 24D0 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 24D2 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 24D4 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     24D6 4000 
0077 24D8 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     24DA 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 24DC 020C  20         li    r12,>1e00             ; SAMS CRU address
     24DE 1E00 
0082 24E0 04C0  14         clr   r0
0083 24E2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 24E4 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 24E6 D100  18         movb  r0,tmp0
0086 24E8 0984  56         srl   tmp0,8                ; Right align
0087 24EA C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     24EC 833C 
0088 24EE 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 24F0 C339  30         mov   *stack+,r12           ; Pop r12
0094 24F2 C039  30         mov   *stack+,r0            ; Pop r0
0095 24F4 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 24F6 045B  20         b     *r11                  ; Return to caller
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
0131 24F8 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 24FA C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 24FC 0649  14         dect  stack
0135 24FE C64B  30         mov   r11,*stack            ; Push return address
0136 2500 0649  14         dect  stack
0137 2502 C640  30         mov   r0,*stack             ; Push r0
0138 2504 0649  14         dect  stack
0139 2506 C64C  30         mov   r12,*stack            ; Push r12
0140 2508 0649  14         dect  stack
0141 250A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 250C 0649  14         dect  stack
0143 250E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2510 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2512 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 2514 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2516 001E 
0153 2518 150A  14         jgt   !
0154 251A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     251C 0004 
0155 251E 1107  14         jlt   !
0156 2520 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2522 0012 
0157 2524 1508  14         jgt   sams.page.set.switch_page
0158 2526 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2528 0006 
0159 252A 1501  14         jgt   !
0160 252C 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 252E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2530 FFCE 
0165 2532 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2534 2030 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 2536 020C  20         li    r12,>1e00             ; SAMS CRU address
     2538 1E00 
0171 253A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 253C 06C0  14         swpb  r0                    ; LSB to MSB
0173 253E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 2540 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2542 4000 
0175 2544 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 2546 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 2548 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 254A C339  30         mov   *stack+,r12           ; Pop r12
0183 254C C039  30         mov   *stack+,r0            ; Pop r0
0184 254E C2F9  30         mov   *stack+,r11           ; Pop return address
0185 2550 045B  20         b     *r11                  ; Return to caller
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
0199 2552 020C  20         li    r12,>1e00             ; SAMS CRU address
     2554 1E00 
0200 2556 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 2558 045B  20         b     *r11                  ; Return to caller
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
0222 255A 020C  20         li    r12,>1e00             ; SAMS CRU address
     255C 1E00 
0223 255E 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 2560 045B  20         b     *r11                  ; Return to caller
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
0255 2562 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 2564 0649  14         dect  stack
0258 2566 C64B  30         mov   r11,*stack            ; Save return address
0259 2568 0649  14         dect  stack
0260 256A C644  30         mov   tmp0,*stack           ; Save tmp0
0261 256C 0649  14         dect  stack
0262 256E C645  30         mov   tmp1,*stack           ; Save tmp1
0263 2570 0649  14         dect  stack
0264 2572 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 2574 0649  14         dect  stack
0266 2576 C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 2578 0206  20         li    tmp2,8                ; Set loop counter
     257A 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 257C C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 257E C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 2580 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     2582 24FC 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 2584 0606  14         dec   tmp2                  ; Next iteration
0283 2586 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 2588 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     258A 2552 
0289                                                   ; / activating changes.
0290               
0291 258C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 258E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 2590 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 2592 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 2594 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 2596 045B  20         b     *r11                  ; Return to caller
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
0313 2598 0649  14         dect  stack
0314 259A C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 259C 06A0  32         bl    @sams.layout
     259E 2562 
0319 25A0 25A6                   data sams.layout.standard
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.layout.reset.exit:
0324 25A2 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 25A4 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.layout.standard:
0330 25A6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25A8 0002 
0331 25AA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25AC 0003 
0332 25AE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25B0 000A 
0333 25B2 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25B4 000B 
0334 25B6 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25B8 000C 
0335 25BA D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     25BC 000D 
0336 25BE E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     25C0 000E 
0337 25C2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     25C4 000F 
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
0358 25C6 C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 25C8 0649  14         dect  stack
0361 25CA C64B  30         mov   r11,*stack            ; Push return address
0362 25CC 0649  14         dect  stack
0363 25CE C644  30         mov   tmp0,*stack           ; Push tmp0
0364 25D0 0649  14         dect  stack
0365 25D2 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 25D4 0649  14         dect  stack
0367 25D6 C646  30         mov   tmp2,*stack           ; Push tmp2
0368 25D8 0649  14         dect  stack
0369 25DA C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 25DC 0205  20         li    tmp1,sams.layout.copy.data
     25DE 25FE 
0374 25E0 0206  20         li    tmp2,8                ; Set loop counter
     25E2 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.layout.copy.loop:
0379 25E4 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 25E6 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     25E8 24C4 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 25EA CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     25EC 833C 
0385               
0386 25EE 0606  14         dec   tmp2                  ; Next iteration
0387 25F0 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.layout.copy.exit:
0392 25F2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 25F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 25F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 25F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 25FA C2F9  30         mov   *stack+,r11           ; Pop r11
0397 25FC 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.layout.copy.data:
0402 25FE 2000             data  >2000                 ; >2000-2fff
0403 2600 3000             data  >3000                 ; >3000-3fff
0404 2602 A000             data  >a000                 ; >a000-afff
0405 2604 B000             data  >b000                 ; >b000-bfff
0406 2606 C000             data  >c000                 ; >c000-cfff
0407 2608 D000             data  >d000                 ; >d000-dfff
0408 260A E000             data  >e000                 ; >e000-efff
0409 260C F000             data  >f000                 ; >f000-ffff
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
0009 260E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2610 FFBF 
0010 2612 0460  28         b     @putv01
     2614 2326 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2616 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2618 0040 
0018 261A 0460  28         b     @putv01
     261C 2326 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 261E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2620 FFDF 
0026 2622 0460  28         b     @putv01
     2624 2326 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2626 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2628 0020 
0034 262A 0460  28         b     @putv01
     262C 2326 
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
0010 262E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2630 FFFE 
0011 2632 0460  28         b     @putv01
     2634 2326 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2636 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2638 0001 
0019 263A 0460  28         b     @putv01
     263C 2326 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 263E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2640 FFFD 
0027 2642 0460  28         b     @putv01
     2644 2326 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2646 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2648 0002 
0035 264A 0460  28         b     @putv01
     264C 2326 
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
0018 264E C83B  50 at      mov   *r11+,@wyx
     2650 832A 
0019 2652 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 2654 B820  54 down    ab    @hb$01,@wyx
     2656 201C 
     2658 832A 
0028 265A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 265C 7820  54 up      sb    @hb$01,@wyx
     265E 201C 
     2660 832A 
0037 2662 045B  20         b     *r11
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
0049 2664 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 2666 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     2668 832A 
0051 266A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     266C 832A 
0052 266E 045B  20         b     *r11
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
0021 2670 C120  34 yx2px   mov   @wyx,tmp0
     2672 832A 
0022 2674 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2676 06C4  14         swpb  tmp0                  ; Y<->X
0024 2678 04C5  14         clr   tmp1                  ; Clear before copy
0025 267A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 267C 20A0  38         coc   @wbit1,config         ; f18a present ?
     267E 2028 
0030 2680 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 2682 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2684 833A 
     2686 26B0 
0032 2688 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 268A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 268C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 268E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     2690 0500 
0037 2692 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2694 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2696 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2698 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 269A D105  18         movb  tmp1,tmp0
0051 269C 06C4  14         swpb  tmp0                  ; X<->Y
0052 269E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26A0 202A 
0053 26A2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26A4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26A6 201C 
0059 26A8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26AA 202E 
0060 26AC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26AE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26B0 0050            data   80
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
0013 26B2 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26B4 06A0  32         bl    @putvr                ; Write once
     26B6 2312 
0015 26B8 391C             data  >391c                 ; VR1/57, value 00011100
0016 26BA 06A0  32         bl    @putvr                ; Write twice
     26BC 2312 
0017 26BE 391C             data  >391c                 ; VR1/57, value 00011100
0018 26C0 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 26C2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 26C4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     26C6 2312 
0028 26C8 391C             data  >391c
0029 26CA 0458  20         b     *tmp4                 ; Exit
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
0040 26CC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 26CE 06A0  32         bl    @cpym2v
     26D0 2418 
0042 26D2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     26D4 2710 
     26D6 0006 
0043 26D8 06A0  32         bl    @putvr
     26DA 2312 
0044 26DC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 26DE 06A0  32         bl    @putvr
     26E0 2312 
0046 26E2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 26E4 0204  20         li    tmp0,>3f00
     26E6 3F00 
0052 26E8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     26EA 229A 
0053 26EC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     26EE 8800 
0054 26F0 0984  56         srl   tmp0,8
0055 26F2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     26F4 8800 
0056 26F6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 26F8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 26FA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     26FC BFFF 
0060 26FE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2700 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2702 4000 
0063               f18chk_exit:
0064 2704 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2706 226E 
0065 2708 3F00             data  >3f00,>00,6
     270A 0000 
     270C 0006 
0066 270E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2710 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2712 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2714 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2716 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2718 06A0  32         bl    @putvr
     271A 2312 
0097 271C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 271E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2720 2312 
0100 2722 391C             data  >391c                 ; Lock the F18a
0101 2724 0458  20         b     *tmp4                 ; Exit
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
0120 2726 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2728 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     272A 2028 
0122 272C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 272E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2730 8802 
0127 2732 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2734 2312 
0128 2736 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2738 04C4  14         clr   tmp0
0130 273A D120  34         movb  @vdps,tmp0
     273C 8802 
0131 273E 0984  56         srl   tmp0,8
0132 2740 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2742 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2744 832A 
0018 2746 D17B  28         movb  *r11+,tmp1
0019 2748 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 274A D1BB  28         movb  *r11+,tmp2
0021 274C 0986  56         srl   tmp2,8                ; Repeat count
0022 274E C1CB  18         mov   r11,tmp3
0023 2750 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2752 23DA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 2754 020B  20         li    r11,hchar1
     2756 275C 
0028 2758 0460  28         b     @xfilv                ; Draw
     275A 2274 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 275C 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     275E 202C 
0033 2760 1302  14         jeq   hchar2                ; Yes, exit
0034 2762 C2C7  18         mov   tmp3,r11
0035 2764 10EE  14         jmp   hchar                 ; Next one
0036 2766 05C7  14 hchar2  inct  tmp3
0037 2768 0457  20         b     *tmp3                 ; Exit
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
0017 276A C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     276C 832A 
0018 276E C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 2770 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     2772 833A 
0020 2774 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2776 23DA 
0021 2778 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 277A D1B7  28         movb  *tmp3+,tmp2
0023 277C 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 277E 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     2780 2296 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 2782 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 2784 A108  18         a     tmp4,tmp0             ; Next row
0033 2786 0606  14         dec   tmp2
0034 2788 16FA  14         jne   vchar2
0035 278A 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     278C 202C 
0036 278E 1303  14         jeq   vchar3                ; Yes, exit
0037 2790 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     2792 832A 
0038 2794 10ED  14         jmp   vchar1                ; Next one
0039 2796 05C7  14 vchar3  inct  tmp3
0040 2798 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 279A C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 279C C804  38         mov   tmp0,@wyx             ; Set cursor position
     279E 832A 
0051 27A0 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 27A2 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     27A4 833A 
0053 27A6 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A8 23DA 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 27AA 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     27AC 2296 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 27AE D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 27B0 A120  34         a     @wcolmn,tmp0          ; Next row
     27B2 833A 
0063 27B4 0606  14         dec   tmp2
0064 27B6 16F9  14         jne   xvcha1
0065 27B8 0458  20         b     *tmp4                 ; Exit
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
0016 27BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BC 202A 
0017 27BE 020C  20         li    r12,>0024
     27C0 0024 
0018 27C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C4 2852 
0019 27C6 04C6  14         clr   tmp2
0020 27C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CA 04CC  14         clr   r12
0025 27CC 1F08  20         tb    >0008                 ; Shift-key ?
0026 27CE 1302  14         jeq   realk1                ; No
0027 27D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D2 2882 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D6 1302  14         jeq   realk2                ; No
0033 27D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DA 28B2 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27DE 1302  14         jeq   realk3                ; No
0039 27E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E2 28E2 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E4 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 27E6 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 27E8 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 27EA E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     27EC 202A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 27EE 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 27F0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F2 0006 
0052 27F4 0606  14 realk5  dec   tmp2
0053 27F6 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F8 0024 
0054 27FA 06C6  14         swpb  tmp2
0055 27FC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 27FE 06C6  14         swpb  tmp2
0057 2800 020C  20         li    r12,6                 ; CRU read address
     2802 0006 
0058 2804 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 2806 0547  14         inv   tmp3                  ;
0060 2808 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     280A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 280C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 280E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 2810 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 2812 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 2814 0285  22         ci    tmp1,8
     2816 0008 
0069 2818 1AFA  14         jl    realk6
0070 281A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 281C 1BEB  14         jh    realk5                ; No, next column
0072 281E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 2820 C206  18 realk8  mov   tmp2,tmp4
0077 2822 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 2824 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 2826 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 2828 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 282A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 282C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 282E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     2830 202A 
0087 2832 1608  14         jne   realka                ; No, continue saving key
0088 2834 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2836 287C 
0089 2838 1A05  14         jl    realka
0090 283A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     283C 287A 
0091 283E 1B02  14         jh    realka                ; No, continue
0092 2840 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     2842 E000 
0093 2844 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2846 833C 
0094 2848 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     284A 2014 
0095 284C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     284E 8C00 
0096 2850 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 2852 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2854 0000 
     2856 FF0D 
     2858 203D 
0099 285A ....             text  'xws29ol.'
0100 2862 ....             text  'ced38ik,'
0101 286A ....             text  'vrf47ujm'
0102 2872 ....             text  'btg56yhn'
0103 287A ....             text  'zqa10p;/'
0104 2882 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2884 0000 
     2886 FF0D 
     2888 202B 
0105 288A ....             text  'XWS@(OL>'
0106 2892 ....             text  'CED#*IK<'
0107 289A ....             text  'VRF$&UJM'
0108 28A2 ....             text  'BTG%^YHN'
0109 28AA ....             text  'ZQA!)P:-'
0110 28B2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B4 0000 
     28B6 FF0D 
     28B8 2005 
0111 28BA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28BC 0804 
     28BE 0F27 
     28C0 C2B9 
0112 28C2 600B             data  >600b,>0907,>063f,>c1B8
     28C4 0907 
     28C6 063F 
     28C8 C1B8 
0113 28CA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28CC 7B02 
     28CE 015F 
     28D0 C0C3 
0114 28D2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D4 7D0E 
     28D6 0CC6 
     28D8 BFC4 
0115 28DA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28DC 7C03 
     28DE BC22 
     28E0 BDBA 
0116 28E2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E4 0000 
     28E6 FF0D 
     28E8 209D 
0117 28EA 9897             data  >9897,>93b2,>9f8f,>8c9B
     28EC 93B2 
     28EE 9F8F 
     28F0 8C9B 
0118 28F2 8385             data  >8385,>84b3,>9e89,>8b80
     28F4 84B3 
     28F6 9E89 
     28F8 8B80 
0119 28FA 9692             data  >9692,>86b4,>b795,>8a8D
     28FC 86B4 
     28FE B795 
     2900 8A8D 
0120 2902 8294             data  >8294,>87b5,>b698,>888E
     2904 87B5 
     2906 B698 
     2908 888E 
0121 290A 9A91             data  >9a91,>81b1,>b090,>9cBB
     290C 81B1 
     290E B090 
     2910 9CBB 
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
0023 2912 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2914 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2916 8340 
0025 2918 04E0  34         clr   @waux1
     291A 833C 
0026 291C 04E0  34         clr   @waux2
     291E 833E 
0027 2920 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2922 833C 
0028 2924 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2926 0205  20         li    tmp1,4                ; 4 nibbles
     2928 0004 
0033 292A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 292C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     292E 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2930 0286  22         ci    tmp2,>000a
     2932 000A 
0039 2934 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2936 C21B  26         mov   *r11,tmp4
0045 2938 0988  56         srl   tmp4,8                ; Right justify
0046 293A 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     293C FFF6 
0047 293E 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2940 C21B  26         mov   *r11,tmp4
0054 2942 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2944 00FF 
0055               
0056 2946 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2948 06C6  14         swpb  tmp2
0058 294A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 294C 0944  56         srl   tmp0,4                ; Next nibble
0060 294E 0605  14         dec   tmp1
0061 2950 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2952 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2954 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2956 C160  34         mov   @waux3,tmp1           ; Get pointer
     2958 8340 
0067 295A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 295C 0585  14         inc   tmp1                  ; Next byte, not word!
0069 295E C120  34         mov   @waux2,tmp0
     2960 833E 
0070 2962 06C4  14         swpb  tmp0
0071 2964 DD44  32         movb  tmp0,*tmp1+
0072 2966 06C4  14         swpb  tmp0
0073 2968 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 296A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     296C 8340 
0078 296E D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2970 2020 
0079 2972 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2974 C120  34         mov   @waux1,tmp0
     2976 833C 
0084 2978 06C4  14         swpb  tmp0
0085 297A DD44  32         movb  tmp0,*tmp1+
0086 297C 06C4  14         swpb  tmp0
0087 297E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2980 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2982 202A 
0092 2984 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2986 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2988 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     298A 7FFF 
0098 298C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     298E 8340 
0099 2990 0460  28         b     @xutst0               ; Display string
     2992 2400 
0100 2994 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 2996 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2998 832A 
0122 299A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     299C 8000 
0123 299E 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A0 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A2 0005 
0020 29A4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A6 C155  26         mov   *tmp1,tmp1            ; /
0022 29A8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29AA 0228  22         ai    tmp4,4                ; Get end of buffer
     29AC 0004 
0024 29AE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B0 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B4 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29BA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29BC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 29BE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C0 0607  14         dec   tmp3                  ; Decrease counter
0036 29C2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C4 0207  20         li    tmp3,4                ; Check first 4 digits
     29C6 0004 
0041 29C8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29CA C11B  26         mov   *r11,tmp0
0043 29CC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29CE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D2 05CB  14 mknum3  inct  r11
0047 29D4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D6 202A 
0048 29D8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29DA 045B  20         b     *r11                  ; Exit
0050 29DC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29DE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E0 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E2 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E6 7FFF 
0058 29E8 C10B  18         mov   r11,tmp0
0059 29EA 0224  22         ai    tmp0,-4
     29EC FFFC 
0060 29EE C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F0 0206  20         li    tmp2,>0500            ; String length = 5
     29F2 0500 
0062 29F4 0460  28         b     @xutstr               ; Display string
     29F6 2402 
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
0092 29F8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29FA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 29FC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 29FE 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 2A00 0207  20         li    tmp3,5                ; Set counter
     2A02 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A04 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A06 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A08 0584  14         inc   tmp0                  ; Next character
0104 2A0A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A0C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A0E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A10 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A12 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A14 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A16 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A18 0607  14         dec   tmp3                  ; Last character ?
0120 2A1A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A1C 045B  20         b     *r11                  ; Return
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
0138 2A1E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A20 832A 
0139 2A22 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A24 8000 
0140 2A26 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A28 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2A2A 3E00 
0023 2A2C C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2A2E 3E02 
0024 2A30 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2A32 3E04 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2A34 0200  20         li    r0,>8306              ; Scratpad source address
     2A36 8306 
0029 2A38 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2A3A 3E06 
0030 2A3C 0202  20         li    r2,62                 ; Loop counter
     2A3E 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 2A40 CC70  46         mov   *r0+,*r1+
0036 2A42 CC70  46         mov   *r0+,*r1+
0037 2A44 0642  14         dect  r2
0038 2A46 16FC  14         jne   cpu.scrpad.backup.copy
0039 2A48 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2A4A 83FE 
     2A4C 3EFE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2A4E C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2A50 3E00 
0045 2A52 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2A54 3E02 
0046 2A56 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2A58 3E04 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 2A5A 045B  20         b     *r11                  ; Return to caller
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
0070 2A5C C820  54         mov   @cpu.scrpad.tgt,@>8300
     2A5E 3E00 
     2A60 8300 
0071 2A62 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2A64 3E02 
     2A66 8302 
0072 2A68 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2A6A 3E04 
     2A6C 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2A6E C800  38         mov   r0,@cpu.scrpad.tgt
     2A70 3E00 
0077 2A72 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2A74 3E02 
0078 2A76 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2A78 3E04 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2A7A 0200  20         li    r0,cpu.scrpad.tgt + 6
     2A7C 3E06 
0083 2A7E 0201  20         li    r1,>8306
     2A80 8306 
0084 2A82 0202  20         li    r2,62
     2A84 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 2A86 CC70  46         mov   *r0+,*r1+
0090 2A88 CC70  46         mov   *r0+,*r1+
0091 2A8A 0642  14         dect  r2
0092 2A8C 16FC  14         jne   cpu.scrpad.restore.copy
0093 2A8E C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     2A90 3EFE 
     2A92 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2A94 C020  34         mov   @cpu.scrpad.tgt,r0
     2A96 3E00 
0099 2A98 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2A9A 3E02 
0100 2A9C C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2A9E 3E04 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 2AA0 045B  20         b     *r11                  ; Return to caller
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
0025 2AA2 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 2AA4 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     2AA6 8300 
0031 2AA8 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 2AAA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2AAC 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 2AAE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 2AB0 0606  14         dec   tmp2
0038 2AB2 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 2AB4 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 2AB6 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2AB8 2ABE 
0044                                                   ; R14=PC
0045 2ABA 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 2ABC 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 2ABE 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     2AC0 2A5C 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 2AC2 045B  20         b     *r11                  ; Return to caller
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
0078 2AC4 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 2AC6 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2AC8 8300 
0084 2ACA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     2ACC 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 2ACE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 2AD0 0606  14         dec   tmp2
0090 2AD2 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 2AD4 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2AD6 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 2AD8 045B  20         b     *r11                  ; Return to caller
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
0041 2ADA A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 2ADC 2ADE             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 2ADE C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 2AE0 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     2AE2 8322 
0049 2AE4 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     2AE6 2026 
0050 2AE8 C020  34         mov   @>8356,r0             ; get ptr to pab
     2AEA 8356 
0051 2AEC C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 2AEE 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     2AF0 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 2AF2 06C0  14         swpb  r0                    ;
0059 2AF4 D800  38         movb  r0,@vdpa              ; send low byte
     2AF6 8C02 
0060 2AF8 06C0  14         swpb  r0                    ;
0061 2AFA D800  38         movb  r0,@vdpa              ; send high byte
     2AFC 8C02 
0062 2AFE D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     2B00 8800 
0063                       ;---------------------------; Inline VSBR end
0064 2B02 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 2B04 0704  14         seto  r4                    ; init counter
0070 2B06 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     2B08 A420 
0071 2B0A 0580  14 !       inc   r0                    ; point to next char of name
0072 2B0C 0584  14         inc   r4                    ; incr char counter
0073 2B0E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     2B10 0007 
0074 2B12 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 2B14 80C4  18         c     r4,r3                 ; end of name?
0077 2B16 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 2B18 06C0  14         swpb  r0                    ;
0082 2B1A D800  38         movb  r0,@vdpa              ; send low byte
     2B1C 8C02 
0083 2B1E 06C0  14         swpb  r0                    ;
0084 2B20 D800  38         movb  r0,@vdpa              ; send high byte
     2B22 8C02 
0085 2B24 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2B26 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 2B28 DC81  32         movb  r1,*r2+               ; move into buffer
0092 2B2A 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     2B2C 2BEE 
0093 2B2E 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 2B30 C104  18         mov   r4,r4                 ; Check if length = 0
0099 2B32 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 2B34 04E0  34         clr   @>83d0
     2B36 83D0 
0102 2B38 C804  38         mov   r4,@>8354             ; save name length for search
     2B3A 8354 
0103 2B3C 0584  14         inc   r4                    ; adjust for dot
0104 2B3E A804  38         a     r4,@>8356             ; point to position after name
     2B40 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 2B42 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B44 83E0 
0110 2B46 04C1  14         clr   r1                    ; version found of dsr
0111 2B48 020C  20         li    r12,>0f00             ; init cru addr
     2B4A 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 2B4C C30C  18         mov   r12,r12               ; anything to turn off?
0117 2B4E 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 2B50 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 2B52 022C  22         ai    r12,>0100             ; next rom to turn on
     2B54 0100 
0125 2B56 04E0  34         clr   @>83d0                ; clear in case we are done
     2B58 83D0 
0126 2B5A 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B5C 2000 
0127 2B5E 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 2B60 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     2B62 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 2B64 1D00  20         sbo   0                     ; turn on rom
0134 2B66 0202  20         li    r2,>4000              ; start at beginning of rom
     2B68 4000 
0135 2B6A 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     2B6C 2BEA 
0136 2B6E 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 2B70 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     2B72 A40A 
0146 2B74 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 2B76 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B78 83D2 
0152                                                   ; subprogram
0153               
0154 2B7A 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 2B7C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 2B7E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 2B80 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B82 83D2 
0163                                                   ; subprogram
0164               
0165 2B84 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 2B86 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 2B88 04C5  14         clr   r5                    ; Remove any old stuff
0174 2B8A D160  34         movb  @>8355,r5             ; get length as counter
     2B8C 8355 
0175 2B8E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 2B90 9C85  32         cb    r5,*r2+               ; see if length matches
0180 2B92 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 2B94 0985  56         srl   r5,8                  ; yes, move to low byte
0185 2B96 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B98 A420 
0186 2B9A 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 2B9C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 2B9E 0605  14         dec   r5                    ; loop until full length checked
0191 2BA0 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 2BA2 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     2BA4 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 2BA6 0581  14         inc   r1                    ; next version found
0203 2BA8 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 2BAA 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 2BAC 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 2BAE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BB0 A400 
0212 2BB2 C009  18         mov   r9,r0                 ; point to flag in pab
0213 2BB4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BB6 8322 
0214                                                   ; (8 or >a)
0215 2BB8 0281  22         ci    r1,8                  ; was it 8?
     2BBA 0008 
0216 2BBC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 2BBE D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BC0 8350 
0218                                                   ; Get error byte from @>8350
0219 2BC2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 2BC4 06C0  14         swpb  r0                    ;
0227 2BC6 D800  38         movb  r0,@vdpa              ; send low byte
     2BC8 8C02 
0228 2BCA 06C0  14         swpb  r0                    ;
0229 2BCC D800  38         movb  r0,@vdpa              ; send high byte
     2BCE 8C02 
0230 2BD0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BD2 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 2BD4 09D1  56         srl   r1,13                 ; just keep error bits
0238 2BD6 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 2BD8 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 2BDA 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2BDC A400 
0248               dsrlnk.error.devicename_invalid:
0249 2BDE 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 2BE0 06C1  14         swpb  r1                    ; put error in hi byte
0252 2BE2 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 2BE4 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     2BE6 2026 
0254 2BE8 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 2BEA AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 2BEC 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 2BEE ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 2BF0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 2BF2 C04B  18         mov   r11,r1                ; Save return address
0049 2BF4 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2BF6 A428 
0050 2BF8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 2BFA 04C5  14         clr   tmp1                  ; io.op.open
0052 2BFC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2BFE 22AC 
0053               file.open_init:
0054 2C00 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C02 0009 
0055 2C04 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C06 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 2C08 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C0A 2ADA 
0061 2C0C 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 2C0E 1029  14         jmp   file.record.pab.details
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
0090 2C10 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 2C12 C04B  18         mov   r11,r1                ; Save return address
0096 2C14 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C16 A428 
0097 2C18 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 2C1A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C1C 0001 
0099 2C1E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C20 22AC 
0100               file.close_init:
0101 2C22 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C24 0009 
0102 2C26 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C28 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 2C2A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C2C 2ADA 
0108 2C2E 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 2C30 1018  14         jmp   file.record.pab.details
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
0139 2C32 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 2C34 C04B  18         mov   r11,r1                ; Save return address
0145 2C36 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2C38 A428 
0146 2C3A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 2C3C 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C3E 0002 
0148 2C40 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2C42 22AC 
0149               file.record.read_init:
0150 2C44 0220  22         ai    r0,9                  ; Move to file descriptor length
     2C46 0009 
0151 2C48 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2C4A 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 2C4C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2C4E 2ADA 
0157 2C50 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 2C52 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 2C54 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 2C56 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 2C58 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 2C5A 1000  14         nop
0183               
0184               
0185               file.delete:
0186 2C5C 1000  14         nop
0187               
0188               
0189               file.rename:
0190 2C5E 1000  14         nop
0191               
0192               
0193               file.status:
0194 2C60 1000  14         nop
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
0211 2C62 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 2C64 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2C66 A428 
0219 2C68 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2C6A 0005 
0220 2C6C 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2C6E 22C4 
0221 2C70 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 2C72 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 2C74 0451  20         b     *r1                   ; Return to caller
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
0020 2C76 0300  24 tmgr    limi  0                     ; No interrupt processing
     2C78 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2C7A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2C7C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2C7E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2C80 2026 
0029 2C82 1602  14         jne   tmgr1a                ; No, so move on
0030 2C84 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2C86 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2C88 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2C8A 202A 
0035 2C8C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2C8E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2C90 201A 
0048 2C92 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2C94 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2C96 2018 
0050 2C98 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2C9A 0460  28         b     @kthread              ; Run kernel thread
     2C9C 2D14 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2C9E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2CA0 201E 
0056 2CA2 13EB  14         jeq   tmgr1
0057 2CA4 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2CA6 201C 
0058 2CA8 16E8  14         jne   tmgr1
0059 2CAA C120  34         mov   @wtiusr,tmp0
     2CAC 832E 
0060 2CAE 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2CB0 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2CB2 2D12 
0065 2CB4 C10A  18         mov   r10,tmp0
0066 2CB6 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2CB8 00FF 
0067 2CBA 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2CBC 2026 
0068 2CBE 1303  14         jeq   tmgr5
0069 2CC0 0284  22         ci    tmp0,60               ; 1 second reached ?
     2CC2 003C 
0070 2CC4 1002  14         jmp   tmgr6
0071 2CC6 0284  22 tmgr5   ci    tmp0,50
     2CC8 0032 
0072 2CCA 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2CCC 1001  14         jmp   tmgr8
0074 2CCE 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2CD0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2CD2 832C 
0079 2CD4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2CD6 FF00 
0080 2CD8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2CDA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2CDC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2CDE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2CE0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2CE2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2CE4 830C 
     2CE6 830D 
0089 2CE8 1608  14         jne   tmgr10                ; No, get next slot
0090 2CEA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2CEC FF00 
0091 2CEE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2CF0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2CF2 8330 
0096 2CF4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2CF6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2CF8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2CFA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2CFC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2CFE 8315 
     2D00 8314 
0103 2D02 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D04 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D06 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D08 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D0A 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D0C 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D0E FF00 
0109 2D10 10B4  14         jmp   tmgr1
0110 2D12 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2D14 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D16 201A 
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
0041 2D18 06A0  32         bl    @realkb               ; Scan full keyboard
     2D1A 27BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D1C 0460  28         b     @tmgr3                ; Exit
     2D1E 2C9E 
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
0017 2D20 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D22 832E 
0018 2D24 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D26 201C 
0019 2D28 045B  20 mkhoo1  b     *r11                  ; Return
0020      2C7A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2D2A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2D2C 832E 
0029 2D2E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2D30 FEFF 
0030 2D32 045B  20         b     *r11                  ; Return
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
0017 2D34 C13B  30 mkslot  mov   *r11+,tmp0
0018 2D36 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2D38 C184  18         mov   tmp0,tmp2
0023 2D3A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2D3C A1A0  34         a     @wtitab,tmp2          ; Add table base
     2D3E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2D40 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2D42 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2D44 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2D46 881B  46         c     *r11,@w$ffff          ; End of list ?
     2D48 202C 
0035 2D4A 1301  14         jeq   mkslo1                ; Yes, exit
0036 2D4C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2D4E 05CB  14 mkslo1  inct  r11
0041 2D50 045B  20         b     *r11                  ; Exit
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
0052 2D52 C13B  30 clslot  mov   *r11+,tmp0
0053 2D54 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2D56 A120  34         a     @wtitab,tmp0          ; Add table base
     2D58 832C 
0055 2D5A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2D5C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2D5E 045B  20         b     *r11                  ; Exit
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
0250 2D60 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2D62 2A28 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 2D64 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2D66 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 2D68 0300  24 runli1  limi  0                     ; Turn off interrupts
     2D6A 0000 
0261 2D6C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2D6E 8300 
0262 2D70 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2D72 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 2D74 0202  20 runli2  li    r2,>8308
     2D76 8308 
0267 2D78 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 2D7A 0282  22         ci    r2,>8400
     2D7C 8400 
0269 2D7E 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 2D80 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2D82 FFFF 
0274 2D84 1602  14         jne   runli4                ; No, continue
0275 2D86 0420  54         blwp  @0                    ; Yes, bye bye
     2D88 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 2D8A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2D8C 833C 
0280 2D8E 04C1  14         clr   r1                    ; Reset counter
0281 2D90 0202  20         li    r2,10                 ; We test 10 times
     2D92 000A 
0282 2D94 C0E0  34 runli5  mov   @vdps,r3
     2D96 8802 
0283 2D98 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2D9A 202A 
0284 2D9C 1302  14         jeq   runli6
0285 2D9E 0581  14         inc   r1                    ; Increase counter
0286 2DA0 10F9  14         jmp   runli5
0287 2DA2 0602  14 runli6  dec   r2                    ; Next test
0288 2DA4 16F7  14         jne   runli5
0289 2DA6 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2DA8 1250 
0290 2DAA 1202  14         jle   runli7                ; No, so it must be NTSC
0291 2DAC 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2DAE 2026 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 2DB0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2DB2 2200 
0296 2DB4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2DB6 8322 
0297 2DB8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 2DBA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 2DBC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 2DBE 04C1  14 runli9  clr   r1
0304 2DC0 04C2  14         clr   r2
0305 2DC2 04C3  14         clr   r3
0306 2DC4 0209  20         li    stack,>8400           ; Set stack
     2DC6 8400 
0307 2DC8 020F  20         li    r15,vdpw              ; Set VDP write address
     2DCA 8C00 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0315 2DCC 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2DCE 4A4A 
0316 2DD0 1605  14         jne   runlia
0317 2DD2 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2DD4 226E 
0318 2DD6 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2DD8 0000 
     2DDA 3FFF 
0323 2DDC 06A0  32 runlia  bl    @filv
     2DDE 226E 
0324 2DE0 0FC0             data  pctadr,spfclr,16      ; Load color table
     2DE2 00F4 
     2DE4 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 2DE6 06A0  32         bl    @f18unl               ; Unlock the F18A
     2DE8 26B2 
0332 2DEA 06A0  32         bl    @f18chk               ; Check if F18A is there
     2DEC 26CC 
0333 2DEE 06A0  32         bl    @f18lck               ; Lock the F18A again
     2DF0 26C2 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0339               *       <<skipped>>
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 2DF2 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2DF4 22D8 
0347 2DF6 21F6             data  spvmod                ; Equate selected video mode table
0348 2DF8 0204  20         li    tmp0,spfont           ; Get font option
     2DFA 000C 
0349 2DFC 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 2DFE 1304  14         jeq   runlid                ; Yes, skip it
0351 2E00 06A0  32         bl    @ldfnt
     2E02 2340 
0352 2E04 1100             data  fntadr,spfont         ; Load specified font
     2E06 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 2E08 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E0A 4A4A 
0357 2E0C 1602  14         jne   runlie                ; No, continue
0358 2E0E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2E10 2090 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 2E12 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2E14 0040 
0363 2E16 0460  28         b     @main                 ; Give control to main program
     2E18 6050 
**** **** ****     > tivi_b1.asm.26425
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
     6064 260E 
0039 6066 06A0  32         bl    @f18unl               ; Unlock the F18a
     6068 26B2 
0040 606A 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     606C 2312 
0041 606E 3140                   data >3140            ; F18a VR49 (>31), bit 40
0042                       ;------------------------------------------------------
0043                       ; Initialize VDP SIT
0044                       ;------------------------------------------------------
0045 6070 06A0  32         bl    @filv
     6072 226E 
0046 6074 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6076 0020 
     6078 09B0 
0047 607A 06A0  32         bl    @scron                ; Turn screen on
     607C 2616 
0048                       ;------------------------------------------------------
0049                       ; Initialize high memory expansion
0050                       ;------------------------------------------------------
0051 607E 06A0  32         bl    @film
     6080 2216 
0052 6082 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6084 0000 
     6086 6000 
0053                       ;------------------------------------------------------
0054                       ; Load SAMS default memory layout
0055                       ;------------------------------------------------------
0056 6088 06A0  32         bl    @mem.setup.sams.layout
     608A 6732 
0057                                                   ; Initialize SAMS layout
0058                       ;------------------------------------------------------
0059                       ; Setup cursor, screen, etc.
0060                       ;------------------------------------------------------
0061 608C 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     608E 262E 
0062 6090 06A0  32         bl    @s8x8                 ; Small sprite
     6092 263E 
0063               
0064 6094 06A0  32         bl    @cpym2m
     6096 2460 
0065 6098 7272                   data romsat,ramsat,4  ; Load sprite SAT
     609A 8380 
     609C 0004 
0066               
0067 609E C820  54         mov   @romsat+2,@tv.curshape
     60A0 7274 
     60A2 A014 
0068                                                   ; Save cursor shape & color
0069               
0070 60A4 06A0  32         bl    @cpym2v
     60A6 2418 
0071 60A8 1800                   data sprpdt,cursors,3*8
     60AA 7276 
     60AC 0018 
0072                                                   ; Load sprite cursor patterns
0073               
0074 60AE 06A0  32         bl    @cpym2v
     60B0 2418 
0075 60B2 1008                   data >1008,patterns,11*8
     60B4 728E 
     60B6 0058 
0076                                                   ; Load character patterns
0077               *--------------------------------------------------------------
0078               * Initialize
0079               *--------------------------------------------------------------
0080 60B8 06A0  32         bl    @tivi.init            ; Initialize TiVi editor config
     60BA 6726 
0081 60BC 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     60BE 6B92 
0082 60C0 06A0  32         bl    @edb.init             ; Initialize editor buffer
     60C2 69B4 
0083 60C4 06A0  32         bl    @idx.init             ; Initialize index
     60C6 68CE 
0084 60C8 06A0  32         bl    @fb.init              ; Initialize framebuffer
     60CA 67A2 
0085                       ;-------------------------------------------------------
0086                       ; Setup editor tasks & hook
0087                       ;-------------------------------------------------------
0088 60CC 0204  20         li    tmp0,>0200
     60CE 0200 
0089 60D0 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60D2 8314 
0090               
0091 60D4 06A0  32         bl    @at
     60D6 264E 
0092 60D8 0100                   data  >0100           ; Cursor YX position = >0000
0093               
0094 60DA 0204  20         li    tmp0,timers
     60DC 8370 
0095 60DE C804  38         mov   tmp0,@wtitab
     60E0 832C 
0096               
0097 60E2 06A0  32         bl    @mkslot
     60E4 2D34 
0098 60E6 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60E8 6FEE 
0099 60EA 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60EC 70D8 
0100 60EE 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60F0 710C 
0101 60F2 FFFF                   data eol
0102               
0103 60F4 06A0  32         bl    @mkhook
     60F6 2D20 
0104 60F8 6FBE                   data hook.keyscan     ; Setup user hook
0105               
0106 60FA 0460  28         b     @tmgr                 ; Start timers and kthread
     60FC 2C76 
0107               
0108               
**** **** ****     > tivi_b1.asm.26425
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
     6122 7738 
0031 6124 1003  14         jmp   edkey.key.check_next
0032                       ;-------------------------------------------------------
0033                       ; Use CMDB keyboard map
0034                       ;-------------------------------------------------------
0035               edkey.key.process.loadmap.cmdb:
0036 6126 0206  20         li    tmp2,keymap_actions.cmdb
     6128 77FA 
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
**** **** ****     > tivi_b1.asm.26425
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
     6172 6FE2 
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
     618A 6FE2 
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
     6196 69EA 
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
     61B0 6814 
0068 61B2 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61B4 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61B6 A106 
0074 61B8 06A0  32         bl    @up                   ; Row-- VDP cursor
     61BA 265C 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61BC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61BE 6B74 
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
     61D4 2666 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61D6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D8 67F8 
0093 61DA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61DC 6FE2 
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
     61F0 69EA 
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
     621C 6814 
0135 621E 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6220 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6222 A106 
0141 6224 06A0  32         bl    @down                 ; Row++ VDP cursor
     6226 2654 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 6228 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     622A 6B74 
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
     6240 2666 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6242 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6244 67F8 
0162 6246 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6248 6FE2 
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
     625C 67F8 
0175 625E 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6260 6FE2 
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
     626C 2666 
0184 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6270 67F8 
0185 6272 0460  28         b     @hook.keyscan.bounce              ; Back to editor main
     6274 6FE2 
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
     62BE 2666 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62C2 67F8 
0253 62C4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62C6 6FE2 
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
     631E 2666 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6320 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6322 67F8 
0336 6324 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6326 6FE2 
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
     634A 69EA 
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
     6358 6814 
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
     638C 69EA 
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
     6398 6FE2 
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
     63A4 69EA 
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
     63B4 6814 
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
     63C8 6FE2 
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
     63D4 69EA 
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
     63F4 6814 
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
     6408 6FE2 
**** **** ****     > tivi_b1.asm.26425
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
     6410 67F8 
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
     6440 6FE2 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 6442 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6444 A206 
0055 6446 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6448 67F8 
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
     6474 6FE2 
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
     648A 67F8 
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
     64A4 6914 
0109 64A6 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64A8 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 64AA C820  54         mov   @fb.topline,@parm1
     64AC A104 
     64AE 8350 
0114 64B0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64B2 6814 
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
     64DC 67F8 
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
     6522 6FE2 
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
     6532 69EA 
0213 6534 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6536 A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6538 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     653A 67F8 
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
     6550 693E 
0224 6552 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     6554 A204 
0225                       ;-------------------------------------------------------
0226                       ; Refresh frame buffer and physical screen
0227                       ;-------------------------------------------------------
0228 6556 C820  54         mov   @fb.topline,@parm1
     6558 A104 
     655A 8350 
0229 655C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     655E 6814 
0230 6560 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6562 A116 
0231                       ;-------------------------------------------------------
0232                       ; Exit
0233                       ;-------------------------------------------------------
0234               edkey.action.ins_line.exit:
0235 6564 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6566 6FE2 
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
     6576 69EA 
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
     65AA 6814 
0281 65AC 1004  14         jmp   edkey.action.newline.rest
0282                       ;-------------------------------------------------------
0283                       ; Move cursor down a row, there are still rows left
0284                       ;-------------------------------------------------------
0285               edkey.action.newline.down:
0286 65AE 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65B0 A106 
0287 65B2 06A0  32         bl    @down                 ; Row++ VDP cursor
     65B4 2654 
0288                       ;-------------------------------------------------------
0289                       ; Set VDP cursor and save variables
0290                       ;-------------------------------------------------------
0291               edkey.action.newline.rest:
0292 65B6 06A0  32         bl    @fb.get.firstnonblank
     65B8 6886 
0293 65BA C120  34         mov   @outparm1,tmp0
     65BC 8360 
0294 65BE C804  38         mov   tmp0,@fb.column
     65C0 A10C 
0295 65C2 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65C4 2666 
0296 65C6 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65C8 6B74 
0297 65CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65CC 67F8 
0298 65CE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65D0 A116 
0299                       ;-------------------------------------------------------
0300                       ; Exit
0301                       ;-------------------------------------------------------
0302               edkey.action.newline.exit:
0303 65D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65D4 6FE2 
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
     65E4 710C 
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
     65FA 67F8 
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
     6624 6FE2 
**** **** ****     > tivi_b1.asm.26425
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
     6628 2716 
0010 662A 0420  54         blwp  @0                    ; Exit
     662C 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 662E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6630 6FE2 
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
     663A 6BCC 
0031 663C 1002  14         jmp   edkey.action.cmdb.toggle.exit
0032                       ;-------------------------------------------------------
0033                       ; Hide pane
0034                       ;-------------------------------------------------------
0035               edkey.action.cmdb.hide:
0036 663E 06A0  32         bl    @cmdb.hide            ; Hide command buffer pane
     6640 6C06 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.toggle.exit:
0041 6642 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6644 6FE2 
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
     666C 72E6 
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
     668A 2314 
0092 668C C2F9  30         mov   *stack+,r11           ; Pop R11
0093 668E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6690 6FE2 
**** **** ****     > tivi_b1.asm.26425
0042                       copy  "edkey.fb.file.asm"   ; fb pane   - Actions for file related keys
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.buffer0:
0006 6692 0204  20         li   tmp0,fdname0
     6694 73B4 
0007 6696 101B  14         jmp  edkey.action.rest
0008               edkey.action.buffer1:
0009 6698 0204  20         li   tmp0,fdname1
     669A 73C4 
0010 669C 1018  14         jmp  edkey.action.rest
0011               edkey.action.buffer2:
0012 669E 0204  20         li   tmp0,fdname2
     66A0 73D4 
0013 66A2 1015  14         jmp  edkey.action.rest
0014               edkey.action.buffer3:
0015 66A4 0204  20         li   tmp0,fdname3
     66A6 73E2 
0016 66A8 1012  14         jmp  edkey.action.rest
0017               edkey.action.buffer4:
0018 66AA 0204  20         li   tmp0,fdname4
     66AC 73F0 
0019 66AE 100F  14         jmp  edkey.action.rest
0020               edkey.action.buffer5:
0021 66B0 0204  20         li   tmp0,fdname5
     66B2 73FE 
0022 66B4 100C  14         jmp  edkey.action.rest
0023               edkey.action.buffer6:
0024 66B6 0204  20         li   tmp0,fdname6
     66B8 740C 
0025 66BA 1009  14         jmp  edkey.action.rest
0026               edkey.action.buffer7:
0027 66BC 0204  20         li   tmp0,fdname7
     66BE 741A 
0028 66C0 1006  14         jmp  edkey.action.rest
0029               edkey.action.buffer8:
0030 66C2 0204  20         li   tmp0,fdname8
     66C4 7428 
0031 66C6 1003  14         jmp  edkey.action.rest
0032               edkey.action.buffer9:
0033 66C8 0204  20         li   tmp0,fdname9
     66CA 7436 
0034 66CC 1000  14         jmp  edkey.action.rest
0035               
0036               edkey.action.rest:
0037 66CE 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     66D0 6E6A 
0038                                                   ; | i  tmp0 = Pointer to device and filename
0039                                                   ; /
0040               
0041 66D2 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66D4 639A 
**** **** ****     > tivi_b1.asm.26425
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
     66E4 67F8 
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
     6714 6FE2 
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
     6724 6FE2 
**** **** ****     > tivi_b1.asm.26425
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
     6730 2212 
**** **** ****     > tivi_b1.asm.26425
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
0009               * mem.setup.sams.layout
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
0020               mem.setup.sams.layout:
0021 6732 0649  14         dect  stack
0022 6734 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 6736 06A0  32         bl    @sams.layout
     6738 2562 
0027 673A 6740                   data mem.sams.layout.data
0028                       ;------------------------------------------------------
0029                       ; Exit
0030                       ;------------------------------------------------------
0031               mem.setup.sams.layout.exit:
0032 673C C2F9  30         mov   *stack+,r11           ; Pop r11
0033 673E 045B  20         b     *r11                  ; Return to caller
0034               ***************************************************************
0035               * SAMS page layout table for TiVi (16 words)
0036               *--------------------------------------------------------------
0037               mem.sams.layout.data:
0038 6740 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6742 0002 
0039 6744 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6746 0003 
0040 6748 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     674A 000A 
0041 674C B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     674E 000B 
0042 6750 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6752 000C 
0043 6754 D000             data  >d000,>0030           ; >d000-dfff, SAMS page >30
     6756 0030 
0044 6758 E000             data  >e000,>0010           ; >e000-efff, SAMS page >10
     675A 0010 
0045 675C F000             data  >f000,>0011           ; >f000-ffff, SAMS page >11
     675E 0011 
0046               
0047               
0048               
0049               
0050               ***************************************************************
0051               * mem.edb.sams.pagein
0052               * Activate editor buffer SAMS page for line
0053               ***************************************************************
0054               * bl  @mem.edb.sams.pagein
0055               *     data p0
0056               *--------------------------------------------------------------
0057               * p0 = Line number in editor buffer
0058               *--------------------------------------------------------------
0059               * bl  @xmem.edb.sams.pagein
0060               *
0061               * tmp0 = Line number in editor buffer
0062               *--------------------------------------------------------------
0063               * OUTPUT
0064               * outparm1 = Pointer to line in editor buffer
0065               * outparm2 = SAMS page
0066               *--------------------------------------------------------------
0067               * Register usage
0068               * tmp0, tmp1
0069               ***************************************************************
0070               mem.edb.sams.pagein:
0071 6760 C13B  30         mov   *r11+,tmp0            ; Get p0
0072               xmem.edb.sams.pagein:
0073 6762 0649  14         dect  stack
0074 6764 C64B  30         mov   r11,*stack            ; Push return address
0075 6766 0649  14         dect  stack
0076 6768 C644  30         mov   tmp0,*stack           ; Push tmp0
0077 676A 0649  14         dect  stack
0078 676C C645  30         mov   tmp1,*stack           ; Push tmp1
0079                       ;------------------------------------------------------
0080                       ; Sanity check
0081                       ;------------------------------------------------------
0082 676E 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6770 A204 
0083 6772 1104  14         jlt   mem.edb.sams.pagein.lookup
0084                                                   ; All checks passed, continue
0085                                                   ;--------------------------
0086                                                   ; Sanity check failed
0087                                                   ;--------------------------
0088 6774 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6776 FFCE 
0089 6778 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     677A 2030 
0090                       ;------------------------------------------------------
0091                       ; Lookup SAMS page for line in parm1
0092                       ;------------------------------------------------------
0093               mem.edb.sams.pagein.lookup:
0094 677C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     677E 696E 
0095                                                   ; \ i  parm1    = Line number
0096                                                   ; | o  outparm1 = Pointer to line
0097                                                   ; / o  outparm2 = SAMS page
0098               
0099 6780 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6782 8362 
0100 6784 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6786 8360 
0101 6788 1308  14         jeq   mem.edb.sams.pagein.exit
0102                                                   ; Nothing to page-in if NULL pointer
0103                                                   ; (=empty line)
0104                       ;------------------------------------------------------
0105                       ; Determine if requested SAMS page is already active
0106                       ;------------------------------------------------------
0107 678A 8120  34         c     @tv.sams.d000,tmp0    ; Compare with active page editor buffer
     678C A00A 
0108 678E 1305  14         jeq   mem.edb.sams.pagein.exit
0109                                                   ; Request page already active. Exit.
0110                       ;------------------------------------------------------
0111                       ; Activate requested SAMS page
0112                       ;-----------------------------------------------------
0113 6790 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6792 24FC 
0114                                                   ; \ i  tmp0 = SAMS page
0115                                                   ; / i  tmp1 = Memory address
0116               
0117 6794 C820  54         mov   @outparm2,@tv.sams.d000
     6796 8362 
     6798 A00A 
0118                                                   ; Set page in shadow registers
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               mem.edb.sams.pagein.exit:
0123 679A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0124 679C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0125 679E C2F9  30         mov   *stack+,r11           ; Pop r11
0126 67A0 045B  20         b     *r11                  ; Return to caller
0127               
**** **** ****     > tivi_b1.asm.26425
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
0024 67A2 0649  14         dect  stack
0025 67A4 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 67A6 0204  20         li    tmp0,fb.top
     67A8 A600 
0030 67AA C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     67AC A100 
0031 67AE 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     67B0 A104 
0032 67B2 04E0  34         clr   @fb.row               ; Current row=0
     67B4 A106 
0033 67B6 04E0  34         clr   @fb.column            ; Current column=0
     67B8 A10C 
0034               
0035 67BA 0204  20         li    tmp0,80
     67BC 0050 
0036 67BE C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     67C0 A10E 
0037               
0038 67C2 0204  20         li    tmp0,27
     67C4 001B 
0039 67C6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
     67C8 A118 
0040 67CA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     67CC A11A 
0041               
0042 67CE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     67D0 A016 
0043 67D2 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     67D4 A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 67D6 06A0  32         bl    @film
     67D8 2216 
0048 67DA A600             data  fb.top,>00,fb.size    ; Clear it all the way
     67DC 0000 
     67DE 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit
0053 67E0 0460  28         b     @poprt                ; Return to caller
     67E2 2212 
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
0078 67E4 0649  14         dect  stack
0079 67E6 C64B  30         mov   r11,*stack            ; Save return address
0080                       ;------------------------------------------------------
0081                       ; Calculate line in editor buffer
0082                       ;------------------------------------------------------
0083 67E8 C120  34         mov   @parm1,tmp0
     67EA 8350 
0084 67EC A120  34         a     @fb.topline,tmp0
     67EE A104 
0085 67F0 C804  38         mov   tmp0,@outparm1
     67F2 8360 
0086                       ;------------------------------------------------------
0087                       ; Exit
0088                       ;------------------------------------------------------
0089               fb.row2line$$:
0090 67F4 0460  28         b    @poprt                 ; Return to caller
     67F6 2212 
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
0118 67F8 0649  14         dect  stack
0119 67FA C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Calculate pointer
0122                       ;------------------------------------------------------
0123 67FC C1A0  34         mov   @fb.row,tmp2
     67FE A106 
0124 6800 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     6802 A10E 
0125 6804 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     6806 A10C 
0126 6808 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     680A A100 
0127 680C C807  38         mov   tmp3,@fb.current
     680E A102 
0128                       ;------------------------------------------------------
0129                       ; Exit
0130                       ;------------------------------------------------------
0131               fb.calc_pointer.$$
0132 6810 0460  28         b    @poprt                 ; Return to caller
     6812 2212 
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
0153 6814 0649  14         dect  stack
0154 6816 C64B  30         mov   r11,*stack            ; Push return address
0155 6818 0649  14         dect  stack
0156 681A C644  30         mov   tmp0,*stack           ; Push tmp0
0157 681C 0649  14         dect  stack
0158 681E C645  30         mov   tmp1,*stack           ; Push tmp1
0159 6820 0649  14         dect  stack
0160 6822 C646  30         mov   tmp2,*stack           ; Push tmp2
0161                       ;------------------------------------------------------
0162                       ; Setup starting position in index
0163                       ;------------------------------------------------------
0164 6824 C820  54         mov   @parm1,@fb.topline
     6826 8350 
     6828 A104 
0165 682A 04E0  34         clr   @parm2                ; Target row in frame buffer
     682C 8352 
0166                       ;------------------------------------------------------
0167                       ; Check if already at EOF
0168                       ;------------------------------------------------------
0169 682E 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6830 8350 
     6832 A204 
0170 6834 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0171                       ;------------------------------------------------------
0172                       ; Unpack line to frame buffer
0173                       ;------------------------------------------------------
0174               fb.refresh.unpack_line:
0175 6836 06A0  32         bl    @edb.line.unpack      ; Unpack line
     6838 6A92 
0176                                                   ; \ i  parm1 = Line to unpack
0177                                                   ; / i  parm2 = Target row in frame buffer
0178               
0179 683A 05A0  34         inc   @parm1                ; Next line in editor buffer
     683C 8350 
0180 683E 05A0  34         inc   @parm2                ; Next row in frame buffer
     6840 8352 
0181                       ;------------------------------------------------------
0182                       ; Last row in editor buffer reached ?
0183                       ;------------------------------------------------------
0184 6842 8820  54         c     @parm1,@edb.lines
     6844 8350 
     6846 A204 
0185 6848 1113  14         jlt   !                     ; no, do next check
0186                                                   ; yes, erase until end of frame buffer
0187                       ;------------------------------------------------------
0188                       ; Erase until end of frame buffer
0189                       ;------------------------------------------------------
0190               fb.refresh.erase_eob:
0191 684A C120  34         mov   @parm2,tmp0           ; Current row
     684C 8352 
0192 684E C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6850 A118 
0193 6852 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0194 6854 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6856 A10E 
0195               
0196 6858 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0197 685A 130E  14         jeq   fb.refresh.exit       ; Yes, so exit
0198               
0199 685C 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     685E A10E 
0200 6860 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6862 A100 
0201               
0202 6864 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0203 6866 0205  20         li    tmp1,32               ; Clear with space
     6868 0020 
0204               
0205 686A 06A0  32         bl    @xfilm                ; \ Fill memory
     686C 221C 
0206                                                   ; | i  tmp0 = Memory start address
0207                                                   ; | i  tmp1 = Byte to fill
0208                                                   ; / i  tmp2 = Number of bytes to fill
0209 686E 1004  14         jmp   fb.refresh.exit
0210                       ;------------------------------------------------------
0211                       ; Bottom row in frame buffer reached ?
0212                       ;------------------------------------------------------
0213 6870 8820  54 !       c     @parm2,@fb.scrrows
     6872 8352 
     6874 A118 
0214 6876 11DF  14         jlt   fb.refresh.unpack_line
0215                                                   ; No, unpack next line
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               fb.refresh.exit:
0220 6878 0720  34         seto  @fb.dirty             ; Refresh screen
     687A A116 
0221 687C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0222 687E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0223 6880 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0224 6882 C2F9  30         mov   *stack+,r11           ; Pop r11
0225 6884 045B  20         b     *r11                  ; Return to caller
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
0239 6886 0649  14         dect  stack
0240 6888 C64B  30         mov   r11,*stack            ; Save return address
0241                       ;------------------------------------------------------
0242                       ; Prepare for scanning
0243                       ;------------------------------------------------------
0244 688A 04E0  34         clr   @fb.column
     688C A10C 
0245 688E 06A0  32         bl    @fb.calc_pointer
     6890 67F8 
0246 6892 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6894 6B74 
0247 6896 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6898 A108 
0248 689A 1313  14         jeq   fb.get.firstnonblank.nomatch
0249                                                   ; Exit if empty line
0250 689C C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     689E A102 
0251 68A0 04C5  14         clr   tmp1
0252                       ;------------------------------------------------------
0253                       ; Scan line for non-blank character
0254                       ;------------------------------------------------------
0255               fb.get.firstnonblank.loop:
0256 68A2 D174  28         movb  *tmp0+,tmp1           ; Get character
0257 68A4 130E  14         jeq   fb.get.firstnonblank.nomatch
0258                                                   ; Exit if empty line
0259 68A6 0285  22         ci    tmp1,>2000            ; Whitespace?
     68A8 2000 
0260 68AA 1503  14         jgt   fb.get.firstnonblank.match
0261 68AC 0606  14         dec   tmp2                  ; Counter--
0262 68AE 16F9  14         jne   fb.get.firstnonblank.loop
0263 68B0 1008  14         jmp   fb.get.firstnonblank.nomatch
0264                       ;------------------------------------------------------
0265                       ; Non-blank character found
0266                       ;------------------------------------------------------
0267               fb.get.firstnonblank.match:
0268 68B2 6120  34         s     @fb.current,tmp0      ; Calculate column
     68B4 A102 
0269 68B6 0604  14         dec   tmp0
0270 68B8 C804  38         mov   tmp0,@outparm1        ; Save column
     68BA 8360 
0271 68BC D805  38         movb  tmp1,@outparm2        ; Save character
     68BE 8362 
0272 68C0 1004  14         jmp   fb.get.firstnonblank.exit
0273                       ;------------------------------------------------------
0274                       ; No non-blank character found
0275                       ;------------------------------------------------------
0276               fb.get.firstnonblank.nomatch:
0277 68C2 04E0  34         clr   @outparm1             ; X=0
     68C4 8360 
0278 68C6 04E0  34         clr   @outparm2             ; Null
     68C8 8362 
0279                       ;------------------------------------------------------
0280                       ; Exit
0281                       ;------------------------------------------------------
0282               fb.get.firstnonblank.exit:
0283 68CA 0460  28         b    @poprt                 ; Return to caller
     68CC 2212 
**** **** ****     > tivi_b1.asm.26425
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
0050 68CE 0649  14         dect  stack
0051 68D0 C64B  30         mov   r11,*stack            ; Save return address
0052                       ;------------------------------------------------------
0053                       ; Initialize
0054                       ;------------------------------------------------------
0055 68D2 0204  20         li    tmp0,idx.top
     68D4 C000 
0056 68D6 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     68D8 A202 
0057                       ;------------------------------------------------------
0058                       ; Clear index page
0059                       ;------------------------------------------------------
0060 68DA 06A0  32         bl    @film
     68DC 2216 
0061 68DE C000             data  idx.top,>00,idx.size  ; Clear index
     68E0 0000 
     68E2 1000 
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               idx.init.exit:
0066 68E4 0460  28         b     @poprt                ; Return to caller
     68E6 2212 
0067               
0068               
0069               
0070               ***************************************************************
0071               * idx.entry.update
0072               * Update index entry - Each entry corresponds to a line
0073               ***************************************************************
0074               * bl @idx.entry.update
0075               *--------------------------------------------------------------
0076               * INPUT
0077               * @parm1    = Line number in editor buffer
0078               * @parm2    = Pointer to line in editor buffer
0079               * @parm3    = SAMS page
0080               *--------------------------------------------------------------
0081               * OUTPUT
0082               * @outparm1 = Pointer to updated index entry
0083               *--------------------------------------------------------------
0084               * Register usage
0085               * tmp0,tmp1,tmp2
0086               *--------------------------------------------------------------
0087               idx.entry.update:
0088 68E8 C120  34         mov   @parm1,tmp0           ; Get line number
     68EA 8350 
0089 68EC C160  34         mov   @parm2,tmp1           ; Get pointer
     68EE 8352 
0090 68F0 130B  14         jeq   idx.entry.update.clear
0091                                                   ; Special handling for "null"-pointer
0092                       ;------------------------------------------------------
0093                       ; Calculate LSB value index slot (pointer offset)
0094                       ;------------------------------------------------------
0095 68F2 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     68F4 0FFF 
0096 68F6 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0097                       ;------------------------------------------------------
0098                       ; Calculate MSB value index slot (SAMS page)
0099                       ;------------------------------------------------------
0100 68F8 06E0  34         swpb  @parm3
     68FA 8354 
0101 68FC D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     68FE 8354 
0102                       ;------------------------------------------------------
0103                       ; Update index slot
0104                       ;------------------------------------------------------
0105               idx.entry.update.save:
0106 6900 0A14  56         sla   tmp0,1                ; line number * 2
0107 6902 C905  38         mov   tmp1,@idx.top(tmp0)   ; Update index slot
     6904 C000 
0108 6906 1003  14         jmp   idx.entry.update.exit
0109                       ;------------------------------------------------------
0110                       ; Special handling for "null"-pointer
0111                       ;------------------------------------------------------
0112               idx.entry.update.clear:
0113 6908 0A14  56         sla   tmp0,1                ; line number * 2
0114 690A 04E4  34         clr   @idx.top(tmp0)        ; Clear index slot
     690C C000 
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.update.exit:
0119 690E C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6910 8360 
0120 6912 045B  20         b     *r11                  ; Return
0121               
0122               
0123               
0124               ***************************************************************
0125               * idx.entry.delete
0126               * Delete index entry - Close gap created by delete
0127               ***************************************************************
0128               * bl @idx.entry.delete
0129               *--------------------------------------------------------------
0130               * INPUT
0131               * @parm1    = Line number in editor buffer to delete
0132               * @parm2    = Line number of last line to check for reorg
0133               *--------------------------------------------------------------
0134               * OUTPUT
0135               * @outparm1 = Pointer to deleted line (for undo)
0136               *--------------------------------------------------------------
0137               * Register usage
0138               * tmp0,tmp2
0139               *--------------------------------------------------------------
0140               idx.entry.delete:
0141 6914 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6916 8350 
0142                       ;------------------------------------------------------
0143                       ; Calculate address of index entry and save pointer
0144                       ;------------------------------------------------------
0145 6918 0A14  56         sla   tmp0,1                ; line number * 2
0146 691A C824  54         mov   @idx.top(tmp0),@outparm1
     691C C000 
     691E 8360 
0147                                                   ; Pointer to deleted line
0148                       ;------------------------------------------------------
0149                       ; Prepare for index reorg
0150                       ;------------------------------------------------------
0151 6920 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6922 8352 
0152 6924 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6926 8350 
0153 6928 1601  14         jne   idx.entry.delete.reorg
0154                       ;------------------------------------------------------
0155                       ; Special treatment if last line
0156                       ;------------------------------------------------------
0157 692A 1006  14         jmp   idx.entry.delete.lastline
0158                       ;------------------------------------------------------
0159                       ; Reorganize index entries
0160                       ;------------------------------------------------------
0161               idx.entry.delete.reorg:
0162 692C C924  54         mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
     692E C002 
     6930 C000 
0163 6932 05C4  14         inct  tmp0                  ; Next index entry
0164 6934 0606  14         dec   tmp2                  ; tmp2--
0165 6936 16FA  14         jne   idx.entry.delete.reorg
0166                                                   ; Loop unless completed
0167                       ;------------------------------------------------------
0168                       ; Last line
0169                       ;------------------------------------------------------
0170               idx.entry.delete.lastline:
0171 6938 04E4  34         clr   @idx.top(tmp0)
     693A C000 
0172                       ;------------------------------------------------------
0173                       ; Exit
0174                       ;------------------------------------------------------
0175               idx.entry.delete.exit:
0176 693C 045B  20         b     *r11                  ; Return
0177               
0178               
0179               ***************************************************************
0180               * idx.entry.insert
0181               * Insert index entry
0182               ***************************************************************
0183               * bl @idx.entry.insert
0184               *--------------------------------------------------------------
0185               * INPUT
0186               * @parm1    = Line number in editor buffer to insert
0187               * @parm2    = Line number of last line to check for reorg
0188               *--------------------------------------------------------------
0189               * OUTPUT
0190               * NONE
0191               *--------------------------------------------------------------
0192               * Register usage
0193               * tmp0,tmp2
0194               *--------------------------------------------------------------
0195               idx.entry.insert:
0196 693E C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6940 8352 
0197                       ;------------------------------------------------------
0198                       ; Calculate address of index entry and save pointer
0199                       ;------------------------------------------------------
0200 6942 0A14  56         sla   tmp0,1                ; line number * 2
0201                       ;------------------------------------------------------
0202                       ; Prepare for index reorg
0203                       ;------------------------------------------------------
0204 6944 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6946 8352 
0205 6948 61A0  34         s     @parm1,tmp2           ; Calculate loop
     694A 8350 
0206 694C 1606  14         jne   idx.entry.insert.reorg
0207                       ;------------------------------------------------------
0208                       ; Special treatment if last line
0209                       ;------------------------------------------------------
0210 694E C924  54         mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     6950 C000 
     6952 C002 
0211                                                   ; Move index entry
0212 6954 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry
     6956 C000 
0213               
0214 6958 1009  14         jmp   idx.entry.insert.exit
0215                       ;------------------------------------------------------
0216                       ; Reorganize index entries
0217                       ;------------------------------------------------------
0218               idx.entry.insert.reorg:
0219 695A 05C6  14         inct  tmp2                  ; Adjust one time
0220               
0221 695C C924  54 !       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
     695E C000 
     6960 C002 
0222                                                   ; Move index entry
0223               
0224 6962 0644  14         dect  tmp0                  ; Previous index entry
0225 6964 0606  14         dec   tmp2                  ; tmp2--
0226 6966 16FA  14         jne   -!                    ; Loop unless completed
0227               
0228 6968 04E4  34         clr   @idx.top+4(tmp0)      ; Clear new index entry
     696A C004 
0229                       ;------------------------------------------------------
0230                       ; Exit
0231                       ;------------------------------------------------------
0232               idx.entry.insert.exit:
0233 696C 045B  20         b     *r11                  ; Return
0234               
0235               
0236               
0237               ***************************************************************
0238               * idx.pointer.get
0239               * Get pointer to editor buffer line content
0240               ***************************************************************
0241               * bl @idx.pointer.get
0242               *--------------------------------------------------------------
0243               * INPUT
0244               * @parm1 = Line number in editor buffer
0245               *--------------------------------------------------------------
0246               * OUTPUT
0247               * @outparm1 = Pointer to editor buffer line content
0248               * @outparm2 = SAMS page
0249               *--------------------------------------------------------------
0250               * Register usage
0251               * tmp0,tmp1,tmp2
0252               *--------------------------------------------------------------
0253               idx.pointer.get:
0254 696E 0649  14         dect  stack
0255 6970 C64B  30         mov   r11,*stack            ; Save return address
0256 6972 0649  14         dect  stack
0257 6974 C644  30         mov   tmp0,*stack           ; Push tmp0
0258 6976 0649  14         dect  stack
0259 6978 C645  30         mov   tmp1,*stack           ; Push tmp1
0260 697A 0649  14         dect  stack
0261 697C C646  30         mov   tmp2,*stack           ; Push tmp2
0262                       ;------------------------------------------------------
0263                       ; Get slot entry
0264                       ;------------------------------------------------------
0265 697E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6980 8350 
0266 6982 0A14  56         sla   tmp0,1                ; line number * 2
0267 6984 C164  34         mov   @idx.top(tmp0),tmp1   ; Get slot entry
     6986 C000 
0268 6988 130C  14         jeq   idx.pointer.get.parm.null
0269                                                   ; Skip if index slot empty
0270                       ;------------------------------------------------------
0271                       ; Calculate MSB (SAMS page)
0272                       ;------------------------------------------------------
0273 698A C185  18         mov   tmp1,tmp2             ; \
0274 698C 0986  56         srl   tmp2,8                ; / Right align SAMS page
0275                       ;------------------------------------------------------
0276                       ; Calculate LSB (pointer address)
0277                       ;------------------------------------------------------
0278 698E 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6990 00FF 
0279 6992 0A45  56         sla   tmp1,4                ; Multiply with 16
0280 6994 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6996 D000 
0281                       ;------------------------------------------------------
0282                       ; Return parameters
0283                       ;------------------------------------------------------
0284               idx.pointer.get.parm:
0285 6998 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     699A 8360 
0286 699C C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     699E 8362 
0287 69A0 1004  14         jmp   idx.pointer.get.exit
0288                       ;------------------------------------------------------
0289                       ; Special handling for "null"-pointer
0290                       ;------------------------------------------------------
0291               idx.pointer.get.parm.null:
0292 69A2 04E0  34         clr   @outparm1
     69A4 8360 
0293 69A6 04E0  34         clr   @outparm2
     69A8 8362 
0294                       ;------------------------------------------------------
0295                       ; Exit
0296                       ;------------------------------------------------------
0297               idx.pointer.get.exit:
0298 69AA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0299 69AC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0300 69AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0301 69B0 C2F9  30         mov   *stack+,r11           ; Pop r11
0302 69B2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > tivi_b1.asm.26425
0048                       copy  "edb.asm"             ; Editor Buffer
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
0026 69B4 0649  14         dect  stack
0027 69B6 C64B  30         mov   r11,*stack            ; Save return address
0028 69B8 0649  14         dect  stack
0029 69BA C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 69BC 0204  20         li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
     69BE D002 
0034                                                   ; with null pointer (has offset 0)
0035               
0036 69C0 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     69C2 A200 
0037 69C4 C804  38         mov   tmp0,@edb.next_free.ptr
     69C6 A208 
0038                                                   ; Set pointer to next free line in
0039                                                   ; editor buffer
0040               
0041 69C8 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     69CA A20A 
0042 69CC 04E0  34         clr   @edb.lines            ; Lines=0
     69CE A204 
0043 69D0 04E0  34         clr   @edb.rle              ; RLE compression off
     69D2 A20C 
0044               
0045 69D4 0204  20         li    tmp0,txt.newfile      ; "New file"
     69D6 734E 
0046 69D8 C804  38         mov   tmp0,@edb.filename.ptr
     69DA A20E 
0047               
0048 69DC 0204  20         li    tmp0,txt.filetype.none
     69DE 739A 
0049 69E0 C804  38         mov   tmp0,@edb.filetype.ptr
     69E2 A210 
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 69E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 69E6 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 69E8 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               
0061               ***************************************************************
0062               * edb.line.pack
0063               * Pack current line in framebuffer
0064               ***************************************************************
0065               *  bl   @edb.line.pack
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * @fb.top       = Address of top row in frame buffer
0069               * @fb.row       = Current row in frame buffer
0070               * @fb.column    = Current column in frame buffer
0071               * @fb.colsline  = Columns per line in frame buffer
0072               *--------------------------------------------------------------
0073               * OUTPUT
0074               *--------------------------------------------------------------
0075               * Register usage
0076               * tmp0,tmp1,tmp2
0077               *--------------------------------------------------------------
0078               * Memory usage
0079               * rambuf   = Saved @fb.column
0080               * rambuf+2 = Saved beginning of row
0081               * rambuf+4 = Saved length of row
0082               ********|*****|*********************|**************************
0083               edb.line.pack:
0084 69EA 0649  14         dect  stack
0085 69EC C64B  30         mov   r11,*stack            ; Save return address
0086                       ;------------------------------------------------------
0087                       ; Get values
0088                       ;------------------------------------------------------
0089 69EE C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     69F0 A10C 
     69F2 8390 
0090 69F4 04E0  34         clr   @fb.column
     69F6 A10C 
0091 69F8 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     69FA 67F8 
0092                       ;------------------------------------------------------
0093                       ; Prepare scan
0094                       ;------------------------------------------------------
0095 69FC 04C4  14         clr   tmp0                  ; Counter
0096 69FE C160  34         mov   @fb.current,tmp1      ; Get position
     6A00 A102 
0097 6A02 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6A04 8392 
0098               
0099                       ;------------------------------------------------------
0100                       ; Scan line for >00 byte termination
0101                       ;------------------------------------------------------
0102               edb.line.pack.scan:
0103 6A06 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0104 6A08 0986  56         srl   tmp2,8                ; Right justify
0105 6A0A 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0106 6A0C 0584  14         inc   tmp0                  ; Increase string length
0107 6A0E 10FB  14         jmp   edb.line.pack.scan    ; Next character
0108               
0109                       ;------------------------------------------------------
0110                       ; Prepare for storing line
0111                       ;------------------------------------------------------
0112               edb.line.pack.prepare:
0113 6A10 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6A12 A104 
     6A14 8350 
0114 6A16 A820  54         a     @fb.row,@parm1        ; /
     6A18 A106 
     6A1A 8350 
0115               
0116 6A1C C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6A1E 8394 
0117               
0118                       ;------------------------------------------------------
0119                       ; 1. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.update_index:
0122 6A20 C120  34         mov   @edb.next_free.ptr,tmp0
     6A22 A208 
0123 6A24 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6A26 8352 
0124               
0125 6A28 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6A2A 24C4 
0126                                                   ; \ i  tmp0  = Memory address
0127                                                   ; | o  waux1 = SAMS page number
0128                                                   ; / o  waux2 = Address of SAMS register
0129               
0130 6A2C C820  54         mov   @waux1,@parm3
     6A2E 833C 
     6A30 8354 
0131 6A32 06A0  32         bl    @idx.entry.update     ; Update index
     6A34 68E8 
0132                                                   ; \ i  parm1 = Line number in editor buffer
0133                                                   ; | i  parm2 = pointer to line in
0134                                                   ; |            editor buffer
0135                                                   ; / i  parm3 = SAMS page
0136               
0137                       ;------------------------------------------------------
0138                       ; 2. Switch to required SAMS page
0139                       ;------------------------------------------------------
0140 6A36 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6A38 A212 
     6A3A 8354 
0141 6A3C 1308  14         jeq   !                     ; Yes, skip setting page
0142               
0143 6A3E C120  34         mov   @parm3,tmp0           ; get SAMS page
     6A40 8354 
0144 6A42 C160  34         mov   @edb.next_free.ptr,tmp1
     6A44 A208 
0145                                                   ; Pointer to line in editor buffer
0146 6A46 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6A48 24FC 
0147                                                   ; \ i  tmp0 = SAMS page
0148                                                   ; / i  tmp1 = Memory address
0149               
0150 6A4A C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6A4C A438 
0151               
0152                       ;------------------------------------------------------
0153                       ; 3. Set line prefix in editor buffer
0154                       ;------------------------------------------------------
0155 6A4E C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6A50 8392 
0156 6A52 C160  34         mov   @edb.next_free.ptr,tmp1
     6A54 A208 
0157                                                   ; Address of line in editor buffer
0158               
0159 6A56 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6A58 A208 
0160               
0161 6A5A C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6A5C 8394 
0162 6A5E 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0163 6A60 06C6  14         swpb  tmp2
0164 6A62 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0165 6A64 06C6  14         swpb  tmp2
0166 6A66 1310  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0167               
0168                       ;------------------------------------------------------
0169                       ; 4. Copy line from framebuffer to editor buffer
0170                       ;------------------------------------------------------
0171               edb.line.pack.copyline:
0172 6A68 0286  22         ci    tmp2,2
     6A6A 0002 
0173 6A6C 1603  14         jne   edb.line.pack.copyline.checkbyte
0174 6A6E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0175 6A70 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0176 6A72 1007  14         jmp   !
0177               edb.line.pack.copyline.checkbyte:
0178 6A74 0286  22         ci    tmp2,1
     6A76 0001 
0179 6A78 1602  14         jne   edb.line.pack.copyline.block
0180 6A7A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6A7C 1002  14         jmp   !
0182               edb.line.pack.copyline.block:
0183 6A7E 06A0  32         bl    @xpym2m               ; Copy memory block
     6A80 2466 
0184                                                   ; \ i  tmp0 = source
0185                                                   ; | i  tmp1 = destination
0186                                                   ; / i  tmp2 = bytes to copy
0187               
0188 6A82 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6A84 8394 
     6A86 A208 
0189                                                   ; Update pointer to next free line
0190               
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.exit:
0195 6A88 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6A8A 8390 
     6A8C A10C 
0196 6A8E 0460  28         b     @poprt                ; Return to caller
     6A90 2212 
0197               
0198               
0199               
0200               
0201               ***************************************************************
0202               * edb.line.unpack
0203               * Unpack specified line to framebuffer
0204               ***************************************************************
0205               *  bl   @edb.line.unpack
0206               *--------------------------------------------------------------
0207               * INPUT
0208               * @parm1 = Line to unpack in editor buffer
0209               * @parm2 = Target row in frame buffer
0210               *--------------------------------------------------------------
0211               * OUTPUT
0212               * none
0213               *--------------------------------------------------------------
0214               * Register usage
0215               * tmp0,tmp1,tmp2
0216               *--------------------------------------------------------------
0217               * Memory usage
0218               * rambuf    = Saved @parm1 of edb.line.unpack
0219               * rambuf+2  = Saved @parm2 of edb.line.unpack
0220               * rambuf+4  = Source memory address in editor buffer
0221               * rambuf+6  = Destination memory address in frame buffer
0222               * rambuf+8  = Length of line
0223               ********|*****|*********************|**************************
0224               edb.line.unpack:
0225 6A92 0649  14         dect  stack
0226 6A94 C64B  30         mov   r11,*stack            ; Save return address
0227 6A96 0649  14         dect  stack
0228 6A98 C644  30         mov   tmp0,*stack           ; Push tmp0
0229 6A9A 0649  14         dect  stack
0230 6A9C C645  30         mov   tmp1,*stack           ; Push tmp1
0231 6A9E 0649  14         dect  stack
0232 6AA0 C646  30         mov   tmp2,*stack           ; Push tmp2
0233                       ;------------------------------------------------------
0234                       ; Sanity check
0235                       ;------------------------------------------------------
0236 6AA2 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6AA4 8350 
     6AA6 A204 
0237 6AA8 1104  14         jlt   !
0238 6AAA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6AAC FFCE 
0239 6AAE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6AB0 2030 
0240                       ;------------------------------------------------------
0241                       ; Save parameters
0242                       ;------------------------------------------------------
0243 6AB2 C820  54 !       mov   @parm1,@rambuf
     6AB4 8350 
     6AB6 8390 
0244 6AB8 C820  54         mov   @parm2,@rambuf+2
     6ABA 8352 
     6ABC 8392 
0245                       ;------------------------------------------------------
0246                       ; Calculate offset in frame buffer
0247                       ;------------------------------------------------------
0248 6ABE C120  34         mov   @fb.colsline,tmp0
     6AC0 A10E 
0249 6AC2 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6AC4 8352 
0250 6AC6 C1A0  34         mov   @fb.top.ptr,tmp2
     6AC8 A100 
0251 6ACA A146  18         a     tmp2,tmp1             ; Add base to offset
0252 6ACC C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6ACE 8396 
0253                       ;------------------------------------------------------
0254                       ; Get pointer to line & page-in editor buffer page
0255                       ;------------------------------------------------------
0256 6AD0 C120  34         mov   @parm1,tmp0
     6AD2 8350 
0257 6AD4 06A0  32         bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
     6AD6 6762 
0258                                                   ; \ i  tmp0     = Line number
0259                                                   ; | o  outparm1 = Pointer to line
0260                                                   ; / o  outparm2 = SAMS page
0261               
0262 6AD8 C820  54         mov   @outparm2,@edb.sams.page
     6ADA 8362 
     6ADC A212 
0263                                                   ; Save current SAMS page
0264                       ;------------------------------------------------------
0265                       ; Handle empty line
0266                       ;------------------------------------------------------
0267 6ADE C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6AE0 8360 
0268 6AE2 1603  14         jne   !                     ; Check if pointer is set
0269 6AE4 04E0  34         clr   @rambuf+8             ; Set length=0
     6AE6 8398 
0270 6AE8 100F  14         jmp   edb.line.unpack.clear
0271                       ;------------------------------------------------------
0272                       ; Get line length
0273                       ;------------------------------------------------------
0274 6AEA C154  26 !       mov   *tmp0,tmp1            ; Get line length
0275 6AEC C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6AEE 8398 
0276               
0277 6AF0 05E0  34         inct  @outparm1             ; Skip line prefix
     6AF2 8360 
0278 6AF4 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6AF6 8360 
     6AF8 8394 
0279                       ;------------------------------------------------------
0280                       ; Sanity check on line length
0281                       ;------------------------------------------------------
0282 6AFA 0285  22         ci    tmp1,80               ; Sanity check on line length, crash
     6AFC 0050 
0283 6AFE 1204  14         jle   edb.line.unpack.clear ; if length > 80.
0284 6B00 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B02 FFCE 
0285 6B04 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B06 2030 
0286                       ;------------------------------------------------------
0287                       ; Erase chars from last column until column 80
0288                       ;------------------------------------------------------
0289               edb.line.unpack.clear:
0290 6B08 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6B0A 8396 
0291 6B0C A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6B0E 8398 
0292               
0293 6B10 04C5  14         clr   tmp1                  ; Fill with >00
0294 6B12 C1A0  34         mov   @fb.colsline,tmp2
     6B14 A10E 
0295 6B16 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6B18 8398 
0296 6B1A 0586  14         inc   tmp2
0297               
0298 6B1C 06A0  32         bl    @xfilm                ; Fill CPU memory
     6B1E 221C 
0299                                                   ; \ i  tmp0 = Target address
0300                                                   ; | i  tmp1 = Byte to fill
0301                                                   ; / i  tmp2 = Repeat count
0302                       ;------------------------------------------------------
0303                       ; Prepare for unpacking data
0304                       ;------------------------------------------------------
0305               edb.line.unpack.prepare:
0306 6B20 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6B22 8398 
0307 6B24 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0308 6B26 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6B28 8394 
0309 6B2A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6B2C 8396 
0310                       ;------------------------------------------------------
0311                       ; Check before copy
0312                       ;------------------------------------------------------
0313               edb.line.unpack.copy:
0314 6B2E 0286  22         ci    tmp2,80               ; Check line length
     6B30 0050 
0315 6B32 1204  14         jle   !
0316 6B34 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B36 FFCE 
0317 6B38 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B3A 2030 
0318                       ;------------------------------------------------------
0319                       ; Copy memory block
0320                       ;------------------------------------------------------
0321 6B3C 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6B3E 2466 
0322                                                   ; \ i  tmp0 = Source address
0323                                                   ; | i  tmp1 = Target address
0324                                                   ; / i  tmp2 = Bytes to copy
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               edb.line.unpack.exit:
0329 6B40 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0330 6B42 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0331 6B44 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0332 6B46 C2F9  30         mov   *stack+,r11           ; Pop r11
0333 6B48 045B  20         b     *r11                  ; Return to caller
0334               
0335               
0336               
0337               ***************************************************************
0338               * edb.line.getlength
0339               * Get length of specified line
0340               ***************************************************************
0341               *  bl   @edb.line.getlength
0342               *--------------------------------------------------------------
0343               * INPUT
0344               * @parm1 = Line number
0345               *--------------------------------------------------------------
0346               * OUTPUT
0347               * @outparm1 = Length of line
0348               * @outparm2 = SAMS page
0349               *--------------------------------------------------------------
0350               * Register usage
0351               * tmp0,tmp1
0352               *--------------------------------------------------------------
0353               * Remarks
0354               * Expects that the affected SAMS page is already paged-in!
0355               ********|*****|*********************|**************************
0356               edb.line.getlength:
0357 6B4A 0649  14         dect  stack
0358 6B4C C64B  30         mov   r11,*stack            ; Push return address
0359 6B4E 0649  14         dect  stack
0360 6B50 C644  30         mov   tmp0,*stack           ; Push tmp0
0361 6B52 0649  14         dect  stack
0362 6B54 C645  30         mov   tmp1,*stack           ; Push tmp1
0363                       ;------------------------------------------------------
0364                       ; Initialisation
0365                       ;------------------------------------------------------
0366 6B56 04E0  34         clr   @outparm1             ; Reset length
     6B58 8360 
0367 6B5A 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6B5C 8362 
0368                       ;------------------------------------------------------
0369                       ; Get length
0370                       ;------------------------------------------------------
0371 6B5E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6B60 696E 
0372                                                   ; \ i  parm1    = Line number
0373                                                   ; | o  outparm1 = Pointer to line
0374                                                   ; / o  outparm2 = SAMS page
0375               
0376 6B62 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6B64 8360 
0377 6B66 1302  14         jeq   edb.line.getlength.exit
0378                                                   ; Exit early if NULL pointer
0379                       ;------------------------------------------------------
0380                       ; Process line prefix
0381                       ;------------------------------------------------------
0382 6B68 C814  46         mov   *tmp0,@outparm1       ; Save length
     6B6A 8360 
0383                       ;------------------------------------------------------
0384                       ; Exit
0385                       ;------------------------------------------------------
0386               edb.line.getlength.exit:
0387 6B6C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0388 6B6E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0389 6B70 C2F9  30         mov   *stack+,r11           ; Pop r11
0390 6B72 045B  20         b     *r11                  ; Return to caller
0391               
0392               
0393               
0394               ***************************************************************
0395               * edb.line.getlength2
0396               * Get length of current row (as seen from editor buffer side)
0397               ***************************************************************
0398               *  bl   @edb.line.getlength2
0399               *--------------------------------------------------------------
0400               * INPUT
0401               * @fb.row = Row in frame buffer
0402               *--------------------------------------------------------------
0403               * OUTPUT
0404               * @fb.row.length = Length of row
0405               *--------------------------------------------------------------
0406               * Register usage
0407               * tmp0
0408               ********|*****|*********************|**************************
0409               edb.line.getlength2:
0410 6B74 0649  14         dect  stack
0411 6B76 C64B  30         mov   r11,*stack            ; Save return address
0412                       ;------------------------------------------------------
0413                       ; Calculate line in editor buffer
0414                       ;------------------------------------------------------
0415 6B78 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6B7A A104 
0416 6B7C A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6B7E A106 
0417                       ;------------------------------------------------------
0418                       ; Get length
0419                       ;------------------------------------------------------
0420 6B80 C804  38         mov   tmp0,@parm1
     6B82 8350 
0421 6B84 06A0  32         bl    @edb.line.getlength
     6B86 6B4A 
0422 6B88 C820  54         mov   @outparm1,@fb.row.length
     6B8A 8360 
     6B8C A108 
0423                                                   ; Save row length
0424                       ;------------------------------------------------------
0425                       ; Exit
0426                       ;------------------------------------------------------
0427               edb.line.getlength2.exit:
0428 6B8E 0460  28         b     @poprt                ; Return to caller
     6B90 2212 
0429               
**** **** ****     > tivi_b1.asm.26425
0049                       copy  "cmdb.asm"            ; Command Buffer
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
0027 6B92 0649  14         dect  stack
0028 6B94 C64B  30         mov   r11,*stack            ; Save return address
0029                       ;------------------------------------------------------
0030                       ; Initialize
0031                       ;------------------------------------------------------
0032 6B96 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6B98 B000 
0033 6B9A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6B9C A300 
0034               
0035 6B9E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6BA0 A302 
0036 6BA2 0204  20         li    tmp0,10
     6BA4 000A 
0037 6BA6 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6BA8 A304 
0038 6BAA C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6BAC A306 
0039               
0040 6BAE 0204  20         li    tmp0,>1b02            ; Y=27, X=2
     6BB0 1B02 
0041 6BB2 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     6BB4 A308 
0042               
0043 6BB6 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6BB8 A30E 
0044 6BBA 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6BBC A310 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6BBE 06A0  32         bl    @film
     6BC0 2216 
0049 6BC2 B000             data  cmdb.top,>00,cmdb.size
     6BC4 0000 
     6BC6 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6BC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6BCA 045B  20         b     *r11                  ; Return to caller
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
0079 6BCC 0649  14         dect  stack
0080 6BCE C64B  30         mov   r11,*stack            ; Save return address
0081 6BD0 0649  14         dect  stack
0082 6BD2 C644  30         mov   tmp0,*stack           ; Push tmp0
0083                       ;------------------------------------------------------
0084                       ; Show command buffer pane
0085                       ;------------------------------------------------------
0086 6BD4 C820  54         mov   @wyx,@cmdb.fb.yxsave
     6BD6 832A 
     6BD8 A312 
0087                                                   ; Save YX position in frame buffer
0088               
0089 6BDA C120  34         mov   @fb.scrrows.max,tmp0
     6BDC A11A 
0090 6BDE 6120  34         s     @cmdb.scrrows,tmp0
     6BE0 A304 
0091 6BE2 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     6BE4 A118 
0092               
0093 6BE6 05C4  14         inct  tmp0                  ; Line below cmdb top border line
0094 6BE8 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0095 6BEA 0584  14         inc   tmp0                  ; X=1
0096 6BEC C804  38         mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor
     6BEE A30C 
0097               
0098 6BF0 0720  34         seto  @cmdb.visible         ; Show pane
     6BF2 A302 
0099               
0100 6BF4 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     6BF6 0001 
0101 6BF8 C804  38         mov   tmp0,@tv.pane.focus   ; /
     6BFA A016 
0102               
0103 6BFC 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6BFE A116 
0104               
0105               cmdb.show.exit:
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109 6C00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0110 6C02 C2F9  30         mov   *stack+,r11           ; Pop r11
0111 6C04 045B  20         b     *r11                  ; Return to caller
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
0134 6C06 0649  14         dect  stack
0135 6C08 C64B  30         mov   r11,*stack            ; Save return address
0136                       ;------------------------------------------------------
0137                       ; Hide command buffer pane
0138                       ;------------------------------------------------------
0139 6C0A C820  54         mov   @fb.scrrows.max,@fb.scrrows
     6C0C A11A 
     6C0E A118 
0140                                                   ; Resize framebuffer
0141               
0142 6C10 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     6C12 A312 
     6C14 832A 
0143               
0144 6C16 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     6C18 A302 
0145 6C1A 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     6C1C A116 
0146 6C1E 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     6C20 A016 
0147               
0148               cmdb.hide.exit:
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152 6C22 C2F9  30         mov   *stack+,r11           ; Pop r11
0153 6C24 045B  20         b     *r11                  ; Return to caller
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
0175 6C26 0649  14         dect  stack
0176 6C28 C64B  30         mov   r11,*stack            ; Save return address
0177 6C2A 0649  14         dect  stack
0178 6C2C C644  30         mov   tmp0,*stack           ; Push tmp0
0179 6C2E 0649  14         dect  stack
0180 6C30 C645  30         mov   tmp1,*stack           ; Push tmp1
0181 6C32 0649  14         dect  stack
0182 6C34 C646  30         mov   tmp2,*stack           ; Push tmp2
0183                       ;------------------------------------------------------
0184                       ; Dump Command buffer content
0185                       ;------------------------------------------------------
0186 6C36 C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6C38 832A 
     6C3A A30A 
0187               
0188 6C3C C820  54         mov   @cmdb.yxtop,@wyx
     6C3E A30C 
     6C40 832A 
0189 6C42 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6C44 23DA 
0190               
0191 6C46 C160  34         mov   @cmdb.top.ptr,tmp1    ; Top of command buffer
     6C48 A300 
0192 6C4A 0206  20         li    tmp2,9*80
     6C4C 02D0 
0193               
0194 6C4E 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6C50 241E 
0195                                                   ; | i  tmp0 = VDP target address
0196                                                   ; | i  tmp1 = RAM source address
0197                                                   ; / i  tmp2 = Number of bytes to copy
0198               
0199                       ;------------------------------------------------------
0200                       ; Show command buffer prompt
0201                       ;------------------------------------------------------
0202 6C52 06A0  32         bl    @putat
     6C54 2410 
0203 6C56 1B01                   byte 27,1
0204 6C58 735A                   data txt.cmdb.prompt
0205               
0206 6C5A C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6C5C A30A 
     6C5E A114 
0207 6C60 C820  54         mov   @cmdb.yxsave,@wyx
     6C62 A30A 
     6C64 832A 
0208                                                   ; Restore YX position
0209               cmdb.refresh.exit:
0210                       ;------------------------------------------------------
0211                       ; Exit
0212                       ;------------------------------------------------------
0213 6C66 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0214 6C68 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0215 6C6A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0216 6C6C C2F9  30         mov   *stack+,r11           ; Pop r11
0217 6C6E 045B  20         b     *r11                  ; Return to caller
0218               
**** **** ****     > tivi_b1.asm.26425
0050                       copy  "fh.read.sams.asm"    ; File handler read file
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
0031 6C70 0649  14         dect  stack
0032 6C72 C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 6C74 04E0  34         clr   @fh.rleonload         ; No RLE compression!
     6C76 A444 
0037 6C78 04E0  34         clr   @fh.records           ; Reset records counter
     6C7A A42E 
0038 6C7C 04E0  34         clr   @fh.counter           ; Clear internal counter
     6C7E A434 
0039 6C80 04E0  34         clr   @fh.kilobytes         ; Clear kilobytes processed
     6C82 A432 
0040 6C84 04C8  14         clr   tmp4                  ; Clear kilobytes processed display counter
0041 6C86 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6C88 A42A 
0042 6C8A 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6C8C A42C 
0043               
0044 6C8E C120  34         mov   @edb.top.ptr,tmp0
     6C90 A200 
0045 6C92 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6C94 24C4 
0046                                                   ; \ i  tmp0  = Memory address
0047                                                   ; | o  waux1 = SAMS page number
0048                                                   ; / o  waux2 = Address of SAMS register
0049               
0050 6C96 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6C98 833C 
     6C9A A438 
0051 6C9C C820  54         mov   @waux1,@fh.sams.hpage ; Set highest SAMS page in use
     6C9E 833C 
     6CA0 A43A 
0052                       ;------------------------------------------------------
0053                       ; Save parameters / callback functions
0054                       ;------------------------------------------------------
0055 6CA2 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6CA4 8350 
     6CA6 A436 
0056 6CA8 C820  54         mov   @parm2,@fh.callback1  ; Loading indicator 1
     6CAA 8352 
     6CAC A43C 
0057 6CAE C820  54         mov   @parm3,@fh.callback2  ; Loading indicator 2
     6CB0 8354 
     6CB2 A43E 
0058 6CB4 C820  54         mov   @parm4,@fh.callback3  ; Loading indicator 3
     6CB6 8356 
     6CB8 A440 
0059 6CBA C820  54         mov   @parm5,@fh.callback4  ; File I/O error handler
     6CBC 8358 
     6CBE A442 
0060                       ;------------------------------------------------------
0061                       ; Sanity check
0062                       ;------------------------------------------------------
0063 6CC0 C120  34         mov   @fh.callback1,tmp0
     6CC2 A43C 
0064 6CC4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6CC6 6000 
0065 6CC8 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0066               
0067 6CCA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6CCC 7FFF 
0068 6CCE 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0069               
0070 6CD0 C120  34         mov   @fh.callback2,tmp0
     6CD2 A43E 
0071 6CD4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6CD6 6000 
0072 6CD8 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6CDA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6CDC 7FFF 
0075 6CDE 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6CE0 C120  34         mov   @fh.callback3,tmp0
     6CE2 A440 
0078 6CE4 0284  22         ci    tmp0,>6000            ; Insane address ?
     6CE6 6000 
0079 6CE8 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6CEA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6CEC 7FFF 
0082 6CEE 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6CF0 1004  14         jmp   fh.file.read.sams.load1
0085                                                   ; All checks passed, continue.
0086                                                   ;--------------------------
0087                                                   ; Check failed, crash CPU!
0088                                                   ;--------------------------
0089               fh.file.read.crash:
0090 6CF2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CF4 FFCE 
0091 6CF6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CF8 2030 
0092                       ;------------------------------------------------------
0093                       ; Show "loading indicator 1"
0094                       ;------------------------------------------------------
0095               fh.file.read.sams.load1:
0096 6CFA C120  34         mov   @fh.callback1,tmp0
     6CFC A43C 
0097 6CFE 0694  24         bl    *tmp0                 ; Run callback function
0098                       ;------------------------------------------------------
0099                       ; Copy PAB header to VDP
0100                       ;------------------------------------------------------
0101               fh.file.read.sams.pabheader:
0102 6D00 06A0  32         bl    @cpym2v
     6D02 2418 
0103 6D04 0A60                   data fh.vpab,fh.file.pab.header,9
     6D06 6E60 
     6D08 0009 
0104                                                   ; Copy PAB header to VDP
0105                       ;------------------------------------------------------
0106                       ; Append file descriptor to PAB header in VDP
0107                       ;------------------------------------------------------
0108 6D0A 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6D0C 0A69 
0109 6D0E C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6D10 A436 
0110 6D12 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0111 6D14 0986  56         srl   tmp2,8                ; Right justify
0112 6D16 0586  14         inc   tmp2                  ; Include length byte as well
0113 6D18 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6D1A 241E 
0114                       ;------------------------------------------------------
0115                       ; Load GPL scratchpad layout
0116                       ;------------------------------------------------------
0117 6D1C 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6D1E 2AA2 
0118 6D20 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0119                       ;------------------------------------------------------
0120                       ; Open file
0121                       ;------------------------------------------------------
0122 6D22 06A0  32         bl    @file.open
     6D24 2BF0 
0123 6D26 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0124 6D28 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6D2A 2026 
0125 6D2C 1602  14         jne   fh.file.read.sams.record
0126 6D2E 0460  28         b     @fh.file.read.sams.error
     6D30 6E2A 
0127                                                   ; Yes, IO error occured
0128                       ;------------------------------------------------------
0129                       ; Step 1: Read file record
0130                       ;------------------------------------------------------
0131               fh.file.read.sams.record:
0132 6D32 05A0  34         inc   @fh.records           ; Update counter
     6D34 A42E 
0133 6D36 04E0  34         clr   @fh.reclen            ; Reset record length
     6D38 A430 
0134               
0135 6D3A 06A0  32         bl    @file.record.read     ; Read file record
     6D3C 2C32 
0136 6D3E 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0137                                                   ; |           (without +9 offset!)
0138                                                   ; | o  tmp0 = Status byte
0139                                                   ; | o  tmp1 = Bytes read
0140                                                   ; | o  tmp2 = Status register contents
0141                                                   ; /           upon DSRLNK return
0142               
0143 6D40 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6D42 A42A 
0144 6D44 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6D46 A430 
0145 6D48 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6D4A A42C 
0146                       ;------------------------------------------------------
0147                       ; 1a: Calculate kilobytes processed
0148                       ;------------------------------------------------------
0149 6D4C A805  38         a     tmp1,@fh.counter
     6D4E A434 
0150 6D50 A160  34         a     @fh.counter,tmp1
     6D52 A434 
0151 6D54 0285  22         ci    tmp1,1024
     6D56 0400 
0152 6D58 1106  14         jlt   !
0153 6D5A 05A0  34         inc   @fh.kilobytes
     6D5C A432 
0154 6D5E 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6D60 FC00 
0155 6D62 C805  38         mov   tmp1,@fh.counter
     6D64 A434 
0156                       ;------------------------------------------------------
0157                       ; 1b: Load spectra scratchpad layout
0158                       ;------------------------------------------------------
0159 6D66 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6D68 2A28 
0160 6D6A 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6D6C 2AC4 
0161 6D6E 3F00                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0162                       ;------------------------------------------------------
0163                       ; 1c: Check if a file error occured
0164                       ;------------------------------------------------------
0165               fh.file.read.sams.check_fioerr:
0166 6D70 C1A0  34         mov   @fh.ioresult,tmp2
     6D72 A42C 
0167 6D74 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6D76 2026 
0168 6D78 1602  14         jne   fh.file.read.sams.check_setpage
0169                                                   ; No, goto (1d)
0170 6D7A 0460  28         b     @fh.file.read.sams.error
     6D7C 6E2A 
0171                                                   ; Yes, so handle file error
0172                       ;------------------------------------------------------
0173                       ; 1d: Check if SAMS page needs to be set
0174                       ;------------------------------------------------------
0175               fh.file.read.sams.check_setpage:
0176 6D7E C120  34         mov   @edb.next_free.ptr,tmp0
     6D80 A208 
0177                                                   ;--------------------------
0178                                                   ; Sanity check
0179                                                   ;--------------------------
0180 6D82 0284  22         ci    tmp0,edb.top + edb.size
     6D84 E000 
0181                                                   ; Insane address ?
0182 6D86 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0183                                                   ;--------------------------
0184                                                   ; Check overflow
0185                                                   ;--------------------------
0186 6D88 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     6D8A 0FFF 
0187 6D8C A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     6D8E A430 
0188 6D90 05C4  14         inct  tmp0                  ; +2 for line prefix
0189 6D92 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6D94 0FF0 
0190 6D96 110E  14         jlt   fh.file.read.sams.process_line
0191                                                   ; Not yet so skip SAMS page switch
0192                       ;------------------------------------------------------
0193                       ; 1e: Increase SAMS page
0194                       ;------------------------------------------------------
0195 6D98 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     6D9A A438 
0196 6D9C C820  54         mov   @fh.sams.page,@fh.sams.hpage
     6D9E A438 
     6DA0 A43A 
0197                                                   ; Set highest SAMS page
0198 6DA2 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6DA4 A200 
     6DA6 A208 
0199                                                   ; Start at top of SAMS page again
0200                       ;------------------------------------------------------
0201                       ; 1f: Switch to SAMS page
0202                       ;------------------------------------------------------
0203 6DA8 C120  34         mov   @fh.sams.page,tmp0
     6DAA A438 
0204 6DAC C160  34         mov   @edb.top.ptr,tmp1
     6DAE A200 
0205 6DB0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6DB2 24FC 
0206                                                   ; \ i  tmp0 = SAMS page number
0207                                                   ; / i  tmp1 = Memory address
0208                       ;------------------------------------------------------
0209                       ; Step 2: Process line
0210                       ;------------------------------------------------------
0211               fh.file.read.sams.process_line:
0212 6DB4 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     6DB6 0960 
0213 6DB8 C160  34         mov   @edb.next_free.ptr,tmp1
     6DBA A208 
0214                                                   ; RAM target in editor buffer
0215               
0216 6DBC C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6DBE 8352 
0217               
0218 6DC0 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6DC2 A430 
0219 6DC4 1318  14         jeq   fh.file.read.sams.prepindex.emptyline
0220                                                   ; Handle empty line
0221                       ;------------------------------------------------------
0222                       ; 2a: Copy line from VDP to CPU editor buffer
0223                       ;------------------------------------------------------
0224                                                   ; Put line length word before string
0225 6DC6 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0226 6DC8 06C6  14         swpb  tmp2                  ; |
0227 6DCA DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0228 6DCC 06C6  14         swpb  tmp2                  ; /
0229               
0230 6DCE 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6DD0 A208 
0231 6DD2 A806  38         a     tmp2,@edb.next_free.ptr
     6DD4 A208 
0232                                                   ; Add line length
0233               
0234 6DD6 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6DD8 2444 
0235                                                   ; \ i  tmp0 = VDP source address
0236                                                   ; | i  tmp1 = RAM target address
0237                                                   ; / i  tmp2 = Bytes to copy
0238               
0239                       ;------------------------------------------------------
0240                       ; 2b: Align pointer to multiple of 16 memory address
0241                       ;------------------------------------------------------
0242 6DDA C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6DDC A208 
0243 6DDE 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0244 6DE0 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6DE2 000F 
0245 6DE4 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6DE6 A208 
0246               
0247               
0248                       ;------------------------------------------------------
0249                       ; Step 3: Update index
0250                       ;------------------------------------------------------
0251               fh.file.read.sams.prepindex:
0252 6DE8 C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     6DEA A204 
     6DEC 8350 
0253                                                   ; parm2 = Must allready be set!
0254 6DEE C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     6DF0 A438 
     6DF2 8354 
0255               
0256 6DF4 1009  14         jmp   fh.file.read.sams.updindex
0257                                                   ; Update index
0258                       ;------------------------------------------------------
0259                       ; 3a: Special handling for empty line
0260                       ;------------------------------------------------------
0261               fh.file.read.sams.prepindex.emptyline:
0262 6DF6 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     6DF8 A42E 
     6DFA 8350 
0263 6DFC 0620  34         dec   @parm1                ;         Adjust for base 0 index
     6DFE 8350 
0264 6E00 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     6E02 8352 
0265 6E04 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     6E06 8354 
0266                       ;------------------------------------------------------
0267                       ; 3b: Do actual index update
0268                       ;------------------------------------------------------
0269               fh.file.read.sams.updindex:
0270 6E08 06A0  32         bl    @idx.entry.update     ; Update index
     6E0A 68E8 
0271                                                   ; \ i  parm1    = Line num in editor buffer
0272                                                   ; | i  parm2    = Pointer to line in editor
0273                                                   ; |               buffer
0274                                                   ; | i  parm3    = SAMS page
0275                                                   ; | o  outparm1 = Pointer to updated index
0276                                                   ; /               entry
0277               
0278 6E0C 05A0  34         inc   @edb.lines            ; lines=lines+1
     6E0E A204 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Display results
0281                       ;------------------------------------------------------
0282               fh.file.read.sams.display:
0283 6E10 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     6E12 A43E 
0284 6E14 0694  24         bl    *tmp0                 ; Run callback function
0285                       ;------------------------------------------------------
0286                       ; 4a: Next record
0287                       ;------------------------------------------------------
0288               fh.file.read.sams.next:
0289 6E16 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6E18 2AA2 
0290 6E1A 3F00                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0291                       ;-------------------------------------------------------
0292                       ; ** TEMPORARY FIX for 4KB INDEX LIMIT **
0293                       ;-------------------------------------------------------
0294 6E1C C120  34         mov   @edb.lines,tmp0
     6E1E A204 
0295 6E20 0284  22         ci    tmp0,2047
     6E22 07FF 
0296 6E24 1311  14         jeq   fh.file.read.sams.eof
0297               
0298 6E26 0460  28         b     @fh.file.read.sams.record
     6E28 6D32 
0299                                                   ; Next record
0300                       ;------------------------------------------------------
0301                       ; Error handler
0302                       ;------------------------------------------------------
0303               fh.file.read.sams.error:
0304 6E2A C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6E2C A42A 
0305 6E2E 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0306 6E30 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     6E32 0005 
0307 6E34 1309  14         jeq   fh.file.read.sams.eof
0308                                                   ; All good. File closed by DSRLNK
0309                       ;------------------------------------------------------
0310                       ; File error occured
0311                       ;------------------------------------------------------
0312 6E36 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E38 2AC4 
0313 6E3A 3F00                   data scrpad.backup2   ; / >2100->8300
0314               
0315 6E3C 06A0  32         bl    @mem.setup.sams.layout
     6E3E 6732 
0316                                                   ; Restore SAMS default memory layout
0317               
0318 6E40 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to "File I/O error handler"
     6E42 A442 
0319 6E44 0694  24         bl    *tmp0                 ; Run callback function
0320 6E46 100A  14         jmp   fh.file.read.sams.exit
0321                       ;------------------------------------------------------
0322                       ; End-Of-File reached
0323                       ;------------------------------------------------------
0324               fh.file.read.sams.eof:
0325 6E48 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6E4A 2AC4 
0326 6E4C 3F00                   data scrpad.backup2   ; / >2100->8300
0327               
0328 6E4E 06A0  32         bl    @mem.setup.sams.layout
     6E50 6732 
0329                                                   ; Restore SAMS default memory layout
0330                       ;------------------------------------------------------
0331                       ; Show "loading indicator 3" (final)
0332                       ;------------------------------------------------------
0333 6E52 0720  34         seto  @edb.dirty            ; Text changed in editor buffer!
     6E54 A206 
0334               
0335 6E56 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to "Loading indicator 3"
     6E58 A440 
0336 6E5A 0694  24         bl    *tmp0                 ; Run callback function
0337               *--------------------------------------------------------------
0338               * Exit
0339               *--------------------------------------------------------------
0340               fh.file.read.sams.exit:
0341 6E5C 0460  28         b     @poprt                ; Return to caller
     6E5E 2212 
0342               
0343               
0344               
0345               
0346               
0347               
0348               ***************************************************************
0349               * PAB for accessing DV/80 file
0350               ********|*****|*********************|**************************
0351               fh.file.pab.header:
0352 6E60 0014             byte  io.op.open            ;  0    - OPEN
0353                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0354 6E62 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0355 6E64 5000             byte  80                    ;  4    - Record length (80 chars max)
0356                       byte  00                    ;  5    - Character count
0357 6E66 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0358 6E68 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0359                       ;------------------------------------------------------
0360                       ; File descriptor part (variable length)
0361                       ;------------------------------------------------------
0362                       ; byte  12                  ;  9    - File descriptor length
0363                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0364                                                   ;         (Device + '.' + File name)
**** **** ****     > tivi_b1.asm.26425
0051                       copy  "fm.load.asm"         ; File manager loadfile
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
0014 6E6A 0649  14         dect  stack
0015 6E6C C64B  30         mov   r11,*stack            ; Save return address
0016               
0017 6E6E C804  38         mov   tmp0,@parm1           ; Setup file to load
     6E70 8350 
0018 6E72 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E74 69B4 
0019 6E76 06A0  32         bl    @idx.init             ; Initialize index
     6E78 68CE 
0020 6E7A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E7C 67A2 
0021 6E7E 06A0  32         bl    @cmdb.hide            ; Hide command buffer
     6E80 6C06 
0022 6E82 C820  54         mov   @parm1,@edb.filename.ptr
     6E84 8350 
     6E86 A20E 
0023                                                   ; Set filename
0024                       ;-------------------------------------------------------
0025                       ; Clear VDP screen buffer
0026                       ;-------------------------------------------------------
0027 6E88 06A0  32         bl    @filv
     6E8A 226E 
0028 6E8C 2000                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6E8E 0000 
     6E90 0004 
0029               
0030 6E92 C160  34         mov   @fb.scrrows,tmp1
     6E94 A118 
0031 6E96 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     6E98 A10E 
0032                                                   ; 16 bit part is in tmp2!
0033               
0034 6E9A 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     6E9C 0050 
0035 6E9E 0205  20         li    tmp1,32               ; Character to fill
     6EA0 0020 
0036               
0037 6EA2 06A0  32         bl    @xfilv                ; Fill VDP memory
     6EA4 2274 
0038                                                   ; \ i  tmp0 = VDP target address
0039                                                   ; | i  tmp1 = Byte to fill
0040                                                   ; / i  tmp2 = Bytes to copy
0041                       ;-------------------------------------------------------
0042                       ; Read DV80 file and display
0043                       ;-------------------------------------------------------
0044 6EA6 0204  20         li    tmp0,fm.loadfile.callback.indicator1
     6EA8 6EDA 
0045 6EAA C804  38         mov   tmp0,@parm2           ; Register callback 1
     6EAC 8352 
0046               
0047 6EAE 0204  20         li    tmp0,fm.loadfile.callback.indicator2
     6EB0 6F12 
0048 6EB2 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6EB4 8354 
0049               
0050 6EB6 0204  20         li    tmp0,fm.loadfile.callback.indicator3
     6EB8 6F44 
0051 6EBA C804  38         mov   tmp0,@parm4           ; Register callback 3
     6EBC 8356 
0052               
0053 6EBE 0204  20         li    tmp0,fm.loadfile.callback.fioerr
     6EC0 6F76 
0054 6EC2 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6EC4 8358 
0055               
0056 6EC6 06A0  32         bl    @fh.file.read.sams    ; Read specified file with SAMS support
     6EC8 6C70 
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
0068 6ECA 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6ECC A206 
0069                                                   ; longer dirty.
0070               
0071 6ECE 0204  20         li    tmp0,txt.filetype.DV80
     6ED0 738E 
0072 6ED2 C804  38         mov   tmp0,@edb.filetype.ptr
     6ED4 A210 
0073                                                   ; Set filetype display string
0074               *--------------------------------------------------------------
0075               * Exit
0076               *--------------------------------------------------------------
0077               fm.loadfile.exit:
0078 6ED6 0460  28         b     @poprt                ; Return to caller
     6ED8 2212 
0079               
0080               
0081               
0082               *---------------------------------------------------------------
0083               * Callback function "Show loading indicator 1"
0084               *---------------------------------------------------------------
0085               * Is expected to be passed as parm2 to @tfh.file.read
0086               *---------------------------------------------------------------
0087               fm.loadfile.callback.indicator1:
0088 6EDA 0649  14         dect  stack
0089 6EDC C64B  30         mov   r11,*stack            ; Save return address
0090                       ;------------------------------------------------------
0091                       ; Show loading indicators and file descriptor
0092                       ;------------------------------------------------------
0093 6EDE 06A0  32         bl    @hchar
     6EE0 2742 
0094 6EE2 1D03                   byte 29,3,32,77
     6EE4 204D 
0095 6EE6 FFFF                   data EOL
0096               
0097 6EE8 06A0  32         bl    @putat
     6EEA 2410 
0098 6EEC 1D03                   byte 29,3
0099 6EEE 7306                   data txt.loading      ; Display "Loading...."
0100               
0101 6EF0 8820  54         c     @fh.rleonload,@w$ffff
     6EF2 A444 
     6EF4 202C 
0102 6EF6 1604  14         jne   !
0103 6EF8 06A0  32         bl    @putat
     6EFA 2410 
0104 6EFC 1D44                   byte 29,68
0105 6EFE 7316                   data txt.rle          ; Display "RLE"
0106               
0107 6F00 06A0  32 !       bl    @at
     6F02 264E 
0108 6F04 1D0E                   byte 29,14            ; Cursor YX position
0109 6F06 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     6F08 8350 
0110 6F0A 06A0  32         bl    @xutst0               ; Display device/filename
     6F0C 2400 
0111                       ;------------------------------------------------------
0112                       ; Exit
0113                       ;------------------------------------------------------
0114               fm.loadfile.callback.indicator1.exit:
0115 6F0E 0460  28         b     @poprt                ; Return to caller
     6F10 2212 
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
0126 6F12 0649  14         dect  stack
0127 6F14 C64B  30         mov   r11,*stack            ; Save return address
0128               
0129 6F16 06A0  32         bl    @putnum
     6F18 2A1E 
0130 6F1A 1D4B                   byte 29,75            ; Show lines read
0131 6F1C A204                   data edb.lines,rambuf,>3020
     6F1E 8390 
     6F20 3020 
0132               
0133 6F22 8220  34         c     @fh.kilobytes,tmp4
     6F24 A432 
0134 6F26 130C  14         jeq   fm.loadfile.callback.indicator2.exit
0135               
0136 6F28 C220  34         mov   @fh.kilobytes,tmp4    ; Save for compare
     6F2A A432 
0137               
0138 6F2C 06A0  32         bl    @putnum
     6F2E 2A1E 
0139 6F30 1D38                   byte 29,56            ; Show kilobytes read
0140 6F32 A432                   data fh.kilobytes,rambuf,>3020
     6F34 8390 
     6F36 3020 
0141               
0142 6F38 06A0  32         bl    @putat
     6F3A 2410 
0143 6F3C 1D3D                   byte 29,61
0144 6F3E 7312                   data txt.kb           ; Show "kb" string
0145                       ;------------------------------------------------------
0146                       ; Exit
0147                       ;------------------------------------------------------
0148               fm.loadfile.callback.indicator2.exit:
0149 6F40 0460  28         b     @poprt                ; Return to caller
     6F42 2212 
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
0161 6F44 0649  14         dect  stack
0162 6F46 C64B  30         mov   r11,*stack            ; Save return address
0163               
0164               
0165 6F48 06A0  32         bl    @hchar
     6F4A 2742 
0166 6F4C 1D03                   byte 29,3,32,50       ; Erase loading indicator
     6F4E 2032 
0167 6F50 FFFF                   data EOL
0168               
0169 6F52 06A0  32         bl    @putnum
     6F54 2A1E 
0170 6F56 1D38                   byte 29,56            ; Show kilobytes read
0171 6F58 A432                   data fh.kilobytes,rambuf,>3020
     6F5A 8390 
     6F5C 3020 
0172               
0173 6F5E 06A0  32         bl    @putat
     6F60 2410 
0174 6F62 1D3D                   byte 29,61
0175 6F64 7312                   data txt.kb           ; Show "kb" string
0176               
0177 6F66 06A0  32         bl    @putnum
     6F68 2A1E 
0178 6F6A 1D4B                   byte 29,75            ; Show lines read
0179 6F6C A42E                   data fh.records,rambuf,>3020
     6F6E 8390 
     6F70 3020 
0180                       ;------------------------------------------------------
0181                       ; Exit
0182                       ;------------------------------------------------------
0183               fm.loadfile.callback.indicator3.exit:
0184 6F72 0460  28         b     @poprt                ; Return to caller
     6F74 2212 
0185               
0186               
0187               
0188               *---------------------------------------------------------------
0189               * Callback function "File I/O error handler"
0190               *---------------------------------------------------------------
0191               * Is expected to be passed as parm5 to @tfh.file.read
0192               ********|*****|*********************|**************************
0193               fm.loadfile.callback.fioerr:
0194 6F76 0649  14         dect  stack
0195 6F78 C64B  30         mov   r11,*stack            ; Save return address
0196               
0197 6F7A 06A0  32         bl    @hchar
     6F7C 2742 
0198 6F7E 1D00                   byte 29,0,32,50       ; Erase loading indicator
     6F80 2032 
0199 6F82 FFFF                   data EOL
0200               
0201                       ;------------------------------------------------------
0202                       ; Display I/O error message
0203                       ;------------------------------------------------------
0204 6F84 06A0  32         bl    @cpym2m
     6F86 2460 
0205 6F88 7321                   data txt.ioerr+1
0206 6F8A B000                   data cmdb.top
0207 6F8C 0029                   data 41               ; Error message
0208               
0209               
0210 6F8E C120  34         mov   @edb.filename.ptr,tmp0
     6F90 A20E 
0211 6F92 D194  26         movb  *tmp0,tmp2            ; Get length byte
0212 6F94 0986  56         srl   tmp2,8                ; Right align
0213 6F96 0584  14         inc   tmp0                  ; Skip length byte
0214 6F98 0205  20         li    tmp1,cmdb.top + 42    ; RAM destination address
     6F9A B02A 
0215               
0216 6F9C 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     6F9E 2466 
0217                                                   ; | i  tmp0 = ROM/RAM source
0218                                                   ; | i  tmp1 = RAM destination
0219                                                   ; / i  tmp2 = Bytes top copy
0220               
0221               
0222 6FA0 0204  20         li    tmp0,txt.newfile      ; New file
     6FA2 734E 
0223 6FA4 C804  38         mov   tmp0,@edb.filename.ptr
     6FA6 A20E 
0224               
0225 6FA8 0204  20         li    tmp0,txt.filetype.none
     6FAA 739A 
0226 6FAC C804  38         mov   tmp0,@edb.filetype.ptr
     6FAE A210 
0227                                                   ; Empty filetype string
0228               
0229 6FB0 C820  54         mov   @cmdb.scrrows,@parm1
     6FB2 A304 
     6FB4 8350 
0230 6FB6 06A0  32         bl    @cmdb.show
     6FB8 6BCC 
0231                       ;------------------------------------------------------
0232                       ; Exit
0233                       ;------------------------------------------------------
0234               fm.loadfile.callback.fioerr.exit:
0235 6FBA 0460  28         b     @poprt                ; Return to caller
     6FBC 2212 
**** **** ****     > tivi_b1.asm.26425
0052                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 6FBE 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     6FC0 2014 
0013 6FC2 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 6FC4 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6FC6 2014 
0019 6FC8 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6FCA 833C 
     6FCC 833E 
0020 6FCE 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 6FD0 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6FD2 833C 
     6FD4 833E 
0026 6FD6 0460  28         b     @edkey.key.process    ; Process key
     6FD8 60FE 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 6FDA 04E0  34         clr   @waux1
     6FDC 833C 
0032 6FDE 04E0  34         clr   @waux2
     6FE0 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 6FE2 0204  20         li    tmp0,2000             ; Avoid key bouncing
     6FE4 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 6FE6 0604  14         dec   tmp0
0043 6FE8 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 6FEA 0460  28         b     @hookok               ; Return
     6FEC 2C7A 
**** **** ****     > tivi_b1.asm.26425
0053                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0012 6FEE C120  34         mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     6FF0 A116 
0013 6FF2 136E  14         jeq   task.vdp.panes.exit   ; No, skip update
0014                       ;------------------------------------------------------
0015                       ; Show banner line
0016                       ;------------------------------------------------------
0017 6FF4 06A0  32         bl    @pane.topline.draw
     6FF6 7154 
0018 6FF8 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     6FFA 832A 
     6FFC A114 
0019                       ;------------------------------------------------------
0020                       ; Determine how many rows to copy
0021                       ;------------------------------------------------------
0022 6FFE 8820  54         c     @edb.lines,@fb.scrrows
     7000 A204 
     7002 A118 
0023 7004 1103  14         jlt   task.vdp.panes.setrows.small
0024 7006 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7008 A118 
0025 700A 1003  14         jmp   task.vdp.panes.copy.framebuffer
0026                       ;------------------------------------------------------
0027                       ; Less lines in editor buffer as rows in frame buffer
0028                       ;------------------------------------------------------
0029               task.vdp.panes.setrows.small:
0030 700C C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     700E A204 
0031 7010 0585  14         inc   tmp1
0032                       ;------------------------------------------------------
0033                       ; Determine area to copy
0034                       ;------------------------------------------------------
0035               task.vdp.panes.copy.framebuffer:
0036 7012 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7014 A10E 
0037                                                   ; 16 bit part is in tmp2!
0038 7016 0204  20         li    tmp0,80               ; VDP target address (2nd line on screen!)
     7018 0050 
0039 701A C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     701C A100 
0040                       ;------------------------------------------------------
0041                       ; Copy memory block
0042                       ;------------------------------------------------------
0043 701E 06A0  32         bl    @xpym2v               ; Copy to VDP
     7020 241E 
0044                                                   ; \ i  tmp0 = VDP target address
0045                                                   ; | i  tmp1 = RAM source address
0046                                                   ; / i  tmp2 = Bytes to copy
0047 7022 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7024 A116 
0048                       ;-------------------------------------------------------
0049                       ; Draw EOF marker at end-of-file
0050                       ;-------------------------------------------------------
0051 7026 C120  34         mov   @edb.lines,tmp0
     7028 A204 
0052 702A 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     702C A104 
0053 702E 05C4  14         inct  tmp0                  ; Y = Y + 2
0054 7030 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     7032 A118 
0055 7034 121C  14         jle   task.vdp.panes.draw_double.line
0056                       ;-------------------------------------------------------
0057                       ; Do actual drawing of EOF marker
0058                       ;-------------------------------------------------------
0059               task.vdp.panes.draw_marker:
0060 7036 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0061 7038 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     703A 832A 
0062               
0063 703C 06A0  32         bl    @putstr
     703E 23FE 
0064 7040 72F0                   data txt.marker       ; Display *EOF*
0065                       ;-------------------------------------------------------
0066                       ; Draw empty line after (and below) EOF marker
0067                       ;-------------------------------------------------------
0068 7042 06A0  32         bl    @setx
     7044 2664 
0069 7046 0005                   data  5               ; Cursor after *EOF* string
0070               
0071 7048 C120  34         mov   @wyx,tmp0
     704A 832A 
0072 704C 0984  56         srl   tmp0,8                ; Right justify
0073 704E 0584  14         inc   tmp0                  ; One time adjust
0074 7050 8120  34         c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
     7052 A118 
0075 7054 1303  14         jeq   !
0076 7056 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7058 009B 
0077 705A 1002  14         jmp   task.vdp.panes.draw_marker.empty.line
0078 705C 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     705E 004B 
0079                       ;-------------------------------------------------------
0080                       ; Draw 1 or 2 empty lines
0081                       ;-------------------------------------------------------
0082               task.vdp.panes.draw_marker.empty.line:
0083 7060 0604  14         dec   tmp0                  ; One time adjust
0084 7062 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7064 23DA 
0085 7066 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7068 0020 
0086 706A 06A0  32         bl    @xfilv                ; Fill VDP memory
     706C 2274 
0087                                                   ; i  tmp0 = VDP destination
0088                                                   ; i  tmp1 = byte to write
0089                                                   ; i  tmp2 = Number of bytes to write
0090                       ;-------------------------------------------------------
0091                       ; Draw "double" bottom line (above command buffer)
0092                       ;-------------------------------------------------------
0093               task.vdp.panes.draw_double.line:
0094 706E C120  34         mov   @fb.scrrows,tmp0
     7070 A118 
0095 7072 0584  14         inc   tmp0                  ; 1st Line after frame buffer boundary
0096 7074 06C4  14         swpb  tmp0                  ; LSB to MSB
0097 7076 C804  38         mov   tmp0,@wyx             ; Save YX
     7078 832A 
0098               
0099 707A C120  34         mov   @cmdb.visible,tmp0    ; Command buffer hidden ?
     707C A302 
0100 707E 1306  14         jeq   !                     ; Yes, full double line
0101                       ;-------------------------------------------------------
0102                       ; Double line with corners
0103                       ;-------------------------------------------------------
0104 7080 06A0  32         bl    @setx                 ; Set cursor to screen column 17
     7082 2664 
0105 7084 0001                   data 1
0106 7086 0206  20         li    tmp2,78               ; Repeat 78x
     7088 004E 
0107 708A 1005  14         jmp   task.vdp.panes.draw_double.draw
0108                       ;-------------------------------------------------------
0109                       ; Continuous double line (80 characters)
0110                       ;-------------------------------------------------------
0111 708C 06A0  32 !       bl    @setx                 ; Set cursor to screen column 0
     708E 2664 
0112 7090 0000                   data 0
0113 7092 0206  20         li    tmp2,80               ; Repeat 80x
     7094 0050 
0114                       ;-------------------------------------------------------
0115                       ; Do actual drawing
0116                       ;-------------------------------------------------------
0117               task.vdp.panes.draw_double.draw:
0118 7096 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7098 23DA 
0119 709A 0205  20         li    tmp1,3                ; Character to write (double line)
     709C 0003 
0120 709E 06A0  32         bl    @xfilv                ; \ Fill VDP memory
     70A0 2274 
0121                                                   ; | i  tmp0 = VDP destination
0122                                                   ; | i  tmp1 = Byte to write
0123                                                   ; / i  tmp2 = Number of bstes to write
0124 70A2 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     70A4 A114 
     70A6 832A 
0125                       ;-------------------------------------------------------
0126                       ; Show command buffer
0127                       ;-------------------------------------------------------
0128 70A8 C120  34         mov   @cmdb.visible,tmp0     ; Show command buffer?
     70AA A302 
0129 70AC 1311  14         jeq   task.vdp.panes.exit    ; No, skip
0130               
0131 70AE 06A0  32         bl    @cmdb.refresh          ; Refresh command buffer content
     70B0 6C26 
0132               
0133 70B2 06A0  32         bl    @vchar
     70B4 276A 
0134 70B6 1200                   byte 18,0,4,1          ; Top left corner
     70B8 0401 
0135 70BA 124F                   byte 18,79,5,1         ; Top right corner
     70BC 0501 
0136 70BE 1300                   byte 19,0,6,9          ; Left vertical double line
     70C0 0609 
0137 70C2 134F                   byte 19,79,7,9         ; Right vertical double line
     70C4 0709 
0138 70C6 1C00                   byte 28,0,8,1          ; Bottom left corner
     70C8 0801 
0139 70CA 1C4F                   byte 28,79,9,1         ; Bottom right corner
     70CC 0901 
0140 70CE FFFF                   data EOL
0141                       ;------------------------------------------------------
0142                       ; Exit task
0143                       ;------------------------------------------------------
0144               task.vdp.panes.exit:
0145 70D0 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     70D2 717E 
0146 70D4 0460  28         b     @slotok
     70D6 2CF6 
**** **** ****     > tivi_b1.asm.26425
0054                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 70D8 C120  34         mov   @tv.pane.focus,tmp0
     70DA A016 
0013 70DC 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 70DE 0284  22         ci    tmp0,pane.focus.cmdb
     70E0 0001 
0016 70E2 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 70E4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     70E6 FFCE 
0022 70E8 06A0  32         bl    @cpu.crash            ; / Halt system.
     70EA 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 70EC C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     70EE A308 
     70F0 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 70F2 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     70F4 202A 
0032 70F6 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     70F8 2670 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 70FA C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     70FC 8380 
0036               
0037 70FE 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7100 2418 
0038 7102 2000                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     7104 8380 
     7106 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 7108 0460  28         b     @slotok               ; Exit task
     710A 2CF6 
**** **** ****     > tivi_b1.asm.26425
0055                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 710C 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     710E A112 
0013 7110 1303  14         jeq   task.vdp.cursor.visible
0014 7112 04E0  34         clr   @ramsat+2              ; Hide cursor
     7114 8382 
0015 7116 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 7118 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     711A A20A 
0019 711C 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 711E C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7120 A016 
0025 7122 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 7124 0284  22         ci    tmp0,pane.focus.cmdb
     7126 0001 
0028 7128 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 712A 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 712C 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 712E 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7130 0100 
0040 7132 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 7134 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     7136 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 7138 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     713A A014 
0051 713C C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     713E A014 
     7140 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7142 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7144 2418 
0057 7146 2000                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     7148 8380 
     714A 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 714C 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     714E 717E 
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               task.vdp.cursor.exit:
0068 7150 0460  28         b     @slotok                ; Exit task
     7152 2CF6 
**** **** ****     > tivi_b1.asm.26425
0056                       copy  "pane.topline.asm"    ; Pane banner top line
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
0021 7154 0649  14         dect  stack
0022 7156 C64B  30         mov   r11,*stack            ; Save return address
0023 7158 C820  54         mov   @wyx,@fb.yxsave
     715A 832A 
     715C A114 
0024                       ;------------------------------------------------------
0025                       ; Show banner (line above frame buffer, not part of it)
0026                       ;------------------------------------------------------
0027 715E 06A0  32         bl    @hchar
     7160 2742 
0028 7162 0000                   byte 0,0,1,34         ; Double line at top (left)
     7164 0122 
0029 7166 002E                   byte 0,46,1,34        ; Double line at top (right)
     7168 0122 
0030 716A FFFF                   data EOL
0031               
0032 716C 06A0  32         bl    @putat
     716E 2410 
0033 7170 0022                   byte 0,34
0034 7172 73A6                   data txt.tivi         ; TiVi banner (middle)
0035                       ;------------------------------------------------------
0036                       ; Exit
0037                       ;------------------------------------------------------
0038               pane.topline.exit:
0039 7174 C820  54         mov   @fb.yxsave,@wyx
     7176 A114 
     7178 832A 
0040 717A C2F9  30         mov   *stack+,r11           ; Pop r11
0041 717C 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.26425
0057                       copy  "pane.botline.asm"    ; Pane status bottom line
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
0021 717E 0649  14         dect  stack
0022 7180 C64B  30         mov   r11,*stack            ; Save return address
0023 7182 0649  14         dect  stack
0024 7184 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7186 C820  54         mov   @wyx,@fb.yxsave
     7188 832A 
     718A A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 718C 06A0  32         bl    @putat
     718E 2410 
0032 7190 1D00                   byte  29,0
0033 7192 734A                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 7194 06A0  32         bl    @at
     7196 264E 
0039 7198 1D03                   byte  29,3            ; Position cursor
0040 719A C160  34         mov   @edb.filename.ptr,tmp1
     719C A20E 
0041                                                   ; Get string to display
0042 719E 06A0  32         bl    @xutst0               ; Display string
     71A0 2400 
0043               
0044 71A2 06A0  32         bl    @at
     71A4 264E 
0045 71A6 1D23                   byte  29,35           ; Position cursor
0046               
0047 71A8 C160  34         mov   @edb.filetype.ptr,tmp1
     71AA A210 
0048                                                   ; Get string to display
0049 71AC 06A0  32         bl    @xutst0               ; Display Filetype string
     71AE 2400 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 71B0 C120  34         mov   @edb.insmode,tmp0
     71B2 A20A 
0055 71B4 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 71B6 06A0  32         bl    @putat
     71B8 2410 
0061 71BA 1D32                   byte  29,50
0062 71BC 72FC                   data  txt.ovrwrite
0063 71BE 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 71C0 06A0  32         bl    @putat
     71C2 2410 
0069 71C4 1D32                   byte  29,50
0070 71C6 7300                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 71C8 C120  34         mov   @edb.dirty,tmp0
     71CA A206 
0076 71CC 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 71CE 06A0  32         bl    @putat
     71D0 2410 
0081 71D2 1D36                   byte 29,54
0082 71D4 7304                   data txt.star
0083 71D6 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 71D8 1000  14         nop
0089               pane.botline.show_linecol:
0090 71DA C820  54         mov   @fb.row,@parm1
     71DC A106 
     71DE 8350 
0091 71E0 06A0  32         bl    @fb.row2line
     71E2 67E4 
0092 71E4 05A0  34         inc   @outparm1
     71E6 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 71E8 06A0  32         bl    @putnum
     71EA 2A1E 
0097 71EC 1D40                   byte  29,64           ; YX
0098 71EE 8360                   data  outparm1,rambuf
     71F0 8390 
0099 71F2 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 71F4 06A0  32         bl    @putat
     71F6 2410 
0105 71F8 1D45                   byte  29,69
0106 71FA 72EE                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 71FC 06A0  32         bl    @film
     71FE 2216 
0111 7200 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     7202 0020 
     7204 000C 
0112               
0113 7206 C820  54         mov   @fb.column,@waux1
     7208 A10C 
     720A 833C 
0114 720C 05A0  34         inc   @waux1                ; Offset 1
     720E 833C 
0115               
0116 7210 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7212 29A0 
0117 7214 833C                   data  waux1,rambuf
     7216 8390 
0118 7218 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 721A 06A0  32         bl    @trimnum              ; Trim number to the left
     721C 29F8 
0122 721E 8390                   data  rambuf,rambuf+6,32
     7220 8396 
     7222 0020 
0123               
0124 7224 0204  20         li    tmp0,>0200
     7226 0200 
0125 7228 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     722A 8396 
0126               
0127 722C 06A0  32         bl    @putat
     722E 2410 
0128 7230 1D46                   byte 29,70
0129 7232 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7234 C820  54         mov   @fb.row,@parm1
     7236 A106 
     7238 8350 
0134 723A 06A0  32         bl    @fb.row2line
     723C 67E4 
0135 723E 8820  54         c     @edb.lines,@outparm1
     7240 A204 
     7242 8360 
0136 7244 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 7246 06A0  32         bl    @putat
     7248 2410 
0139 724A 1D4B                   byte 29,75
0140 724C 72F6                   data txt.bottom
0141               
0142 724E 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 7250 C820  54         mov   @edb.lines,@waux1
     7252 A204 
     7254 833C 
0148 7256 05A0  34         inc   @waux1                ; Offset 1
     7258 833C 
0149 725A 06A0  32         bl    @putnum
     725C 2A1E 
0150 725E 1D4B                   byte 29,75            ; YX
0151 7260 833C                   data waux1,rambuf
     7262 8390 
0152 7264 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 7266 C820  54         mov   @fb.yxsave,@wyx
     7268 A114 
     726A 832A 
0159 726C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 726E C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7270 045B  20         b     *r11                  ; Return
**** **** ****     > tivi_b1.asm.26425
0058                       copy  "data.constants.asm"  ; Data segment - Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: TiVi Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               romsat:
0008 7272 0303             data  >0303,>000f           ; Cursor YX, initial shape and colour
     7274 000F 
0009               
0010               cursors:
0011 7276 0000             data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     7278 0000 
     727A 0000 
     727C 001C 
0012 727E 1010             data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     7280 1010 
     7282 1010 
     7284 1000 
0013 7286 1C1C             data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     7288 1C1C 
     728A 1C1C 
     728C 1C00 
0014               
0015               patterns:
0016 728E 0000             data >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
     7290 FF00 
     7292 00FF 
     7294 0080 
0017 7296 0080             data >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     7298 0000 
     729A FF00 
     729C FF00 
0018               patterns.box:
0019 729E 0000             data >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     72A0 0000 
     72A2 FF00 
     72A4 FF00 
0020 72A6 0000             data >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     72A8 0000 
     72AA FF80 
     72AC BFA0 
0021 72AE 0000             data >0000,>0000,>fc04,>f414 ; 05. Top right corner
     72B0 0000 
     72B2 FC04 
     72B4 F414 
0022 72B6 A0A0             data >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     72B8 A0A0 
     72BA A0A0 
     72BC A0A0 
0023 72BE 1414             data >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     72C0 1414 
     72C2 1414 
     72C4 1414 
0024 72C6 A0A0             data >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     72C8 A0A0 
     72CA BF80 
     72CC FF00 
0025 72CE 1414             data >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     72D0 1414 
     72D2 F404 
     72D4 FC00 
0026 72D6 0000             data >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     72D8 C0C0 
     72DA C0C0 
     72DC 0080 
0027 72DE 0000             data >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     72E0 0F0F 
     72E2 0F0F 
     72E4 0000 
0028               
0029               
0030               tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
0031 72E6 F404             data  >f404                 ; White      | Dark blue  | Dark blue
0032 72E8 F101             data  >f101                 ; White      | Black      | Black
0033 72EA 1707             data  >1707                 ; Black      | Cyan       | Cyan
0034 72EC 1F0F             data  >1f0f                 ; Black      | White      | White
**** **** ****     > tivi_b1.asm.26425
0059                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: TiVi Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               txt.delim
0008 72EE 012C             byte  1
0009 72EF ....             text  ','
0010                       even
0011               
0012               txt.marker
0013 72F0 052A             byte  5
0014 72F1 ....             text  '*EOF*'
0015                       even
0016               
0017               txt.bottom
0018 72F6 0520             byte  5
0019 72F7 ....             text  '  BOT'
0020                       even
0021               
0022               txt.ovrwrite
0023 72FC 034F             byte  3
0024 72FD ....             text  'OVR'
0025                       even
0026               
0027               txt.insert
0028 7300 0349             byte  3
0029 7301 ....             text  'INS'
0030                       even
0031               
0032               txt.star
0033 7304 012A             byte  1
0034 7305 ....             text  '*'
0035                       even
0036               
0037               txt.loading
0038 7306 0A4C             byte  10
0039 7307 ....             text  'Loading...'
0040                       even
0041               
0042               txt.kb
0043 7312 026B             byte  2
0044 7313 ....             text  'kb'
0045                       even
0046               
0047               txt.rle
0048 7316 0352             byte  3
0049 7317 ....             text  'RLE'
0050                       even
0051               
0052               txt.lines
0053 731A 054C             byte  5
0054 731B ....             text  'Lines'
0055                       even
0056               
0057               txt.ioerr
0058 7320 2921             byte  41
0059 7321 ....             text  '! I/O error occured. Could not load file:'
0060                       even
0061               
0062               txt.bufnum
0063 734A 0223             byte  2
0064 734B ....             text  '#1'
0065                       even
0066               
0067               txt.newfile
0068 734E 0A5B             byte  10
0069 734F ....             text  '[New file]'
0070                       even
0071               
0072               
0073               txt.cmdb.prompt
0074 735A 013E             byte  1
0075 735B ....             text  '>'
0076                       even
0077               
0078               txt.cmdb.hint
0079 735C 2348             byte  35
0080 735D ....             text  'Hint: Type "help" for command list.'
0081                       even
0082               
0083               txt.cmdb.catalog
0084 7380 0C46             byte  12
0085 7381 ....             text  'File catalog'
0086                       even
0087               
0088               
0089               
0090               txt.filetype.dv80
0091 738E 0A44             byte  10
0092 738F ....             text  'DIS/VAR80 '
0093                       even
0094               
0095               txt.filetype.none
0096 739A 0A20             byte  10
0097 739B ....             text  '          '
0098                       even
0099               
0100               
0101 73A6 0C0A     txt.tivi     byte    12
0102                            byte    10
0103 73A8 ....                  text    'TiVi v1.00'
0104 73B2 0B00                  byte    11
0105                            even
0106               
0107               fdname0
0108 73B4 0F44             byte  15
0109 73B5 ....             text  'DSK1.FWDOC/PSRV'
0110                       even
0111               
0112               fdname1
0113 73C4 0F44             byte  15
0114 73C5 ....             text  'DSK1.SPEECHDOCS'
0115                       even
0116               
0117               fdname2
0118 73D4 0C44             byte  12
0119 73D5 ....             text  'DSK1.XBEADOC'
0120                       even
0121               
0122               fdname3
0123 73E2 0C44             byte  12
0124 73E3 ....             text  'DSK3.XBEADOC'
0125                       even
0126               
0127               fdname4
0128 73F0 0C44             byte  12
0129 73F1 ....             text  'DSK3.C99MAN1'
0130                       even
0131               
0132               fdname5
0133 73FE 0C44             byte  12
0134 73FF ....             text  'DSK3.C99MAN2'
0135                       even
0136               
0137               fdname6
0138 740C 0C44             byte  12
0139 740D ....             text  'DSK3.C99MAN3'
0140                       even
0141               
0142               fdname7
0143 741A 0D44             byte  13
0144 741B ....             text  'DSK3.C99SPECS'
0145                       even
0146               
0147               fdname8
0148 7428 0D44             byte  13
0149 7429 ....             text  'DSK3.RANDOM#C'
0150                       even
0151               
0152               fdname9
0153 7436 0D44             byte  13
0154 7437 ....             text  'DSK1.INVADERS'
0155                       even
0156               
0157               
0158               
0159               *---------------------------------------------------------------
0160               * Keyboard labels - Function keys
0161               *---------------------------------------------------------------
0162               txt.fctn.0
0163 7444 0866             byte  8
0164 7445 ....             text  'fctn + 0'
0165                       even
0166               
0167               txt.fctn.1
0168 744E 0866             byte  8
0169 744F ....             text  'fctn + 1'
0170                       even
0171               
0172               txt.fctn.2
0173 7458 0866             byte  8
0174 7459 ....             text  'fctn + 2'
0175                       even
0176               
0177               txt.fctn.3
0178 7462 0866             byte  8
0179 7463 ....             text  'fctn + 3'
0180                       even
0181               
0182               txt.fctn.4
0183 746C 0866             byte  8
0184 746D ....             text  'fctn + 4'
0185                       even
0186               
0187               txt.fctn.5
0188 7476 0866             byte  8
0189 7477 ....             text  'fctn + 5'
0190                       even
0191               
0192               txt.fctn.6
0193 7480 0866             byte  8
0194 7481 ....             text  'fctn + 6'
0195                       even
0196               
0197               txt.fctn.7
0198 748A 0866             byte  8
0199 748B ....             text  'fctn + 7'
0200                       even
0201               
0202               txt.fctn.8
0203 7494 0866             byte  8
0204 7495 ....             text  'fctn + 8'
0205                       even
0206               
0207               txt.fctn.9
0208 749E 0866             byte  8
0209 749F ....             text  'fctn + 9'
0210                       even
0211               
0212               txt.fctn.a
0213 74A8 0866             byte  8
0214 74A9 ....             text  'fctn + a'
0215                       even
0216               
0217               txt.fctn.b
0218 74B2 0866             byte  8
0219 74B3 ....             text  'fctn + b'
0220                       even
0221               
0222               txt.fctn.c
0223 74BC 0866             byte  8
0224 74BD ....             text  'fctn + c'
0225                       even
0226               
0227               txt.fctn.d
0228 74C6 0866             byte  8
0229 74C7 ....             text  'fctn + d'
0230                       even
0231               
0232               txt.fctn.e
0233 74D0 0866             byte  8
0234 74D1 ....             text  'fctn + e'
0235                       even
0236               
0237               txt.fctn.f
0238 74DA 0866             byte  8
0239 74DB ....             text  'fctn + f'
0240                       even
0241               
0242               txt.fctn.g
0243 74E4 0866             byte  8
0244 74E5 ....             text  'fctn + g'
0245                       even
0246               
0247               txt.fctn.h
0248 74EE 0866             byte  8
0249 74EF ....             text  'fctn + h'
0250                       even
0251               
0252               txt.fctn.i
0253 74F8 0866             byte  8
0254 74F9 ....             text  'fctn + i'
0255                       even
0256               
0257               txt.fctn.j
0258 7502 0866             byte  8
0259 7503 ....             text  'fctn + j'
0260                       even
0261               
0262               txt.fctn.k
0263 750C 0866             byte  8
0264 750D ....             text  'fctn + k'
0265                       even
0266               
0267               txt.fctn.l
0268 7516 0866             byte  8
0269 7517 ....             text  'fctn + l'
0270                       even
0271               
0272               txt.fctn.m
0273 7520 0866             byte  8
0274 7521 ....             text  'fctn + m'
0275                       even
0276               
0277               txt.fctn.n
0278 752A 0866             byte  8
0279 752B ....             text  'fctn + n'
0280                       even
0281               
0282               txt.fctn.o
0283 7534 0866             byte  8
0284 7535 ....             text  'fctn + o'
0285                       even
0286               
0287               txt.fctn.p
0288 753E 0866             byte  8
0289 753F ....             text  'fctn + p'
0290                       even
0291               
0292               txt.fctn.q
0293 7548 0866             byte  8
0294 7549 ....             text  'fctn + q'
0295                       even
0296               
0297               txt.fctn.r
0298 7552 0866             byte  8
0299 7553 ....             text  'fctn + r'
0300                       even
0301               
0302               txt.fctn.s
0303 755C 0866             byte  8
0304 755D ....             text  'fctn + s'
0305                       even
0306               
0307               txt.fctn.t
0308 7566 0866             byte  8
0309 7567 ....             text  'fctn + t'
0310                       even
0311               
0312               txt.fctn.u
0313 7570 0866             byte  8
0314 7571 ....             text  'fctn + u'
0315                       even
0316               
0317               txt.fctn.v
0318 757A 0866             byte  8
0319 757B ....             text  'fctn + v'
0320                       even
0321               
0322               txt.fctn.w
0323 7584 0866             byte  8
0324 7585 ....             text  'fctn + w'
0325                       even
0326               
0327               txt.fctn.x
0328 758E 0866             byte  8
0329 758F ....             text  'fctn + x'
0330                       even
0331               
0332               txt.fctn.y
0333 7598 0866             byte  8
0334 7599 ....             text  'fctn + y'
0335                       even
0336               
0337               txt.fctn.z
0338 75A2 0866             byte  8
0339 75A3 ....             text  'fctn + z'
0340                       even
0341               
0342               *---------------------------------------------------------------
0343               * Keyboard labels - Function keys extra
0344               *---------------------------------------------------------------
0345               txt.fctn.dot
0346 75AC 0866             byte  8
0347 75AD ....             text  'fctn + .'
0348                       even
0349               
0350               txt.fctn.plus
0351 75B6 0866             byte  8
0352 75B7 ....             text  'fctn + +'
0353                       even
0354               
0355               *---------------------------------------------------------------
0356               * Keyboard labels - Control keys
0357               *---------------------------------------------------------------
0358               txt.ctrl.0
0359 75C0 0863             byte  8
0360 75C1 ....             text  'ctrl + 0'
0361                       even
0362               
0363               txt.ctrl.1
0364 75CA 0863             byte  8
0365 75CB ....             text  'ctrl + 1'
0366                       even
0367               
0368               txt.ctrl.2
0369 75D4 0863             byte  8
0370 75D5 ....             text  'ctrl + 2'
0371                       even
0372               
0373               txt.ctrl.3
0374 75DE 0863             byte  8
0375 75DF ....             text  'ctrl + 3'
0376                       even
0377               
0378               txt.ctrl.4
0379 75E8 0863             byte  8
0380 75E9 ....             text  'ctrl + 4'
0381                       even
0382               
0383               txt.ctrl.5
0384 75F2 0863             byte  8
0385 75F3 ....             text  'ctrl + 5'
0386                       even
0387               
0388               txt.ctrl.6
0389 75FC 0863             byte  8
0390 75FD ....             text  'ctrl + 6'
0391                       even
0392               
0393               txt.ctrl.7
0394 7606 0863             byte  8
0395 7607 ....             text  'ctrl + 7'
0396                       even
0397               
0398               txt.ctrl.8
0399 7610 0863             byte  8
0400 7611 ....             text  'ctrl + 8'
0401                       even
0402               
0403               txt.ctrl.9
0404 761A 0863             byte  8
0405 761B ....             text  'ctrl + 9'
0406                       even
0407               
0408               txt.ctrl.a
0409 7624 0863             byte  8
0410 7625 ....             text  'ctrl + a'
0411                       even
0412               
0413               txt.ctrl.b
0414 762E 0863             byte  8
0415 762F ....             text  'ctrl + b'
0416                       even
0417               
0418               txt.ctrl.c
0419 7638 0863             byte  8
0420 7639 ....             text  'ctrl + c'
0421                       even
0422               
0423               txt.ctrl.d
0424 7642 0863             byte  8
0425 7643 ....             text  'ctrl + d'
0426                       even
0427               
0428               txt.ctrl.e
0429 764C 0863             byte  8
0430 764D ....             text  'ctrl + e'
0431                       even
0432               
0433               txt.ctrl.f
0434 7656 0863             byte  8
0435 7657 ....             text  'ctrl + f'
0436                       even
0437               
0438               txt.ctrl.g
0439 7660 0863             byte  8
0440 7661 ....             text  'ctrl + g'
0441                       even
0442               
0443               txt.ctrl.h
0444 766A 0863             byte  8
0445 766B ....             text  'ctrl + h'
0446                       even
0447               
0448               txt.ctrl.i
0449 7674 0863             byte  8
0450 7675 ....             text  'ctrl + i'
0451                       even
0452               
0453               txt.ctrl.j
0454 767E 0863             byte  8
0455 767F ....             text  'ctrl + j'
0456                       even
0457               
0458               txt.ctrl.k
0459 7688 0863             byte  8
0460 7689 ....             text  'ctrl + k'
0461                       even
0462               
0463               txt.ctrl.l
0464 7692 0863             byte  8
0465 7693 ....             text  'ctrl + l'
0466                       even
0467               
0468               txt.ctrl.m
0469 769C 0863             byte  8
0470 769D ....             text  'ctrl + m'
0471                       even
0472               
0473               txt.ctrl.n
0474 76A6 0863             byte  8
0475 76A7 ....             text  'ctrl + n'
0476                       even
0477               
0478               txt.ctrl.o
0479 76B0 0863             byte  8
0480 76B1 ....             text  'ctrl + o'
0481                       even
0482               
0483               txt.ctrl.p
0484 76BA 0863             byte  8
0485 76BB ....             text  'ctrl + p'
0486                       even
0487               
0488               txt.ctrl.q
0489 76C4 0863             byte  8
0490 76C5 ....             text  'ctrl + q'
0491                       even
0492               
0493               txt.ctrl.r
0494 76CE 0863             byte  8
0495 76CF ....             text  'ctrl + r'
0496                       even
0497               
0498               txt.ctrl.s
0499 76D8 0863             byte  8
0500 76D9 ....             text  'ctrl + s'
0501                       even
0502               
0503               txt.ctrl.t
0504 76E2 0863             byte  8
0505 76E3 ....             text  'ctrl + t'
0506                       even
0507               
0508               txt.ctrl.u
0509 76EC 0863             byte  8
0510 76ED ....             text  'ctrl + u'
0511                       even
0512               
0513               txt.ctrl.v
0514 76F6 0863             byte  8
0515 76F7 ....             text  'ctrl + v'
0516                       even
0517               
0518               txt.ctrl.w
0519 7700 0863             byte  8
0520 7701 ....             text  'ctrl + w'
0521                       even
0522               
0523               txt.ctrl.x
0524 770A 0863             byte  8
0525 770B ....             text  'ctrl + x'
0526                       even
0527               
0528               txt.ctrl.y
0529 7714 0863             byte  8
0530 7715 ....             text  'ctrl + y'
0531                       even
0532               
0533               txt.ctrl.z
0534 771E 0863             byte  8
0535 771F ....             text  'ctrl + z'
0536                       even
0537               
0538               *---------------------------------------------------------------
0539               * Keyboard labels - control keys extra
0540               *---------------------------------------------------------------
0541               txt.ctrl.plus
0542 7728 0863             byte  8
0543 7729 ....             text  'ctrl + +'
0544                       even
0545               
0546               *---------------------------------------------------------------
0547               * Special keys
0548               *---------------------------------------------------------------
0549               txt.enter
0550 7732 0565             byte  5
0551 7733 ....             text  'enter'
0552                       even
0553               
**** **** ****     > tivi_b1.asm.26425
0060                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0105 7738 0D00             data  key.enter, txt.enter, edkey.action.enter
     773A 7732 
     773C 6568 
0106 773E 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7740 755C 
     7742 615E 
0107 7744 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7746 74C6 
     7748 6174 
0108 774A 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     774C 74D0 
     774E 618C 
0109 7750 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7752 758E 
     7754 61DE 
0110 7756 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7758 7624 
     775A 624A 
0111 775C 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     775E 7656 
     7760 6262 
0112 7762 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7764 76D8 
     7766 6276 
0113 7768 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     776A 7642 
     776C 62C8 
0114 776E 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7770 764C 
     7772 6328 
0115 7774 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7776 770A 
     7778 636E 
0116 777A 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     777C 76E2 
     777E 639A 
0117 7780 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7782 762E 
     7784 63CA 
0118                       ;-------------------------------------------------------
0119                       ; Modifier keys - Delete
0120                       ;-------------------------------------------------------
0121 7786 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7788 744E 
     778A 640A 
0122 778C 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     778E 7688 
     7790 6442 
0123 7792 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7794 7462 
     7796 6476 
0124                       ;-------------------------------------------------------
0125                       ; Modifier keys - Insert
0126                       ;-------------------------------------------------------
0127 7798 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     779A 7458 
     779C 64CE 
0128 779E B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     77A0 75AC 
     77A2 65D6 
0129 77A4 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     77A6 7476 
     77A8 6524 
0130                       ;-------------------------------------------------------
0131                       ; Other action keys
0132                       ;-------------------------------------------------------
0133 77AA 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     77AC 75B6 
     77AE 6626 
0134 77B0 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     77B2 749E 
     77B4 6632 
0135 77B6 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     77B8 771E 
     77BA 6650 
0136                       ;-------------------------------------------------------
0137                       ; Editor/File buffer keys
0138                       ;-------------------------------------------------------
0139 77BC B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     77BE 75C0 
     77C0 6692 
0140 77C2 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     77C4 75CA 
     77C6 6698 
0141 77C8 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     77CA 75D4 
     77CC 669E 
0142 77CE B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     77D0 75DE 
     77D2 66A4 
0143 77D4 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     77D6 75E8 
     77D8 66AA 
0144 77DA B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     77DC 75F2 
     77DE 66B0 
0145 77E0 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     77E2 75FC 
     77E4 66B6 
0146 77E6 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     77E8 7606 
     77EA 66BC 
0147 77EC 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     77EE 7610 
     77F0 66C2 
0148 77F2 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     77F4 761A 
     77F6 66C8 
0149                       ;-------------------------------------------------------
0150                       ; End of list
0151                       ;-------------------------------------------------------
0152 77F8 FFFF             data  EOL                           ; EOL
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
0164 77FA 0D00             data  key.enter, txt.enter, edkey.action.enter
     77FC 7732 
     77FE 6568 
0165 7800 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7802 755C 
     7804 615E 
0166 7806 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7808 74C6 
     780A 6174 
0167 780C 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.noop
     780E 74D0 
     7810 662E 
0168 7812 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.noop
     7814 758E 
     7816 662E 
0169 7818 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.noop
     781A 7624 
     781C 662E 
0170 781E 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.noop
     7820 7656 
     7822 662E 
0171 7824 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.noop
     7826 76D8 
     7828 662E 
0172 782A 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.noop
     782C 7642 
     782E 662E 
0173 7830 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.noop
     7832 764C 
     7834 662E 
0174 7836 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.noop
     7838 770A 
     783A 662E 
0175 783C 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.noop
     783E 76E2 
     7840 662E 
0176 7842 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.noop
     7844 762E 
     7846 662E 
0177                       ;-------------------------------------------------------
0178                       ; Modifier keys - Delete
0179                       ;-------------------------------------------------------
0180 7848 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     784A 744E 
     784C 640A 
0181 784E 0000             data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
     7850 7688 
     7852 6442 
0182 7854 0700             data  key.fctn.3, txt.fctn.3, edkey.action.noop
     7856 7462 
     7858 662E 
0183                       ;-------------------------------------------------------
0184                       ; Modifier keys - Insert
0185                       ;-------------------------------------------------------
0186 785A 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     785C 7458 
     785E 64CE 
0187 7860 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7862 75AC 
     7864 65D6 
0188 7866 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.noop
     7868 7476 
     786A 662E 
0189                       ;-------------------------------------------------------
0190                       ; Other action keys
0191                       ;-------------------------------------------------------
0192 786C 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     786E 75B6 
     7870 6626 
0193 7872 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.toggle
     7874 749E 
     7876 6632 
0194 7878 9A00             data  key.ctrl.z, txt.ctrl.z, edkey.action.color.cycle
     787A 771E 
     787C 6650 
0195                       ;-------------------------------------------------------
0196                       ; Editor/File buffer keys
0197                       ;-------------------------------------------------------
0198 787E B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.buffer0
     7880 75C0 
     7882 6692 
0199 7884 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.buffer1
     7886 75CA 
     7888 6698 
0200 788A B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.buffer2
     788C 75D4 
     788E 669E 
0201 7890 B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.buffer3
     7892 75DE 
     7894 66A4 
0202 7896 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.buffer4
     7898 75E8 
     789A 66AA 
0203 789C B500             data  key.ctrl.5, txt.ctrl.5, edkey.action.buffer5
     789E 75F2 
     78A0 66B0 
0204 78A2 B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.buffer6
     78A4 75FC 
     78A6 66B6 
0205 78A8 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.buffer7
     78AA 7606 
     78AC 66BC 
0206 78AE 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.buffer8
     78B0 7610 
     78B2 66C2 
0207 78B4 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.buffer9
     78B6 761A 
     78B8 66C8 
0208                       ;-------------------------------------------------------
0209                       ; End of list
0210                       ;-------------------------------------------------------
0211 78BA FFFF             data  EOL                           ; EOL
**** **** ****     > tivi_b1.asm.26425
0061               
0065 78BC 78BC                   data $                ; Bank 1 ROM size OK.
0067               
0068               *--------------------------------------------------------------
0069               * Video mode configuration
0070               *--------------------------------------------------------------
0071      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0072      0004     spfbck  equ   >04                   ; Screen background color.
0073      21F6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0074      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0075      0050     colrow  equ   80                    ; Columns per row
0076      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0077      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0078      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0079      2000     sprsat  equ   >2000                 ; VDP sprite attribute table

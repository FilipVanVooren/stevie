XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.37551
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 200803-37551
0010               
0011                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.asm                 ; Version 200803-37551
0010               *--------------------------------------------------------------
0011               * stevie memory layout
0012               * See file "modules/mem.asm" for further details.
0013               *
0014               *
0015               * LOW MEMORY EXPANSION (2000-2fff)
0016               *
0017               * Mem range   Bytes    SAMS   Purpose
0018               * =========   =====    ====   ==================================
0019               * 2000-2fff    4096           SP2 library
0020               *
0021               * LOW MEMORY EXPANSION (3000-3fff)
0022               *
0023               * Mem range   Bytes    SAMS   Purpose
0024               * =========   =====    ====   ==================================
0025               * 3200-3fff    4096           Resident Stevie Modules
0026               *
0027               *
0028               * CARTRIDGE SPACE (6000-7fff)
0029               *
0030               * Mem range   Bytes    BANK   Purpose
0031               * =========   =====    ====   ==================================
0032               * 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
0033               * 6000-7fff    8192       1   Stevie program code
0034               *
0035               *
0036               * HIGH MEMORY EXPANSION (a000-ffff)
0037               *
0038               * Mem range   Bytes    SAMS   Purpose
0039               * =========   =====    ====   ==================================
0040               * a000-a0ff     256           Stevie Editor shared structure
0041               * a100-a1ff     256           Framebuffer structure
0042               * a200-a2ff     256           Editor buffer structure
0043               * a300-a3ff     256           Command buffer structure
0044               * a400-a4ff     256           File handle structure
0045               * a500-a5ff     256           Index structure
0046               * a600-af5f    2400           Frame buffer
0047               * af60-afff     ???           *FREE*
0048               *
0049               * b000-bfff    4096           Index buffer page
0050               * c000-cfff    4096           Editor buffer page
0051               * d000-dfff    4096           Command history buffer
0052               * e000-efff    4096           Heap
0053               * f000-f0ff     256           SP2/GPL scratchpad backup 1
0054               * f100-f1ff     256           SP2/GPL scratchpad backup 2
0055               * f200-ffff    3584           *FREE*
0056               *
0057               *
0058               * VDP RAM
0059               *
0060               * Mem range   Bytes    Hex    Purpose
0061               * =========   =====   =====   =================================
0062               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0063               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0064               * 0fc0                        PCT - Pattern Color Table
0065               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0066               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0067               * 2180                        SAT - Sprite Attribute List
0068               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0069               *--------------------------------------------------------------
0070               * Skip unused spectra2 code modules for reduced code size
0071               *--------------------------------------------------------------
0072      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0073      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0074      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0075      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0076      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0077      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0078      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0079      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0080      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0081      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0082      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0083      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0084      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0085      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0086      0001     skip_random_generator     equ  1       ; Skip random functions
0087      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0088               *--------------------------------------------------------------
0089               * Stevie specific equates
0090               *--------------------------------------------------------------
0091      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0092      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0093      0001     id.dialog.load            equ  1       ; ID for dialog "Load DV 80 file"
0094      0002     id.dialog.save            equ  2       ; ID for dialog "Save DV 80 file"
0095      0003     id.dialog.unsaved         equ  3       ; ID for dialog "Unsaved changes"
0096      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0097      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0098      0002     fh.fopmode.savefile       equ  2       ; Save file from memory to disk
0099               *--------------------------------------------------------------
0100               * SPECTRA2 / Stevie startup options
0101               *--------------------------------------------------------------
0102      0001     debug                     equ  1       ; Turn on spectra2 debugging
0103      0001     startup_backup_scrpad     equ  1       ; Backup scratchpad 8300-83ff to
0104                                                      ; memory address @cpu.scrpad.tgt
0105      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0106      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0107      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0108               *--------------------------------------------------------------
0109               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0110               *--------------------------------------------------------------
0111               ;                 equ  >8342           ; >8342-834F **free***
0112      8350     parm1             equ  >8350           ; Function parameter 1
0113      8352     parm2             equ  >8352           ; Function parameter 2
0114      8354     parm3             equ  >8354           ; Function parameter 3
0115      8356     parm4             equ  >8356           ; Function parameter 4
0116      8358     parm5             equ  >8358           ; Function parameter 5
0117      835A     parm6             equ  >835a           ; Function parameter 6
0118      835C     parm7             equ  >835c           ; Function parameter 7
0119      835E     parm8             equ  >835e           ; Function parameter 8
0120      8360     outparm1          equ  >8360           ; Function output parameter 1
0121      8362     outparm2          equ  >8362           ; Function output parameter 2
0122      8364     outparm3          equ  >8364           ; Function output parameter 3
0123      8366     outparm4          equ  >8366           ; Function output parameter 4
0124      8368     outparm5          equ  >8368           ; Function output parameter 5
0125      836A     outparm6          equ  >836a           ; Function output parameter 6
0126      836C     outparm7          equ  >836c           ; Function output parameter 7
0127      836E     outparm8          equ  >836e           ; Function output parameter 8
0128      8370     timers            equ  >8370           ; Timer table
0129      8380     ramsat            equ  >8380           ; Sprite Attribute Table in RAM
0130      8390     rambuf            equ  >8390           ; RAM workbuffer 1
0131               *--------------------------------------------------------------
0132               * Stevie Editor shared structures     @>a000-a0ff     (256 bytes)
0133               *--------------------------------------------------------------
0134      A000     tv.top            equ  >a000           ; Structure begin
0135      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0136      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0137      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0138      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0139      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0140      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0141      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0142      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0143      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0144      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0145      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0146      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0147      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0148      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0149      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0150      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0151      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0152      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0153               *--------------------------------------------------------------
0154               * Frame buffer structure            @>a100-a1ff     (256 bytes)
0155               *--------------------------------------------------------------
0156      A100     fb.struct         equ  >a100           ; Structure begin
0157      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0158      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0159      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0160                                                      ; line X in editor buffer).
0161      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0162                                                      ; (offset 0 .. @fb.scrrows)
0163      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0164      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0165      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0166      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0167      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0168      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0169      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0170      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0171      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0172      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0173      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0174               *--------------------------------------------------------------
0175               * Editor buffer structure           @>a200-a2ff     (256 bytes)
0176               *--------------------------------------------------------------
0177      A200     edb.struct        equ  >a200           ; Begin structure
0178      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0179      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0180      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0181      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0182      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0183      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0184      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0185      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0186                                                      ; with current filename.
0187      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0188                                                      ; with current file type.
0189      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0190      A214     edb.free          equ  edb.struct + 20 ; End of structure
0191               *--------------------------------------------------------------
0192               * Command buffer structure          @>a300-a3ff     (256 bytes)
0193               *--------------------------------------------------------------
0194      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0195      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0196      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0197      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0198      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0199      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0200      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0201      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0202      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0203      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0204      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0205      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0206      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0207      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0208      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0209      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0210      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0211      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0212      A322     cmdb.cmdlen       equ  cmdb.struct + 34; Length of current command (MSB byte!)
0213      A323     cmdb.cmd          equ  cmdb.struct + 35; Current command (80 bytes max.)
0214      A373     cmdb.free         equ  cmdb.struct +115; End of structure
0215               *--------------------------------------------------------------
0216               * File handle structure             @>a400-a4ff     (256 bytes)
0217               *--------------------------------------------------------------
0218      A400     fh.struct         equ  >a400           ; stevie file handling structures
0219      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0220      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0221      A428     file.pab.ptr      equ  fh.struct + 40  ; Pointer to VDP PAB, needed by lev 2 FIO
0222      A42A     fh.pabstat        equ  fh.struct + 42  ; Copy of VDP PAB status byte
0223      A42C     fh.ioresult       equ  fh.struct + 44  ; DSRLNK IO-status after file operation
0224      A42E     fh.records        equ  fh.struct + 46  ; File records counter
0225      A430     fh.reclen         equ  fh.struct + 48  ; Current record length
0226      A432     fh.kilobytes      equ  fh.struct + 50  ; Kilobytes processed (read/written)
0227      A434     fh.counter        equ  fh.struct + 52  ; Counter used in stevie file operations
0228      A436     fh.fname.ptr      equ  fh.struct + 54  ; Pointer to device and filename
0229      A438     fh.sams.page      equ  fh.struct + 56  ; Current SAMS page during file operation
0230      A43A     fh.sams.hipage    equ  fh.struct + 58  ; Highest SAMS page used for file oper.
0231      A43C     fh.fopmode        equ  fh.struct + 60  ; FOP (File Operation Mode)
0232      A43E     fh.callback1      equ  fh.struct + 62  ; Pointer to callback function 1
0233      A440     fh.callback2      equ  fh.struct + 64  ; Pointer to callback function 2
0234      A442     fh.callback3      equ  fh.struct + 66  ; Pointer to callback function 3
0235      A444     fh.callback4      equ  fh.struct + 68  ; Pointer to callback function 4
0236      A446     fh.kilobytes.prev equ  fh.struct + 70  ; Kilobytes process (previous)
0237      A448     fh.membuffer      equ  fh.struct + 72  ; 80 bytes file memory buffer
0238      A498     fh.free           equ  fh.struct +152  ; End of structure
0239      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0240      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0241               *--------------------------------------------------------------
0242               * Index structure                   @>a500-a5ff     (256 bytes)
0243               *--------------------------------------------------------------
0244      A500     idx.struct        equ  >a500           ; stevie index structure
0245      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0246      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0247      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0248               *--------------------------------------------------------------
0249               * Frame buffer                      @>a600-afff    (2560 bytes)
0250               *--------------------------------------------------------------
0251      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0252      0960     fb.size           equ  80*30           ; Frame buffer size
0253               *--------------------------------------------------------------
0254               * Index                             @>b000-bfff    (4096 bytes)
0255               *--------------------------------------------------------------
0256      B000     idx.top           equ  >b000           ; Top of index
0257      1000     idx.size          equ  4096            ; Index size
0258               *--------------------------------------------------------------
0259               * Editor buffer                     @>c000-cfff    (4096 bytes)
0260               *--------------------------------------------------------------
0261      C000     edb.top           equ  >c000           ; Editor buffer high memory
0262      1000     edb.size          equ  4096            ; Editor buffer size
0263               *--------------------------------------------------------------
0264               * Command history buffer            @>d000-dfff    (4096 bytes)
0265               *--------------------------------------------------------------
0266      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0267      1000     cmdb.size         equ  4096            ; Command buffer size
0268               *--------------------------------------------------------------
0269               * Heap                              @>e000-efff    (4096 bytes)
0270               *--------------------------------------------------------------
0271      E000     heap.top          equ  >e000           ; Top of heap
0272               *--------------------------------------------------------------
0273               * Scratchpad backup 1               @>f000-f0ff     (256 bytes)
0274               * Scratchpad backup 2               @>f100-f1ff     (256 bytes)
0275               *--------------------------------------------------------------
0276      F000     cpu.scrpad.tgt    equ  >f000           ; Destination cpu.scrpad.backup/restore
0277      F000     scrpad.backup1    equ  >f000           ; Backup GPL layout
0278      F100     scrpad.backup2    equ  >f100           ; Backup spectra2 layout
**** **** ****     > stevie_b1.asm.37551
0012               
0013               ***************************************************************
0014               * BANK 1 - Stevie main editor modules
0015               ********|*****|*********************|**************************
0016                       aorg  >6000
0017                       save  >6000,>7fff           ; Save bank 1
0018               *--------------------------------------------------------------
0019               * Cartridge header
0020               ********|*****|*********************|**************************
0021 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0022 6006 6010             data  $+10
0023 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0024 6010 0000             data  0                     ; No more items following
0025 6012 6030             data  kickstart.code1
0026               
0028               
0029 6014 1353             byte  19
0030 6015 ....             text  'STEVIE 200803-37551'
0031                       even
0032               
0040               
0041               *--------------------------------------------------------------
0042               * Step 1: Switch to bank 0 (uniform code accross all banks)
0043               ********|*****|*********************|**************************
0044                       aorg  kickstart.code1       ; >6030
0045 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
0046               
0047               *--------------------------------------------------------------
0048               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0049               ********|*****|*********************|**************************
0050                       aorg  >2000
0051                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     208E 2DF2 
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
     2180 2CEC 
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
0259 21DA 1642             byte  22
0260 21DB ....             text  'Build-ID  200803-37551'
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
     2ACE F000 
0023 2AD0 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2AD2 F002 
0024 2AD4 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2AD6 F004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 2AD8 0200  20         li    r0,>8306              ; Scratpad source address
     2ADA 8306 
0029 2ADC 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2ADE F006 
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
     2AF0 F0FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 2AF2 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2AF4 F000 
0045 2AF6 C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2AF8 F002 
0046 2AFA C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2AFC F004 
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
     2B02 F000 
     2B04 8300 
0071 2B06 C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     2B08 F002 
     2B0A 8302 
0072 2B0C C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     2B0E F004 
     2B10 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 2B12 C800  38         mov   r0,@cpu.scrpad.tgt
     2B14 F000 
0077 2B16 C801  38         mov   r1,@cpu.scrpad.tgt + 2
     2B18 F002 
0078 2B1A C802  38         mov   r2,@cpu.scrpad.tgt + 4
     2B1C F004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 2B1E 0200  20         li    r0,cpu.scrpad.tgt + 6
     2B20 F006 
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
     2B34 F0FE 
     2B36 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 2B38 C020  34         mov   @cpu.scrpad.tgt,r0
     2B3A F000 
0099 2B3C C060  34         mov   @cpu.scrpad.tgt + 2,r1
     2B3E F002 
0100 2B40 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     2B42 F004 
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
0029               *       data P0
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
0048 2C96 04C5  14         clr   tmp1                  ; io.op.open
0049 2C98 1012  14         jmp   _file.record.fop      ; Do file operation
0050               
0051               
0052               
0053               ***************************************************************
0054               * file.close - Close currently open file
0055               ***************************************************************
0056               *  bl   @file.close
0057               *       data P0
0058               *--------------------------------------------------------------
0059               *  P0 = Address of PAB in VDP RAM
0060               *--------------------------------------------------------------
0061               *  bl   @xfile.close
0062               *
0063               *  R0 = Address of PAB in VDP RAM
0064               *--------------------------------------------------------------
0065               *  Output:
0066               *  tmp0 LSB = VDP PAB byte 1 (status)
0067               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0068               *  tmp2     = Status register contents upon DSRLNK return
0069               ********|*****|*********************|**************************
0070               file.close:
0071 2C9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0072               *--------------------------------------------------------------
0073               * Initialisation
0074               *--------------------------------------------------------------
0075               xfile.close:
0076 2C9C 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C9E 0001 
0077 2CA0 100E  14         jmp   _file.record.fop      ; Do file operation
0078               
0079               
0080               ***************************************************************
0081               * file.record.read - Read record from file
0082               ***************************************************************
0083               *  bl   @file.record.read
0084               *       data P0
0085               *--------------------------------------------------------------
0086               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0087               *--------------------------------------------------------------
0088               *  bl   @xfile.record.read
0089               *
0090               *  R0 = Address of PAB in VDP RAM
0091               *--------------------------------------------------------------
0092               *  Output:
0093               *  tmp0 LSB = VDP PAB byte 1 (status)
0094               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0095               *  tmp2     = Status register contents upon DSRLNK return
0096               ********|*****|*********************|**************************
0097               file.record.read:
0098 2CA2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0099               *--------------------------------------------------------------
0100               * Initialisation
0101               *--------------------------------------------------------------
0102 2CA4 0205  20         li    tmp1,io.op.read       ; io.op.read
     2CA6 0002 
0103 2CA8 100A  14         jmp   _file.record.fop      ; Do file operation
0104               
0105               
0106               
0107               ***************************************************************
0108               * file.record.write - Write record to file
0109               ***************************************************************
0110               *  bl   @file.record.write
0111               *       data P0
0112               *--------------------------------------------------------------
0113               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0114               *--------------------------------------------------------------
0115               *  bl   @xfile.record.read
0116               *
0117               *  R0 = Address of PAB in VDP RAM
0118               *--------------------------------------------------------------
0119               *  Output:
0120               *  tmp0 LSB = VDP PAB byte 1 (status)
0121               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0122               *  tmp2     = Status register contents upon DSRLNK return
0123               ********|*****|*********************|**************************
0124               file.record.write:
0125 2CAA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0126               *--------------------------------------------------------------
0127               * Initialisation
0128               *--------------------------------------------------------------
0129 2CAC 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CAE 0003 
0130 2CB0 1006  14         jmp   _file.record.fop      ; Do file operation
0131               
0132               
0133               
0134               file.record.seek:
0135 2CB2 1000  14         nop
0136               
0137               
0138               file.image.load:
0139 2CB4 1000  14         nop
0140               
0141               
0142               file.image.save:
0143 2CB6 1000  14         nop
0144               
0145               
0146               file.delete:
0147 2CB8 1000  14         nop
0148               
0149               
0150               file.rename:
0151 2CBA 1000  14         nop
0152               
0153               
0154               file.status:
0155 2CBC 1000  14         nop
0156               
0157               
0158               
0159               ***************************************************************
0160               * file.record.fop - File operation
0161               ***************************************************************
0162               * Called internally via JMP/B by file operations
0163               *--------------------------------------------------------------
0164               *  Input:
0165               *  r0   = Address of PAB in VDP RAM
0166               *  tmp1 = File operation opcode
0167               *--------------------------------------------------------------
0168               *  Register usage:
0169               *  r0, r1, tmp0, tmp1, tmp2
0170               *--------------------------------------------------------------
0171               *  Remarks
0172               *  Private, only to be called from inside fio_level2 module
0173               *  via jump or branch instruction
0174               ********|*****|*********************|**************************
0175               _file.record.fop:
0176 2CBE C04B  18         mov   r11,r1                ; Save return address
0177 2CC0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     2CC2 A428 
0178 2CC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0179               
0180 2CC6 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     2CC8 22C6 
0181                                                   ; \ i  tmp0 = VDP target address
0182                                                   ; / i  tmp1 = Byte to write
0183               
0184 2CCA 0220  22         ai    r0,9                  ; Move to file descriptor length
     2CCC 0009 
0185 2CCE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CD0 8356 
0186               *--------------------------------------------------------------
0187               * Call DSRLINK for doing file operation
0188               *--------------------------------------------------------------
0189 2CD2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CD4 2B7E 
0190 2CD6 0008             data  8                     ;
0191               *--------------------------------------------------------------
0192               * Return PAB details to caller
0193               *--------------------------------------------------------------
0194               _file.record.fop.pab:
0195 2CD8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0196                                                   ; Upon DSRLNK return status register EQ bit
0197                                                   ; 1 = No file error
0198                                                   ; 0 = File error occured
0199               *--------------------------------------------------------------
0200               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0201               *--------------------------------------------------------------
0202 2CDA C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     2CDC A428 
0203 2CDE 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2CE0 0005 
0204 2CE2 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2CE4 22DE 
0205 2CE6 C144  18         mov   tmp0,tmp1             ; Move to destination
0206               *--------------------------------------------------------------
0207               * Get PAB byte 1 from VDP ram into tmp0 (status)
0208               *--------------------------------------------------------------
0209 2CE8 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0210                                                   ; as returned by DSRLNK
0211               *--------------------------------------------------------------
0212               * Exit
0213               *--------------------------------------------------------------
0214               ; If an error occured during the IO operation, then the
0215               ; equal bit in the saved status register (=tmp2) is set to 1.
0216               ;
0217               ; Upon return from this IO call you should basically test with:
0218               ;       coc   @wbit2,tmp2           ; Equal bit set?
0219               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0220               ;
0221               ; Then look for further details in the copy of VDP PAB byte 1
0222               ; in register tmp0, bits 13-15
0223               ;
0224               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0225               ;                                   ; calls, skip for type >A subprograms!)
0226               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0227               ;       jeq   my_error_handler
0228               *--------------------------------------------------------------
0229               _file.record.fop.exit:
0230 2CEA 0451  20         b     *r1                   ; Return to caller
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
0020 2CEC 0300  24 tmgr    limi  0                     ; No interrupt processing
     2CEE 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2CF0 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2CF2 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2CF4 2360  38         coc   @wbit2,r13            ; C flag on ?
     2CF6 2026 
0029 2CF8 1602  14         jne   tmgr1a                ; No, so move on
0030 2CFA E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2CFC 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2CFE 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D00 202A 
0035 2D02 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D04 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D06 201A 
0048 2D08 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D0A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D0C 2018 
0050 2D0E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D10 0460  28         b     @kthread              ; Run kernel thread
     2D12 2D8A 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D14 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D16 201E 
0056 2D18 13EB  14         jeq   tmgr1
0057 2D1A 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D1C 201C 
0058 2D1E 16E8  14         jne   tmgr1
0059 2D20 C120  34         mov   @wtiusr,tmp0
     2D22 832E 
0060 2D24 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D26 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D28 2D88 
0065 2D2A C10A  18         mov   r10,tmp0
0066 2D2C 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D2E 00FF 
0067 2D30 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D32 2026 
0068 2D34 1303  14         jeq   tmgr5
0069 2D36 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D38 003C 
0070 2D3A 1002  14         jmp   tmgr6
0071 2D3C 0284  22 tmgr5   ci    tmp0,50
     2D3E 0032 
0072 2D40 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D42 1001  14         jmp   tmgr8
0074 2D44 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D46 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D48 832C 
0079 2D4A 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D4C FF00 
0080 2D4E C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D50 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D52 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D54 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D56 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D58 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D5A 830C 
     2D5C 830D 
0089 2D5E 1608  14         jne   tmgr10                ; No, get next slot
0090 2D60 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D62 FF00 
0091 2D64 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D66 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D68 8330 
0096 2D6A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D6C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D6E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D70 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D72 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D74 8315 
     2D76 8314 
0103 2D78 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D7A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D7C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D7E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D80 10F7  14         jmp   tmgr10                ; Process next slot
0108 2D82 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2D84 FF00 
0109 2D86 10B4  14         jmp   tmgr1
0110 2D88 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2D8A E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2D8C 201A 
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
0041 2D8E 06A0  32         bl    @realkb               ; Scan full keyboard
     2D90 279C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2D92 0460  28         b     @tmgr3                ; Exit
     2D94 2D14 
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
0017 2D96 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2D98 832E 
0018 2D9A E0A0  34         soc   @wbit7,config         ; Enable user hook
     2D9C 201C 
0019 2D9E 045B  20 mkhoo1  b     *r11                  ; Return
0020      2CF0     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DA0 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DA2 832E 
0029 2DA4 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DA6 FEFF 
0030 2DA8 045B  20         b     *r11                  ; Return
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
0017 2DAA C13B  30 mkslot  mov   *r11+,tmp0
0018 2DAC C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DAE C184  18         mov   tmp0,tmp2
0023 2DB0 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DB2 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DB4 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DB6 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DB8 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DBA C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DBC 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DBE 202C 
0035 2DC0 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DC2 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DC4 05CB  14 mkslo1  inct  r11
0041 2DC6 045B  20         b     *r11                  ; Exit
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
0052 2DC8 C13B  30 clslot  mov   *r11+,tmp0
0053 2DCA 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DCC A120  34         a     @wtitab,tmp0          ; Add table base
     2DCE 832C 
0055 2DD0 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DD2 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DD4 045B  20         b     *r11                  ; Exit
0058               
0059               
0060               ***************************************************************
0061               * RSSLOT - Reset single timer slot loop counter
0062               ***************************************************************
0063               *  BL    @RSSLOT
0064               *  DATA  P0
0065               *--------------------------------------------------------------
0066               *  P0 = Slot number
0067               ********|*****|*********************|**************************
0068 2DD6 C13B  30 rsslot  mov   *r11+,tmp0
0069 2DD8 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2DDA A120  34         a     @wtitab,tmp0          ; Add table base
     2DDC 832C 
0071 2DDE 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2DE0 C154  26         mov   *tmp0,tmp1
0073 2DE2 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2DE4 FF00 
0074 2DE6 C505  30         mov   tmp1,*tmp0
0075 2DE8 045B  20         b     *r11                  ; Exit
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
0255 2DEA 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     2DEC 2ACC 
0256                                                   ; @cpu.scrpad.tgt (>00..>ff)
0257               
0258 2DEE 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2DF0 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2DF2 0300  24 runli1  limi  0                     ; Turn off interrupts
     2DF4 0000 
0266 2DF6 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2DF8 8300 
0267 2DFA C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2DFC 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2DFE 0202  20 runli2  li    r2,>8308
     2E00 8308 
0272 2E02 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E04 0282  22         ci    r2,>8400
     2E06 8400 
0274 2E08 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E0A 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E0C FFFF 
0279 2E0E 1602  14         jne   runli4                ; No, continue
0280 2E10 0420  54         blwp  @0                    ; Yes, bye bye
     2E12 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E14 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E16 833C 
0285 2E18 04C1  14         clr   r1                    ; Reset counter
0286 2E1A 0202  20         li    r2,10                 ; We test 10 times
     2E1C 000A 
0287 2E1E C0E0  34 runli5  mov   @vdps,r3
     2E20 8802 
0288 2E22 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E24 202A 
0289 2E26 1302  14         jeq   runli6
0290 2E28 0581  14         inc   r1                    ; Increase counter
0291 2E2A 10F9  14         jmp   runli5
0292 2E2C 0602  14 runli6  dec   r2                    ; Next test
0293 2E2E 16F7  14         jne   runli5
0294 2E30 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E32 1250 
0295 2E34 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E36 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E38 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E3A 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     2E3C 221A 
0301 2E3E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2E40 8322 
0302 2E42 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0303 2E44 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0304 2E46 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0305               *--------------------------------------------------------------
0306               * Initialize registers, memory, ...
0307               *--------------------------------------------------------------
0308 2E48 04C1  14 runli9  clr   r1
0309 2E4A 04C2  14         clr   r2
0310 2E4C 04C3  14         clr   r3
0311 2E4E 0209  20         li    stack,>8400           ; Set stack
     2E50 8400 
0312 2E52 020F  20         li    r15,vdpw              ; Set VDP write address
     2E54 8C00 
0316               *--------------------------------------------------------------
0317               * Setup video memory
0318               *--------------------------------------------------------------
0320 2E56 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E58 4A4A 
0321 2E5A 1605  14         jne   runlia
0322 2E5C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E5E 2288 
0323 2E60 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     2E62 0000 
     2E64 3FFF 
0328 2E66 06A0  32 runlia  bl    @filv
     2E68 2288 
0329 2E6A 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E6C 00F4 
     2E6E 0010 
0330               *--------------------------------------------------------------
0331               * Check if there is a F18A present
0332               *--------------------------------------------------------------
0336 2E70 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E72 26E4 
0337 2E74 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E76 26FE 
0338 2E78 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E7A 26F4 
0339               
0340 2E7C 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E7E 232C 
0341 2E80 3201                   data >3201            ; F18a VR50 (>32), bit 1
0343               *--------------------------------------------------------------
0344               * Check if there is a speech synthesizer attached
0345               *--------------------------------------------------------------
0347               *       <<skipped>>
0351               *--------------------------------------------------------------
0352               * Load video mode table & font
0353               *--------------------------------------------------------------
0354 2E82 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E84 22F2 
0355 2E86 3008             data  spvmod                ; Equate selected video mode table
0356 2E88 0204  20         li    tmp0,spfont           ; Get font option
     2E8A 000C 
0357 2E8C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0358 2E8E 1304  14         jeq   runlid                ; Yes, skip it
0359 2E90 06A0  32         bl    @ldfnt
     2E92 235A 
0360 2E94 1100             data  fntadr,spfont         ; Load specified font
     2E96 000C 
0361               *--------------------------------------------------------------
0362               * Did a system crash occur before runlib was called?
0363               *--------------------------------------------------------------
0364 2E98 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2E9A 4A4A 
0365 2E9C 1602  14         jne   runlie                ; No, continue
0366 2E9E 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EA0 2090 
0367               *--------------------------------------------------------------
0368               * Branch to main program
0369               *--------------------------------------------------------------
0370 2EA2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EA4 0040 
0371 2EA6 0460  28         b     @main                 ; Give control to main program
     2EA8 6036 
**** **** ****     > stevie_b1.asm.37551
0052                                                   ; Relocated spectra2 in low MEMEXP, was
0053                                                   ; copied to >2000 from ROM in bank 0
0054                       ;------------------------------------------------------
0055                       ; End of File marker
0056                       ;------------------------------------------------------
0057 2EAA DEAD             data >dead,>beef,>dead,>beef
     2EAC BEEF 
     2EAE DEAD 
     2EB0 BEEF 
0059               
0060               *--------------------------------------------------------------
0061               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0062               ********|*****|*********************|**************************
0063                       aorg  >3000
0064                       ;------------------------------------------------------
0065                       ; Activate bank 1
0066                       ;------------------------------------------------------
0067 3000 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
     3002 6002 
0068 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0069                       ;------------------------------------------------------
0070                       ; Resident Stevie modules >3000 - >3fff
0071                       ;------------------------------------------------------
0072                       copy  "data.constants.asm"  ; Data Constants
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
0033 3008 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     300A 003F 
     300C 0243 
     300E 05F4 
     3010 0050 
0034               
0035               romsat:
0036 3012 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     3014 0001 
0037               
0038               cursors:
0039 3016 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     3018 0000 
     301A 0000 
     301C 001C 
0040 301E 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 2 - Insert mode
     3020 1C1C 
     3022 1C1C 
     3024 1C00 
0041 3026 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     3028 1C1C 
     302A 1C1C 
     302C 1C00 
0042               
0043               patterns:
0044 302E 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     3030 0000 
     3032 00FF 
     3034 0000 
0045 3036 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     3038 0000 
     303A FF00 
     303C FF00 
0046               patterns.box:
0047 303E 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     3040 0000 
     3042 FF00 
     3044 FF00 
0048 3046 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     3048 0000 
     304A FF80 
     304C BFA0 
0049 304E 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     3050 0000 
     3052 FC04 
     3054 F414 
0050 3056 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     3058 A0A0 
     305A A0A0 
     305C A0A0 
0051 305E 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     3060 1414 
     3062 1414 
     3064 1414 
0052 3066 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     3068 A0A0 
     306A BF80 
     306C FF00 
0053 306E 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     3070 1414 
     3072 F404 
     3074 FC00 
0054 3076 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     3078 C0C0 
     307A C0C0 
     307C 0080 
0055 307E 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     3080 0F0F 
     3082 0F0F 
     3084 0000 
0056               
0057               
0058               
0059               
0060               ***************************************************************
0061               * SAMS page layout table for Stevie (16 words)
0062               *--------------------------------------------------------------
0063               mem.sams.layout.data:
0064 3086 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     3088 0002 
0065 308A 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     308C 0003 
0066 308E A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3090 000A 
0067               
0068 3092 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     3094 0010 
0069                                                   ; \ The index can allocate
0070                                                   ; / pages >10 to >2f.
0071               
0072 3096 C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     3098 0030 
0073                                                   ; \ Editor buffer can allocate
0074                                                   ; / pages >30 to >ff.
0075               
0076 309A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     309C 000D 
0077 309E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     30A0 000E 
0078 30A2 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     30A4 000F 
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
0104 30A6 F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     30A8 F001 
0105 30AA F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     30AC F00F 
0106 30AE A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     30B0 F00F 
0107 30B2 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     30B4 F00F 
0108 30B6 E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     30B8 F00F 
0109 30BA 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     30BC 1006 
0110 30BE 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     30C0 1001 
0111 30C2 A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     30C4 1A0F 
0112 30C6 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     30C8 F20F 
0113               
**** **** ****     > stevie_b1.asm.37551
0073                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 30CA 012C             byte  1
0013 30CB ....             text  ','
0014                       even
0015               
0016               txt.marker
0017 30CC 052A             byte  5
0018 30CD ....             text  '*EOF*'
0019                       even
0020               
0021               txt.bottom
0022 30D2 0520             byte  5
0023 30D3 ....             text  '  BOT'
0024                       even
0025               
0026               txt.ovrwrite
0027 30D8 034F             byte  3
0028 30D9 ....             text  'OVR'
0029                       even
0030               
0031               txt.insert
0032 30DC 0349             byte  3
0033 30DD ....             text  'INS'
0034                       even
0035               
0036               txt.star
0037 30E0 012A             byte  1
0038 30E1 ....             text  '*'
0039                       even
0040               
0041               txt.loading
0042 30E2 0A4C             byte  10
0043 30E3 ....             text  'Loading...'
0044                       even
0045               
0046               txt.saving
0047 30EE 0953             byte  9
0048 30EF ....             text  'Saving...'
0049                       even
0050               
0051               txt.kb
0052 30F8 026B             byte  2
0053 30F9 ....             text  'kb'
0054                       even
0055               
0056               txt.lines
0057 30FC 054C             byte  5
0058 30FD ....             text  'Lines'
0059                       even
0060               
0061               txt.bufnum
0062 3102 0323             byte  3
0063 3103 ....             text  '#1 '
0064                       even
0065               
0066               txt.newfile
0067 3106 0A5B             byte  10
0068 3107 ....             text  '[New file]'
0069                       even
0070               
0071               txt.filetype.dv80
0072 3112 0444             byte  4
0073 3113 ....             text  'DV80'
0074                       even
0075               
0076               txt.filetype.none
0077 3118 0420             byte  4
0078 3119 ....             text  '    '
0079                       even
0080               
0081               
0082               
0083               ;--------------------------------------------------------------
0084               ; Dialog Load DV 80 file
0085               ;--------------------------------------------------------------
0086               txt.head.load
0087 311E 0E4C             byte  14
0088 311F ....             text  'Load DV80 file'
0089                       even
0090               
0091               txt.hint.load
0092 312E 3448             byte  52
0093 312F ....             text  'HINT: Specify filename and press ENTER to load file.'
0094                       even
0095               
0096               txt.keys.load
0097 3164 4246             byte  66
0098 3165 ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End    ^,=Previous    ^.=Next'
0099                       even
0100               
0101               
0102               ;--------------------------------------------------------------
0103               ; Dialog Save DV 80 file
0104               ;--------------------------------------------------------------
0105               txt.head.save
0106 31A8 0E53             byte  14
0107 31A9 ....             text  'Save DV80 file'
0108                       even
0109               
0110               txt.hint.save
0111 31B8 3448             byte  52
0112 31B9 ....             text  'HINT: Specify filename and press ENTER to save file.'
0113                       even
0114               
0115               txt.keys.save
0116 31EE 2846             byte  40
0117 31EF ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0118                       even
0119               
0120               
0121               ;--------------------------------------------------------------
0122               ; Dialog "Unsaved changes"
0123               ;--------------------------------------------------------------
0124               txt.head.unsaved
0125 3218 0F55             byte  15
0126 3219 ....             text  'Unsaved changes'
0127                       even
0128               
0129               txt.hint.unsaved
0130 3228 2748             byte  39
0131 3229 ....             text  'HINT: Unsaved changes in editor buffer.'
0132                       even
0133               
0134               txt.keys.unsaved
0135 3250 2B46             byte  43
0136 3251 ....             text  'F9=Back    F6=Proceed anyway   ^K=Save file'
0137                       even
0138               
0139               
0140               
0141               
0142               ;--------------------------------------------------------------
0143               ; Strings for error line pane
0144               ;--------------------------------------------------------------
0145               txt.ioerr
0146 327C 2049             byte  32
0147 327D ....             text  'I/O error. Failed loading file: '
0148                       even
0149               
0150               txt.io.nofile
0151 329E 2149             byte  33
0152 329F ....             text  'I/O error. No filename specified.'
0153                       even
0154               
0155               
0156               
0157               ;--------------------------------------------------------------
0158               ; Strings for command buffer
0159               ;--------------------------------------------------------------
0160               txt.cmdb.title
0161 32C0 0E43             byte  14
0162 32C1 ....             text  'Command buffer'
0163                       even
0164               
0165               txt.cmdb.prompt
0166 32D0 013E             byte  1
0167 32D1 ....             text  '>'
0168                       even
0169               
0170               
0171 32D2 4201     txt.cmdb.hbar      byte    66
0172 32D4 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     32D6 0101 
     32D8 0101 
     32DA 0101 
     32DC 0101 
     32DE 0101 
     32E0 0101 
     32E2 0101 
     32E4 0101 
     32E6 0101 
0173 32E8 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     32EA 0101 
     32EC 0101 
     32EE 0101 
     32F0 0101 
     32F2 0101 
     32F4 0101 
     32F6 0101 
     32F8 0101 
     32FA 0101 
0174 32FC 0101                        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     32FE 0101 
     3300 0101 
     3302 0101 
     3304 0101 
     3306 0101 
     3308 0101 
     330A 0101 
     330C 0101 
     330E 0101 
0175 3310 0101                        byte    1,1,1,1,1,1
     3312 0101 
     3314 0100 
0176                                  even
0177               
0178               
0179               
0180 3316 0C0A     txt.stevie         byte    12
0181                                  byte    10
0182 3318 ....                        text    'stevie v1.00'
0183 3324 0B00                        byte    11
0184                                  even
0185               
0186               txt.colorscheme
0187 3326 0E43             byte  14
0188 3327 ....             text  'COLOR SCHEME: '
0189                       even
0190               
0191               
0192               
0193               ;--------------------------------------------------------------
0194               ; Strings for filenames
0195               ;--------------------------------------------------------------
0196               fdname1
0197 3336 0850             byte  8
0198 3337 ....             text  'PI.CLOCK'
0199                       even
0200               
0201               fdname2
0202 3340 0E54             byte  14
0203 3341 ....             text  'TIPI.TIVI.NR80'
0204                       even
0205               
0206               fdname3
0207 3350 0C44             byte  12
0208 3351 ....             text  'DSK1.XBEADOC'
0209                       even
0210               
0211               fdname4
0212 335E 1154             byte  17
0213 335F ....             text  'TIPI.TIVI.C99MAN1'
0214                       even
0215               
0216               fdname5
0217 3370 1154             byte  17
0218 3371 ....             text  'TIPI.TIVI.C99MAN2'
0219                       even
0220               
0221               fdname6
0222 3382 1154             byte  17
0223 3383 ....             text  'TIPI.TIVI.C99MAN3'
0224                       even
0225               
0226               fdname7
0227 3394 1254             byte  18
0228 3395 ....             text  'TIPI.TIVI.C99SPECS'
0229                       even
0230               
0231               fdname8
0232 33A8 1254             byte  18
0233 33A9 ....             text  'TIPI.TIVI.RANDOM#C'
0234                       even
0235               
0236               fdname9
0237 33BC 0D44             byte  13
0238 33BD ....             text  'DSK1.INVADERS'
0239                       even
0240               
0241               fdname0
0242 33CA 0944             byte  9
0243 33CB ....             text  'DSK1.NR80'
0244                       even
0245               
0246               fdname.clock
0247 33D4 0850             byte  8
0248 33D5 ....             text  'PI.CLOCK'
0249                       even
0250               
**** **** ****     > stevie_b1.asm.37551
0074                       ;------------------------------------------------------
0075                       ; End of File marker
0076                       ;------------------------------------------------------
0077 33DE DEAD             data  >dead,>beef,>dead,>beef
     33E0 BEEF 
     33E2 DEAD 
     33E4 BEEF 
0079               
0080               ***************************************************************
0081               * Step 4: Include main editor modules
0082               ********|*****|*********************|**************************
0083               main:
0084                       aorg  kickstart.code2       ; >6036
0085 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0086                       ;-----------------------------------------------------------------------
0087                       ; Include files
0088                       ;-----------------------------------------------------------------------
0089                       copy  "main.asm"            ; Main file (entrypoint)
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
0033 603A 20A0  38         coc   @wbit1,config         ; F18a detected?
     603C 2028 
0034 603E 1302  14         jeq   main.continue
0035 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0036               
0037               main.continue:
0038                       ;------------------------------------------------------
0039                       ; Setup F18A VDP
0040                       ;------------------------------------------------------
0041 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 2640 
0042               
0043 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 26E4 
0044 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 232C 
0045 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 232C 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 232C 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 2288 
0056 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6068 06A0  32         bl    @film
     606A 2230 
0061 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0062                       ;------------------------------------------------------
0063                       ; Setup SAMS windows
0064                       ;------------------------------------------------------
0065 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 67CE 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2660 
0070 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2670 
0071               
0072 607E 06A0  32         bl    @cpym2m
     6080 248C 
0073 6082 3012                   data romsat,ramsat,4  ; Load sprite SAT
     6084 8380 
     6086 0004 
0074               
0075 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3014 
     608C A014 
0076                                                   ; Save cursor shape & color
0077               
0078 608E 06A0  32         bl    @cpym2v
     6090 2444 
0079 6092 2800                   data sprpdt,cursors,3*8
     6094 3016 
     6096 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 6098 06A0  32         bl    @cpym2v
     609A 2444 
0083 609C 1008                   data >1008,patterns,11*8
     609E 302E 
     60A0 0058 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 679C 
0089 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 67B2 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 776E 
0094                                                   ; Load color scheme and turn on screen
0095                       ;-------------------------------------------------------
0096                       ; Setup editor tasks & hook
0097                       ;-------------------------------------------------------
0098 60AE 0204  20         li    tmp0,>0300
     60B0 0300 
0099 60B2 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B4 8314 
0100               
0101 60B6 06A0  32         bl    @at
     60B8 2680 
0102 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60BC 0204  20         li    tmp0,timers
     60BE 8370 
0105 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0106               
0107 60C4 06A0  32         bl    @mkslot
     60C6 2DAA 
0108 60C8 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 7556 
0109 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 75EE 
0110 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 7622 
0111 60D4 032F                   data >032f,task.oneshot      ; Task 3 - One shot task
     60D6 7670 
0112 60D8 FFFF                   data eol
0113               
0114 60DA 06A0  32         bl    @mkhook
     60DC 2D96 
0115 60DE 7526                   data hook.keyscan     ; Setup user hook
0116               
0117 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2CEC 
**** **** ****     > stevie_b1.asm.37551
0090               
0091                       ;-----------------------------------------------------------------------
0092                       ; Keyboard actions
0093                       ;-----------------------------------------------------------------------
0094                       copy  "edkey.asm"           ; Keyboard actions
**** **** ****     > edkey.asm
0001               * FILE......: edkey.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 60E4 C160  34         mov   @waux1,tmp1           ; Get key value
     60E6 833C 
0010 60E8 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     60EA FF00 
0011 60EC 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 60EE C1A0  34         mov   @tv.pane.focus,tmp2
     60F0 A01A 
0016 60F2 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60F4 0000 
0017 60F6 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 60F8 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60FA 0001 
0021 60FC 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 60FE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6100 FFCE 
0027 6102 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6104 2030 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 6106 0206  20         li    tmp2,keymap_actions.editor
     6108 7E3E 
0033 610A 1003  14         jmp   edkey.key.check_next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7F0C 
0039 6110 1600  14         jne   edkey.key.check_next
0040                       ;-------------------------------------------------------
0041                       ; Iterate over keyboard map for matching action key
0042                       ;-------------------------------------------------------
0043               edkey.key.check_next:
0044 6112 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0045 6114 1309  14         jeq   edkey.key.process.addbuffer
0046                                                   ; Yes, means no action key pressed, so
0047                                                   ; add character to buffer
0048                       ;-------------------------------------------------------
0049                       ; Check for action key match
0050                       ;-------------------------------------------------------
0051 6116 8585  30         c     tmp1,*tmp2            ; Action key matched?
0052 6118 1303  14         jeq   edkey.key.process.action
0053                                                   ; Yes, do action
0054 611A 0226  22         ai    tmp2,6                ; Skip current entry
     611C 0006 
0055 611E 10F9  14         jmp   edkey.key.check_next  ; Check next entry
0056                       ;-------------------------------------------------------
0057                       ; Trigger keyboard action
0058                       ;-------------------------------------------------------
0059               edkey.key.process.action:
0060 6120 0226  22         ai    tmp2,4                ; Move to action address
     6122 0004 
0061 6124 C196  26         mov   *tmp2,tmp2            ; Get action address
0062 6126 0456  20         b     *tmp2                 ; Process key action
0063                       ;-------------------------------------------------------
0064                       ; Add character to appropriate buffer
0065                       ;-------------------------------------------------------
0066               edkey.key.process.addbuffer:
0067 6128 C120  34         mov  @tv.pane.focus,tmp0    ; Frame buffer has focus?
     612A A01A 
0068 612C 1602  14         jne  !                      ; No, skip frame buffer
0069 612E 0460  28         b    @edkey.action.char     ; Add character to frame buffer
     6130 65C4 
0070                       ;-------------------------------------------------------
0071                       ; CMDB buffer
0072                       ;-------------------------------------------------------
0073 6132 0284  22 !       ci   tmp0,pane.focus.cmdb   ; CMDB has focus ?
     6134 0001 
0074 6136 1602  14         jne  edkey.key.process.crash
0075                                                   ; No, crash
0076 6138 0460  28         b    @edkey.action.cmdb.char
     613A 66F6 
0077                                                   ; Add character to CMDB buffer
0078                       ;-------------------------------------------------------
0079                       ; Crash
0080                       ;-------------------------------------------------------
0081               edkey.key.process.crash:
0082 613C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     613E FFCE 
0083 6140 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6142 2030 
**** **** ****     > stevie_b1.asm.37551
0095                       copy  "edkey.fb.mov.asm"    ; fb pane   - Actions for movement keys
**** **** ****     > edkey.fb.mov.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6144 C120  34         mov   @fb.column,tmp0
     6146 A10C 
0010 6148 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 614A 0620  34         dec   @fb.column            ; Column-- in screen buffer
     614C A10C 
0015 614E 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6150 832A 
0016 6152 0620  34         dec   @fb.current
     6154 A102 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6156 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6158 754A 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 615A 8820  54         c     @fb.column,@fb.row.length
     615C A10C 
     615E A108 
0028 6160 1406  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6162 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6164 A10C 
0033 6166 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6168 832A 
0034 616A 05A0  34         inc   @fb.current
     616C A102 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 616E 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6170 754A 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 6172 8820  54         c     @fb.row.dirty,@w$ffff
     6174 A10A 
     6176 202C 
0049 6178 1604  14         jne   edkey.action.up.cursor
0050 617A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     617C 6C1C 
0051 617E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6180 A10A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 6182 C120  34         mov   @fb.row,tmp0
     6184 A106 
0057 6186 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row > 0
0059 6188 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     618A A104 
0060 618C 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 618E 0604  14         dec   tmp0                  ; fb.topline--
0066 6190 C804  38         mov   tmp0,@parm1
     6192 8350 
0067 6194 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6196 689C 
0068 6198 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 619A 0620  34         dec   @fb.row               ; Row-- in screen buffer
     619C A106 
0074 619E 06A0  32         bl    @up                   ; Row-- VDP cursor
     61A0 268E 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61A2 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     61A4 6DB4 
0080 61A6 8820  54         c     @fb.column,@fb.row.length
     61A8 A10C 
     61AA A108 
0081 61AC 1207  14         jle   edkey.action.up.exit
0082                       ;-------------------------------------------------------
0083                       ; Adjust cursor column position
0084                       ;-------------------------------------------------------
0085 61AE C820  54         mov   @fb.row.length,@fb.column
     61B0 A108 
     61B2 A10C 
0086 61B4 C120  34         mov   @fb.column,tmp0
     61B6 A10C 
0087 61B8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61BA 2698 
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.up.exit:
0092 61BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61BE 6880 
0093 61C0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61C2 754A 
0094               
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Cursor down
0099               *---------------------------------------------------------------
0100               edkey.action.down:
0101 61C4 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     61C6 A106 
     61C8 A204 
0102 61CA 1330  14         jeq   !                     ; Yes, skip further processing
0103                       ;-------------------------------------------------------
0104                       ; Crunch current row if dirty
0105                       ;-------------------------------------------------------
0106 61CC 8820  54         c     @fb.row.dirty,@w$ffff
     61CE A10A 
     61D0 202C 
0107 61D2 1604  14         jne   edkey.action.down.move
0108 61D4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61D6 6C1C 
0109 61D8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61DA A10A 
0110                       ;-------------------------------------------------------
0111                       ; Move cursor
0112                       ;-------------------------------------------------------
0113               edkey.action.down.move:
0114                       ;-------------------------------------------------------
0115                       ; EOF reached?
0116                       ;-------------------------------------------------------
0117 61DC C120  34         mov   @fb.topline,tmp0
     61DE A104 
0118 61E0 A120  34         a     @fb.row,tmp0
     61E2 A106 
0119 61E4 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     61E6 A204 
0120 61E8 1312  14         jeq   edkey.action.down.set_cursorx
0121                                                   ; Yes, only position cursor X
0122                       ;-------------------------------------------------------
0123                       ; Check if scrolling required
0124                       ;-------------------------------------------------------
0125 61EA C120  34         mov   @fb.scrrows,tmp0
     61EC A118 
0126 61EE 0604  14         dec   tmp0
0127 61F0 8120  34         c     @fb.row,tmp0
     61F2 A106 
0128 61F4 1108  14         jlt   edkey.action.down.cursor
0129                       ;-------------------------------------------------------
0130                       ; Scroll 1 line
0131                       ;-------------------------------------------------------
0132 61F6 C820  54         mov   @fb.topline,@parm1
     61F8 A104 
     61FA 8350 
0133 61FC 05A0  34         inc   @parm1
     61FE 8350 
0134 6200 06A0  32         bl    @fb.refresh
     6202 689C 
0135 6204 1004  14         jmp   edkey.action.down.set_cursorx
0136                       ;-------------------------------------------------------
0137                       ; Move cursor down a row, there are still rows left
0138                       ;-------------------------------------------------------
0139               edkey.action.down.cursor:
0140 6206 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6208 A106 
0141 620A 06A0  32         bl    @down                 ; Row++ VDP cursor
     620C 2686 
0142                       ;-------------------------------------------------------
0143                       ; Check line length and position cursor
0144                       ;-------------------------------------------------------
0145               edkey.action.down.set_cursorx:
0146 620E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6210 6DB4 
0147               
0148 6212 8820  54         c     @fb.column,@fb.row.length
     6214 A10C 
     6216 A108 
0149 6218 1207  14         jle   edkey.action.down.exit
0150                                                   ; Exit
0151                       ;-------------------------------------------------------
0152                       ; Adjust cursor column position
0153                       ;-------------------------------------------------------
0154 621A C820  54         mov   @fb.row.length,@fb.column
     621C A108 
     621E A10C 
0155 6220 C120  34         mov   @fb.column,tmp0
     6222 A10C 
0156 6224 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6226 2698 
0157                       ;-------------------------------------------------------
0158                       ; Exit
0159                       ;-------------------------------------------------------
0160               edkey.action.down.exit:
0161 6228 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     622A 6880 
0162 622C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     622E 754A 
0163               
0164               
0165               
0166               *---------------------------------------------------------------
0167               * Cursor beginning of line
0168               *---------------------------------------------------------------
0169               edkey.action.home:
0170 6230 C120  34         mov   @wyx,tmp0
     6232 832A 
0171 6234 0244  22         andi  tmp0,>ff00
     6236 FF00 
0172 6238 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     623A 832A 
0173 623C 04E0  34         clr   @fb.column
     623E A10C 
0174 6240 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6242 6880 
0175 6244 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6246 754A 
0176               
0177               *---------------------------------------------------------------
0178               * Cursor end of line
0179               *---------------------------------------------------------------
0180               edkey.action.end:
0181 6248 C120  34         mov   @fb.row.length,tmp0
     624A A108 
0182 624C C804  38         mov   tmp0,@fb.column
     624E A10C 
0183 6250 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6252 2698 
0184 6254 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6256 6880 
0185 6258 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     625A 754A 
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Cursor beginning of word or previous word
0191               *---------------------------------------------------------------
0192               edkey.action.pword:
0193 625C C120  34         mov   @fb.column,tmp0
     625E A10C 
0194 6260 1324  14         jeq   !                     ; column=0 ? Skip further processing
0195                       ;-------------------------------------------------------
0196                       ; Prepare 2 char buffer
0197                       ;-------------------------------------------------------
0198 6262 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6264 A102 
0199 6266 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0200 6268 1003  14         jmp   edkey.action.pword_scan_char
0201                       ;-------------------------------------------------------
0202                       ; Scan backwards to first character following space
0203                       ;-------------------------------------------------------
0204               edkey.action.pword_scan
0205 626A 0605  14         dec   tmp1
0206 626C 0604  14         dec   tmp0                  ; Column-- in screen buffer
0207 626E 1315  14         jeq   edkey.action.pword_done
0208                                                   ; Column=0 ? Skip further processing
0209                       ;-------------------------------------------------------
0210                       ; Check character
0211                       ;-------------------------------------------------------
0212               edkey.action.pword_scan_char
0213 6270 D195  26         movb  *tmp1,tmp2            ; Get character
0214 6272 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0215 6274 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0216 6276 0986  56         srl   tmp2,8                ; Right justify
0217 6278 0286  22         ci    tmp2,32               ; Space character found?
     627A 0020 
0218 627C 16F6  14         jne   edkey.action.pword_scan
0219                                                   ; No space found, try again
0220                       ;-------------------------------------------------------
0221                       ; Space found, now look closer
0222                       ;-------------------------------------------------------
0223 627E 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6280 2020 
0224 6282 13F3  14         jeq   edkey.action.pword_scan
0225                                                   ; Yes, so continue scanning
0226 6284 0287  22         ci    tmp3,>20ff            ; First character is space
     6286 20FF 
0227 6288 13F0  14         jeq   edkey.action.pword_scan
0228                       ;-------------------------------------------------------
0229                       ; Check distance travelled
0230                       ;-------------------------------------------------------
0231 628A C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     628C A10C 
0232 628E 61C4  18         s     tmp0,tmp3
0233 6290 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     6292 0002 
0234 6294 11EA  14         jlt   edkey.action.pword_scan
0235                                                   ; Didn't move enough so keep on scanning
0236                       ;--------------------------------------------------------
0237                       ; Set cursor following space
0238                       ;--------------------------------------------------------
0239 6296 0585  14         inc   tmp1
0240 6298 0584  14         inc   tmp0                  ; Column++ in screen buffer
0241                       ;-------------------------------------------------------
0242                       ; Save position and position hardware cursor
0243                       ;-------------------------------------------------------
0244               edkey.action.pword_done:
0245 629A C805  38         mov   tmp1,@fb.current
     629C A102 
0246 629E C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62A0 A10C 
0247 62A2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62A4 2698 
0248                       ;-------------------------------------------------------
0249                       ; Exit
0250                       ;-------------------------------------------------------
0251               edkey.action.pword.exit:
0252 62A6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62A8 6880 
0253 62AA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62AC 754A 
0254               
0255               
0256               
0257               *---------------------------------------------------------------
0258               * Cursor next word
0259               *---------------------------------------------------------------
0260               edkey.action.nword:
0261 62AE 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0262 62B0 C120  34         mov   @fb.column,tmp0
     62B2 A10C 
0263 62B4 8804  38         c     tmp0,@fb.row.length
     62B6 A108 
0264 62B8 1428  14         jhe   !                     ; column=last char ? Skip further processing
0265                       ;-------------------------------------------------------
0266                       ; Prepare 2 char buffer
0267                       ;-------------------------------------------------------
0268 62BA C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62BC A102 
0269 62BE 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0270 62C0 1006  14         jmp   edkey.action.nword_scan_char
0271                       ;-------------------------------------------------------
0272                       ; Multiple spaces mode
0273                       ;-------------------------------------------------------
0274               edkey.action.nword_ms:
0275 62C2 0708  14         seto  tmp4                  ; Set multiple spaces mode
0276                       ;-------------------------------------------------------
0277                       ; Scan forward to first character following space
0278                       ;-------------------------------------------------------
0279               edkey.action.nword_scan
0280 62C4 0585  14         inc   tmp1
0281 62C6 0584  14         inc   tmp0                  ; Column++ in screen buffer
0282 62C8 8804  38         c     tmp0,@fb.row.length
     62CA A108 
0283 62CC 1316  14         jeq   edkey.action.nword_done
0284                                                   ; Column=last char ? Skip further processing
0285                       ;-------------------------------------------------------
0286                       ; Check character
0287                       ;-------------------------------------------------------
0288               edkey.action.nword_scan_char
0289 62CE D195  26         movb  *tmp1,tmp2            ; Get character
0290 62D0 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0291 62D2 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0292 62D4 0986  56         srl   tmp2,8                ; Right justify
0293               
0294 62D6 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     62D8 FFFF 
0295 62DA 1604  14         jne   edkey.action.nword_scan_char_other
0296                       ;-------------------------------------------------------
0297                       ; Special handling if multiple spaces found
0298                       ;-------------------------------------------------------
0299               edkey.action.nword_scan_char_ms:
0300 62DC 0286  22         ci    tmp2,32
     62DE 0020 
0301 62E0 160C  14         jne   edkey.action.nword_done
0302                                                   ; Exit if non-space found
0303 62E2 10F0  14         jmp   edkey.action.nword_scan
0304                       ;-------------------------------------------------------
0305                       ; Normal handling
0306                       ;-------------------------------------------------------
0307               edkey.action.nword_scan_char_other:
0308 62E4 0286  22         ci    tmp2,32               ; Space character found?
     62E6 0020 
0309 62E8 16ED  14         jne   edkey.action.nword_scan
0310                                                   ; No space found, try again
0311                       ;-------------------------------------------------------
0312                       ; Space found, now look closer
0313                       ;-------------------------------------------------------
0314 62EA 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62EC 2020 
0315 62EE 13E9  14         jeq   edkey.action.nword_ms
0316                                                   ; Yes, so continue scanning
0317 62F0 0287  22         ci    tmp3,>20ff            ; First characer is space?
     62F2 20FF 
0318 62F4 13E7  14         jeq   edkey.action.nword_scan
0319                       ;--------------------------------------------------------
0320                       ; Set cursor following space
0321                       ;--------------------------------------------------------
0322 62F6 0585  14         inc   tmp1
0323 62F8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0324                       ;-------------------------------------------------------
0325                       ; Save position and position hardware cursor
0326                       ;-------------------------------------------------------
0327               edkey.action.nword_done:
0328 62FA C805  38         mov   tmp1,@fb.current
     62FC A102 
0329 62FE C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6300 A10C 
0330 6302 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6304 2698 
0331                       ;-------------------------------------------------------
0332                       ; Exit
0333                       ;-------------------------------------------------------
0334               edkey.action.nword.exit:
0335 6306 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6308 6880 
0336 630A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     630C 754A 
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
0348 630E C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6310 A104 
0349 6312 1316  14         jeq   edkey.action.ppage.exit
0350                       ;-------------------------------------------------------
0351                       ; Special treatment top page
0352                       ;-------------------------------------------------------
0353 6314 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     6316 A118 
0354 6318 1503  14         jgt   edkey.action.ppage.topline
0355 631A 04E0  34         clr   @fb.topline           ; topline = 0
     631C A104 
0356 631E 1003  14         jmp   edkey.action.ppage.crunch
0357                       ;-------------------------------------------------------
0358                       ; Adjust topline
0359                       ;-------------------------------------------------------
0360               edkey.action.ppage.topline:
0361 6320 6820  54         s     @fb.scrrows,@fb.topline
     6322 A118 
     6324 A104 
0362                       ;-------------------------------------------------------
0363                       ; Crunch current row if dirty
0364                       ;-------------------------------------------------------
0365               edkey.action.ppage.crunch:
0366 6326 8820  54         c     @fb.row.dirty,@w$ffff
     6328 A10A 
     632A 202C 
0367 632C 1604  14         jne   edkey.action.ppage.refresh
0368 632E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6330 6C1C 
0369 6332 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6334 A10A 
0370                       ;-------------------------------------------------------
0371                       ; Refresh page
0372                       ;-------------------------------------------------------
0373               edkey.action.ppage.refresh:
0374 6336 C820  54         mov   @fb.topline,@parm1
     6338 A104 
     633A 8350 
0375 633C 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     633E 689C 
0376                       ;-------------------------------------------------------
0377                       ; Exit
0378                       ;-------------------------------------------------------
0379               edkey.action.ppage.exit:
0380 6340 04E0  34         clr   @fb.row
     6342 A106 
0381 6344 04E0  34         clr   @fb.column
     6346 A10C 
0382 6348 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     634A 832A 
0383 634C 0460  28         b     @edkey.action.up      ; In edkey.action up cursor is moved up
     634E 6172 
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
0394 6350 C120  34         mov   @fb.topline,tmp0
     6352 A104 
0395 6354 A120  34         a     @fb.scrrows,tmp0
     6356 A118 
0396 6358 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     635A A204 
0397 635C 150D  14         jgt   edkey.action.npage.exit
0398                       ;-------------------------------------------------------
0399                       ; Adjust topline
0400                       ;-------------------------------------------------------
0401               edkey.action.npage.topline:
0402 635E A820  54         a     @fb.scrrows,@fb.topline
     6360 A118 
     6362 A104 
0403                       ;-------------------------------------------------------
0404                       ; Crunch current row if dirty
0405                       ;-------------------------------------------------------
0406               edkey.action.npage.crunch:
0407 6364 8820  54         c     @fb.row.dirty,@w$ffff
     6366 A10A 
     6368 202C 
0408 636A 1604  14         jne   edkey.action.npage.refresh
0409 636C 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     636E 6C1C 
0410 6370 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6372 A10A 
0411                       ;-------------------------------------------------------
0412                       ; Refresh page
0413                       ;-------------------------------------------------------
0414               edkey.action.npage.refresh:
0415 6374 0460  28         b     @edkey.action.ppage.refresh
     6376 6336 
0416                                                   ; Same logic as previous page
0417                       ;-------------------------------------------------------
0418                       ; Exit
0419                       ;-------------------------------------------------------
0420               edkey.action.npage.exit:
0421 6378 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     637A 754A 
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
0433 637C 8820  54         c     @fb.row.dirty,@w$ffff
     637E A10A 
     6380 202C 
0434 6382 1604  14         jne   edkey.action.top.refresh
0435 6384 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6386 6C1C 
0436 6388 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     638A A10A 
0437                       ;-------------------------------------------------------
0438                       ; Refresh page
0439                       ;-------------------------------------------------------
0440               edkey.action.top.refresh:
0441 638C 04E0  34         clr   @fb.topline           ; Set to 1st line in editor buffer
     638E A104 
0442 6390 04E0  34         clr   @parm1
     6392 8350 
0443 6394 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6396 689C 
0444                       ;-------------------------------------------------------
0445                       ; Exit
0446                       ;-------------------------------------------------------
0447               edkey.action.top.exit:
0448 6398 04E0  34         clr   @fb.row               ; Frame buffer line 0
     639A A106 
0449 639C 04E0  34         clr   @fb.column            ; Frame buffer column 0
     639E A10C 
0450 63A0 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63A2 832A 
0451 63A4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63A6 754A 
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
0462 63A8 8820  54         c     @fb.row.dirty,@w$ffff
     63AA A10A 
     63AC 202C 
0463 63AE 1604  14         jne   edkey.action.bot.refresh
0464 63B0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63B2 6C1C 
0465 63B4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63B6 A10A 
0466                       ;-------------------------------------------------------
0467                       ; Refresh page
0468                       ;-------------------------------------------------------
0469               edkey.action.bot.refresh:
0470 63B8 8820  54         c     @edb.lines,@fb.scrrows
     63BA A204 
     63BC A118 
0471                                                   ; Skip if whole editor buffer on screen
0472 63BE 1212  14         jle   !
0473 63C0 C120  34         mov   @edb.lines,tmp0
     63C2 A204 
0474 63C4 6120  34         s     @fb.scrrows,tmp0
     63C6 A118 
0475 63C8 C804  38         mov   tmp0,@fb.topline      ; Set to last page in editor buffer
     63CA A104 
0476 63CC C804  38         mov   tmp0,@parm1
     63CE 8350 
0477 63D0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     63D2 689C 
0478                       ;-------------------------------------------------------
0479                       ; Exit
0480                       ;-------------------------------------------------------
0481               edkey.action.bot.exit:
0482 63D4 04E0  34         clr   @fb.row               ; Editor line 0
     63D6 A106 
0483 63D8 04E0  34         clr   @fb.column            ; Editor column 0
     63DA A10C 
0484 63DC 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     63DE 0100 
0485 63E0 C804  38         mov   tmp0,@wyx             ; Set cursor
     63E2 832A 
0486 63E4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     63E6 754A 
**** **** ****     > stevie_b1.asm.37551
0096                       copy  "edkey.fb.mod.asm"    ; fb pane   - Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 63E8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     63EA A206 
0010 63EC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63EE 6880 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1
0013                       ;-------------------------------------------------------
0014 63F0 C120  34         mov   @fb.current,tmp0      ; Get pointer
     63F2 A102 
0015 63F4 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     63F6 A108 
0016 63F8 1311  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2
0020                       ;-------------------------------------------------------
0021 63FA 8820  54         c     @fb.column,@fb.row.length
     63FC A10C 
     63FE A108 
0022 6400 130D  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 6402 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6404 A102 
0028 6406 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0029 6408 0585  14         inc   tmp1
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 640A DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 640C 0606  14         dec   tmp2
0036 640E 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Save variables
0039                       ;-------------------------------------------------------
0040 6410 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6412 A10A 
0041 6414 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6416 A116 
0042 6418 0620  34         dec   @fb.row.length        ; @fb.row.length--
     641A A108 
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.del_char.exit:
0047 641C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     641E 754A 
0048               
0049               
0050               *---------------------------------------------------------------
0051               * Delete until end of line
0052               *---------------------------------------------------------------
0053               edkey.action.del_eol:
0054 6420 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6422 A206 
0055 6424 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6426 6880 
0056 6428 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     642A A108 
0057 642C 1311  14         jeq   edkey.action.del_eol.exit
0058                                                   ; Exit if empty line
0059                       ;-------------------------------------------------------
0060                       ; Prepare for erase operation
0061                       ;-------------------------------------------------------
0062 642E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6430 A102 
0063 6432 C1A0  34         mov   @fb.colsline,tmp2
     6434 A10E 
0064 6436 61A0  34         s     @fb.column,tmp2
     6438 A10C 
0065 643A 04C5  14         clr   tmp1
0066                       ;-------------------------------------------------------
0067                       ; Loop until last column in frame buffer
0068                       ;-------------------------------------------------------
0069               edkey.action.del_eol_loop:
0070 643C DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0071 643E 0606  14         dec   tmp2
0072 6440 16FD  14         jne   edkey.action.del_eol_loop
0073                       ;-------------------------------------------------------
0074                       ; Save variables
0075                       ;-------------------------------------------------------
0076 6442 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6444 A10A 
0077 6446 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6448 A116 
0078               
0079 644A C820  54         mov   @fb.column,@fb.row.length
     644C A10C 
     644E A108 
0080                                                   ; Set new row length
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.del_eol.exit:
0085 6450 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6452 754A 
0086               
0087               
0088               *---------------------------------------------------------------
0089               * Delete current line
0090               *---------------------------------------------------------------
0091               edkey.action.del_line:
0092 6454 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6456 A206 
0093                       ;-------------------------------------------------------
0094                       ; Special treatment if only 1 line in file
0095                       ;-------------------------------------------------------
0096 6458 C120  34         mov   @edb.lines,tmp0
     645A A204 
0097 645C 1604  14         jne   !
0098 645E 04E0  34         clr   @fb.column            ; Column 0
     6460 A10C 
0099 6462 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     6464 6420 
0100                       ;-------------------------------------------------------
0101                       ; Delete entry in index
0102                       ;-------------------------------------------------------
0103 6466 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6468 6880 
0104 646A 04E0  34         clr   @fb.row.dirty         ; Discard current line
     646C A10A 
0105 646E C820  54         mov   @fb.topline,@parm1
     6470 A104 
     6472 8350 
0106 6474 A820  54         a     @fb.row,@parm1        ; Line number to remove
     6476 A106 
     6478 8350 
0107 647A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     647C A204 
     647E 8352 
0108 6480 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     6482 6B04 
0109 6484 0620  34         dec   @edb.lines            ; One line less in editor buffer
     6486 A204 
0110                       ;-------------------------------------------------------
0111                       ; Refresh frame buffer and physical screen
0112                       ;-------------------------------------------------------
0113 6488 C820  54         mov   @fb.topline,@parm1
     648A A104 
     648C 8350 
0114 648E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6490 689C 
0115 6492 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6494 A116 
0116                       ;-------------------------------------------------------
0117                       ; Special treatment if current line was last line
0118                       ;-------------------------------------------------------
0119 6496 C120  34         mov   @fb.topline,tmp0
     6498 A104 
0120 649A A120  34         a     @fb.row,tmp0
     649C A106 
0121 649E 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64A0 A204 
0122 64A2 1202  14         jle   edkey.action.del_line.exit
0123 64A4 0460  28         b     @edkey.action.up      ; One line up
     64A6 6172 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.del_line.exit:
0128 64A8 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64AA 6230 
0129               
0130               
0131               
0132               *---------------------------------------------------------------
0133               * Insert character
0134               *
0135               * @parm1 = high byte has character to insert
0136               *---------------------------------------------------------------
0137               edkey.action.ins_char.ws:
0138 64AC 0204  20         li    tmp0,>2000            ; White space
     64AE 2000 
0139 64B0 C804  38         mov   tmp0,@parm1
     64B2 8350 
0140               edkey.action.ins_char:
0141 64B4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64B6 A206 
0142 64B8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64BA 6880 
0143                       ;-------------------------------------------------------
0144                       ; Sanity check 1 - Empty line
0145                       ;-------------------------------------------------------
0146 64BC C120  34         mov   @fb.current,tmp0      ; Get pointer
     64BE A102 
0147 64C0 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64C2 A108 
0148 64C4 131A  14         jeq   edkey.action.ins_char.sanity
0149                                                   ; Add character in overwrite mode
0150                       ;-------------------------------------------------------
0151                       ; Sanity check 2 - EOL
0152                       ;-------------------------------------------------------
0153 64C6 8820  54         c     @fb.column,@fb.row.length
     64C8 A10C 
     64CA A108 
0154 64CC 1316  14         jeq   edkey.action.ins_char.sanity
0155                                                   ; Add character in overwrite mode
0156                       ;-------------------------------------------------------
0157                       ; Prepare for insert operation
0158                       ;-------------------------------------------------------
0159               edkey.action.skipsanity:
0160 64CE C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0161 64D0 61E0  34         s     @fb.column,tmp3
     64D2 A10C 
0162 64D4 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0163 64D6 C144  18         mov   tmp0,tmp1
0164 64D8 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0165 64DA 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     64DC A10C 
0166 64DE 0586  14         inc   tmp2
0167                       ;-------------------------------------------------------
0168                       ; Loop from end of line until current character
0169                       ;-------------------------------------------------------
0170               edkey.action.ins_char_loop:
0171 64E0 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0172 64E2 0604  14         dec   tmp0
0173 64E4 0605  14         dec   tmp1
0174 64E6 0606  14         dec   tmp2
0175 64E8 16FB  14         jne   edkey.action.ins_char_loop
0176                       ;-------------------------------------------------------
0177                       ; Set specified character on current position
0178                       ;-------------------------------------------------------
0179 64EA D560  46         movb  @parm1,*tmp1
     64EC 8350 
0180                       ;-------------------------------------------------------
0181                       ; Save variables
0182                       ;-------------------------------------------------------
0183 64EE 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64F0 A10A 
0184 64F2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64F4 A116 
0185 64F6 05A0  34         inc   @fb.row.length        ; @fb.row.length
     64F8 A108 
0186                       ;-------------------------------------------------------
0187                       ; Add character in overwrite mode
0188                       ;-------------------------------------------------------
0189               edkey.action.ins_char.sanity
0190 64FA 0460  28         b     @edkey.action.char.overwrite
     64FC 65E6 
0191                       ;-------------------------------------------------------
0192                       ; Exit
0193                       ;-------------------------------------------------------
0194               edkey.action.ins_char.exit:
0195 64FE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6500 754A 
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
0206 6502 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6504 A206 
0207                       ;-------------------------------------------------------
0208                       ; Crunch current line if dirty
0209                       ;-------------------------------------------------------
0210 6506 8820  54         c     @fb.row.dirty,@w$ffff
     6508 A10A 
     650A 202C 
0211 650C 1604  14         jne   edkey.action.ins_line.insert
0212 650E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6510 6C1C 
0213 6512 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6514 A10A 
0214                       ;-------------------------------------------------------
0215                       ; Insert entry in index
0216                       ;-------------------------------------------------------
0217               edkey.action.ins_line.insert:
0218 6516 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6518 6880 
0219 651A C820  54         mov   @fb.topline,@parm1
     651C A104 
     651E 8350 
0220 6520 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6522 A106 
     6524 8350 
0221 6526 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6528 A204 
     652A 8352 
0222               
0223 652C 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     652E 6B8E 
0224                                                   ; \ i  parm1 = Line for insert
0225                                                   ; / i  parm2 = Last line to reorg
0226               
0227 6530 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6532 A204 
0228                       ;-------------------------------------------------------
0229                       ; Refresh frame buffer and physical screen
0230                       ;-------------------------------------------------------
0231 6534 C820  54         mov   @fb.topline,@parm1
     6536 A104 
     6538 8350 
0232 653A 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     653C 689C 
0233 653E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6540 A116 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               edkey.action.ins_line.exit:
0238 6542 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6544 754A 
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
0252 6546 8820  54         c     @fb.row.dirty,@w$ffff
     6548 A10A 
     654A 202C 
0253 654C 1606  14         jne   edkey.action.enter.upd_counter
0254 654E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6550 A206 
0255 6552 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6554 6C1C 
0256 6556 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6558 A10A 
0257                       ;-------------------------------------------------------
0258                       ; Update line counter
0259                       ;-------------------------------------------------------
0260               edkey.action.enter.upd_counter:
0261 655A C120  34         mov   @fb.topline,tmp0
     655C A104 
0262 655E A120  34         a     @fb.row,tmp0
     6560 A106 
0263 6562 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6564 A204 
0264 6566 1602  14         jne   edkey.action.newline  ; No, continue newline
0265 6568 05A0  34         inc   @edb.lines            ; Total lines++
     656A A204 
0266                       ;-------------------------------------------------------
0267                       ; Process newline
0268                       ;-------------------------------------------------------
0269               edkey.action.newline:
0270                       ;-------------------------------------------------------
0271                       ; Scroll 1 line if cursor at bottom row of screen
0272                       ;-------------------------------------------------------
0273 656C C120  34         mov   @fb.scrrows,tmp0
     656E A118 
0274 6570 0604  14         dec   tmp0
0275 6572 8120  34         c     @fb.row,tmp0
     6574 A106 
0276 6576 110A  14         jlt   edkey.action.newline.down
0277                       ;-------------------------------------------------------
0278                       ; Scroll
0279                       ;-------------------------------------------------------
0280 6578 C120  34         mov   @fb.scrrows,tmp0
     657A A118 
0281 657C C820  54         mov   @fb.topline,@parm1
     657E A104 
     6580 8350 
0282 6582 05A0  34         inc   @parm1
     6584 8350 
0283 6586 06A0  32         bl    @fb.refresh
     6588 689C 
0284 658A 1004  14         jmp   edkey.action.newline.rest
0285                       ;-------------------------------------------------------
0286                       ; Move cursor down a row, there are still rows left
0287                       ;-------------------------------------------------------
0288               edkey.action.newline.down:
0289 658C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     658E A106 
0290 6590 06A0  32         bl    @down                 ; Row++ VDP cursor
     6592 2686 
0291                       ;-------------------------------------------------------
0292                       ; Set VDP cursor and save variables
0293                       ;-------------------------------------------------------
0294               edkey.action.newline.rest:
0295 6594 06A0  32         bl    @fb.get.firstnonblank
     6596 690C 
0296 6598 C120  34         mov   @outparm1,tmp0
     659A 8360 
0297 659C C804  38         mov   tmp0,@fb.column
     659E A10C 
0298 65A0 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65A2 2698 
0299 65A4 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65A6 6DB4 
0300 65A8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65AA 6880 
0301 65AC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65AE A116 
0302                       ;-------------------------------------------------------
0303                       ; Exit
0304                       ;-------------------------------------------------------
0305               edkey.action.newline.exit:
0306 65B0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65B2 754A 
0307               
0308               
0309               
0310               
0311               *---------------------------------------------------------------
0312               * Toggle insert/overwrite mode
0313               *---------------------------------------------------------------
0314               edkey.action.ins_onoff:
0315 65B4 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     65B6 A20A 
0316                       ;-------------------------------------------------------
0317                       ; Delay
0318                       ;-------------------------------------------------------
0319 65B8 0204  20         li    tmp0,2000
     65BA 07D0 
0320               edkey.action.ins_onoff.loop:
0321 65BC 0604  14         dec   tmp0
0322 65BE 16FE  14         jne   edkey.action.ins_onoff.loop
0323                       ;-------------------------------------------------------
0324                       ; Exit
0325                       ;-------------------------------------------------------
0326               edkey.action.ins_onoff.exit:
0327 65C0 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     65C2 7622 
0328               
0329               
0330               
0331               
0332               *---------------------------------------------------------------
0333               * Process character (frame buffer)
0334               *---------------------------------------------------------------
0335               edkey.action.char:
0336                       ;-------------------------------------------------------
0337                       ; Sanity checks
0338                       ;-------------------------------------------------------
0339 65C4 D105  18         movb  tmp1,tmp0             ; Get keycode
0340 65C6 0984  56         srl   tmp0,8                ; MSB to LSB
0341               
0342 65C8 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     65CA 0020 
0343 65CC 1121  14         jlt   edkey.action.char.exit
0344                                                   ; Yes, skip
0345               
0346 65CE 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     65D0 007E 
0347 65D2 151E  14         jgt   edkey.action.char.exit
0348                                                   ; Yes, skip
0349                       ;-------------------------------------------------------
0350                       ; Setup
0351                       ;-------------------------------------------------------
0352 65D4 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65D6 A206 
0353 65D8 D805  38         movb  tmp1,@parm1           ; Store character for insert
     65DA 8350 
0354 65DC C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     65DE A20A 
0355 65E0 1302  14         jeq   edkey.action.char.overwrite
0356                       ;-------------------------------------------------------
0357                       ; Insert mode
0358                       ;-------------------------------------------------------
0359               edkey.action.char.insert:
0360 65E2 0460  28         b     @edkey.action.ins_char
     65E4 64B4 
0361                       ;-------------------------------------------------------
0362                       ; Overwrite mode
0363                       ;-------------------------------------------------------
0364               edkey.action.char.overwrite:
0365 65E6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65E8 6880 
0366 65EA C120  34         mov   @fb.current,tmp0      ; Get pointer
     65EC A102 
0367               
0368 65EE D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     65F0 8350 
0369 65F2 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     65F4 A10A 
0370 65F6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65F8 A116 
0371               
0372 65FA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     65FC A10C 
0373 65FE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6600 832A 
0374                       ;-------------------------------------------------------
0375                       ; Update line length in frame buffer
0376                       ;-------------------------------------------------------
0377 6602 8820  54         c     @fb.column,@fb.row.length
     6604 A10C 
     6606 A108 
0378 6608 1103  14         jlt   edkey.action.char.exit
0379                                                   ; column < length line ? Skip processing
0380               
0381 660A C820  54         mov   @fb.column,@fb.row.length
     660C A10C 
     660E A108 
0382                       ;-------------------------------------------------------
0383                       ; Exit
0384                       ;-------------------------------------------------------
0385               edkey.action.char.exit:
0386 6610 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6612 754A 
**** **** ****     > stevie_b1.asm.37551
0097                       copy  "edkey.fb.misc.asm"   ; fb pane   - Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit stevie
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009 6614 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6616 2748 
0010 6618 0420  54         blwp  @0                    ; Exit
     661A 0000 
0011               
0012               
0013               *---------------------------------------------------------------
0014               * No action at all
0015               *---------------------------------------------------------------
0016               edkey.action.noop:
0017 661C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     661E 754A 
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
0028 6620 05A0  34         inc   @fb.scrrows
     6622 A118 
0029 6624 0720  34         seto  @fb.dirty
     6626 A116 
0030               
0031 6628 045B  20         b     *r11
0032               
**** **** ****     > stevie_b1.asm.37551
0098                       copy  "edkey.fb.file.asm"   ; fb pane   - File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               
0005               edkey.action.fb.buffer0:
0006 662A 0204  20         li   tmp0,fdname0
     662C 33CA 
0007 662E 101B  14         jmp  _edkey.action.rest
0008               edkey.action.fb.buffer1:
0009 6630 0204  20         li   tmp0,fdname1
     6632 3336 
0010 6634 1018  14         jmp  _edkey.action.rest
0011               edkey.action.fb.buffer2:
0012 6636 0204  20         li   tmp0,fdname2
     6638 3340 
0013 663A 1015  14         jmp  _edkey.action.rest
0014               edkey.action.fb.buffer3:
0015 663C 0204  20         li   tmp0,fdname3
     663E 3350 
0016 6640 1012  14         jmp  _edkey.action.rest
0017               edkey.action.fb.buffer4:
0018 6642 0204  20         li   tmp0,fdname4
     6644 335E 
0019 6646 100F  14         jmp  _edkey.action.rest
0020               edkey.action.fb.buffer5:
0021 6648 0204  20         li   tmp0,fdname5
     664A 3370 
0022 664C 100C  14         jmp  _edkey.action.rest
0023               edkey.action.fb.buffer6:
0024 664E 0204  20         li   tmp0,fdname6
     6650 3382 
0025 6652 1009  14         jmp  _edkey.action.rest
0026               edkey.action.fb.buffer7:
0027 6654 0204  20         li   tmp0,fdname7
     6656 3394 
0028 6658 1006  14         jmp  _edkey.action.rest
0029               edkey.action.fb.buffer8:
0030 665A 0204  20         li   tmp0,fdname8
     665C 33A8 
0031 665E 1003  14         jmp  _edkey.action.rest
0032               edkey.action.fb.buffer9:
0033 6660 0204  20         li   tmp0,fdname9
     6662 33BC 
0034 6664 1000  14         jmp  _edkey.action.rest
0035               _edkey.action.rest:
0036 6666 06A0  32         bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer
     6668 72DE 
0037                                                   ; | i  tmp0 = Pointer to device and filename
0038                                                   ; /
0039               
0040 666A 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     666C 637C 
0041               
0042               
0043               
0044               
0045               
0046               
0047               
0048               
0049               *---------------------------------------------------------------
0050               * Load next or previous file based on last char in suffix
0051               *---------------------------------------------------------------
0052               * b   @edkey.action.fb.fname.inc.load
0053               * b   @edkey.action.fb.fname.dec.load
0054               *---------------------------------------------------------------
0055               * INPUT
0056               * none
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * none
0060               ********|*****|*********************|**************************
0061               edkey.action.fb.fname.inc.load:
0062 666E C820  54         mov   @fh.fname.ptr,@parm1   ; Set pointer to current filename
     6670 A436 
     6672 8350 
0063 6674 0720  34         seto  @parm2                 ; Increase ASCII value of char in suffix
     6676 8352 
0064               
0065               _edkey.action.fb.fname.doit:
0066                       ;------------------------------------------------------
0067                       ; Update suffix and load file
0068                       ;------------------------------------------------------
0069 6678 06A0  32         bl   @fm.browse.fname.suffix.incdec
     667A 74AA 
0070                                                    ; Filename suffix adjust
0071                                                    ; i  \ parm1 = Pointer to filename
0072                                                    ; i  / parm2 = >FFFF or >0000
0073               
0074 667C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     667E E000 
0075 6680 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6682 72DE 
0076                                                   ; \ i  tmp0 = Pointer to length-prefixed
0077                                                   ; /           device/filename string
0078                       ;------------------------------------------------------
0079                       ; Exit
0080                       ;------------------------------------------------------
0081 6684 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6686 637C 
0082               
0083               
0084               edkey.action.fb.fname.dec.load:
0085 6688 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     668A A436 
     668C 8350 
0086 668E 04E0  34         clr  @parm2                 ; Decrease ASCII value of char in suffix
     6690 8352 
0087 6692 10F2  14         jmp  _edkey.action.fb.fname.doit
0088               
0089               
0090               _edkey.action.fb.fname.loadfile:
**** **** ****     > stevie_b1.asm.37551
0099                       copy  "edkey.cmdb.mov.asm"  ; cmdb pane - Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 6694 C120  34         mov   @cmdb.column,tmp0
     6696 A312 
0010 6698 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 669A 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     669C A312 
0015 669E 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     66A0 A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 66A2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66A4 754A 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 66A6 06A0  32         bl    @cmdb.cmd.getlength
     66A8 6E8E 
0027 66AA 8820  54         c     @cmdb.column,@outparm1
     66AC A312 
     66AE 8360 
0028 66B0 1404  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 66B2 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     66B4 A312 
0033 66B6 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     66B8 A30A 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037 66BA 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66BC 754A 
0038               
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor beginning of line
0043               *---------------------------------------------------------------
0044               edkey.action.cmdb.home:
0045 66BE 04C4  14         clr   tmp0
0046 66C0 C804  38         mov   tmp0,@cmdb.column      ; First column
     66C2 A312 
0047 66C4 0584  14         inc   tmp0
0048 66C6 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     66C8 A30A 
0049 66CA C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     66CC A30A 
0050               
0051 66CE 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66D0 754A 
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.cmdb.end:
0057 66D2 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     66D4 A322 
0058 66D6 0984  56         srl   tmp0,8                 ; Right justify
0059 66D8 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     66DA A312 
0060 66DC 0584  14         inc   tmp0                   ; One time adjustment command prompt
0061 66DE 0224  22         ai    tmp0,>1a00             ; Y=26
     66E0 1A00 
0062 66E2 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     66E4 A30A 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066 66E6 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66E8 754A 
**** **** ****     > stevie_b1.asm.37551
0100                       copy  "edkey.cmdb.mod.asm"  ; cmdb pane - Actions for modifier keys
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
0026 66EA 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     66EC 6E5C 
0027 66EE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     66F0 A318 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.clear.exit:
0032 66F2 0460  28         b     @edkey.action.cmdb.home
     66F4 66BE 
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
0061 66F6 D105  18         movb  tmp1,tmp0             ; Get keycode
0062 66F8 0984  56         srl   tmp0,8                ; MSB to LSB
0063               
0064 66FA 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     66FC 0020 
0065 66FE 1115  14         jlt   edkey.action.cmdb.char.exit
0066                                                   ; Yes, skip
0067               
0068 6700 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6702 007E 
0069 6704 1512  14         jgt   edkey.action.cmdb.char.exit
0070                                                   ; Yes, skip
0071                       ;-------------------------------------------------------
0072                       ; Add character
0073                       ;-------------------------------------------------------
0074 6706 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6708 A318 
0075               
0076 670A 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     670C A323 
0077 670E A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6710 A312 
0078 6712 D505  30         movb  tmp1,*tmp0            ; Add character
0079 6714 05A0  34         inc   @cmdb.column          ; Next column
     6716 A312 
0080 6718 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     671A A30A 
0081               
0082 671C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     671E 6E8E 
0083                                                   ; \ i  @cmdb.cmd = Command string
0084                                                   ; / o  @outparm1 = Length of command
0085                       ;-------------------------------------------------------
0086                       ; Addjust length
0087                       ;-------------------------------------------------------
0088 6720 C120  34         mov   @outparm1,tmp0
     6722 8360 
0089 6724 0A84  56         sla   tmp0,8               ; LSB to MSB
0090 6726 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6728 A322 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.cmdb.char.exit:
0095 672A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     672C 754A 
0096               
0097               
0098               
0099               
0100               *---------------------------------------------------------------
0101               * Enter
0102               *---------------------------------------------------------------
0103               edkey.action.cmdb.enter:
0104                       ;-------------------------------------------------------
0105                       ; Parse command
0106                       ;-------------------------------------------------------
0107                       ; TO BE IMPLEMENTED
0108               
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.cmdb.enter.exit:
0113 672E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6730 754A 
**** **** ****     > stevie_b1.asm.37551
0101                       copy  "edkey.cmdb.misc.asm" ; cmdb pane - Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 6732 C120  34         mov   @cmdb.visible,tmp0
     6734 A302 
0010 6736 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 6738 04E0  34         clr   @cmdb.column          ; Column = 0
     673A A312 
0016 673C 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     673E 7906 
0017 6740 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6742 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6744 7952 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 6746 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6748 754A 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.37551
0102                       copy  "edkey.cmdb.file.asm" ; cmdb pane - File related actions
**** **** ****     > edkey.cmdb.file.asm
0001               * FILE......: edkey.cmdb.fíle.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load or save DV 80 file
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.loadsave:
0009                       ;-------------------------------------------------------
0010                       ; Load or save file
0011                       ;-------------------------------------------------------
0012 674A 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     674C 7952 
0013               
0014 674E 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6750 6E8E 
0015 6752 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6754 8360 
0016 6756 1607  14         jne   !                     ; No, prepare for load/save
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 6758 06A0  32         bl    @pane.errline.show    ; Show error line
     675A 7990 
0021               
0022 675C 06A0  32         bl    @pane.show_hint
     675E 76D2 
0023 6760 1C00                   byte 28,0
0024 6762 329E                   data txt.io.nofile
0025               
0026 6764 1019  14         jmp   edkey.action.cmdb.loadsave.exit
0027                       ;-------------------------------------------------------
0028                       ; Prepare for loading or saving file
0029                       ;-------------------------------------------------------
0030 6766 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6768 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     676A A322 
0032               
0033 676C 06A0  32         bl    @cpym2m
     676E 248C 
0034 6770 A322                   data cmdb.cmdlen,heap.top,80
     6772 E000 
     6774 0050 
0035                                                   ; Copy filename from command line to buffer
0036               
0037 6776 C120  34         mov   @cmdb.dialog,tmp0
     6778 A31A 
0038 677A 0284  22         ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
     677C 0001 
0039 677E 1303  14         jeq   edkey.action.cmdb.load.loadfile
0040               
0041 6780 0284  22         ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
     6782 0002 
0042 6784 1305  14         jeq   edkey.action.cmdb.load.savefile
0043                       ;-------------------------------------------------------
0044                       ; Load specified file
0045                       ;-------------------------------------------------------
0046               edkey.action.cmdb.load.loadfile:
0047 6786 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6788 E000 
0048 678A 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     678C 72DE 
0049                                                   ; \ i  tmp0 = Pointer to length-prefixed
0050                                                   ; /           device/filename string
0051 678E 1004  14         jmp   edkey.action.cmdb.loadsave.exit
0052                       ;-------------------------------------------------------
0053                       ; Save specified file
0054                       ;-------------------------------------------------------
0055               edkey.action.cmdb.load.savefile:
0056 6790 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6792 E000 
0057 6794 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6796 7364 
0058                                                   ; \ i  tmp0 = Pointer to length-prefixed
0059                                                   ; /           device/filename string
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.cmdb.loadsave.exit:
0064 6798 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     679A 637C 
**** **** ****     > stevie_b1.asm.37551
0103                       ;-----------------------------------------------------------------------
0104                       ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
0105                       ;-----------------------------------------------------------------------
0106                       copy  "tv.asm"              ; Main editor configuration
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
0027 679C 0649  14         dect  stack
0028 679E C64B  30         mov   r11,*stack            ; Save return address
0029 67A0 0649  14         dect  stack
0030 67A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 67A4 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     67A6 A012 
0035 67A8 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     67AA A01C 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039               tv.init.exit:
0040 67AC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0041 67AE C2F9  30         mov   *stack+,r11           ; Pop R11
0042 67B0 045B  20         b     *r11                  ; Return to caller
0043               
0044               
0045               
0046               ***************************************************************
0047               * tv.reset
0048               * Reset editor (clear buffer)
0049               ***************************************************************
0050               * bl @tv.reset
0051               *--------------------------------------------------------------
0052               * INPUT
0053               * none
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               * none
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * r11
0060               *--------------------------------------------------------------
0061               * Notes
0062               ***************************************************************
0063               tv.reset:
0064 67B2 0649  14         dect  stack
0065 67B4 C64B  30         mov   r11,*stack            ; Save return address
0066                       ;------------------------------------------------------
0067                       ; Reset editor
0068                       ;------------------------------------------------------
0069 67B6 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     67B8 6DD2 
0070 67BA 06A0  32         bl    @edb.init             ; Initialize editor buffer
     67BC 6BE6 
0071 67BE 06A0  32         bl    @idx.init             ; Initialize index
     67C0 6954 
0072 67C2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     67C4 682A 
0073 67C6 06A0  32         bl    @errline.init         ; Initialize error line
     67C8 6EBC 
0074                       ;-------------------------------------------------------
0075                       ; Exit
0076                       ;-------------------------------------------------------
0077               tv.reset.exit:
0078 67CA C2F9  30         mov   *stack+,r11           ; Pop R11
0079 67CC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0107                       copy  "mem.asm"             ; Memory Management
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
0021 67CE 0649  14         dect  stack
0022 67D0 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 67D2 06A0  32         bl    @sams.layout
     67D4 2594 
0027 67D6 3086                   data mem.sams.layout.data
0028               
0029 67D8 06A0  32         bl    @sams.layout.copy
     67DA 25F8 
0030 67DC A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 67DE C820  54         mov   @tv.sams.c000,@edb.sams.page
     67E0 A008 
     67E2 A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 67E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0039 67E6 045B  20         b     *r11                  ; Return to caller
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
0064 67E8 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 67EA 0649  14         dect  stack
0067 67EC C64B  30         mov   r11,*stack            ; Push return address
0068 67EE 0649  14         dect  stack
0069 67F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0070 67F2 0649  14         dect  stack
0071 67F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 67F6 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     67F8 A204 
0076 67FA 1104  14         jlt   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 67FC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     67FE FFCE 
0082 6800 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6802 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 6804 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6806 6AA8 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 6808 C120  34         mov   @outparm2,tmp0        ; SAMS page
     680A 8362 
0093 680C C160  34         mov   @outparm1,tmp1        ; Pointer to line
     680E 8360 
0094 6810 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 6812 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6814 A008 
0101 6816 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 6818 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     681A 2528 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 681C C820  54         mov   @outparm2,@tv.sams.c000
     681E 8362 
     6820 A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 6822 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 6824 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 6826 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 6828 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.37551
0108                       copy  "fb.asm"              ; Framebuffer
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
0023               fb.init:
0024 682A 0649  14         dect  stack
0025 682C C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 682E 0204  20         li    tmp0,fb.top
     6830 A600 
0030 6832 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     6834 A100 
0031 6836 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     6838 A104 
0032 683A 04E0  34         clr   @fb.row               ; Current row=0
     683C A106 
0033 683E 04E0  34         clr   @fb.column            ; Current column=0
     6840 A10C 
0034               
0035 6842 0204  20         li    tmp0,80
     6844 0050 
0036 6846 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     6848 A10E 
0037               
0038 684A 0204  20         li    tmp0,29
     684C 001D 
0039 684E C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     6850 A118 
0040 6852 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     6854 A11A 
0041               
0042 6856 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     6858 A01A 
0043 685A 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     685C A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 685E 06A0  32         bl    @film
     6860 2230 
0048 6862 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     6864 0000 
     6866 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit:
0053 6868 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 686A 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               ***************************************************************
0060               * fb.row2line
0061               * Calculate line in editor buffer
0062               ***************************************************************
0063               * bl @fb.row2line
0064               *--------------------------------------------------------------
0065               * INPUT
0066               * @fb.topline = Top line in frame buffer
0067               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0068               *--------------------------------------------------------------
0069               * OUTPUT
0070               * @outparm1 = Matching line in editor buffer
0071               *--------------------------------------------------------------
0072               * Register usage
0073               * tmp2,tmp3
0074               *--------------------------------------------------------------
0075               * Formula
0076               * outparm1 = @fb.topline + @parm1
0077               ********|*****|*********************|**************************
0078               fb.row2line:
0079 686C 0649  14         dect  stack
0080 686E C64B  30         mov   r11,*stack            ; Save return address
0081                       ;------------------------------------------------------
0082                       ; Calculate line in editor buffer
0083                       ;------------------------------------------------------
0084 6870 C120  34         mov   @parm1,tmp0
     6872 8350 
0085 6874 A120  34         a     @fb.topline,tmp0
     6876 A104 
0086 6878 C804  38         mov   tmp0,@outparm1
     687A 8360 
0087                       ;------------------------------------------------------
0088                       ; Exit
0089                       ;------------------------------------------------------
0090               fb.row2line$$:
0091 687C C2F9  30         mov   *stack+,r11           ; Pop r11
0092 687E 045B  20         b     *r11                  ; Return to caller
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * fb.calc_pointer
0099               * Calculate pointer address in frame buffer
0100               ***************************************************************
0101               * bl @fb.calc_pointer
0102               *--------------------------------------------------------------
0103               * INPUT
0104               * @fb.top       = Address of top row in frame buffer
0105               * @fb.topline   = Top line in frame buffer
0106               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0107               * @fb.column    = Current column in frame buffer
0108               * @fb.colsline  = Columns per line in frame buffer
0109               *--------------------------------------------------------------
0110               * OUTPUT
0111               * @fb.current   = Updated pointer
0112               *--------------------------------------------------------------
0113               * Register usage
0114               * tmp2,tmp3
0115               *--------------------------------------------------------------
0116               * Formula
0117               * pointer = row * colsline + column + deref(@fb.top.ptr)
0118               ********|*****|*********************|**************************
0119               fb.calc_pointer:
0120 6880 0649  14         dect  stack
0121 6882 C64B  30         mov   r11,*stack            ; Save return address
0122                       ;------------------------------------------------------
0123                       ; Calculate pointer
0124                       ;------------------------------------------------------
0125 6884 C1A0  34         mov   @fb.row,tmp2
     6886 A106 
0126 6888 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     688A A10E 
0127 688C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     688E A10C 
0128 6890 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     6892 A100 
0129 6894 C807  38         mov   tmp3,@fb.current
     6896 A102 
0130                       ;------------------------------------------------------
0131                       ; Exit
0132                       ;------------------------------------------------------
0133               fb.calc_pointer.exit:
0134 6898 C2F9  30         mov   *stack+,r11           ; Pop r11
0135 689A 045B  20         b     *r11                  ; Return to caller
0136               
0137               
0138               
0139               
0140               
0141               ***************************************************************
0142               * fb.refresh
0143               * Refresh frame buffer with editor buffer content
0144               ***************************************************************
0145               * bl @fb.refresh
0146               *--------------------------------------------------------------
0147               * INPUT
0148               * @parm1 = Line to start with (becomes @fb.topline)
0149               *--------------------------------------------------------------
0150               * OUTPUT
0151               * none
0152               *--------------------------------------------------------------
0153               * Register usage
0154               * tmp0,tmp1,tmp2
0155               ********|*****|*********************|**************************
0156               fb.refresh:
0157 689C 0649  14         dect  stack
0158 689E C64B  30         mov   r11,*stack            ; Push return address
0159 68A0 0649  14         dect  stack
0160 68A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0161 68A4 0649  14         dect  stack
0162 68A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0163 68A8 0649  14         dect  stack
0164 68AA C646  30         mov   tmp2,*stack           ; Push tmp2
0165                       ;------------------------------------------------------
0166                       ; Setup starting position in index
0167                       ;------------------------------------------------------
0168 68AC C820  54         mov   @parm1,@fb.topline
     68AE 8350 
     68B0 A104 
0169 68B2 04E0  34         clr   @parm2                ; Target row in frame buffer
     68B4 8352 
0170                       ;------------------------------------------------------
0171                       ; Check if already at EOF
0172                       ;------------------------------------------------------
0173 68B6 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     68B8 8350 
     68BA A204 
0174 68BC 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0175                       ;------------------------------------------------------
0176                       ; Unpack line to frame buffer
0177                       ;------------------------------------------------------
0178               fb.refresh.unpack_line:
0179 68BE 06A0  32         bl    @edb.line.unpack      ; Unpack line
     68C0 6CD2 
0180                                                   ; \ i  parm1 = Line to unpack
0181                                                   ; / i  parm2 = Target row in frame buffer
0182               
0183 68C2 05A0  34         inc   @parm1                ; Next line in editor buffer
     68C4 8350 
0184 68C6 05A0  34         inc   @parm2                ; Next row in frame buffer
     68C8 8352 
0185                       ;------------------------------------------------------
0186                       ; Last row in editor buffer reached ?
0187                       ;------------------------------------------------------
0188 68CA 8820  54         c     @parm1,@edb.lines
     68CC 8350 
     68CE A204 
0189 68D0 1112  14         jlt   !                     ; no, do next check
0190                                                   ; yes, erase until end of frame buffer
0191                       ;------------------------------------------------------
0192                       ; Erase until end of frame buffer
0193                       ;------------------------------------------------------
0194               fb.refresh.erase_eob:
0195 68D2 C120  34         mov   @parm2,tmp0           ; Current row
     68D4 8352 
0196 68D6 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     68D8 A118 
0197 68DA 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0198 68DC 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     68DE A10E 
0199               
0200 68E0 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0201 68E2 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0202               
0203 68E4 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     68E6 A10E 
0204 68E8 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     68EA A100 
0205               
0206 68EC C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0207 68EE 04C5  14         clr   tmp1                  ; Clear with >00 character
0208               
0209 68F0 06A0  32         bl    @xfilm                ; \ Fill memory
     68F2 2236 
0210                                                   ; | i  tmp0 = Memory start address
0211                                                   ; | i  tmp1 = Byte to fill
0212                                                   ; / i  tmp2 = Number of bytes to fill
0213 68F4 1004  14         jmp   fb.refresh.exit
0214                       ;------------------------------------------------------
0215                       ; Bottom row in frame buffer reached ?
0216                       ;------------------------------------------------------
0217 68F6 8820  54 !       c     @parm2,@fb.scrrows
     68F8 8352 
     68FA A118 
0218 68FC 11E0  14         jlt   fb.refresh.unpack_line
0219                                                   ; No, unpack next line
0220                       ;------------------------------------------------------
0221                       ; Exit
0222                       ;------------------------------------------------------
0223               fb.refresh.exit:
0224 68FE 0720  34         seto  @fb.dirty             ; Refresh screen
     6900 A116 
0225 6902 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0226 6904 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0227 6906 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0228 6908 C2F9  30         mov   *stack+,r11           ; Pop r11
0229 690A 045B  20         b     *r11                  ; Return to caller
0230               
0231               
0232               ***************************************************************
0233               * fb.get.firstnonblank
0234               * Get column of first non-blank character in specified line
0235               ***************************************************************
0236               * bl @fb.get.firstnonblank
0237               *--------------------------------------------------------------
0238               * OUTPUT
0239               * @outparm1 = Column containing first non-blank character
0240               * @outparm2 = Character
0241               ********|*****|*********************|**************************
0242               fb.get.firstnonblank:
0243 690C 0649  14         dect  stack
0244 690E C64B  30         mov   r11,*stack            ; Save return address
0245                       ;------------------------------------------------------
0246                       ; Prepare for scanning
0247                       ;------------------------------------------------------
0248 6910 04E0  34         clr   @fb.column
     6912 A10C 
0249 6914 06A0  32         bl    @fb.calc_pointer
     6916 6880 
0250 6918 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     691A 6DB4 
0251 691C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     691E A108 
0252 6920 1313  14         jeq   fb.get.firstnonblank.nomatch
0253                                                   ; Exit if empty line
0254 6922 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6924 A102 
0255 6926 04C5  14         clr   tmp1
0256                       ;------------------------------------------------------
0257                       ; Scan line for non-blank character
0258                       ;------------------------------------------------------
0259               fb.get.firstnonblank.loop:
0260 6928 D174  28         movb  *tmp0+,tmp1           ; Get character
0261 692A 130E  14         jeq   fb.get.firstnonblank.nomatch
0262                                                   ; Exit if empty line
0263 692C 0285  22         ci    tmp1,>2000            ; Whitespace?
     692E 2000 
0264 6930 1503  14         jgt   fb.get.firstnonblank.match
0265 6932 0606  14         dec   tmp2                  ; Counter--
0266 6934 16F9  14         jne   fb.get.firstnonblank.loop
0267 6936 1008  14         jmp   fb.get.firstnonblank.nomatch
0268                       ;------------------------------------------------------
0269                       ; Non-blank character found
0270                       ;------------------------------------------------------
0271               fb.get.firstnonblank.match:
0272 6938 6120  34         s     @fb.current,tmp0      ; Calculate column
     693A A102 
0273 693C 0604  14         dec   tmp0
0274 693E C804  38         mov   tmp0,@outparm1        ; Save column
     6940 8360 
0275 6942 D805  38         movb  tmp1,@outparm2        ; Save character
     6944 8362 
0276 6946 1004  14         jmp   fb.get.firstnonblank.exit
0277                       ;------------------------------------------------------
0278                       ; No non-blank character found
0279                       ;------------------------------------------------------
0280               fb.get.firstnonblank.nomatch:
0281 6948 04E0  34         clr   @outparm1             ; X=0
     694A 8360 
0282 694C 04E0  34         clr   @outparm2             ; Null
     694E 8362 
0283                       ;------------------------------------------------------
0284                       ; Exit
0285                       ;------------------------------------------------------
0286               fb.get.firstnonblank.exit:
0287 6950 C2F9  30         mov   *stack+,r11           ; Pop r11
0288 6952 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0109                       copy  "idx.asm"             ; Index management
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
0050 6954 0649  14         dect  stack
0051 6956 C64B  30         mov   r11,*stack            ; Save return address
0052 6958 0649  14         dect  stack
0053 695A C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 695C 0204  20         li    tmp0,idx.top
     695E B000 
0058 6960 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6962 A202 
0059               
0060 6964 C120  34         mov   @tv.sams.b000,tmp0
     6966 A006 
0061 6968 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     696A A500 
0062 696C C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     696E A502 
0063 6970 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     6972 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 6974 06A0  32         bl    @film
     6976 2230 
0068 6978 B000                   data idx.top,>00,idx.size
     697A 0000 
     697C 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 697E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 6980 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6982 045B  20         b     *r11                  ; Return to caller
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
0100 6984 0649  14         dect  stack
0101 6986 C64B  30         mov   r11,*stack            ; Push return address
0102 6988 0649  14         dect  stack
0103 698A C644  30         mov   tmp0,*stack           ; Push tmp0
0104 698C 0649  14         dect  stack
0105 698E C645  30         mov   tmp1,*stack           ; Push tmp1
0106 6990 0649  14         dect  stack
0107 6992 C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6994 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6996 A502 
0112 6998 0205  20         li    tmp1,idx.top
     699A B000 
0113               
0114 699C C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     699E A504 
0115 69A0 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 69A2 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     69A4 A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 69A6 0286  22         ci    tmp2,5                ; Crash if too many index pages
     69A8 0005 
0121 69AA 1104  14         jlt   !
0122 69AC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     69AE FFCE 
0123 69B0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     69B2 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 69B4 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     69B6 2528 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 69B8 0584  14         inc   tmp0                  ; Next SAMS index page
0132 69BA 0225  22         ai    tmp1,>1000            ; Next memory region
     69BC 1000 
0133 69BE 0606  14         dec   tmp2                  ; Update loop counter
0134 69C0 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 69C2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 69C4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 69C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 69C8 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 69CA 045B  20         b     *r11                  ; Return to caller
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
0159 69CC 0649  14         dect  stack
0160 69CE C64B  30         mov   r11,*stack            ; Push return address
0161 69D0 0649  14         dect  stack
0162 69D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0163 69D4 0649  14         dect  stack
0164 69D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0165 69D8 0649  14         dect  stack
0166 69DA C646  30         mov   tmp2,*stack           ; Push tmp2
0167 69DC 0649  14         dect  stack
0168 69DE C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 69E0 0205  20         li    tmp1,idx.top
     69E2 B000 
0173 69E4 0206  20         li    tmp2,5                ; Always 5 pages
     69E6 0005 
0174 69E8 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     69EA A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 69EC C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 69EE 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     69F0 2528 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 69F2 0225  22         ai    tmp1,>1000            ; Next memory region
     69F4 1000 
0185 69F6 0606  14         dec   tmp2                  ; Update loop counter
0186 69F8 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 69FA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 69FC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 69FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6A00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6A02 C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6A04 045B  20         b     *r11                  ; Return to caller
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
0220 6A06 0649  14         dect  stack
0221 6A08 C64B  30         mov   r11,*stack            ; Save return address
0222 6A0A 0649  14         dect  stack
0223 6A0C C644  30         mov   tmp0,*stack           ; Push tmp0
0224 6A0E 0649  14         dect  stack
0225 6A10 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6A12 0649  14         dect  stack
0227 6A14 C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6A16 C184  18         mov   tmp0,tmp2             ; Line number
0232 6A18 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6A1A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6A1C 0800 
0234               
0235 6A1E 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 6A20 0A16  56         sla   tmp2,1                ; line number * 2
0240 6A22 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6A24 8360 
0241               
0242 6A26 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6A28 A502 
0243 6A2A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6A2C A500 
0244               
0245 6A2E 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 6A30 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6A32 A500 
0251 6A34 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     6A36 A006 
0252               
0253 6A38 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6A3A 0205  20         li    tmp1,>b000            ; Memory window for index page
     6A3C B000 
0255               
0256 6A3E 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6A40 2528 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 6A42 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     6A44 A504 
0263 6A46 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 6A48 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6A4A A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 6A4C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 6A4E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6A50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6A52 C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6A54 045B  20         b     *r11                  ; Return to caller
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
0295 6A56 0649  14         dect  stack
0296 6A58 C64B  30         mov   r11,*stack            ; Save return address
0297 6A5A 0649  14         dect  stack
0298 6A5C C644  30         mov   tmp0,*stack           ; Push tmp0
0299 6A5E 0649  14         dect  stack
0300 6A60 C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 6A62 C120  34         mov   @parm1,tmp0           ; Get line number
     6A64 8350 
0305 6A66 C160  34         mov   @parm2,tmp1           ; Get pointer
     6A68 8352 
0306 6A6A 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 6A6C 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6A6E 0FFF 
0312 6A70 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 6A72 06E0  34         swpb  @parm3
     6A74 8354 
0317 6A76 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6A78 8354 
0318 6A7A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6A7C 8354 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 6A7E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A80 6A06 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 6A82 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6A84 8360 
0329 6A86 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6A88 B000 
0330 6A8A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A8C 8360 
0331 6A8E 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 6A90 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6A92 6A06 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 6A94 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6A96 8360 
0341 6A98 04E4  34         clr   @idx.top(tmp0)        ; /
     6A9A B000 
0342 6A9C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6A9E 8360 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 6AA0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6AA2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6AA4 C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6AA6 045B  20         b     *r11                  ; Return to caller
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
0373 6AA8 0649  14         dect  stack
0374 6AAA C64B  30         mov   r11,*stack            ; Save return address
0375 6AAC 0649  14         dect  stack
0376 6AAE C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6AB0 0649  14         dect  stack
0378 6AB2 C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6AB4 0649  14         dect  stack
0380 6AB6 C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6AB8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6ABA 8350 
0385               
0386 6ABC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6ABE 6A06 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6AC0 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6AC2 8360 
0391 6AC4 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6AC6 B000 
0392               
0393 6AC8 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6ACA C185  18         mov   tmp1,tmp2             ; \
0399 6ACC 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6ACE 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6AD0 00FF 
0404 6AD2 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6AD4 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6AD6 C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6AD8 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6ADA 8360 
0411 6ADC C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6ADE 8362 
0412 6AE0 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6AE2 04E0  34         clr   @outparm1
     6AE4 8360 
0418 6AE6 04E0  34         clr   @outparm2
     6AE8 8362 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6AEA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6AEC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6AEE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6AF0 C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6AF2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0110                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0025 6AF4 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6AF6 B000 
0026 6AF8 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6AFA 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6AFC CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6AFE 0606  14         dec   tmp2                  ; tmp2--
0034 6B00 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6B02 045B  20         b     *r11                  ; Return to caller
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
0054 6B04 0649  14         dect  stack
0055 6B06 C64B  30         mov   r11,*stack            ; Save return address
0056 6B08 0649  14         dect  stack
0057 6B0A C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6B0C 0649  14         dect  stack
0059 6B0E C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6B10 0649  14         dect  stack
0061 6B12 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6B14 0649  14         dect  stack
0063 6B16 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6B18 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B1A 8350 
0068               
0069 6B1C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B1E 6A06 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6B20 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B22 8360 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6B24 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B26 8352 
0078 6B28 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6B2A 8350 
0079 6B2C 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6B2E C1E0  34         mov   @parm2,tmp3
     6B30 8352 
0086 6B32 0287  22         ci    tmp3,2048
     6B34 0800 
0087 6B36 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6B38 06A0  32         bl    @_idx.sams.mapcolumn.on
     6B3A 6984 
0095                                                   ; Index in continious memory region
0096               
0097 6B3C 06A0  32         bl    @_idx.entry.delete.reorg
     6B3E 6AF4 
0098                                                   ; Reorganize index
0099               
0100               
0101 6B40 06A0  32         bl    @_idx.sams.mapcolumn.off
     6B42 69CC 
0102                                                   ; Restore memory window layout
0103               
0104 6B44 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6B46 06A0  32         bl    @_idx.entry.delete.reorg
     6B48 6AF4 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6B4A 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6B4C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6B4E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6B50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6B52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6B54 C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6B56 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0111                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0025 6B58 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6B5A 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6B5C 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6B5E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6B60 FFCE 
0034 6B62 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6B64 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6B66 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6B68 B000 
0039 6B6A C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6B6C 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6B6E 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6B70 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6B72 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6B74 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6B76 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6B78 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6B7A AFFE 
0050 6B7C 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6B7E C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6B80 0644  14         dect  tmp0                  ; Move pointer up
0058 6B82 0645  14         dect  tmp1                  ; Move pointer up
0059 6B84 0606  14         dec   tmp2                  ; Next index entry
0060 6B86 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6B88 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6B8A 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6B8C 045B  20         b     *r11                  ; Return to caller
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
0090 6B8E 0649  14         dect  stack
0091 6B90 C64B  30         mov   r11,*stack            ; Save return address
0092 6B92 0649  14         dect  stack
0093 6B94 C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6B96 0649  14         dect  stack
0095 6B98 C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6B9A 0649  14         dect  stack
0097 6B9C C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6B9E 0649  14         dect  stack
0099 6BA0 C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6BA2 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6BA4 8352 
0104 6BA6 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BA8 8350 
0105 6BAA 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6BAC C1E0  34         mov   @parm2,tmp3
     6BAE 8352 
0112 6BB0 0287  22         ci    tmp3,2048
     6BB2 0800 
0113 6BB4 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6BB6 06A0  32         bl    @_idx.sams.mapcolumn.on
     6BB8 6984 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6BBA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6BBC 8352 
0125 6BBE 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6BC0 06A0  32         bl    @_idx.entry.insert.reorg
     6BC2 6B58 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6BC4 06A0  32         bl    @_idx.sams.mapcolumn.off
     6BC6 69CC 
0133                                                   ; Restore memory window layout
0134               
0135 6BC8 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6BCA C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6BCC 8352 
0141               
0142 6BCE 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BD0 6A06 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6BD2 C120  34         mov   @outparm1,tmp0        ; Index offset
     6BD4 8360 
0147               
0148 6BD6 06A0  32         bl    @_idx.entry.insert.reorg
     6BD8 6B58 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6BDA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6BDC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6BDE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6BE0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6BE2 C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6BE4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0112                       copy  "edb.asm"             ; Editor Buffer
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
0026 6BE6 0649  14         dect  stack
0027 6BE8 C64B  30         mov   r11,*stack            ; Save return address
0028 6BEA 0649  14         dect  stack
0029 6BEC C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6BEE 0204  20         li    tmp0,edb.top          ; \
     6BF0 C000 
0034 6BF2 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6BF4 A200 
0035 6BF6 C804  38         mov   tmp0,@edb.next_free.ptr
     6BF8 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6BFA 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6BFC A20A 
0039 6BFE 04E0  34         clr   @edb.lines            ; Lines=0
     6C00 A204 
0040 6C02 04E0  34         clr   @edb.rle              ; RLE compression off
     6C04 A20C 
0041               
0042 6C06 0204  20         li    tmp0,txt.newfile      ; "New file"
     6C08 3106 
0043 6C0A C804  38         mov   tmp0,@edb.filename.ptr
     6C0C A20E 
0044               
0045 6C0E 0204  20         li    tmp0,txt.filetype.none
     6C10 3118 
0046 6C12 C804  38         mov   tmp0,@edb.filetype.ptr
     6C14 A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6C16 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6C18 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6C1A 045B  20         b     *r11                  ; Return to caller
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
0081 6C1C 0649  14         dect  stack
0082 6C1E C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6C20 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6C22 A10C 
     6C24 8390 
0087 6C26 04E0  34         clr   @fb.column
     6C28 A10C 
0088 6C2A 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6C2C 6880 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6C2E 04C4  14         clr   tmp0                  ; Counter
0093 6C30 C160  34         mov   @fb.current,tmp1      ; Get position
     6C32 A102 
0094 6C34 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6C36 8392 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6C38 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6C3A 0986  56         srl   tmp2,8                ; Right justify
0102 6C3C 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6C3E 0584  14         inc   tmp0                  ; Increase string length
0104 6C40 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6C42 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6C44 A104 
     6C46 8350 
0111 6C48 A820  54         a     @fb.row,@parm1        ; /
     6C4A A106 
     6C4C 8350 
0112               
0113 6C4E C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6C50 8394 
0114               
0115                       ;------------------------------------------------------
0116                       ; 1. Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6C52 C120  34         mov   @edb.next_free.ptr,tmp0
     6C54 A208 
0120 6C56 C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6C58 8352 
0121               
0122 6C5A 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6C5C 24F0 
0123                                                   ; \ i  tmp0  = Memory address
0124                                                   ; | o  waux1 = SAMS page number
0125                                                   ; / o  waux2 = Address of SAMS register
0126               
0127 6C5E C820  54         mov   @waux1,@parm3         ; Setup parm3
     6C60 833C 
     6C62 8354 
0128               
0129 6C64 06A0  32         bl    @idx.entry.update     ; Update index
     6C66 6A56 
0130                                                   ; \ i  parm1 = Line number in editor buffer
0131                                                   ; | i  parm2 = pointer to line in
0132                                                   ; |            editor buffer
0133                                                   ; / i  parm3 = SAMS page
0134               
0135                       ;------------------------------------------------------
0136                       ; 2. Switch to required SAMS page
0137                       ;------------------------------------------------------
0138 6C68 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6C6A A212 
     6C6C 8354 
0139 6C6E 1308  14         jeq   !                     ; Yes, skip setting page
0140               
0141 6C70 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6C72 8354 
0142 6C74 C160  34         mov   @edb.next_free.ptr,tmp1
     6C76 A208 
0143                                                   ; Pointer to line in editor buffer
0144 6C78 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6C7A 2528 
0145                                                   ; \ i  tmp0 = SAMS page
0146                                                   ; / i  tmp1 = Memory address
0147               
0148 6C7C C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6C7E A438 
0149                                                   ; TODO - Why is @fh.xxx accessed here?
0150               
0151                       ;------------------------------------------------------
0152                       ; 3. Set line prefix in editor buffer
0153                       ;------------------------------------------------------
0154 6C80 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6C82 8392 
0155 6C84 C160  34         mov   @edb.next_free.ptr,tmp1
     6C86 A208 
0156                                                   ; Address of line in editor buffer
0157               
0158 6C88 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6C8A A208 
0159               
0160 6C8C C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6C8E 8394 
0161 6C90 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0162 6C92 06C6  14         swpb  tmp2
0163 6C94 DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0164 6C96 06C6  14         swpb  tmp2
0165 6C98 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0166               
0167                       ;------------------------------------------------------
0168                       ; 4. Copy line from framebuffer to editor buffer
0169                       ;------------------------------------------------------
0170               edb.line.pack.copyline:
0171 6C9A 0286  22         ci    tmp2,2
     6C9C 0002 
0172 6C9E 1603  14         jne   edb.line.pack.copyline.checkbyte
0173 6CA0 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0174 6CA2 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0175 6CA4 1007  14         jmp   !
0176               
0177               edb.line.pack.copyline.checkbyte:
0178 6CA6 0286  22         ci    tmp2,1
     6CA8 0001 
0179 6CAA 1602  14         jne   edb.line.pack.copyline.block
0180 6CAC D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0181 6CAE 1002  14         jmp   !
0182               
0183               edb.line.pack.copyline.block:
0184 6CB0 06A0  32         bl    @xpym2m               ; Copy memory block
     6CB2 2492 
0185                                                   ; \ i  tmp0 = source
0186                                                   ; | i  tmp1 = destination
0187                                                   ; / i  tmp2 = bytes to copy
0188                       ;------------------------------------------------------
0189                       ; 5: Align pointer to multiple of 16 memory address
0190                       ;------------------------------------------------------
0191 6CB4 A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6CB6 8394 
     6CB8 A208 
0192                                                      ; Add length of line
0193               
0194 6CBA C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6CBC A208 
0195 6CBE 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0196 6CC0 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6CC2 000F 
0197 6CC4 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6CC6 A208 
0198                       ;------------------------------------------------------
0199                       ; Exit
0200                       ;------------------------------------------------------
0201               edb.line.pack.exit:
0202 6CC8 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6CCA 8390 
     6CCC A10C 
0203 6CCE C2F9  30         mov   *stack+,r11           ; Pop R11
0204 6CD0 045B  20         b     *r11                  ; Return to caller
0205               
0206               
0207               
0208               
0209               ***************************************************************
0210               * edb.line.unpack
0211               * Unpack specified line to framebuffer
0212               ***************************************************************
0213               *  bl   @edb.line.unpack
0214               *--------------------------------------------------------------
0215               * INPUT
0216               * @parm1 = Line to unpack in editor buffer
0217               * @parm2 = Target row in frame buffer
0218               *--------------------------------------------------------------
0219               * OUTPUT
0220               * none
0221               *--------------------------------------------------------------
0222               * Register usage
0223               * tmp0,tmp1,tmp2
0224               *--------------------------------------------------------------
0225               * Memory usage
0226               * rambuf    = Saved @parm1 of edb.line.unpack
0227               * rambuf+2  = Saved @parm2 of edb.line.unpack
0228               * rambuf+4  = Source memory address in editor buffer
0229               * rambuf+6  = Destination memory address in frame buffer
0230               * rambuf+8  = Length of line
0231               ********|*****|*********************|**************************
0232               edb.line.unpack:
0233 6CD2 0649  14         dect  stack
0234 6CD4 C64B  30         mov   r11,*stack            ; Save return address
0235 6CD6 0649  14         dect  stack
0236 6CD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0237 6CDA 0649  14         dect  stack
0238 6CDC C645  30         mov   tmp1,*stack           ; Push tmp1
0239 6CDE 0649  14         dect  stack
0240 6CE0 C646  30         mov   tmp2,*stack           ; Push tmp2
0241                       ;------------------------------------------------------
0242                       ; Sanity check
0243                       ;------------------------------------------------------
0244 6CE2 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6CE4 8350 
     6CE6 A204 
0245 6CE8 1104  14         jlt   !
0246 6CEA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CEC FFCE 
0247 6CEE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CF0 2030 
0248                       ;------------------------------------------------------
0249                       ; Save parameters
0250                       ;------------------------------------------------------
0251 6CF2 C820  54 !       mov   @parm1,@rambuf
     6CF4 8350 
     6CF6 8390 
0252 6CF8 C820  54         mov   @parm2,@rambuf+2
     6CFA 8352 
     6CFC 8392 
0253                       ;------------------------------------------------------
0254                       ; Calculate offset in frame buffer
0255                       ;------------------------------------------------------
0256 6CFE C120  34         mov   @fb.colsline,tmp0
     6D00 A10E 
0257 6D02 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6D04 8352 
0258 6D06 C1A0  34         mov   @fb.top.ptr,tmp2
     6D08 A100 
0259 6D0A A146  18         a     tmp2,tmp1             ; Add base to offset
0260 6D0C C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6D0E 8396 
0261                       ;------------------------------------------------------
0262                       ; Get pointer to line & page-in editor buffer page
0263                       ;------------------------------------------------------
0264 6D10 C120  34         mov   @parm1,tmp0
     6D12 8350 
0265 6D14 06A0  32         bl    @xmem.edb.sams.mappage
     6D16 67EA 
0266                                                   ; Activate editor buffer SAMS page for line
0267                                                   ; \ i  tmp0     = Line number
0268                                                   ; | o  outparm1 = Pointer to line
0269                                                   ; / o  outparm2 = SAMS page
0270               
0271 6D18 C820  54         mov   @outparm2,@edb.sams.page
     6D1A 8362 
     6D1C A212 
0272                                                   ; Save current SAMS page
0273                       ;------------------------------------------------------
0274                       ; Handle empty line
0275                       ;------------------------------------------------------
0276 6D1E C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6D20 8360 
0277 6D22 1603  14         jne   !                     ; Check if pointer is set
0278 6D24 04E0  34         clr   @rambuf+8             ; Set length=0
     6D26 8398 
0279 6D28 100F  14         jmp   edb.line.unpack.clear
0280                       ;------------------------------------------------------
0281                       ; Get line length
0282                       ;------------------------------------------------------
0283 6D2A C154  26 !       mov   *tmp0,tmp1            ; Get line length
0284 6D2C C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6D2E 8398 
0285               
0286 6D30 05E0  34         inct  @outparm1             ; Skip line prefix
     6D32 8360 
0287 6D34 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6D36 8360 
     6D38 8394 
0288                       ;------------------------------------------------------
0289                       ; Sanity check on line length
0290                       ;------------------------------------------------------
0291 6D3A 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6D3C 0050 
0292 6D3E 1204  14         jle   edb.line.unpack.clear ; /
0293               
0294 6D40 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D42 FFCE 
0295 6D44 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D46 2030 
0296                       ;------------------------------------------------------
0297                       ; Erase chars from last column until column 80
0298                       ;------------------------------------------------------
0299               edb.line.unpack.clear:
0300 6D48 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6D4A 8396 
0301 6D4C A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6D4E 8398 
0302               
0303 6D50 04C5  14         clr   tmp1                  ; Fill with >00
0304 6D52 C1A0  34         mov   @fb.colsline,tmp2
     6D54 A10E 
0305 6D56 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6D58 8398 
0306 6D5A 0586  14         inc   tmp2
0307               
0308 6D5C 06A0  32         bl    @xfilm                ; Fill CPU memory
     6D5E 2236 
0309                                                   ; \ i  tmp0 = Target address
0310                                                   ; | i  tmp1 = Byte to fill
0311                                                   ; / i  tmp2 = Repeat count
0312                       ;------------------------------------------------------
0313                       ; Prepare for unpacking data
0314                       ;------------------------------------------------------
0315               edb.line.unpack.prepare:
0316 6D60 C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6D62 8398 
0317 6D64 130D  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0318 6D66 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6D68 8394 
0319 6D6A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6D6C 8396 
0320                       ;------------------------------------------------------
0321                       ; Check before copy
0322                       ;------------------------------------------------------
0323               edb.line.unpack.copy:
0324 6D6E 0286  22         ci    tmp2,80               ; Check line length
     6D70 0050 
0325 6D72 1204  14         jle   !
0326 6D74 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D76 FFCE 
0327 6D78 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D7A 2030 
0328                       ;------------------------------------------------------
0329                       ; Copy memory block
0330                       ;------------------------------------------------------
0331 6D7C 06A0  32 !       bl    @xpym2m               ; Copy line to frame buffer
     6D7E 2492 
0332                                                   ; \ i  tmp0 = Source address
0333                                                   ; | i  tmp1 = Target address
0334                                                   ; / i  tmp2 = Bytes to copy
0335                       ;------------------------------------------------------
0336                       ; Exit
0337                       ;------------------------------------------------------
0338               edb.line.unpack.exit:
0339 6D80 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0340 6D82 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0341 6D84 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0342 6D86 C2F9  30         mov   *stack+,r11           ; Pop r11
0343 6D88 045B  20         b     *r11                  ; Return to caller
0344               
0345               
0346               
0347               ***************************************************************
0348               * edb.line.getlength
0349               * Get length of specified line
0350               ***************************************************************
0351               *  bl   @edb.line.getlength
0352               *--------------------------------------------------------------
0353               * INPUT
0354               * @parm1 = Line number
0355               *--------------------------------------------------------------
0356               * OUTPUT
0357               * @outparm1 = Length of line
0358               * @outparm2 = SAMS page
0359               *--------------------------------------------------------------
0360               * Register usage
0361               * tmp0,tmp1
0362               *--------------------------------------------------------------
0363               * Remarks
0364               * Expects that the affected SAMS page is already paged-in!
0365               ********|*****|*********************|**************************
0366               edb.line.getlength:
0367 6D8A 0649  14         dect  stack
0368 6D8C C64B  30         mov   r11,*stack            ; Push return address
0369 6D8E 0649  14         dect  stack
0370 6D90 C644  30         mov   tmp0,*stack           ; Push tmp0
0371 6D92 0649  14         dect  stack
0372 6D94 C645  30         mov   tmp1,*stack           ; Push tmp1
0373                       ;------------------------------------------------------
0374                       ; Initialisation
0375                       ;------------------------------------------------------
0376 6D96 04E0  34         clr   @outparm1             ; Reset length
     6D98 8360 
0377 6D9A 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6D9C 8362 
0378                       ;------------------------------------------------------
0379                       ; Get length
0380                       ;------------------------------------------------------
0381 6D9E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6DA0 6AA8 
0382                                                   ; \ i  parm1    = Line number
0383                                                   ; | o  outparm1 = Pointer to line
0384                                                   ; / o  outparm2 = SAMS page
0385               
0386 6DA2 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6DA4 8360 
0387 6DA6 1302  14         jeq   edb.line.getlength.exit
0388                                                   ; Exit early if NULL pointer
0389                       ;------------------------------------------------------
0390                       ; Process line prefix
0391                       ;------------------------------------------------------
0392 6DA8 C814  46         mov   *tmp0,@outparm1       ; Save length
     6DAA 8360 
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               edb.line.getlength.exit:
0397 6DAC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0398 6DAE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0399 6DB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0400 6DB2 045B  20         b     *r11                  ; Return to caller
0401               
0402               
0403               
0404               ***************************************************************
0405               * edb.line.getlength2
0406               * Get length of current row (as seen from editor buffer side)
0407               ***************************************************************
0408               *  bl   @edb.line.getlength2
0409               *--------------------------------------------------------------
0410               * INPUT
0411               * @fb.row = Row in frame buffer
0412               *--------------------------------------------------------------
0413               * OUTPUT
0414               * @fb.row.length = Length of row
0415               *--------------------------------------------------------------
0416               * Register usage
0417               * tmp0
0418               ********|*****|*********************|**************************
0419               edb.line.getlength2:
0420 6DB4 0649  14         dect  stack
0421 6DB6 C64B  30         mov   r11,*stack            ; Save return address
0422                       ;------------------------------------------------------
0423                       ; Calculate line in editor buffer
0424                       ;------------------------------------------------------
0425 6DB8 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6DBA A104 
0426 6DBC A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6DBE A106 
0427                       ;------------------------------------------------------
0428                       ; Get length
0429                       ;------------------------------------------------------
0430 6DC0 C804  38         mov   tmp0,@parm1
     6DC2 8350 
0431 6DC4 06A0  32         bl    @edb.line.getlength
     6DC6 6D8A 
0432 6DC8 C820  54         mov   @outparm1,@fb.row.length
     6DCA 8360 
     6DCC A108 
0433                                                   ; Save row length
0434                       ;------------------------------------------------------
0435                       ; Exit
0436                       ;------------------------------------------------------
0437               edb.line.getlength2.exit:
0438 6DCE C2F9  30         mov   *stack+,r11           ; Pop R11
0439 6DD0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0113                       ;-----------------------------------------------------------------------
0114                       ; Command buffer handling
0115                       ;-----------------------------------------------------------------------
0116                       copy  "cmdb.asm"            ; Command buffer shared code
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
0027 6DD2 0649  14         dect  stack
0028 6DD4 C64B  30         mov   r11,*stack            ; Save return address
0029 6DD6 0649  14         dect  stack
0030 6DD8 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6DDA 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6DDC D000 
0035 6DDE C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6DE0 A300 
0036               
0037 6DE2 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6DE4 A302 
0038 6DE6 0204  20         li    tmp0,4
     6DE8 0004 
0039 6DEA C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6DEC A306 
0040 6DEE C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6DF0 A308 
0041               
0042 6DF2 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6DF4 A316 
0043 6DF6 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6DF8 A318 
0044                       ;------------------------------------------------------
0045                       ; Clear command buffer
0046                       ;------------------------------------------------------
0047 6DFA 06A0  32         bl    @film
     6DFC 2230 
0048 6DFE D000             data  cmdb.top,>00,cmdb.size
     6E00 0000 
     6E02 1000 
0049                                                   ; Clear it all the way
0050               cmdb.init.exit:
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054 6E04 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0055 6E06 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 6E08 045B  20         b     *r11                  ; Return to caller
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
0082 6E0A 0649  14         dect  stack
0083 6E0C C64B  30         mov   r11,*stack            ; Save return address
0084 6E0E 0649  14         dect  stack
0085 6E10 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 6E12 0649  14         dect  stack
0087 6E14 C645  30         mov   tmp1,*stack           ; Push tmp1
0088 6E16 0649  14         dect  stack
0089 6E18 C646  30         mov   tmp2,*stack           ; Push tmp2
0090                       ;------------------------------------------------------
0091                       ; Dump Command buffer content
0092                       ;------------------------------------------------------
0093 6E1A C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6E1C 832A 
     6E1E A30C 
0094 6E20 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6E22 A310 
     6E24 832A 
0095               
0096 6E26 05A0  34         inc   @wyx                  ; X +1 for prompt
     6E28 832A 
0097               
0098 6E2A 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6E2C 23F4 
0099                                                   ; \ i  @wyx = Cursor position
0100                                                   ; / o  tmp0 = VDP target address
0101               
0102 6E2E 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6E30 A323 
0103 6E32 0206  20         li    tmp2,1*79             ; Command length
     6E34 004F 
0104               
0105 6E36 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6E38 244A 
0106                                                   ; | i  tmp0 = VDP target address
0107                                                   ; | i  tmp1 = RAM source address
0108                                                   ; / i  tmp2 = Number of bytes to copy
0109                       ;------------------------------------------------------
0110                       ; Show command buffer prompt
0111                       ;------------------------------------------------------
0112 6E3A C820  54         mov   @cmdb.yxprompt,@wyx
     6E3C A310 
     6E3E 832A 
0113 6E40 06A0  32         bl    @putstr
     6E42 2418 
0114 6E44 32D0                   data txt.cmdb.prompt
0115               
0116 6E46 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6E48 A30C 
     6E4A A114 
0117 6E4C C820  54         mov   @cmdb.yxsave,@wyx
     6E4E A30C 
     6E50 832A 
0118                                                   ; Restore YX position
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122               cmdb.refresh.exit:
0123 6E52 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0124 6E54 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0125 6E56 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0126 6E58 C2F9  30         mov   *stack+,r11           ; Pop r11
0127 6E5A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0117                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
0001               * FILE......: cmdb_cmd.asm
0002               * Purpose...: Stevie Editor - Command line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Command line handling
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cmdb.cmd.clear
0010               * Clear current command
0011               ***************************************************************
0012               * bl @cmdb.cmd.clear
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1,tmp2
0022               *--------------------------------------------------------------
0023               * Notes
0024               ********|*****|*********************|**************************
0025               cmdb.cmd.clear:
0026 6E5C 0649  14         dect  stack
0027 6E5E C64B  30         mov   r11,*stack            ; Save return address
0028 6E60 0649  14         dect  stack
0029 6E62 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6E64 0649  14         dect  stack
0031 6E66 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6E68 0649  14         dect  stack
0033 6E6A C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Clear command
0036                       ;------------------------------------------------------
0037 6E6C 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6E6E A322 
0038 6E70 06A0  32         bl    @film                 ; Clear command
     6E72 2230 
0039 6E74 A323                   data  cmdb.cmd,>00,80
     6E76 0000 
     6E78 0050 
0040                       ;------------------------------------------------------
0041                       ; Put cursor at beginning of line
0042                       ;------------------------------------------------------
0043 6E7A C120  34         mov   @cmdb.yxprompt,tmp0
     6E7C A310 
0044 6E7E 0584  14         inc   tmp0
0045 6E80 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6E82 A30A 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               cmdb.cmd.clear.exit:
0050 6E84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0051 6E86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 6E88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6E8A C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6E8C 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               
0060               
0061               ***************************************************************
0062               * cmdb.cmdb.getlength
0063               * Get length of current command
0064               ***************************************************************
0065               * bl @cmdb.cmd.getlength
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * @cmdb.cmd
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               * @outparm1
0072               *--------------------------------------------------------------
0073               * Register usage
0074               * none
0075               *--------------------------------------------------------------
0076               * Notes
0077               ********|*****|*********************|**************************
0078               cmdb.cmd.getlength:
0079 6E8E 0649  14         dect  stack
0080 6E90 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;-------------------------------------------------------
0082                       ; Get length of null terminated string
0083                       ;-------------------------------------------------------
0084 6E92 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6E94 2A76 
0085 6E96 A323                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6E98 0000 
0086                                                  ; | i  p1    = Termination character
0087                                                  ; / o  waux1 = Length of string
0088 6E9A C820  54         mov   @waux1,@outparm1     ; Save length of string
     6E9C 833C 
     6E9E 8360 
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cmdb.cmd.getlength.exit:
0093 6EA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6EA2 045B  20         b     *r11                  ; Return to caller
0095               
0096               
0097               
0098               
0099               
0100               ***************************************************************
0101               * cmdb.cmd.addhist
0102               * Add command to history
0103               ***************************************************************
0104               * bl @cmdb.cmd.addhist
0105               *--------------------------------------------------------------
0106               * INPUT
0107               *
0108               * @cmdb.cmd
0109               *--------------------------------------------------------------
0110               * OUTPUT
0111               * @outparm1     (Length in LSB)
0112               *--------------------------------------------------------------
0113               * Register usage
0114               * tmp0
0115               *--------------------------------------------------------------
0116               * Notes
0117               ********|*****|*********************|**************************
0118               cmdb.cmd.history.add:
0119 6EA4 0649  14         dect  stack
0120 6EA6 C64B  30         mov   r11,*stack            ; Save return address
0121 6EA8 0649  14         dect  stack
0122 6EAA C644  30         mov   tmp0,*stack           ; Push tmp0
0123               
0124 6EAC 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6EAE 6E8E 
0125                                                   ; \ i  @cmdb.cmd
0126                                                   ; / o  @outparm1
0127                       ;------------------------------------------------------
0128                       ; Sanity check
0129                       ;------------------------------------------------------
0130 6EB0 C120  34         mov   @outparm1,tmp0        ; Check length
     6EB2 8360 
0131 6EB4 1300  14         jeq   cmdb.cmd.history.add.exit
0132                                                   ; Exit early if length = 0
0133                       ;------------------------------------------------------
0134                       ; Add command to history
0135                       ;------------------------------------------------------
0136               
0137               
0138               
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142               cmdb.cmd.history.add.exit:
0143 6EB6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 6EB8 C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6EBA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0118                       copy  "errline.asm"         ; Error line
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
0026 6EBC 0649  14         dect  stack
0027 6EBE C64B  30         mov   r11,*stack            ; Save return address
0028 6EC0 0649  14         dect  stack
0029 6EC2 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6EC4 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6EC6 A01E 
0034               
0035 6EC8 06A0  32         bl    @film
     6ECA 2230 
0036 6ECC A020                   data tv.error.msg,0,160
     6ECE 0000 
     6ED0 00A0 
0037               
0038 6ED2 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6ED4 A000 
0039 6ED6 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6ED8 A020 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6EDA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6EDC C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6EDE 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.37551
0119                       ;-----------------------------------------------------------------------
0120                       ; File handling
0121                       ;-----------------------------------------------------------------------
0122                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
**** **** ****     > fh.read.edb.asm
0001               * FILE......: fh.read.edb.asm
0002               * Purpose...: File reader module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.read.edb
0011               * Read file into editor buffer
0012               ***************************************************************
0013               *  bl   @fh.file.read.edb
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
0027               fh.file.read.edb:
0028 6EE0 0649  14         dect  stack
0029 6EE2 C64B  30         mov   r11,*stack            ; Save return address
0030 6EE4 0649  14         dect  stack
0031 6EE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6EE8 0649  14         dect  stack
0033 6EEA C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6EEC 0649  14         dect  stack
0035 6EEE C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6EF0 04E0  34         clr   @fh.records           ; Reset records counter
     6EF2 A42E 
0040 6EF4 04E0  34         clr   @fh.counter           ; Clear internal counter
     6EF6 A434 
0041 6EF8 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6EFA A432 
0042 6EFC 04E0  34         clr   @fh.kilobytes.prev    ; /
     6EFE A446 
0043 6F00 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6F02 A42A 
0044 6F04 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6F06 A42C 
0045               
0046 6F08 C120  34         mov   @edb.top.ptr,tmp0
     6F0A A200 
0047 6F0C 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6F0E 24F0 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6F10 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6F12 833C 
     6F14 A438 
0053 6F16 C820  54         mov   @waux1,@fh.sams.hipage
     6F18 833C 
     6F1A A43A 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6F1C 0204  20         li    tmp0,fh.fopmode.readfile
     6F1E 0001 
0059                                                   ; We are going to read a file
0060 6F20 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     6F22 A43C 
0061               
0062 6F24 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6F26 8350 
     6F28 A436 
0063 6F2A C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6F2C 8352 
     6F2E A43E 
0064 6F30 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6F32 8354 
     6F34 A440 
0065 6F36 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6F38 8356 
     6F3A A442 
0066 6F3C C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6F3E 8358 
     6F40 A444 
0067                       ;------------------------------------------------------
0068                       ; Sanity check
0069                       ;------------------------------------------------------
0070 6F42 C120  34         mov   @fh.callback1,tmp0
     6F44 A43E 
0071 6F46 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F48 6000 
0072 6F4A 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6F4C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F4E 7FFF 
0075 6F50 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6F52 C120  34         mov   @fh.callback2,tmp0
     6F54 A440 
0078 6F56 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F58 6000 
0079 6F5A 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6F5C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F5E 7FFF 
0082 6F60 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6F62 C120  34         mov   @fh.callback3,tmp0
     6F64 A442 
0085 6F66 0284  22         ci    tmp0,>6000            ; Insane address ?
     6F68 6000 
0086 6F6A 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0087               
0088 6F6C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6F6E 7FFF 
0089 6F70 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 6F72 1004  14         jmp   fh.file.read.edb.load1
0092                                                   ; All checks passed, continue.
0093                                                   ;--------------------------
0094                                                   ; Check failed, crash CPU!
0095                                                   ;--------------------------
0096               fh.file.read.crash:
0097 6F74 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6F76 FFCE 
0098 6F78 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6F7A 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.read.edb.load1:
0103 6F7C C120  34         mov   @fh.callback1,tmp0
     6F7E A43E 
0104 6F80 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.pabheader:
0109 6F82 06A0  32         bl    @cpym2v
     6F84 2444 
0110 6F86 0A60                   data fh.vpab,fh.file.pab.header,9
     6F88 70DA 
     6F8A 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 6F8C 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     6F8E 0A69 
0116 6F90 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     6F92 A436 
0117 6F94 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 6F96 0986  56         srl   tmp2,8                ; Right justify
0119 6F98 0586  14         inc   tmp2                  ; Include length byte as well
0120 6F9A 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     6F9C 244A 
0121                       ;------------------------------------------------------
0122                       ; Load GPL scratchpad layout
0123                       ;------------------------------------------------------
0124 6F9E 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     6FA0 2B46 
0125 6FA2 F100                   data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
0126                       ;------------------------------------------------------
0127                       ; Open file
0128                       ;------------------------------------------------------
0129 6FA4 06A0  32         bl    @file.open
     6FA6 2C94 
0130 6FA8 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0131 6FAA 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     6FAC 2026 
0132 6FAE 1602  14         jne   fh.file.read.edb.record
0133 6FB0 0460  28         b     @fh.file.read.edb.error
     6FB2 70A2 
0134                                                   ; Yes, IO error occured
0135                       ;------------------------------------------------------
0136                       ; Step 1: Read file record
0137                       ;------------------------------------------------------
0138               fh.file.read.edb.record:
0139 6FB4 05A0  34         inc   @fh.records           ; Update counter
     6FB6 A42E 
0140 6FB8 04E0  34         clr   @fh.reclen            ; Reset record length
     6FBA A430 
0141               
0142 6FBC 06A0  32         bl    @file.record.read     ; Read file record
     6FBE 2CA2 
0143 6FC0 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0144                                                   ; |           (without +9 offset!)
0145                                                   ; | o  tmp0 = Status byte
0146                                                   ; | o  tmp1 = Bytes read
0147                                                   ; | o  tmp2 = Status register contents
0148                                                   ; /           upon DSRLNK return
0149               
0150 6FC2 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6FC4 A42A 
0151 6FC6 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     6FC8 A430 
0152 6FCA C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     6FCC A42C 
0153                       ;------------------------------------------------------
0154                       ; 1a: Calculate kilobytes processed
0155                       ;------------------------------------------------------
0156 6FCE A805  38         a     tmp1,@fh.counter
     6FD0 A434 
0157 6FD2 A160  34         a     @fh.counter,tmp1
     6FD4 A434 
0158 6FD6 0285  22         ci    tmp1,1024
     6FD8 0400 
0159 6FDA 1106  14         jlt   !
0160 6FDC 05A0  34         inc   @fh.kilobytes
     6FDE A432 
0161 6FE0 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     6FE2 FC00 
0162 6FE4 C805  38         mov   tmp1,@fh.counter
     6FE6 A434 
0163                       ;------------------------------------------------------
0164                       ; 1b: Load spectra scratchpad layout
0165                       ;------------------------------------------------------
0166 6FE8 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     6FEA 2ACC 
0167 6FEC 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     6FEE 2B68 
0168 6FF0 F100                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0169                       ;------------------------------------------------------
0170                       ; 1c: Check if a file error occured
0171                       ;------------------------------------------------------
0172               fh.file.read.edb.check_fioerr:
0173 6FF2 C1A0  34         mov   @fh.ioresult,tmp2
     6FF4 A42C 
0174 6FF6 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6FF8 2026 
0175 6FFA 1602  14         jne   fh.file.read.edb.check_setpage
0176                                                   ; No, goto (1d)
0177 6FFC 0460  28         b     @fh.file.read.edb.error
     6FFE 70A2 
0178                                                   ; Yes, so handle file error
0179                       ;------------------------------------------------------
0180                       ; 1d: Check if SAMS page needs to be set
0181                       ;------------------------------------------------------
0182               fh.file.read.edb.check_setpage:
0183 7000 C120  34         mov   @edb.next_free.ptr,tmp0
     7002 A208 
0184                                                   ;--------------------------
0185                                                   ; Sanity check
0186                                                   ;--------------------------
0187 7004 0284  22         ci    tmp0,edb.top + edb.size
     7006 D000 
0188                                                   ; Insane address ?
0189 7008 15B5  14         jgt   fh.file.read.crash    ; Yes, crash!
0190                                                   ;--------------------------
0191                                                   ; Check overflow
0192                                                   ;--------------------------
0193 700A 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     700C 0FFF 
0194 700E A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     7010 A430 
0195 7012 05C4  14         inct  tmp0                  ; +2 for line prefix
0196 7014 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     7016 0FF0 
0197 7018 110E  14         jlt   fh.file.read.edb.process_line
0198                                                   ; Not yet so skip SAMS page switch
0199                       ;------------------------------------------------------
0200                       ; 1e: Increase SAMS page
0201                       ;------------------------------------------------------
0202 701A 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     701C A438 
0203 701E C820  54         mov   @fh.sams.page,@fh.sams.hipage
     7020 A438 
     7022 A43A 
0204                                                   ; Set highest SAMS page
0205 7024 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     7026 A200 
     7028 A208 
0206                                                   ; Start at top of SAMS page again
0207                       ;------------------------------------------------------
0208                       ; 1f: Switch to SAMS page
0209                       ;------------------------------------------------------
0210 702A C120  34         mov   @fh.sams.page,tmp0
     702C A438 
0211 702E C160  34         mov   @edb.top.ptr,tmp1
     7030 A200 
0212 7032 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7034 2528 
0213                                                   ; \ i  tmp0 = SAMS page number
0214                                                   ; / i  tmp1 = Memory address
0215                       ;------------------------------------------------------
0216                       ; Step 2: Process line
0217                       ;------------------------------------------------------
0218               fh.file.read.edb.process_line:
0219 7036 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     7038 0960 
0220 703A C160  34         mov   @edb.next_free.ptr,tmp1
     703C A208 
0221                                                   ; RAM target in editor buffer
0222               
0223 703E C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7040 8352 
0224               
0225 7042 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     7044 A430 
0226 7046 1318  14         jeq   fh.file.read.edb.prepindex.emptyline
0227                                                   ; Handle empty line
0228                       ;------------------------------------------------------
0229                       ; 2a: Copy line from VDP to CPU editor buffer
0230                       ;------------------------------------------------------
0231                                                   ; Put line length word before string
0232 7048 DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0233 704A 06C6  14         swpb  tmp2                  ; |
0234 704C DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0235 704E 06C6  14         swpb  tmp2                  ; /
0236               
0237 7050 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7052 A208 
0238 7054 A806  38         a     tmp2,@edb.next_free.ptr
     7056 A208 
0239                                                   ; Add line length
0240               
0241 7058 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     705A 2470 
0242                                                   ; \ i  tmp0 = VDP source address
0243                                                   ; | i  tmp1 = RAM target address
0244                                                   ; / i  tmp2 = Bytes to copy
0245                       ;------------------------------------------------------
0246                       ; 2b: Align pointer to multiple of 16 memory address
0247                       ;------------------------------------------------------
0248 705C C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     705E A208 
0249 7060 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0250 7062 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7064 000F 
0251 7066 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7068 A208 
0252                       ;------------------------------------------------------
0253                       ; Step 3: Update index
0254                       ;------------------------------------------------------
0255               fh.file.read.edb.prepindex:
0256 706A C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     706C A204 
     706E 8350 
0257                                                   ; parm2 = Must allready be set!
0258 7070 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7072 A438 
     7074 8354 
0259               
0260 7076 1009  14         jmp   fh.file.read.edb.updindex
0261                                                   ; Update index
0262                       ;------------------------------------------------------
0263                       ; 3a: Special handling for empty line
0264                       ;------------------------------------------------------
0265               fh.file.read.edb.prepindex.emptyline:
0266 7078 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     707A A42E 
     707C 8350 
0267 707E 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7080 8350 
0268 7082 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7084 8352 
0269 7086 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7088 8354 
0270                       ;------------------------------------------------------
0271                       ; 3b: Do actual index update
0272                       ;------------------------------------------------------
0273               fh.file.read.edb.updindex:
0274 708A 06A0  32         bl    @idx.entry.update     ; Update index
     708C 6A56 
0275                                                   ; \ i  parm1    = Line num in editor buffer
0276                                                   ; | i  parm2    = Pointer to line in editor
0277                                                   ; |               buffer
0278                                                   ; | i  parm3    = SAMS page
0279                                                   ; | o  outparm1 = Pointer to updated index
0280                                                   ; /               entry
0281               
0282 708E 05A0  34         inc   @edb.lines            ; lines=lines+1
     7090 A204 
0283                       ;------------------------------------------------------
0284                       ; Step 4: Callback "Read line from file"
0285                       ;------------------------------------------------------
0286               fh.file.read.edb.display:
0287 7092 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     7094 A440 
0288 7096 0694  24         bl    *tmp0                 ; Run callback function
0289                       ;------------------------------------------------------
0290                       ; 4a: Next record
0291                       ;------------------------------------------------------
0292               fh.file.read.edb.next:
0293 7098 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     709A 2B46 
0294 709C F100                   data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
0295               
0296 709E 0460  28         b     @fh.file.read.edb.record
     70A0 6FB4 
0297                                                   ; Next record
0298                       ;------------------------------------------------------
0299                       ; Error handler
0300                       ;------------------------------------------------------
0301               fh.file.read.edb.error:
0302 70A2 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     70A4 A42A 
0303 70A6 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0304 70A8 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     70AA 0005 
0305 70AC 1309  14         jeq   fh.file.read.edb.eof
0306                                                   ; All good. File closed by DSRLNK
0307                       ;------------------------------------------------------
0308                       ; File error occured
0309                       ;------------------------------------------------------
0310 70AE 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     70B0 2B68 
0311 70B2 F100                   data scrpad.backup2   ; / >2100->8300
0312               
0313 70B4 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     70B6 67CE 
0314                       ;------------------------------------------------------
0315                       ; Callback "File I/O error"
0316                       ;------------------------------------------------------
0317 70B8 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     70BA A444 
0318 70BC 0694  24         bl    *tmp0                 ; Run callback function
0319 70BE 1008  14         jmp   fh.file.read.edb.exit
0320                       ;------------------------------------------------------
0321                       ; End-Of-File reached
0322                       ;------------------------------------------------------
0323               fh.file.read.edb.eof:
0324 70C0 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     70C2 2B68 
0325 70C4 F100                   data scrpad.backup2   ; / >2100->8300
0326               
0327 70C6 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     70C8 67CE 
0328                       ;------------------------------------------------------
0329                       ; Callback "Close file"
0330                       ;------------------------------------------------------
0331 70CA C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     70CC A442 
0332 70CE 0694  24         bl    *tmp0                 ; Run callback function
0333               *--------------------------------------------------------------
0334               * Exit
0335               *--------------------------------------------------------------
0336               fh.file.read.edb.exit:
0337 70D0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0338 70D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0339 70D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0340 70D6 C2F9  30         mov   *stack+,r11           ; Pop R11
0341 70D8 045B  20         b     *r11                  ; Return to caller
0342               
0343               
0344               ***************************************************************
0345               * PAB for accessing DV/80 file
0346               ********|*****|*********************|**************************
0347               fh.file.pab.header:
0348 70DA 0014             byte  io.op.open            ;  0    - OPEN
0349                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0350 70DC 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0351 70DE 5000             byte  80                    ;  4    - Record length (80 chars max)
0352                       byte  00                    ;  5    - Character count
0353 70E0 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0354 70E2 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0355                       ;------------------------------------------------------
0356                       ; File descriptor part (variable length)
0357                       ;------------------------------------------------------
0358                       ; byte  12                  ;  9    - File descriptor length
0359                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0360                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.37551
0123                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
**** **** ****     > fh.write.edb.asm
0001               * FILE......: fh.write.edb.asm
0002               * Purpose...: File write module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               Write editor buffer to file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.write.edb
0011               * Write editor buffer to file
0012               ***************************************************************
0013               *  bl   @fh.file.write.edb
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "Before Open file"
0018               * parm3 = Pointer to callback function "Write line to file"
0019               * parm4 = Pointer to callback function "Close file"
0020               * parm5 = Pointer to callback function "File I/O error"
0021               *--------------------------------------------------------------
0022               * OUTPUT
0023               *--------------------------------------------------------------
0024               * Register usage
0025               * tmp0, tmp1, tmp2
0026               ********|*****|*********************|**************************
0027               fh.file.write.edb:
0028 70E4 0649  14         dect  stack
0029 70E6 C64B  30         mov   r11,*stack            ; Save return address
0030 70E8 0649  14         dect  stack
0031 70EA C644  30         mov   tmp0,*stack           ; Push tmp0
0032 70EC 0649  14         dect  stack
0033 70EE C645  30         mov   tmp1,*stack           ; Push tmp1
0034 70F0 0649  14         dect  stack
0035 70F2 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 70F4 04E0  34         clr   @fh.records           ; Reset records counter
     70F6 A42E 
0040 70F8 04E0  34         clr   @fh.counter           ; Clear internal counter
     70FA A434 
0041 70FC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     70FE A432 
0042 7100 04E0  34         clr   @fh.kilobytes.prev    ; /
     7102 A446 
0043 7104 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     7106 A42A 
0044 7108 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     710A A42C 
0045               
0046 710C C120  34         mov   @edb.top.ptr,tmp0
     710E A200 
0047 7110 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     7112 24F0 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 7114 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     7116 833C 
     7118 A438 
0053 711A C820  54         mov   @waux1,@fh.sams.hipage
     711C 833C 
     711E A43A 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 7120 0204  20         li    tmp0,fh.fopmode.savefile
     7122 0002 
0059                                                   ; We are going to save a file
0060 7124 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     7126 A43C 
0061               
0062 7128 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     712A 8350 
     712C A436 
0063 712E C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     7130 8352 
     7132 A43E 
0064 7134 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     7136 8354 
     7138 A440 
0065 713A C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     713C 8356 
     713E A442 
0066 7140 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     7142 8358 
     7144 A444 
0067                       ;------------------------------------------------------
0068                       ; Sanity check
0069                       ;------------------------------------------------------
0070 7146 C120  34         mov   @fh.callback1,tmp0
     7148 A43E 
0071 714A 0284  22         ci    tmp0,>6000            ; Insane address ?
     714C 6000 
0072 714E 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0073               
0074 7150 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7152 7FFF 
0075 7154 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0076               
0077 7156 C120  34         mov   @fh.callback2,tmp0
     7158 A440 
0078 715A 0284  22         ci    tmp0,>6000            ; Insane address ?
     715C 6000 
0079 715E 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0080               
0081 7160 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7162 7FFF 
0082 7164 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0083               
0084 7166 C120  34         mov   @fh.callback3,tmp0
     7168 A442 
0085 716A 0284  22         ci    tmp0,>6000            ; Insane address ?
     716C 6000 
0086 716E 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0087               
0088 7170 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7172 7FFF 
0089 7174 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0090               
0091 7176 1004  14         jmp   fh.file.write.edb.save1
0092                                                   ; All checks passed, continue.
0093                                                   ;--------------------------
0094                                                   ; Check failed, crash CPU!
0095                                                   ;--------------------------
0096               fh.file.write.crash:
0097 7178 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     717A FFCE 
0098 717C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     717E 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.write.edb.save1:
0103 7180 C120  34         mov   @fh.callback1,tmp0
     7182 A43E 
0104 7184 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.write.edb.pabheader:
0109 7186 06A0  32         bl    @cpym2v
     7188 2444 
0110 718A 0A60                   data fh.vpab,fh.file.pab.header,9
     718C 70DA 
     718E 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 7190 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     7192 0A69 
0116 7194 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     7196 A436 
0117 7198 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 719A 0986  56         srl   tmp2,8                ; Right justify
0119 719C 0586  14         inc   tmp2                  ; Include length byte as well
0120 719E 06A0  32         bl    @xpym2v               ; Append file descriptor to VDP PAB
     71A0 244A 
0121                       ;------------------------------------------------------
0122                       ; Load GPL scratchpad layout
0123                       ;------------------------------------------------------
0124 71A2 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     71A4 2B46 
0125 71A6 F100                   data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
0126                       ;------------------------------------------------------
0127                       ; Open file
0128                       ;------------------------------------------------------
0129 71A8 06A0  32         bl    @file.open
     71AA 2C94 
0130 71AC 0A60                   data fh.vpab          ; Pass file descriptor to DSRLNK
0131 71AE 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     71B0 2026 
0132 71B2 1602  14         jne   fh.file.write.edb.record
0133 71B4 0460  28         b     @fh.file.write.edb.error
     71B6 72A6 
0134                                                   ; Yes, IO error occured
0135                       ;------------------------------------------------------
0136                       ; Step 1: Read file record
0137                       ;------------------------------------------------------
0138               fh.file.write.edb.record:
0139 71B8 05A0  34         inc   @fh.records           ; Update counter
     71BA A42E 
0140 71BC 04E0  34         clr   @fh.reclen            ; Reset record length
     71BE A430 
0141               
0142 71C0 06A0  32         bl    @file.record.read     ; Read file record
     71C2 2CA2 
0143 71C4 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0144                                                   ; |           (without +9 offset!)
0145                                                   ; | o  tmp0 = Status byte
0146                                                   ; | o  tmp1 = Bytes read
0147                                                   ; | o  tmp2 = Status register contents
0148                                                   ; /           upon DSRLNK return
0149               
0150 71C6 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     71C8 A42A 
0151 71CA C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     71CC A430 
0152 71CE C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     71D0 A42C 
0153                       ;------------------------------------------------------
0154                       ; 1a: Calculate kilobytes processed
0155                       ;------------------------------------------------------
0156 71D2 A805  38         a     tmp1,@fh.counter
     71D4 A434 
0157 71D6 A160  34         a     @fh.counter,tmp1
     71D8 A434 
0158 71DA 0285  22         ci    tmp1,1024
     71DC 0400 
0159 71DE 1106  14         jlt   !
0160 71E0 05A0  34         inc   @fh.kilobytes
     71E2 A432 
0161 71E4 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     71E6 FC00 
0162 71E8 C805  38         mov   tmp1,@fh.counter
     71EA A434 
0163                       ;------------------------------------------------------
0164                       ; 1b: Load spectra scratchpad layout
0165                       ;------------------------------------------------------
0166 71EC 06A0  32 !       bl    @cpu.scrpad.backup    ; Backup GPL layout to @cpu.scrpad.tgt
     71EE 2ACC 
0167 71F0 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     71F2 2B68 
0168 71F4 F100                   data scrpad.backup2   ; / @scrpad.backup2 to >8300
0169                       ;------------------------------------------------------
0170                       ; 1c: Check if a file error occured
0171                       ;------------------------------------------------------
0172               fh.file.write.edb.check_fioerr:
0173 71F6 C1A0  34         mov   @fh.ioresult,tmp2
     71F8 A42C 
0174 71FA 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     71FC 2026 
0175 71FE 1602  14         jne   fh.file.write.edb.check_setpage
0176                                                   ; No, goto (1d)
0177 7200 0460  28         b     @fh.file.write.edb.error
     7202 72A6 
0178                                                   ; Yes, so handle file error
0179                       ;------------------------------------------------------
0180                       ; 1d: Check if SAMS page needs to be set
0181                       ;------------------------------------------------------
0182               fh.file.write.edb.check_setpage:
0183 7204 C120  34         mov   @edb.next_free.ptr,tmp0
     7206 A208 
0184                                                   ;--------------------------
0185                                                   ; Sanity check
0186                                                   ;--------------------------
0187 7208 0284  22         ci    tmp0,edb.top + edb.size
     720A D000 
0188                                                   ; Insane address ?
0189 720C 15B5  14         jgt   fh.file.write.crash    ; Yes, crash!
0190                                                   ;--------------------------
0191                                                   ; Check overflow
0192                                                   ;--------------------------
0193 720E 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     7210 0FFF 
0194 7212 A120  34         a     @fh.reclen,tmp0       ; Add length of line just read
     7214 A430 
0195 7216 05C4  14         inct  tmp0                  ; +2 for line prefix
0196 7218 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     721A 0FF0 
0197 721C 110E  14         jlt   fh.file.write.edb.process_line
0198                                                   ; Not yet so skip SAMS page switch
0199                       ;------------------------------------------------------
0200                       ; 1e: Increase SAMS page
0201                       ;------------------------------------------------------
0202 721E 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     7220 A438 
0203 7222 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     7224 A438 
     7226 A43A 
0204                                                   ; Set highest SAMS page
0205 7228 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     722A A200 
     722C A208 
0206                                                   ; Start at top of SAMS page again
0207                       ;------------------------------------------------------
0208                       ; 1f: Switch to SAMS page
0209                       ;------------------------------------------------------
0210 722E C120  34         mov   @fh.sams.page,tmp0
     7230 A438 
0211 7232 C160  34         mov   @edb.top.ptr,tmp1
     7234 A200 
0212 7236 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7238 2528 
0213                                                   ; \ i  tmp0 = SAMS page number
0214                                                   ; / i  tmp1 = Memory address
0215                       ;------------------------------------------------------
0216                       ; Step 2: Process line
0217                       ;------------------------------------------------------
0218               fh.file.write.edb.process_line:
0219 723A 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     723C 0960 
0220 723E C160  34         mov   @edb.next_free.ptr,tmp1
     7240 A208 
0221                                                   ; RAM target in editor buffer
0222               
0223 7242 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7244 8352 
0224               
0225 7246 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     7248 A430 
0226 724A 1318  14         jeq   fh.file.write.edb.prepindex.emptyline
0227                                                   ; Handle empty line
0228                       ;------------------------------------------------------
0229                       ; 2a: Copy line from VDP to CPU editor buffer
0230                       ;------------------------------------------------------
0231                                                   ; Put line length word before string
0232 724C DD46  32         movb  tmp2,*tmp1+           ; \ MSB to line prefix
0233 724E 06C6  14         swpb  tmp2                  ; |
0234 7250 DD46  32         movb  tmp2,*tmp1+           ; | LSB to line prefix
0235 7252 06C6  14         swpb  tmp2                  ; /
0236               
0237 7254 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     7256 A208 
0238 7258 A806  38         a     tmp2,@edb.next_free.ptr
     725A A208 
0239                                                   ; Add line length
0240               
0241 725C 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     725E 2470 
0242                                                   ; \ i  tmp0 = VDP source address
0243                                                   ; | i  tmp1 = RAM target address
0244                                                   ; / i  tmp2 = Bytes to copy
0245                       ;------------------------------------------------------
0246                       ; 2b: Align pointer to multiple of 16 memory address
0247                       ;------------------------------------------------------
0248 7260 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7262 A208 
0249 7264 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0250 7266 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7268 000F 
0251 726A A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     726C A208 
0252                       ;------------------------------------------------------
0253                       ; Step 3: Update index
0254                       ;------------------------------------------------------
0255               fh.file.write.edb.prepindex:
0256 726E C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     7270 A204 
     7272 8350 
0257                                                   ; parm2 = Must allready be set!
0258 7274 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7276 A438 
     7278 8354 
0259               
0260 727A 1009  14         jmp   fh.file.write.edb.updindex
0261                                                   ; Update index
0262                       ;------------------------------------------------------
0263                       ; 3a: Special handling for empty line
0264                       ;------------------------------------------------------
0265               fh.file.write.edb.prepindex.emptyline:
0266 727C C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     727E A42E 
     7280 8350 
0267 7282 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7284 8350 
0268 7286 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7288 8352 
0269 728A 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     728C 8354 
0270                       ;------------------------------------------------------
0271                       ; 3b: Do actual index update
0272                       ;------------------------------------------------------
0273               fh.file.write.edb.updindex:
0274 728E 06A0  32         bl    @idx.entry.update     ; Update index
     7290 6A56 
0275                                                   ; \ i  parm1    = Line num in editor buffer
0276                                                   ; | i  parm2    = Pointer to line in editor
0277                                                   ; |               buffer
0278                                                   ; | i  parm3    = SAMS page
0279                                                   ; | o  outparm1 = Pointer to updated index
0280                                                   ; /               entry
0281               
0282 7292 05A0  34         inc   @edb.lines            ; lines=lines+1
     7294 A204 
0283                       ;------------------------------------------------------
0284                       ; Step 4: Callback "Read line from file"
0285                       ;------------------------------------------------------
0286               fh.file.write.edb.display:
0287 7296 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     7298 A440 
0288 729A 0694  24         bl    *tmp0                 ; Run callback function
0289                       ;------------------------------------------------------
0290                       ; 4a: Next record
0291                       ;------------------------------------------------------
0292               fh.file.write.edb.next:
0293 729C 06A0  32         bl    @cpu.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     729E 2B46 
0294 72A0 F100                   data scrpad.backup2   ; / 8300->xxxx, xxxx->8300
0295               
0296 72A2 0460  28         b     @fh.file.write.edb.record
     72A4 71B8 
0297                                                   ; Next record
0298                       ;------------------------------------------------------
0299                       ; Error handler
0300                       ;------------------------------------------------------
0301               fh.file.write.edb.error:
0302 72A6 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     72A8 A42A 
0303 72AA 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0304 72AC 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     72AE 0005 
0305 72B0 1309  14         jeq   fh.file.write.edb.eof
0306                                                   ; All good. File closed by DSRLNK
0307                       ;------------------------------------------------------
0308                       ; File error occured
0309                       ;------------------------------------------------------
0310 72B2 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     72B4 2B68 
0311 72B6 F100                   data scrpad.backup2   ; / >2100->8300
0312               
0313 72B8 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     72BA 67CE 
0314                       ;------------------------------------------------------
0315                       ; Callback "File I/O error"
0316                       ;------------------------------------------------------
0317 72BC C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     72BE A444 
0318 72C0 0694  24         bl    *tmp0                 ; Run callback function
0319 72C2 1008  14         jmp   fh.file.write.edb.exit
0320                       ;------------------------------------------------------
0321                       ; End-Of-File reached
0322                       ;------------------------------------------------------
0323               fh.file.write.edb.eof:
0324 72C4 06A0  32         bl    @cpu.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     72C6 2B68 
0325 72C8 F100                   data scrpad.backup2   ; / >2100->8300
0326               
0327 72CA 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     72CC 67CE 
0328                       ;------------------------------------------------------
0329                       ; Callback "Close file"
0330                       ;------------------------------------------------------
0331 72CE C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     72D0 A442 
0332 72D2 0694  24         bl    *tmp0                 ; Run callback function
0333               *--------------------------------------------------------------
0334               * Exit
0335               *--------------------------------------------------------------
0336               fh.file.write.edb.exit:
0337 72D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0338 72D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0339 72D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0340 72DA C2F9  30         mov   *stack+,r11           ; Pop R11
0341 72DC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0124                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
**** **** ****     > fm.load.asm
0001               * FILE......: fm.load.asm
0002               * Purpose...: File Manager - Load file into editor buffer
0003               
0004               
0005               ***************************************************************
0006               * fm.loadfile
0007               * Load file into editor buffer
0008               ***************************************************************
0009               * bl  @fm.loadfile
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * tmp0  = Pointer to length-prefixed string containing both
0013               *         device and filename
0014               *---------------------------------------------------------------
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0, tmp1
0020               ********|*****|*********************|**************************
0021               fm.loadfile:
0022 72DE 0649  14         dect  stack
0023 72E0 C64B  30         mov   r11,*stack            ; Save return address
0024 72E2 0649  14         dect  stack
0025 72E4 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 72E6 0649  14         dect  stack
0027 72E8 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" if editor buffer dirty
0030                       ;-------------------------------------------------------
0031 72EA C160  34         mov   @edb.dirty,tmp1
     72EC A206 
0032 72EE 1305  14         jeq   !
0033 72F0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0034 72F2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0035 72F4 C2F9  30         mov   *stack+,r11           ; Pop R11
0036 72F6 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     72F8 7B12 
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 72FA C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     72FC 8350 
0041 72FE 06A0  32         bl    @tv.reset             ; Reset editor
     7300 67B2 
0042 7302 C820  54         mov   @parm1,@edb.filename.ptr
     7304 8350 
     7306 A20E 
0043                                                   ; Set filename
0044                       ;-------------------------------------------------------
0045                       ; Clear VDP screen buffer
0046                       ;-------------------------------------------------------
0047 7308 06A0  32         bl    @filv
     730A 2288 
0048 730C 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     730E 0000 
     7310 0004 
0049               
0050 7312 C160  34         mov   @fb.scrrows,tmp1
     7314 A118 
0051 7316 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7318 A10E 
0052                                                   ; 16 bit part is in tmp2!
0053               
0054 731A 06A0  32         bl    @scroff               ; Turn off screen
     731C 2640 
0055               
0056 731E 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0057 7320 0205  20         li    tmp1,32               ; Character to fill
     7322 0020 
0058               
0059 7324 06A0  32         bl    @xfilv                ; Fill VDP memory
     7326 228E 
0060                                                   ; \ i  tmp0 = VDP target address
0061                                                   ; | i  tmp1 = Byte to fill
0062                                                   ; / i  tmp2 = Bytes to copy
0063               
0064 7328 06A0  32         bl    @pane.action.colorscheme.Load
     732A 776E 
0065                                                   ; Load color scheme and turn on screen
0066                       ;-------------------------------------------------------
0067                       ; Read DV80 file and display
0068                       ;-------------------------------------------------------
0069 732C 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     732E 73A8 
0070 7330 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7332 8352 
0071               
0072 7334 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     7336 73F0 
0073 7338 C804  38         mov   tmp0,@parm3           ; Register callback 2
     733A 8354 
0074               
0075 733C 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     733E 7426 
0076 7340 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7342 8356 
0077               
0078 7344 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     7346 7458 
0079 7348 C804  38         mov   tmp0,@parm5           ; Register callback 4
     734A 8358 
0080               
0081 734C 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     734E 6EE0 
0082                                                   ; \ i  parm1 = Pointer to length prefixed
0083                                                   ; |            file descriptor
0084                                                   ; | i  parm2 = Pointer to callback
0085                                                   ; |            "loading indicator 1"
0086                                                   ; | i  parm3 = Pointer to callback
0087                                                   ; |            "loading indicator 2"
0088                                                   ; | i  parm4 = Pointer to callback
0089                                                   ; |            "loading indicator 3"
0090                                                   ; | i  parm5 = Pointer to callback
0091                                                   ; /            "File I/O error handler"
0092               
0093 7350 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     7352 A206 
0094                                                   ; longer dirty.
0095               
0096 7354 0204  20         li    tmp0,txt.filetype.DV80
     7356 3112 
0097 7358 C804  38         mov   tmp0,@edb.filetype.ptr
     735A A210 
0098                                                   ; Set filetype display string
0099               *--------------------------------------------------------------
0100               * Exit
0101               *--------------------------------------------------------------
0102               fm.loadfile.exit:
0103 735C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 735E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 7360 C2F9  30         mov   *stack+,r11           ; Pop R11
0106 7362 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0125                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
**** **** ****     > fm.save.asm
0001               * FILE......: fm.save.asm
0002               * Purpose...: File Manager - Save file from editor buffer
0003               
0004               
0005               ***************************************************************
0006               * fm.savefile
0007               * Save file from editor buffer
0008               ***************************************************************
0009               * bl  @fm.savefile
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * tmp0  = Pointer to length-prefixed string containing both
0013               *         device and filename
0014               *---------------------------------------------------------------
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0, tmp1
0020               ********|*****|*********************|**************************
0021               fm.savefile:
0022 7364 0649  14         dect  stack
0023 7366 C64B  30         mov   r11,*stack            ; Save return address
0024 7368 0649  14         dect  stack
0025 736A C644  30         mov   tmp0,*stack           ; Push tmp0
0026 736C 0649  14         dect  stack
0027 736E C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Save DV80 file
0030                       ;-------------------------------------------------------
0031 7370 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7372 73A8 
0032 7374 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7376 8352 
0033               
0034 7378 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     737A 73F0 
0035 737C C804  38         mov   tmp0,@parm3           ; Register callback 2
     737E 8354 
0036               
0037 7380 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     7382 7426 
0038 7384 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7386 8356 
0039               
0040 7388 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     738A 7458 
0041 738C C804  38         mov   tmp0,@parm5           ; Register callback 4
     738E 8358 
0042               
0043 7390 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     7392 70E4 
0044                                                   ; \ i  parm1 = Pointer to length prefixed
0045                                                   ; |            file descriptor
0046                                                   ; | i  parm2 = Pointer to callback
0047                                                   ; |            "loading indicator 1"
0048                                                   ; | i  parm3 = Pointer to callback
0049                                                   ; |            "loading indicator 2"
0050                                                   ; | i  parm4 = Pointer to callback
0051                                                   ; |            "loading indicator 3"
0052                                                   ; | i  parm5 = Pointer to callback
0053                                                   ; /            "File I/O error handler"
0054               
0055 7394 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     7396 A206 
0056                                                   ; longer dirty.
0057               
0058 7398 0204  20         li    tmp0,txt.filetype.DV80
     739A 3112 
0059 739C C804  38         mov   tmp0,@edb.filetype.ptr
     739E A210 
0060                                                   ; Set filetype display string
0061               *--------------------------------------------------------------
0062               * Exit
0063               *--------------------------------------------------------------
0064               fm.savefile.exit:
0065 73A0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 73A2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 73A4 C2F9  30         mov   *stack+,r11           ; Pop R11
0068 73A6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0126                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
**** **** ****     > fm.callbacks.asm
0001               * FILE......: fm.callbacks.asm
0002               * Purpose...: File Manager - Callbacks for file operations
0003               
0004               *---------------------------------------------------------------
0005               * Callback function "Show loading indicator 1"
0006               * Open file
0007               *---------------------------------------------------------------
0008               * Registered as pointer in @fh.callback1
0009               *---------------------------------------------------------------
0010               fm.loadsave.cb.indicator1:
0011 73A8 0649  14         dect  stack
0012 73AA C64B  30         mov   r11,*stack            ; Save return address
0013 73AC 0649  14         dect  stack
0014 73AE C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;------------------------------------------------------
0016                       ; Check file operation m ode
0017                       ;------------------------------------------------------
0018 73B0 06A0  32         bl    @hchar
     73B2 2774 
0019 73B4 1D00                   byte 29,0,32,80
     73B6 2050 
0020 73B8 FFFF                   data EOL              ; Clear until end of line
0021               
0022 73BA C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     73BC A43C 
0023               
0024 73BE 0284  22         ci    tmp0,fh.fopmode.savefile
     73C0 0002 
0025 73C2 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0026                                                   ; Saving file?
0027               
0028 73C4 0284  22         ci    tmp0,fh.fopmode.readfile
     73C6 0001 
0029 73C8 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0030                                                   ; Loading file?
0031                       ;------------------------------------------------------
0032                       ; Display Saving....
0033                       ;------------------------------------------------------
0034               fm.loadsave.cb.indicator1.saving:
0035 73CA 06A0  32         bl    @putat
     73CC 243C 
0036 73CE 1D00                   byte 29,0
0037 73D0 30EE                   data txt.saving       ; Display "Saving...."
0038 73D2 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0039                       ;------------------------------------------------------
0040                       ; Display Loading....
0041                       ;------------------------------------------------------
0042               fm.loadsave.cb.indicator1.loading:
0043 73D4 06A0  32         bl    @putat
     73D6 243C 
0044 73D8 1D00                   byte 29,0
0045 73DA 30E2                   data txt.loading      ; Display "Loading...."
0046                       ;------------------------------------------------------
0047                       ; Display device/filename
0048                       ;------------------------------------------------------
0049               fm.loadsave.cb.indicator1.filename:
0050 73DC 06A0  32         bl    @at
     73DE 2680 
0051 73E0 1D0B                   byte 29,11            ; Cursor YX position
0052 73E2 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     73E4 8350 
0053 73E6 06A0  32         bl    @xutst0               ; Display device/filename
     73E8 241A 
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057               fm.loadsave.cb.indicator1.exit:
0058 73EA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0059 73EC C2F9  30         mov   *stack+,r11           ; Pop R11
0060 73EE 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               
0065               *---------------------------------------------------------------
0066               * Callback function "Show loading indicator 2"
0067               * Read line from file / Write line to file
0068               *---------------------------------------------------------------
0069               * Registered as pointer in @fh.callback2
0070               *---------------------------------------------------------------
0071               fm.loadsave.cb.indicator2:
0072                       ;------------------------------------------------------
0073                       ; Check if updated counters should be displayed
0074                       ;------------------------------------------------------
0075 73F0 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     73F2 A432 
     73F4 A446 
0076 73F6 1316  14         jeq   !
0077                       ;------------------------------------------------------
0078                       ; Display updated counters
0079                       ;------------------------------------------------------
0080 73F8 0649  14         dect  stack
0081 73FA C64B  30         mov   r11,*stack            ; Save return address
0082               
0083 73FC C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     73FE A432 
     7400 A446 
0084                                                   ; Save for compare
0085               
0086 7402 06A0  32         bl    @putnum
     7404 2A00 
0087 7406 1D4B                   byte 29,75            ; Show lines processed
0088 7408 A204                   data edb.lines,rambuf,>3020
     740A 8390 
     740C 3020 
0089               
0090 740E 06A0  32         bl    @putnum
     7410 2A00 
0091 7412 1D38                   byte 29,56            ; Show kilobytes processed
0092 7414 A432                   data fh.kilobytes,rambuf,>3020
     7416 8390 
     7418 3020 
0093               
0094 741A 06A0  32         bl    @putat
     741C 243C 
0095 741E 1D3D                   byte 29,61
0096 7420 30F8                   data txt.kb           ; Show "kb" string
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100               fm.loadsave.cb.indicator2.exit:
0101 7422 C2F9  30         mov   *stack+,r11           ; Pop R11
0102 7424 045B  20 !       b     *r11                  ; Return to caller
0103               
0104               
0105               
0106               
0107               *---------------------------------------------------------------
0108               * Callback function "Show loading indicator 3"
0109               * Close file
0110               *---------------------------------------------------------------
0111               * Registered as pointer in @fh.callback3
0112               *---------------------------------------------------------------
0113               fm.loadsave.cb.indicator3:
0114 7426 0649  14         dect  stack
0115 7428 C64B  30         mov   r11,*stack            ; Save return address
0116               
0117 742A 06A0  32         bl    @hchar
     742C 2774 
0118 742E 1D03                   byte 29,3,32,50       ; Erase loading indicator
     7430 2032 
0119 7432 FFFF                   data EOL
0120               
0121 7434 06A0  32         bl    @putnum
     7436 2A00 
0122 7438 1D38                   byte 29,56            ; Show kilobytes processed
0123 743A A432                   data fh.kilobytes,rambuf,>3020
     743C 8390 
     743E 3020 
0124               
0125 7440 06A0  32         bl    @putat
     7442 243C 
0126 7444 1D3D                   byte 29,61
0127 7446 30F8                   data txt.kb           ; Show "kb" string
0128               
0129 7448 06A0  32         bl    @putnum
     744A 2A00 
0130 744C 1D4B                   byte 29,75            ; Show lines processed
0131 744E A42E                   data fh.records,rambuf,>3020
     7450 8390 
     7452 3020 
0132                       ;------------------------------------------------------
0133                       ; Exit
0134                       ;------------------------------------------------------
0135               fm.loadsave.cb.indicator3.exit:
0136 7454 C2F9  30         mov   *stack+,r11           ; Pop R11
0137 7456 045B  20         b     *r11                  ; Return to caller
0138               
0139               
0140               
0141               *---------------------------------------------------------------
0142               * Callback function "File I/O error handler"
0143               * I/O error
0144               *---------------------------------------------------------------
0145               * Registered as pointer in @fh.callback4
0146               *---------------------------------------------------------------
0147               fm.loadsave.cb.fioerr:
0148 7458 0649  14         dect  stack
0149 745A C64B  30         mov   r11,*stack            ; Save return address
0150 745C 0649  14         dect  stack
0151 745E C644  30         mov   tmp0,*stack           ; Push tmp0
0152                       ;------------------------------------------------------
0153                       ; Build I/O error message
0154                       ;------------------------------------------------------
0155 7460 06A0  32         bl    @hchar
     7462 2774 
0156 7464 1D00                   byte 29,0,32,50       ; Erase loading indicator
     7466 2032 
0157 7468 FFFF                   data EOL
0158               
0159 746A 06A0  32         bl    @cpym2m
     746C 248C 
0160 746E 327D                   data txt.ioerr+1
0161 7470 A021                   data tv.error.msg+1
0162 7472 0022                   data 34               ; Error message
0163               
0164 7474 C120  34         mov   @edb.filename.ptr,tmp0
     7476 A20E 
0165 7478 D194  26         movb  *tmp0,tmp2            ; Get length byte
0166 747A 0986  56         srl   tmp2,8                ; Right align
0167 747C 0584  14         inc   tmp0                  ; Skip length byte
0168 747E 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     7480 A041 
0169               
0170 7482 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     7484 2492 
0171                                                   ; | i  tmp0 = ROM/RAM source
0172                                                   ; | i  tmp1 = RAM destination
0173                                                   ; / i  tmp2 = Bytes to copy
0174                       ;------------------------------------------------------
0175                       ; Reset filename to "new file"
0176                       ;------------------------------------------------------
0177 7486 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7488 A43C 
0178               
0179 748A 0284  22         ci    tmp0,fh.fopmode.readfile
     748C 0001 
0180 748E 1608  14         jne   !                     ; Only when reading file
0181               
0182 7490 0204  20         li    tmp0,txt.newfile      ; New file
     7492 3106 
0183 7494 C804  38         mov   tmp0,@edb.filename.ptr
     7496 A20E 
0184               
0185 7498 0204  20         li    tmp0,txt.filetype.none
     749A 3118 
0186 749C C804  38         mov   tmp0,@edb.filetype.ptr
     749E A210 
0187                                                   ; Empty filetype string
0188                       ;------------------------------------------------------
0189                       ; Display I/O error message
0190                       ;------------------------------------------------------
0191 74A0 06A0  32 !       bl    @pane.errline.show    ; Show error line
     74A2 7990 
0192                       ;------------------------------------------------------
0193                       ; Exit
0194                       ;------------------------------------------------------
0195               fm.loadsave.cb.fioerr.exit:
0196 74A4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0197 74A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0198 74A8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0127                       copy  "fm.browse.asm"       ; File manager browse support routines
**** **** ****     > fm.browse.asm
0001               * FILE......: fm.browse.asm
0002               * Purpose...: File Manager - File browse support routines
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Increase/Decrease last-character of current filename
0007               *---------------------------------------------------------------
0008               * bl   @fm.browse.fname.suffix
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * parm1        = Pointer to device and filename
0012               * parm2        = Increase (>FFFF) or Decrease (>0000) ASCII
0013               *--------------------------------------------------------------
0014               * Register usage
0015               * tmp0, tmp1
0016               ********|*****|*********************|**************************
0017               fm.browse.fname.suffix.incdec:
0018 74AA 0649  14         dect  stack
0019 74AC C64B  30         mov   r11,*stack            ; Save return address
0020 74AE 0649  14         dect  stack
0021 74B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 74B2 0649  14         dect  stack
0023 74B4 C645  30         mov   tmp1,*stack           ; Push tmp1
0024                       ;------------------------------------------------------
0025                       ; Get last character in filename
0026                       ;------------------------------------------------------
0027 74B6 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     74B8 8350 
0028 74BA 1331  14         jeq   fm.browse.fname.suffix.exit
0029                                                   ; Exit early if pointer is nill
0030               
0031 74BC D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0032 74BE 0985  56         srl   tmp1,8                ; MSB to LSB
0033               
0034 74C0 A105  18         a     tmp1,tmp0             ; Move to last character
0035 74C2 04C5  14         clr   tmp1
0036 74C4 D154  26         movb  *tmp0,tmp1            ; Get character
0037 74C6 0985  56         srl   tmp1,8                ; MSB to LSB
0038 74C8 132A  14         jeq   fm.browse.fname.suffix.exit
0039                                                   ; Exit early if empty filename
0040                       ;------------------------------------------------------
0041                       ; Check mode (increase/decrease) character ASCII value
0042                       ;------------------------------------------------------
0043 74CA C1A0  34         mov   @parm2,tmp2           ; Get mode
     74CC 8352 
0044 74CE 1314  14         jeq   fm.browse.fname.suffix.dec
0045                                                   ; Decrease ASCII if mode = 0
0046                       ;------------------------------------------------------
0047                       ; Increase ASCII value last character in filename
0048                       ;------------------------------------------------------
0049               fm.browse.fname.suffix.inc:
0050 74D0 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     74D2 0030 
0051 74D4 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0052 74D6 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     74D8 0039 
0053 74DA 1109  14         jlt   !                     ; Next character
0054 74DC 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0055                                                   ; Swith to alpha range A..Z
0056 74DE 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     74E0 0084 
0057 74E2 131D  14         jeq   fm.browse.fname.suffix.exit
0058                                                   ; Already last alpha character, so exit
0059 74E4 1104  14         jlt   !                     ; Next character
0060                       ;------------------------------------------------------
0061                       ; Invalid character, crash and burn
0062                       ;------------------------------------------------------
0063               fm.browse.fname.suffix.inc.crash:
0064 74E6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     74E8 FFCE 
0065 74EA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     74EC 2030 
0066                       ;------------------------------------------------------
0067                       ; Increase ASCII value last character in filename
0068                       ;------------------------------------------------------
0069 74EE 0585  14 !       inc   tmp1                  ; Increase ASCII value
0070 74F0 1014  14         jmp   fm.browse.fname.suffix.store
0071               fm.browse.fname.suffix.inc.alpha:
0072 74F2 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     74F4 0041 
0073 74F6 1011  14         jmp   fm.browse.fname.suffix.store
0074                       ;------------------------------------------------------
0075                       ; Decrease ASCII value last character in filename
0076                       ;------------------------------------------------------
0077               fm.browse.fname.suffix.dec:
0078 74F8 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     74FA 0030 
0079 74FC 1310  14         jeq   fm.browse.fname.suffix.exit
0080                                                   ; Already first numeric character, so exit
0081 74FE 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7500 0039 
0082 7502 1207  14         jle   !                     ; Previous character
0083 7504 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     7506 0041 
0084 7508 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0085                                                   ; Switch to numeric range 0..9
0086 750A 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0087                                                   ; Invalid character
0088 750C 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     750E 0084 
0089 7510 1306  14         jeq   fm.browse.fname.suffix.exit
0090 7512 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0091 7514 1002  14         jmp   fm.browse.fname.suffix.store
0092               fm.browse.fname.suffix.dec.numeric:
0093 7516 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     7518 0039 
0094                       ;------------------------------------------------------
0095                       ; Store updatec character
0096                       ;------------------------------------------------------
0097               fm.browse.fname.suffix.store:
0098 751A 0A85  56         sla   tmp1,8                ; LSB to MSB
0099 751C D505  30         movb  tmp1,*tmp0            ; Store updated character
0100                       ;------------------------------------------------------
0101                       ; Exit
0102                       ;------------------------------------------------------
0103               fm.browse.fname.suffix.exit:
0104 751E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0105 7520 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0106 7522 C2F9  30         mov   *stack+,r11           ; Pop R11
0107 7524 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0128                       ;-----------------------------------------------------------------------
0129                       ; User hook, background tasks
0130                       ;-----------------------------------------------------------------------
0131                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 7526 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     7528 2014 
0013 752A 160B  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015               *---------------------------------------------------------------
0016               * Identical key pressed ?
0017               *---------------------------------------------------------------
0018 752C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     752E 2014 
0019 7530 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     7532 833C 
     7534 833E 
0020 7536 1309  14         jeq   hook.keyscan.bounce
0021               *--------------------------------------------------------------
0022               * New key pressed
0023               *--------------------------------------------------------------
0024               hook.keyscan.newkey:
0025 7538 C820  54         mov   @waux1,@waux2         ; Save as previous key
     753A 833C 
     753C 833E 
0026 753E 0460  28         b     @edkey.key.process    ; Process key
     7540 60E4 
0027               *--------------------------------------------------------------
0028               * Clear keyboard buffer if no key pressed
0029               *--------------------------------------------------------------
0030               hook.keyscan.clear_kbbuffer:
0031 7542 04E0  34         clr   @waux1
     7544 833C 
0032 7546 04E0  34         clr   @waux2
     7548 833E 
0033               *--------------------------------------------------------------
0034               * Delay to avoid key bouncing
0035               *--------------------------------------------------------------
0036               hook.keyscan.bounce:
0037 754A 0204  20         li    tmp0,2000             ; Avoid key bouncing
     754C 07D0 
0038                       ;------------------------------------------------------
0039                       ; Delay loop
0040                       ;------------------------------------------------------
0041               hook.keyscan.bounce.loop:
0042 754E 0604  14         dec   tmp0
0043 7550 16FE  14         jne   hook.keyscan.bounce.loop
0044               *--------------------------------------------------------------
0045               * Exit
0046               *--------------------------------------------------------------
0047 7552 0460  28         b     @hookok               ; Return
     7554 2CF0 
**** **** ****     > stevie_b1.asm.37551
0132                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0015 7556 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     7558 A302 
0016 755A 1308  14         jeq   !                     ; No, skip CMDB pane
0017                       ;-------------------------------------------------------
0018                       ; Draw command buffer pane if dirty
0019                       ;-------------------------------------------------------
0020               task.vdp.panes.cmdb.draw:
0021 755C C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     755E A318 
0022 7560 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0023               
0024 7562 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     7564 7884 
0025 7566 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7568 A318 
0026 756A 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0027                       ;-------------------------------------------------------
0028                       ; Check if frame buffer dirty
0029                       ;-------------------------------------------------------
0030 756C C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     756E A116 
0031 7570 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0032 7572 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7574 832A 
     7576 A114 
0033                       ;------------------------------------------------------
0034                       ; Determine how many rows to copy
0035                       ;------------------------------------------------------
0036 7578 8820  54         c     @edb.lines,@fb.scrrows
     757A A204 
     757C A118 
0037 757E 1103  14         jlt   task.vdp.panes.setrows.small
0038 7580 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7582 A118 
0039 7584 1003  14         jmp   task.vdp.panes.copy.framebuffer
0040                       ;------------------------------------------------------
0041                       ; Less lines in editor buffer as rows in frame buffer
0042                       ;------------------------------------------------------
0043               task.vdp.panes.setrows.small:
0044 7586 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7588 A204 
0045 758A 0585  14         inc   tmp1
0046                       ;------------------------------------------------------
0047                       ; Determine area to copy
0048                       ;------------------------------------------------------
0049               task.vdp.panes.copy.framebuffer:
0050 758C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     758E A10E 
0051                                                   ; 16 bit part is in tmp2!
0052 7590 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0053 7592 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7594 A100 
0054                       ;------------------------------------------------------
0055                       ; Copy memory block
0056                       ;------------------------------------------------------
0057 7596 06A0  32         bl    @xpym2v               ; Copy to VDP
     7598 244A 
0058                                                   ; \ i  tmp0 = VDP target address
0059                                                   ; | i  tmp1 = RAM source address
0060                                                   ; / i  tmp2 = Bytes to copy
0061 759A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     759C A116 
0062                       ;-------------------------------------------------------
0063                       ; Draw EOF marker at end-of-file
0064                       ;-------------------------------------------------------
0065 759E C120  34         mov   @edb.lines,tmp0
     75A0 A204 
0066 75A2 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     75A4 A104 
0067 75A6 0584  14         inc   tmp0                  ; Y = Y + 1
0068 75A8 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     75AA A118 
0069 75AC 121C  14         jle   task.vdp.panes.botline.draw
0070                                                   ; Skip drawing EOF maker
0071                       ;-------------------------------------------------------
0072                       ; Do actual drawing of EOF marker
0073                       ;-------------------------------------------------------
0074               task.vdp.panes.draw_marker:
0075 75AE 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0076 75B0 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     75B2 832A 
0077               
0078 75B4 06A0  32         bl    @putstr
     75B6 2418 
0079 75B8 30CC                   data txt.marker       ; Display *EOF*
0080               
0081 75BA 06A0  32         bl    @setx
     75BC 2696 
0082 75BE 0005                   data  5               ; Cursor after *EOF* string
0083                       ;-------------------------------------------------------
0084                       ; Clear rest of screen
0085                       ;-------------------------------------------------------
0086               task.vdp.panes.clear_screen:
0087 75C0 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     75C2 A10E 
0088               
0089 75C4 C160  34         mov   @wyx,tmp1             ;
     75C6 832A 
0090 75C8 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0091 75CA 0505  16         neg   tmp1                  ; tmp1 = -Y position
0092 75CC A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     75CE A118 
0093               
0094 75D0 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0095 75D2 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     75D4 FFFB 
0096               
0097 75D6 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     75D8 23F4 
0098                                                   ; \ i  @wyx = Cursor position
0099                                                   ; / o  tmp0 = VDP address
0100               
0101 75DA 04C5  14         clr   tmp1                  ; Character to write (null!)
0102 75DC 06A0  32         bl    @xfilv                ; Fill VDP memory
     75DE 228E 
0103                                                   ; \ i  tmp0 = VDP destination
0104                                                   ; | i  tmp1 = byte to write
0105                                                   ; / i  tmp2 = Number of bytes to write
0106               
0107 75E0 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     75E2 A114 
     75E4 832A 
0108                       ;-------------------------------------------------------
0109                       ; Draw status line
0110                       ;-------------------------------------------------------
0111               task.vdp.panes.botline.draw:
0112 75E6 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     75E8 79D6 
0113                       ;------------------------------------------------------
0114                       ; Exit task
0115                       ;------------------------------------------------------
0116               task.vdp.panes.exit:
0117 75EA 0460  28         b     @slotok
     75EC 2D6C 
**** **** ****     > stevie_b1.asm.37551
0133                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 75EE C120  34         mov   @tv.pane.focus,tmp0
     75F0 A01A 
0013 75F2 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 75F4 0284  22         ci    tmp0,pane.focus.cmdb
     75F6 0001 
0016 75F8 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 75FA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     75FC FFCE 
0022 75FE 06A0  32         bl    @cpu.crash            ; / Halt system.
     7600 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 7602 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     7604 A30A 
     7606 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 7608 E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     760A 202A 
0032 760C 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     760E 26A2 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 7610 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     7612 8380 
0036               
0037 7614 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     7616 2444 
0038 7618 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     761A 8380 
     761C 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 761E 0460  28         b     @slotok               ; Exit task
     7620 2D6C 
**** **** ****     > stevie_b1.asm.37551
0134                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 7622 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     7624 A112 
0013 7626 1303  14         jeq   task.vdp.cursor.visible
0014 7628 04E0  34         clr   @ramsat+2              ; Hide cursor
     762A 8382 
0015 762C 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 762E C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     7630 A20A 
0019 7632 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 7634 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     7636 A01A 
0025 7638 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 763A 0284  22         ci    tmp0,pane.focus.cmdb
     763C 0001 
0028 763E 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 7640 04C4  14         clr   tmp0                   ; Cursor editor insert mode
0034 7642 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 7644 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     7646 0100 
0040 7648 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 764A 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     764C 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 764E D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     7650 A014 
0051 7652 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     7654 A014 
     7656 8382 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 7658 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     765A 2444 
0057 765C 2180                   data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
     765E 8380 
     7660 0004 
0058                                                    ; | i  tmp1 = ROM/RAM source
0059                                                    ; / i  tmp2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 7662 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     7664 A302 
0064 7666 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 7668 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     766A 79D6 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 766C 0460  28         b     @slotok                ; Exit task
     766E 2D6C 
**** **** ****     > stevie_b1.asm.37551
0135                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               task.oneshot:
0002 7670 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7672 A01C 
0003 7674 1301  14         jeq   task.oneshot.exit
0004               
0005 7676 0694  24         bl    *tmp0                  ; Execute one-shot task
0006                       ;------------------------------------------------------
0007                       ; Exit
0008                       ;------------------------------------------------------
0009               task.oneshot.exit:
0010 7678 0460  28         b     @slotok                ; Exit task
     767A 2D6C 
**** **** ****     > stevie_b1.asm.37551
0136                       ;-----------------------------------------------------------------------
0137                       ; Screen pane utilities
0138                       ;-----------------------------------------------------------------------
0139                       copy  "pane.utils.asm"      ; Pane utility functions
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
0026 767C 0649  14         dect  stack
0027 767E C64B  30         mov   r11,*stack            ; Save return address
0028 7680 0649  14         dect  stack
0029 7682 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7684 0649  14         dect  stack
0031 7686 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 7688 0649  14         dect  stack
0033 768A C646  30         mov   tmp2,*stack           ; Push tmp2
0034 768C 0649  14         dect  stack
0035 768E C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 7690 C820  54         mov   @parm1,@wyx           ; Set cursor
     7692 8350 
     7694 832A 
0040 7696 C160  34         mov   @parm2,tmp1           ; Get string to display
     7698 8352 
0041 769A 06A0  32         bl    @xutst0               ; Display string
     769C 241A 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 769E C120  34         mov   @parm2,tmp0
     76A0 8352 
0046 76A2 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 76A4 0984  56         srl   tmp0,8                ; Right justify
0048 76A6 C184  18         mov   tmp0,tmp2
0049 76A8 C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 76AA 0506  16         neg   tmp2
0051 76AC 0226  22         ai    tmp2,80               ; Number of bytes to fill
     76AE 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 76B0 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     76B2 8350 
0056 76B4 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 76B6 C804  38         mov   tmp0,@wyx             ; / Set cursor
     76B8 832A 
0058               
0059 76BA 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     76BC 23F4 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 76BE 0205  20         li    tmp1,32               ; Byte to fill
     76C0 0020 
0064               
0065 76C2 06A0  32         bl    @xfilv                ; Clear line
     76C4 228E 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 76C6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 76C8 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 76CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 76CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 76CE C2F9  30         mov   *stack+,r11           ; Pop R11
0078 76D0 045B  20         b     *r11                  ; Return to caller
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
0100 76D2 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     76D4 8350 
0101 76D6 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     76D8 8352 
0102 76DA 0649  14         dect  stack
0103 76DC C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 76DE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     76E0 767C 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 76E2 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 76E4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0140                       copy  "pane.utils.colorscheme.asm"
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
0021 76E6 0649  14         dect  stack
0022 76E8 C64B  30         mov   r11,*stack            ; Push return address
0023 76EA 0649  14         dect  stack
0024 76EC C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 76EE C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     76F0 A012 
0027 76F2 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     76F4 0008 
0028                                                   ; Last entry reached?
0029 76F6 1102  14         jlt   !
0030 76F8 04C4  14         clr   tmp0
0031 76FA 1001  14         jmp   pane.action.colorscheme.switch
0032 76FC 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 76FE C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     7700 A012 
0038 7702 06A0  32         bl    @pane.action.colorscheme.load
     7704 776E 
0039                       ;-------------------------------------------------------
0040                       ; Show current color scheme message
0041                       ;-------------------------------------------------------
0042 7706 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     7708 832A 
     770A 833C 
0043               
0044 770C 06A0  32         bl    @filv
     770E 2288 
0045 7710 183C                   data >183C,>1F,20     ; VDP start address (frame buffer area)
     7712 001F 
     7714 0014 
0046               
0047 7716 06A0  32         bl    @putat
     7718 243C 
0048 771A 003C                   byte 0,60
0049 771C 3326                   data txt.colorscheme  ; Show color scheme message
0050               
0051 771E 06A0  32         bl    @putnum
     7720 2A00 
0052 7722 004B                   byte 0,75
0053 7724 A012                   data tv.colorscheme,rambuf,>3020
     7726 8390 
     7728 3020 
0054               
0055 772A C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     772C 833C 
     772E 832A 
0056                       ;-------------------------------------------------------
0057                       ; Delay
0058                       ;-------------------------------------------------------
0059 7730 0204  20         li    tmp0,12000
     7732 2EE0 
0060 7734 0604  14 !       dec   tmp0
0061 7736 16FE  14         jne   -!
0062                       ;-------------------------------------------------------
0063                       ; Setup one shot task for removing message
0064                       ;-------------------------------------------------------
0065 7738 0204  20         li    tmp0,pane.action.colorscheme.task.callback
     773A 774C 
0066 773C C804  38         mov   tmp0,@tv.task.oneshot
     773E A01C 
0067               
0068 7740 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     7742 2DD6 
0069 7744 0003                   data 3                ; / for getting consistent delay
0070                       ;-------------------------------------------------------
0071                       ; Exit
0072                       ;-------------------------------------------------------
0073               pane.action.colorscheme.cycle.exit:
0074 7746 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 7748 C2F9  30         mov   *stack+,r11           ; Pop R11
0076 774A 045B  20         b     *r11                  ; Return to caller
0077                       ;-------------------------------------------------------
0078                       ; Remove colorscheme message (triggered by oneshot task)
0079                       ;-------------------------------------------------------
0080               pane.action.colorscheme.task.callback:
0081 774C 0649  14         dect  stack
0082 774E C64B  30         mov   r11,*stack            ; Push return address
0083               
0084 7750 06A0  32         bl    @filv
     7752 2288 
0085 7754 003C                   data >003C,>00,20     ; Remove message
     7756 0000 
     7758 0014 
0086               
0087 775A 0720  34         seto  @parm1
     775C 8350 
0088 775E 06A0  32         bl    @pane.action.colorscheme.load
     7760 776E 
0089                                                   ; Reload current colorscheme
0090                                                   ; \ i  parm1 = Do not turn screen off
0091                                                   ; /
0092               
0093 7762 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     7764 A116 
0094 7766 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     7768 A01C 
0095               
0096 776A C2F9  30         mov   *stack+,r11           ; Pop R11
0097 776C 045B  20         b     *r11                  ; Return to task
0098               
0099               
0100               
0101               ***************************************************************
0102               * pane.action.colorscheme.load
0103               * Load color scheme
0104               ***************************************************************
0105               * bl  @pane.action.colorscheme.load
0106               *--------------------------------------------------------------
0107               * INPUT
0108               * @tv.colorscheme = Index into color scheme table
0109               * @parm1          = Skip screen off if >FFFF
0110               *--------------------------------------------------------------
0111               * OUTPUT
0112               * none
0113               *--------------------------------------------------------------
0114               * Register usage
0115               * tmp0,tmp1,tmp2,tmp3,tmp4
0116               ********|*****|*********************|**************************
0117               pane.action.colorscheme.load:
0118 776E 0649  14         dect  stack
0119 7770 C64B  30         mov   r11,*stack            ; Save return address
0120 7772 0649  14         dect  stack
0121 7774 C644  30         mov   tmp0,*stack           ; Push tmp0
0122 7776 0649  14         dect  stack
0123 7778 C645  30         mov   tmp1,*stack           ; Push tmp1
0124 777A 0649  14         dect  stack
0125 777C C646  30         mov   tmp2,*stack           ; Push tmp2
0126 777E 0649  14         dect  stack
0127 7780 C647  30         mov   tmp3,*stack           ; Push tmp3
0128 7782 0649  14         dect  stack
0129 7784 C648  30         mov   tmp4,*stack           ; Push tmp4
0130                       ;-------------------------------------------------------
0131                       ; Turn screen of
0132                       ;-------------------------------------------------------
0133 7786 C120  34         mov   @parm1,tmp0
     7788 8350 
0134 778A 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     778C FFFF 
0135 778E 1302  14         jeq   !                     ; Yes, so skip screen off
0136 7790 06A0  32         bl    @scroff               ; Turn screen off
     7792 2640 
0137                       ;-------------------------------------------------------
0138                       ; Get framebuffer foreground/background color
0139                       ;-------------------------------------------------------
0140 7794 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7796 A012 
0141 7798 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0142 779A 0224  22         ai    tmp0,tv.colorscheme.table
     779C 30A6 
0143                                                   ; Add base for color scheme data table
0144 779E C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0145 77A0 C807  38         mov   tmp3,@tv.color        ; Save colors
     77A2 A018 
0146                       ;-------------------------------------------------------
0147                       ; Get and save cursor color
0148                       ;-------------------------------------------------------
0149 77A4 C214  26         mov   *tmp0,tmp4            ; Get cursor color
0150 77A6 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     77A8 00FF 
0151 77AA C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     77AC A016 
0152                       ;-------------------------------------------------------
0153                       ; Get CMDB pane foreground/background color
0154                       ;-------------------------------------------------------
0155 77AE C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0156 77B0 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     77B2 FF00 
0157 77B4 0988  56         srl   tmp4,8                ; MSB to LSB
0158                       ;-------------------------------------------------------
0159                       ; Dump colors to VDP register 7 (text mode)
0160                       ;-------------------------------------------------------
0161 77B6 C147  18         mov   tmp3,tmp1             ; Get work copy
0162 77B8 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0163 77BA 0265  22         ori   tmp1,>0700
     77BC 0700 
0164 77BE C105  18         mov   tmp1,tmp0
0165 77C0 06A0  32         bl    @putvrx               ; Write VDP register
     77C2 232E 
0166                       ;-------------------------------------------------------
0167                       ; Dump colors for frame buffer pane (TAT)
0168                       ;-------------------------------------------------------
0169 77C4 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     77C6 1800 
0170 77C8 C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0171 77CA 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0172 77CC 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     77CE 0910 
0173 77D0 06A0  32         bl    @xfilv                ; Fill colors
     77D2 228E 
0174                                                   ; i \  tmp0 = start address
0175                                                   ; i |  tmp1 = byte to fill
0176                                                   ; i /  tmp2 = number of bytes to fill
0177                       ;-------------------------------------------------------
0178                       ; Dump colors for CMDB pane (TAT)
0179                       ;-------------------------------------------------------
0180               pane.action.colorscheme.cmdbpane:
0181 77D4 C120  34         mov   @cmdb.visible,tmp0
     77D6 A302 
0182 77D8 1307  14         jeq   pane.action.colorscheme.errpane
0183                                                   ; Skip if CMDB pane is hidden
0184               
0185 77DA 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     77DC 1FD0 
0186 77DE C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0187 77E0 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     77E2 0190 
0188 77E4 06A0  32         bl    @xfilv                ; Fill colors
     77E6 228E 
0189                                                   ; i \  tmp0 = start address
0190                                                   ; i |  tmp1 = byte to fill
0191                                                   ; i /  tmp2 = number of bytes to fill
0192                       ;-------------------------------------------------------
0193                       ; Dump colors for error line pane (TAT)
0194                       ;-------------------------------------------------------
0195               pane.action.colorscheme.errpane:
0196 77E8 C120  34         mov   @tv.error.visible,tmp0
     77EA A01E 
0197 77EC 1304  14         jeq   pane.action.colorscheme.statusline
0198                                                   ; Skip if error line pane is hidden
0199               
0200 77EE 0205  20         li    tmp1,>00f6            ; White on dark red
     77F0 00F6 
0201 77F2 06A0  32         bl    @pane.action.colorscheme.errline
     77F4 7828 
0202                                                   ; Load color combination for error line
0203                       ;-------------------------------------------------------
0204                       ; Dump colors for bottom status line pane (TAT)
0205                       ;-------------------------------------------------------
0206               pane.action.colorscheme.statusline:
0207 77F6 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     77F8 2110 
0208 77FA C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0209 77FC 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     77FE 00FF 
0210 7800 0206  20         li    tmp2,80               ; Number of bytes to fill
     7802 0050 
0211 7804 06A0  32         bl    @xfilv                ; Fill colors
     7806 228E 
0212                                                   ; i \  tmp0 = start address
0213                                                   ; i |  tmp1 = byte to fill
0214                                                   ; i /  tmp2 = number of bytes to fill
0215                       ;-------------------------------------------------------
0216                       ; Dump cursor FG color to sprite table (SAT)
0217                       ;-------------------------------------------------------
0218               pane.action.colorscheme.cursorcolor:
0219 7808 C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     780A A016 
0220 780C 0A88  56         sla   tmp4,8                ; Move to MSB
0221 780E D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7810 8383 
0222 7812 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7814 A015 
0223                       ;-------------------------------------------------------
0224                       ; Exit
0225                       ;-------------------------------------------------------
0226               pane.action.colorscheme.load.exit:
0227 7816 06A0  32         bl    @scron                ; Turn screen on
     7818 2648 
0228 781A C239  30         mov   *stack+,tmp4          ; Pop tmp4
0229 781C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0230 781E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0231 7820 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0232 7822 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0233 7824 C2F9  30         mov   *stack+,r11           ; Pop R11
0234 7826 045B  20         b     *r11                  ; Return to caller
0235               
0236               
0237               
0238               ***************************************************************
0239               * pane.action.colorscheme.errline
0240               * Load color scheme for error line
0241               ***************************************************************
0242               * bl  @pane.action.colorscheme.errline
0243               *--------------------------------------------------------------
0244               * INPUT
0245               * @tmp1 = Foreground / Background color
0246               *--------------------------------------------------------------
0247               * OUTPUT
0248               * none
0249               *--------------------------------------------------------------
0250               * Register usage
0251               * tmp0,tmp1,tmp2
0252               ********|*****|*********************|**************************
0253               pane.action.colorscheme.errline:
0254 7828 0649  14         dect  stack
0255 782A C64B  30         mov   r11,*stack            ; Save return address
0256 782C 0649  14         dect  stack
0257 782E C644  30         mov   tmp0,*stack           ; Push tmp0
0258 7830 0649  14         dect  stack
0259 7832 C645  30         mov   tmp1,*stack           ; Push tmp1
0260 7834 0649  14         dect  stack
0261 7836 C646  30         mov   tmp2,*stack           ; Push tmp2
0262                       ;-------------------------------------------------------
0263                       ; Load error line colors
0264                       ;-------------------------------------------------------
0265 7838 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     783A 20C0 
0266 783C 0206  20         li    tmp2,80               ; Number of bytes to fill
     783E 0050 
0267 7840 06A0  32         bl    @xfilv                ; Fill colors
     7842 228E 
0268                                                   ; i \  tmp0 = start address
0269                                                   ; i |  tmp1 = byte to fill
0270                                                   ; i /  tmp2 = number of bytes to fill
0271                       ;-------------------------------------------------------
0272                       ; Exit
0273                       ;-------------------------------------------------------
0274               pane.action.colorscheme.errline.exit:
0275 7844 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0276 7846 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0277 7848 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0278 784A C2F9  30         mov   *stack+,r11           ; Pop R11
0279 784C 045B  20         b     *r11                  ; Return to caller
0280               
**** **** ****     > stevie_b1.asm.37551
0141                                                   ; Colorscheme handling in panes
0142                       copy  "pane.utils.tipiclock.asm"
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
0021 784E 0649  14         dect  stack
0022 7850 C64B  30         mov   r11,*stack            ; Push return address
0023 7852 0649  14         dect  stack
0024 7854 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;-------------------------------------------------------
0026                       ; Read DV80 file
0027                       ;-------------------------------------------------------
0028 7856 0204  20         li    tmp0,fdname.clock
     7858 33D4 
0029 785A C804  38         mov   tmp0,@parm1           ; Pointer to length-prefixed 'PI.CLOCK'
     785C 8350 
0030               
0031 785E 0204  20         li    tmp0,_pane.tipi.clock.cb.noop
     7860 7880 
0032 7862 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7864 8352 
0033 7866 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7868 8354 
0034 786A C804  38         mov   tmp0,@parm5           ; Register callback 4 (ignore IO errors)
     786C 8358 
0035               
0036 786E 0204  20         li    tmp0,_pane.tipi.clock.cb.datetime
     7870 7882 
0037 7872 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7874 8356 
0038               
0039 7876 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     7878 6EE0 
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
0055 787A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 787C C2F9  30         mov   *stack+,r11           ; Pop R11
0057 787E 045B  20         b     *r11                  ; Return to caller
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
0070 7880 069B  24         bl    *r11                  ; Return to caller
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
0083 7882 069B  24         bl    *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0143                                                   ; TIPI clock
0144                       ;-----------------------------------------------------------------------
0145                       ; Screen panes
0146                       ;-----------------------------------------------------------------------
0147                       copy  "pane.cmdb.asm"       ; Command buffer
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
0021 7884 0649  14         dect  stack
0022 7886 C64B  30         mov   r11,*stack            ; Save return address
0023 7888 0649  14         dect  stack
0024 788A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 788C 0649  14         dect  stack
0026 788E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7890 0649  14         dect  stack
0028 7892 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 7894 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7896 A30E 
     7898 832A 
0033 789A C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     789C A31C 
0034 789E 06A0  32         bl    @xutst0               ; /
     78A0 241A 
0035               
0036 78A2 06A0  32         bl    @setx
     78A4 2696 
0037 78A6 000E                   data 14               ; Position cursor
0038               
0039 78A8 06A0  32         bl    @putstr               ; Display horizontal line
     78AA 2418 
0040 78AC 32D2                   data txt.cmdb.hbar
0041                       ;------------------------------------------------------
0042                       ; Clear lines after prompt in command buffer
0043                       ;------------------------------------------------------
0044 78AE C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     78B0 A322 
0045 78B2 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0046 78B4 A120  34         a     @cmdb.yxprompt,tmp0   ; |
     78B6 A310 
0047 78B8 C804  38         mov   tmp0,@wyx             ; /
     78BA 832A 
0048               
0049 78BC 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     78BE 23F4 
0050                                                   ; \ i  @wyx = Cursor position
0051                                                   ; / o  tmp0 = VDP target address
0052               
0053 78C0 0205  20         li    tmp1,32
     78C2 0020 
0054               
0055 78C4 C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     78C6 A322 
0056 78C8 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0057 78CA 0506  16         neg   tmp2                  ; | Based on command & prompt length
0058 78CC 0226  22         ai    tmp2,2*80 - 1         ; /
     78CE 009F 
0059               
0060 78D0 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     78D2 228E 
0061                                                   ; | i  tmp0 = VDP target address
0062                                                   ; | i  tmp1 = Byte to fill
0063                                                   ; / i  tmp2 = Number of bytes to fill
0064                       ;------------------------------------------------------
0065                       ; Display pane hint in command buffer
0066                       ;------------------------------------------------------
0067 78D4 0204  20         li    tmp0,>1c00            ; Y=28, X=0
     78D6 1C00 
0068 78D8 C804  38         mov   tmp0,@parm1           ; Set parameter
     78DA 8350 
0069 78DC C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     78DE A31E 
     78E0 8352 
0070               
0071 78E2 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     78E4 767C 
0072                                                   ; \ i  parm1 = Pointer to string with hint
0073                                                   ; / i  parm2 = YX position
0074                       ;------------------------------------------------------
0075                       ; Display keys in status line
0076                       ;------------------------------------------------------
0077 78E6 0204  20         li    tmp0,>1d00            ; Y = 29, X=0
     78E8 1D00 
0078 78EA C804  38         mov   tmp0,@parm1           ; Set parameter
     78EC 8350 
0079 78EE C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     78F0 A320 
     78F2 8352 
0080               
0081 78F4 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     78F6 767C 
0082                                                   ; \ i  parm1 = Pointer to string with hint
0083                                                   ; / i  parm2 = YX position
0084                       ;------------------------------------------------------
0085                       ; Command buffer content
0086                       ;------------------------------------------------------
0087 78F8 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     78FA 6E0A 
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               pane.cmdb.exit:
0092 78FC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0093 78FE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 7900 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 7902 C2F9  30         mov   *stack+,r11           ; Pop r11
0096 7904 045B  20         b     *r11                  ; Return
0097               
0098               
0099               ***************************************************************
0100               * pane.cmdb.show
0101               * Show command buffer pane
0102               ***************************************************************
0103               * bl @pane.cmdb.show
0104               *--------------------------------------------------------------
0105               * INPUT
0106               * none
0107               *--------------------------------------------------------------
0108               * OUTPUT
0109               * none
0110               *--------------------------------------------------------------
0111               * Register usage
0112               * none
0113               *--------------------------------------------------------------
0114               * Notes
0115               ********|*****|*********************|**************************
0116               pane.cmdb.show:
0117 7906 0649  14         dect  stack
0118 7908 C64B  30         mov   r11,*stack            ; Save return address
0119 790A 0649  14         dect  stack
0120 790C C644  30         mov   tmp0,*stack           ; Push tmp0
0121                       ;------------------------------------------------------
0122                       ; Show command buffer pane
0123                       ;------------------------------------------------------
0124 790E C820  54         mov   @wyx,@cmdb.fb.yxsave
     7910 832A 
     7912 A304 
0125                                                   ; Save YX position in frame buffer
0126               
0127 7914 C120  34         mov   @fb.scrrows.max,tmp0
     7916 A11A 
0128 7918 6120  34         s     @cmdb.scrrows,tmp0
     791A A306 
0129 791C C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     791E A118 
0130               
0131 7920 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0132 7922 C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7924 A30E 
0133               
0134 7926 0224  22         ai    tmp0,>0100
     7928 0100 
0135 792A C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     792C A310 
0136 792E 0584  14         inc   tmp0
0137 7930 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7932 A30A 
0138               
0139 7934 0720  34         seto  @cmdb.visible         ; Show pane
     7936 A302 
0140 7938 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     793A A318 
0141               
0142 793C 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     793E 0001 
0143 7940 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7942 A01A 
0144               
0145                       ;bl    @cmdb.cmd.clear      ; Clear current command
0146               
0147 7944 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7946 79C2 
0148               
0149 7948 06A0  32         bl    @pane.action.colorscheme.load
     794A 776E 
0150                                                   ; Reload colorscheme
0151               pane.cmdb.show.exit:
0152                       ;------------------------------------------------------
0153                       ; Exit
0154                       ;------------------------------------------------------
0155 794C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0156 794E C2F9  30         mov   *stack+,r11           ; Pop r11
0157 7950 045B  20         b     *r11                  ; Return to caller
0158               
0159               
0160               
0161               ***************************************************************
0162               * pane.cmdb.hide
0163               * Hide command buffer pane
0164               ***************************************************************
0165               * bl @pane.cmdb.hide
0166               *--------------------------------------------------------------
0167               * INPUT
0168               * none
0169               *--------------------------------------------------------------
0170               * OUTPUT
0171               * none
0172               *--------------------------------------------------------------
0173               * Register usage
0174               * none
0175               *--------------------------------------------------------------
0176               * Hiding the command buffer automatically passes pane focus
0177               * to frame buffer.
0178               ********|*****|*********************|**************************
0179               pane.cmdb.hide:
0180 7952 0649  14         dect  stack
0181 7954 C64B  30         mov   r11,*stack            ; Save return address
0182                       ;------------------------------------------------------
0183                       ; Hide command buffer pane
0184                       ;------------------------------------------------------
0185 7956 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7958 A11A 
     795A A118 
0186                       ;------------------------------------------------------
0187                       ; Adjust frame buffer size if error pane visible
0188                       ;------------------------------------------------------
0189 795C C820  54         mov   @tv.error.visible,@tv.error.visible
     795E A01E 
     7960 A01E 
0190 7962 1302  14         jeq   !
0191 7964 0620  34         dec   @fb.scrrows
     7966 A118 
0192                       ;------------------------------------------------------
0193                       ; Clear error/hint & status line
0194                       ;------------------------------------------------------
0195 7968 06A0  32 !       bl    @hchar
     796A 2774 
0196 796C 1C00                   byte 28,0,32,80*2
     796E 20A0 
0197 7970 FFFF                   data EOL
0198                       ;------------------------------------------------------
0199                       ; Hide command buffer pane (rest)
0200                       ;------------------------------------------------------
0201 7972 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7974 A304 
     7976 832A 
0202 7978 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     797A A302 
0203 797C 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     797E A116 
0204 7980 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7982 A01A 
0205                       ;------------------------------------------------------
0206                       ; Reload current color scheme
0207                       ;------------------------------------------------------
0208 7984 0720  34         seto  @parm1                ; Do not turn screen off while
     7986 8350 
0209                                                   ; reloading color scheme
0210               
0211 7988 06A0  32         bl    @pane.action.colorscheme.load
     798A 776E 
0212                                                   ; Reload color scheme
0213                       ;------------------------------------------------------
0214                       ; Exit
0215                       ;------------------------------------------------------
0216               pane.cmdb.hide.exit:
0217 798C C2F9  30         mov   *stack+,r11           ; Pop r11
0218 798E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0148                       copy  "pane.errline.asm"    ; Error line
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
0026 7990 0649  14         dect  stack
0027 7992 C64B  30         mov   r11,*stack            ; Save return address
0028 7994 0649  14         dect  stack
0029 7996 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7998 0649  14         dect  stack
0031 799A C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 799C 0205  20         li    tmp1,>00f6            ; White on dark red
     799E 00F6 
0034 79A0 06A0  32         bl    @pane.action.colorscheme.errline
     79A2 7828 
0035                       ;------------------------------------------------------
0036                       ; Show error line content
0037                       ;------------------------------------------------------
0038 79A4 06A0  32         bl    @putat                ; Display error message
     79A6 243C 
0039 79A8 1C00                   byte 28,0
0040 79AA A020                   data tv.error.msg
0041               
0042 79AC C120  34         mov   @fb.scrrows.max,tmp0
     79AE A11A 
0043 79B0 0604  14         dec   tmp0
0044 79B2 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     79B4 A118 
0045               
0046 79B6 0720  34         seto  @tv.error.visible     ; Error line is visible
     79B8 A01E 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               pane.errline.show.exit:
0051 79BA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 79BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 79BE C2F9  30         mov   *stack+,r11           ; Pop r11
0054 79C0 045B  20         b     *r11                  ; Return to caller
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
0076 79C2 0649  14         dect  stack
0077 79C4 C64B  30         mov   r11,*stack            ; Save return address
0078                       ;------------------------------------------------------
0079                       ; Hide command buffer pane
0080                       ;------------------------------------------------------
0081 79C6 06A0  32 !       bl    @errline.init         ; Clear error line
     79C8 6EBC 
0082 79CA C160  34         mov   @tv.color,tmp1        ; Get foreground/background color
     79CC A018 
0083 79CE 06A0  32         bl    @pane.action.colorscheme.errline
     79D0 7828 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               pane.errline.hide.exit:
0088 79D2 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 79D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.37551
0149                       copy  "pane.botline.asm"    ; Status line
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
0021 79D6 0649  14         dect  stack
0022 79D8 C64B  30         mov   r11,*stack            ; Save return address
0023 79DA 0649  14         dect  stack
0024 79DC C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 79DE C820  54         mov   @wyx,@fb.yxsave
     79E0 832A 
     79E2 A114 
0027                       ;------------------------------------------------------
0028                       ; Show buffer number
0029                       ;------------------------------------------------------
0030               pane.botline.bufnum:
0031 79E4 06A0  32         bl    @putat
     79E6 243C 
0032 79E8 1D00                   byte  29,0
0033 79EA 3102                   data  txt.bufnum
0034                       ;------------------------------------------------------
0035                       ; Show current file
0036                       ;------------------------------------------------------
0037               pane.botline.show_file:
0038 79EC 06A0  32         bl    @at
     79EE 2680 
0039 79F0 1D03                   byte  29,3            ; Position cursor
0040 79F2 C160  34         mov   @edb.filename.ptr,tmp1
     79F4 A20E 
0041                                                   ; Get string to display
0042 79F6 06A0  32         bl    @xutst0               ; Display string
     79F8 241A 
0043               
0044 79FA 06A0  32         bl    @at
     79FC 2680 
0045 79FE 1D2C                   byte  29,44           ; Position cursor
0046               
0047 7A00 C160  34         mov   @edb.filetype.ptr,tmp1
     7A02 A210 
0048                                                   ; Get string to display
0049 7A04 06A0  32         bl    @xutst0               ; Display Filetype string
     7A06 241A 
0050                       ;------------------------------------------------------
0051                       ; Show text editing mode
0052                       ;------------------------------------------------------
0053               pane.botline.show_mode:
0054 7A08 C120  34         mov   @edb.insmode,tmp0
     7A0A A20A 
0055 7A0C 1605  14         jne   pane.botline.show_mode.insert
0056                       ;------------------------------------------------------
0057                       ; Overwrite mode
0058                       ;------------------------------------------------------
0059               pane.botline.show_mode.overwrite:
0060 7A0E 06A0  32         bl    @putat
     7A10 243C 
0061 7A12 1D32                   byte  29,50
0062 7A14 30D8                   data  txt.ovrwrite
0063 7A16 1004  14         jmp   pane.botline.show_changed
0064                       ;------------------------------------------------------
0065                       ; Insert  mode
0066                       ;------------------------------------------------------
0067               pane.botline.show_mode.insert:
0068 7A18 06A0  32         bl    @putat
     7A1A 243C 
0069 7A1C 1D32                   byte  29,50
0070 7A1E 30DC                   data  txt.insert
0071                       ;------------------------------------------------------
0072                       ; Show if text was changed in editor buffer
0073                       ;------------------------------------------------------
0074               pane.botline.show_changed:
0075 7A20 C120  34         mov   @edb.dirty,tmp0
     7A22 A206 
0076 7A24 1305  14         jeq   pane.botline.show_changed.clear
0077                       ;------------------------------------------------------
0078                       ; Show "*"
0079                       ;------------------------------------------------------
0080 7A26 06A0  32         bl    @putat
     7A28 243C 
0081 7A2A 1D36                   byte 29,54
0082 7A2C 30E0                   data txt.star
0083 7A2E 1001  14         jmp   pane.botline.show_linecol
0084                       ;------------------------------------------------------
0085                       ; Show "line,column"
0086                       ;------------------------------------------------------
0087               pane.botline.show_changed.clear:
0088 7A30 1000  14         nop
0089               pane.botline.show_linecol:
0090 7A32 C820  54         mov   @fb.row,@parm1
     7A34 A106 
     7A36 8350 
0091 7A38 06A0  32         bl    @fb.row2line
     7A3A 686C 
0092 7A3C 05A0  34         inc   @outparm1
     7A3E 8360 
0093                       ;------------------------------------------------------
0094                       ; Show line
0095                       ;------------------------------------------------------
0096 7A40 06A0  32         bl    @putnum
     7A42 2A00 
0097 7A44 1D40                   byte  29,64           ; YX
0098 7A46 8360                   data  outparm1,rambuf
     7A48 8390 
0099 7A4A 3020                   byte  48              ; ASCII offset
0100                             byte  32              ; Padding character
0101                       ;------------------------------------------------------
0102                       ; Show comma
0103                       ;------------------------------------------------------
0104 7A4C 06A0  32         bl    @putat
     7A4E 243C 
0105 7A50 1D45                   byte  29,69
0106 7A52 30CA                   data  txt.delim
0107                       ;------------------------------------------------------
0108                       ; Show column
0109                       ;------------------------------------------------------
0110 7A54 06A0  32         bl    @film
     7A56 2230 
0111 7A58 8396                   data rambuf+6,32,12   ; Clear work buffer with space character
     7A5A 0020 
     7A5C 000C 
0112               
0113 7A5E C820  54         mov   @fb.column,@waux1
     7A60 A10C 
     7A62 833C 
0114 7A64 05A0  34         inc   @waux1                ; Offset 1
     7A66 833C 
0115               
0116 7A68 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7A6A 2982 
0117 7A6C 833C                   data  waux1,rambuf
     7A6E 8390 
0118 7A70 3020                   byte  48              ; ASCII offset
0119                             byte  32              ; Fill character
0120               
0121 7A72 06A0  32         bl    @trimnum              ; Trim number to the left
     7A74 29DA 
0122 7A76 8390                   data  rambuf,rambuf+6,32
     7A78 8396 
     7A7A 0020 
0123               
0124 7A7C 0204  20         li    tmp0,>0200
     7A7E 0200 
0125 7A80 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7A82 8396 
0126               
0127 7A84 06A0  32         bl    @putat
     7A86 243C 
0128 7A88 1D46                   byte 29,70
0129 7A8A 8396                   data rambuf+6         ; Show column
0130                       ;------------------------------------------------------
0131                       ; Show lines in buffer unless on last line in file
0132                       ;------------------------------------------------------
0133 7A8C C820  54         mov   @fb.row,@parm1
     7A8E A106 
     7A90 8350 
0134 7A92 06A0  32         bl    @fb.row2line
     7A94 686C 
0135 7A96 8820  54         c     @edb.lines,@outparm1
     7A98 A204 
     7A9A 8360 
0136 7A9C 1605  14         jne   pane.botline.show_lines_in_buffer
0137               
0138 7A9E 06A0  32         bl    @putat
     7AA0 243C 
0139 7AA2 1D4B                   byte 29,75
0140 7AA4 30D2                   data txt.bottom
0141               
0142 7AA6 100B  14         jmp   pane.botline.exit
0143                       ;------------------------------------------------------
0144                       ; Show lines in buffer
0145                       ;------------------------------------------------------
0146               pane.botline.show_lines_in_buffer:
0147 7AA8 C820  54         mov   @edb.lines,@waux1
     7AAA A204 
     7AAC 833C 
0148 7AAE 05A0  34         inc   @waux1                ; Offset 1
     7AB0 833C 
0149 7AB2 06A0  32         bl    @putnum
     7AB4 2A00 
0150 7AB6 1D4B                   byte 29,75            ; YX
0151 7AB8 833C                   data waux1,rambuf
     7ABA 8390 
0152 7ABC 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 7ABE C820  54         mov   @fb.yxsave,@wyx
     7AC0 A114 
     7AC2 832A 
0159 7AC4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 7AC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7AC8 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.37551
0150                       ;-----------------------------------------------------------------------
0151                       ; Dialogs
0152                       ;-----------------------------------------------------------------------
0153                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
**** **** ****     > dialog.load.asm
0001               * FILE......: dialog.load.asm
0002               * Purpose...: Dialog "Load file"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Open DV80 file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.load
0011               * Open Dialog for loading DV 80 file
0012               ***************************************************************
0013               * b @dialog.load
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
0026               dialog.load:
0027 7ACA 0204  20         li    tmp0,id.dialog.load
     7ACC 0001 
0028 7ACE C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7AD0 A31A 
0029               
0030 7AD2 0204  20         li    tmp0,txt.head.load
     7AD4 311E 
0031 7AD6 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7AD8 A31C 
0032               
0033 7ADA 0204  20         li    tmp0,txt.hint.load
     7ADC 312E 
0034 7ADE C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7AE0 A31E 
0035               
0036 7AE2 0204  20         li    tmp0,txt.keys.load
     7AE4 3164 
0037 7AE6 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7AE8 A320 
0038               
0039 7AEA 0460  28         b     @edkey.action.cmdb.show
     7AEC 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.37551
0154                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
**** **** ****     > dialog.save.asm
0001               * FILE......: dialog.save.asm
0002               * Purpose...: Dialog "Save file"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Save DV80 file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.save
0011               * Open Dialog for saving file
0012               ***************************************************************
0013               * b @dialog.save
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
0026               dialog.save:
0027 7AEE 0204  20         li    tmp0,id.dialog.save
     7AF0 0002 
0028 7AF2 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7AF4 A31A 
0029               
0030 7AF6 0204  20         li    tmp0,txt.head.save
     7AF8 31A8 
0031 7AFA C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7AFC A31C 
0032               
0033 7AFE 0204  20         li    tmp0,txt.hint.save
     7B00 31B8 
0034 7B02 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7B04 A31E 
0035               
0036 7B06 0204  20         li    tmp0,txt.keys.save
     7B08 31EE 
0037 7B0A C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7B0C A320 
0038               
0039 7B0E 0460  28         b     @edkey.action.cmdb.show
     7B10 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.37551
0155                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
**** **** ****     > dialog.unsaved.asm
0001               * FILE......: dialog.unsaved.asm
0002               * Purpose...: Dialog "Unsaved changes"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *      Stevie Editor - Unsaved changes in editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.unsaved
0011               * Open Dialog "Unsaved changes"
0012               ***************************************************************
0013               * b @dialog.unsaved
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
0026               dialog.unsaved:
0027 7B12 0204  20         li    tmp0,id.dialog.unsaved
     7B14 0003 
0028 7B16 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7B18 A31A 
0029               
0030 7B1A 0204  20         li    tmp0,txt.head.unsaved
     7B1C 3218 
0031 7B1E C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7B20 A31C 
0032               
0033 7B22 0204  20         li    tmp0,txt.hint.unsaved
     7B24 3228 
0034 7B26 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7B28 A31E 
0035               
0036 7B2A 0204  20         li    tmp0,txt.keys.unsaved
     7B2C 3250 
0037 7B2E C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7B30 A320 
0038               
0039 7B32 0460  28         b     @edkey.action.cmdb.show
     7B34 6738 
0040                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.37551
0156                       ;-----------------------------------------------------------------------
0157                       ; Program data
0158                       ;-----------------------------------------------------------------------
0159                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0011      0200     key.fctn.4    equ >0200             ; fctn + 4
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
0046      B900     key.fctn.dot    equ >b900           ; fctn + .
0047      B800     key.fctn.comma  equ >b800           ; fctn + ,
0048      0500     key.fctn.plus   equ >0500           ; fctn + +
0049               *---------------------------------------------------------------
0050               * Keyboard scancodes - control keys
0051               *-------------|---------------------|---------------------------
0052      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0053      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0054      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0055      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0056      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0057      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0058      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0059      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0060      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0061      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0062      8100     key.ctrl.a    equ >8100             ; ctrl + a
0063      8200     key.ctrl.b    equ >8200             ; ctrl + b
0064      0000     key.ctrl.c    equ >0000             ; ctrl + c
0065      8400     key.ctrl.d    equ >8400             ; ctrl + d
0066      8500     key.ctrl.e    equ >8500             ; ctrl + e
0067      8600     key.ctrl.f    equ >8600             ; ctrl + f
0068      0000     key.ctrl.g    equ >0000             ; ctrl + g
0069      0000     key.ctrl.h    equ >0000             ; ctrl + h
0070      0000     key.ctrl.i    equ >0000             ; ctrl + i
0071      0000     key.ctrl.j    equ >0000             ; ctrl + j
0072      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0073      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0074      0000     key.ctrl.m    equ >0000             ; ctrl + m
0075      0000     key.ctrl.n    equ >0000             ; ctrl + n
0076      0000     key.ctrl.o    equ >0000             ; ctrl + o
0077      0000     key.ctrl.p    equ >0000             ; ctrl + p
0078      0000     key.ctrl.q    equ >0000             ; ctrl + q
0079      0000     key.ctrl.r    equ >0000             ; ctrl + r
0080      9300     key.ctrl.s    equ >9300             ; ctrl + s
0081      9400     key.ctrl.t    equ >9400             ; ctrl + t
0082      0000     key.ctrl.u    equ >0000             ; ctrl + u
0083      0000     key.ctrl.v    equ >0000             ; ctrl + v
0084      0000     key.ctrl.w    equ >0000             ; ctrl + w
0085      9800     key.ctrl.x    equ >9800             ; ctrl + x
0086      0000     key.ctrl.y    equ >0000             ; ctrl + y
0087      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0088               *---------------------------------------------------------------
0089               * Keyboard scancodes - control keys extra
0090               *---------------------------------------------------------------
0091      9B00     key.ctrl.dot    equ >9b00           ; ctrl + .
0092      8000     key.ctrl.comma  equ >8000           ; ctrl + ,
0093      9D00     key.ctrl.plus   equ >9d00           ; ctrl + +
0094               *---------------------------------------------------------------
0095               * Special keys
0096               *---------------------------------------------------------------
0097      0D00     key.enter     equ >0d00             ; enter
0098               
0099               
0100               
0101               *---------------------------------------------------------------
0102               * Keyboard labels - Function keys
0103               *---------------------------------------------------------------
0104               txt.fctn.0
0105 7B36 0866             byte  8
0106 7B37 ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 7B40 0866             byte  8
0111 7B41 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 7B4A 0866             byte  8
0116 7B4B ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 7B54 0866             byte  8
0121 7B55 ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 7B5E 0866             byte  8
0126 7B5F ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 7B68 0866             byte  8
0131 7B69 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 7B72 0866             byte  8
0136 7B73 ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 7B7C 0866             byte  8
0141 7B7D ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 7B86 0866             byte  8
0146 7B87 ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 7B90 0866             byte  8
0151 7B91 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 7B9A 0866             byte  8
0156 7B9B ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 7BA4 0866             byte  8
0161 7BA5 ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 7BAE 0866             byte  8
0166 7BAF ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 7BB8 0866             byte  8
0171 7BB9 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 7BC2 0866             byte  8
0176 7BC3 ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 7BCC 0866             byte  8
0181 7BCD ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 7BD6 0866             byte  8
0186 7BD7 ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 7BE0 0866             byte  8
0191 7BE1 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 7BEA 0866             byte  8
0196 7BEB ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 7BF4 0866             byte  8
0201 7BF5 ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 7BFE 0866             byte  8
0206 7BFF ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 7C08 0866             byte  8
0211 7C09 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 7C12 0866             byte  8
0216 7C13 ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 7C1C 0866             byte  8
0221 7C1D ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 7C26 0866             byte  8
0226 7C27 ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 7C30 0866             byte  8
0231 7C31 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 7C3A 0866             byte  8
0236 7C3B ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 7C44 0866             byte  8
0241 7C45 ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 7C4E 0866             byte  8
0246 7C4F ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 7C58 0866             byte  8
0251 7C59 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 7C62 0866             byte  8
0256 7C63 ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 7C6C 0866             byte  8
0261 7C6D ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 7C76 0866             byte  8
0266 7C77 ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 7C80 0866             byte  8
0271 7C81 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 7C8A 0866             byte  8
0276 7C8B ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 7C94 0866             byte  8
0281 7C95 ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 7C9E 0866             byte  8
0289 7C9F ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 7CA8 0866             byte  8
0294 7CA9 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 7CB2 0863             byte  8
0300 7CB3 ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 7CBC 0863             byte  8
0305 7CBD ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 7CC6 0863             byte  8
0313 7CC7 ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 7CD0 0863             byte  8
0318 7CD1 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 7CDA 0863             byte  8
0323 7CDB ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 7CE4 0863             byte  8
0328 7CE5 ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 7CEE 0863             byte  8
0333 7CEF ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 7CF8 0863             byte  8
0338 7CF9 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 7D02 0863             byte  8
0343 7D03 ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 7D0C 0863             byte  8
0348 7D0D ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 7D16 0863             byte  8
0353 7D17 ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 7D20 0863             byte  8
0358 7D21 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 7D2A 0863             byte  8
0363 7D2B ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 7D34 0863             byte  8
0368 7D35 ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 7D3E 0863             byte  8
0373 7D3F ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 7D48 0863             byte  8
0378 7D49 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 7D52 0863             byte  8
0383 7D53 ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 7D5C 0863             byte  8
0388 7D5D ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 7D66 0863             byte  8
0393 7D67 ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 7D70 0863             byte  8
0398 7D71 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 7D7A 0863             byte  8
0403 7D7B ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 7D84 0863             byte  8
0408 7D85 ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 7D8E 0863             byte  8
0413 7D8F ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 7D98 0863             byte  8
0418 7D99 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 7DA2 0863             byte  8
0423 7DA3 ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 7DAC 0863             byte  8
0428 7DAD ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 7DB6 0863             byte  8
0433 7DB7 ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 7DC0 0863             byte  8
0438 7DC1 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 7DCA 0863             byte  8
0443 7DCB ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 7DD4 0863             byte  8
0448 7DD5 ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 7DDE 0863             byte  8
0453 7DDF ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 7DE8 0863             byte  8
0458 7DE9 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 7DF2 0863             byte  8
0463 7DF3 ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 7DFC 0863             byte  8
0468 7DFD ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 7E06 0863             byte  8
0473 7E07 ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 7E10 0863             byte  8
0478 7E11 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 7E1A 0863             byte  8
0483 7E1B ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 7E24 0863             byte  8
0488 7E25 ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 7E2E 0863             byte  8
0496 7E2F ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 7E38 0565             byte  5
0504 7E39 ....             text  'enter'
0505                       even
0506               
0507               
0508               
0509               
0510               
0511               *---------------------------------------------------------------
0512               * Action keys mapping table: Editor
0513               *---------------------------------------------------------------
0514               keymap_actions.editor:
0515                       ;-------------------------------------------------------
0516                       ; Movement keys
0517                       ;-------------------------------------------------------
0518 7E3E 0D00             data  key.enter, txt.enter, edkey.action.enter
     7E40 7E38 
     7E42 6546 
0519 7E44 0800             data  key.fctn.s, txt.fctn.s, edkey.action.left
     7E46 7C4E 
     7E48 6144 
0520 7E4A 0900             data  key.fctn.d, txt.fctn.d, edkey.action.right
     7E4C 7BB8 
     7E4E 615A 
0521 7E50 0B00             data  key.fctn.e, txt.fctn.e, edkey.action.up
     7E52 7BC2 
     7E54 6172 
0522 7E56 0A00             data  key.fctn.x, txt.fctn.x, edkey.action.down
     7E58 7C80 
     7E5A 61C4 
0523 7E5C 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.home
     7E5E 7D2A 
     7E60 6230 
0524 7E62 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.end
     7E64 7D5C 
     7E66 6248 
0525 7E68 9300             data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
     7E6A 7DDE 
     7E6C 625C 
0526 7E6E 8400             data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
     7E70 7D48 
     7E72 62AE 
0527 7E74 8500             data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
     7E76 7D52 
     7E78 630E 
0528 7E7A 9800             data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
     7E7C 7E10 
     7E7E 6350 
0529 7E80 9400             data  key.ctrl.t, txt.ctrl.t, edkey.action.top
     7E82 7DE8 
     7E84 637C 
0530 7E86 8200             data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
     7E88 7D34 
     7E8A 63A8 
0531                       ;-------------------------------------------------------
0532                       ; Modifier keys - Delete
0533                       ;-------------------------------------------------------
0534 7E8C 0300             data  key.fctn.1, txt.fctn.1, edkey.action.del_char
     7E8E 7B40 
     7E90 63E8 
0535 7E92 0700             data  key.fctn.3, txt.fctn.3, edkey.action.del_line
     7E94 7B54 
     7E96 6454 
0536 7E98 0200             data  key.fctn.4, txt.fctn.4, edkey.action.del_eol
     7E9A 7B5E 
     7E9C 6420 
0537               
0538                       ;-------------------------------------------------------
0539                       ; Modifier keys - Insert
0540                       ;-------------------------------------------------------
0541 7E9E 0400             data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
     7EA0 7B4A 
     7EA2 64AC 
0542 7EA4 B900             data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
     7EA6 7C9E 
     7EA8 65B4 
0543 7EAA 0E00             data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
     7EAC 7B68 
     7EAE 6502 
0544                       ;-------------------------------------------------------
0545                       ; Other action keys
0546                       ;-------------------------------------------------------
0547 7EB0 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7EB2 7CA8 
     7EB4 6614 
0548 7EB6 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7EB8 7E24 
     7EBA 76E6 
0549                       ;-------------------------------------------------------
0550                       ; Editor/File buffer keys
0551                       ;-------------------------------------------------------
0552 7EBC B000             data  key.ctrl.0, txt.ctrl.0, edkey.action.fb.buffer0
     7EBE 7CC6 
     7EC0 662A 
0553 7EC2 B100             data  key.ctrl.1, txt.ctrl.1, edkey.action.fb.buffer1
     7EC4 7CD0 
     7EC6 6630 
0554 7EC8 B200             data  key.ctrl.2, txt.ctrl.2, edkey.action.fb.buffer2
     7ECA 7CDA 
     7ECC 6636 
0555 7ECE B300             data  key.ctrl.3, txt.ctrl.3, edkey.action.fb.buffer3
     7ED0 7CE4 
     7ED2 663C 
0556 7ED4 B400             data  key.ctrl.4, txt.ctrl.4, edkey.action.fb.buffer4
     7ED6 7CEE 
     7ED8 6642 
0557                ;      data  key.ctrl.5, txt.ctrl.5, edkey.action.fb.buffer5
0558 7EDA B600             data  key.ctrl.6, txt.ctrl.6, edkey.action.fb.buffer6
     7EDC 7D02 
     7EDE 664E 
0559 7EE0 B700             data  key.ctrl.7, txt.ctrl.7, edkey.action.fb.buffer7
     7EE2 7D0C 
     7EE4 6654 
0560 7EE6 9E00             data  key.ctrl.8, txt.ctrl.8, edkey.action.fb.buffer8
     7EE8 7D16 
     7EEA 665A 
0561 7EEC 9F00             data  key.ctrl.9, txt.ctrl.9, edkey.action.fb.buffer9
     7EEE 7D20 
     7EF0 6660 
0562                       ;-------------------------------------------------------
0563                       ; Dialog keys
0564                       ;-------------------------------------------------------
0565 7EF2 8000             data  key.ctrl.comma, txt.ctrl.comma, edkey.action.fb.fname.dec.load
     7EF4 7CBC 
     7EF6 6688 
0566 7EF8 9B00             data  key.ctrl.dot, txt.ctrl.dot, edkey.action.fb.fname.inc.load
     7EFA 7CB2 
     7EFC 666E 
0567 7EFE 8B00             data  key.ctrl.k, txt.ctrl.k, dialog.save
     7F00 7D8E 
     7F02 7AEE 
0568 7F04 8C00             data  key.ctrl.l, txt.ctrl.l, dialog.load
     7F06 7D98 
     7F08 7ACA 
0569                       ;-------------------------------------------------------
0570                       ; End of list
0571                       ;-------------------------------------------------------
0572 7F0A FFFF             data  EOL                           ; EOL
0573               
0574               
0575               
0576               
0577               *---------------------------------------------------------------
0578               * Action keys mapping table: Command Buffer (CMDB)
0579               *---------------------------------------------------------------
0580               keymap_actions.cmdb:
0581                       ;-------------------------------------------------------
0582                       ; Movement keys
0583                       ;-------------------------------------------------------
0584 7F0C 0800             data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
     7F0E 7C4E 
     7F10 6694 
0585 7F12 0900             data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
     7F14 7BB8 
     7F16 66A6 
0586 7F18 8100             data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
     7F1A 7D2A 
     7F1C 66BE 
0587 7F1E 8600             data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
     7F20 7D5C 
     7F22 66D2 
0588                       ;-------------------------------------------------------
0589                       ; Modifier keys
0590                       ;-------------------------------------------------------
0591 7F24 0700             data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
     7F26 7B54 
     7F28 66EA 
0592 7F2A 0D00             data  key.enter, txt.enter, edkey.action.cmdb.loadsave
     7F2C 7E38 
     7F2E 674A 
0593                       ;-------------------------------------------------------
0594                       ; Other action keys
0595                       ;-------------------------------------------------------
0596 7F30 0500             data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
     7F32 7CA8 
     7F34 6614 
0597 7F36 9A00             data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
     7F38 7E24 
     7F3A 76E6 
0598                       ;-------------------------------------------------------
0599                       ; File load dialog
0600                       ;-------------------------------------------------------
0601 7F3C 8000             data  key.ctrl.comma, txt.ctrl.comma, fm.browse.fname.suffix.dec
     7F3E 7CBC 
     7F40 74F8 
0602 7F42 9B00             data  key.ctrl.dot, txt.ctrl.dot, fm.browse.fname.suffix.inc
     7F44 7CB2 
     7F46 74D0 
0603                       ;-------------------------------------------------------
0604                       ; Dialog keys
0605                       ;-------------------------------------------------------
0606 7F48 0F00             data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
     7F4A 7B90 
     7F4C 6742 
0607                       ;-------------------------------------------------------
0608                       ; End of list
0609                       ;-------------------------------------------------------
0610 7F4E FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.37551
0163 7F50 7F50                   data $                ; Bank 1 ROM size OK.
0165               
0166               
0167               
0168               
0169               *--------------------------------------------------------------
0170               * Video mode configuration
0171               *--------------------------------------------------------------
0172      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0173      0004     spfbck  equ   >04                   ; Screen background color.
0174      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0175      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0176      0050     colrow  equ   80                    ; Columns per row
0177      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0178      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0179      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0180      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

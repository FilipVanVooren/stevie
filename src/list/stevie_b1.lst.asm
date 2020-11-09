XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.2405726
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 201109-2405726
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
0009               * File: equates.equ                 ; Version 201109-2405726
0010               *--------------------------------------------------------------
0011               * Stevie memory map
0012               *
0013               *
0014               * LOW MEMORY EXPANSION (2000-2fff)
0015               *
0016               * Mem range   Bytes    SAMS   Purpose
0017               * =========   =====    ====   ==================================
0018               * 2000-2eff    3840           SP2 library
0019               * 2f00-2fff     256           SP2 work memory
0020               *
0021               * LOW MEMORY EXPANSION (3000-3fff)
0022               *
0023               * Mem range   Bytes    SAMS   Purpose
0024               * =========   =====    ====   ==================================
0025               * 3000-3fff    4096           Resident Stevie Modules
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
0053               * f000-ffff    4096           *FREE*
0054               *
0055               *
0056               * VDP RAM
0057               *
0058               * Mem range   Bytes    Hex    Purpose
0059               * =========   =====   =====   =================================
0060               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0061               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0062               * 0fc0                        PCT - Pattern Color Table
0063               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0064               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0065               * 2180                        SAT - Sprite Attribute List
0066               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0067               *--------------------------------------------------------------
0068               * Skip unused spectra2 code modules for reduced code size
0069               *--------------------------------------------------------------
0070      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0071      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0072      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0073      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0074      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0075      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0076      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0077      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0078      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0079      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0080      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0081      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0082      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0083      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0084      0001     skip_random_generator     equ  1       ; Skip random functions
0085      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0086      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0087               *--------------------------------------------------------------
0088               * Stevie specific equates
0089               *--------------------------------------------------------------
0090      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0091      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0092      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0093               *--------------------------------------------------------------
0094               * Stevie Dialog / Pane specific equates
0095               *--------------------------------------------------------------
0096      001D     pane.botrow               equ  29      ; Bottom row on screen
0097      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0098      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0099      000A     id.dialog.load            equ  10      ; ID dialog "Load DV 80 file"
0100      000B     id.dialog.save            equ  11      ; ID dialog "Save DV 80 file"
0101               ;-----------------------------------------------------------------
0102               ;   Dialog ID's > 100 indicate that command prompt should be
0103               ;   hidden and no characters added to buffer
0104               ;-----------------------------------------------------------------
0105      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0106      0066     id.dialog.about           equ  102     ; ID dialog "About"
0107               *--------------------------------------------------------------
0108               * SPECTRA2 / Stevie startup options
0109               *--------------------------------------------------------------
0110      0001     debug                     equ  1       ; Turn on spectra2 debugging
0111      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0112      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0113      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0114               *--------------------------------------------------------------
0115               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0116               *--------------------------------------------------------------
0117      2F20     parm1             equ  >2f20           ; Function parameter 1
0118      2F22     parm2             equ  >2f22           ; Function parameter 2
0119      2F24     parm3             equ  >2f24           ; Function parameter 3
0120      2F26     parm4             equ  >2f26           ; Function parameter 4
0121      2F28     parm5             equ  >2f28           ; Function parameter 5
0122      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0123      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0124      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0125      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0126      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0127      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0128      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0129      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0130      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0131      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0132      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0133      2F40     keycode1          equ  >2f40           ; Current key scanned
0134      2F42     keycode2          equ  >2f42           ; Previous key scanned
0135      2F44     timers            equ  >2f44           ; Timer table
0136      2F54     ramsat            equ  >2f54           ; Sprite Attribute Table in RAM
0137      2F64     rambuf            equ  >2f64           ; RAM workbuffer 1
0138               *--------------------------------------------------------------
0139               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0140               *--------------------------------------------------------------
0141      A000     tv.top            equ  >a000           ; Structure begin
0142      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0143      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0144      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0145      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0146      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0147      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0148      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0149      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0150      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0151      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0152      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0153      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0154      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebufffer + bottom line
0155      A01A     tv.busycolor      equ  tv.top + 26     ; FG/BG-color bottom line when busy
0156      A01C     tv.pane.focus     equ  tv.top + 28     ; Identify pane that has focus
0157      A01E     tv.task.oneshot   equ  tv.top + 30     ; Pointer to one-shot routine
0158      A020     tv.error.visible  equ  tv.top + 32     ; Error pane visible
0159      A022     tv.error.msg      equ  tv.top + 34     ; Error message (max. 160 characters)
0160      A0C2     tv.free           equ  tv.top + 194    ; End of structure
0161               *--------------------------------------------------------------
0162               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0163               *--------------------------------------------------------------
0164      A100     fb.struct         equ  >a100           ; Structure begin
0165      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0166      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0167      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0168                                                      ; line X in editor buffer).
0169      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0170                                                      ; (offset 0 .. @fb.scrrows)
0171      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0172      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0173      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0174      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0175      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0176      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0177      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0178      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0179      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0180      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0181      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0182               *--------------------------------------------------------------
0183               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0184               *--------------------------------------------------------------
0185      A200     edb.struct        equ  >a200           ; Begin structure
0186      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0187      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0188      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0189      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0190      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0191      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0192      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0193      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0194                                                      ; with current filename.
0195      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0196                                                      ; with current file type.
0197      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0198      A214     edb.sams.hipage   equ  edb.struct + 20 ; Highest SAMS page in use
0199      A216     edb.free          equ  edb.struct + 22 ; End of structure
0200               *--------------------------------------------------------------
0201               * Command buffer structure            @>a300-a3ff   (256 bytes)
0202               *--------------------------------------------------------------
0203      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0204      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0205      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0206      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0207      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0208      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0209      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0210      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0211      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0212      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0213      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0214      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0215      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0216      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0217      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0218      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0219      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0220      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0221      A322     cmdb.action.ptr   equ  cmdb.struct + 34; Pointer to function to execute
0222      A324     cmdb.cmdlen       equ  cmdb.struct + 36; Length of current command (MSB byte!)
0223      A325     cmdb.cmd          equ  cmdb.struct + 37; Current command (80 bytes max.)
0224      A375     cmdb.free         equ  cmdb.struct +117; End of structure
0225               *--------------------------------------------------------------
0226               * File handle structure               @>a400-a4ff   (256 bytes)
0227               *--------------------------------------------------------------
0228      A400     fh.struct         equ  >a400           ; stevie file handling structures
0229               ;***********************************************************************
0230               ; ATTENTION
0231               ; The dsrlnk variables must form a continuous memory block and keep
0232               ; their order!
0233               ;***********************************************************************
0234      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0235      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0236      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0237      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0238      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0239      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0240      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0241      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0242      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0243      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0244      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0245      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0246      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0247      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0248      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0249      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0250      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0251      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0252      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0253      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0254      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0255      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0256      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0257      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0258      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0259      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0260      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0261      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0262      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0263      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0264      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0265               *--------------------------------------------------------------
0266               * Index structure                     @>a500-a5ff   (256 bytes)
0267               *--------------------------------------------------------------
0268      A500     idx.struct        equ  >a500           ; stevie index structure
0269      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0270      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0271      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0272               *--------------------------------------------------------------
0273               * Frame buffer                        @>a600-afff  (2560 bytes)
0274               *--------------------------------------------------------------
0275      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0276      0960     fb.size           equ  80*30           ; Frame buffer size
0277               *--------------------------------------------------------------
0278               * Index                               @>b000-bfff  (4096 bytes)
0279               *--------------------------------------------------------------
0280      B000     idx.top           equ  >b000           ; Top of index
0281      1000     idx.size          equ  4096            ; Index size
0282               *--------------------------------------------------------------
0283               * Editor buffer                       @>c000-cfff  (4096 bytes)
0284               *--------------------------------------------------------------
0285      C000     edb.top           equ  >c000           ; Editor buffer high memory
0286      1000     edb.size          equ  4096            ; Editor buffer size
0287               *--------------------------------------------------------------
0288               * Command history buffer              @>d000-dfff  (4096 bytes)
0289               *--------------------------------------------------------------
0290      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0291      1000     cmdb.size         equ  4096            ; Command buffer size
0292               *--------------------------------------------------------------
0293               * Heap                                @>e000-efff  (4096 bytes)
0294               *--------------------------------------------------------------
0295      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b1.asm.2405726
0012               
0013               ***************************************************************
0014               * Spectra2 core configuration
0015               ********|*****|*********************|**************************
0016      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff
0017                                                   ; and grows downwards
0018               
0019               ***************************************************************
0020               * BANK 1 - Stevie main editor modules
0021               ********|*****|*********************|**************************
0022                       aorg  >6000
0023                       save  >6000,>7fff           ; Save bank 1
0024               *--------------------------------------------------------------
0025               * Cartridge header
0026               ********|*****|*********************|**************************
0027 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0028 6006 6010             data  $+10
0029 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0030 6010 0000             data  0                     ; No more items following
0031 6012 6030             data  kickstart.code1
0032               
0034               
0035 6014 0C53             byte  12
0036 6015 ....             text  'STEVIE V0.1E'
0037                       even
0038               
0046               
0047               ***************************************************************
0048               * Step 1: Switch to bank 0 (uniform code accross all banks)
0049               ********|*****|*********************|**************************
0050                       aorg  kickstart.code1       ; >6030
0051 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
0052               ***************************************************************
0053               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0054               ********|*****|*********************|**************************
0055                       aorg  >2000
0056                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0030               * skip_textmode             equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a             equ  1  ; Skip f18a support
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
0077                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
**** **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
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
0078                       copy  "registers.equ"            ; Equates runlib registers
**** **** ****     > registers.equ
0001               * FILE......: registers.equ
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
0079                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
**** **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
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
0080                       copy  "param.equ"                ; Equates runlib parameters
**** **** ****     > param.equ
0001               * FILE......: param.equ
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
0087                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
0001               * FILE......: config.equ
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
     208E 2E18 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2092 2306 
0078 2094 21F6                   data graph1           ; Equate selected video mode table
0079               
0080 2096 06A0  32         bl    @ldfnt
     2098 236E 
0081 209A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     209C 000C 
0082               
0083 209E 06A0  32         bl    @filv
     20A0 229C 
0084 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0 
     20A6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 2450 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 299C 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 2450 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 299C 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 2450 
0113 20D4 0300                   byte 3,0
0114 20D6 21B4                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 2450 
0116 20DC 0400                   byte 4,0
0117 20DE 21BA                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 2450 
0119 20E4 1600                   byte 22,0
0120 20E6 21C0                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 2450 
0122 20EC 1700                   byte 23,0
0123 20EE 21DC                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 26A0 
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
     2116 29A6 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26B6 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 242C 
0164 2128 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 26B6 
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
     213C 242C 
0176 213E 21AE                   data cpu.crash.msg.r
0177               
0178 2140 06A0  32         bl    @mknum
     2142 29A6 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 2918 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 26B6 
0194 2158 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr               ; Put '  >'
     215C 242C 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 26B6 
0201 2164 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2166 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2168 242C 
0205 216A 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 216C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 216E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2172 06A0  32         bl    @down                 ; y=y+1
     2174 26A6 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2D16 
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
0239 21B0 0320             byte  3
0240 21B1 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21B4 042A             byte  4
0245 21B5 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21BA 042A             byte  4
0250 21BB ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21C0 1B53             byte  27
0255 21C1 ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21DC 1842             byte  24
0260 21DD ....             text  'Build-ID  201109-2405726'
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
0007 21F6 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21F8 000E 
     21FA 0106 
     21FC 0204 
     21FE 0020 
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
0032 2200 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2202 000E 
     2204 0106 
     2206 00F4 
     2208 0028 
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
0058 220A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220C 003F 
     220E 0240 
     2210 03F4 
     2212 0050 
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
0084 2214 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2216 003F 
     2218 0240 
     221A 03F4 
     221C 0050 
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
0013 221E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2220 16FD             data  >16fd                 ; |         jne   mcloop
0015 2222 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2224 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2226 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               ***************************************************************
0027               * loadmc - Load machine code into scratchpad  >8322 - >8328
0028               ***************************************************************
0029               *  bl  @loadmc
0030               *--------------------------------------------------------------
0031               *  REMARKS
0032               *  Machine instruction in location @>8320 will be set by
0033               *  SP2 copy/fill routine that is called later on.
0034               ********|*****|*********************|**************************
0035               loadmc:
0036 2228 0201  20         li    r1,mccode             ; Machinecode to patch
     222A 221E 
0037 222C 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222E 8322 
0038 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2234 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2236 045B  20         b     *r11                  ; Return to caller
0042               
0043               
0044               *//////////////////////////////////////////////////////////////
0045               *                    STACK SUPPORT FUNCTIONS
0046               *//////////////////////////////////////////////////////////////
0047               
0048               ***************************************************************
0049               * POPR. - Pop registers & return to caller
0050               ***************************************************************
0051               *  B  @POPRG.
0052               *--------------------------------------------------------------
0053               *  REMARKS
0054               *  R11 must be at stack bottom
0055               ********|*****|*********************|**************************
0056 2238 C0F9  30 popr3   mov   *stack+,r3
0057 223A C0B9  30 popr2   mov   *stack+,r2
0058 223C C079  30 popr1   mov   *stack+,r1
0059 223E C039  30 popr0   mov   *stack+,r0
0060 2240 C2F9  30 poprt   mov   *stack+,r11
0061 2242 045B  20         b     *r11
0062               
0063               
0064               
0065               *//////////////////////////////////////////////////////////////
0066               *                   MEMORY FILL FUNCTIONS
0067               *//////////////////////////////////////////////////////////////
0068               
0069               ***************************************************************
0070               * FILM - Fill CPU memory with byte
0071               ***************************************************************
0072               *  bl   @film
0073               *  data P0,P1,P2
0074               *--------------------------------------------------------------
0075               *  P0 = Memory start address
0076               *  P1 = Byte to fill
0077               *  P2 = Number of bytes to fill
0078               *--------------------------------------------------------------
0079               *  bl   @xfilm
0080               *
0081               *  TMP0 = Memory start address
0082               *  TMP1 = Byte to fill
0083               *  TMP2 = Number of bytes to fill
0084               ********|*****|*********************|**************************
0085 2244 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2246 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2248 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 224A C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224C 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2250 FFCE 
0095 2252 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2254 2030 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2256 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2258 830B 
     225A 830A 
0100               
0101 225C 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225E 0001 
0102 2260 1602  14         jne   filchk2
0103 2262 DD05  32         movb  tmp1,*tmp0+
0104 2264 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2266 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2268 0002 
0109 226A 1603  14         jne   filchk3
0110 226C DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226E DD05  32         movb  tmp1,*tmp0+
0112 2270 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2272 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2274 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2276 0001 
0118 2278 1605  14         jne   fil16b
0119 227A DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227C 0606  14         dec   tmp2
0121 227E 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2280 0002 
0122 2282 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2284 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2286 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2288 0001 
0128 228A 1301  14         jeq   dofill
0129 228C 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228E CD05  34 dofill  mov   tmp1,*tmp0+
0131 2290 0646  14         dect  tmp2
0132 2292 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2294 C1C7  18         mov   tmp3,tmp3
0137 2296 1301  14         jeq   fil.exit
0138 2298 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 229A 045B  20         b     *r11
0141               
0142               
0143               ***************************************************************
0144               * FILV - Fill VRAM with byte
0145               ***************************************************************
0146               *  BL   @FILV
0147               *  DATA P0,P1,P2
0148               *--------------------------------------------------------------
0149               *  P0 = VDP start address
0150               *  P1 = Byte to fill
0151               *  P2 = Number of bytes to fill
0152               *--------------------------------------------------------------
0153               *  BL   @XFILV
0154               *
0155               *  TMP0 = VDP start address
0156               *  TMP1 = Byte to fill
0157               *  TMP2 = Number of bytes to fill
0158               ********|*****|*********************|**************************
0159 229C C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 22A0 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A2 0264  22 xfilv   ori   tmp0,>4000
     22A4 4000 
0166 22A6 06C4  14         swpb  tmp0
0167 22A8 D804  38         movb  tmp0,@vdpa
     22AA 8C02 
0168 22AC 06C4  14         swpb  tmp0
0169 22AE D804  38         movb  tmp0,@vdpa
     22B0 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B2 020F  20         li    r15,vdpw              ; Set VDP write address
     22B4 8C00 
0174 22B6 06C5  14         swpb  tmp1
0175 22B8 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22BA 22C2 
     22BC 8320 
0176 22BE 0460  28         b     @mcloop               ; Write data to VDP
     22C0 8320 
0177               *--------------------------------------------------------------
0181 22C2 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0183               
0184               
0185               
0186               *//////////////////////////////////////////////////////////////
0187               *                  VDP LOW LEVEL FUNCTIONS
0188               *//////////////////////////////////////////////////////////////
0189               
0190               ***************************************************************
0191               * VDWA / VDRA - Setup VDP write or read address
0192               ***************************************************************
0193               *  BL   @VDWA
0194               *
0195               *  TMP0 = VDP destination address for write
0196               *--------------------------------------------------------------
0197               *  BL   @VDRA
0198               *
0199               *  TMP0 = VDP source address for read
0200               ********|*****|*********************|**************************
0201 22C4 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C6 4000 
0202 22C8 06C4  14 vdra    swpb  tmp0
0203 22CA D804  38         movb  tmp0,@vdpa
     22CC 8C02 
0204 22CE 06C4  14         swpb  tmp0
0205 22D0 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D2 8C02 
0206 22D4 045B  20         b     *r11                  ; Exit
0207               
0208               ***************************************************************
0209               * VPUTB - VDP put single byte
0210               ***************************************************************
0211               *  BL @VPUTB
0212               *  DATA P0,P1
0213               *--------------------------------------------------------------
0214               *  P0 = VDP target address
0215               *  P1 = Byte to write
0216               ********|*****|*********************|**************************
0217 22D6 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D8 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22DA 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DC 4000 
0223 22DE 06C4  14         swpb  tmp0                  ; \
0224 22E0 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E2 8C02 
0225 22E4 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E6 D804  38         movb  tmp0,@vdpa            ; /
     22E8 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22EA 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EC D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EE 045B  20         b     *r11                  ; Exit
0233               
0234               
0235               ***************************************************************
0236               * VGETB - VDP get single byte
0237               ***************************************************************
0238               *  bl   @vgetb
0239               *  data p0
0240               *--------------------------------------------------------------
0241               *  P0 = VDP source address
0242               *--------------------------------------------------------------
0243               *  bl   @xvgetb
0244               *
0245               *  tmp0 = VDP source address
0246               *--------------------------------------------------------------
0247               *  Output:
0248               *  tmp0 MSB = >00
0249               *  tmp0 LSB = VDP byte read
0250               ********|*****|*********************|**************************
0251 22F0 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F2 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F4 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F6 8C02 
0257 22F8 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22FA D804  38         movb  tmp0,@vdpa            ; /
     22FC 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FE D120  34         movb  @vdpr,tmp0            ; Read byte
     2300 8800 
0263 2302 0984  56         srl   tmp0,8                ; Right align
0264 2304 045B  20         b     *r11                  ; Exit
0265               
0266               
0267               ***************************************************************
0268               * VIDTAB - Dump videomode table
0269               ***************************************************************
0270               *  BL   @VIDTAB
0271               *  DATA P0
0272               *--------------------------------------------------------------
0273               *  P0 = Address of video mode table
0274               *--------------------------------------------------------------
0275               *  BL   @XIDTAB
0276               *
0277               *  TMP0 = Address of video mode table
0278               *--------------------------------------------------------------
0279               *  Remarks
0280               *  TMP1 = MSB is the VDP target register
0281               *         LSB is the value to write
0282               ********|*****|*********************|**************************
0283 2306 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2308 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 230A C144  18         mov   tmp0,tmp1
0289 230C 05C5  14         inct  tmp1
0290 230E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2310 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2312 FF00 
0292 2314 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2316 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2318 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 231A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231C 8000 
0298 231E 0206  20         li    tmp2,8
     2320 0008 
0299 2322 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2324 830B 
0300 2326 06C5  14         swpb  tmp1
0301 2328 D805  38         movb  tmp1,@vdpa
     232A 8C02 
0302 232C 06C5  14         swpb  tmp1
0303 232E D805  38         movb  tmp1,@vdpa
     2330 8C02 
0304 2332 0225  22         ai    tmp1,>0100
     2334 0100 
0305 2336 0606  14         dec   tmp2
0306 2338 16F4  14         jne   vidta1                ; Next register
0307 233A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233C 833A 
0308 233E 045B  20         b     *r11
0309               
0310               
0311               ***************************************************************
0312               * PUTVR  - Put single VDP register
0313               ***************************************************************
0314               *  BL   @PUTVR
0315               *  DATA P0
0316               *--------------------------------------------------------------
0317               *  P0 = MSB is the VDP target register
0318               *       LSB is the value to write
0319               *--------------------------------------------------------------
0320               *  BL   @PUTVRX
0321               *
0322               *  TMP0 = MSB is the VDP target register
0323               *         LSB is the value to write
0324               ********|*****|*********************|**************************
0325 2340 C13B  30 putvr   mov   *r11+,tmp0
0326 2342 0264  22 putvrx  ori   tmp0,>8000
     2344 8000 
0327 2346 06C4  14         swpb  tmp0
0328 2348 D804  38         movb  tmp0,@vdpa
     234A 8C02 
0329 234C 06C4  14         swpb  tmp0
0330 234E D804  38         movb  tmp0,@vdpa
     2350 8C02 
0331 2352 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2354 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2356 C10E  18         mov   r14,tmp0
0341 2358 0984  56         srl   tmp0,8
0342 235A 06A0  32         bl    @putvrx               ; Write VR#0
     235C 2342 
0343 235E 0204  20         li    tmp0,>0100
     2360 0100 
0344 2362 D820  54         movb  @r14lb,@tmp0lb
     2364 831D 
     2366 8309 
0345 2368 06A0  32         bl    @putvrx               ; Write VR#1
     236A 2342 
0346 236C 0458  20         b     *tmp4                 ; Exit
0347               
0348               
0349               ***************************************************************
0350               * LDFNT - Load TI-99/4A font from GROM into VDP
0351               ***************************************************************
0352               *  BL   @LDFNT
0353               *  DATA P0,P1
0354               *--------------------------------------------------------------
0355               *  P0 = VDP Target address
0356               *  P1 = Font options
0357               *--------------------------------------------------------------
0358               * Uses registers tmp0-tmp4
0359               ********|*****|*********************|**************************
0360 236E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2370 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2372 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2374 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2376 7FFF 
0364 2378 2120  38         coc   @wbit0,tmp0
     237A 202A 
0365 237C 1604  14         jne   ldfnt1
0366 237E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2380 8000 
0367 2382 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2384 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2386 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2388 23F0 
0372 238A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238C 9C02 
0373 238E 06C4  14         swpb  tmp0
0374 2390 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2392 9C02 
0375 2394 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2396 9800 
0376 2398 06C5  14         swpb  tmp1
0377 239A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239C 9800 
0378 239E 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 23A0 D805  38         movb  tmp1,@grmwa
     23A2 9C02 
0383 23A4 06C5  14         swpb  tmp1
0384 23A6 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A8 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23AA C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AC 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AE 22C4 
0390 23B0 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B2 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B4 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B6 7FFF 
0393 23B8 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23BA 23F2 
0394 23BC C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BE 23F4 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23C0 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C2 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C4 D120  34         movb  @grmrd,tmp0
     23C6 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C8 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23CA 202A 
0405 23CC 1603  14         jne   ldfnt3                ; No, so skip
0406 23CE D1C4  18         movb  tmp0,tmp3
0407 23D0 0917  56         srl   tmp3,1
0408 23D2 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D4 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D6 8C00 
0413 23D8 0606  14         dec   tmp2
0414 23DA 16F2  14         jne   ldfnt2
0415 23DC 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DE 020F  20         li    r15,vdpw              ; Set VDP write address
     23E0 8C00 
0417 23E2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E4 7FFF 
0418 23E6 0458  20         b     *tmp4                 ; Exit
0419 23E8 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23EA 200A 
     23EC 8C00 
0420 23EE 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23F0 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F2 0200 
     23F4 0000 
0425 23F6 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F8 01C0 
     23FA 0101 
0426 23FC 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FE 02A0 
     2400 0101 
0427 2402 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2404 00E0 
     2406 0101 
0428               
0429               
0430               
0431               ***************************************************************
0432               * YX2PNT - Get VDP PNT address for current YX cursor position
0433               ***************************************************************
0434               *  BL   @YX2PNT
0435               *--------------------------------------------------------------
0436               *  INPUT
0437               *  @WYX = Cursor YX position
0438               *--------------------------------------------------------------
0439               *  OUTPUT
0440               *  TMP0 = VDP address for entry in Pattern Name Table
0441               *--------------------------------------------------------------
0442               *  Register usage
0443               *  TMP0, R14, R15
0444               ********|*****|*********************|**************************
0445 2408 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 240A C3A0  34         mov   @wyx,r14              ; Get YX
     240C 832A 
0447 240E 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2410 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2412 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2414 C3A0  34         mov   @wyx,r14              ; Get YX
     2416 832A 
0454 2418 024E  22         andi  r14,>00ff             ; Remove Y
     241A 00FF 
0455 241C A3CE  18         a     r14,r15               ; pos = pos + X
0456 241E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2420 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2422 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2424 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2426 020F  20         li    r15,vdpw              ; VDP write address
     2428 8C00 
0463 242A 045B  20         b     *r11
0464               
0465               
0466               
0467               ***************************************************************
0468               * Put length-byte prefixed string at current YX
0469               ***************************************************************
0470               *  BL   @PUTSTR
0471               *  DATA P0
0472               *
0473               *  P0 = Pointer to string
0474               *--------------------------------------------------------------
0475               *  REMARKS
0476               *  First byte of string must contain length
0477               ********|*****|*********************|**************************
0478 242C C17B  30 putstr  mov   *r11+,tmp1
0479 242E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 2430 C1CB  18 xutstr  mov   r11,tmp3
0481 2432 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2434 2408 
0482 2436 C2C7  18         mov   tmp3,r11
0483 2438 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 243A C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 243C 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 243E 0286  22         ci    tmp2,255              ; Length > 255 ?
     2440 00FF 
0491 2442 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2444 0460  28         b     @xpym2v               ; Display string
     2446 245E 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 2448 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     244A FFCE 
0498 244C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244E 2030 
0499               
0500               
0501               
0502               ***************************************************************
0503               * Put length-byte prefixed string at YX
0504               ***************************************************************
0505               *  BL   @PUTAT
0506               *  DATA P0,P1
0507               *
0508               *  P0 = YX position
0509               *  P1 = Pointer to string
0510               *--------------------------------------------------------------
0511               *  REMARKS
0512               *  First byte of string must contain length
0513               ********|*****|*********************|**************************
0514 2450 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2452 832A 
0515 2454 0460  28         b     @putstr
     2456 242C 
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
0020 2458 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 245A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 245C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 245E C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2460 1604  14         jne   !                     ; No, continue
0028               
0029 2462 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2464 FFCE 
0030 2466 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2468 2030 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 246A 0264  22 !       ori   tmp0,>4000
     246C 4000 
0035 246E 06C4  14         swpb  tmp0
0036 2470 D804  38         movb  tmp0,@vdpa
     2472 8C02 
0037 2474 06C4  14         swpb  tmp0
0038 2476 D804  38         movb  tmp0,@vdpa
     2478 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 247A 020F  20         li    r15,vdpw              ; Set VDP write address
     247C 8C00 
0043 247E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2480 2488 
     2482 8320 
0044 2484 0460  28         b     @mcloop               ; Write data to VDP and return
     2486 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 2488 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 248A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 248C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 248E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2490 06C4  14 xpyv2m  swpb  tmp0
0027 2492 D804  38         movb  tmp0,@vdpa
     2494 8C02 
0028 2496 06C4  14         swpb  tmp0
0029 2498 D804  38         movb  tmp0,@vdpa
     249A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 249C 020F  20         li    r15,vdpr              ; Set VDP read address
     249E 8800 
0034 24A0 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24A2 24AA 
     24A4 8320 
0035 24A6 0460  28         b     @mcloop               ; Read data from VDP
     24A8 8320 
0036 24AA DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24AC C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24AE C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24B0 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24B2 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24B4 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24B6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24B8 FFCE 
0034 24BA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24BC 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24BE 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24C0 0001 
0039 24C2 1603  14         jne   cpym0                 ; No, continue checking
0040 24C4 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24C6 04C6  14         clr   tmp2                  ; Reset counter
0042 24C8 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24CA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24CC 7FFF 
0047 24CE C1C4  18         mov   tmp0,tmp3
0048 24D0 0247  22         andi  tmp3,1
     24D2 0001 
0049 24D4 1618  14         jne   cpyodd                ; Odd source address handling
0050 24D6 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24D8 0247  22         andi  tmp3,1
     24DA 0001 
0052 24DC 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24DE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24E0 202A 
0057 24E2 1605  14         jne   cpym3
0058 24E4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24E6 250C 
     24E8 8320 
0059 24EA 0460  28         b     @mcloop               ; Copy memory and exit
     24EC 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24EE C1C6  18 cpym3   mov   tmp2,tmp3
0064 24F0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24F2 0001 
0065 24F4 1301  14         jeq   cpym4
0066 24F6 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24F8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24FA 0646  14         dect  tmp2
0069 24FC 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24FE C1C7  18         mov   tmp3,tmp3
0074 2500 1301  14         jeq   cpymz
0075 2502 D554  38         movb  *tmp0,*tmp1
0076 2504 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2506 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2508 8000 
0081 250A 10E9  14         jmp   cpym2
0082 250C DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 250E C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2510 0649  14         dect  stack
0065 2512 C64B  30         mov   r11,*stack            ; Push return address
0066 2514 0649  14         dect  stack
0067 2516 C640  30         mov   r0,*stack             ; Push r0
0068 2518 0649  14         dect  stack
0069 251A C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 251C 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 251E 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2520 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2522 4000 
0077 2524 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2526 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2528 020C  20         li    r12,>1e00             ; SAMS CRU address
     252A 1E00 
0082 252C 04C0  14         clr   r0
0083 252E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2530 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2532 D100  18         movb  r0,tmp0
0086 2534 0984  56         srl   tmp0,8                ; Right align
0087 2536 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2538 833C 
0088 253A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 253C C339  30         mov   *stack+,r12           ; Pop r12
0094 253E C039  30         mov   *stack+,r0            ; Pop r0
0095 2540 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2542 045B  20         b     *r11                  ; Return to caller
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
0131 2544 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2546 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2548 0649  14         dect  stack
0135 254A C64B  30         mov   r11,*stack            ; Push return address
0136 254C 0649  14         dect  stack
0137 254E C640  30         mov   r0,*stack             ; Push r0
0138 2550 0649  14         dect  stack
0139 2552 C64C  30         mov   r12,*stack            ; Push r12
0140 2554 0649  14         dect  stack
0141 2556 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2558 0649  14         dect  stack
0143 255A C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 255C 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 255E 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2560 0284  22         ci    tmp0,255              ; Crash if page > 255
     2562 00FF 
0153 2564 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2566 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2568 001E 
0158 256A 150A  14         jgt   !
0159 256C 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     256E 0004 
0160 2570 1107  14         jlt   !
0161 2572 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2574 0012 
0162 2576 1508  14         jgt   sams.page.set.switch_page
0163 2578 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     257A 0006 
0164 257C 1501  14         jgt   !
0165 257E 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2580 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2582 FFCE 
0170 2584 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2586 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2588 020C  20         li    r12,>1e00             ; SAMS CRU address
     258A 1E00 
0176 258C C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 258E 06C0  14         swpb  r0                    ; LSB to MSB
0178 2590 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2592 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2594 4000 
0180 2596 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2598 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 259A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 259C C339  30         mov   *stack+,r12           ; Pop r12
0188 259E C039  30         mov   *stack+,r0            ; Pop r0
0189 25A0 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25A2 045B  20         b     *r11                  ; Return to caller
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
0204 25A4 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A6 1E00 
0205 25A8 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25AA 045B  20         b     *r11                  ; Return to caller
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
0227 25AC 020C  20         li    r12,>1e00             ; SAMS CRU address
     25AE 1E00 
0228 25B0 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25B2 045B  20         b     *r11                  ; Return to caller
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
0260 25B4 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25B6 0649  14         dect  stack
0263 25B8 C64B  30         mov   r11,*stack            ; Save return address
0264 25BA 0649  14         dect  stack
0265 25BC C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25BE 0649  14         dect  stack
0267 25C0 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25C2 0649  14         dect  stack
0269 25C4 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25C6 0649  14         dect  stack
0271 25C8 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25CA 0206  20         li    tmp2,8                ; Set loop counter
     25CC 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25CE C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25D0 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25D2 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25D4 2548 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25D6 0606  14         dec   tmp2                  ; Next iteration
0288 25D8 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25DA 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25DC 25A4 
0294                                                   ; / activating changes.
0295               
0296 25DE C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25E6 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25E8 045B  20         b     *r11                  ; Return to caller
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
0318 25EA 0649  14         dect  stack
0319 25EC C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25EE 06A0  32         bl    @sams.layout
     25F0 25B4 
0324 25F2 25F8                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25F6 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25F8 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25FA 0002 
0336 25FC 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25FE 0003 
0337 2600 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2602 000A 
0338 2604 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2606 000B 
0339 2608 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     260A 000C 
0340 260C D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     260E 000D 
0341 2610 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2612 000E 
0342 2614 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2616 000F 
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
0363 2618 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 261A 0649  14         dect  stack
0366 261C C64B  30         mov   r11,*stack            ; Push return address
0367 261E 0649  14         dect  stack
0368 2620 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2622 0649  14         dect  stack
0370 2624 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2626 0649  14         dect  stack
0372 2628 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 262A 0649  14         dect  stack
0374 262C C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 262E 0205  20         li    tmp1,sams.layout.copy.data
     2630 2650 
0379 2632 0206  20         li    tmp2,8                ; Set loop counter
     2634 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2636 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2638 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     263A 2510 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 263C CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     263E 833C 
0390               
0391 2640 0606  14         dec   tmp2                  ; Next iteration
0392 2642 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2644 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2646 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2648 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 264A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 264C C2F9  30         mov   *stack+,r11           ; Pop r11
0402 264E 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2650 2000             data  >2000                 ; >2000-2fff
0408 2652 3000             data  >3000                 ; >3000-3fff
0409 2654 A000             data  >a000                 ; >a000-afff
0410 2656 B000             data  >b000                 ; >b000-bfff
0411 2658 C000             data  >c000                 ; >c000-cfff
0412 265A D000             data  >d000                 ; >d000-dfff
0413 265C E000             data  >e000                 ; >e000-efff
0414 265E F000             data  >f000                 ; >f000-ffff
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
0009 2660 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2662 FFBF 
0010 2664 0460  28         b     @putv01
     2666 2354 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2668 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     266A 0040 
0018 266C 0460  28         b     @putv01
     266E 2354 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2670 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2672 FFDF 
0026 2674 0460  28         b     @putv01
     2676 2354 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2678 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     267A 0020 
0034 267C 0460  28         b     @putv01
     267E 2354 
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
0010 2680 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2682 FFFE 
0011 2684 0460  28         b     @putv01
     2686 2354 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2688 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     268A 0001 
0019 268C 0460  28         b     @putv01
     268E 2354 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2690 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2692 FFFD 
0027 2694 0460  28         b     @putv01
     2696 2354 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2698 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     269A 0002 
0035 269C 0460  28         b     @putv01
     269E 2354 
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
0018 26A0 C83B  50 at      mov   *r11+,@wyx
     26A2 832A 
0019 26A4 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26A6 B820  54 down    ab    @hb$01,@wyx
     26A8 201C 
     26AA 832A 
0028 26AC 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26AE 7820  54 up      sb    @hb$01,@wyx
     26B0 201C 
     26B2 832A 
0037 26B4 045B  20         b     *r11
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
0049 26B6 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26B8 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26BA 832A 
0051 26BC C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26BE 832A 
0052 26C0 045B  20         b     *r11
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
0021 26C2 C120  34 yx2px   mov   @wyx,tmp0
     26C4 832A 
0022 26C6 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26C8 06C4  14         swpb  tmp0                  ; Y<->X
0024 26CA 04C5  14         clr   tmp1                  ; Clear before copy
0025 26CC D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26CE 20A0  38         coc   @wbit1,config         ; f18a present ?
     26D0 2028 
0030 26D2 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26D4 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26D6 833A 
     26D8 2702 
0032 26DA 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26DC 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26DE B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26E0 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26E2 0500 
0037 26E4 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26E6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26E8 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26EA 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26EC D105  18         movb  tmp1,tmp0
0051 26EE 06C4  14         swpb  tmp0                  ; X<->Y
0052 26F0 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26F2 202A 
0053 26F4 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26F6 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26F8 201C 
0059 26FA 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26FC 202E 
0060 26FE 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 2700 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2702 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0131               
0135               
0139               
0141                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
**** **** ****     > vdp_f18a.asm
0001               * FILE......: vdp_f18a.asm
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
0013 2704 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2706 06A0  32         bl    @putvr                ; Write once
     2708 2340 
0015 270A 391C             data  >391c                 ; VR1/57, value 00011100
0016 270C 06A0  32         bl    @putvr                ; Write twice
     270E 2340 
0017 2710 391C             data  >391c                 ; VR1/57, value 00011100
0018 2712 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2714 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2716 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2718 2340 
0028 271A 391C             data  >391c
0029 271C 0458  20         b     *tmp4                 ; Exit
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
0040 271E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2720 06A0  32         bl    @cpym2v
     2722 2458 
0042 2724 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2726 2762 
     2728 0006 
0043 272A 06A0  32         bl    @putvr
     272C 2340 
0044 272E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2730 06A0  32         bl    @putvr
     2732 2340 
0046 2734 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2736 0204  20         li    tmp0,>3f00
     2738 3F00 
0052 273A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     273C 22C8 
0053 273E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2740 8800 
0054 2742 0984  56         srl   tmp0,8
0055 2744 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2746 8800 
0056 2748 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 274A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 274C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     274E BFFF 
0060 2750 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2752 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2754 4000 
0063               f18chk_exit:
0064 2756 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2758 229C 
0065 275A 3F00             data  >3f00,>00,6
     275C 0000 
     275E 0006 
0066 2760 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2762 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2764 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2766 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2768 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 276A 06A0  32         bl    @putvr
     276C 2340 
0097 276E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2770 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2772 2340 
0100 2774 391C             data  >391c                 ; Lock the F18a
0101 2776 0458  20         b     *tmp4                 ; Exit
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
0120 2778 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 277A 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     277C 2028 
0122 277E 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2780 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2782 8802 
0127 2784 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2786 2340 
0128 2788 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 278A 04C4  14         clr   tmp0
0130 278C D120  34         movb  @vdps,tmp0
     278E 8802 
0131 2790 0984  56         srl   tmp0,8
0132 2792 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2794 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2796 832A 
0018 2798 D17B  28         movb  *r11+,tmp1
0019 279A 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 279C D1BB  28         movb  *r11+,tmp2
0021 279E 0986  56         srl   tmp2,8                ; Repeat count
0022 27A0 C1CB  18         mov   r11,tmp3
0023 27A2 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A4 2408 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27A6 020B  20         li    r11,hchar1
     27A8 27AE 
0028 27AA 0460  28         b     @xfilv                ; Draw
     27AC 22A2 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27AE 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27B0 202C 
0033 27B2 1302  14         jeq   hchar2                ; Yes, exit
0034 27B4 C2C7  18         mov   tmp3,r11
0035 27B6 10EE  14         jmp   hchar                 ; Next one
0036 27B8 05C7  14 hchar2  inct  tmp3
0037 27BA 0457  20         b     *tmp3                 ; Exit
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
0016 27BC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BE 202A 
0017 27C0 020C  20         li    r12,>0024
     27C2 0024 
0018 27C4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C6 2858 
0019 27C8 04C6  14         clr   tmp2
0020 27CA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CC 04CC  14         clr   r12
0025 27CE 1F08  20         tb    >0008                 ; Shift-key ?
0026 27D0 1302  14         jeq   realk1                ; No
0027 27D2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D4 2888 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D8 1302  14         jeq   realk2                ; No
0033 27DA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DC 28B8 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27E0 1302  14         jeq   realk3                ; No
0039 27E2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E4 28E8 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E6 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27E8 2016 
0044 27EA 1E15  20         sbz   >0015                 ; Set P5
0045 27EC 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27EE 1302  14         jeq   realk4                ; No
0047 27F0 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27F2 2016 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27F4 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27F6 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F8 0006 
0053 27FA 0606  14 realk5  dec   tmp2
0054 27FC 020C  20         li    r12,>24               ; CRU address for P2-P4
     27FE 0024 
0055 2800 06C6  14         swpb  tmp2
0056 2802 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2804 06C6  14         swpb  tmp2
0058 2806 020C  20         li    r12,6                 ; CRU read address
     2808 0006 
0059 280A 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 280C 0547  14         inv   tmp3                  ;
0061 280E 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2810 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2812 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2814 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2816 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2818 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 281A 0285  22         ci    tmp1,8
     281C 0008 
0070 281E 1AFA  14         jl    realk6
0071 2820 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2822 1BEB  14         jh    realk5                ; No, next column
0073 2824 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2826 C206  18 realk8  mov   tmp2,tmp4
0078 2828 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 282A A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 282C A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 282E D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2830 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2832 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2834 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2836 2016 
0089 2838 1608  14         jne   realka                ; No, continue saving key
0090 283A 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     283C 2882 
0091 283E 1A05  14         jl    realka
0092 2840 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2842 2880 
0093 2844 1B02  14         jh    realka                ; No, continue
0094 2846 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2848 E000 
0095 284A C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     284C 833C 
0096 284E E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2850 2014 
0097 2852 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2854 8C00 
0098                                                   ; / using R15 as temp storage
0099 2856 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2858 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     285A 0000 
     285C FF0D 
     285E 203D 
0102 2860 ....             text  'xws29ol.'
0103 2868 ....             text  'ced38ik,'
0104 2870 ....             text  'vrf47ujm'
0105 2878 ....             text  'btg56yhn'
0106 2880 ....             text  'zqa10p;/'
0107 2888 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     288A 0000 
     288C FF0D 
     288E 202B 
0108 2890 ....             text  'XWS@(OL>'
0109 2898 ....             text  'CED#*IK<'
0110 28A0 ....             text  'VRF$&UJM'
0111 28A8 ....             text  'BTG%^YHN'
0112 28B0 ....             text  'ZQA!)P:-'
0113 28B8 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28BA 0000 
     28BC FF0D 
     28BE 2005 
0114 28C0 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28C2 0804 
     28C4 0F27 
     28C6 C2B9 
0115 28C8 600B             data  >600b,>0907,>063f,>c1B8
     28CA 0907 
     28CC 063F 
     28CE C1B8 
0116 28D0 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28D2 7B02 
     28D4 015F 
     28D6 C0C3 
0117 28D8 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28DA 7D0E 
     28DC 0CC6 
     28DE BFC4 
0118 28E0 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28E2 7C03 
     28E4 BC22 
     28E6 BDBA 
0119 28E8 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28EA 0000 
     28EC FF0D 
     28EE 209D 
0120 28F0 9897             data  >9897,>93b2,>9f8f,>8c9B
     28F2 93B2 
     28F4 9F8F 
     28F6 8C9B 
0121 28F8 8385             data  >8385,>84b3,>9e89,>8b80
     28FA 84B3 
     28FC 9E89 
     28FE 8B80 
0122 2900 9692             data  >9692,>86b4,>b795,>8a8D
     2902 86B4 
     2904 B795 
     2906 8A8D 
0123 2908 8294             data  >8294,>87b5,>b698,>888E
     290A 87B5 
     290C B698 
     290E 888E 
0124 2910 9A91             data  >9a91,>81b1,>b090,>9cBB
     2912 81B1 
     2914 B090 
     2916 9CBB 
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
0023 2918 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 291A C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     291C 8340 
0025 291E 04E0  34         clr   @waux1
     2920 833C 
0026 2922 04E0  34         clr   @waux2
     2924 833E 
0027 2926 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2928 833C 
0028 292A C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 292C 0205  20         li    tmp1,4                ; 4 nibbles
     292E 0004 
0033 2930 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2932 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2934 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2936 0286  22         ci    tmp2,>000a
     2938 000A 
0039 293A 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 293C C21B  26         mov   *r11,tmp4
0045 293E 0988  56         srl   tmp4,8                ; Right justify
0046 2940 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2942 FFF6 
0047 2944 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2946 C21B  26         mov   *r11,tmp4
0054 2948 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     294A 00FF 
0055               
0056 294C A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 294E 06C6  14         swpb  tmp2
0058 2950 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2952 0944  56         srl   tmp0,4                ; Next nibble
0060 2954 0605  14         dec   tmp1
0061 2956 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2958 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     295A BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 295C C160  34         mov   @waux3,tmp1           ; Get pointer
     295E 8340 
0067 2960 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2962 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2964 C120  34         mov   @waux2,tmp0
     2966 833E 
0070 2968 06C4  14         swpb  tmp0
0071 296A DD44  32         movb  tmp0,*tmp1+
0072 296C 06C4  14         swpb  tmp0
0073 296E DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2970 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2972 8340 
0078 2974 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2976 2020 
0079 2978 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 297A C120  34         mov   @waux1,tmp0
     297C 833C 
0084 297E 06C4  14         swpb  tmp0
0085 2980 DD44  32         movb  tmp0,*tmp1+
0086 2982 06C4  14         swpb  tmp0
0087 2984 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2986 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2988 202A 
0092 298A 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 298C 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 298E 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2990 7FFF 
0098 2992 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2994 8340 
0099 2996 0460  28         b     @xutst0               ; Display string
     2998 242E 
0100 299A 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 299C C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     299E 832A 
0122 29A0 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29A2 8000 
0123 29A4 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A6 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A8 0005 
0020 29AA C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29AC C155  26         mov   *tmp1,tmp1            ; /
0022 29AE C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29B0 0228  22         ai    tmp4,4                ; Get end of buffer
     29B2 0004 
0024 29B4 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B6 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B8 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29BA 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29BC 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29BE B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29C0 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29C2 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29C4 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C6 0607  14         dec   tmp3                  ; Decrease counter
0036 29C8 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29CA 0207  20         li    tmp3,4                ; Check first 4 digits
     29CC 0004 
0041 29CE 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29D0 C11B  26         mov   *r11,tmp0
0043 29D2 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29D4 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D6 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D8 05CB  14 mknum3  inct  r11
0047 29DA 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29DC 202A 
0048 29DE 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29E0 045B  20         b     *r11                  ; Exit
0050 29E2 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29E4 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E6 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E8 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29EA 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29EC 7FFF 
0058 29EE C10B  18         mov   r11,tmp0
0059 29F0 0224  22         ai    tmp0,-4
     29F2 FFFC 
0060 29F4 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F6 0206  20         li    tmp2,>0500            ; String length = 5
     29F8 0500 
0062 29FA 0460  28         b     @xutstr               ; Display string
     29FC 2430 
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
0083               *               01234|56789A
0084               *  Before...:   XXXXX
0085               *  After....:   XXXXX|zY       where length byte z=1
0086               *               XXXXX|zYY      where length byte z=2
0087               *                 ..
0088               *               XXXXX|zYYYYY   where length byte z=5
0089               *--------------------------------------------------------------
0090               *  Destroys registers tmp0-tmp3
0091               ********|*****|*********************|**************************
0092               trimnum:
0093 29FE C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 2A00 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 2A02 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 2A04 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 2A06 0207  20         li    tmp3,5                ; Set counter
     2A08 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 2A0A 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A0C 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A0E 0584  14         inc   tmp0                  ; Next character
0105 2A10 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A12 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A14 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A16 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A18 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A1A 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill
0119 2A1C DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A1E 0607  14         dec   tmp3                  ; Last character ?
0121 2A20 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A22 045B  20         b     *r11                  ; Return
0123               
0124               
0125               
0126               
0127               ***************************************************************
0128               * PUTNUM - Put unsigned number on screen
0129               ***************************************************************
0130               *  BL   @PUTNUM
0131               *  DATA P0,P1,P2,P3
0132               *--------------------------------------------------------------
0133               *  P0   = YX position
0134               *  P1   = Pointer to 16 bit unsigned number
0135               *  P2   = Pointer to 5 byte string buffer
0136               *  P3HB = Offset for ASCII digit
0137               *  P3LB = Character for replacing leading 0's
0138               ********|*****|*********************|**************************
0139 2A24 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A26 832A 
0140 2A28 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A2A 8000 
0141 2A2C 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A2E 0649  14         dect  stack
0023 2A30 C64B  30         mov   r11,*stack            ; Save return address
0024 2A32 0649  14         dect  stack
0025 2A34 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A36 0649  14         dect  stack
0027 2A38 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A3A 0649  14         dect  stack
0029 2A3C C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A3E 0649  14         dect  stack
0031 2A40 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A42 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A44 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A46 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A48 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A4A 0649  14         dect  stack
0044 2A4C C64B  30         mov   r11,*stack            ; Save return address
0045 2A4E 0649  14         dect  stack
0046 2A50 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A52 0649  14         dect  stack
0048 2A54 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A56 0649  14         dect  stack
0050 2A58 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A5A 0649  14         dect  stack
0052 2A5C C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A5E C1D4  26 !       mov   *tmp0,tmp3
0057 2A60 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A62 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A64 00FF 
0059 2A66 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A68 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A6A 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A6C 0584  14         inc   tmp0                  ; Next byte
0067 2A6E 0607  14         dec   tmp3                  ; Shorten string length
0068 2A70 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A72 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A74 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A76 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A78 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A7A C187  18         mov   tmp3,tmp2
0078 2A7C 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A7E DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A80 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A82 24B2 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A84 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A86 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A88 FFCE 
0090 2A8A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A8C 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A8E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A90 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A92 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A94 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A96 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A98 045B  20         b     *r11                  ; Return to caller
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
0123 2A9A 0649  14         dect  stack
0124 2A9C C64B  30         mov   r11,*stack            ; Save return address
0125 2A9E 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AA0 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AA2 0649  14         dect  stack
0128 2AA4 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AA6 0649  14         dect  stack
0130 2AA8 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AAA 0649  14         dect  stack
0132 2AAC C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AAE C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AB0 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AB2 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AB4 0649  14         dect  stack
0144 2AB6 C64B  30         mov   r11,*stack            ; Save return address
0145 2AB8 0649  14         dect  stack
0146 2ABA C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2ABC 0649  14         dect  stack
0148 2ABE C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AC0 0649  14         dect  stack
0150 2AC2 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AC4 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AC6 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AC8 0586  14         inc   tmp2
0161 2ACA 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2ACC 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2ACE 0286  22         ci    tmp2,255
     2AD0 00FF 
0167 2AD2 1505  14         jgt   string.getlenc.panic
0168 2AD4 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AD6 0606  14         dec   tmp2                  ; One time adjustment
0174 2AD8 C806  38         mov   tmp2,@waux1           ; Store length
     2ADA 833C 
0175 2ADC 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2ADE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AE0 FFCE 
0181 2AE2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AE4 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AE6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AE8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AEA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AEC C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AEE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0216               
0218                       copy  "fio.equ"                  ; File I/O equates
**** **** ****     > fio.equ
0001               * FILE......: fio.equ
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations - Byte 0 in PAB
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
0018               * File & data type - Byte 1 in PAB (Bit 0-4)
0019               ***************************************************************
0020               * Bit position: 4  3  21  0
0021               *               |  |  ||   \
0022               *               |  |  ||    File type
0023               *               |  |  ||    0 = INTERNAL
0024               *               |  |  ||    1 = FIXED
0025               *               |  |  \\
0026               *               |  |   File operation
0027               *               |  |   00 - UPDATE
0028               *               |  |   01 - OUTPUT
0029               *               |  |   10 - INPUT
0030               *               |  |   11 - APPEND
0031               *               |  |
0032               *               |  \
0033               *               |   Data type
0034               *               |   0 = DISPLAY
0035               *               |   1 = INTERNAL
0036               *               |
0037               *               \
0038               *                Record type
0039               *                0 = FIXED
0040               *                1 = VARIABLE
0041               ***************************************************************
0042               ; Bit position           43210
0043               ************************************|**************************
0044      0000     io.seq.upd.dis.fix  equ :00000      ; 00
0045      0001     io.rel.upd.dis.fix  equ :00001      ; 01
0046      0003     io.rel.out.dis.fix  equ :00011      ; 02
0047      0002     io.seq.out.dis.fix  equ :00010      ; 03
0048      0004     io.seq.inp.dis.fix  equ :00100      ; 04
0049      0005     io.rel.inp.dis.fix  equ :00101      ; 05
0050      0006     io.seq.app.dis.fix  equ :00110      ; 06
0051      0007     io.rel.app.dis.fix  equ :00111      ; 07
0052      0008     io.seq.upd.int.fix  equ :01000      ; 08
0053      0009     io.rel.upd.int.fix  equ :01001      ; 09
0054      000A     io.seq.out.int.fix  equ :01010      ; 0A
0055      000B     io.rel.out.int.fix  equ :01011      ; 0B
0056      000C     io.seq.inp.int.fix  equ :01100      ; 0C
0057      000D     io.rel.inp.int.fix  equ :01101      ; 0D
0058      000E     io.seq.app.int.fix  equ :01110      ; 0E
0059      000F     io.rel.app.int.fix  equ :01111      ; 0F
0060      0010     io.seq.upd.dis.var  equ :10000      ; 10
0061      0011     io.rel.upd.dis.var  equ :10001      ; 11
0062      0012     io.seq.out.dis.var  equ :10010      ; 12
0063      0013     io.rel.out.dis.var  equ :10011      ; 13
0064      0014     io.seq.inp.dis.var  equ :10100      ; 14
0065      0015     io.rel.inp.dis.var  equ :10101      ; 15
0066      0016     io.seq.app.dis.var  equ :10110      ; 16
0067      0017     io.rel.app.dis.var  equ :10111      ; 17
0068      0018     io.seq.upd.int.var  equ :11000      ; 18
0069      0019     io.rel.upd.int.var  equ :11001      ; 19
0070      001A     io.seq.out.int.var  equ :11010      ; 1A
0071      001B     io.rel.out.int.var  equ :11011      ; 1B
0072      001C     io.seq.inp.int.var  equ :11100      ; 1C
0073      001D     io.rel.inp.int.var  equ :11101      ; 1D
0074      001E     io.seq.app.int.var  equ :11110      ; 1E
0075      001F     io.rel.app.int.var  equ :11111      ; 1F
0076               ***************************************************************
0077               * File error codes - Byte 1 in PAB (Bits 5-7)
0078               ************************************|**************************
0079      0000     io.err.no_error_occured             equ 0
0080                       ; Error code 0 with condition bit reset, indicates that
0081                       ; no error has occured
0082               
0083      0000     io.err.bad_device_name              equ 0
0084                       ; Device indicated not in system
0085                       ; Error code 0 with condition bit set, indicates a
0086                       ; device not present in system
0087               
0088      0001     io.err.device_write_prottected      equ 1
0089                       ; Device is write protected
0090               
0091      0002     io.err.bad_open_attribute           equ 2
0092                       ; One or more of the OPEN attributes are illegal or do
0093                       ; not match the file's actual characteristics.
0094                       ; This could be:
0095                       ;   * File type
0096                       ;   * Record length
0097                       ;   * I/O mode
0098                       ;   * File organization
0099               
0100      0003     io.err.illegal_operation            equ 3
0101                       ; Either an issued I/O command was not supported, or a
0102                       ; conflict with the OPEN mode has occured
0103               
0104      0004     io.err.out_of_table_buffer_space    equ 4
0105                       ; The amount of space left on the device is insufficient
0106                       ; for the requested operation
0107               
0108      0005     io.err.eof                          equ 5
0109                       ; Attempt to read past end of file.
0110                       ; This error may also be given for non-existing records
0111                       ; in a relative record file
0112               
0113      0006     io.err.device_error                 equ 6
0114                       ; Covers all hard device errors, such as parity and
0115                       ; bad medium errors
0116               
0117      0007     io.err.file_error                   equ 7
0118                       ; Covers all file-related error like: program/data
0119                       ; file mismatch, non-existing file opened for input mode, etc.
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
0010               * dsrlnk - DSRLNK for file I/O in DSR space >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  Input:
0016               *  P0     = 8 or 10 (a)
0017               *  @>8356 = Pointer to VDP PAB file descriptor length (PAB+9)
0018               *--------------------------------------------------------------
0019               *  Output:
0020               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0021               *--------------------------------------------------------------
0022               *  Remarks:
0023               *
0024               *  You need to specify following equates in main program
0025               *
0026               *  dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0027               *  dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0028               *
0029               *  Scratchpad memory usage
0030               *  >8322            Parameter (>08) or (>0A) passed to dsrlnk
0031               *  >8356            Pointer to PAB
0032               *  >83D0            CRU address of current device
0033               *  >83D2            DSR entry address
0034               *  >83e0 - >83ff    GPL / DSRLNK workspace
0035               *
0036               *  Credits
0037               *  Originally appeared in Miller Graphics The Smart Programmer.
0038               *  This version based on version of Paolo Bagnaresi.
0039               *
0040               *  The following memory address can be used to directly jump
0041               *  into the DSR in consequtive calls without having to
0042               *  scan the PEB cards again:
0043               *
0044               *  dsrlnk.namsto  -  8-byte RAM buf for holding device name
0045               *  dsrlnk.savcru  -  CRU address of device in prev. DSR call
0046               *  dsrlnk.savent  -  DSR entry addr of prev. DSR call
0047               *  dsrlnk.savpab  -  Pointer to Device or Subprogram in PAB
0048               *  dsrlnk.savver  -  Version used in prev. DSR call
0049               *  dsrlnk.savlen  -  Length of DSR name of prev. DSR call (in MSB)
0050               *  dsrlnk.flgptr  -  Pointer to VDP PAB byte 1 (flag byte)
0051               
0052               *--------------------------------------------------------------
0053      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0054                                                   ; dstype is address of R5 of DSRLNK ws.
0055               ********|*****|*********************|**************************
0056 2AF0 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AF2 2AF4             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AF4 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AF6 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AF8 A428 
0064 2AFA 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AFC 2026 
0065 2AFE C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2B00 8356 
0066 2B02 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B04 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B06 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B08 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B0A A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B0C 06C0  14         swpb  r0                    ;
0075 2B0E D800  38         movb  r0,@vdpa              ; Send low byte
     2B10 8C02 
0076 2B12 06C0  14         swpb  r0                    ;
0077 2B14 D800  38         movb  r0,@vdpa              ; Send high byte
     2B16 8C02 
0078 2B18 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B1A 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B1C 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B1E 0704  14         seto  r4                    ; Init counter
0086 2B20 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B22 A420 
0087 2B24 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B26 0584  14         inc   r4                    ; Increment char counter
0089 2B28 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B2A 0007 
0090 2B2C 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B2E 80C4  18         c     r4,r3                 ; End of name?
0093 2B30 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B32 06C0  14         swpb  r0                    ;
0098 2B34 D800  38         movb  r0,@vdpa              ; Send low byte
     2B36 8C02 
0099 2B38 06C0  14         swpb  r0                    ;
0100 2B3A D800  38         movb  r0,@vdpa              ; Send high byte
     2B3C 8C02 
0101 2B3E D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B40 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B42 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B44 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B46 2C5C 
0109 2B48 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B4A C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B4C 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B4E 04E0  34         clr   @>83d0
     2B50 83D0 
0118 2B52 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B54 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B56 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B58 A432 
0121               
0122 2B5A 0584  14         inc   r4                    ; Adjust for dot
0123 2B5C A804  38         a     r4,@>8356             ; Point to position after name
     2B5E 8356 
0124 2B60 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B62 8356 
     2B64 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B66 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B68 83E0 
0130 2B6A 04C1  14         clr   r1                    ; Version found of dsr
0131 2B6C 020C  20         li    r12,>0f00             ; Init cru address
     2B6E 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B70 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B72 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B74 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B76 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B78 0100 
0145 2B7A 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B7C 83D0 
0146 2B7E 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B80 2000 
0147 2B82 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B84 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B86 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B88 1D00  20         sbo   0                     ; Turn on ROM
0154 2B8A 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B8C 4000 
0155 2B8E 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B90 2C58 
0156 2B92 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B94 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B96 A40A 
0166 2B98 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B9A C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B9C 83D2 
0172                                                   ; subprogram
0173               
0174 2B9E 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2BA0 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BA2 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BA4 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BA6 83D2 
0183                                                   ; subprogram
0184               
0185 2BA8 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BAA C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BAC 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BAE D160  34         movb  @>8355,r5             ; Get length as counter
     2BB0 8355 
0195 2BB2 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BB4 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BB6 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BB8 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BBA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BBC A420 
0206 2BBE 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BC0 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BC2 0605  14         dec   r5                    ; Update loop counter
0211 2BC4 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BC6 0581  14         inc   r1                    ; Next version found
0217 2BC8 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BCA A42A 
0218 2BCC C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BCE A42C 
0219 2BD0 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BD2 A430 
0220               
0221 2BD4 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BD6 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BD8 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BDA 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BDC 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BDE 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BE0 A400 
0233 2BE2 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BE4 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BE6 A428 
0239                                                   ; (8 or >a)
0240 2BE8 0281  22         ci    r1,8                  ; was it 8?
     2BEA 0008 
0241 2BEC 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BEE D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BF0 8350 
0243                                                   ; Get error byte from @>8350
0244 2BF2 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BF4 06C0  14         swpb  r0                    ;
0252 2BF6 D800  38         movb  r0,@vdpa              ; send low byte
     2BF8 8C02 
0253 2BFA 06C0  14         swpb  r0                    ;
0254 2BFC D800  38         movb  r0,@vdpa              ; send high byte
     2BFE 8C02 
0255 2C00 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C02 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C04 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C06 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C08 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C0A 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C0C 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C0E A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C10 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C12 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C14 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C16 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C18 2026 
0281                                                   ; / to indicate error
0282 2C1A 0380  18         rtwp                        ; Return from DSR workspace to caller
0283                                                   ; workspace
0284               
0285               
0286               ***************************************************************
0287               * dsrln.reuse - Reuse previous DSRLNK call for improved speed
0288               ***************************************************************
0289               *  blwp @dsrlnk.reuse
0290               *--------------------------------------------------------------
0291               *  Input:
0292               *  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
0293               *  @dsrlnk.savcru = CRU address of device in previous DSR call
0294               *  @dsrlnk.savent = DSR entry address of previous DSR call
0295               *  @dsrlnk.savver = Version used in previous DSR call
0296               *  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
0297               *--------------------------------------------------------------
0298               *  Output:
0299               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0300               *--------------------------------------------------------------
0301               *  Remarks:
0302               *   Call the same DSR entry again without having to scan through
0303               *   all devices again.
0304               *
0305               *   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
0306               *   set by previous DSRLNK call.
0307               ********|*****|*********************|**************************
0308               dsrlnk.reuse:
0309 2C1C A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C1E 2C20             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C20 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C22 83E0 
0316               
0317 2C24 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C26 2026 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C28 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C2A A42A 
0322 2C2C C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C2E C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C30 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C32 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C34 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C36 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C38 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C3A 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C3C 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C3E 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C40 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C42 4000 
     2C44 2C58 
0337 2C46 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C48 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C4A 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C4C 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C4E 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C50 A400 
0355 2C52 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C54 A434 
0356               
0357 2C56 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C58 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C5A 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C5C ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0220                       copy  "fio_level3.asm"           ; File I/O level 3 support
**** **** ****     > fio_level3.asm
0001               * FILE......: fio_level3.asm
0002               * Purpose...: File I/O level 3 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
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
0029               *       data P0,P1
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *  P1 = LSB contains File type/mode
0033               *--------------------------------------------------------------
0034               *  bl   @xfile.open
0035               *
0036               *  R0 = Address of PAB in VDP RAM
0037               *  R1 = LSB contains File type/mode
0038               *--------------------------------------------------------------
0039               *  Output:
0040               *  tmp0     = Copy of VDP PAB byte 1 after operation
0041               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0042               *  tmp2 LSB = Copy of status register after operation
0043               ********|*****|*********************|**************************
0044               file.open:
0045 2C5E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C60 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C62 0649  14         dect  stack
0052 2C64 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C66 0204  20         li    tmp0,dsrlnk.savcru
     2C68 A42A 
0057 2C6A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C6C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C6E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C70 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C72 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C74 37D7 
0065 2C76 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C78 8370 
0066                                                   ; / location
0067 2C7A C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C7C A44C 
0068 2C7E 04C5  14         clr   tmp1                  ; io.op.open
0069 2C80 101F  14         jmp   _file.record.fop      ; Do file operation
0070               
0071               
0072               
0073               ***************************************************************
0074               * file.close - Close currently open file
0075               ***************************************************************
0076               *  bl   @file.close
0077               *       data P0
0078               *--------------------------------------------------------------
0079               *  P0 = Address of PAB in VDP RAM
0080               *--------------------------------------------------------------
0081               *  bl   @xfile.close
0082               *
0083               *  R0 = Address of PAB in VDP RAM
0084               *--------------------------------------------------------------
0085               *  Output:
0086               *  tmp0 LSB = Copy of VDP PAB byte 1 after operation
0087               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0088               *  tmp2 LSB = Copy of status register after operation
0089               ********|*****|*********************|**************************
0090               file.close:
0091 2C82 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C84 0649  14         dect  stack
0097 2C86 C64B  30         mov   r11,*stack            ; Save return address
0098 2C88 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C8A 0001 
0099 2C8C 1019  14         jmp   _file.record.fop      ; Do file operation
0100               
0101               
0102               ***************************************************************
0103               * file.record.read - Read record from file
0104               ***************************************************************
0105               *  bl   @file.record.read
0106               *       data P0
0107               *--------------------------------------------------------------
0108               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0109               *--------------------------------------------------------------
0110               *  bl   @xfile.record.read
0111               *
0112               *  R0 = Address of PAB in VDP RAM
0113               *--------------------------------------------------------------
0114               *  Output:
0115               *  tmp0     = Copy of VDP PAB byte 1 after operation
0116               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0117               *  tmp2 LSB = Copy of status register after operation
0118               ********|*****|*********************|**************************
0119               file.record.read:
0120 2C8E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C90 0649  14         dect  stack
0125 2C92 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C94 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C96 0002 
0128 2C98 1013  14         jmp   _file.record.fop      ; Do file operation
0129               
0130               
0131               
0132               ***************************************************************
0133               * file.record.write - Write record to file
0134               ***************************************************************
0135               *  bl   @file.record.write
0136               *       data P0
0137               *--------------------------------------------------------------
0138               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0139               *--------------------------------------------------------------
0140               *  bl   @xfile.record.write
0141               *
0142               *  R0 = Address of PAB in VDP RAM
0143               *--------------------------------------------------------------
0144               *  Output:
0145               *  tmp0     = Copy of VDP PAB byte 1 after operation
0146               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0147               *  tmp2 LSB = Copy of status register after operation
0148               ********|*****|*********************|**************************
0149               file.record.write:
0150 2C9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C9C 0649  14         dect  stack
0155 2C9E C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2CA0 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CA2 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CA4 0005 
0159               
0160 2CA6 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CA8 A43E 
0161               
0162 2CAA 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CAC 22DA 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CAE 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CB0 0003 
0167 2CB2 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CB4 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CB6 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CB8 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CBA 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CBC 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CBE 1000  14         nop
0193               
0194               
0195               
0196               ***************************************************************
0197               * file.record.fop - File operation
0198               ***************************************************************
0199               * Called internally via JMP/B by file operations
0200               *--------------------------------------------------------------
0201               *  Input:
0202               *  r0   = Address of PAB in VDP RAM
0203               *  r1   = File type/mode
0204               *  tmp1 = File operation opcode
0205               *
0206               *  @fh.offsetopcode = >00  Data buffer in VDP RAM
0207               *  @fh.offsetopcode = >40  Data buffer in CPU RAM
0208               *--------------------------------------------------------------
0209               *  Output:
0210               *  tmp0     = Copy of VDP PAB byte 1 after operation
0211               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0212               *  tmp2 LSB = Copy of status register after operation
0213               *--------------------------------------------------------------
0214               *  Register usage:
0215               *  r0, r1, tmp0, tmp1, tmp2
0216               *--------------------------------------------------------------
0217               *  Remarks
0218               *  Private, only to be called from inside fio_level2 module
0219               *  via jump or branch instruction.
0220               *
0221               *  Uses @waux1 for backup/restore of memory word @>8322
0222               ********|*****|*********************|**************************
0223               _file.record.fop:
0224                       ;------------------------------------------------------
0225                       ; Write to PAB required?
0226                       ;------------------------------------------------------
0227 2CC0 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CC2 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CC6 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CC8 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CCA 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CCC 22DA 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CCE C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CD0 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CD2 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CD4 A44C 
0246               
0247 2CD6 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CD8 22DA 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CDA 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CDC 0009 
0254 2CDE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CE0 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CE2 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CE4 8322 
     2CE6 833C 
0259               
0260 2CE8 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CEA A42A 
0261 2CEC 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CEE 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CF0 2AF0 
0268 2CF2 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CF4 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CF6 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CF8 2C1C 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CFA 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CFC C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CFE 833C 
     2D00 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D02 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D04 A436 
0292 2D06 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D08 0005 
0293 2D0A 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D0C 22F2 
0294 2D0E C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D10 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0299                                                   ; as returned by DSRLNK
0300               *--------------------------------------------------------------
0301               * Exit
0302               *--------------------------------------------------------------
0303               ; If an error occured during the IO operation, then the
0304               ; equal bit in the saved status register (=tmp2) is set to 1.
0305               ;
0306               ; Upon return from this IO call you should basically test with:
0307               ;       coc   @wbit2,tmp2           ; Equal bit set?
0308               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0309               ;
0310               ; Then look for further details in the copy of VDP PAB byte 1
0311               ; in register tmp0, bits 13-15
0312               ;
0313               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0314               ;                                   ; calls, skip for type >A subprograms!)
0315               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0316               ;       jeq   my_error_handler
0317               *--------------------------------------------------------------
0318               _file.record.fop.exit:
0319 2D12 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D14 045B  20         b     *r11                  ; Return to caller
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
0011               *  This is basically the kernel keeping everything together.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2D16 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D18 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D1A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D1C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D1E 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D20 2026 
0029 2D22 1602  14         jne   tmgr1a                ; No, so move on
0030 2D24 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D26 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D28 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D2A 202A 
0035 2D2C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D2E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D30 201A 
0048 2D32 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D34 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D36 2018 
0050 2D38 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D3A 0460  28         b     @kthread              ; Run kernel thread
     2D3C 2DB4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D3E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D40 201E 
0056 2D42 13EB  14         jeq   tmgr1
0057 2D44 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D46 201C 
0058 2D48 16E8  14         jne   tmgr1
0059 2D4A C120  34         mov   @wtiusr,tmp0
     2D4C 832E 
0060 2D4E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D50 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D52 2DB2 
0065 2D54 C10A  18         mov   r10,tmp0
0066 2D56 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D58 00FF 
0067 2D5A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D5C 2026 
0068 2D5E 1303  14         jeq   tmgr5
0069 2D60 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D62 003C 
0070 2D64 1002  14         jmp   tmgr6
0071 2D66 0284  22 tmgr5   ci    tmp0,50
     2D68 0032 
0072 2D6A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D6C 1001  14         jmp   tmgr8
0074 2D6E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D70 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D72 832C 
0079 2D74 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D76 FF00 
0080 2D78 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D7A 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D7C 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D7E 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D80 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D82 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D84 830C 
     2D86 830D 
0089 2D88 1608  14         jne   tmgr10                ; No, get next slot
0090 2D8A 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D8C FF00 
0091 2D8E C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D90 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D92 8330 
0096 2D94 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D96 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D98 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D9A 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D9C 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D9E 8315 
     2DA0 8314 
0103 2DA2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DA6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DA8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DAA 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DAC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DAE FF00 
0109 2DB0 10B4  14         jmp   tmgr1
0110 2DB2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DB4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DB6 201A 
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
0041 2DB8 06A0  32         bl    @realkb               ; Scan full keyboard
     2DBA 27BC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DBC 0460  28         b     @tmgr3                ; Exit
     2DBE 2D3E 
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
0017 2DC0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DC2 832E 
0018 2DC4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DC6 201C 
0019 2DC8 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D1A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DCA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DCC 832E 
0029 2DCE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DD0 FEFF 
0030 2DD2 045B  20         b     *r11                  ; Return
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
0017 2DD4 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DD6 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DD8 C184  18         mov   tmp0,tmp2
0023 2DDA 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DDC A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DDE 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DE0 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DE2 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE4 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DE6 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DE8 202C 
0035 2DEA 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DEC 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DEE 05CB  14 mkslo1  inct  r11
0041 2DF0 045B  20         b     *r11                  ; Exit
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
0052 2DF2 C13B  30 clslot  mov   *r11+,tmp0
0053 2DF4 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DF6 A120  34         a     @wtitab,tmp0          ; Add table base
     2DF8 832C 
0055 2DFA 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DFC 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DFE 045B  20         b     *r11                  ; Exit
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
0068 2E00 C13B  30 rsslot  mov   *r11+,tmp0
0069 2E02 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E04 A120  34         a     @wtitab,tmp0          ; Add table base
     2E06 832C 
0071 2E08 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E0A C154  26         mov   *tmp0,tmp1
0073 2E0C 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E0E FF00 
0074 2E10 C505  30         mov   tmp1,*tmp0
0075 2E12 045B  20         b     *r11                  ; Exit
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
0260 2E14 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E16 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E18 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E1A 0000 
0266 2E1C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E1E 8300 
0267 2E20 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E22 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E24 0202  20 runli2  li    r2,>8308
     2E26 8308 
0272 2E28 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E2A 0282  22         ci    r2,>8400
     2E2C 8400 
0274 2E2E 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E30 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E32 FFFF 
0279 2E34 1602  14         jne   runli4                ; No, continue
0280 2E36 0420  54         blwp  @0                    ; Yes, bye bye
     2E38 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E3A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E3C 833C 
0285 2E3E 04C1  14         clr   r1                    ; Reset counter
0286 2E40 0202  20         li    r2,10                 ; We test 10 times
     2E42 000A 
0287 2E44 C0E0  34 runli5  mov   @vdps,r3
     2E46 8802 
0288 2E48 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E4A 202A 
0289 2E4C 1302  14         jeq   runli6
0290 2E4E 0581  14         inc   r1                    ; Increase counter
0291 2E50 10F9  14         jmp   runli5
0292 2E52 0602  14 runli6  dec   r2                    ; Next test
0293 2E54 16F7  14         jne   runli5
0294 2E56 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E58 1250 
0295 2E5A 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E5C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E5E 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E60 06A0  32 runli7  bl    @loadmc
     2E62 2228 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E64 04C1  14 runli9  clr   r1
0305 2E66 04C2  14         clr   r2
0306 2E68 04C3  14         clr   r3
0307 2E6A 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E6C 3000 
0308 2E6E 020F  20         li    r15,vdpw              ; Set VDP write address
     2E70 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E72 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E74 4A4A 
0317 2E76 1605  14         jne   runlia
0318 2E78 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E7A 229C 
0319 2E7C 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E7E 0000 
     2E80 3000 
0324 2E82 06A0  32 runlia  bl    @filv
     2E84 229C 
0325 2E86 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E88 00F4 
     2E8A 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E8C 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E8E 2704 
0333 2E90 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E92 271E 
0334 2E94 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E96 2714 
0335               
0336 2E98 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E9A 2340 
0337 2E9C 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E9E 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2EA0 2306 
0351 2EA2 3084             data  spvmod                ; Equate selected video mode table
0352 2EA4 0204  20         li    tmp0,spfont           ; Get font option
     2EA6 000C 
0353 2EA8 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EAA 1304  14         jeq   runlid                ; Yes, skip it
0355 2EAC 06A0  32         bl    @ldfnt
     2EAE 236E 
0356 2EB0 1100             data  fntadr,spfont         ; Load specified font
     2EB2 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EB4 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EB6 4A4A 
0361 2EB8 1602  14         jne   runlie                ; No, continue
0362 2EBA 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EBC 2090 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EBE 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EC0 0040 
0367 2EC2 0460  28         b     @main                 ; Give control to main program
     2EC4 6036 
**** **** ****     > stevie_b1.asm.2405726
0057                                                   ; Relocated spectra2 in low MEMEXP, was
0058                                                   ; copied to >2000 from ROM in bank 0
0059                       ;------------------------------------------------------
0060                       ; End of File marker
0061                       ;------------------------------------------------------
0062 2EC6 DEAD             data >dead,>beef,>dead,>beef
     2EC8 BEEF 
     2ECA DEAD 
     2ECC BEEF 
0064               ***************************************************************
0065               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0066               ********|*****|*********************|**************************
0067                       aorg  >3000
0068                       ;------------------------------------------------------
0069                       ; Activate bank 1
0070                       ;------------------------------------------------------
0071 3000 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
     3002 6002 
0072 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0073                       ;------------------------------------------------------
0074                       ; Resident Stevie modules >3000 - >3fff
0075                       ;------------------------------------------------------
0076                       copy  "fb.asm"              ; Framebuffer
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
0024 3008 0649  14         dect  stack
0025 300A C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 300C 0204  20         li    tmp0,fb.top
     300E A600 
0030 3010 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3012 A100 
0031 3014 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3016 A104 
0032 3018 04E0  34         clr   @fb.row               ; Current row=0
     301A A106 
0033 301C 04E0  34         clr   @fb.column            ; Current column=0
     301E A10C 
0034               
0035 3020 0204  20         li    tmp0,colrow
     3022 0050 
0036 3024 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3026 A10E 
0037               
0038 3028 0204  20         li    tmp0,29
     302A 001D 
0039 302C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     302E A118 
0040 3030 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3032 A11A 
0041               
0042 3034 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3036 A01C 
0043 3038 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     303A A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 303C 06A0  32         bl    @film
     303E 2244 
0048 3040 A600             data  fb.top,>00,fb.size    ; Clear it all the way
     3042 0000 
     3044 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit:
0053 3046 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 3048 045B  20         b     *r11                  ; Return to caller
0055               
**** **** ****     > stevie_b1.asm.2405726
0077                       copy  "edb.asm"             ; Editor Buffer
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
0026 304A 0649  14         dect  stack
0027 304C C64B  30         mov   r11,*stack            ; Save return address
0028 304E 0649  14         dect  stack
0029 3050 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 3052 0204  20         li    tmp0,edb.top          ; \
     3054 C000 
0034 3056 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     3058 A200 
0035 305A C804  38         mov   tmp0,@edb.next_free.ptr
     305C A208 
0036                                                   ; Set pointer to next free line
0037               
0038 305E 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     3060 A20A 
0039               
0040 3062 0204  20         li    tmp0,1
     3064 0001 
0041 3066 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     3068 A204 
0042 306A 04E0  34         clr   @edb.rle              ; RLE compression off
     306C A20C 
0043               
0044 306E 0204  20         li    tmp0,txt.newfile      ; "New file"
     3070 3350 
0045 3072 C804  38         mov   tmp0,@edb.filename.ptr
     3074 A20E 
0046               
0047 3076 0204  20         li    tmp0,txt.filetype.none
     3078 3362 
0048 307A C804  38         mov   tmp0,@edb.filetype.ptr
     307C A210 
0049               
0050               edb.init.exit:
0051                       ;------------------------------------------------------
0052                       ; Exit
0053                       ;------------------------------------------------------
0054 307E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0055 3080 C2F9  30         mov   *stack+,r11           ; Pop r11
0056 3082 045B  20         b     *r11                  ; Return to caller
0057               
0058               
0059               
0060               
**** **** ****     > stevie_b1.asm.2405726
0078                       ;------------------------------------------------------
0079                       ; Resident Stevie modules >3000 - >3fff
0080                       ;------------------------------------------------------
0081                       copy  "data.constants.asm"  ; Data Constants
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
0033 3084 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3086 003F 
     3088 0243 
     308A 05F4 
     308C 0050 
0034               
0035               romsat:
0036 308E 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     3090 0001 
0037               
0038               cursors:
0039 3092 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     3094 0000 
     3096 0000 
     3098 001C 
0040 309A 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     309C 1010 
     309E 1010 
     30A0 1000 
0041 30A2 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     30A4 1C1C 
     30A6 1C1C 
     30A8 1C00 
0042               
0043               patterns:
0044 30AA 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     30AC 0000 
     30AE 00FF 
     30B0 0000 
0045 30B2 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     30B4 0000 
     30B6 FF00 
     30B8 FF00 
0046               
0047               patterns.box:
0048 30BA 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     30BC 0000 
     30BE FF00 
     30C0 FF00 
0049 30C2 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     30C4 0000 
     30C6 FF80 
     30C8 BFA0 
0050 30CA 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     30CC 0000 
     30CE FC04 
     30D0 F414 
0051 30D2 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     30D4 A0A0 
     30D6 A0A0 
     30D8 A0A0 
0052 30DA 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     30DC 1414 
     30DE 1414 
     30E0 1414 
0053 30E2 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     30E4 A0A0 
     30E6 BF80 
     30E8 FF00 
0054 30EA 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     30EC 1414 
     30EE F404 
     30F0 FC00 
0055 30F2 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     30F4 C0C0 
     30F6 C0C0 
     30F8 0080 
0056 30FA 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     30FC 0F0F 
     30FE 0F0F 
     3100 0000 
0057               
0058               
0059               patterns.cr:
0060 3102 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     3104 6C48 
     3106 4800 
     3108 7C00 
0061 310A 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     310C 64FC 
     310E 6020 
     3110 0000 
0062               
0063               
0064               alphalock:
0065 3112 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     3114 00E0 
     3116 E0E0 
     3118 E0E0 
0066 311A 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     311C E0E0 
     311E E0E0 
     3120 0000 
0067               
0068               
0069               vertline:
0070 3122 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     3124 1010 
     3126 1010 
     3128 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 312A 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     312C 0002 
0078 312E 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     3130 0003 
0079 3132 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3134 000A 
0080               
0081 3136 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     3138 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 313A C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     313C 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 313E D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     3140 000D 
0090 3142 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     3144 000E 
0091 3146 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     3148 000F 
0092               
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * Stevie color schemes table
0099               *--------------------------------------------------------------
0100               * Word 1
0101               * A  MSB  high-nibble    Foreground color frame buffer
0102               * B  MSB  low-nibble     Background color frame buffer
0103               * C  LSB  high-nibble    Foreground color bottom line
0104               * D  LSB  low-nibble     Background color bottom line
0105               *
0106               * Word 2
0107               * E  MSB  high-nibble    Foreground color cmdb pane
0108               * F  MSB  low-nibble     Background color cmdb pane
0109               * G  LSB  high-nibble    0
0110               * H  LSB  low-nibble     Cursor foreground color
0111               *
0112               * Word 3
0113               * I  MSB  high-nibble    Foreground color busy bottom line
0114               * J  MSB  low-nibble     Background color busy bottom line
0115               * K  LSB  high-nibble    0
0116               * L  LSB  low-nibble     0
0117               *
0118               * Word 4
0119               * M  MSB  high-nibble    0
0120               * N  MSB  low-nibble     0
0121               * O  LSB  high-nibble    0
0122               * P  LSB  low-nibble     0
0123               *--------------------------------------------------------------
0124      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0125               
0126               tv.colorscheme.table:
0127               ;                              ; #  AB          | CD          | EF    | GH
0128               ;       ABCD  EFGH  IJKL  MNOP ; ---------------|-------------|-------|---------
0129 314A F41F      data  >f41f,>f001,>1b00,>0000 ; 1  whit/dblue  | black/whit  | whit  | black
     314C F001 
     314E 1B00 
     3150 0000 
0130 3152 F41C      data  >f41c,>f00f,>1b00,>0000 ; 2  whit/dblue  | black/dgreen| whit  | whit
     3154 F00F 
     3156 1B00 
     3158 0000 
0131 315A A11A      data  >a11a,>f00f,>1b00,>0000 ; 3  yel/black   | black/dyel  | whit  | whit
     315C F00F 
     315E 1B00 
     3160 0000 
0132 3162 2112      data  >2112,>f00f,>1b00,>0000 ; 4  mgreen/black| black/mgreen| white | whit
     3164 F00F 
     3166 1B00 
     3168 0000 
0133 316A E11E      data  >e11e,>f00f,>1b00,>0000 ; 5  grey/black  | black/grey  | white | whit
     316C F00F 
     316E 1B00 
     3170 0000 
0134 3172 1771      data  >1771,>1006,>1b00,>0000 ; 6  black/cyan  | cyan/black  | black | ?
     3174 1006 
     3176 1B00 
     3178 0000 
0135 317A 1FF1      data  >1ff1,>1001,>1b00,>0000 ; 7  black/whit  | whit/black  | black | black
     317C 1001 
     317E 1B00 
     3180 0000 
0136 3182 A1F0      data  >a1f0,>1a0f,>1b00,>0000 ; 8  dyel/black  | whit/trnsp  | inver | whit
     3184 1A0F 
     3186 1B00 
     3188 0000 
0137 318A 21F0      data  >21f0,>f20f,>1b00,>0000 ; 9  mgreen/black| whit/trnsp  | inver | whit
     318C F20F 
     318E 1B00 
     3190 0000 
0138               
**** **** ****     > stevie_b1.asm.2405726
0082                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for welcome pane
0010               ;--------------------------------------------------------------
0011               txt.about.program
0012 3192 0C53             byte  12
0013 3193 ....             text  'Stevie v0.1E'
0014                       even
0015               
0016               txt.about.purpose
0017 31A0 2350             byte  35
0018 31A1 ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 31C4 1D32             byte  29
0023 31C5 ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 31E2 1B68             byte  27
0028 31E3 ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 31FE 1542             byte  21
0033 31FF ....             text  'Build: 201109-2405726'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 3214 2446             byte  36
0039 3215 ....             text  'FCTN-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 323A 2246             byte  34
0044 323B ....             text  'FCTN-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 325E 1946             byte  25
0049 325F ....             text  'FCTN-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 3278 1C43             byte  28
0054 3279 ....             text  'CTRL-L (^L)   Load DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 3296 1C43             byte  28
0059 3297 ....             text  'CTRL-K (^K)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 32B4 1A43             byte  26
0064 32B5 ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 32D0 380E     txt.about.msg7     byte    56,14
0069 32D2 ....                        text    ' ALPHA LOCK up     '
0070                                  byte    15
0071 32E6 ....                        text    ' ALPHA LOCK down   '
0072 32F9 ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 330A ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 330C 052A             byte  5
0085 330D ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 3312 0520             byte  5
0090 3313 ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 3318 034F             byte  3
0095 3319 ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 331C 0349             byte  3
0100 331D ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 3320 012A             byte  1
0105 3321 ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 3322 0A4C             byte  10
0110 3323 ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 332E 0953             byte  9
0115 332F ....             text  'Saving...'
0116                       even
0117               
0118               txt.fastmode
0119 3338 0846             byte  8
0120 3339 ....             text  'Fastmode'
0121                       even
0122               
0123               txt.kb
0124 3342 026B             byte  2
0125 3343 ....             text  'kb'
0126                       even
0127               
0128               txt.lines
0129 3346 054C             byte  5
0130 3347 ....             text  'Lines'
0131                       even
0132               
0133               txt.bufnum
0134 334C 0323             byte  3
0135 334D ....             text  '#1 '
0136                       even
0137               
0138               txt.newfile
0139 3350 0A5B             byte  10
0140 3351 ....             text  '[New file]'
0141                       even
0142               
0143               txt.filetype.dv80
0144 335C 0444             byte  4
0145 335D ....             text  'DV80'
0146                       even
0147               
0148               txt.filetype.none
0149 3362 0420             byte  4
0150 3363 ....             text  '    '
0151                       even
0152               
0153               
0154 3368 010F     txt.alpha.up       data >010f
0155 336A 010E     txt.alpha.down     data >010e
0156 336C 0110     txt.vertline       data >0110
0157               
0158               
0159               ;--------------------------------------------------------------
0160               ; Dialog Load DV 80 file
0161               ;--------------------------------------------------------------
0162               txt.head.load
0163 336E 0F4C             byte  15
0164 336F ....             text  'Load DV80 file '
0165                       even
0166               
0167               txt.hint.load
0168 337E 4D48             byte  77
0169 337F ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0170                       even
0171               
0172               txt.keys.load
0173 33CC 3746             byte  55
0174 33CD ....             text  'F9=Back    F3=Clear    F5=Fastmode    ^A=Home    ^F=End'
0175                       even
0176               
0177               txt.keys.load2
0178 3404 3746             byte  55
0179 3405 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    ^A=Home    ^F=End'
0180                       even
0181               
0182               
0183               ;--------------------------------------------------------------
0184               ; Dialog Save DV 80 file
0185               ;--------------------------------------------------------------
0186               txt.head.save
0187 343C 0F53             byte  15
0188 343D ....             text  'Save DV80 file '
0189                       even
0190               
0191               txt.hint.save
0192 344C 3F48             byte  63
0193 344D ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0194                       even
0195               
0196               txt.keys.save
0197 348C 2846             byte  40
0198 348D ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0199                       even
0200               
0201               
0202               ;--------------------------------------------------------------
0203               ; Dialog "Unsaved changes"
0204               ;--------------------------------------------------------------
0205               txt.head.unsaved
0206 34B6 1055             byte  16
0207 34B7 ....             text  'Unsaved changes '
0208                       even
0209               
0210               txt.hint.unsaved
0211 34C8 3F48             byte  63
0212 34C9 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0213                       even
0214               
0215               txt.keys.unsaved
0216 3508 2846             byte  40
0217 3509 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0218                       even
0219               
0220               txt.warn.unsaved
0221 3532 3259             byte  50
0222 3533 ....             text  'You are about to lose changes to the current file!'
0223                       even
0224               
0225               
0226               ;--------------------------------------------------------------
0227               ; Dialog "About"
0228               ;--------------------------------------------------------------
0229               txt.head.about
0230 3566 0D41             byte  13
0231 3567 ....             text  'About Stevie '
0232                       even
0233               
0234               txt.hint.about
0235 3574 2C48             byte  44
0236 3575 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0237                       even
0238               
0239               txt.keys.about
0240 35A2 1546             byte  21
0241 35A3 ....             text  'F9=Back    ENTER=Back'
0242                       even
0243               
0244               
0245               ;--------------------------------------------------------------
0246               ; Strings for error line pane
0247               ;--------------------------------------------------------------
0248               txt.ioerr.load
0249 35B8 2049             byte  32
0250 35B9 ....             text  'I/O error. Failed loading file: '
0251                       even
0252               
0253               txt.ioerr.save
0254 35DA 1F49             byte  31
0255 35DB ....             text  'I/O error. Failed saving file: '
0256                       even
0257               
0258               txt.io.nofile
0259 35FA 2149             byte  33
0260 35FB ....             text  'I/O error. No filename specified.'
0261                       even
0262               
0263               
0264               
0265               ;--------------------------------------------------------------
0266               ; Strings for command buffer
0267               ;--------------------------------------------------------------
0268               txt.cmdb.title
0269 361C 0E43             byte  14
0270 361D ....             text  'Command buffer'
0271                       even
0272               
0273               txt.cmdb.prompt
0274 362C 013E             byte  1
0275 362D ....             text  '>'
0276                       even
0277               
0278               
0279 362E 0C0A     txt.stevie         byte    12
0280                                  byte    10
0281 3630 ....                        text    'stevie v1.00'
0282 363C 0B00                        byte    11
0283                                  even
0284               
0285               txt.colorscheme
0286 363E 0E43             byte  14
0287 363F ....             text  'Color scheme: '
0288                       even
0289               
0290               
**** **** ****     > stevie_b1.asm.2405726
0083                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
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
0013      0C00     key.fctn.6    equ >0c00             ; fctn + 6
0014      0100     key.fctn.7    equ >0100             ; fctn + 7
0015      0600     key.fctn.8    equ >0600             ; fctn + 8
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
0105 364E 0866             byte  8
0106 364F ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 3658 0866             byte  8
0111 3659 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 3662 0866             byte  8
0116 3663 ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 366C 0866             byte  8
0121 366D ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 3676 0866             byte  8
0126 3677 ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 3680 0866             byte  8
0131 3681 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 368A 0866             byte  8
0136 368B ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 3694 0866             byte  8
0141 3695 ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 369E 0866             byte  8
0146 369F ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 36A8 0866             byte  8
0151 36A9 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 36B2 0866             byte  8
0156 36B3 ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 36BC 0866             byte  8
0161 36BD ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 36C6 0866             byte  8
0166 36C7 ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 36D0 0866             byte  8
0171 36D1 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 36DA 0866             byte  8
0176 36DB ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 36E4 0866             byte  8
0181 36E5 ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 36EE 0866             byte  8
0186 36EF ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 36F8 0866             byte  8
0191 36F9 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 3702 0866             byte  8
0196 3703 ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 370C 0866             byte  8
0201 370D ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 3716 0866             byte  8
0206 3717 ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 3720 0866             byte  8
0211 3721 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 372A 0866             byte  8
0216 372B ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 3734 0866             byte  8
0221 3735 ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 373E 0866             byte  8
0226 373F ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 3748 0866             byte  8
0231 3749 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 3752 0866             byte  8
0236 3753 ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 375C 0866             byte  8
0241 375D ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 3766 0866             byte  8
0246 3767 ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 3770 0866             byte  8
0251 3771 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 377A 0866             byte  8
0256 377B ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 3784 0866             byte  8
0261 3785 ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 378E 0866             byte  8
0266 378F ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 3798 0866             byte  8
0271 3799 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 37A2 0866             byte  8
0276 37A3 ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 37AC 0866             byte  8
0281 37AD ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 37B6 0866             byte  8
0289 37B7 ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 37C0 0866             byte  8
0294 37C1 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 37CA 0863             byte  8
0300 37CB ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 37D4 0863             byte  8
0305 37D5 ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 37DE 0863             byte  8
0313 37DF ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 37E8 0863             byte  8
0318 37E9 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 37F2 0863             byte  8
0323 37F3 ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 37FC 0863             byte  8
0328 37FD ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 3806 0863             byte  8
0333 3807 ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 3810 0863             byte  8
0338 3811 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 381A 0863             byte  8
0343 381B ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 3824 0863             byte  8
0348 3825 ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 382E 0863             byte  8
0353 382F ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 3838 0863             byte  8
0358 3839 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 3842 0863             byte  8
0363 3843 ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 384C 0863             byte  8
0368 384D ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 3856 0863             byte  8
0373 3857 ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 3860 0863             byte  8
0378 3861 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 386A 0863             byte  8
0383 386B ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 3874 0863             byte  8
0388 3875 ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 387E 0863             byte  8
0393 387F ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 3888 0863             byte  8
0398 3889 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 3892 0863             byte  8
0403 3893 ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 389C 0863             byte  8
0408 389D ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 38A6 0863             byte  8
0413 38A7 ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 38B0 0863             byte  8
0418 38B1 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 38BA 0863             byte  8
0423 38BB ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 38C4 0863             byte  8
0428 38C5 ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 38CE 0863             byte  8
0433 38CF ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 38D8 0863             byte  8
0438 38D9 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 38E2 0863             byte  8
0443 38E3 ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 38EC 0863             byte  8
0448 38ED ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 38F6 0863             byte  8
0453 38F7 ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 3900 0863             byte  8
0458 3901 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 390A 0863             byte  8
0463 390B ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 3914 0863             byte  8
0468 3915 ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 391E 0863             byte  8
0473 391F ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 3928 0863             byte  8
0478 3929 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 3932 0863             byte  8
0483 3933 ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 393C 0863             byte  8
0488 393D ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 3946 0863             byte  8
0496 3947 ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 3950 0565             byte  5
0504 3951 ....             text  'enter'
0505                       even
0506               
**** **** ****     > stevie_b1.asm.2405726
0084                       ;------------------------------------------------------
0085                       ; End of File marker
0086                       ;------------------------------------------------------
0087 3956 DEAD             data  >dead,>beef,>dead,>beef
     3958 BEEF 
     395A DEAD 
     395C BEEF 
0089               ***************************************************************
0090               * Step 4: Include main editor modules
0091               ********|*****|*********************|**************************
0092               main:
0093                       aorg  kickstart.code2       ; >6036
0094 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0095                       ;-----------------------------------------------------------------------
0096                       ; Include files
0097                       ;-----------------------------------------------------------------------
0098                       copy  "main.asm"            ; Main file (entrypoint)
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
     6046 2660 
0042               
0043 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2704 
0044 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 2340 
0045 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 2340 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 2340 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 229C 
0056 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6068 06A0  32         bl    @film
     606A 2244 
0061 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0062                       ;------------------------------------------------------
0063                       ; Setup SAMS windows
0064                       ;------------------------------------------------------
0065 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 68A8 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 2680 
0070 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 2690 
0071               
0072 607E 06A0  32         bl    @cpym2m
     6080 24AC 
0073 6082 308E                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F54 
     6086 0004 
0074               
0075 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3090 
     608C A014 
0076                                                   ; Save cursor shape & color
0077               
0078 608E 06A0  32         bl    @cpym2v
     6090 2458 
0079 6092 2800                   data sprpdt,cursors,3*8
     6094 3092 
     6096 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 6098 06A0  32         bl    @cpym2v
     609A 2458 
0083 609C 1008                   data >1008,patterns,16*8
     609E 30AA 
     60A0 0080 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 686E 
0089 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 688C 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 7950 
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
     60B8 26A0 
0102 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60BC 0204  20         li    tmp0,timers
     60BE 2F44 
0105 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0106               
0107 60C4 06A0  32         bl    @mkslot
     60C6 2DD4 
0108 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 76CA 
0109 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 7790 
0110 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 77C4 
0111 60D4 032F                   data >032f,task.oneshot      ; Task 3 - One shot task
     60D6 7812 
0112 60D8 FFFF                   data eol
0113               
0114 60DA 06A0  32         bl    @mkhook
     60DC 2DC0 
0115 60DE 768C                   data hook.keyscan     ; Setup user hook
0116               
0117 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D16 
**** **** ****     > stevie_b1.asm.2405726
0099                       ;-----------------------------------------------------------------------
0100                       ; Keyboard actions
0101                       ;-----------------------------------------------------------------------
0102                       copy  "edkey.key.process.asm"
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
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
     60F0 A01C 
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
     6108 7F00 
0033 610A 1003  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7F9E 
0039 6110 1600  14         jne   edkey.key.check.next
0040                       ;-------------------------------------------------------
0041                       ; Iterate over keyboard map for matching action key
0042                       ;-------------------------------------------------------
0043               edkey.key.check.next:
0044 6112 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0045 6114 1319  14         jeq   edkey.key.process.addbuffer
0046                                                   ; Yes, means no action key pressed, so
0047                                                   ; add character to buffer
0048                       ;-------------------------------------------------------
0049                       ; Check for action key match
0050                       ;-------------------------------------------------------
0051 6116 8585  30         c     tmp1,*tmp2            ; Action key matched?
0052 6118 1303  14         jeq   edkey.key.check.scope
0053                                                   ; Yes, check scope
0054 611A 0226  22         ai    tmp2,6                ; Skip current entry
     611C 0006 
0055 611E 10F9  14         jmp   edkey.key.check.next  ; Check next entry
0056                       ;-------------------------------------------------------
0057                       ; Check scope of key
0058                       ;-------------------------------------------------------
0059               edkey.key.check.scope:
0060 6120 05C6  14         inct  tmp2                  ; Move to scope
0061 6122 8816  46         c     *tmp2,@tv.pane.focus  ; (1) Process key if scope matches pane
     6124 A01C 
0062 6126 1306  14         jeq   edkey.key.process.action
0063               
0064 6128 8816  46         c     *tmp2,@cmdb.dialog    ; (2) Process key if scope matches dialog
     612A A31A 
0065 612C 1303  14         jeq   edkey.key.process.action
0066                       ;-------------------------------------------------------
0067                       ; Key pressed outside valid scope, ignore action entry
0068                       ;-------------------------------------------------------
0069 612E 0226  22         ai    tmp2,4                ; Skip current entry
     6130 0004 
0070 6132 10EF  14         jmp   edkey.key.check.next  ; Process next action entry
0071                       ;-------------------------------------------------------
0072                       ; Trigger keyboard action
0073                       ;-------------------------------------------------------
0074               edkey.key.process.action:
0075 6134 05C6  14         inct  tmp2                  ; Move to action address
0076 6136 C196  26         mov   *tmp2,tmp2            ; Get action address
0077               
0078 6138 0204  20         li    tmp0,id.dialog.unsaved
     613A 0065 
0079 613C 8120  34         c     @cmdb.dialog,tmp0
     613E A31A 
0080 6140 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0081               
0082 6142 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6144 A322 
0083 6146 0456  20 !       b     *tmp2                 ; Process key action
0084                       ;-------------------------------------------------------
0085                       ; Add character to editor or cmdb buffer
0086                       ;-------------------------------------------------------
0087               edkey.key.process.addbuffer:
0088 6148 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     614A A01C 
0089 614C 1602  14         jne   !                     ; No, skip frame buffer
0090 614E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6150 6670 
0091                       ;-------------------------------------------------------
0092                       ; CMDB buffer
0093                       ;-------------------------------------------------------
0094 6152 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6154 0001 
0095 6156 1607  14         jne   edkey.key.process.crash
0096                                                   ; No, crash
0097                       ;-------------------------------------------------------
0098                       ; Don't add character if dialog has ID > 100
0099                       ;-------------------------------------------------------
0100 6158 C120  34         mov   @cmdb.dialog,tmp0
     615A A31A 
0101 615C 0284  22         ci    tmp0,100
     615E 0064 
0102 6160 1506  14         jgt   edkey.key.process.exit
0103                       ;-------------------------------------------------------
0104                       ; Add character to CMDB
0105                       ;-------------------------------------------------------
0106 6162 0460  28         b     @edkey.action.cmdb.char
     6164 677E 
0107                                                   ; Add character to CMDB buffer
0108                       ;-------------------------------------------------------
0109                       ; Crash
0110                       ;-------------------------------------------------------
0111               edkey.key.process.crash:
0112 6166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6168 FFCE 
0113 616A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     616C 2030 
0114                       ;-------------------------------------------------------
0115                       ; Exit
0116                       ;-------------------------------------------------------
0117               edkey.key.process.exit:
0118 616E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6170 76BE 
**** **** ****     > stevie_b1.asm.2405726
0103                                                   ; Process keyboard actions
0104                       ;-----------------------------------------------------------------------
0105                       ; Keyboard actions - Framebuffer
0106                       ;-----------------------------------------------------------------------
0107                       copy  "edkey.fb.mov.leftright.asm"
**** **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6172 C120  34         mov   @fb.column,tmp0
     6174 A10C 
0010 6176 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6178 0620  34         dec   @fb.column            ; Column-- in screen buffer
     617A A10C 
0015 617C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     617E 832A 
0016 6180 0620  34         dec   @fb.current
     6182 A102 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6184 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6186 76BE 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6188 8820  54         c     @fb.column,@fb.row.length
     618A A10C 
     618C A108 
0028 618E 1406  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6190 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6192 A10C 
0033 6194 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6196 832A 
0034 6198 05A0  34         inc   @fb.current
     619A A102 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 619C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     619E 76BE 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor beginning of line
0043               *---------------------------------------------------------------
0044               edkey.action.home:
0045 61A0 C120  34         mov   @wyx,tmp0
     61A2 832A 
0046 61A4 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     61A6 FF00 
0047 61A8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     61AA 832A 
0048 61AC 04E0  34         clr   @fb.column
     61AE A10C 
0049 61B0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61B2 6924 
0050 61B4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61B6 76BE 
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.end:
0056 61B8 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     61BA A108 
0057 61BC 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     61BE 0050 
0058 61C0 1102  14         jlt   !                     ; | is right of last character on line,
0059 61C2 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     61C4 004F 
0060                       ;-------------------------------------------------------
0061                       ; Set cursor X position
0062                       ;-------------------------------------------------------
0063 61C6 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     61C8 A10C 
0064 61CA 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     61CC 26B8 
0065 61CE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61D0 6924 
0066 61D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61D4 76BE 
**** **** ****     > stevie_b1.asm.2405726
0108                                                        ; Move left / right / home / end
0109                       copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor beginning of word or previous word
0007               *---------------------------------------------------------------
0008               edkey.action.pword:
0009 61D6 C120  34         mov   @fb.column,tmp0
     61D8 A10C 
0010 61DA 1324  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 61DC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     61DE A102 
0015 61E0 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 61E2 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 61E4 0605  14         dec   tmp1
0022 61E6 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 61E8 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 61EA D195  26         movb  *tmp1,tmp2            ; Get character
0030 61EC 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 61EE D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 61F0 0986  56         srl   tmp2,8                ; Right justify
0033 61F2 0286  22         ci    tmp2,32               ; Space character found?
     61F4 0020 
0034 61F6 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 61F8 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     61FA 2020 
0040 61FC 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 61FE 0287  22         ci    tmp3,>20ff            ; First character is space
     6200 20FF 
0043 6202 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 6204 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     6206 A10C 
0048 6208 61C4  18         s     tmp0,tmp3
0049 620A 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     620C 0002 
0050 620E 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 6210 0585  14         inc   tmp1
0056 6212 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 6214 C805  38         mov   tmp1,@fb.current
     6216 A102 
0062 6218 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     621A A10C 
0063 621C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     621E 26B8 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.pword.exit:
0068 6220 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6222 6924 
0069 6224 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6226 76BE 
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Cursor next word
0075               *---------------------------------------------------------------
0076               edkey.action.nword:
0077 6228 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 622A C120  34         mov   @fb.column,tmp0
     622C A10C 
0079 622E 8804  38         c     tmp0,@fb.row.length
     6230 A108 
0080 6232 1428  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 6234 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     6236 A102 
0085 6238 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 623A 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 623C 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 623E 0585  14         inc   tmp1
0097 6240 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6242 8804  38         c     tmp0,@fb.row.length
     6244 A108 
0099 6246 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6248 D195  26         movb  *tmp1,tmp2            ; Get character
0106 624A 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 624C D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 624E 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6250 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6252 FFFF 
0111 6254 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6256 0286  22         ci    tmp2,32
     6258 0020 
0117 625A 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 625C 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 625E 0286  22         ci    tmp2,32               ; Space character found?
     6260 0020 
0125 6262 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6264 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6266 2020 
0131 6268 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 626A 0287  22         ci    tmp3,>20ff            ; First characer is space?
     626C 20FF 
0134 626E 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6270 0585  14         inc   tmp1
0139 6272 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6274 C805  38         mov   tmp1,@fb.current
     6276 A102 
0145 6278 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     627A A10C 
0146 627C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     627E 26B8 
0147                       ;-------------------------------------------------------
0148                       ; Exit
0149                       ;-------------------------------------------------------
0150               edkey.action.nword.exit:
0151 6280 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6282 6924 
0152 6284 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6286 76BE 
0153               
0154               
**** **** ****     > stevie_b1.asm.2405726
0110                       copy  "edkey.fb.mov.updown.asm"  ; Move line up / down
**** **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor up
0007               *---------------------------------------------------------------
0008               edkey.action.up:
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 6288 8820  54         c     @fb.row.dirty,@w$ffff
     628A A10A 
     628C 202C 
0013 628E 1604  14         jne   edkey.action.up.cursor
0014 6290 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6292 6CA6 
0015 6294 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6296 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Move cursor
0018                       ;-------------------------------------------------------
0019               edkey.action.up.cursor:
0020 6298 C120  34         mov   @fb.row,tmp0
     629A A106 
0021 629C 1509  14         jgt   edkey.action.up.cursor_up
0022                                                   ; Move cursor up if fb.row > 0
0023 629E C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     62A0 A104 
0024 62A2 130A  14         jeq   edkey.action.up.set_cursorx
0025                                                   ; At top, only position cursor X
0026                       ;-------------------------------------------------------
0027                       ; Scroll 1 line
0028                       ;-------------------------------------------------------
0029 62A4 0604  14         dec   tmp0                  ; fb.topline--
0030 62A6 C804  38         mov   tmp0,@parm1
     62A8 2F20 
0031 62AA 06A0  32         bl    @fb.refresh           ; Scroll one line up
     62AC 6994 
0032 62AE 1004  14         jmp   edkey.action.up.set_cursorx
0033                       ;-------------------------------------------------------
0034                       ; Move cursor up
0035                       ;-------------------------------------------------------
0036               edkey.action.up.cursor_up:
0037 62B0 0620  34         dec   @fb.row               ; Row-- in screen buffer
     62B2 A106 
0038 62B4 06A0  32         bl    @up                   ; Row-- VDP cursor
     62B6 26AE 
0039                       ;-------------------------------------------------------
0040                       ; Check line length and position cursor
0041                       ;-------------------------------------------------------
0042               edkey.action.up.set_cursorx:
0043 62B8 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     62BA 6E8C 
0044                                                   ; | i  @fb.row        = Row in frame buffer
0045                                                   ; / o  @fb.row.length = Length of row
0046               
0047 62BC 8820  54         c     @fb.column,@fb.row.length
     62BE A10C 
     62C0 A108 
0048 62C2 1207  14         jle   edkey.action.up.exit
0049                       ;-------------------------------------------------------
0050                       ; Adjust cursor column position
0051                       ;-------------------------------------------------------
0052 62C4 C820  54         mov   @fb.row.length,@fb.column
     62C6 A108 
     62C8 A10C 
0053 62CA C120  34         mov   @fb.column,tmp0
     62CC A10C 
0054 62CE 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62D0 26B8 
0055                       ;-------------------------------------------------------
0056                       ; Exit
0057                       ;-------------------------------------------------------
0058               edkey.action.up.exit:
0059 62D2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62D4 6924 
0060 62D6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     62D8 76BE 
0061               
0062               
0063               
0064               *---------------------------------------------------------------
0065               * Cursor down
0066               *---------------------------------------------------------------
0067               edkey.action.down:
0068 62DA 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     62DC A106 
     62DE A204 
0069 62E0 1330  14         jeq   !                     ; Yes, skip further processing
0070                       ;-------------------------------------------------------
0071                       ; Crunch current row if dirty
0072                       ;-------------------------------------------------------
0073 62E2 8820  54         c     @fb.row.dirty,@w$ffff
     62E4 A10A 
     62E6 202C 
0074 62E8 1604  14         jne   edkey.action.down.move
0075 62EA 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     62EC 6CA6 
0076 62EE 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     62F0 A10A 
0077                       ;-------------------------------------------------------
0078                       ; Move cursor
0079                       ;-------------------------------------------------------
0080               edkey.action.down.move:
0081                       ;-------------------------------------------------------
0082                       ; EOF reached?
0083                       ;-------------------------------------------------------
0084 62F2 C120  34         mov   @fb.topline,tmp0
     62F4 A104 
0085 62F6 A120  34         a     @fb.row,tmp0
     62F8 A106 
0086 62FA 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     62FC A204 
0087 62FE 1312  14         jeq   edkey.action.down.set_cursorx
0088                                                   ; Yes, only position cursor X
0089                       ;-------------------------------------------------------
0090                       ; Check if scrolling required
0091                       ;-------------------------------------------------------
0092 6300 C120  34         mov   @fb.scrrows,tmp0
     6302 A118 
0093 6304 0604  14         dec   tmp0
0094 6306 8120  34         c     @fb.row,tmp0
     6308 A106 
0095 630A 1108  14         jlt   edkey.action.down.cursor
0096                       ;-------------------------------------------------------
0097                       ; Scroll 1 line
0098                       ;-------------------------------------------------------
0099 630C C820  54         mov   @fb.topline,@parm1
     630E A104 
     6310 2F20 
0100 6312 05A0  34         inc   @parm1
     6314 2F20 
0101 6316 06A0  32         bl    @fb.refresh
     6318 6994 
0102 631A 1004  14         jmp   edkey.action.down.set_cursorx
0103                       ;-------------------------------------------------------
0104                       ; Move cursor down a row, there are still rows left
0105                       ;-------------------------------------------------------
0106               edkey.action.down.cursor:
0107 631C 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     631E A106 
0108 6320 06A0  32         bl    @down                 ; Row++ VDP cursor
     6322 26A6 
0109                       ;-------------------------------------------------------
0110                       ; Check line length and position cursor
0111                       ;-------------------------------------------------------
0112               edkey.action.down.set_cursorx:
0113 6324 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6326 6E8C 
0114                                                   ; | i  @fb.row        = Row in frame buffer
0115                                                   ; / o  @fb.row.length = Length of row
0116               
0117 6328 8820  54         c     @fb.column,@fb.row.length
     632A A10C 
     632C A108 
0118 632E 1207  14         jle   edkey.action.down.exit
0119                                                   ; Exit
0120                       ;-------------------------------------------------------
0121                       ; Adjust cursor column position
0122                       ;-------------------------------------------------------
0123 6330 C820  54         mov   @fb.row.length,@fb.column
     6332 A108 
     6334 A10C 
0124 6336 C120  34         mov   @fb.column,tmp0
     6338 A10C 
0125 633A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     633C 26B8 
0126                       ;-------------------------------------------------------
0127                       ; Exit
0128                       ;-------------------------------------------------------
0129               edkey.action.down.exit:
0130 633E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6340 6924 
0131 6342 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6344 76BE 
**** **** ****     > stevie_b1.asm.2405726
0111                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Previous page
0007               *---------------------------------------------------------------
0008               edkey.action.ppage:
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 6346 8820  54         c     @fb.row.dirty,@w$ffff
     6348 A10A 
     634A 202C 
0013 634C 1604  14         jne   edkey.action.ppage.sanity
0014 634E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6350 6CA6 
0015 6352 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6354 A10A 
0016                       ;-------------------------------------------------------
0017                       ; Sanity check
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 6356 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6358 A104 
0021 635A 130D  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 635C 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     635E A118 
0026 6360 1503  14         jgt   edkey.action.ppage.topline
0027 6362 04E0  34         clr   @fb.topline           ; topline = 0
     6364 A104 
0028 6366 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 6368 6820  54         s     @fb.scrrows,@fb.topline
     636A A118 
     636C A104 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 636E C820  54         mov   @fb.topline,@parm1
     6370 A104 
     6372 2F20 
0039               
0040 6374 101B  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0041                                                   ; / i  @parm1 = Line in editor buffer
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               edkey.action.ppage.exit:
0046 6376 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6378 76BE 
0047               
0048               
0049               
0050               
0051               *---------------------------------------------------------------
0052               * Next page
0053               *---------------------------------------------------------------
0054               edkey.action.npage:
0055                       ;-------------------------------------------------------
0056                       ; Crunch current row if dirty
0057                       ;-------------------------------------------------------
0058 637A 8820  54         c     @fb.row.dirty,@w$ffff
     637C A10A 
     637E 202C 
0059 6380 1604  14         jne   edkey.action.npage.sanity
0060 6382 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6384 6CA6 
0061 6386 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6388 A10A 
0062                       ;-------------------------------------------------------
0063                       ; Sanity check
0064                       ;-------------------------------------------------------
0065               edkey.action.npage.sanity:
0066 638A C120  34         mov   @fb.topline,tmp0
     638C A104 
0067 638E A120  34         a     @fb.scrrows,tmp0
     6390 A118 
0068 6392 0584  14         inc   tmp0                  ; Base 1 offset !
0069 6394 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6396 A204 
0070 6398 1507  14         jgt   edkey.action.npage.exit
0071                       ;-------------------------------------------------------
0072                       ; Adjust topline
0073                       ;-------------------------------------------------------
0074               edkey.action.npage.topline:
0075 639A A820  54         a     @fb.scrrows,@fb.topline
     639C A118 
     639E A104 
0076                       ;-------------------------------------------------------
0077                       ; Refresh page
0078                       ;-------------------------------------------------------
0079               edkey.action.npage.refresh:
0080 63A0 C820  54         mov   @fb.topline,@parm1
     63A2 A104 
     63A4 2F20 
0081               
0082 63A6 1002  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0083                                                   ; / i  @parm1 = Line in editor buffer
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               edkey.action.npage.exit:
0088 63A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63AA 76BE 
**** **** ****     > stevie_b1.asm.2405726
0112                       copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
**** **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
0003               
0004               ***************************************************************
0005               * _edkey.goto.fb.toprow
0006               *
0007               * Position cursor on first row in frame buffer and
0008               * align variables in editor buffer to match with that position.
0009               *
0010               * Internal method that needs to be called via jmp or branch
0011               * instruction.
0012               ***************************************************************
0013               * b    _edkey.goto.fb.toprow
0014               * jmp  _edkey.goto.fb.toprow
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @parm1  = Line in editor buffer to display as top row (goto)
0018               *
0019               * Register usage
0020               * none
0021               *--------------------------------------------------------------
0022               *  Remarks
0023               *  Private, only to be called from inside edkey submodules
0024               ********|*****|*********************|**************************
0025               _edkey.goto.fb.toprow:
0026 63AC 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63AE 6994 
0027                                                   ; | i  @parm1 = Line to start with
0028                                                   ; /             (becomes @fb.topline)
0029               
0030 63B0 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B2 A106 
0031 63B4 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B6 A10C 
0032 63B8 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63BA 832A 
0033               
0034 63BC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BE 6924 
0035               
0036 63C0 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63C2 6E8C 
0037                                                   ; | i  @fb.row        = Row in frame buffer
0038                                                   ; / o  @fb.row.length = Length of row
0039               
0040 63C4 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C6 76BE 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Goto top of file
0045               *---------------------------------------------------------------
0046               edkey.action.top:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current row if dirty
0049                       ;-------------------------------------------------------
0050 63C8 8820  54         c     @fb.row.dirty,@w$ffff
     63CA A10A 
     63CC 202C 
0051 63CE 1604  14         jne   edkey.action.top.refresh
0052 63D0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63D2 6CA6 
0053 63D4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D6 A10A 
0054                       ;-------------------------------------------------------
0055                       ; Refresh page
0056                       ;-------------------------------------------------------
0057               edkey.action.top.refresh:
0058 63D8 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63DA 2F20 
0059               
0060 63DC 10E7  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0061                                                   ; / i  @parm1 = Line in editor buffer
0062               
0063               
0064               
0065               
0066               *---------------------------------------------------------------
0067               * Goto bottom of file
0068               *---------------------------------------------------------------
0069               edkey.action.bot:
0070                       ;-------------------------------------------------------
0071                       ; Crunch current row if dirty
0072                       ;-------------------------------------------------------
0073 63DE 8820  54         c     @fb.row.dirty,@w$ffff
     63E0 A10A 
     63E2 202C 
0074 63E4 1604  14         jne   edkey.action.bot.refresh
0075 63E6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63E8 6CA6 
0076 63EA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63EC A10A 
0077                       ;-------------------------------------------------------
0078                       ; Refresh page
0079                       ;-------------------------------------------------------
0080               edkey.action.bot.refresh:
0081 63EE 8820  54         c     @edb.lines,@fb.scrrows
     63F0 A204 
     63F2 A118 
0082 63F4 1207  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0083               
0084 63F6 C120  34         mov   @edb.lines,tmp0
     63F8 A204 
0085 63FA 6120  34         s     @fb.scrrows,tmp0
     63FC A118 
0086 63FE C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6400 2F20 
0087               
0088 6402 10D4  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0089                                                   ; / i  @parm1 = Line in editor buffer
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.bot.exit:
0094 6404 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6406 76BE 
**** **** ****     > stevie_b1.asm.2405726
0113                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 6408 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     640A A206 
0010 640C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     640E 6924 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1 - Empty line
0013                       ;-------------------------------------------------------
0014               edkey.action.del_char.sanity1:
0015 6410 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6412 A108 
0016 6414 1336  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018               
0019 6416 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6418 A102 
0020                       ;-------------------------------------------------------
0021                       ; Sanity check 2 - Already at EOL
0022                       ;-------------------------------------------------------
0023               edkey.action.del_char.sanity2:
0024 641A C1C6  18         mov   tmp2,tmp3             ; \
0025 641C 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0026 641E 81E0  34         c     @fb.column,tmp3
     6420 A10C 
0027 6422 110A  14         jlt   edkey.action.del_char.sanity3
0028               
0029                       ;------------------------------------------------------
0030                       ; At EOL - clear current character
0031                       ;------------------------------------------------------
0032 6424 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0033 6426 D505  30         movb  tmp1,*tmp0            ; /
0034 6428 C820  54         mov   @fb.column,@fb.row.length
     642A A10C 
     642C A108 
0035                                                   ; Row length - 1
0036 642E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6430 A10A 
0037 6432 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6434 A116 
0038 6436 1025  14         jmp  edkey.action.del_char.exit
0039                       ;-------------------------------------------------------
0040                       ; Sanity check 3 - Abort if row length > 80
0041                       ;-------------------------------------------------------
0042               edkey.action.del_char.sanity3:
0043 6438 0286  22         ci    tmp2,colrow
     643A 0050 
0044 643C 1204  14         jle   edkey.action.del_char.prep
0045                                                   ; Continue if row length <= 80
0046                       ;-----------------------------------------------------------------------
0047                       ; CPU crash
0048                       ;-----------------------------------------------------------------------
0049 643E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6440 FFCE 
0050 6442 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6444 2030 
0051                       ;-------------------------------------------------------
0052                       ; Calculate number of characters to move
0053                       ;-------------------------------------------------------
0054               edkey.action.del_char.prep:
0055 6446 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0056 6448 61E0  34         s     @fb.column,tmp3
     644A A10C 
0057 644C 0607  14         dec   tmp3                  ; Remove base 1 offset
0058 644E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0059 6450 C144  18         mov   tmp0,tmp1
0060 6452 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0061 6454 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6456 A10C 
0062                       ;-------------------------------------------------------
0063                       ; Setup pointers
0064                       ;-------------------------------------------------------
0065 6458 C120  34         mov   @fb.current,tmp0      ; Get pointer
     645A A102 
0066 645C C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0067 645E 0585  14         inc   tmp1                  ; / tmp1 = Next character
0068                       ;-------------------------------------------------------
0069                       ; Loop from current character until end of line
0070                       ;-------------------------------------------------------
0071               edkey.action.del_char.loop:
0072 6460 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0073 6462 0606  14         dec   tmp2
0074 6464 16FD  14         jne   edkey.action.del_char.loop
0075                       ;-------------------------------------------------------
0076                       ; Special treatment if line 80 characters long
0077                       ;-------------------------------------------------------
0078 6466 0206  20         li    tmp2,colrow
     6468 0050 
0079 646A 81A0  34         c     @fb.row.length,tmp2
     646C A108 
0080 646E 1603  14         jne   edkey.action.del_char.save
0081 6470 0604  14         dec   tmp0                  ; One time adjustment
0082 6472 04C5  14         clr   tmp1
0083 6474 D505  30         movb  tmp1,*tmp0            ; Write >00 character
0084                       ;-------------------------------------------------------
0085                       ; Save variables
0086                       ;-------------------------------------------------------
0087               edkey.action.del_char.save:
0088 6476 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6478 A10A 
0089 647A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     647C A116 
0090 647E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6480 A108 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.del_char.exit:
0095 6482 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6484 76BE 
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Delete until end of line
0100               *---------------------------------------------------------------
0101               edkey.action.del_eol:
0102 6486 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6488 A206 
0103 648A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     648C 6924 
0104 648E C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6490 A108 
0105 6492 1311  14         jeq   edkey.action.del_eol.exit
0106                                                   ; Exit if empty line
0107                       ;-------------------------------------------------------
0108                       ; Prepare for erase operation
0109                       ;-------------------------------------------------------
0110 6494 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6496 A102 
0111 6498 C1A0  34         mov   @fb.colsline,tmp2
     649A A10E 
0112 649C 61A0  34         s     @fb.column,tmp2
     649E A10C 
0113 64A0 04C5  14         clr   tmp1
0114                       ;-------------------------------------------------------
0115                       ; Loop until last column in frame buffer
0116                       ;-------------------------------------------------------
0117               edkey.action.del_eol_loop:
0118 64A2 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0119 64A4 0606  14         dec   tmp2
0120 64A6 16FD  14         jne   edkey.action.del_eol_loop
0121                       ;-------------------------------------------------------
0122                       ; Save variables
0123                       ;-------------------------------------------------------
0124 64A8 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     64AA A10A 
0125 64AC 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64AE A116 
0126               
0127 64B0 C820  54         mov   @fb.column,@fb.row.length
     64B2 A10C 
     64B4 A108 
0128                                                   ; Set new row length
0129                       ;-------------------------------------------------------
0130                       ; Exit
0131                       ;-------------------------------------------------------
0132               edkey.action.del_eol.exit:
0133 64B6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     64B8 76BE 
0134               
0135               
0136               *---------------------------------------------------------------
0137               * Delete current line
0138               *---------------------------------------------------------------
0139               edkey.action.del_line:
0140 64BA 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64BC A206 
0141                       ;-------------------------------------------------------
0142                       ; Special treatment if only 1 line in editor buffer
0143                       ;-------------------------------------------------------
0144 64BE C120  34          mov   @edb.lines,tmp0      ; \
     64C0 A204 
0145 64C2 0284  22          ci    tmp0,1               ; /  Only a single line?
     64C4 0001 
0146 64C6 1323  14          jeq   edkey.action.del_line.1stline
0147                                                   ; Yes, handle single line and exit
0148                       ;-------------------------------------------------------
0149                       ; Delete entry in index
0150                       ;-------------------------------------------------------
0151 64C8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64CA 6924 
0152               
0153 64CC 04E0  34         clr   @fb.row.dirty         ; Discard current line
     64CE A10A 
0154               
0155 64D0 C820  54         mov   @fb.topline,@parm1
     64D2 A104 
     64D4 2F20 
0156 64D6 A820  54         a     @fb.row,@parm1        ; Line number to remove
     64D8 A106 
     64DA 2F20 
0157 64DC C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64DE A204 
     64E0 2F22 
0158               
0159 64E2 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     64E4 6BB4 
0160                                                   ; \ i  @parm1 = Line in editor buffer
0161                                                   ; / i  @parm2 = Last line for index reorg
0162                       ;-------------------------------------------------------
0163                       ; Get length of current row in framebuffer
0164                       ;-------------------------------------------------------
0165 64E6 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     64E8 6E8C 
0166                                                   ; \ i  @fb.row        = Current row
0167                                                   ; / o  @fb.row.length = Length of row
0168                       ;-------------------------------------------------------
0169                       ; Refresh frame buffer and physical screen
0170                       ;-------------------------------------------------------
0171 64EA 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64EC A204 
0172 64EE C820  54         mov   @fb.topline,@parm1
     64F0 A104 
     64F2 2F20 
0173 64F4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64F6 6994 
0174 64F8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64FA A116 
0175                       ;-------------------------------------------------------
0176                       ; Special treatment if current line was last line
0177                       ;-------------------------------------------------------
0178 64FC C120  34         mov   @fb.topline,tmp0
     64FE A104 
0179 6500 A120  34         a     @fb.row,tmp0
     6502 A106 
0180 6504 8804  38         c     tmp0,@edb.lines       ; Was last line?
     6506 A204 
0181 6508 1112  14         jlt   edkey.action.del_line.exit
0182 650A 0460  28         b     @edkey.action.up      ; One line up
     650C 6288 
0183                       ;-------------------------------------------------------
0184                       ; Special treatment if only 1 line in editor buffer
0185                       ;-------------------------------------------------------
0186               edkey.action.del_line.1stline:
0187 650E 04E0  34         clr   @fb.column            ; Column 0
     6510 A10C 
0188 6512 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6514 6924 
0189               
0190 6516 04E0  34         clr   @fb.row.dirty         ; Discard current line
     6518 A10A 
0191 651A 04E0  34         clr   @parm1
     651C 2F20 
0192 651E 04E0  34         clr   @parm2
     6520 2F22 
0193               
0194 6522 06A0  32         bl    @idx.entry.delete     ; Delete entry in index
     6524 6BB4 
0195                                                   ; \ i  @parm1 = Line in editor buffer
0196                                                   ; / i  @parm2 = Last line for index reorg
0197               
0198 6526 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6528 6994 
0199 652A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     652C A116 
0200                       ;-------------------------------------------------------
0201                       ; Exit
0202                       ;-------------------------------------------------------
0203               edkey.action.del_line.exit:
0204 652E 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6530 61A0 
**** **** ****     > stevie_b1.asm.2405726
0114                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
**** **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Insert character
0007               *
0008               * @parm1 = high byte has character to insert
0009               *---------------------------------------------------------------
0010               edkey.action.ins_char.ws:
0011 6532 0204  20         li    tmp0,>2000            ; White space
     6534 2000 
0012 6536 C804  38         mov   tmp0,@parm1
     6538 2F20 
0013               edkey.action.ins_char:
0014 653A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     653C A206 
0015 653E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6540 6924 
0016                       ;-------------------------------------------------------
0017                       ; Sanity check 1 - Empty line
0018                       ;-------------------------------------------------------
0019 6542 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6544 A102 
0020 6546 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6548 A108 
0021 654A 132C  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Sanity check 2 - EOL
0025                       ;-------------------------------------------------------
0026 654C 8820  54         c     @fb.column,@fb.row.length
     654E A10C 
     6550 A108 
0027 6552 1328  14         jeq   edkey.action.ins_char.append
0028                                                   ; Add character in append mode
0029                       ;-------------------------------------------------------
0030                       ; Sanity check 3 - Overwrite if at column 80
0031                       ;-------------------------------------------------------
0032 6554 C160  34         mov   @fb.column,tmp1
     6556 A10C 
0033 6558 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     655A 004F 
0034 655C 1102  14         jlt   !
0035 655E 0460  28         b     @edkey.action.char.overwrite
     6560 6692 
0036                       ;-------------------------------------------------------
0037                       ; Sanity check 4 - 80 characters maximum
0038                       ;-------------------------------------------------------
0039 6562 C160  34 !       mov   @fb.row.length,tmp1
     6564 A108 
0040 6566 0285  22         ci    tmp1,colrow
     6568 0050 
0041 656A 1101  14         jlt   edkey.action.ins_char.prep
0042 656C 101D  14         jmp   edkey.action.ins_char.exit
0043                       ;-------------------------------------------------------
0044                       ; Calculate number of characters to move
0045                       ;-------------------------------------------------------
0046               edkey.action.ins_char.prep:
0047 656E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0048 6570 61E0  34         s     @fb.column,tmp3
     6572 A10C 
0049 6574 0607  14         dec   tmp3                  ; Remove base 1 offset
0050 6576 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0051 6578 C144  18         mov   tmp0,tmp1
0052 657A 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0053 657C 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     657E A10C 
0054                       ;-------------------------------------------------------
0055                       ; Loop from end of line until current character
0056                       ;-------------------------------------------------------
0057               edkey.action.ins_char.loop:
0058 6580 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0059 6582 0604  14         dec   tmp0
0060 6584 0605  14         dec   tmp1
0061 6586 0606  14         dec   tmp2
0062 6588 16FB  14         jne   edkey.action.ins_char.loop
0063                       ;-------------------------------------------------------
0064                       ; Insert specified character at current position
0065                       ;-------------------------------------------------------
0066 658A D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     658C 2F20 
0067                       ;-------------------------------------------------------
0068                       ; Save variables and exit
0069                       ;-------------------------------------------------------
0070 658E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6590 A10A 
0071 6592 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6594 A116 
0072 6596 05A0  34         inc   @fb.column
     6598 A10C 
0073 659A 05A0  34         inc   @wyx
     659C 832A 
0074 659E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     65A0 A108 
0075 65A2 1002  14         jmp   edkey.action.ins_char.exit
0076                       ;-------------------------------------------------------
0077                       ; Add character in append mode
0078                       ;-------------------------------------------------------
0079               edkey.action.ins_char.append:
0080 65A4 0460  28         b     @edkey.action.char.overwrite
     65A6 6692 
0081                       ;-------------------------------------------------------
0082                       ; Exit
0083                       ;-------------------------------------------------------
0084               edkey.action.ins_char.exit:
0085 65A8 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     65AA 76BE 
0086               
0087               
0088               
0089               
0090               
0091               
0092               *---------------------------------------------------------------
0093               * Insert new line
0094               *---------------------------------------------------------------
0095               edkey.action.ins_line:
0096 65AC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65AE A206 
0097                       ;-------------------------------------------------------
0098                       ; Crunch current line if dirty
0099                       ;-------------------------------------------------------
0100 65B0 8820  54         c     @fb.row.dirty,@w$ffff
     65B2 A10A 
     65B4 202C 
0101 65B6 1604  14         jne   edkey.action.ins_line.insert
0102 65B8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65BA 6CA6 
0103 65BC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65BE A10A 
0104                       ;-------------------------------------------------------
0105                       ; Insert entry in index
0106                       ;-------------------------------------------------------
0107               edkey.action.ins_line.insert:
0108 65C0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65C2 6924 
0109 65C4 C820  54         mov   @fb.topline,@parm1
     65C6 A104 
     65C8 2F20 
0110 65CA A820  54         a     @fb.row,@parm1        ; Line number to insert
     65CC A106 
     65CE 2F20 
0111 65D0 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     65D2 A204 
     65D4 2F22 
0112               
0113 65D6 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     65D8 6C4E 
0114                                                   ; \ i  parm1 = Line for insert
0115                                                   ; / i  parm2 = Last line to reorg
0116               
0117 65DA 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     65DC A204 
0118                       ;-------------------------------------------------------
0119                       ; Refresh frame buffer and physical screen
0120                       ;-------------------------------------------------------
0121 65DE C820  54         mov   @fb.topline,@parm1
     65E0 A104 
     65E2 2F20 
0122 65E4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     65E6 6994 
0123 65E8 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     65EA A116 
0124                       ;-------------------------------------------------------
0125                       ; Exit
0126                       ;-------------------------------------------------------
0127               edkey.action.ins_line.exit:
0128 65EC 0460  28         b     @edkey.action.home    ; Position cursor at home
     65EE 61A0 
0129               
**** **** ****     > stevie_b1.asm.2405726
0115                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Enter
0007               *---------------------------------------------------------------
0008               edkey.action.enter:
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 65F0 8820  54         c     @fb.row.dirty,@w$ffff
     65F2 A10A 
     65F4 202C 
0013 65F6 1606  14         jne   edkey.action.enter.upd_counter
0014 65F8 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65FA A206 
0015 65FC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65FE 6CA6 
0016 6600 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6602 A10A 
0017                       ;-------------------------------------------------------
0018                       ; Update line counter
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.upd_counter:
0021 6604 C120  34         mov   @fb.topline,tmp0
     6606 A104 
0022 6608 A120  34         a     @fb.row,tmp0
     660A A106 
0023 660C 0584  14         inc   tmp0
0024 660E 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     6610 A204 
0025 6612 1102  14         jlt   edkey.action.newline  ; No, continue newline
0026 6614 05A0  34         inc   @edb.lines            ; Total lines++
     6616 A204 
0027                       ;-------------------------------------------------------
0028                       ; Process newline
0029                       ;-------------------------------------------------------
0030               edkey.action.newline:
0031                       ;-------------------------------------------------------
0032                       ; Scroll 1 line if cursor at bottom row of screen
0033                       ;-------------------------------------------------------
0034 6618 C120  34         mov   @fb.scrrows,tmp0
     661A A118 
0035 661C 0604  14         dec   tmp0
0036 661E 8120  34         c     @fb.row,tmp0
     6620 A106 
0037 6622 110A  14         jlt   edkey.action.newline.down
0038                       ;-------------------------------------------------------
0039                       ; Scroll
0040                       ;-------------------------------------------------------
0041 6624 C120  34         mov   @fb.scrrows,tmp0
     6626 A118 
0042 6628 C820  54         mov   @fb.topline,@parm1
     662A A104 
     662C 2F20 
0043 662E 05A0  34         inc   @parm1
     6630 2F20 
0044 6632 06A0  32         bl    @fb.refresh
     6634 6994 
0045 6636 1004  14         jmp   edkey.action.newline.rest
0046                       ;-------------------------------------------------------
0047                       ; Move cursor down a row, there are still rows left
0048                       ;-------------------------------------------------------
0049               edkey.action.newline.down:
0050 6638 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     663A A106 
0051 663C 06A0  32         bl    @down                 ; Row++ VDP cursor
     663E 26A6 
0052                       ;-------------------------------------------------------
0053                       ; Set VDP cursor and save variables
0054                       ;-------------------------------------------------------
0055               edkey.action.newline.rest:
0056 6640 06A0  32         bl    @fb.get.firstnonblank
     6642 694C 
0057 6644 C120  34         mov   @outparm1,tmp0
     6646 2F30 
0058 6648 C804  38         mov   tmp0,@fb.column
     664A A10C 
0059 664C 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     664E 26B8 
0060 6650 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     6652 6E8C 
0061 6654 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6656 6924 
0062 6658 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     665A A116 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.newline.exit:
0067 665C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     665E 76BE 
0068               
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Toggle insert/overwrite mode
0074               *---------------------------------------------------------------
0075               edkey.action.ins_onoff:
0076 6660 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     6662 A20A 
0077                       ;-------------------------------------------------------
0078                       ; Delay
0079                       ;-------------------------------------------------------
0080 6664 0204  20         li    tmp0,2000
     6666 07D0 
0081               edkey.action.ins_onoff.loop:
0082 6668 0604  14         dec   tmp0
0083 666A 16FE  14         jne   edkey.action.ins_onoff.loop
0084                       ;-------------------------------------------------------
0085                       ; Exit
0086                       ;-------------------------------------------------------
0087               edkey.action.ins_onoff.exit:
0088 666C 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     666E 77C4 
0089               
0090               
0091               
0092               
0093               *---------------------------------------------------------------
0094               * Add character (frame buffer)
0095               *---------------------------------------------------------------
0096               edkey.action.char:
0097                       ;-------------------------------------------------------
0098                       ; Sanity checks
0099                       ;-------------------------------------------------------
0100 6670 D105  18         movb  tmp1,tmp0             ; Get keycode
0101 6672 0984  56         srl   tmp0,8                ; MSB to LSB
0102               
0103 6674 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6676 0020 
0104 6678 112B  14         jlt   edkey.action.char.exit
0105                                                   ; Yes, skip
0106               
0107 667A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     667C 007E 
0108 667E 1528  14         jgt   edkey.action.char.exit
0109                                                   ; Yes, skip
0110                       ;-------------------------------------------------------
0111                       ; Setup
0112                       ;-------------------------------------------------------
0113 6680 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6682 A206 
0114 6684 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6686 2F20 
0115 6688 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     668A A20A 
0116 668C 1302  14         jeq   edkey.action.char.overwrite
0117                       ;-------------------------------------------------------
0118                       ; Insert mode
0119                       ;-------------------------------------------------------
0120               edkey.action.char.insert:
0121 668E 0460  28         b     @edkey.action.ins_char
     6690 653A 
0122                       ;-------------------------------------------------------
0123                       ; Overwrite mode - Write character
0124                       ;-------------------------------------------------------
0125               edkey.action.char.overwrite:
0126 6692 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6694 6924 
0127 6696 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6698 A102 
0128               
0129 669A D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     669C 2F20 
0130 669E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     66A0 A10A 
0131 66A2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     66A4 A116 
0132                       ;-------------------------------------------------------
0133                       ; Last column on screen reached?
0134                       ;-------------------------------------------------------
0135 66A6 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     66A8 A10C 
0136 66AA 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     66AC 004F 
0137 66AE 1105  14         jlt   edkey.action.char.overwrite.incx
0138                                                   ; No, increase X position
0139               
0140 66B0 0205  20         li    tmp1,colrow           ; \
     66B2 0050 
0141 66B4 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     66B6 A108 
0142 66B8 100B  14         jmp   edkey.action.char.exit
0143                       ;-------------------------------------------------------
0144                       ; Increase column
0145                       ;-------------------------------------------------------
0146               edkey.action.char.overwrite.incx:
0147 66BA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     66BC A10C 
0148 66BE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     66C0 832A 
0149                       ;-------------------------------------------------------
0150                       ; Update line length in frame buffer
0151                       ;-------------------------------------------------------
0152 66C2 8820  54         c     @fb.column,@fb.row.length
     66C4 A10C 
     66C6 A108 
0153                                                   ; column < line length ?
0154 66C8 1103  14         jlt   edkey.action.char.exit
0155                                                   ; Yes, don't update row length
0156 66CA C820  54         mov   @fb.column,@fb.row.length
     66CC A10C 
     66CE A108 
0157                                                   ; Set row length
0158                       ;-------------------------------------------------------
0159                       ; Exit
0160                       ;-------------------------------------------------------
0161               edkey.action.char.exit:
0162 66D0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     66D2 76BE 
**** **** ****     > stevie_b1.asm.2405726
0116                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit stevie
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009                       ;-------------------------------------------------------
0010                       ; Show dialog "unsaved changes" if editor buffer dirty
0011                       ;-------------------------------------------------------
0012 66D4 C120  34         mov   @edb.dirty,tmp0
     66D6 A206 
0013 66D8 1302  14         jeq   !
0014 66DA 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66DC 7ED8 
0015                       ;-------------------------------------------------------
0016                       ; Reset and lock F18a
0017                       ;-------------------------------------------------------
0018 66DE 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     66E0 2768 
0019 66E2 0420  54         blwp  @0                    ; Exit
     66E4 0000 
**** **** ****     > stevie_b1.asm.2405726
0117                       copy  "edkey.fb.file.asm"        ; File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load next or previous file based on last char in suffix
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.fname.inc.load
0008               * b   @edkey.action.fb.fname.dec.load
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 66E6 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66E8 A444 
     66EA 2F20 
0018 66EC 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     66EE 2F22 
0019 66F0 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 66F2 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     66F4 A444 
     66F6 2F20 
0023 66F8 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     66FA 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Sanity check
0028                       ;------------------------------------------------------
0029 66FC C120  34         mov   @parm1,tmp0
     66FE 2F20 
0030 6700 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 6702 C120  34         mov   @edb.dirty,tmp0
     6704 A206 
0036 6706 1302  14         jeq   !
0037 6708 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     670A 7ED8 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 670C 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     670E 760A 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 6710 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6712 E000 
0047 6714 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6716 734A 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 6718 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     671A 63C8 
**** **** ****     > stevie_b1.asm.2405726
0118                       ;-----------------------------------------------------------------------
0119                       ; Keyboard actions - Command Buffer
0120                       ;-----------------------------------------------------------------------
0121                       copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 671C C120  34         mov   @cmdb.column,tmp0
     671E A312 
0010 6720 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6722 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     6724 A312 
0015 6726 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6728 A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 672A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     672C 76BE 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 672E 06A0  32         bl    @cmdb.cmd.getlength
     6730 6F70 
0027 6732 8820  54         c     @cmdb.column,@outparm1
     6734 A312 
     6736 2F30 
0028 6738 1404  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 673A 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     673C A312 
0033 673E 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     6740 A30A 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037 6742 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6744 76BE 
0038               
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor beginning of line
0043               *---------------------------------------------------------------
0044               edkey.action.cmdb.home:
0045 6746 04C4  14         clr   tmp0
0046 6748 C804  38         mov   tmp0,@cmdb.column      ; First column
     674A A312 
0047 674C 0584  14         inc   tmp0
0048 674E D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     6750 A30A 
0049 6752 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     6754 A30A 
0050               
0051 6756 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6758 76BE 
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.cmdb.end:
0057 675A D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     675C A324 
0058 675E 0984  56         srl   tmp0,8                 ; Right justify
0059 6760 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6762 A312 
0060 6764 0584  14         inc   tmp0                   ; One time adjustment command prompt
0061 6766 0224  22         ai    tmp0,>1a00             ; Y=26
     6768 1A00 
0062 676A C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     676C A30A 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066 676E 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6770 76BE 
**** **** ****     > stevie_b1.asm.2405726
0122                       copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
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
0026 6772 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6774 6F3E 
0027 6776 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6778 A318 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.clear.exit:
0032 677A 0460  28         b     @edkey.action.cmdb.home
     677C 6746 
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
0061 677E D105  18         movb  tmp1,tmp0             ; Get keycode
0062 6780 0984  56         srl   tmp0,8                ; MSB to LSB
0063               
0064 6782 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6784 0020 
0065 6786 1115  14         jlt   edkey.action.cmdb.char.exit
0066                                                   ; Yes, skip
0067               
0068 6788 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     678A 007E 
0069 678C 1512  14         jgt   edkey.action.cmdb.char.exit
0070                                                   ; Yes, skip
0071                       ;-------------------------------------------------------
0072                       ; Add character
0073                       ;-------------------------------------------------------
0074 678E 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6790 A318 
0075               
0076 6792 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6794 A325 
0077 6796 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6798 A312 
0078 679A D505  30         movb  tmp1,*tmp0            ; Add character
0079 679C 05A0  34         inc   @cmdb.column          ; Next column
     679E A312 
0080 67A0 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     67A2 A30A 
0081               
0082 67A4 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     67A6 6F70 
0083                                                   ; \ i  @cmdb.cmd = Command string
0084                                                   ; / o  @outparm1 = Length of command
0085                       ;-------------------------------------------------------
0086                       ; Addjust length
0087                       ;-------------------------------------------------------
0088 67A8 C120  34         mov   @outparm1,tmp0
     67AA 2F30 
0089 67AC 0A84  56         sla   tmp0,8               ; LSB to MSB
0090 67AE D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     67B0 A324 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.cmdb.char.exit:
0095 67B2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67B4 76BE 
0096               
0097               
0098               
0099               
0100               *---------------------------------------------------------------
0101               * Enter
0102               *---------------------------------------------------------------
0103               edkey.action.cmdb.enter:
0104                       ;-------------------------------------------------------
0105                       ; Show Load or Save dialog depending on current mode
0106                       ;-------------------------------------------------------
0107               edkey.action.cmdb.enter.loadsave:
0108 67B6 0460  28         b     @edkey.action.cmdb.loadsave
     67B8 67D6 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.cmdb.enter.exit:
0113 67BA 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67BC 76BE 
**** **** ****     > stevie_b1.asm.2405726
0123                       copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 67BE C120  34         mov   @cmdb.visible,tmp0
     67C0 A302 
0010 67C2 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 67C4 04E0  34         clr   @cmdb.column          ; Column = 0
     67C6 A312 
0016 67C8 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     67CA 7B52 
0017 67CC 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 67CE 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     67D0 7BA2 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 67D2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67D4 76BE 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.2405726
0124                       copy  "edkey.cmdb.file.asm"      ; File related actions
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
0012 67D6 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     67D8 7BA2 
0013               
0014 67DA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     67DC 6F70 
0015 67DE C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     67E0 2F30 
0016 67E2 1607  14         jne   !                     ; No, prepare for load/save
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 67E4 06A0  32         bl    @pane.errline.show    ; Show error line
     67E6 7BE4 
0021               
0022 67E8 06A0  32         bl    @pane.show_hint
     67EA 7874 
0023 67EC 1C00                   byte 28,0
0024 67EE 35FA                   data txt.io.nofile
0025               
0026 67F0 1019  14         jmp   edkey.action.cmdb.loadsave.exit
0027                       ;-------------------------------------------------------
0028                       ; Prepare for loading or saving file
0029                       ;-------------------------------------------------------
0030 67F2 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 67F4 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     67F6 A324 
0032               
0033 67F8 06A0  32         bl    @cpym2m
     67FA 24AC 
0034 67FC A324                   data cmdb.cmdlen,heap.top,80
     67FE E000 
     6800 0050 
0035                                                   ; Copy filename from command line to buffer
0036               
0037 6802 C120  34         mov   @cmdb.dialog,tmp0
     6804 A31A 
0038 6806 0284  22         ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
     6808 000A 
0039 680A 1303  14         jeq   edkey.action.cmdb.load.loadfile
0040               
0041 680C 0284  22         ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
     680E 000B 
0042 6810 1305  14         jeq   edkey.action.cmdb.load.savefile
0043                       ;-------------------------------------------------------
0044                       ; Load specified file
0045                       ;-------------------------------------------------------
0046               edkey.action.cmdb.load.loadfile:
0047 6812 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6814 E000 
0048 6816 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6818 734A 
0049                                                   ; \ i  tmp0 = Pointer to length-prefixed
0050                                                   ; /           device/filename string
0051 681A 1004  14         jmp   edkey.action.cmdb.loadsave.exit
0052                       ;-------------------------------------------------------
0053                       ; Save specified file
0054                       ;-------------------------------------------------------
0055               edkey.action.cmdb.load.savefile:
0056 681C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     681E E000 
0057 6820 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6822 7402 
0058                                                   ; \ i  tmp0 = Pointer to length-prefixed
0059                                                   ; /           device/filename string
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.cmdb.loadsave.exit:
0064 6824 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6826 63C8 
**** **** ****     > stevie_b1.asm.2405726
0125                       copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
**** **** ****     > edkey.cmdb.dialog.asm
0001               * FILE......: edkey.cmdb.dialog.asm
0002               * Purpose...: Dialog specific actions in command buffer pane.
0003               
0004               
0005               
0006               *---------------------------------------------------------------
0007               * Proceed with action
0008               *---------------------------------------------------------------
0009               edkey.action.cmdb.proceed:
0010                       ;-------------------------------------------------------
0011                       ; Intialisation
0012                       ;-------------------------------------------------------
0013 6828 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     682A A206 
0014 682C 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     682E 78A6 
0015 6830 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6832 6F3E 
0016 6834 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6836 A322 
0017                       ;-------------------------------------------------------
0018                       ; Sanity checks
0019                       ;-------------------------------------------------------
0020 6838 0284  22         ci    tmp0,>2000
     683A 2000 
0021 683C 1104  14         jlt   !                     ; Invalid address, crash
0022               
0023 683E 0284  22         ci    tmp0,>7fff
     6840 7FFF 
0024 6842 1501  14         jgt   !                     ; Invalid address, crash
0025                       ;------------------------------------------------------
0026                       ; All sanity checks passed
0027                       ;------------------------------------------------------
0028 6844 0454  20         b     *tmp0                 ; Execute action
0029                       ;------------------------------------------------------
0030                       ; Sanity checks failed
0031                       ;------------------------------------------------------
0032 6846 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6848 FFCE 
0033 684A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     684C 2030 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037               edkey.action.cmdb.proceed.exit:
0038 684E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6850 76BE 
0039               
0040               
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Toggle fastmode on/off
0045               *---------------------------------------------------------------
0046               edkey.action.cmdb.fastmode.toggle:
0047 6852 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6854 73D0 
0048 6856 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6858 A318 
0049 685A 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     685C 76BE 
0050               
0051               
0052               
0053               
0054               ***************************************************************
0055               * dialog.close
0056               * Close dialog
0057               ***************************************************************
0058               * b   @edkey.action.cmdb.close.dialog
0059               *--------------------------------------------------------------
0060               * OUTPUT
0061               * none
0062               *--------------------------------------------------------------
0063               * Register usage
0064               * none
0065               ********|*****|*********************|**************************
0066               edkey.action.cmdb.close.dialog:
0067                       ;------------------------------------------------------
0068                       ; Close dialog
0069                       ;------------------------------------------------------
0070 685E 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6860 A31A 
0071 6862 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6864 78A6 
0072 6866 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6868 7BA2 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               edkey.action.cmdb.close.dialog.exit:
0077 686A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     686C 76BE 
**** **** ****     > stevie_b1.asm.2405726
0126                       ;-----------------------------------------------------------------------
0127                       ; Logic for Editor configuration and SAMS memory
0128                       ;-----------------------------------------------------------------------
0129                       copy  "tv.asm"              ; Main editor configuration
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
0027 686E 0649  14         dect  stack
0028 6870 C64B  30         mov   r11,*stack            ; Save return address
0029 6872 0649  14         dect  stack
0030 6874 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6876 0204  20         li    tmp0,1                ; \ Set default color scheme
     6878 0001 
0035 687A C804  38         mov   tmp0,@tv.colorscheme  ; /
     687C A012 
0036               
0037 687E 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     6880 A01E 
0038 6882 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     6884 2016 
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               tv.init.exit:
0043 6886 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0044 6888 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 688A 045B  20         b     *r11                  ; Return to caller
0046               
0047               
0048               
0049               ***************************************************************
0050               * tv.reset
0051               * Reset editor (clear buffer)
0052               ***************************************************************
0053               * bl @tv.reset
0054               *--------------------------------------------------------------
0055               * INPUT
0056               * none
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * none
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * r11
0063               *--------------------------------------------------------------
0064               * Notes
0065               ***************************************************************
0066               tv.reset:
0067 688C 0649  14         dect  stack
0068 688E C64B  30         mov   r11,*stack            ; Save return address
0069                       ;------------------------------------------------------
0070                       ; Reset editor
0071                       ;------------------------------------------------------
0072 6890 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6892 6EB0 
0073 6894 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6896 304A 
0074 6898 06A0  32         bl    @idx.init             ; Initialize index
     689A 6A04 
0075 689C 06A0  32         bl    @fb.init              ; Initialize framebuffer
     689E 3008 
0076 68A0 06A0  32         bl    @errline.init         ; Initialize error line
     68A2 6F9E 
0077                       ;-------------------------------------------------------
0078                       ; Exit
0079                       ;-------------------------------------------------------
0080               tv.reset.exit:
0081 68A4 C2F9  30         mov   *stack+,r11           ; Pop R11
0082 68A6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0130                       copy  "mem.asm"             ; SAMS Memory Management
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
0012               * bl  @mem.sams.layout
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ***************************************************************
0020               mem.sams.layout:
0021 68A8 0649  14         dect  stack
0022 68AA C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 68AC 06A0  32         bl    @sams.layout
     68AE 25B4 
0027 68B0 312A                   data mem.sams.layout.data
0028               
0029 68B2 06A0  32         bl    @sams.layout.copy
     68B4 2618 
0030 68B6 A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 68B8 C820  54         mov   @tv.sams.c000,@edb.sams.page
     68BA A008 
     68BC A212 
0033 68BE C820  54         mov   @edb.sams.page,@edb.sams.hipage
     68C0 A212 
     68C2 A214 
0034                                                   ; Track editor buffer SAMS page
0035                       ;------------------------------------------------------
0036                       ; Exit
0037                       ;------------------------------------------------------
0038               mem.sams.layout.exit:
0039 68C4 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 68C6 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               ***************************************************************
0045               * mem.edb.sams.mappage
0046               * Activate editor buffer SAMS page for line
0047               ***************************************************************
0048               * bl  @mem.edb.sams.mappage
0049               *     data p0
0050               *--------------------------------------------------------------
0051               * p0 = Line number in editor buffer
0052               *--------------------------------------------------------------
0053               * bl  @xmem.edb.sams.mappage
0054               *
0055               * tmp0 = Line number in editor buffer
0056               *--------------------------------------------------------------
0057               * OUTPUT
0058               * outparm1 = Pointer to line in editor buffer
0059               * outparm2 = SAMS page
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * tmp0, tmp1
0063               ***************************************************************
0064               mem.edb.sams.mappage:
0065 68C8 C13B  30         mov   *r11+,tmp0            ; Get p0
0066               xmem.edb.sams.mappage:
0067 68CA 0649  14         dect  stack
0068 68CC C64B  30         mov   r11,*stack            ; Push return address
0069 68CE 0649  14         dect  stack
0070 68D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0071 68D2 0649  14         dect  stack
0072 68D4 C645  30         mov   tmp1,*stack           ; Push tmp1
0073                       ;------------------------------------------------------
0074                       ; Sanity check
0075                       ;------------------------------------------------------
0076 68D6 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     68D8 A204 
0077 68DA 1204  14         jle   mem.edb.sams.mappage.lookup
0078                                                   ; All checks passed, continue
0079                                                   ;--------------------------
0080                                                   ; Sanity check failed
0081                                                   ;--------------------------
0082 68DC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     68DE FFCE 
0083 68E0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     68E2 2030 
0084                       ;------------------------------------------------------
0085                       ; Lookup SAMS page for line in parm1
0086                       ;------------------------------------------------------
0087               mem.edb.sams.mappage.lookup:
0088 68E4 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     68E6 6B58 
0089                                                   ; \ i  parm1    = Line number
0090                                                   ; | o  outparm1 = Pointer to line
0091                                                   ; / o  outparm2 = SAMS page
0092               
0093 68E8 C120  34         mov   @outparm2,tmp0        ; SAMS page
     68EA 2F32 
0094 68EC C160  34         mov   @outparm1,tmp1        ; Pointer to line
     68EE 2F30 
0095 68F0 130B  14         jeq   mem.edb.sams.mappage.exit
0096                                                   ; Nothing to page-in if NULL pointer
0097                                                   ; (=empty line)
0098                       ;------------------------------------------------------
0099                       ; Determine if requested SAMS page is already active
0100                       ;------------------------------------------------------
0101 68F2 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     68F4 A008 
0102 68F6 1308  14         jeq   mem.edb.sams.mappage.exit
0103                                                   ; Request page already active. Exit.
0104                       ;------------------------------------------------------
0105                       ; Activate requested SAMS page
0106                       ;-----------------------------------------------------
0107 68F8 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     68FA 2548 
0108                                                   ; \ i  tmp0 = SAMS page
0109                                                   ; / i  tmp1 = Memory address
0110               
0111 68FC C820  54         mov   @outparm2,@tv.sams.c000
     68FE 2F32 
     6900 A008 
0112                                                   ; Set page in shadow registers
0113               
0114 6902 C820  54         mov   @outparm2,@edb.sams.page
     6904 2F32 
     6906 A212 
0115                                                   ; Set current SAMS page
0116                       ;------------------------------------------------------
0117                       ; Exit
0118                       ;------------------------------------------------------
0119               mem.edb.sams.mappage.exit:
0120 6908 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0121 690A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0122 690C C2F9  30         mov   *stack+,r11           ; Pop r11
0123 690E 045B  20         b     *r11                  ; Return to caller
0124               
0125               
0126               
**** **** ****     > stevie_b1.asm.2405726
0131                       ;-----------------------------------------------------------------------
0132                       ; Logic for Framebuffer
0133                       ;-----------------------------------------------------------------------
0134                       copy  "fb.util.asm"         ; Framebuffer utilities
**** **** ****     > fb.util.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Stevie Editor - Framebuffer utilities
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fb.row2line
0011               * Calculate line in editor buffer
0012               ***************************************************************
0013               * bl @fb.row2line
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @fb.topline = Top line in frame buffer
0017               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * @outparm1 = Matching line in editor buffer
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp2,tmp3
0024               *--------------------------------------------------------------
0025               * Formula
0026               * outparm1 = @fb.topline + @parm1
0027               ********|*****|*********************|**************************
0028               fb.row2line:
0029 6910 0649  14         dect  stack
0030 6912 C64B  30         mov   r11,*stack            ; Save return address
0031                       ;------------------------------------------------------
0032                       ; Calculate line in editor buffer
0033                       ;------------------------------------------------------
0034 6914 C120  34         mov   @parm1,tmp0
     6916 2F20 
0035 6918 A120  34         a     @fb.topline,tmp0
     691A A104 
0036 691C C804  38         mov   tmp0,@outparm1
     691E 2F30 
0037                       ;------------------------------------------------------
0038                       ; Exit
0039                       ;------------------------------------------------------
0040               fb.row2line.exit:
0041 6920 C2F9  30         mov   *stack+,r11           ; Pop r11
0042 6922 045B  20         b     *r11                  ; Return to caller
0043               
0044               
0045               
0046               
0047               ***************************************************************
0048               * fb.calc_pointer
0049               * Calculate pointer address in frame buffer
0050               ***************************************************************
0051               * bl @fb.calc_pointer
0052               *--------------------------------------------------------------
0053               * INPUT
0054               * @fb.top       = Address of top row in frame buffer
0055               * @fb.topline   = Top line in frame buffer
0056               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0057               * @fb.column    = Current column in frame buffer
0058               * @fb.colsline  = Columns per line in frame buffer
0059               *--------------------------------------------------------------
0060               * OUTPUT
0061               * @fb.current   = Updated pointer
0062               *--------------------------------------------------------------
0063               * Register usage
0064               * tmp0,tmp1
0065               *--------------------------------------------------------------
0066               * Formula
0067               * pointer = row * colsline + column + deref(@fb.top.ptr)
0068               ********|*****|*********************|**************************
0069               fb.calc_pointer:
0070 6924 0649  14         dect  stack
0071 6926 C64B  30         mov   r11,*stack            ; Save return address
0072 6928 0649  14         dect  stack
0073 692A C644  30         mov   tmp0,*stack           ; Push tmp0
0074 692C 0649  14         dect  stack
0075 692E C645  30         mov   tmp1,*stack           ; Push tmp1
0076                       ;------------------------------------------------------
0077                       ; Calculate pointer
0078                       ;------------------------------------------------------
0079 6930 C120  34         mov   @fb.row,tmp0
     6932 A106 
0080 6934 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     6936 A10E 
0081 6938 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     693A A10C 
0082 693C A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     693E A100 
0083 6940 C805  38         mov   tmp1,@fb.current
     6942 A102 
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               fb.calc_pointer.exit:
0088 6944 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0089 6946 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0090 6948 C2F9  30         mov   *stack+,r11           ; Pop r11
0091 694A 045B  20         b     *r11                  ; Return to caller
0092               
0093               
0094               
0095               
0096               
0097               
0098               
0099               ***************************************************************
0100               * fb.get.firstnonblank
0101               * Get column of first non-blank character in specified line
0102               ***************************************************************
0103               * bl @fb.get.firstnonblank
0104               *--------------------------------------------------------------
0105               * OUTPUT
0106               * @outparm1 = Column containing first non-blank character
0107               * @outparm2 = Character
0108               ********|*****|*********************|**************************
0109               fb.get.firstnonblank:
0110 694C 0649  14         dect  stack
0111 694E C64B  30         mov   r11,*stack            ; Save return address
0112                       ;------------------------------------------------------
0113                       ; Prepare for scanning
0114                       ;------------------------------------------------------
0115 6950 04E0  34         clr   @fb.column
     6952 A10C 
0116 6954 06A0  32         bl    @fb.calc_pointer
     6956 6924 
0117 6958 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     695A 6E8C 
0118 695C C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     695E A108 
0119 6960 1313  14         jeq   fb.get.firstnonblank.nomatch
0120                                                   ; Exit if empty line
0121 6962 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6964 A102 
0122 6966 04C5  14         clr   tmp1
0123                       ;------------------------------------------------------
0124                       ; Scan line for non-blank character
0125                       ;------------------------------------------------------
0126               fb.get.firstnonblank.loop:
0127 6968 D174  28         movb  *tmp0+,tmp1           ; Get character
0128 696A 130E  14         jeq   fb.get.firstnonblank.nomatch
0129                                                   ; Exit if empty line
0130 696C 0285  22         ci    tmp1,>2000            ; Whitespace?
     696E 2000 
0131 6970 1503  14         jgt   fb.get.firstnonblank.match
0132 6972 0606  14         dec   tmp2                  ; Counter--
0133 6974 16F9  14         jne   fb.get.firstnonblank.loop
0134 6976 1008  14         jmp   fb.get.firstnonblank.nomatch
0135                       ;------------------------------------------------------
0136                       ; Non-blank character found
0137                       ;------------------------------------------------------
0138               fb.get.firstnonblank.match:
0139 6978 6120  34         s     @fb.current,tmp0      ; Calculate column
     697A A102 
0140 697C 0604  14         dec   tmp0
0141 697E C804  38         mov   tmp0,@outparm1        ; Save column
     6980 2F30 
0142 6982 D805  38         movb  tmp1,@outparm2        ; Save character
     6984 2F32 
0143 6986 1004  14         jmp   fb.get.firstnonblank.exit
0144                       ;------------------------------------------------------
0145                       ; No non-blank character found
0146                       ;------------------------------------------------------
0147               fb.get.firstnonblank.nomatch:
0148 6988 04E0  34         clr   @outparm1             ; X=0
     698A 2F30 
0149 698C 04E0  34         clr   @outparm2             ; Null
     698E 2F32 
0150                       ;------------------------------------------------------
0151                       ; Exit
0152                       ;------------------------------------------------------
0153               fb.get.firstnonblank.exit:
0154 6990 C2F9  30         mov   *stack+,r11           ; Pop r11
0155 6992 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0135                       copy  "fb.refresh.asm"      ; Framebuffer refresh
**** **** ****     > fb.refresh.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Stevie Editor - Framebuffer refresh
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fb.refresh
0011               * Refresh frame buffer with editor buffer content
0012               ***************************************************************
0013               * bl @fb.refresh
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1 = Line to start with (becomes @fb.topline)
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0,tmp1,tmp2
0023               ********|*****|*********************|**************************
0024               fb.refresh:
0025 6994 0649  14         dect  stack
0026 6996 C64B  30         mov   r11,*stack            ; Push return address
0027 6998 0649  14         dect  stack
0028 699A C644  30         mov   tmp0,*stack           ; Push tmp0
0029 699C 0649  14         dect  stack
0030 699E C645  30         mov   tmp1,*stack           ; Push tmp1
0031 69A0 0649  14         dect  stack
0032 69A2 C646  30         mov   tmp2,*stack           ; Push tmp2
0033                       ;------------------------------------------------------
0034                       ; Setup starting position in index
0035                       ;------------------------------------------------------
0036 69A4 C820  54         mov   @parm1,@fb.topline
     69A6 2F20 
     69A8 A104 
0037 69AA 04E0  34         clr   @parm2                ; Target row in frame buffer
     69AC 2F22 
0038                       ;------------------------------------------------------
0039                       ; Check if already at EOF
0040                       ;------------------------------------------------------
0041 69AE 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     69B0 2F20 
     69B2 A204 
0042 69B4 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0043                       ;------------------------------------------------------
0044                       ; Unpack line to frame buffer
0045                       ;------------------------------------------------------
0046               fb.refresh.unpack_line:
0047 69B6 06A0  32         bl    @edb.line.unpack      ; Unpack line
     69B8 6D9A 
0048                                                   ; \ i  parm1    = Line to unpack
0049                                                   ; | i  parm2    = Target row in frame buffer
0050                                                   ; / o  outparm1 = Length of line
0051               
0052 69BA 05A0  34         inc   @parm1                ; Next line in editor buffer
     69BC 2F20 
0053 69BE 05A0  34         inc   @parm2                ; Next row in frame buffer
     69C0 2F22 
0054                       ;------------------------------------------------------
0055                       ; Last row in editor buffer reached ?
0056                       ;------------------------------------------------------
0057 69C2 8820  54         c     @parm1,@edb.lines
     69C4 2F20 
     69C6 A204 
0058 69C8 1212  14         jle   !                     ; no, do next check
0059                                                   ; yes, erase until end of frame buffer
0060                       ;------------------------------------------------------
0061                       ; Erase until end of frame buffer
0062                       ;------------------------------------------------------
0063               fb.refresh.erase_eob:
0064 69CA C120  34         mov   @parm2,tmp0           ; Current row
     69CC 2F22 
0065 69CE C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     69D0 A118 
0066 69D2 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0067 69D4 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     69D6 A10E 
0068               
0069 69D8 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0070 69DA 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0071               
0072 69DC 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     69DE A10E 
0073 69E0 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     69E2 A100 
0074               
0075 69E4 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0076 69E6 04C5  14         clr   tmp1                  ; Clear with >00 character
0077               
0078 69E8 06A0  32         bl    @xfilm                ; \ Fill memory
     69EA 224A 
0079                                                   ; | i  tmp0 = Memory start address
0080                                                   ; | i  tmp1 = Byte to fill
0081                                                   ; / i  tmp2 = Number of bytes to fill
0082 69EC 1004  14         jmp   fb.refresh.exit
0083                       ;------------------------------------------------------
0084                       ; Bottom row in frame buffer reached ?
0085                       ;------------------------------------------------------
0086 69EE 8820  54 !       c     @parm2,@fb.scrrows
     69F0 2F22 
     69F2 A118 
0087 69F4 11E0  14         jlt   fb.refresh.unpack_line
0088                                                   ; No, unpack next line
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               fb.refresh.exit:
0093 69F6 0720  34         seto  @fb.dirty             ; Refresh screen
     69F8 A116 
0094 69FA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0095 69FC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0096 69FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0097 6A00 C2F9  30         mov   *stack+,r11           ; Pop r11
0098 6A02 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0136                       ;-----------------------------------------------------------------------
0137                       ; Logic for Index management
0138                       ;-----------------------------------------------------------------------
0139                       copy  "idx.asm"             ; Index management
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
0050 6A04 0649  14         dect  stack
0051 6A06 C64B  30         mov   r11,*stack            ; Save return address
0052 6A08 0649  14         dect  stack
0053 6A0A C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 6A0C 0204  20         li    tmp0,idx.top
     6A0E B000 
0058 6A10 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     6A12 A202 
0059               
0060 6A14 C120  34         mov   @tv.sams.b000,tmp0
     6A16 A006 
0061 6A18 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     6A1A A500 
0062 6A1C C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     6A1E A502 
0063 6A20 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     6A22 A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 6A24 06A0  32         bl    @film
     6A26 2244 
0068 6A28 B000                   data idx.top,>00,idx.size
     6A2A 0000 
     6A2C 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 6A2E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 6A30 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 6A32 045B  20         b     *r11                  ; Return to caller
0077               
0078               
0079               
0080               ***************************************************************
0081               * _idx.sams.mapcolumn.on
0082               * Flatten SAMS index pages into continuous memory region.
0083               * Gives 20 KB of index space (2048 * 5 = 10240 lines for each
0084               * editor buffer).
0085               *
0086               * >b000  1st index page
0087               * >c000  2nd index page
0088               * >d000  3rd index page
0089               * >e000  4th index page
0090               * >f000  5th index page
0091               ***************************************************************
0092               * bl @_idx.sams.mapcolumn.on
0093               *--------------------------------------------------------------
0094               * Register usage
0095               * tmp0, tmp1, tmp2
0096               *--------------------------------------------------------------
0097               *  Remarks
0098               *  Private, only to be called from inside idx module
0099               ********|*****|*********************|**************************
0100               _idx.sams.mapcolumn.on:
0101 6A34 0649  14         dect  stack
0102 6A36 C64B  30         mov   r11,*stack            ; Push return address
0103 6A38 0649  14         dect  stack
0104 6A3A C644  30         mov   tmp0,*stack           ; Push tmp0
0105 6A3C 0649  14         dect  stack
0106 6A3E C645  30         mov   tmp1,*stack           ; Push tmp1
0107 6A40 0649  14         dect  stack
0108 6A42 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 6A44 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6A46 A502 
0113 6A48 0205  20         li    tmp1,idx.top
     6A4A B000 
0114               
0115 6A4C C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     6A4E A504 
0116 6A50 0586  14         inc   tmp2                  ; +1 loop adjustment
0117 6A52 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6A54 A502 
0118                       ;-------------------------------------------------------
0119                       ; Sanity check
0120                       ;-------------------------------------------------------
0121 6A56 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6A58 0005 
0122 6A5A 1104  14         jlt   !
0123 6A5C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6A5E FFCE 
0124 6A60 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A62 2030 
0125                       ;-------------------------------------------------------
0126                       ; Loop over banks
0127                       ;-------------------------------------------------------
0128 6A64 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6A66 2548 
0129                                                   ; \ i  tmp0  = SAMS page number
0130                                                   ; / i  tmp1  = Memory address
0131               
0132 6A68 0584  14         inc   tmp0                  ; Next SAMS index page
0133 6A6A 0225  22         ai    tmp1,>1000            ; Next memory region
     6A6C 1000 
0134 6A6E 0606  14         dec   tmp2                  ; Update loop counter
0135 6A70 15F9  14         jgt   -!                    ; Next iteration
0136               *--------------------------------------------------------------
0137               * Exit
0138               *--------------------------------------------------------------
0139               _idx.sams.mapcolumn.on.exit:
0140 6A72 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0141 6A74 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0142 6A76 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0143 6A78 C2F9  30         mov   *stack+,r11           ; Pop return address
0144 6A7A 045B  20         b     *r11                  ; Return to caller
0145               
0146               
0147               ***************************************************************
0148               * _idx.sams.mapcolumn.off
0149               * Restore normal SAMS layout again (single index page)
0150               ***************************************************************
0151               * bl @_idx.sams.mapcolumn.off
0152               *--------------------------------------------------------------
0153               * Register usage
0154               * tmp0, tmp1, tmp2, tmp3
0155               *--------------------------------------------------------------
0156               *  Remarks
0157               *  Private, only to be called from inside idx module
0158               ********|*****|*********************|**************************
0159               _idx.sams.mapcolumn.off:
0160 6A7C 0649  14         dect  stack
0161 6A7E C64B  30         mov   r11,*stack            ; Push return address
0162 6A80 0649  14         dect  stack
0163 6A82 C644  30         mov   tmp0,*stack           ; Push tmp0
0164 6A84 0649  14         dect  stack
0165 6A86 C645  30         mov   tmp1,*stack           ; Push tmp1
0166 6A88 0649  14         dect  stack
0167 6A8A C646  30         mov   tmp2,*stack           ; Push tmp2
0168 6A8C 0649  14         dect  stack
0169 6A8E C647  30         mov   tmp3,*stack           ; Push tmp3
0170               *--------------------------------------------------------------
0171               * Map index pages into memory window  (b000-?????)
0172               *--------------------------------------------------------------
0173 6A90 0205  20         li    tmp1,idx.top
     6A92 B000 
0174 6A94 0206  20         li    tmp2,5                ; Always 5 pages
     6A96 0005 
0175 6A98 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6A9A A006 
0176                       ;-------------------------------------------------------
0177                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0178                       ;-------------------------------------------------------
0179 6A9C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0180               
0181 6A9E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6AA0 2548 
0182                                                   ; \ i  tmp0  = SAMS page number
0183                                                   ; / i  tmp1  = Memory address
0184               
0185 6AA2 0225  22         ai    tmp1,>1000            ; Next memory region
     6AA4 1000 
0186 6AA6 0606  14         dec   tmp2                  ; Update loop counter
0187 6AA8 15F9  14         jgt   -!                    ; Next iteration
0188               *--------------------------------------------------------------
0189               * Exit
0190               *--------------------------------------------------------------
0191               _idx.sams.mapcolumn.off.exit:
0192 6AAA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0193 6AAC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0194 6AAE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0195 6AB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0196 6AB2 C2F9  30         mov   *stack+,r11           ; Pop return address
0197 6AB4 045B  20         b     *r11                  ; Return to caller
0198               
0199               
0200               
0201               ***************************************************************
0202               * _idx.samspage.get
0203               * Get SAMS page for index
0204               ***************************************************************
0205               * bl @_idx.samspage.get
0206               *--------------------------------------------------------------
0207               * INPUT
0208               * tmp0 = Line number
0209               *--------------------------------------------------------------
0210               * OUTPUT
0211               * @outparm1 = Offset for index entry in index SAMS page
0212               *--------------------------------------------------------------
0213               * Register usage
0214               * tmp0, tmp1, tmp2
0215               *--------------------------------------------------------------
0216               *  Remarks
0217               *  Private, only to be called from inside idx module.
0218               *  Activates SAMS page containing required index slot entry.
0219               ********|*****|*********************|**************************
0220               _idx.samspage.get:
0221 6AB6 0649  14         dect  stack
0222 6AB8 C64B  30         mov   r11,*stack            ; Save return address
0223 6ABA 0649  14         dect  stack
0224 6ABC C644  30         mov   tmp0,*stack           ; Push tmp0
0225 6ABE 0649  14         dect  stack
0226 6AC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0227 6AC2 0649  14         dect  stack
0228 6AC4 C646  30         mov   tmp2,*stack           ; Push tmp2
0229                       ;------------------------------------------------------
0230                       ; Determine SAMS index page
0231                       ;------------------------------------------------------
0232 6AC6 C184  18         mov   tmp0,tmp2             ; Line number
0233 6AC8 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0234 6ACA 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6ACC 0800 
0235               
0236 6ACE 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0237                                                   ; | tmp1 = quotient  (SAMS page offset)
0238                                                   ; / tmp2 = remainder
0239               
0240 6AD0 0A16  56         sla   tmp2,1                ; line number * 2
0241 6AD2 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6AD4 2F30 
0242               
0243 6AD6 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6AD8 A502 
0244 6ADA 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6ADC A500 
0245               
0246 6ADE 130E  14         jeq   _idx.samspage.get.exit
0247                                                   ; Yes, so exit
0248                       ;------------------------------------------------------
0249                       ; Activate SAMS index page
0250                       ;------------------------------------------------------
0251 6AE0 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6AE2 A500 
0252 6AE4 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     6AE6 A006 
0253               
0254 6AE8 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0255 6AEA 0205  20         li    tmp1,>b000            ; Memory window for index page
     6AEC B000 
0256               
0257 6AEE 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6AF0 2548 
0258                                                   ; \ i  tmp0 = SAMS page
0259                                                   ; / i  tmp1 = Memory address
0260                       ;------------------------------------------------------
0261                       ; Check if new highest SAMS index page
0262                       ;------------------------------------------------------
0263 6AF2 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     6AF4 A504 
0264 6AF6 1202  14         jle   _idx.samspage.get.exit
0265                                                   ; No, exit
0266 6AF8 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6AFA A504 
0267                       ;------------------------------------------------------
0268                       ; Exit
0269                       ;------------------------------------------------------
0270               _idx.samspage.get.exit:
0271 6AFC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0272 6AFE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0273 6B00 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0274 6B02 C2F9  30         mov   *stack+,r11           ; Pop r11
0275 6B04 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0140                       copy  "idx.update.asm"      ; Index management - Update entry
**** **** ****     > idx.update.asm
0001               * FILE......: idx.update.asm
0002               * Purpose...: Stevie Editor - Update index entry
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *             Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * idx.entry.update
0011               * Update index entry - Each entry corresponds to a line
0012               ***************************************************************
0013               * bl @idx.entry.update
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1    = Line number in editor buffer
0017               * @parm2    = Pointer to line in editor buffer
0018               * @parm3    = SAMS page
0019               *--------------------------------------------------------------
0020               * OUTPUT
0021               * @outparm1 = Pointer to updated index entry
0022               *--------------------------------------------------------------
0023               * Register usage
0024               * tmp0,tmp1,tmp2
0025               ********|*****|*********************|**************************
0026               idx.entry.update:
0027 6B06 0649  14         dect  stack
0028 6B08 C64B  30         mov   r11,*stack            ; Save return address
0029 6B0A 0649  14         dect  stack
0030 6B0C C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6B0E 0649  14         dect  stack
0032 6B10 C645  30         mov   tmp1,*stack           ; Push tmp1
0033                       ;------------------------------------------------------
0034                       ; Get parameters
0035                       ;------------------------------------------------------
0036 6B12 C120  34         mov   @parm1,tmp0           ; Get line number
     6B14 2F20 
0037 6B16 C160  34         mov   @parm2,tmp1           ; Get pointer
     6B18 2F22 
0038 6B1A 1312  14         jeq   idx.entry.update.clear
0039                                                   ; Special handling for "null"-pointer
0040                       ;------------------------------------------------------
0041                       ; Calculate LSB value index slot (pointer offset)
0042                       ;------------------------------------------------------
0043 6B1C 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6B1E 0FFF 
0044 6B20 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0045                       ;------------------------------------------------------
0046                       ; Calculate MSB value index slot (SAMS page editor buffer)
0047                       ;------------------------------------------------------
0048 6B22 06E0  34         swpb  @parm3
     6B24 2F24 
0049 6B26 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6B28 2F24 
0050 6B2A 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6B2C 2F24 
0051                                                   ; / important for messing up caller parm3!
0052                       ;------------------------------------------------------
0053                       ; Update index slot
0054                       ;------------------------------------------------------
0055               idx.entry.update.save:
0056 6B2E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B30 6AB6 
0057                                                   ; \ i  tmp0     = Line number
0058                                                   ; / o  outparm1 = Slot offset in SAMS page
0059               
0060 6B32 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6B34 2F30 
0061 6B36 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6B38 B000 
0062 6B3A C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B3C 2F30 
0063 6B3E 1008  14         jmp   idx.entry.update.exit
0064                       ;------------------------------------------------------
0065                       ; Special handling for "null"-pointer
0066                       ;------------------------------------------------------
0067               idx.entry.update.clear:
0068 6B40 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B42 6AB6 
0069                                                   ; \ i  tmp0     = Line number
0070                                                   ; / o  outparm1 = Slot offset in SAMS page
0071               
0072 6B44 C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6B46 2F30 
0073 6B48 04E4  34         clr   @idx.top(tmp0)        ; /
     6B4A B000 
0074 6B4C C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B4E 2F30 
0075                       ;------------------------------------------------------
0076                       ; Exit
0077                       ;------------------------------------------------------
0078               idx.entry.update.exit:
0079 6B50 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0080 6B52 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0081 6B54 C2F9  30         mov   *stack+,r11           ; Pop r11
0082 6B56 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0141                       copy  "idx.pointer.asm"     ; Index management - Get pointer to line
**** **** ****     > idx.pointer.asm
0001               * FILE......: idx.pointer.asm
0002               * Purpose...: Stevie Editor - Get pointer to line in editor buffer
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               ***************************************************************
0011               * idx.pointer.get
0012               * Get pointer to editor buffer line content
0013               ***************************************************************
0014               * bl @idx.pointer.get
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @parm1 = Line number in editor buffer
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * @outparm1 = Pointer to editor buffer line content
0021               * @outparm2 = SAMS page
0022               *--------------------------------------------------------------
0023               * Register usage
0024               * tmp0,tmp1,tmp2
0025               ********|*****|*********************|**************************
0026               idx.pointer.get:
0027 6B58 0649  14         dect  stack
0028 6B5A C64B  30         mov   r11,*stack            ; Save return address
0029 6B5C 0649  14         dect  stack
0030 6B5E C644  30         mov   tmp0,*stack           ; Push tmp0
0031 6B60 0649  14         dect  stack
0032 6B62 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 6B64 0649  14         dect  stack
0034 6B66 C646  30         mov   tmp2,*stack           ; Push tmp2
0035                       ;------------------------------------------------------
0036                       ; Get slot entry
0037                       ;------------------------------------------------------
0038 6B68 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B6A 2F20 
0039               
0040 6B6C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6B6E 6AB6 
0041                                                   ; \ i  tmp0     = Line number
0042                                                   ; / o  outparm1 = Slot offset in SAMS page
0043               
0044 6B70 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6B72 2F30 
0045 6B74 C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6B76 B000 
0046               
0047 6B78 130C  14         jeq   idx.pointer.get.parm.null
0048                                                   ; Skip if index slot empty
0049                       ;------------------------------------------------------
0050                       ; Calculate MSB (SAMS page)
0051                       ;------------------------------------------------------
0052 6B7A C185  18         mov   tmp1,tmp2             ; \
0053 6B7C 0986  56         srl   tmp2,8                ; / Right align SAMS page
0054                       ;------------------------------------------------------
0055                       ; Calculate LSB (pointer address)
0056                       ;------------------------------------------------------
0057 6B7E 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6B80 00FF 
0058 6B82 0A45  56         sla   tmp1,4                ; Multiply with 16
0059 6B84 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6B86 C000 
0060                       ;------------------------------------------------------
0061                       ; Return parameters
0062                       ;------------------------------------------------------
0063               idx.pointer.get.parm:
0064 6B88 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6B8A 2F30 
0065 6B8C C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6B8E 2F32 
0066 6B90 1004  14         jmp   idx.pointer.get.exit
0067                       ;------------------------------------------------------
0068                       ; Special handling for "null"-pointer
0069                       ;------------------------------------------------------
0070               idx.pointer.get.parm.null:
0071 6B92 04E0  34         clr   @outparm1
     6B94 2F30 
0072 6B96 04E0  34         clr   @outparm2
     6B98 2F32 
0073                       ;------------------------------------------------------
0074                       ; Exit
0075                       ;------------------------------------------------------
0076               idx.pointer.get.exit:
0077 6B9A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0078 6B9C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0079 6B9E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0080 6BA0 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6BA2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0142                       copy  "idx.delete.asm"      ; Index management - delete slot
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
0025 6BA4 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6BA6 B000 
0026 6BA8 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6BAA 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6BAC CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6BAE 0606  14         dec   tmp2                  ; tmp2--
0034 6BB0 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6BB2 045B  20         b     *r11                  ; Return to caller
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
0051               * tmp0,tmp1,tmp2,tmp3
0052               ********|*****|*********************|**************************
0053               idx.entry.delete:
0054 6BB4 0649  14         dect  stack
0055 6BB6 C64B  30         mov   r11,*stack            ; Save return address
0056 6BB8 0649  14         dect  stack
0057 6BBA C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6BBC 0649  14         dect  stack
0059 6BBE C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6BC0 0649  14         dect  stack
0061 6BC2 C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6BC4 0649  14         dect  stack
0063 6BC6 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6BC8 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6BCA 2F20 
0068               
0069 6BCC 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6BCE 6AB6 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6BD0 C120  34         mov   @outparm1,tmp0        ; Index offset
     6BD2 2F30 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6BD4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6BD6 2F22 
0078 6BD8 1303  14         jeq   idx.entry.delete.lastline
0079                                                   ; Exit early if last line = 0
0080               
0081 6BDA 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BDC 2F20 
0082 6BDE 1504  14         jgt   idx.entry.delete.reorg
0083                                                   ; Reorganize if loop counter > 0
0084                       ;------------------------------------------------------
0085                       ; Special treatment for last line
0086                       ;------------------------------------------------------
0087               idx.entry.delete.lastline:
0088 6BE0 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6BE2 B000 
0089 6BE4 04D4  26         clr   *tmp0                 ; Clear index entry
0090 6BE6 1012  14         jmp   idx.entry.delete.exit ; Exit early
0091                       ;------------------------------------------------------
0092                       ; Reorganize index entries
0093                       ;------------------------------------------------------
0094               idx.entry.delete.reorg:
0095 6BE8 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     6BEA 2F22 
0096 6BEC 0287  22         ci    tmp3,2048
     6BEE 0800 
0097 6BF0 120A  14         jle   idx.entry.delete.reorg.simple
0098                                                   ; Do simple reorg only if single
0099                                                   ; SAMS index page, otherwise complex reorg.
0100                       ;------------------------------------------------------
0101                       ; Complex index reorganization (multiple SAMS pages)
0102                       ;------------------------------------------------------
0103               idx.entry.delete.reorg.complex:
0104 6BF2 06A0  32         bl    @_idx.sams.mapcolumn.on
     6BF4 6A34 
0105                                                   ; Index in continuous memory region
0106               
0107                       ;-------------------------------------------------------
0108                       ; Recalculate index offset in continuous memory region
0109                       ;-------------------------------------------------------
0110 6BF6 C120  34         mov   @parm1,tmp0           ; Restore line number
     6BF8 2F20 
0111 6BFA 0A14  56         sla   tmp0,1                ; Calculate offset
0112               
0113 6BFC 06A0  32         bl    @_idx.entry.delete.reorg
     6BFE 6BA4 
0114                                                   ; Reorganize index
0115                                                   ; \ i  tmp0 = Index offset
0116                                                   ; / i  tmp2 = Loop count
0117               
0118 6C00 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C02 6A7C 
0119                                                   ; Restore memory window layout
0120               
0121 6C04 1002  14         jmp   !
0122                       ;------------------------------------------------------
0123                       ; Simple index reorganization
0124                       ;------------------------------------------------------
0125               idx.entry.delete.reorg.simple:
0126 6C06 06A0  32         bl    @_idx.entry.delete.reorg
     6C08 6BA4 
0127                       ;------------------------------------------------------
0128                       ; Clear index entry (base + offset already set)
0129                       ;------------------------------------------------------
0130 6C0A 04D4  26 !       clr   *tmp0                 ; Clear index entry
0131                       ;------------------------------------------------------
0132                       ; Exit
0133                       ;------------------------------------------------------
0134               idx.entry.delete.exit:
0135 6C0C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0136 6C0E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0137 6C10 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0138 6C12 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0139 6C14 C2F9  30         mov   *stack+,r11           ; Pop r11
0140 6C16 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0143                       copy  "idx.insert.asm"      ; Index management - insert slot
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
0010               ***************************************************************
0011               * _idx.entry.insert.reorg
0012               * Reorganize index slot entries
0013               ***************************************************************
0014               * bl @_idx.entry.insert.reorg
0015               *--------------------------------------------------------------
0016               *  Remarks
0017               *  Private, only to be called from idx_entry_delete
0018               ********|*****|*********************|**************************
0019               _idx.entry.insert.reorg:
0020                       ;------------------------------------------------------
0021                       ; sanity check 1
0022                       ;------------------------------------------------------
0023 6C18 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6C1A 2800 
0024                                                   ; (max 5 SAMS pages with 2048 index entries)
0025               
0026 6C1C 1204  14         jle   !                     ; Continue if ok
0027                       ;------------------------------------------------------
0028                       ; Crash and burn
0029                       ;------------------------------------------------------
0030               _idx.entry.insert.reorg.crash:
0031 6C1E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6C20 FFCE 
0032 6C22 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6C24 2030 
0033                       ;------------------------------------------------------
0034                       ; Reorganize index entries
0035                       ;------------------------------------------------------
0036 6C26 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6C28 B000 
0037 6C2A C144  18         mov   tmp0,tmp1             ; a = current slot
0038 6C2C 05C5  14         inct  tmp1                  ; b = current slot + 2
0039 6C2E 0586  14         inc   tmp2                  ; One time adjustment for current line
0040                       ;------------------------------------------------------
0041                       ; Sanity check 2
0042                       ;------------------------------------------------------
0043 6C30 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0044 6C32 0A17  56         sla   tmp3,1                ; adjust to slot size
0045 6C34 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0046 6C36 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0047 6C38 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6C3A AFFE 
0048 6C3C 11F0  14         jlt   _idx.entry.insert.reorg.crash
0049                                                   ; If yes, crash
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 6C3E C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 6C40 0644  14         dect  tmp0                  ; Move pointer up
0056 6C42 0645  14         dect  tmp1                  ; Move pointer up
0057 6C44 0606  14         dec   tmp2                  ; Next index entry
0058 6C46 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 6C48 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 6C4A 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 6C4C 045B  20         b     *r11                  ; Return to caller
0067               
0068               
0069               
0070               
0071               ***************************************************************
0072               * idx.entry.insert
0073               * Insert index entry
0074               ***************************************************************
0075               * bl @idx.entry.insert
0076               *--------------------------------------------------------------
0077               * INPUT
0078               * @parm1    = Line number in editor buffer to insert
0079               * @parm2    = Line number of last line to check for reorg
0080               *--------------------------------------------------------------
0081               * OUTPUT
0082               * NONE
0083               *--------------------------------------------------------------
0084               * Register usage
0085               * tmp0,tmp2
0086               ********|*****|*********************|**************************
0087               idx.entry.insert:
0088 6C4E 0649  14         dect  stack
0089 6C50 C64B  30         mov   r11,*stack            ; Save return address
0090 6C52 0649  14         dect  stack
0091 6C54 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 6C56 0649  14         dect  stack
0093 6C58 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 6C5A 0649  14         dect  stack
0095 6C5C C646  30         mov   tmp2,*stack           ; Push tmp2
0096 6C5E 0649  14         dect  stack
0097 6C60 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 6C62 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C64 2F22 
0102 6C66 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6C68 2F20 
0103 6C6A 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 6C6C C1E0  34         mov   @parm2,tmp3
     6C6E 2F22 
0110 6C70 0287  22         ci    tmp3,2048
     6C72 0800 
0111 6C74 120A  14         jle   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 6C76 06A0  32         bl    @_idx.sams.mapcolumn.on
     6C78 6A34 
0119                                                   ; Index in continious memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 6C7A C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6C7C 2F22 
0123 6C7E 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 6C80 06A0  32         bl    @_idx.entry.insert.reorg
     6C82 6C18 
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 6C84 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C86 6A7C 
0131                                                   ; Restore memory window layout
0132               
0133 6C88 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 6C8A C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6C8C 2F22 
0139               
0140 6C8E 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C90 6AB6 
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 6C92 C120  34         mov   @outparm1,tmp0        ; Index offset
     6C94 2F30 
0145               
0146 6C96 06A0  32         bl    @_idx.entry.insert.reorg
     6C98 6C18 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               idx.entry.insert.exit:
0151 6C9A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0152 6C9C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0153 6C9E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0154 6CA0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0155 6CA2 C2F9  30         mov   *stack+,r11           ; Pop r11
0156 6CA4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0144                       ;-----------------------------------------------------------------------
0145                       ; Logic for Editor Buffer
0146                       ;-----------------------------------------------------------------------
0147                       copy  "edb.line.pack.asm"   ; Pack line into editor buffer
**** **** ****     > edb.line.pack.asm
0001               * FILE......: edb.line.pack.asm
0002               * Purpose...: Stevie Editor - Editor Buffer pack line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          Stevie Editor - Editor Buffer pack line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               ***************************************************************
0011               * edb.line.pack
0012               * Pack current line in framebuffer
0013               ***************************************************************
0014               *  bl   @edb.line.pack
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @fb.top       = Address of top row in frame buffer
0018               * @fb.row       = Current row in frame buffer
0019               * @fb.column    = Current column in frame buffer
0020               * @fb.colsline  = Columns per line in frame buffer
0021               *--------------------------------------------------------------
0022               * OUTPUT
0023               *--------------------------------------------------------------
0024               * Register usage
0025               * tmp0,tmp1,tmp2
0026               *--------------------------------------------------------------
0027               * Memory usage
0028               * rambuf   = Saved @fb.column
0029               * rambuf+2 = Saved beginning of row
0030               * rambuf+4 = Saved length of row
0031               ********|*****|*********************|**************************
0032               edb.line.pack:
0033 6CA6 0649  14         dect  stack
0034 6CA8 C64B  30         mov   r11,*stack            ; Save return address
0035 6CAA 0649  14         dect  stack
0036 6CAC C644  30         mov   tmp0,*stack           ; Push tmp0
0037 6CAE 0649  14         dect  stack
0038 6CB0 C645  30         mov   tmp1,*stack           ; Push tmp1
0039 6CB2 0649  14         dect  stack
0040 6CB4 C646  30         mov   tmp2,*stack           ; Push tmp2
0041                       ;------------------------------------------------------
0042                       ; Get values
0043                       ;------------------------------------------------------
0044 6CB6 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6CB8 A10C 
     6CBA 2F64 
0045 6CBC 04E0  34         clr   @fb.column
     6CBE A10C 
0046 6CC0 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6CC2 6924 
0047                       ;------------------------------------------------------
0048                       ; Prepare scan
0049                       ;------------------------------------------------------
0050 6CC4 04C4  14         clr   tmp0                  ; Counter
0051 6CC6 C160  34         mov   @fb.current,tmp1      ; Get position
     6CC8 A102 
0052 6CCA C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6CCC 2F66 
0053                       ;------------------------------------------------------
0054                       ; Scan line for >00 byte termination
0055                       ;------------------------------------------------------
0056               edb.line.pack.scan:
0057 6CCE D1B5  28         movb  *tmp1+,tmp2           ; Get char
0058 6CD0 0986  56         srl   tmp2,8                ; Right justify
0059 6CD2 1309  14         jeq   edb.line.pack.check_setpage
0060                                                   ; Stop scan if >00 found
0061 6CD4 0584  14         inc   tmp0                  ; Increase string length
0062                       ;------------------------------------------------------
0063                       ; Not more than 80 characters
0064                       ;------------------------------------------------------
0065 6CD6 0284  22         ci    tmp0,colrow
     6CD8 0050 
0066 6CDA 1305  14         jeq   edb.line.pack.check_setpage
0067                                                   ; Stop scan if 80 characters processed
0068 6CDC 10F8  14         jmp   edb.line.pack.scan    ; Next character
0069                       ;------------------------------------------------------
0070                       ; Check failed, crash CPU!
0071                       ;------------------------------------------------------
0072               edb.line.pack.crash:
0073 6CDE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6CE0 FFCE 
0074 6CE2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6CE4 2030 
0075                       ;------------------------------------------------------
0076                       ; 1a: Check if highest SAMS page needs to be increased
0077                       ;------------------------------------------------------
0078               edb.line.pack.check_setpage:
0079 6CE6 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6CE8 2F68 
0080 6CEA C120  34         mov   @edb.next_free.ptr,tmp0
     6CEC A208 
0081                                                   ;--------------------------
0082                                                   ; Sanity check
0083                                                   ;--------------------------
0084 6CEE 0284  22         ci    tmp0,edb.top + edb.size
     6CF0 D000 
0085                                                   ; Insane address ?
0086 6CF2 15F5  14         jgt   edb.line.pack.crash   ; Yes, crash!
0087                                                   ;--------------------------
0088                                                   ; Check for page overflow
0089                                                   ;--------------------------
0090 6CF4 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     6CF6 0FFF 
0091 6CF8 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     6CFA 0052 
0092 6CFC 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     6CFE 0FF0 
0093 6D00 1105  14         jlt   edb.line.pack.setpage ; Not yet, don't increase SAMS page
0094                       ;------------------------------------------------------
0095                       ; 1b: Increase highest SAMS page (copy-on-write!)
0096                       ;------------------------------------------------------
0097 6D02 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     6D04 A214 
0098 6D06 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     6D08 A200 
     6D0A A208 
0099                                                   ; Start at top of SAMS page again
0100                       ;------------------------------------------------------
0101                       ; 1c: Switch to SAMS page
0102                       ;------------------------------------------------------
0103               edb.line.pack.setpage:
0104 6D0C C120  34         mov   @edb.sams.hipage,tmp0
     6D0E A214 
0105 6D10 C160  34         mov   @edb.top.ptr,tmp1
     6D12 A200 
0106 6D14 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D16 2548 
0107                                                   ; \ i  tmp0 = SAMS page number
0108                                                   ; / i  tmp1 = Memory address
0109                       ;------------------------------------------------------
0110                       ; Step 2: Prepare for storing line
0111                       ;------------------------------------------------------
0112               edb.line.pack.prepare:
0113 6D18 C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6D1A A104 
     6D1C 2F20 
0114 6D1E A820  54         a     @fb.row,@parm1        ; /
     6D20 A106 
     6D22 2F20 
0115                       ;------------------------------------------------------
0116                       ; 2a Update index
0117                       ;------------------------------------------------------
0118               edb.line.pack.update_index:
0119 6D24 C820  54         mov   @edb.next_free.ptr,@parm2
     6D26 A208 
     6D28 2F22 
0120                                                   ; Pointer to new line
0121 6D2A C820  54         mov   @edb.sams.hipage,@parm3
     6D2C A214 
     6D2E 2F24 
0122                                                   ; SAMS page to use
0123               
0124 6D30 06A0  32         bl    @idx.entry.update     ; Update index
     6D32 6B06 
0125                                                   ; \ i  parm1 = Line number in editor buffer
0126                                                   ; | i  parm2 = pointer to line in
0127                                                   ; |            editor buffer
0128                                                   ; / i  parm3 = SAMS page
0129                       ;------------------------------------------------------
0130                       ; 3. Set line prefix in editor buffer
0131                       ;------------------------------------------------------
0132 6D34 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     6D36 2F66 
0133 6D38 C160  34         mov   @edb.next_free.ptr,tmp1
     6D3A A208 
0134                                                   ; Address of line in editor buffer
0135               
0136 6D3C 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6D3E A208 
0137               
0138 6D40 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6D42 2F68 
0139 6D44 CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0140 6D46 1317  14         jeq   edb.line.pack.prepexit
0141                                                   ; Nothing to copy if empty line
0142                       ;------------------------------------------------------
0143                       ; 4. Copy line from framebuffer to editor buffer
0144                       ;------------------------------------------------------
0145               edb.line.pack.copyline:
0146 6D48 0286  22         ci    tmp2,2
     6D4A 0002 
0147 6D4C 1603  14         jne   edb.line.pack.copyline.checkbyte
0148 6D4E DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0149 6D50 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0150 6D52 1007  14         jmp   edb.line.pack.copyline.align16
0151               
0152               edb.line.pack.copyline.checkbyte:
0153 6D54 0286  22         ci    tmp2,1
     6D56 0001 
0154 6D58 1602  14         jne   edb.line.pack.copyline.block
0155 6D5A D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0156 6D5C 1002  14         jmp   edb.line.pack.copyline.align16
0157               
0158               edb.line.pack.copyline.block:
0159 6D5E 06A0  32         bl    @xpym2m               ; Copy memory block
     6D60 24B2 
0160                                                   ; \ i  tmp0 = source
0161                                                   ; | i  tmp1 = destination
0162                                                   ; / i  tmp2 = bytes to copy
0163                       ;------------------------------------------------------
0164                       ; 5: Align pointer to multiple of 16 memory address
0165                       ;------------------------------------------------------
0166               edb.line.pack.copyline.align16:
0167 6D62 A820  54         a     @rambuf+4,@edb.next_free.ptr
     6D64 2F68 
     6D66 A208 
0168                                                      ; Add length of line
0169               
0170 6D68 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6D6A A208 
0171 6D6C 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0172 6D6E 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6D70 000F 
0173 6D72 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6D74 A208 
0174                       ;------------------------------------------------------
0175                       ; 6: Restore SAMS page and prepare for exit
0176                       ;------------------------------------------------------
0177               edb.line.pack.prepexit:
0178 6D76 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6D78 2F64 
     6D7A A10C 
0179               
0180 6D7C 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6D7E A214 
     6D80 A212 
0181 6D82 1306  14         jeq   edb.line.pack.exit    ; Exit early if SAMS page already mapped
0182               
0183 6D84 C120  34         mov   @edb.sams.page,tmp0
     6D86 A212 
0184 6D88 C160  34         mov   @edb.top.ptr,tmp1
     6D8A A200 
0185 6D8C 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6D8E 2548 
0186                                                   ; \ i  tmp0 = SAMS page number
0187                                                   ; / i  tmp1 = Memory address
0188                       ;------------------------------------------------------
0189                       ; Exit
0190                       ;------------------------------------------------------
0191               edb.line.pack.exit:
0192 6D90 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 6D92 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6D94 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6D96 C2F9  30         mov   *stack+,r11           ; Pop R11
0196 6D98 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0148                       copy  "edb.line.unpack.asm" ; Unpack line from editor buffer
**** **** ****     > edb.line.unpack.asm
0001               * FILE......: edb.line.unpack.asm
0002               * Purpose...: Stevie Editor - Editor Buffer unpack line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          Stevie Editor - Editor Buffer unpack line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * edb.line.unpack
0011               * Unpack specified line to framebuffer
0012               ***************************************************************
0013               *  bl   @edb.line.unpack
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1 = Line to unpack in editor buffer
0017               * @parm2 = Target row in frame buffer
0018               *--------------------------------------------------------------
0019               * OUTPUT
0020               * @outparm1 = Length of unpacked line
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0,tmp1,tmp2
0024               *--------------------------------------------------------------
0025               * Memory usage
0026               * rambuf    = Saved @parm1 of edb.line.unpack
0027               * rambuf+2  = Saved @parm2 of edb.line.unpack
0028               * rambuf+4  = Source memory address in editor buffer
0029               * rambuf+6  = Destination memory address in frame buffer
0030               * rambuf+8  = Length of line
0031               ********|*****|*********************|**************************
0032               edb.line.unpack:
0033 6D9A 0649  14         dect  stack
0034 6D9C C64B  30         mov   r11,*stack            ; Save return address
0035 6D9E 0649  14         dect  stack
0036 6DA0 C644  30         mov   tmp0,*stack           ; Push tmp0
0037 6DA2 0649  14         dect  stack
0038 6DA4 C645  30         mov   tmp1,*stack           ; Push tmp1
0039 6DA6 0649  14         dect  stack
0040 6DA8 C646  30         mov   tmp2,*stack           ; Push tmp2
0041                       ;------------------------------------------------------
0042                       ; Sanity check
0043                       ;------------------------------------------------------
0044 6DAA 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6DAC 2F20 
     6DAE A204 
0045 6DB0 1204  14         jle   !
0046 6DB2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DB4 FFCE 
0047 6DB6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DB8 2030 
0048                       ;------------------------------------------------------
0049                       ; Save parameters
0050                       ;------------------------------------------------------
0051 6DBA C820  54 !       mov   @parm1,@rambuf
     6DBC 2F20 
     6DBE 2F64 
0052 6DC0 C820  54         mov   @parm2,@rambuf+2
     6DC2 2F22 
     6DC4 2F66 
0053                       ;------------------------------------------------------
0054                       ; Calculate offset in frame buffer
0055                       ;------------------------------------------------------
0056 6DC6 C120  34         mov   @fb.colsline,tmp0
     6DC8 A10E 
0057 6DCA 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6DCC 2F22 
0058 6DCE C1A0  34         mov   @fb.top.ptr,tmp2
     6DD0 A100 
0059 6DD2 A146  18         a     tmp2,tmp1             ; Add base to offset
0060 6DD4 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6DD6 2F6A 
0061                       ;------------------------------------------------------
0062                       ; Get pointer to line & page-in editor buffer page
0063                       ;------------------------------------------------------
0064 6DD8 C120  34         mov   @parm1,tmp0
     6DDA 2F20 
0065 6DDC 06A0  32         bl    @xmem.edb.sams.mappage
     6DDE 68CA 
0066                                                   ; Activate editor buffer SAMS page for line
0067                                                   ; \ i  tmp0     = Line number
0068                                                   ; | o  outparm1 = Pointer to line
0069                                                   ; / o  outparm2 = SAMS page
0070                       ;------------------------------------------------------
0071                       ; Handle empty line
0072                       ;------------------------------------------------------
0073 6DE0 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6DE2 2F30 
0074 6DE4 1603  14         jne   edb.line.unpack.getlen
0075                                                   ; Continue if pointer is set
0076               
0077 6DE6 04E0  34         clr   @rambuf+8             ; Set length=0
     6DE8 2F6C 
0078 6DEA 100C  14         jmp   edb.line.unpack.clear
0079                       ;------------------------------------------------------
0080                       ; Get line length
0081                       ;------------------------------------------------------
0082               edb.line.unpack.getlen:
0083 6DEC C174  30         mov   *tmp0+,tmp1           ; Get line length
0084 6DEE C804  38         mov   tmp0,@rambuf+4        ; Source memory address for block copy
     6DF0 2F68 
0085 6DF2 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6DF4 2F6C 
0086                       ;------------------------------------------------------
0087                       ; Sanity check on line length
0088                       ;------------------------------------------------------
0089 6DF6 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6DF8 0050 
0090 6DFA 1204  14         jle   edb.line.unpack.clear ; /
0091                       ;------------------------------------------------------
0092                       ; Crash the system
0093                       ;------------------------------------------------------
0094 6DFC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DFE FFCE 
0095 6E00 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E02 2030 
0096                       ;------------------------------------------------------
0097                       ; Erase chars from last column until column 80
0098                       ;------------------------------------------------------
0099               edb.line.unpack.clear:
0100 6E04 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6E06 2F6A 
0101 6E08 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6E0A 2F6C 
0102               
0103 6E0C 04C5  14         clr   tmp1                  ; Fill with >00
0104 6E0E C1A0  34         mov   @fb.colsline,tmp2
     6E10 A10E 
0105 6E12 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6E14 2F6C 
0106 6E16 0586  14         inc   tmp2
0107               
0108 6E18 06A0  32         bl    @xfilm                ; Fill CPU memory
     6E1A 224A 
0109                                                   ; \ i  tmp0 = Target address
0110                                                   ; | i  tmp1 = Byte to fill
0111                                                   ; / i  tmp2 = Repeat count
0112                       ;------------------------------------------------------
0113                       ; Prepare for unpacking data
0114                       ;------------------------------------------------------
0115               edb.line.unpack.prepare:
0116 6E1C C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6E1E 2F6C 
0117 6E20 130F  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0118 6E22 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6E24 2F68 
0119 6E26 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6E28 2F6A 
0120                       ;------------------------------------------------------
0121                       ; Sanity check on line length
0122                       ;------------------------------------------------------
0123               edb.line.unpack.copy:
0124 6E2A 0286  22         ci    tmp2,80               ; Check line length
     6E2C 0050 
0125 6E2E 1204  14         jle   !
0126                       ;------------------------------------------------------
0127                       ; Crash the system
0128                       ;------------------------------------------------------
0129 6E30 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E32 FFCE 
0130 6E34 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E36 2030 
0131                       ;------------------------------------------------------
0132                       ; Copy memory block
0133                       ;------------------------------------------------------
0134 6E38 C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6E3A 2F30 
0135               
0136 6E3C 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6E3E 24B2 
0137                                                   ; \ i  tmp0 = Source address
0138                                                   ; | i  tmp1 = Target address
0139                                                   ; / i  tmp2 = Bytes to copy
0140                       ;------------------------------------------------------
0141                       ; Exit
0142                       ;------------------------------------------------------
0143               edb.line.unpack.exit:
0144 6E40 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0145 6E42 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0146 6E44 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0147 6E46 C2F9  30         mov   *stack+,r11           ; Pop r11
0148 6E48 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0149                       copy  "edb.line.getlen.asm" ; Get line length
**** **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Stevie Editor - Editor Buffer get line length
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Stevie Editor - Editor Buffer get line length
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * edb.line.getlength
0011               * Get length of specified line
0012               ***************************************************************
0013               *  bl   @edb.line.getlength
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1 = Line number
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * @outparm1 = Length of line
0020               * @outparm2 = SAMS page
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0,tmp1
0024               ********|*****|*********************|**************************
0025               edb.line.getlength:
0026 6E4A 0649  14         dect  stack
0027 6E4C C64B  30         mov   r11,*stack            ; Push return address
0028 6E4E 0649  14         dect  stack
0029 6E50 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6E52 0649  14         dect  stack
0031 6E54 C645  30         mov   tmp1,*stack           ; Push tmp1
0032                       ;------------------------------------------------------
0033                       ; Initialisation
0034                       ;------------------------------------------------------
0035 6E56 04E0  34         clr   @outparm1             ; Reset length
     6E58 2F30 
0036 6E5A 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6E5C 2F32 
0037                       ;------------------------------------------------------
0038                       ; Map SAMS page
0039                       ;------------------------------------------------------
0040 6E5E C120  34         mov   @parm1,tmp0           ; Get line
     6E60 2F20 
0041               
0042 6E62 06A0  32         bl    @xmem.edb.sams.mappage
     6E64 68CA 
0043                                                   ; Activate editor buffer SAMS page for line
0044                                                   ; \ i  tmp0     = Line number
0045                                                   ; | o  outparm1 = Pointer to line
0046                                                   ; / o  outparm2 = SAMS page
0047               
0048 6E66 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     6E68 2F30 
0049 6E6A 130A  14         jeq   edb.line.getlength.null
0050                                                   ; Set length to 0 if null-pointer
0051                       ;------------------------------------------------------
0052                       ; Process line prefix
0053                       ;------------------------------------------------------
0054 6E6C C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0055 6E6E C805  38         mov   tmp1,@outparm1        ; Save length
     6E70 2F30 
0056                       ;------------------------------------------------------
0057                       ; Sanity check
0058                       ;------------------------------------------------------
0059 6E72 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     6E74 0050 
0060 6E76 1206  14         jle   edb.line.getlength.exit
0061                                                   ; Yes, exit
0062                       ;------------------------------------------------------
0063                       ; Crash the system
0064                       ;------------------------------------------------------
0065 6E78 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6E7A FFCE 
0066 6E7C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6E7E 2030 
0067                       ;------------------------------------------------------
0068                       ; Set length to 0 if null-pointer
0069                       ;------------------------------------------------------
0070               edb.line.getlength.null:
0071 6E80 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     6E82 2F30 
0072                       ;------------------------------------------------------
0073                       ; Exit
0074                       ;------------------------------------------------------
0075               edb.line.getlength.exit:
0076 6E84 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0077 6E86 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0078 6E88 C2F9  30         mov   *stack+,r11           ; Pop r11
0079 6E8A 045B  20         b     *r11                  ; Return to caller
0080               
0081               
0082               
0083               ***************************************************************
0084               * edb.line.getlength2
0085               * Get length of current row (as seen from editor buffer side)
0086               ***************************************************************
0087               *  bl   @edb.line.getlength2
0088               *--------------------------------------------------------------
0089               * INPUT
0090               * @fb.row = Row in frame buffer
0091               *--------------------------------------------------------------
0092               * OUTPUT
0093               * @fb.row.length = Length of row
0094               *--------------------------------------------------------------
0095               * Register usage
0096               * tmp0
0097               ********|*****|*********************|**************************
0098               edb.line.getlength2:
0099 6E8C 0649  14         dect  stack
0100 6E8E C64B  30         mov   r11,*stack            ; Save return address
0101 6E90 0649  14         dect  stack
0102 6E92 C644  30         mov   tmp0,*stack           ; Push tmp0
0103                       ;------------------------------------------------------
0104                       ; Calculate line in editor buffer
0105                       ;------------------------------------------------------
0106 6E94 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6E96 A104 
0107 6E98 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6E9A A106 
0108                       ;------------------------------------------------------
0109                       ; Get length
0110                       ;------------------------------------------------------
0111 6E9C C804  38         mov   tmp0,@parm1
     6E9E 2F20 
0112 6EA0 06A0  32         bl    @edb.line.getlength
     6EA2 6E4A 
0113 6EA4 C820  54         mov   @outparm1,@fb.row.length
     6EA6 2F30 
     6EA8 A108 
0114                                                   ; Save row length
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               edb.line.getlength2.exit:
0119 6EAA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0120 6EAC C2F9  30         mov   *stack+,r11           ; Pop R11
0121 6EAE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0150                       ;-----------------------------------------------------------------------
0151                       ; Command buffer handling
0152                       ;-----------------------------------------------------------------------
0153                       copy  "cmdb.asm"            ; Command buffer shared code
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
0027 6EB0 0649  14         dect  stack
0028 6EB2 C64B  30         mov   r11,*stack            ; Save return address
0029 6EB4 0649  14         dect  stack
0030 6EB6 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6EB8 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6EBA D000 
0035 6EBC C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6EBE A300 
0036               
0037 6EC0 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6EC2 A302 
0038 6EC4 0204  20         li    tmp0,4
     6EC6 0004 
0039 6EC8 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6ECA A306 
0040 6ECC C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6ECE A308 
0041               
0042 6ED0 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6ED2 A316 
0043 6ED4 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6ED6 A318 
0044 6ED8 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     6EDA A322 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6EDC 06A0  32         bl    @film
     6EDE 2244 
0049 6EE0 D000             data  cmdb.top,>00,cmdb.size
     6EE2 0000 
     6EE4 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6EE6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 6EE8 C2F9  30         mov   *stack+,r11           ; Pop r11
0057 6EEA 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               
0061               
0062               
0063               
0064               
0065               ***************************************************************
0066               * cmdb.refresh
0067               * Refresh command buffer content
0068               ***************************************************************
0069               * bl @cmdb.refresh
0070               *--------------------------------------------------------------
0071               * INPUT
0072               * none
0073               *--------------------------------------------------------------
0074               * OUTPUT
0075               * none
0076               *--------------------------------------------------------------
0077               * Register usage
0078               * none
0079               *--------------------------------------------------------------
0080               * Notes
0081               ********|*****|*********************|**************************
0082               cmdb.refresh:
0083 6EEC 0649  14         dect  stack
0084 6EEE C64B  30         mov   r11,*stack            ; Save return address
0085 6EF0 0649  14         dect  stack
0086 6EF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0087 6EF4 0649  14         dect  stack
0088 6EF6 C645  30         mov   tmp1,*stack           ; Push tmp1
0089 6EF8 0649  14         dect  stack
0090 6EFA C646  30         mov   tmp2,*stack           ; Push tmp2
0091                       ;------------------------------------------------------
0092                       ; Dump Command buffer content
0093                       ;------------------------------------------------------
0094 6EFC C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6EFE 832A 
     6F00 A30C 
0095 6F02 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6F04 A310 
     6F06 832A 
0096               
0097 6F08 05A0  34         inc   @wyx                  ; X +1 for prompt
     6F0A 832A 
0098               
0099 6F0C 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6F0E 2408 
0100                                                   ; \ i  @wyx = Cursor position
0101                                                   ; / o  tmp0 = VDP target address
0102               
0103 6F10 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6F12 A325 
0104 6F14 0206  20         li    tmp2,1*79             ; Command length
     6F16 004F 
0105               
0106 6F18 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6F1A 245E 
0107                                                   ; | i  tmp0 = VDP target address
0108                                                   ; | i  tmp1 = RAM source address
0109                                                   ; / i  tmp2 = Number of bytes to copy
0110                       ;------------------------------------------------------
0111                       ; Show command buffer prompt
0112                       ;------------------------------------------------------
0113 6F1C C820  54         mov   @cmdb.yxprompt,@wyx
     6F1E A310 
     6F20 832A 
0114 6F22 06A0  32         bl    @putstr
     6F24 242C 
0115 6F26 362C                   data txt.cmdb.prompt
0116               
0117 6F28 C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6F2A A30C 
     6F2C A114 
0118 6F2E C820  54         mov   @cmdb.yxsave,@wyx
     6F30 A30C 
     6F32 832A 
0119                                                   ; Restore YX position
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               cmdb.refresh.exit:
0124 6F34 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0125 6F36 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0126 6F38 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0127 6F3A C2F9  30         mov   *stack+,r11           ; Pop r11
0128 6F3C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0154                       copy  "cmdb.cmd.asm"        ; Command line handling
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
0026 6F3E 0649  14         dect  stack
0027 6F40 C64B  30         mov   r11,*stack            ; Save return address
0028 6F42 0649  14         dect  stack
0029 6F44 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6F46 0649  14         dect  stack
0031 6F48 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6F4A 0649  14         dect  stack
0033 6F4C C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Clear command
0036                       ;------------------------------------------------------
0037 6F4E 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6F50 A324 
0038 6F52 06A0  32         bl    @film                 ; Clear command
     6F54 2244 
0039 6F56 A325                   data  cmdb.cmd,>00,80
     6F58 0000 
     6F5A 0050 
0040                       ;------------------------------------------------------
0041                       ; Put cursor at beginning of line
0042                       ;------------------------------------------------------
0043 6F5C C120  34         mov   @cmdb.yxprompt,tmp0
     6F5E A310 
0044 6F60 0584  14         inc   tmp0
0045 6F62 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6F64 A30A 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               cmdb.cmd.clear.exit:
0050 6F66 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0051 6F68 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 6F6A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6F6C C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6F6E 045B  20         b     *r11                  ; Return to caller
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
0079 6F70 0649  14         dect  stack
0080 6F72 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;-------------------------------------------------------
0082                       ; Get length of null terminated string
0083                       ;-------------------------------------------------------
0084 6F74 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6F76 2A9A 
0085 6F78 A325                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6F7A 0000 
0086                                                  ; | i  p1    = Termination character
0087                                                  ; / o  waux1 = Length of string
0088 6F7C C820  54         mov   @waux1,@outparm1     ; Save length of string
     6F7E 833C 
     6F80 2F30 
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cmdb.cmd.getlength.exit:
0093 6F82 C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6F84 045B  20         b     *r11                  ; Return to caller
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
0119 6F86 0649  14         dect  stack
0120 6F88 C64B  30         mov   r11,*stack            ; Save return address
0121 6F8A 0649  14         dect  stack
0122 6F8C C644  30         mov   tmp0,*stack           ; Push tmp0
0123               
0124 6F8E 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6F90 6F70 
0125                                                   ; \ i  @cmdb.cmd
0126                                                   ; / o  @outparm1
0127                       ;------------------------------------------------------
0128                       ; Sanity check
0129                       ;------------------------------------------------------
0130 6F92 C120  34         mov   @outparm1,tmp0        ; Check length
     6F94 2F30 
0131 6F96 1300  14         jeq   cmdb.cmd.history.add.exit
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
0143 6F98 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 6F9A C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6F9C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0155                       copy  "errline.asm"         ; Error line
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
0026 6F9E 0649  14         dect  stack
0027 6FA0 C64B  30         mov   r11,*stack            ; Save return address
0028 6FA2 0649  14         dect  stack
0029 6FA4 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6FA6 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6FA8 A020 
0034               
0035 6FAA 06A0  32         bl    @film
     6FAC 2244 
0036 6FAE A022                   data tv.error.msg,0,160
     6FB0 0000 
     6FB2 00A0 
0037               
0038 6FB4 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6FB6 A000 
0039 6FB8 D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6FBA A022 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6FBC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6FBE C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6FC0 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.2405726
0156                       ;-----------------------------------------------------------------------
0157                       ; File handling
0158                       ;-----------------------------------------------------------------------
0159                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
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
0028 6FC2 0649  14         dect  stack
0029 6FC4 C64B  30         mov   r11,*stack            ; Save return address
0030 6FC6 0649  14         dect  stack
0031 6FC8 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6FCA 0649  14         dect  stack
0033 6FCC C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6FCE 0649  14         dect  stack
0035 6FD0 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6FD2 04E0  34         clr   @fh.records           ; Reset records counter
     6FD4 A43C 
0040 6FD6 04E0  34         clr   @fh.counter           ; Clear internal counter
     6FD8 A442 
0041 6FDA 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6FDC A440 
0042 6FDE 04E0  34         clr   @fh.kilobytes.prev    ; /
     6FE0 A458 
0043 6FE2 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6FE4 A438 
0044 6FE6 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6FE8 A43A 
0045               
0046 6FEA C120  34         mov   @edb.top.ptr,tmp0
     6FEC A200 
0047 6FEE 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6FF0 2510 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6FF2 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6FF4 833C 
     6FF6 A446 
0053 6FF8 C820  54         mov   @waux1,@fh.sams.hipage
     6FFA 833C 
     6FFC A448 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6FFE 0204  20         li    tmp0,fh.fopmode.readfile
     7000 0001 
0059                                                   ; We are going to read a file
0060 7002 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     7004 A44A 
0061               
0062 7006 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     7008 2F20 
     700A A444 
0063 700C C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     700E 2F22 
     7010 A450 
0064 7012 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     7014 2F24 
     7016 A452 
0065 7018 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     701A 2F26 
     701C A454 
0066 701E C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     7020 2F28 
     7022 A456 
0067                       ;------------------------------------------------------
0068                       ; Sanity checks
0069                       ;------------------------------------------------------
0070 7024 C120  34         mov   @fh.callback1,tmp0
     7026 A450 
0071 7028 0284  22         ci    tmp0,>6000            ; Insane address ?
     702A 6000 
0072 702C 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 702E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7030 7FFF 
0075 7032 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 7034 C120  34         mov   @fh.callback2,tmp0
     7036 A452 
0078 7038 0284  22         ci    tmp0,>6000            ; Insane address ?
     703A 6000 
0079 703C 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 703E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7040 7FFF 
0082 7042 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 7044 C120  34         mov   @fh.callback3,tmp0
     7046 A454 
0085 7048 0284  22         ci    tmp0,>6000            ; Insane address ?
     704A 6000 
0086 704C 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0087               
0088 704E 0284  22         ci    tmp0,>7fff            ; Insane address ?
     7050 7FFF 
0089 7052 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 7054 1004  14         jmp   fh.file.read.edb.load1
0092                                                   ; All checks passed, continue
0093                       ;------------------------------------------------------
0094                       ; Check failed, crash CPU!
0095                       ;------------------------------------------------------
0096               fh.file.read.crash:
0097 7056 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7058 FFCE 
0098 705A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     705C 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.read.edb.load1:
0103 705E C120  34         mov   @fh.callback1,tmp0
     7060 A450 
0104 7062 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.pabheader:
0109 7064 06A0  32         bl    @cpym2v
     7066 2458 
0110 7068 0A60                   data fh.vpab,fh.file.pab.header,9
     706A 71EA 
     706C 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 706E 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     7070 0A69 
0116 7072 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     7074 A444 
0117 7076 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 7078 0986  56         srl   tmp2,8                ; Right justify
0119 707A 0586  14         inc   tmp2                  ; Include length byte as well
0120               
0121 707C 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     707E 245E 
0122                                                   ; \ i  tmp0 = VDP destination
0123                                                   ; | i  tmp1 = CPU source
0124                                                   ; / i  tmp2 = Number of bytes to copy
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 7080 06A0  32         bl    @file.open            ; Open file
     7082 2C5E 
0129 7084 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0130 7086 0014                   data io.seq.inp.dis.var
0131                                                   ; / i  p1 = File type/mode
0132               
0133 7088 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     708A 2026 
0134 708C 1602  14         jne   fh.file.read.edb.check_setpage
0135               
0136 708E 0460  28         b     @fh.file.read.edb.error
     7090 719E 
0137                                                   ; Yes, IO error occured
0138                       ;------------------------------------------------------
0139                       ; 1a: Check if SAMS page needs to be increased
0140                       ;------------------------------------------------------
0141               fh.file.read.edb.check_setpage:
0142 7092 C120  34         mov   @edb.next_free.ptr,tmp0
     7094 A208 
0143                                                   ;--------------------------
0144                                                   ; Sanity check
0145                                                   ;--------------------------
0146 7096 0284  22         ci    tmp0,edb.top + edb.size
     7098 D000 
0147                                                   ; Insane address ?
0148 709A 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0149                                                   ;--------------------------
0150                                                   ; Check for page overflow
0151                                                   ;--------------------------
0152 709C 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     709E 0FFF 
0153 70A0 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     70A2 0052 
0154 70A4 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     70A6 0FF0 
0155 70A8 110E  14         jlt   fh.file.read.edb.record
0156                                                   ; Not yet so skip SAMS page switch
0157                       ;------------------------------------------------------
0158                       ; 1b: Increase SAMS page
0159                       ;------------------------------------------------------
0160 70AA 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     70AC A446 
0161 70AE C820  54         mov   @fh.sams.page,@fh.sams.hipage
     70B0 A446 
     70B2 A448 
0162                                                   ; Set highest SAMS page
0163 70B4 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     70B6 A200 
     70B8 A208 
0164                                                   ; Start at top of SAMS page again
0165                       ;------------------------------------------------------
0166                       ; 1c: Switch to SAMS page
0167                       ;------------------------------------------------------
0168 70BA C120  34         mov   @fh.sams.page,tmp0
     70BC A446 
0169 70BE C160  34         mov   @edb.top.ptr,tmp1
     70C0 A200 
0170 70C2 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     70C4 2548 
0171                                                   ; \ i  tmp0 = SAMS page number
0172                                                   ; / i  tmp1 = Memory address
0173                       ;------------------------------------------------------
0174                       ; 1d: Fill new SAMS page with garbage (debug only)
0175                       ;------------------------------------------------------
0176                       ; bl  @film
0177                       ;     data >c000,>99,4092
0178                       ;------------------------------------------------------
0179                       ; Step 2: Read file record
0180                       ;------------------------------------------------------
0181               fh.file.read.edb.record:
0182 70C6 05A0  34         inc   @fh.records           ; Update counter
     70C8 A43C 
0183 70CA 04E0  34         clr   @fh.reclen            ; Reset record length
     70CC A43E 
0184               
0185 70CE 0760  38         abs   @fh.offsetopcode
     70D0 A44E 
0186 70D2 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0187                       ;------------------------------------------------------
0188                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0189                       ;------------------------------------------------------
0190 70D4 C160  34         mov   @edb.next_free.ptr,tmp1
     70D6 A208 
0191 70D8 05C5  14         inct  tmp1
0192 70DA 0204  20         li    tmp0,fh.vpab + 2
     70DC 0A62 
0193               
0194 70DE 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     70E0 4000 
0195 70E2 06C4  14         swpb  tmp0                  ; \
0196 70E4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     70E6 8C02 
0197 70E8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0198 70EA D804  38         movb  tmp0,@vdpa            ; /
     70EC 8C02 
0199               
0200 70EE D7C5  30         movb  tmp1,*r15             ; Write MSB
0201 70F0 06C5  14         swpb  tmp1
0202 70F2 D7C5  30         movb  tmp1,*r15             ; Write LSB
0203                       ;------------------------------------------------------
0204                       ; 2b: Read file record
0205                       ;------------------------------------------------------
0206 70F4 06A0  32 !       bl    @file.record.read     ; Read file record
     70F6 2C8E 
0207 70F8 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0208                                                   ; |           (without +9 offset!)
0209                                                   ; | o  tmp0 = Status byte
0210                                                   ; | o  tmp1 = Bytes read
0211                                                   ; | o  tmp2 = Status register contents
0212                                                   ; /           upon DSRLNK return
0213               
0214 70FA C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     70FC A438 
0215 70FE C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     7100 A43E 
0216 7102 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7104 A43A 
0217                       ;------------------------------------------------------
0218                       ; 2c: Calculate kilobytes processed
0219                       ;------------------------------------------------------
0220 7106 A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     7108 A442 
0221 710A C160  34         mov   @fh.counter,tmp1      ;
     710C A442 
0222 710E 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     7110 0400 
0223 7112 1106  14         jlt   fh.file.read.edb.check_fioerr
0224                                                   ; Not yet, goto (2d)
0225 7114 05A0  34         inc   @fh.kilobytes
     7116 A440 
0226 7118 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     711A FC00 
0227 711C C805  38         mov   tmp1,@fh.counter      ; Update counter
     711E A442 
0228                       ;------------------------------------------------------
0229                       ; 2d: Check if a file error occured
0230                       ;------------------------------------------------------
0231               fh.file.read.edb.check_fioerr:
0232 7120 C1A0  34         mov   @fh.ioresult,tmp2
     7122 A43A 
0233 7124 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7126 2026 
0234 7128 1602  14         jne   fh.file.read.edb.process_line
0235                                                   ; No, goto (3)
0236 712A 0460  28         b     @fh.file.read.edb.error
     712C 719E 
0237                                                   ; Yes, so handle file error
0238                       ;------------------------------------------------------
0239                       ; Step 3: Process line
0240                       ;------------------------------------------------------
0241               fh.file.read.edb.process_line:
0242 712E 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     7130 0960 
0243 7132 C160  34         mov   @edb.next_free.ptr,tmp1
     7134 A208 
0244                                                   ; RAM target in editor buffer
0245               
0246 7136 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     7138 2F22 
0247               
0248 713A C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     713C A43E 
0249 713E 131D  14         jeq   fh.file.read.edb.prepindex.emptyline
0250                                                   ; Handle empty line
0251                       ;------------------------------------------------------
0252                       ; 3a: Set length of line in CPU editor buffer
0253                       ;------------------------------------------------------
0254 7140 04D5  26         clr   *tmp1                 ; Clear word before string
0255 7142 0585  14         inc   tmp1                  ; Adjust position for length byte string
0256 7144 DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     7146 A43F 
0257               
0258 7148 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     714A A208 
0259 714C A806  38         a     tmp2,@edb.next_free.ptr
     714E A208 
0260                                                   ; Add line length
0261               
0262 7150 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     7152 A44E 
0263 7154 1602  14         jne   fh.file.read.edb.preppointer
0264                       ;------------------------------------------------------
0265                       ; 3b: Copy line from VDP to CPU editor buffer
0266                       ;------------------------------------------------------
0267               fh.file.read.edb.vdp2cpu:
0268                       ;
0269                       ; Executed for devices that need their disk buffer in VDP memory
0270                       ; (TI Disk Controller, tipi, nanopeb, ...).
0271                       ;
0272 7156 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     7158 2490 
0273                                                   ; \ i  tmp0 = VDP source address
0274                                                   ; | i  tmp1 = RAM target address
0275                                                   ; / i  tmp2 = Bytes to copy
0276                       ;------------------------------------------------------
0277                       ; 3c: Align pointer for next line
0278                       ;------------------------------------------------------
0279               fh.file.read.edb.preppointer:
0280 715A C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     715C A208 
0281 715E 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0282 7160 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7162 000F 
0283 7164 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7166 A208 
0284                       ;------------------------------------------------------
0285                       ; Step 4: Update index
0286                       ;------------------------------------------------------
0287               fh.file.read.edb.prepindex:
0288 7168 C820  54         mov   @edb.lines,@parm1     ; \ parm1 = Line number - 1
     716A A204 
     716C 2F20 
0289 716E 0620  34         dec   @parm1                ; /
     7170 2F20 
0290               
0291                                                   ; parm2 = Must allready be set!
0292 7172 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7174 A446 
     7176 2F24 
0293               
0294 7178 1009  14         jmp   fh.file.read.edb.updindex
0295                                                   ; Update index
0296                       ;------------------------------------------------------
0297                       ; 4a: Special handling for empty line
0298                       ;------------------------------------------------------
0299               fh.file.read.edb.prepindex.emptyline:
0300 717A C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     717C A43C 
     717E 2F20 
0301 7180 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7182 2F20 
0302 7184 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7186 2F22 
0303 7188 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     718A 2F24 
0304                       ;------------------------------------------------------
0305                       ; 4b: Do actual index update
0306                       ;------------------------------------------------------
0307               fh.file.read.edb.updindex:
0308 718C 06A0  32         bl    @idx.entry.update     ; Update index
     718E 6B06 
0309                                                   ; \ i  parm1    = Line num in editor buffer
0310                                                   ; | i  parm2    = Pointer to line in editor
0311                                                   ; |               buffer
0312                                                   ; | i  parm3    = SAMS page
0313                                                   ; | o  outparm1 = Pointer to updated index
0314                                                   ; /               entry
0315               
0316 7190 05A0  34         inc   @edb.lines            ; lines=lines+1
     7192 A204 
0317                       ;------------------------------------------------------
0318                       ; Step 5: Callback "Read line from file"
0319                       ;------------------------------------------------------
0320               fh.file.read.edb.display:
0321 7194 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     7196 A452 
0322 7198 0694  24         bl    *tmp0                 ; Run callback function
0323                       ;------------------------------------------------------
0324                       ; 5a: Next record
0325                       ;------------------------------------------------------
0326               fh.file.read.edb.next:
0327 719A 0460  28         b     @fh.file.read.edb.check_setpage
     719C 7092 
0328                                                   ; Next record
0329                       ;------------------------------------------------------
0330                       ; Error handler
0331                       ;------------------------------------------------------
0332               fh.file.read.edb.error:
0333 719E C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     71A0 A438 
0334 71A2 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0335 71A4 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     71A6 0005 
0336 71A8 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0337                       ;------------------------------------------------------
0338                       ; File error occured
0339                       ;------------------------------------------------------
0340 71AA 06A0  32         bl    @file.close           ; Close file
     71AC 2C82 
0341 71AE 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0342               
0343 71B0 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     71B2 68A8 
0344                       ;------------------------------------------------------
0345                       ; Callback "File I/O error"
0346                       ;------------------------------------------------------
0347 71B4 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     71B6 A456 
0348 71B8 0694  24         bl    *tmp0                 ; Run callback function
0349 71BA 100D  14         jmp   fh.file.read.edb.exit
0350                       ;------------------------------------------------------
0351                       ; End-Of-File reached
0352                       ;------------------------------------------------------
0353               fh.file.read.edb.eof:
0354 71BC 06A0  32         bl    @file.close           ; Close file
     71BE 2C82 
0355 71C0 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0356               
0357 71C2 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     71C4 68A8 
0358                       ;------------------------------------------------------
0359                       ; Callback "Close file"
0360                       ;------------------------------------------------------
0361 71C6 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     71C8 A454 
0362 71CA 0694  24         bl    *tmp0                 ; Run callback function
0363               
0364 71CC C120  34         mov   @edb.lines,tmp0       ; Get number of lines
     71CE A204 
0365 71D0 1302  14         jeq   fh.file.read.edb.exit ; Exit if lines = 0
0366 71D2 0620  34         dec   @edb.lines            ; One-time adjustment
     71D4 A204 
0367               *--------------------------------------------------------------
0368               * Exit
0369               *--------------------------------------------------------------
0370               fh.file.read.edb.exit:
0371 71D6 C820  54         mov   @fh.sams.hipage,@edb.sams.hipage
     71D8 A448 
     71DA A214 
0372                                                   ; Set highest SAMS page in use
0373 71DC 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     71DE A44A 
0374               
0375 71E0 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0376 71E2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0377 71E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0378 71E6 C2F9  30         mov   *stack+,r11           ; Pop R11
0379 71E8 045B  20         b     *r11                  ; Return to caller
0380               
0381               
0382               ***************************************************************
0383               * PAB for accessing DV/80 file
0384               ********|*****|*********************|**************************
0385               fh.file.pab.header:
0386 71EA 0014             byte  io.op.open            ;  0    - OPEN
0387                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0388 71EC 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0389 71EE 5000             byte  80                    ;  4    - Record length (80 chars max)
0390                       byte  00                    ;  5    - Character count
0391 71F0 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0392 71F2 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0393                       ;------------------------------------------------------
0394                       ; File descriptor part (variable length)
0395                       ;------------------------------------------------------
0396                       ; byte  12                  ;  9    - File descriptor length
0397                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0398                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.2405726
0160                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
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
0028 71F4 0649  14         dect  stack
0029 71F6 C64B  30         mov   r11,*stack            ; Save return address
0030 71F8 0649  14         dect  stack
0031 71FA C644  30         mov   tmp0,*stack           ; Push tmp0
0032 71FC 0649  14         dect  stack
0033 71FE C645  30         mov   tmp1,*stack           ; Push tmp1
0034 7200 0649  14         dect  stack
0035 7202 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 7204 04E0  34         clr   @fh.records           ; Reset records counter
     7206 A43C 
0040 7208 04E0  34         clr   @fh.counter           ; Clear internal counter
     720A A442 
0041 720C 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     720E A440 
0042 7210 04E0  34         clr   @fh.kilobytes.prev    ; /
     7212 A458 
0043 7214 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     7216 A438 
0044 7218 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     721A A43A 
0045                       ;------------------------------------------------------
0046                       ; Save parameters / callback functions
0047                       ;------------------------------------------------------
0048 721C 0204  20         li    tmp0,fh.fopmode.writefile
     721E 0002 
0049                                                   ; We are going to write to a file
0050 7220 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     7222 A44A 
0051               
0052 7224 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     7226 2F20 
     7228 A444 
0053 722A C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     722C 2F22 
     722E A450 
0054 7230 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     7232 2F24 
     7234 A452 
0055 7236 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     7238 2F26 
     723A A454 
0056 723C C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     723E 2F28 
     7240 A456 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 7242 C120  34         mov   @fh.callback1,tmp0
     7244 A450 
0061 7246 0284  22         ci    tmp0,>6000            ; Insane address ?
     7248 6000 
0062 724A 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0063               
0064 724C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     724E 7FFF 
0065 7250 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0066               
0067 7252 C120  34         mov   @fh.callback2,tmp0
     7254 A452 
0068 7256 0284  22         ci    tmp0,>6000            ; Insane address ?
     7258 6000 
0069 725A 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0070               
0071 725C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     725E 7FFF 
0072 7260 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0073               
0074 7262 C120  34         mov   @fh.callback3,tmp0
     7264 A454 
0075 7266 0284  22         ci    tmp0,>6000            ; Insane address ?
     7268 6000 
0076 726A 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0077               
0078 726C 0284  22         ci    tmp0,>7fff            ; Insane address ?
     726E 7FFF 
0079 7270 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0080               
0081 7272 1004  14         jmp   fh.file.write.edb.save1
0082                                                   ; All checks passed, continue.
0083                       ;------------------------------------------------------
0084                       ; Check failed, crash CPU!
0085                       ;------------------------------------------------------
0086               fh.file.write.crash:
0087 7274 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7276 FFCE 
0088 7278 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     727A 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.write.edb.save1:
0093 727C C120  34         mov   @fh.callback1,tmp0
     727E A450 
0094 7280 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.write.edb.pabheader:
0099 7282 06A0  32         bl    @cpym2v
     7284 2458 
0100 7286 0A60                   data fh.vpab,fh.file.pab.header,9
     7288 71EA 
     728A 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 728C 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     728E 0A69 
0106 7290 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     7292 A444 
0107 7294 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 7296 0986  56         srl   tmp2,8                ; Right justify
0109 7298 0586  14         inc   tmp2                  ; Include length byte as well
0110               
0111 729A 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     729C 245E 
0112                                                   ; \ i  tmp0 = VDP destination
0113                                                   ; | i  tmp1 = CPU source
0114                                                   ; / i  tmp2 = Number of bytes to copy
0115                       ;------------------------------------------------------
0116                       ; Open file
0117                       ;------------------------------------------------------
0118 729E 06A0  32         bl    @file.open            ; Open file
     72A0 2C5E 
0119 72A2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0120 72A4 0012                   data io.seq.out.dis.var
0121                                                   ; / i  p1 = File type/mode
0122               
0123 72A6 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     72A8 2026 
0124 72AA 1338  14         jeq   fh.file.write.edb.error
0125                                                   ; Yes, IO error occured
0126                       ;------------------------------------------------------
0127                       ; Step 1: Write file record
0128                       ;------------------------------------------------------
0129               fh.file.write.edb.record:
0130 72AC 8820  54         c     @fh.records,@edb.lines
     72AE A43C 
     72B0 A204 
0131 72B2 133E  14         jeq   fh.file.write.edb.done
0132                                                   ; Exit when all records processed
0133                       ;------------------------------------------------------
0134                       ; 1a: Unpack current line to framebuffer
0135                       ;------------------------------------------------------
0136 72B4 C820  54         mov   @fh.records,@parm1    ; Line to unpack
     72B6 A43C 
     72B8 2F20 
0137 72BA 04E0  34         clr   @parm2                ; 1st row in frame buffer
     72BC 2F22 
0138               
0139 72BE 06A0  32         bl    @edb.line.unpack      ; Unpack line
     72C0 6D9A 
0140                                                   ; \ i  parm1    = Line to unpack
0141                                                   ; | i  parm2    = Target row in frame buffer
0142                                                   ; / o  outparm1 = Length of line
0143                       ;------------------------------------------------------
0144                       ; 1b: Copy unpacked line to VDP memory
0145                       ;------------------------------------------------------
0146 72C2 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     72C4 0960 
0147 72C6 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     72C8 A600 
0148               
0149 72CA C1A0  34         mov   @outparm1,tmp2        ; Length of line
     72CC 2F30 
0150 72CE C806  38         mov   tmp2,@fh.reclen       ; Set record length
     72D0 A43E 
0151 72D2 1302  14         jeq   !                     ; Skip VDP copy if empty line
0152               
0153 72D4 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     72D6 245E 
0154                                                   ; \ i  tmp0 = VDP target address
0155                                                   ; | i  tmp1 = CPU source address
0156                                                   ; / i  tmp2 = Number of bytes to copy
0157                       ;------------------------------------------------------
0158                       ; 1c: Write file record
0159                       ;------------------------------------------------------
0160 72D8 06A0  32 !       bl    @file.record.write    ; Write file record
     72DA 2C9A 
0161 72DC 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0162                                                   ; |           (without +9 offset!)
0163                                                   ; | o  tmp0 = Status byte
0164                                                   ; | o  tmp1 = ?????
0165                                                   ; | o  tmp2 = Status register contents
0166                                                   ; /           upon DSRLNK return
0167               
0168 72DE C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     72E0 A438 
0169 72E2 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     72E4 A43A 
0170                       ;------------------------------------------------------
0171                       ; 1d: Calculate kilobytes processed
0172                       ;------------------------------------------------------
0173 72E6 A820  54         a     @fh.reclen,@fh.counter
     72E8 A43E 
     72EA A442 
0174                                                   ; Add record length to counter
0175 72EC C160  34         mov   @fh.counter,tmp1      ;
     72EE A442 
0176 72F0 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     72F2 0400 
0177 72F4 1106  14         jlt   fh.file.write.edb.check_fioerr
0178                                                   ; Not yet, goto (1e)
0179 72F6 05A0  34         inc   @fh.kilobytes
     72F8 A440 
0180 72FA 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     72FC FC00 
0181 72FE C805  38         mov   tmp1,@fh.counter      ; Update counter
     7300 A442 
0182                       ;------------------------------------------------------
0183                       ; 1e: Check if a file error occured
0184                       ;------------------------------------------------------
0185               fh.file.write.edb.check_fioerr:
0186 7302 C1A0  34         mov   @fh.ioresult,tmp2
     7304 A43A 
0187 7306 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7308 2026 
0188 730A 1602  14         jne   fh.file.write.edb.display
0189                                                   ; No, goto (2)
0190 730C 0460  28         b     @fh.file.write.edb.error
     730E 731C 
0191                                                   ; Yes, so handle file error
0192                       ;------------------------------------------------------
0193                       ; Step 2: Callback "Write line to  file"
0194                       ;------------------------------------------------------
0195               fh.file.write.edb.display:
0196 7310 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     7312 A452 
0197 7314 0694  24         bl    *tmp0                 ; Run callback function
0198                       ;------------------------------------------------------
0199                       ; Step 3: Next record
0200                       ;------------------------------------------------------
0201 7316 05A0  34         inc   @fh.records           ; Update counter
     7318 A43C 
0202 731A 10C8  14         jmp   fh.file.write.edb.record
0203                       ;------------------------------------------------------
0204                       ; Error handler
0205                       ;------------------------------------------------------
0206               fh.file.write.edb.error:
0207 731C C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     731E A438 
0208 7320 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0209                       ;------------------------------------------------------
0210                       ; File error occured
0211                       ;------------------------------------------------------
0212 7322 06A0  32         bl    @file.close           ; Close file
     7324 2C82 
0213 7326 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0214                       ;------------------------------------------------------
0215                       ; Callback "File I/O error"
0216                       ;------------------------------------------------------
0217 7328 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     732A A456 
0218 732C 0694  24         bl    *tmp0                 ; Run callback function
0219 732E 1006  14         jmp   fh.file.write.edb.exit
0220                       ;------------------------------------------------------
0221                       ; All records written. Close file
0222                       ;------------------------------------------------------
0223               fh.file.write.edb.done:
0224 7330 06A0  32         bl    @file.close           ; Close file
     7332 2C82 
0225 7334 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0226                       ;------------------------------------------------------
0227                       ; Callback "Close file"
0228                       ;------------------------------------------------------
0229 7336 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7338 A454 
0230 733A 0694  24         bl    *tmp0                 ; Run callback function
0231               *--------------------------------------------------------------
0232               * Exit
0233               *--------------------------------------------------------------
0234               fh.file.write.edb.exit:
0235 733C 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     733E A44A 
0236 7340 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0237 7342 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0238 7344 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0239 7346 C2F9  30         mov   *stack+,r11           ; Pop R11
0240 7348 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0161                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
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
0022 734A 0649  14         dect  stack
0023 734C C64B  30         mov   r11,*stack            ; Save return address
0024 734E 0649  14         dect  stack
0025 7350 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7352 0649  14         dect  stack
0027 7354 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" and exit if buffer dirty
0030                       ;-------------------------------------------------------
0031 7356 C160  34         mov   @edb.dirty,tmp1
     7358 A206 
0032 735A 1305  14         jeq   !
0033 735C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0034 735E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0035 7360 C2F9  30         mov   *stack+,r11           ; Pop R11
0036 7362 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7364 7ED8 
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 7366 C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     7368 2F20 
0041 736A 06A0  32         bl    @tv.reset             ; Reset editor
     736C 688C 
0042 736E C820  54         mov   @parm1,@edb.filename.ptr
     7370 2F20 
     7372 A20E 
0043                                                   ; Set filename
0044                       ;-------------------------------------------------------
0045                       ; Clear VDP screen buffer
0046                       ;-------------------------------------------------------
0047 7374 06A0  32         bl    @filv
     7376 229C 
0048 7378 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     737A 0000 
     737C 0004 
0049               
0050 737E C160  34         mov   @fb.scrrows,tmp1
     7380 A118 
0051 7382 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7384 A10E 
0052                                                   ; 16 bit part is in tmp2!
0053               
0054 7386 06A0  32         bl    @scroff               ; Turn off screen
     7388 2660 
0055               
0056 738A 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0057 738C 0205  20         li    tmp1,32               ; Character to fill
     738E 0020 
0058               
0059 7390 06A0  32         bl    @xfilv                ; Fill VDP memory
     7392 22A2 
0060                                                   ; \ i  tmp0 = VDP target address
0061                                                   ; | i  tmp1 = Byte to fill
0062                                                   ; / i  tmp2 = Bytes to copy
0063               
0064 7394 06A0  32         bl    @pane.action.colorscheme.Load
     7396 7950 
0065                                                   ; Load color scheme and turn on screen
0066                       ;-------------------------------------------------------
0067                       ; Read DV80 file and display
0068                       ;-------------------------------------------------------
0069 7398 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     739A 745A 
0070 739C C804  38         mov   tmp0,@parm2           ; Register callback 1
     739E 2F22 
0071               
0072 73A0 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     73A2 74D2 
0073 73A4 C804  38         mov   tmp0,@parm3           ; Register callback 2
     73A6 2F24 
0074               
0075 73A8 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     73AA 7548 
0076 73AC C804  38         mov   tmp0,@parm4           ; Register callback 3
     73AE 2F26 
0077               
0078 73B0 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     73B2 758E 
0079 73B4 C804  38         mov   tmp0,@parm5           ; Register callback 4
     73B6 2F28 
0080               
0081 73B8 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     73BA 6FC2 
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
0093 73BC 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     73BE A206 
0094                                                   ; longer dirty.
0095               
0096 73C0 0204  20         li    tmp0,txt.filetype.DV80
     73C2 335C 
0097 73C4 C804  38         mov   tmp0,@edb.filetype.ptr
     73C6 A210 
0098                                                   ; Set filetype display string
0099               *--------------------------------------------------------------
0100               * Exit
0101               *--------------------------------------------------------------
0102               fm.loadfile.exit:
0103 73C8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 73CA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 73CC C2F9  30         mov   *stack+,r11           ; Pop R11
0106 73CE 045B  20         b     *r11                  ; Return to caller
0107               
0108               
0109               ***************************************************************
0110               * fm.fastmode
0111               * Turn on fast mode for supported devices
0112               ***************************************************************
0113               * bl  @fm.fastmode
0114               *--------------------------------------------------------------
0115               * INPUT
0116               * none
0117               *---------------------------------------------------------------
0118               * OUTPUT
0119               * none
0120               *--------------------------------------------------------------
0121               * Register usage
0122               * tmp0, tmp1
0123               ********|*****|*********************|**************************
0124               fm.fastmode:
0125 73D0 0649  14         dect  stack
0126 73D2 C64B  30         mov   r11,*stack            ; Save return address
0127 73D4 0649  14         dect  stack
0128 73D6 C644  30         mov   tmp0,*stack           ; Push tmp0
0129               
0130 73D8 C120  34         mov   @fh.offsetopcode,tmp0
     73DA A44E 
0131 73DC 1307  14         jeq   !
0132                       ;------------------------------------------------------
0133                       ; Turn fast mode off
0134                       ;------------------------------------------------------
0135 73DE 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     73E0 A44E 
0136 73E2 0204  20         li    tmp0,txt.keys.load
     73E4 33CC 
0137 73E6 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     73E8 A320 
0138 73EA 1008  14         jmp   fm.fastmode.exit
0139                       ;------------------------------------------------------
0140                       ; Turn fast mode on
0141                       ;------------------------------------------------------
0142 73EC 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     73EE 0040 
0143 73F0 C804  38         mov   tmp0,@fh.offsetopcode
     73F2 A44E 
0144 73F4 0204  20         li    tmp0,txt.keys.load2
     73F6 3404 
0145 73F8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     73FA A320 
0146               *--------------------------------------------------------------
0147               * Exit
0148               *--------------------------------------------------------------
0149               fm.fastmode.exit:
0150 73FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 73FE C2F9  30         mov   *stack+,r11           ; Pop R11
0152 7400 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0162                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
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
0022 7402 0649  14         dect  stack
0023 7404 C64B  30         mov   r11,*stack            ; Save return address
0024 7406 0649  14         dect  stack
0025 7408 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 740A 0649  14         dect  stack
0027 740C C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Save DV80 file
0030                       ;-------------------------------------------------------
0031 740E C804  38         mov   tmp0,@parm1           ; Set device and filename
     7410 2F20 
0032               
0033 7412 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7414 745A 
0034 7416 C804  38         mov   tmp0,@parm2           ; Register callback 1
     7418 2F22 
0035               
0036 741A 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     741C 74D2 
0037 741E C804  38         mov   tmp0,@parm3           ; Register callback 2
     7420 2F24 
0038               
0039 7422 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     7424 7548 
0040 7426 C804  38         mov   tmp0,@parm4           ; Register callback 3
     7428 2F26 
0041               
0042 742A 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     742C 758E 
0043 742E C804  38         mov   tmp0,@parm5           ; Register callback 4
     7430 2F28 
0044               
0045 7432 C820  54         mov   @parm1,@edb.filename.ptr
     7434 2F20 
     7436 A20E 
0046                                                   ; Set current filename
0047               
0048 7438 06A0  32         bl    @filv
     743A 229C 
0049 743C 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     743E 0000 
     7440 0004 
0050               
0051 7442 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     7444 71F4 
0052                                                   ; \ i  parm1 = Pointer to length prefixed
0053                                                   ; |            file descriptor
0054                                                   ; | i  parm2 = Pointer to callback
0055                                                   ; |            "loading indicator 1"
0056                                                   ; | i  parm3 = Pointer to callback
0057                                                   ; |            "loading indicator 2"
0058                                                   ; | i  parm4 = Pointer to callback
0059                                                   ; |            "loading indicator 3"
0060                                                   ; | i  parm5 = Pointer to callback
0061                                                   ; /            "File I/O error handler"
0062               
0063 7446 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     7448 A206 
0064                                                   ; longer dirty.
0065               
0066 744A 0204  20         li    tmp0,txt.filetype.DV80
     744C 335C 
0067 744E C804  38         mov   tmp0,@edb.filetype.ptr
     7450 A210 
0068                                                   ; Set filetype display string
0069               *--------------------------------------------------------------
0070               * Exit
0071               *--------------------------------------------------------------
0072               fm.savefile.exit:
0073 7452 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0074 7454 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 7456 C2F9  30         mov   *stack+,r11           ; Pop R11
0076 7458 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0163                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
0011 745A 0649  14         dect  stack
0012 745C C64B  30         mov   r11,*stack            ; Save return address
0013 745E 0649  14         dect  stack
0014 7460 C644  30         mov   tmp0,*stack           ; Push tmp0
0015 7462 0649  14         dect  stack
0016 7464 C645  30         mov   tmp1,*stack           ; Push tmp1
0017 7466 0649  14         dect  stack
0018 7468 C660  46         mov   @parm1,*stack         ; Push @parm1
     746A 2F20 
0019                       ;------------------------------------------------------
0020                       ; Check file operation mode
0021                       ;------------------------------------------------------
0022 746C 06A0  32         bl    @hchar
     746E 2794 
0023 7470 1D00                   byte pane.botrow,0,32,80
     7472 2050 
0024 7474 FFFF                   data EOL              ; Clear until end of line
0025               
0026 7476 C820  54         mov   @tv.busycolor,@parm1
     7478 A01A 
     747A 2F20 
0027 747C 06A0  32         bl    @pane.action.colorcombo.botline
     747E 7A52 
0028                                                   ; Load color combinaton for bottom line
0029                                                   ; \ i  @parm1 = Color combination
0030                                                   ; /
0031               
0032 7480 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     7482 A44A 
0033               
0034 7484 0284  22         ci    tmp0,fh.fopmode.writefile
     7486 0002 
0035 7488 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0036                                                   ; Saving file?
0037               
0038 748A 0284  22         ci    tmp0,fh.fopmode.readfile
     748C 0001 
0039 748E 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0040                                                   ; Loading file?
0041                       ;------------------------------------------------------
0042                       ; Display Saving....
0043                       ;------------------------------------------------------
0044               fm.loadsave.cb.indicator1.saving:
0045 7490 06A0  32         bl    @putat
     7492 2450 
0046 7494 1D00                   byte pane.botrow,0
0047 7496 332E                   data txt.saving       ; Display "Saving...."
0048 7498 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0049                       ;------------------------------------------------------
0050                       ; Display Loading....
0051                       ;------------------------------------------------------
0052               fm.loadsave.cb.indicator1.loading:
0053 749A 06A0  32         bl    @putat
     749C 2450 
0054 749E 1D00                   byte pane.botrow,0
0055 74A0 3322                   data txt.loading      ; Display "Loading...."
0056                       ;------------------------------------------------------
0057                       ; Display device/filename
0058                       ;------------------------------------------------------
0059               fm.loadsave.cb.indicator1.filename:
0060 74A2 06A0  32         bl    @at
     74A4 26A0 
0061 74A6 1D0B                   byte pane.botrow,11   ; Cursor YX position
0062 74A8 C160  34         mov   @edb.filename.ptr,tmp1
     74AA A20E 
0063                                                   ; Get pointer to file descriptor
0064 74AC 06A0  32         bl    @xutst0               ; Display device/filename
     74AE 242E 
0065                       ;------------------------------------------------------
0066                       ; Display separators
0067                       ;------------------------------------------------------
0068 74B0 06A0  32         bl    @putat
     74B2 2450 
0069 74B4 1D47                   byte pane.botrow,71
0070 74B6 336C                   data txt.vertline     ; Vertical line
0071                       ;------------------------------------------------------
0072                       ; Display fast mode
0073                       ;------------------------------------------------------
0074 74B8 0760  38         abs   @fh.offsetopcode
     74BA A44E 
0075 74BC 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0076               
0077 74BE 06A0  32         bl    @putat
     74C0 2450 
0078 74C2 1D26                   byte pane.botrow,38
0079 74C4 3338                   data txt.fastmode     ; Display "FastMode"
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               fm.loadsave.cb.indicator1.exit:
0084 74C6 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     74C8 2F20 
0085 74CA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0086 74CC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 74CE C2F9  30         mov   *stack+,r11           ; Pop R11
0088 74D0 045B  20         b     *r11                  ; Return to caller
0089               
0090               
0091               
0092               
0093               *---------------------------------------------------------------
0094               * Callback function "Show loading indicator 2"
0095               * Read line from file / Write line to file
0096               *---------------------------------------------------------------
0097               * Registered as pointer in @fh.callback2
0098               *---------------------------------------------------------------
0099               fm.loadsave.cb.indicator2:
0100                       ;------------------------------------------------------
0101                       ; Check if first page processed (speedup impression)
0102                       ;------------------------------------------------------
0103 74D2 8820  54         c     @fh.records,@fb.scrrows.max
     74D4 A43C 
     74D6 A11A 
0104 74D8 161B  14         jne   fm.loadsave.cb.indicator2.kb
0105                                                   ; Skip framebuffer refresh
0106                       ;------------------------------------------------------
0107                       ; Refresh framebuffer if first page processed
0108                       ;------------------------------------------------------
0109 74DA 0649  14         dect  stack
0110 74DC C64B  30         mov   r11,*stack            ; Save return address
0111 74DE 0649  14         dect  stack
0112 74E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0113 74E2 0649  14         dect  stack
0114 74E4 C645  30         mov   tmp1,*stack           ; Push tmp1
0115 74E6 0649  14         dect  stack
0116 74E8 C646  30         mov   tmp2,*stack           ; Push tmp2
0117               
0118 74EA 04E0  34         clr   @parm1                ;
     74EC 2F20 
0119 74EE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     74F0 6994 
0120                                                   ; \ i  @parm1 = Line to start with
0121                                                   ; /
0122               
0123                       ;------------------------------------------------------
0124                       ; Refresh VDP content with framebuffer
0125                       ;------------------------------------------------------
0126 74F2 C160  34         mov   @fb.scrrows.max,tmp1
     74F4 A11A 
0127 74F6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     74F8 A10E 
0128                                                   ; 16 bit part is in tmp2!
0129 74FA 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0130 74FC C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     74FE A100 
0131               
0132 7500 06A0  32         bl    @xpym2v               ; Copy to VDP
     7502 245E 
0133                                                   ; \ i  tmp0 = VDP target address
0134                                                   ; | i  tmp1 = RAM source address
0135                                                   ; / i  tmp2 = Bytes to copy
0136               
0137 7504 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7506 A116 
0138               
0139 7508 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 750A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 750C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 750E C2F9  30         mov   *stack+,r11           ; Pop R11
0143               
0144                       ;------------------------------------------------------
0145                       ; Check if updated counters should be displayed
0146                       ;------------------------------------------------------
0147               fm.loadsave.cb.indicator2.kb:
0148 7510 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     7512 A440 
     7514 A458 
0149 7516 1601  14         jne   !
0150 7518 045B  20         b     *r11                  ; Exit early!
0151                       ;------------------------------------------------------
0152                       ; Display updated counters
0153                       ;------------------------------------------------------
0154 751A 0649  14 !       dect  stack
0155 751C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 751E C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     7520 A440 
     7522 A458 
0158                                                   ; Save for compare
0159               
0160 7524 06A0  32         bl    @putnum
     7526 2A24 
0161 7528 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0162 752A A440                   data fh.kilobytes,rambuf,>3020
     752C 2F64 
     752E 3020 
0163               
0164 7530 06A0  32         bl    @putat
     7532 2450 
0165 7534 1D37                   byte pane.botrow,55
0166 7536 3342                   data txt.kb           ; Show "kb" string
0167               
0168 7538 06A0  32         bl    @putnum
     753A 2A24 
0169 753C 1D49                   byte pane.botrow,73   ; Show lines processed
0170 753E A43C                   data fh.records,rambuf,>3020
     7540 2F64 
     7542 3020 
0171                       ;------------------------------------------------------
0172                       ; Exit
0173                       ;------------------------------------------------------
0174               fm.loadsave.cb.indicator2.exit:
0175 7544 C2F9  30         mov   *stack+,r11           ; Pop R11
0176 7546 045B  20         b     *r11                  ; Return to caller
0177               
0178               
0179               
0180               
0181               *---------------------------------------------------------------
0182               * Callback function "Show loading indicator 3"
0183               * Close file
0184               *---------------------------------------------------------------
0185               * Registered as pointer in @fh.callback3
0186               *---------------------------------------------------------------
0187               fm.loadsave.cb.indicator3:
0188 7548 0649  14         dect  stack
0189 754A C64B  30         mov   r11,*stack            ; Save return address
0190 754C 0649  14         dect  stack
0191 754E C660  46         mov   @parm1,*stack         ; Push @parm1
     7550 2F20 
0192               
0193 7552 06A0  32         bl    @hchar
     7554 2794 
0194 7556 1D00                   byte pane.botrow,0,32,50
     7558 2032 
0195 755A FFFF                   data EOL              ; Erase loading indicator
0196               
0197 755C C820  54         mov   @tv.color,@parm1
     755E A018 
     7560 2F20 
0198 7562 06A0  32         bl    @pane.action.colorcombo.botline
     7564 7A52 
0199                                                   ; Load color combinaton for bottom line
0200                                                   ; \ i  @parm1 = Color combination
0201                                                   ; /
0202               
0203 7566 06A0  32         bl    @putnum
     7568 2A24 
0204 756A 1D32                   byte pane.botrow,50   ; Show kilobytes processed
0205 756C A440                   data fh.kilobytes,rambuf,>3020
     756E 2F64 
     7570 3020 
0206               
0207 7572 06A0  32         bl    @putat
     7574 2450 
0208 7576 1D37                   byte pane.botrow,55
0209 7578 3342                   data txt.kb           ; Show "kb" string
0210               
0211 757A 06A0  32         bl    @putnum
     757C 2A24 
0212 757E 1D49                   byte pane.botrow,73   ; Show lines processed
0213 7580 A43C                   data fh.records,rambuf,>3020
     7582 2F64 
     7584 3020 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               fm.loadsave.cb.indicator3.exit:
0218 7586 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7588 2F20 
0219 758A C2F9  30         mov   *stack+,r11           ; Pop R11
0220 758C 045B  20         b     *r11                  ; Return to caller
0221               
0222               
0223               
0224               *---------------------------------------------------------------
0225               * Callback function "File I/O error handler"
0226               * I/O error
0227               *---------------------------------------------------------------
0228               * Registered as pointer in @fh.callback4
0229               *---------------------------------------------------------------
0230               fm.loadsave.cb.fioerr:
0231 758E 0649  14         dect  stack
0232 7590 C64B  30         mov   r11,*stack            ; Save return address
0233 7592 0649  14         dect  stack
0234 7594 C644  30         mov   tmp0,*stack           ; Push tmp0
0235 7596 0649  14         dect  stack
0236 7598 C660  46         mov   @parm1,*stack         ; Push @parm1
     759A 2F20 
0237                       ;------------------------------------------------------
0238                       ; Build I/O error message
0239                       ;------------------------------------------------------
0240 759C 06A0  32         bl    @hchar
     759E 2794 
0241 75A0 1D00                   byte pane.botrow,0,32,50
     75A2 2032 
0242 75A4 FFFF                   data EOL              ; Erase loading indicator
0243               
0244 75A6 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     75A8 A44A 
0245 75AA 0284  22         ci    tmp0,fh.fopmode.writefile
     75AC 0002 
0246 75AE 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0247                       ;------------------------------------------------------
0248                       ; Failed loading file
0249                       ;------------------------------------------------------
0250               fm.loadsave.cb.fioerr.mgs1:
0251 75B0 06A0  32         bl    @cpym2m
     75B2 24AC 
0252 75B4 35B9                   data txt.ioerr.load+1
0253 75B6 A023                   data tv.error.msg+1
0254 75B8 0022                   data 34               ; Error message
0255 75BA 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0256                       ;------------------------------------------------------
0257                       ; Failed saving file
0258                       ;------------------------------------------------------
0259               fm.loadsave.cb.fioerr.mgs2:
0260 75BC 06A0  32         bl    @cpym2m
     75BE 24AC 
0261 75C0 35DB                   data txt.ioerr.save+1
0262 75C2 A023                   data tv.error.msg+1
0263 75C4 0022                   data 34               ; Error message
0264                       ;------------------------------------------------------
0265                       ; Add filename to error message
0266                       ;------------------------------------------------------
0267               fm.loadsave.cb.fioerr.mgs3:
0268 75C6 C120  34         mov   @edb.filename.ptr,tmp0
     75C8 A20E 
0269 75CA D194  26         movb  *tmp0,tmp2            ; Get length byte
0270 75CC 0986  56         srl   tmp2,8                ; Right align
0271 75CE 0584  14         inc   tmp0                  ; Skip length byte
0272 75D0 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     75D2 A043 
0273               
0274 75D4 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     75D6 24B2 
0275                                                   ; | i  tmp0 = ROM/RAM source
0276                                                   ; | i  tmp1 = RAM destination
0277                                                   ; / i  tmp2 = Bytes to copy
0278                       ;------------------------------------------------------
0279                       ; Reset filename to "new file"
0280                       ;------------------------------------------------------
0281 75D8 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     75DA A44A 
0282               
0283 75DC 0284  22         ci    tmp0,fh.fopmode.readfile
     75DE 0001 
0284 75E0 1608  14         jne   !                     ; Only when reading file
0285               
0286 75E2 0204  20         li    tmp0,txt.newfile      ; New file
     75E4 3350 
0287 75E6 C804  38         mov   tmp0,@edb.filename.ptr
     75E8 A20E 
0288               
0289 75EA 0204  20         li    tmp0,txt.filetype.none
     75EC 3362 
0290 75EE C804  38         mov   tmp0,@edb.filetype.ptr
     75F0 A210 
0291                                                   ; Empty filetype string
0292                       ;------------------------------------------------------
0293                       ; Display I/O error message
0294                       ;------------------------------------------------------
0295 75F2 06A0  32 !       bl    @pane.errline.show    ; Show error line
     75F4 7BE4 
0296               
0297 75F6 C820  54         mov   @tv.color,@parm1      ; Restore "normal" color
     75F8 A018 
     75FA 2F20 
0298 75FC 06A0  32         bl    @pane.action.colorcombo.botline
     75FE 7A52 
0299                                                   ; Load color combinaton for bottom line
0300                                                   ; \ i  @parm1 = Color combination
0301                                                   ; /
0302                       ;------------------------------------------------------
0303                       ; Exit
0304                       ;------------------------------------------------------
0305               fm.loadsave.cb.fioerr.exit:
0306 7600 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7602 2F20 
0307 7604 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0308 7606 C2F9  30         mov   *stack+,r11           ; Pop R11
0309 7608 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0164                       copy  "fm.browse.asm"       ; File manager browse support routines
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
0018 760A 0649  14         dect  stack
0019 760C C64B  30         mov   r11,*stack            ; Save return address
0020 760E 0649  14         dect  stack
0021 7610 C644  30         mov   tmp0,*stack           ; Push tmp0
0022 7612 0649  14         dect  stack
0023 7614 C645  30         mov   tmp1,*stack           ; Push tmp1
0024                       ;------------------------------------------------------
0025                       ; Sanity check
0026                       ;------------------------------------------------------
0027 7616 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     7618 2F20 
0028 761A 1334  14         jeq   fm.browse.fname.suffix.exit
0029                                                   ; Exit early if pointer is nill
0030               
0031 761C 0284  22         ci    tmp0,txt.newfile
     761E 3350 
0032 7620 1331  14         jeq   fm.browse.fname.suffix.exit
0033                                                   ; Exit early if "New file"
0034                       ;------------------------------------------------------
0035                       ; Get last character in filename
0036                       ;------------------------------------------------------
0037 7622 D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0038 7624 0985  56         srl   tmp1,8                ; MSB to LSB
0039               
0040 7626 A105  18         a     tmp1,tmp0             ; Move to last character
0041 7628 04C5  14         clr   tmp1
0042 762A D154  26         movb  *tmp0,tmp1            ; Get character
0043 762C 0985  56         srl   tmp1,8                ; MSB to LSB
0044 762E 132A  14         jeq   fm.browse.fname.suffix.exit
0045                                                   ; Exit early if empty filename
0046                       ;------------------------------------------------------
0047                       ; Check mode (increase/decrease) character ASCII value
0048                       ;------------------------------------------------------
0049 7630 C1A0  34         mov   @parm2,tmp2           ; Get mode
     7632 2F22 
0050 7634 1314  14         jeq   fm.browse.fname.suffix.dec
0051                                                   ; Decrease ASCII if mode = 0
0052                       ;------------------------------------------------------
0053                       ; Increase ASCII value last character in filename
0054                       ;------------------------------------------------------
0055               fm.browse.fname.suffix.inc:
0056 7636 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     7638 0030 
0057 763A 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0058 763C 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     763E 0039 
0059 7640 1109  14         jlt   !                     ; Next character
0060 7642 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0061                                                   ; Swith to alpha range A..Z
0062 7644 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     7646 005A 
0063 7648 131D  14         jeq   fm.browse.fname.suffix.exit
0064                                                   ; Already last alpha character, so exit
0065 764A 1104  14         jlt   !                     ; Next character
0066                       ;------------------------------------------------------
0067                       ; Invalid character, crash and burn
0068                       ;------------------------------------------------------
0069               fm.browse.fname.suffix.inc.crash:
0070 764C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     764E FFCE 
0071 7650 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7652 2030 
0072                       ;------------------------------------------------------
0073                       ; Increase ASCII value last character in filename
0074                       ;------------------------------------------------------
0075 7654 0585  14 !       inc   tmp1                  ; Increase ASCII value
0076 7656 1014  14         jmp   fm.browse.fname.suffix.store
0077               fm.browse.fname.suffix.inc.alpha:
0078 7658 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     765A 0041 
0079 765C 1011  14         jmp   fm.browse.fname.suffix.store
0080                       ;------------------------------------------------------
0081                       ; Decrease ASCII value last character in filename
0082                       ;------------------------------------------------------
0083               fm.browse.fname.suffix.dec:
0084 765E 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     7660 0030 
0085 7662 1310  14         jeq   fm.browse.fname.suffix.exit
0086                                                   ; Already first numeric character, so exit
0087 7664 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7666 0039 
0088 7668 1207  14         jle   !                     ; Previous character
0089 766A 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     766C 0041 
0090 766E 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0091                                                   ; Switch to numeric range 0..9
0092 7670 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0093                                                   ; Invalid character
0094 7672 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     7674 0084 
0095 7676 1306  14         jeq   fm.browse.fname.suffix.exit
0096 7678 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0097 767A 1002  14         jmp   fm.browse.fname.suffix.store
0098               fm.browse.fname.suffix.dec.numeric:
0099 767C 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     767E 0039 
0100                       ;------------------------------------------------------
0101                       ; Store updatec character
0102                       ;------------------------------------------------------
0103               fm.browse.fname.suffix.store:
0104 7680 0A85  56         sla   tmp1,8                ; LSB to MSB
0105 7682 D505  30         movb  tmp1,*tmp0            ; Store updated character
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               fm.browse.fname.suffix.exit:
0110 7684 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 7686 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 7688 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 768A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0165                       ;-----------------------------------------------------------------------
0166                       ; User hook, background tasks
0167                       ;-----------------------------------------------------------------------
0168                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
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
0012 768C 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     768E 2014 
0013 7690 1612  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015 7692 C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     7694 833C 
     7696 2F40 
0016               *---------------------------------------------------------------
0017               * Identical key pressed ?
0018               *---------------------------------------------------------------
0019 7698 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     769A 2014 
0020 769C 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     769E 2F40 
     76A0 2F42 
0021 76A2 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0022               *--------------------------------------------------------------
0023               * New key pressed
0024               *--------------------------------------------------------------
0025 76A4 0204  20         li    tmp0,500              ; \
     76A6 01F4 
0026 76A8 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0027 76AA 16FE  14         jne   -!                    ; /
0028 76AC C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     76AE 2F40 
     76B0 2F42 
0029 76B2 0460  28         b     @edkey.key.process    ; Process key
     76B4 60E4 
0030               *--------------------------------------------------------------
0031               * Clear keyboard buffer if no key pressed
0032               *--------------------------------------------------------------
0033               hook.keyscan.clear_kbbuffer:
0034 76B6 04E0  34         clr   @keycode1
     76B8 2F40 
0035 76BA 04E0  34         clr   @keycode2
     76BC 2F42 
0036               *--------------------------------------------------------------
0037               * Delay to avoid key bouncing
0038               *--------------------------------------------------------------
0039               hook.keyscan.bounce:
0040 76BE 0204  20         li    tmp0,2000             ; Avoid key bouncing
     76C0 07D0 
0041                       ;------------------------------------------------------
0042                       ; Delay loop
0043                       ;------------------------------------------------------
0044               hook.keyscan.bounce.loop:
0045 76C2 0604  14         dec   tmp0
0046 76C4 16FE  14         jne   hook.keyscan.bounce.loop
0047 76C6 0460  28         b     @hookok               ; Return
     76C8 2D1A 
0048               
**** **** ****     > stevie_b1.asm.2405726
0169                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
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
0010               ********|*****|*********************|**************************
0011               task.vdp.panes:
0012 76CA C820  54         mov   @wyx,@fb.yxsave       ; Backup cursor
     76CC 832A 
     76CE A114 
0013                       ;------------------------------------------------------
0014                       ; ALPHA-Lock key down?
0015                       ;------------------------------------------------------
0016               task.vdp.panes.alpha_lock:
0017 76D0 20A0  38         coc   @wbit10,config
     76D2 2016 
0018 76D4 1305  14         jeq   task.vdp.panes.alpha_lock.down
0019                       ;------------------------------------------------------
0020                       ; AlPHA-Lock is up
0021                       ;------------------------------------------------------
0022 76D6 06A0  32         bl    @putat
     76D8 2450 
0023 76DA 1D4F                   byte   pane.botrow,79
0024 76DC 3368                   data   txt.alpha.up
0025 76DE 1004  14         jmp   task.vdp.panes.cmdb.check
0026                       ;------------------------------------------------------
0027                       ; AlPHA-Lock is down
0028                       ;------------------------------------------------------
0029               task.vdp.panes.alpha_lock.down:
0030 76E0 06A0  32         bl    @putat
     76E2 2450 
0031 76E4 1D4F                   byte   pane.botrow,79
0032 76E6 336A                   data   txt.alpha.down
0033                       ;------------------------------------------------------
0034                       ; Command buffer visible ?
0035                       ;------------------------------------------------------
0036               task.vdp.panes.cmdb.check
0037 76E8 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     76EA A114 
     76EC 832A 
0038 76EE C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     76F0 A302 
0039 76F2 1309  14         jeq   !                     ; No, skip CMDB pane
0040 76F4 1000  14         jmp   task.vdp.panes.cmdb.draw
0041                       ;-------------------------------------------------------
0042                       ; Draw command buffer pane if dirty
0043                       ;-------------------------------------------------------
0044               task.vdp.panes.cmdb.draw:
0045 76F6 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     76F8 A318 
0046 76FA 1348  14         jeq   task.vdp.panes.exit   ; No, skip update
0047               
0048 76FC 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     76FE 7A8A 
0049 7700 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     7702 A318 
0050 7704 1043  14         jmp   task.vdp.panes.exit   ; Exit early
0051                       ;-------------------------------------------------------
0052                       ; Check if frame buffer dirty
0053                       ;-------------------------------------------------------
0054 7706 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7708 A116 
0055 770A 133E  14         jeq   task.vdp.panes.botline.draw
0056                                                   ; No, skip update
0057               
0058 770C C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     770E 832A 
     7710 A114 
0059                       ;------------------------------------------------------
0060                       ; Determine how many rows to copy
0061                       ;------------------------------------------------------
0062 7712 8820  54         c     @edb.lines,@fb.scrrows
     7714 A204 
     7716 A118 
0063 7718 1103  14         jlt   task.vdp.panes.setrows.small
0064 771A C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     771C A118 
0065 771E 1003  14         jmp   task.vdp.panes.copy.framebuffer
0066                       ;------------------------------------------------------
0067                       ; Less lines in editor buffer as rows in frame buffer
0068                       ;------------------------------------------------------
0069               task.vdp.panes.setrows.small:
0070 7720 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7722 A204 
0071 7724 0585  14         inc   tmp1
0072                       ;------------------------------------------------------
0073                       ; Determine area to copy
0074                       ;------------------------------------------------------
0075               task.vdp.panes.copy.framebuffer:
0076 7726 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7728 A10E 
0077                                                   ; 16 bit part is in tmp2!
0078 772A 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0079 772C C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     772E A100 
0080                       ;------------------------------------------------------
0081                       ; Copy memory block
0082                       ;------------------------------------------------------
0083 7730 0286  22         ci    tmp2,0                ; Something to copy?
     7732 0000 
0084 7734 1304  14         jeq   task.vdp.panes.copy.eof
0085                                                   ; No, skip copy
0086               
0087 7736 06A0  32         bl    @xpym2v               ; Copy to VDP
     7738 245E 
0088                                                   ; \ i  tmp0 = VDP target address
0089                                                   ; | i  tmp1 = RAM source address
0090                                                   ; / i  tmp2 = Bytes to copy
0091 773A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     773C A116 
0092                       ;-------------------------------------------------------
0093                       ; Draw EOF marker at end-of-file
0094                       ;-------------------------------------------------------
0095               task.vdp.panes.copy.eof:
0096 773E 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7740 A116 
0097 7742 C120  34         mov   @edb.lines,tmp0
     7744 A204 
0098 7746 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7748 A104 
0099               
0100 774A 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     774C A118 
0101 774E 121C  14         jle   task.vdp.panes.botline.draw
0102                                                   ; Skip drawing EOF maker
0103                       ;-------------------------------------------------------
0104                       ; Do actual drawing of EOF marker
0105                       ;-------------------------------------------------------
0106               task.vdp.panes.draw_marker:
0107 7750 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0108 7752 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7754 832A 
0109               
0110 7756 06A0  32         bl    @putstr
     7758 242C 
0111 775A 330C                   data txt.marker       ; Display *EOF*
0112               
0113 775C 06A0  32         bl    @setx
     775E 26B6 
0114 7760 0005                   data 5                ; Cursor after *EOF* string
0115                       ;-------------------------------------------------------
0116                       ; Clear rest of screen
0117                       ;-------------------------------------------------------
0118               task.vdp.panes.clear_screen:
0119 7762 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     7764 A10E 
0120               
0121 7766 C160  34         mov   @wyx,tmp1             ;
     7768 832A 
0122 776A 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0123 776C 0505  16         neg   tmp1                  ; tmp1 = -Y position
0124 776E A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     7770 A118 
0125               
0126 7772 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0127 7774 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     7776 FFFB 
0128               
0129 7778 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     777A 2408 
0130                                                   ; \ i  @wyx = Cursor position
0131                                                   ; / o  tmp0 = VDP address
0132               
0133 777C 04C5  14         clr   tmp1                  ; Character to write (null!)
0134 777E 06A0  32         bl    @xfilv                ; Fill VDP memory
     7780 22A2 
0135                                                   ; \ i  tmp0 = VDP destination
0136                                                   ; | i  tmp1 = byte to write
0137                                                   ; / i  tmp2 = Number of bytes to write
0138               
0139 7782 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7784 A114 
     7786 832A 
0140                       ;-------------------------------------------------------
0141                       ; Draw status line
0142                       ;-------------------------------------------------------
0143               task.vdp.panes.botline.draw:
0144 7788 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     778A 7C3A 
0145                       ;------------------------------------------------------
0146                       ; Exit task
0147                       ;------------------------------------------------------
0148               task.vdp.panes.exit:
0149 778C 0460  28         b     @slotok
     778E 2D96 
**** **** ****     > stevie_b1.asm.2405726
0170                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
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
0012 7790 C120  34         mov   @tv.pane.focus,tmp0
     7792 A01C 
0013 7794 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 7796 0284  22         ci    tmp0,pane.focus.cmdb
     7798 0001 
0016 779A 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 779C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     779E FFCE 
0022 77A0 06A0  32         bl    @cpu.crash            ; / Halt system.
     77A2 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 77A4 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     77A6 A30A 
     77A8 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 77AA E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     77AC 202A 
0032 77AE 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     77B0 26C2 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 77B2 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     77B4 2F54 
0036               
0037 77B6 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     77B8 2458 
0038 77BA 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     77BC 2F54 
     77BE 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 77C0 0460  28         b     @slotok               ; Exit task
     77C2 2D96 
**** **** ****     > stevie_b1.asm.2405726
0171                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
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
0012 77C4 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     77C6 A112 
0013 77C8 1303  14         jeq   task.vdp.cursor.visible
0014 77CA 04E0  34         clr   @ramsat+2              ; Hide cursor
     77CC 2F56 
0015 77CE 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 77D0 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     77D2 A20A 
0019 77D4 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 77D6 C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     77D8 A01C 
0025 77DA 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 77DC 0284  22         ci    tmp0,pane.focus.cmdb
     77DE 0001 
0028 77E0 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 77E2 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0034 77E4 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 77E6 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     77E8 0100 
0040 77EA 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 77EC 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     77EE 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 77F0 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     77F2 A014 
0051 77F4 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     77F6 A014 
     77F8 2F56 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 77FA 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     77FC 2458 
0057 77FE 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     7800 2F54 
     7802 0004 
0058                                                    ; | i  p1 = ROM/RAM source
0059                                                    ; / i  p2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 7804 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     7806 A302 
0064 7808 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 780A 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     780C 7C3A 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 780E 0460  28         b     @slotok                ; Exit task
     7810 2D96 
**** **** ****     > stevie_b1.asm.2405726
0172                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               task.oneshot:
0002 7812 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7814 A01E 
0003 7816 1301  14         jeq   task.oneshot.exit
0004               
0005 7818 0694  24         bl    *tmp0                  ; Execute one-shot task
0006                       ;------------------------------------------------------
0007                       ; Exit
0008                       ;------------------------------------------------------
0009               task.oneshot.exit:
0010 781A 0460  28         b     @slotok                ; Exit task
     781C 2D96 
**** **** ****     > stevie_b1.asm.2405726
0173                       ;-----------------------------------------------------------------------
0174                       ; Screen pane utilities
0175                       ;-----------------------------------------------------------------------
0176                       copy  "pane.utils.asm"      ; Pane utility functions
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
0019               * OUTPUT test
0020               * none
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0, tmp1, tmp2
0024               ********|*****|*********************|**************************
0025               pane.show_hintx:
0026 781E 0649  14         dect  stack
0027 7820 C64B  30         mov   r11,*stack            ; Save return address
0028 7822 0649  14         dect  stack
0029 7824 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7826 0649  14         dect  stack
0031 7828 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 782A 0649  14         dect  stack
0033 782C C646  30         mov   tmp2,*stack           ; Push tmp2
0034 782E 0649  14         dect  stack
0035 7830 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 7832 C820  54         mov   @parm1,@wyx           ; Set cursor
     7834 2F20 
     7836 832A 
0040 7838 C160  34         mov   @parm2,tmp1           ; Get string to display
     783A 2F22 
0041 783C 06A0  32         bl    @xutst0               ; Display string
     783E 242E 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 7840 C120  34         mov   @parm2,tmp0
     7842 2F22 
0046 7844 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 7846 0984  56         srl   tmp0,8                ; Right justify
0048 7848 C184  18         mov   tmp0,tmp2
0049 784A C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 784C 0506  16         neg   tmp2
0051 784E 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7850 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 7852 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7854 2F20 
0056 7856 A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 7858 C804  38         mov   tmp0,@wyx             ; / Set cursor
     785A 832A 
0058               
0059 785C 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     785E 2408 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 7860 0205  20         li    tmp1,32               ; Byte to fill
     7862 0020 
0064               
0065 7864 06A0  32         bl    @xfilv                ; Clear line
     7866 22A2 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 7868 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 786A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 786C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 786E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 7870 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7872 045B  20         b     *r11                  ; Return to caller
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
0100 7874 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     7876 2F20 
0101 7878 C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     787A 2F22 
0102 787C 0649  14         dect  stack
0103 787E C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 7880 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7882 781E 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 7884 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 7886 045B  20         b     *r11                  ; Return to caller
0114               
0115               
0116               
0117               ***************************************************************
0118               * pane.cursor.hide
0119               * Hide cursor
0120               ***************************************************************
0121               * bl  @pane.cursor.hide
0122               *--------------------------------------------------------------
0123               * INPUT
0124               * none
0125               *--------------------------------------------------------------
0126               * OUTPUT
0127               * none
0128               *--------------------------------------------------------------
0129               * Register usage
0130               * none
0131               ********|*****|*********************|**************************
0132               pane.cursor.hide:
0133 7888 0649  14         dect  stack
0134 788A C64B  30         mov   r11,*stack            ; Save return address
0135                       ;-------------------------------------------------------
0136                       ; Hide cursor
0137                       ;-------------------------------------------------------
0138 788C 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     788E 229C 
0139 7890 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7892 0000 
     7894 0004 
0140                                                   ; | i  p1 = Byte to write
0141                                                   ; / i  p2 = Number of bytes to write
0142               
0143 7896 06A0  32         bl    @clslot
     7898 2DF2 
0144 789A 0001                   data 1                ; Terminate task.vdp.copy.sat
0145               
0146 789C 06A0  32         bl    @clslot
     789E 2DF2 
0147 78A0 0002                   data 2                ; Terminate task.vdp.copy.sat
0148               
0149                       ;-------------------------------------------------------
0150                       ; Exit
0151                       ;-------------------------------------------------------
0152               pane.cursor.hide.exit:
0153 78A2 C2F9  30         mov   *stack+,r11           ; Pop R11
0154 78A4 045B  20         b     *r11                  ; Return to caller
0155               
0156               
0157               
0158               ***************************************************************
0159               * pane.cursor.blink
0160               * Blink cursor
0161               ***************************************************************
0162               * bl  @pane.cursor.blink
0163               *--------------------------------------------------------------
0164               * INPUT
0165               * none
0166               *--------------------------------------------------------------
0167               * OUTPUT
0168               * none
0169               *--------------------------------------------------------------
0170               * Register usage
0171               * none
0172               ********|*****|*********************|**************************
0173               pane.cursor.blink:
0174 78A6 0649  14         dect  stack
0175 78A8 C64B  30         mov   r11,*stack            ; Save return address
0176                       ;-------------------------------------------------------
0177                       ; Hide cursor
0178                       ;-------------------------------------------------------
0179 78AA 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     78AC 229C 
0180 78AE 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     78B0 0000 
     78B2 0004 
0181                                                   ; | i  p1 = Byte to write
0182                                                   ; / i  p2 = Number of bytes to write
0183               
0184 78B4 06A0  32         bl    @mkslot
     78B6 2DD4 
0185 78B8 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     78BA 7790 
0186 78BC 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     78BE 77C4 
0187 78C0 FFFF                   data eol
0188                       ;-------------------------------------------------------
0189                       ; Exit
0190                       ;-------------------------------------------------------
0191               pane.cursor.blink.exit:
0192 78C2 C2F9  30         mov   *stack+,r11           ; Pop R11
0193 78C4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0177                       copy  "pane.utils.colorscheme.asm"
**** **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Colorscheme for panes
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.action.colorschene.cycle
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
0021 78C6 0649  14         dect  stack
0022 78C8 C64B  30         mov   r11,*stack            ; Push return address
0023 78CA 0649  14         dect  stack
0024 78CC C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 78CE C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     78D0 A012 
0027 78D2 0284  22         ci    tmp0,tv.colorscheme.entries
     78D4 0009 
0028                                                   ; Last entry reached?
0029 78D6 1103  14         jlt   !
0030 78D8 0204  20         li    tmp0,1                ; Reset color scheme index
     78DA 0001 
0031 78DC 1001  14         jmp   pane.action.colorscheme.switch
0032 78DE 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 78E0 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     78E2 A012 
0038 78E4 06A0  32         bl    @pane.action.colorscheme.load
     78E6 7950 
0039                       ;-------------------------------------------------------
0040                       ; Show current color scheme message
0041                       ;-------------------------------------------------------
0042 78E8 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     78EA 832A 
     78EC 833C 
0043               
0044 78EE 06A0  32         bl    @filv
     78F0 229C 
0045 78F2 1840                   data >1840,>1F,16     ; VDP start address (frame buffer area)
     78F4 001F 
     78F6 0010 
0046               
0047 78F8 06A0  32         bl    @putnum
     78FA 2A24 
0048 78FC 004B                   byte 0,75
0049 78FE A012                   data tv.colorscheme,rambuf,>3020
     7900 2F64 
     7902 3020 
0050               
0051 7904 06A0  32         bl    @putat
     7906 2450 
0052 7908 0040                   byte 0,64
0053 790A 363E                   data txt.colorscheme  ; Show color scheme message
0054               
0055 790C C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     790E 833C 
     7910 832A 
0056                       ;-------------------------------------------------------
0057                       ; Delay
0058                       ;-------------------------------------------------------
0059 7912 0204  20         li    tmp0,12000
     7914 2EE0 
0060 7916 0604  14 !       dec   tmp0
0061 7918 16FE  14         jne   -!
0062                       ;-------------------------------------------------------
0063                       ; Setup one shot task for removing message
0064                       ;-------------------------------------------------------
0065 791A 0204  20         li    tmp0,pane.action.colorscheme.task.callback
     791C 792E 
0066 791E C804  38         mov   tmp0,@tv.task.oneshot
     7920 A01E 
0067               
0068 7922 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     7924 2E00 
0069 7926 0003                   data 3                ; / for getting consistent delay
0070                       ;-------------------------------------------------------
0071                       ; Exit
0072                       ;-------------------------------------------------------
0073               pane.action.colorscheme.cycle.exit:
0074 7928 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 792A C2F9  30         mov   *stack+,r11           ; Pop R11
0076 792C 045B  20         b     *r11                  ; Return to caller
0077                       ;-------------------------------------------------------
0078                       ; Remove colorscheme message (triggered by oneshot task)
0079                       ;-------------------------------------------------------
0080               pane.action.colorscheme.task.callback:
0081 792E 0649  14         dect  stack
0082 7930 C64B  30         mov   r11,*stack            ; Push return address
0083               
0084 7932 06A0  32         bl    @filv
     7934 229C 
0085 7936 003C                   data >003C,>00,20     ; Remove message
     7938 0000 
     793A 0014 
0086               
0087 793C 0720  34         seto  @parm1
     793E 2F20 
0088 7940 06A0  32         bl    @pane.action.colorscheme.load
     7942 7950 
0089                                                   ; Reload current colorscheme
0090                                                   ; \ i  parm1 = Do not turn screen off
0091                                                   ; /
0092               
0093 7944 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     7946 A116 
0094 7948 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     794A A01E 
0095               
0096 794C C2F9  30         mov   *stack+,r11           ; Pop R11
0097 794E 045B  20         b     *r11                  ; Return to task
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
0118 7950 0649  14         dect  stack
0119 7952 C64B  30         mov   r11,*stack            ; Save return address
0120 7954 0649  14         dect  stack
0121 7956 C644  30         mov   tmp0,*stack           ; Push tmp0
0122 7958 0649  14         dect  stack
0123 795A C645  30         mov   tmp1,*stack           ; Push tmp1
0124 795C 0649  14         dect  stack
0125 795E C646  30         mov   tmp2,*stack           ; Push tmp2
0126 7960 0649  14         dect  stack
0127 7962 C647  30         mov   tmp3,*stack           ; Push tmp3
0128 7964 0649  14         dect  stack
0129 7966 C648  30         mov   tmp4,*stack           ; Push tmp4
0130 7968 0649  14         dect  stack
0131 796A C660  46         mov   @parm1,*stack         ; Push parm1
     796C 2F20 
0132                       ;-------------------------------------------------------
0133                       ; Turn screen of
0134                       ;-------------------------------------------------------
0135 796E C120  34         mov   @parm1,tmp0
     7970 2F20 
0136 7972 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7974 FFFF 
0137 7976 1302  14         jeq   !                     ; Yes, so skip screen off
0138 7978 06A0  32         bl    @scroff               ; Turn screen off
     797A 2660 
0139                       ;-------------------------------------------------------
0140                       ; Get framebuffer foreground/background color
0141                       ;-------------------------------------------------------
0142 797C C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     797E A012 
0143 7980 0604  14         dec   tmp0                  ; Internally work with base 0
0144               
0145 7982 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0146 7984 0224  22         ai    tmp0,tv.colorscheme.table
     7986 314A 
0147                                                   ; Add base for color scheme data table
0148 7988 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0149 798A C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     798C A018 
0150                       ;-------------------------------------------------------
0151                       ; Get and save cursor color
0152                       ;-------------------------------------------------------
0153 798E C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0154 7990 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     7992 00FF 
0155 7994 C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7996 A016 
0156                       ;-------------------------------------------------------
0157                       ; Get CMDB pane foreground/background color
0158                       ;-------------------------------------------------------
0159 7998 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0160 799A 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     799C FF00 
0161 799E 0988  56         srl   tmp4,8                ; MSB to LSB
0162               
0163 79A0 C134  30         mov   *tmp0+,tmp0           ; Get colors IJKL
0164 79A2 0244  22         andi  tmp0,>ff00            ; Only keep MSB (IJ)
     79A4 FF00 
0165 79A6 0984  56         srl   tmp0,8                ; MSB to LSB
0166 79A8 C804  38         mov   tmp0,@tv.busycolor    ; Save colors IJ
     79AA A01A 
0167                       ;-------------------------------------------------------
0168                       ; Dump colors to VDP register 7 (text mode)
0169                       ;-------------------------------------------------------
0170 79AC C147  18         mov   tmp3,tmp1             ; Get work copy
0171 79AE 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0172 79B0 0265  22         ori   tmp1,>0700
     79B2 0700 
0173 79B4 C105  18         mov   tmp1,tmp0
0174 79B6 06A0  32         bl    @putvrx               ; Write VDP register
     79B8 2342 
0175                       ;-------------------------------------------------------
0176                       ; Dump colors for frame buffer pane (TAT)
0177                       ;-------------------------------------------------------
0178 79BA 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     79BC 1800 
0179 79BE C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0180 79C0 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0181 79C2 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     79C4 0910 
0182 79C6 06A0  32         bl    @xfilv                ; Fill colors
     79C8 22A2 
0183                                                   ; i \  tmp0 = start address
0184                                                   ; i |  tmp1 = byte to fill
0185                                                   ; i /  tmp2 = number of bytes to fill
0186                       ;-------------------------------------------------------
0187                       ; Dump colors for CMDB pane (TAT)
0188                       ;-------------------------------------------------------
0189               pane.action.colorscheme.cmdbpane:
0190 79CA C120  34         mov   @cmdb.visible,tmp0
     79CC A302 
0191 79CE 1307  14         jeq   pane.action.colorscheme.errpane
0192                                                   ; Skip if CMDB pane is hidden
0193               
0194 79D0 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     79D2 1FD0 
0195 79D4 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0196 79D6 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     79D8 0190 
0197 79DA 06A0  32         bl    @xfilv                ; Fill colors
     79DC 22A2 
0198                                                   ; i \  tmp0 = start address
0199                                                   ; i |  tmp1 = byte to fill
0200                                                   ; i /  tmp2 = number of bytes to fill
0201                       ;-------------------------------------------------------
0202                       ; Dump fixed colors for error line pane (TAT)
0203                       ;-------------------------------------------------------
0204               pane.action.colorscheme.errpane:
0205 79DE C120  34         mov   @tv.error.visible,tmp0
     79E0 A020 
0206 79E2 1306  14         jeq   pane.action.colorscheme.statusline
0207                                                   ; Skip if error line pane is hidden
0208               
0209 79E4 0205  20         li    tmp1,>00f6            ; White on dark red
     79E6 00F6 
0210 79E8 C805  38         mov   tmp1,@parm1           ; Pass color combination
     79EA 2F20 
0211               
0212 79EC 06A0  32         bl    @pane.action.colorcombo.errline
     79EE 7A1E 
0213                                                   ; Load color combination for error line
0214                                                   ; \ i  @parm1 = Color combination
0215                                                   ; /
0216                       ;-------------------------------------------------------
0217                       ; Dump colors for bottom status line pane (TAT)
0218                       ;-------------------------------------------------------
0219               pane.action.colorscheme.statusline:
0220 79F0 C820  54         mov   @tv.color,@parm1      ; Pass color combination
     79F2 A018 
     79F4 2F20 
0221               
0222 79F6 06A0  32         bl    @pane.action.colorcombo.botline
     79F8 7A52 
0223                                                   ; Load color combination for status line
0224                                                   ; \ i  @parm1 = Color combination
0225                                                   ; /
0226                       ;-------------------------------------------------------
0227                       ; Dump cursor FG color to sprite table (SAT)
0228                       ;-------------------------------------------------------
0229               pane.action.colorscheme.cursorcolor:
0230 79FA C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     79FC A016 
0231 79FE 0A88  56         sla   tmp4,8                ; Move to MSB
0232 7A00 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     7A02 2F57 
0233 7A04 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     7A06 A015 
0234                       ;-------------------------------------------------------
0235                       ; Exit
0236                       ;-------------------------------------------------------
0237               pane.action.colorscheme.load.exit:
0238 7A08 06A0  32         bl    @scron                ; Turn screen on
     7A0A 2668 
0239 7A0C C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7A0E 2F20 
0240 7A10 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0241 7A12 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0242 7A14 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0243 7A16 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0244 7A18 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0245 7A1A C2F9  30         mov   *stack+,r11           ; Pop R11
0246 7A1C 045B  20         b     *r11                  ; Return to caller
0247               
0248               
0249               
0250               ***************************************************************
0251               * pane.action.colorcombo.errline
0252               * Load color scheme for error line
0253               ***************************************************************
0254               * bl  @pane.action.colorcombo.errline
0255               *--------------------------------------------------------------
0256               * INPUT
0257               * @parm1 = Foreground / Background color
0258               *--------------------------------------------------------------
0259               * OUTPUT
0260               * none
0261               *--------------------------------------------------------------
0262               * Register usage
0263               * tmp0,tmp1,tmp2
0264               ********|*****|*********************|**************************
0265               pane.action.colorcombo.errline:
0266 7A1E 0649  14         dect  stack
0267 7A20 C64B  30         mov   r11,*stack            ; Save return address
0268 7A22 0649  14         dect  stack
0269 7A24 C644  30         mov   tmp0,*stack           ; Push tmp0
0270 7A26 0649  14         dect  stack
0271 7A28 C645  30         mov   tmp1,*stack           ; Push tmp1
0272 7A2A 0649  14         dect  stack
0273 7A2C C646  30         mov   tmp2,*stack           ; Push tmp2
0274 7A2E 0649  14         dect  stack
0275 7A30 C660  46         mov   @parm1,*stack         ; Push parm1
     7A32 2F20 
0276                       ;-------------------------------------------------------
0277                       ; Load error line colors
0278                       ;-------------------------------------------------------
0279 7A34 C160  34         mov   @parm1,tmp1           ; Get FG/BG color
     7A36 2F20 
0280               
0281 7A38 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     7A3A 20C0 
0282 7A3C 0206  20         li    tmp2,80               ; Number of bytes to fill
     7A3E 0050 
0283 7A40 06A0  32         bl    @xfilv                ; Fill colors
     7A42 22A2 
0284                                                   ; i \  tmp0 = start address
0285                                                   ; i |  tmp1 = byte to fill
0286                                                   ; i /  tmp2 = number of bytes to fill
0287                       ;-------------------------------------------------------
0288                       ; Exit
0289                       ;-------------------------------------------------------
0290               pane.action.colorcombo.errline.exit:
0291 7A44 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7A46 2F20 
0292 7A48 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 7A4A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 7A4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 7A4E C2F9  30         mov   *stack+,r11           ; Pop R11
0296 7A50 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               
0301               
0302               
0303               ***************************************************************
0304               * pane.action.colorcombo.botline
0305               * Load color combination for error line
0306               ***************************************************************
0307               * bl  @pane.action.colorcombo.botline
0308               *--------------------------------------------------------------
0309               * INPUT
0310               * @parm1 = Foreground / Background color
0311               *--------------------------------------------------------------
0312               * OUTPUT
0313               * none
0314               *--------------------------------------------------------------
0315               * Register usage
0316               * tmp0,tmp1,tmp2
0317               ********|*****|*********************|**************************
0318               pane.action.colorcombo.botline:
0319 7A52 0649  14         dect  stack
0320 7A54 C64B  30         mov   r11,*stack            ; Save return address
0321 7A56 0649  14         dect  stack
0322 7A58 C644  30         mov   tmp0,*stack           ; Push tmp0
0323 7A5A 0649  14         dect  stack
0324 7A5C C645  30         mov   tmp1,*stack           ; Push tmp1
0325 7A5E 0649  14         dect  stack
0326 7A60 C646  30         mov   tmp2,*stack           ; Push tmp2
0327 7A62 0649  14         dect  stack
0328 7A64 C660  46         mov   @parm1,*stack         ; Push parm1
     7A66 2F20 
0329                       ;-------------------------------------------------------
0330                       ; Dump colors for bottom status line pane (TAT)
0331                       ;-------------------------------------------------------
0332 7A68 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     7A6A 2110 
0333 7A6C C160  34         mov   @parm1,tmp1           ; Get color
     7A6E 2F20 
0334 7A70 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7A72 00FF 
0335 7A74 0206  20         li    tmp2,80               ; Number of bytes to fill
     7A76 0050 
0336 7A78 06A0  32         bl    @xfilv                ; Fill colors
     7A7A 22A2 
0337                                                   ; i \  tmp0 = start address
0338                                                   ; i |  tmp1 = byte to fill
0339                                                   ; i /  tmp2 = number of bytes to fill
0340                       ;-------------------------------------------------------
0341                       ; Exit
0342                       ;-------------------------------------------------------
0343               pane.action.colorcombo.botline.exit:
0344 7A7C C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7A7E 2F20 
0345 7A80 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0346 7A82 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0347 7A84 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0348 7A86 C2F9  30         mov   *stack+,r11           ; Pop R11
0349 7A88 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0178                                                   ; Colorscheme handling in panes
0179                       ;-----------------------------------------------------------------------
0180                       ; Screen panes
0181                       ;-----------------------------------------------------------------------
0182                       copy  "pane.cmdb.asm"       ; Command buffer
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
0010               * Draw Stevie Command Buffer in pane
0011               ***************************************************************
0012               * bl  @pane.cmdb.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               pane.cmdb.draw:
0021 7A8A 0649  14         dect  stack
0022 7A8C C64B  30         mov   r11,*stack            ; Save return address
0023 7A8E 0649  14         dect  stack
0024 7A90 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 7A92 0649  14         dect  stack
0026 7A94 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7A96 0649  14         dect  stack
0028 7A98 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 7A9A 06A0  32         bl    @hchar
     7A9C 2794 
0033 7A9E 190F                   byte pane.botrow-4,15,1,65
     7AA0 0141 
0034 7AA2 FFFF                   data eol
0035               
0036 7AA4 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7AA6 A30E 
     7AA8 832A 
0037 7AAA C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     7AAC A31C 
0038 7AAE 06A0  32         bl    @xutst0               ; /
     7AB0 242E 
0039               
0040                       ;------------------------------------------------------
0041                       ; Check dialog id
0042                       ;------------------------------------------------------
0043 7AB2 04E0  34         clr   @waux1                ; Default is show prompt
     7AB4 833C 
0044               
0045 7AB6 C120  34         mov   @cmdb.dialog,tmp0
     7AB8 A31A 
0046 7ABA 0284  22         ci    tmp0,100              ; \ Hide prompt and no keyboard
     7ABC 0064 
0047 7ABE 120C  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 100
0048 7AC0 0720  34         seto  @waux1                ; /
     7AC2 833C 
0049                       ;------------------------------------------------------
0050                       ; Show warning message if in "Unsaved changes" dialog
0051                       ;------------------------------------------------------
0052 7AC4 0284  22         ci    tmp0,id.dialog.unsaved
     7AC6 0065 
0053 7AC8 1607  14         jne   pane.cmdb.draw.clear  ; Display normal prompt
0054               
0055 7ACA 06A0  32         bl    @putat                ; \ Show warning message
     7ACC 2450 
0056 7ACE 1A00                   byte pane.botrow-3,0  ; |
0057 7AD0 3532                   data txt.warn.unsaved ; /
0058               
0059 7AD2 C820  54         mov   @txt.warn.unsaved,@cmdb.cmdlen
     7AD4 3532 
     7AD6 A324 
0060                       ;------------------------------------------------------
0061                       ; Clear lines after prompt in command buffer
0062                       ;------------------------------------------------------
0063               pane.cmdb.draw.clear:
0064 7AD8 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7ADA A324 
0065 7ADC 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0066 7ADE A120  34         a     @cmdb.yxprompt,tmp0   ; |
     7AE0 A310 
0067 7AE2 C804  38         mov   tmp0,@wyx             ; /
     7AE4 832A 
0068               
0069 7AE6 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7AE8 2408 
0070                                                   ; \ i  @wyx = Cursor position
0071                                                   ; / o  tmp0 = VDP target address
0072               
0073 7AEA 0205  20         li    tmp1,32
     7AEC 0020 
0074               
0075 7AEE C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     7AF0 A324 
0076 7AF2 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0077 7AF4 0506  16         neg   tmp2                  ; | Based on command & prompt length
0078 7AF6 0226  22         ai    tmp2,2*80 - 1         ; /
     7AF8 009F 
0079               
0080 7AFA 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     7AFC 22A2 
0081                                                   ; | i  tmp0 = VDP target address
0082                                                   ; | i  tmp1 = Byte to fill
0083                                                   ; / i  tmp2 = Number of bytes to fill
0084                       ;------------------------------------------------------
0085                       ; Display pane hint in command buffer
0086                       ;------------------------------------------------------
0087               pane.cmdb.draw.hint:
0088 7AFE 0204  20         li    tmp0,pane.botrow - 1  ; \
     7B00 001C 
0089 7B02 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0090 7B04 C804  38         mov   tmp0,@parm1           ; Set parameter
     7B06 2F20 
0091 7B08 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     7B0A A31E 
     7B0C 2F22 
0092               
0093 7B0E 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7B10 781E 
0094                                                   ; \ i  parm1 = Pointer to string with hint
0095                                                   ; / i  parm2 = YX position
0096                       ;------------------------------------------------------
0097                       ; Display keys in status line
0098                       ;------------------------------------------------------
0099 7B12 0204  20         li    tmp0,pane.botrow      ; \
     7B14 001D 
0100 7B16 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0101 7B18 C804  38         mov   tmp0,@parm1           ; Set parameter
     7B1A 2F20 
0102 7B1C C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     7B1E A320 
     7B20 2F22 
0103               
0104 7B22 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7B24 781E 
0105                                                   ; \ i  parm1 = Pointer to string with hint
0106                                                   ; / i  parm2 = YX position
0107                       ;------------------------------------------------------
0108                       ; ALPHA-Lock key down?
0109                       ;------------------------------------------------------
0110 7B26 20A0  38         coc   @wbit10,config
     7B28 2016 
0111 7B2A 1305  14         jeq   pane.cmdb.draw.alpha.down
0112                       ;------------------------------------------------------
0113                       ; AlPHA-Lock is up
0114                       ;------------------------------------------------------
0115 7B2C 06A0  32         bl    @putat
     7B2E 2450 
0116 7B30 1D4F                   byte   pane.botrow,79
0117 7B32 3368                   data   txt.alpha.up
0118               
0119 7B34 1004  14         jmp   pane.cmdb.draw.promptcmd
0120                       ;------------------------------------------------------
0121                       ; AlPHA-Lock is down
0122                       ;------------------------------------------------------
0123               pane.cmdb.draw.alpha.down:
0124 7B36 06A0  32         bl    @putat
     7B38 2450 
0125 7B3A 1D4F                   byte   pane.botrow,79
0126 7B3C 336A                   data   txt.alpha.down
0127                       ;------------------------------------------------------
0128                       ; Command buffer content
0129                       ;------------------------------------------------------
0130               pane.cmdb.draw.promptcmd:
0131 7B3E C120  34         mov   @waux1,tmp0           ; Flag set?
     7B40 833C 
0132 7B42 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0133 7B44 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     7B46 6EEC 
0134                       ;------------------------------------------------------
0135                       ; Exit
0136                       ;------------------------------------------------------
0137               pane.cmdb.draw.exit:
0138 7B48 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0139 7B4A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0140 7B4C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0141 7B4E C2F9  30         mov   *stack+,r11           ; Pop r11
0142 7B50 045B  20         b     *r11                  ; Return
0143               
0144               
0145               ***************************************************************
0146               * pane.cmdb.show
0147               * Show command buffer pane
0148               ***************************************************************
0149               * bl @pane.cmdb.show
0150               *--------------------------------------------------------------
0151               * INPUT
0152               * none
0153               *--------------------------------------------------------------
0154               * OUTPUT
0155               * none
0156               *--------------------------------------------------------------
0157               * Register usage
0158               * none
0159               *--------------------------------------------------------------
0160               * Notes
0161               ********|*****|*********************|**************************
0162               pane.cmdb.show:
0163 7B52 0649  14         dect  stack
0164 7B54 C64B  30         mov   r11,*stack            ; Save return address
0165 7B56 0649  14         dect  stack
0166 7B58 C644  30         mov   tmp0,*stack           ; Push tmp0
0167                       ;------------------------------------------------------
0168                       ; Show command buffer pane
0169                       ;------------------------------------------------------
0170 7B5A C820  54         mov   @wyx,@cmdb.fb.yxsave
     7B5C 832A 
     7B5E A304 
0171                                                   ; Save YX position in frame buffer
0172               
0173 7B60 C120  34         mov   @fb.scrrows.max,tmp0
     7B62 A11A 
0174 7B64 6120  34         s     @cmdb.scrrows,tmp0
     7B66 A306 
0175 7B68 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7B6A A118 
0176               
0177 7B6C 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0178 7B6E C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7B70 A30E 
0179               
0180 7B72 0224  22         ai    tmp0,>0100
     7B74 0100 
0181 7B76 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7B78 A310 
0182 7B7A 0584  14         inc   tmp0
0183 7B7C C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7B7E A30A 
0184               
0185 7B80 0720  34         seto  @cmdb.visible         ; Show pane
     7B82 A302 
0186 7B84 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7B86 A318 
0187               
0188 7B88 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7B8A 0001 
0189 7B8C C804  38         mov   tmp0,@tv.pane.focus   ; /
     7B8E A01C 
0190               
0191 7B90 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7B92 7C1A 
0192               
0193 7B94 0720  34         seto  @parm1                ; Do not turn screen off while
     7B96 2F20 
0194                                                   ; reloading color scheme
0195               
0196 7B98 06A0  32         bl    @pane.action.colorscheme.load
     7B9A 7950 
0197                                                   ; Reload color scheme
0198                                                   ; i  parm1 = Skip screen off if >FFFF
0199               
0200               pane.cmdb.show.exit:
0201                       ;------------------------------------------------------
0202                       ; Exit
0203                       ;------------------------------------------------------
0204 7B9C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0205 7B9E C2F9  30         mov   *stack+,r11           ; Pop r11
0206 7BA0 045B  20         b     *r11                  ; Return to caller
0207               
0208               
0209               
0210               ***************************************************************
0211               * pane.cmdb.hide
0212               * Hide command buffer pane
0213               ***************************************************************
0214               * bl @pane.cmdb.hide
0215               *--------------------------------------------------------------
0216               * INPUT
0217               * none
0218               *--------------------------------------------------------------
0219               * OUTPUT
0220               * none
0221               *--------------------------------------------------------------
0222               * Register usage
0223               * none
0224               *--------------------------------------------------------------
0225               * Hiding the command buffer automatically passes pane focus
0226               * to frame buffer.
0227               ********|*****|*********************|**************************
0228               pane.cmdb.hide:
0229 7BA2 0649  14         dect  stack
0230 7BA4 C64B  30         mov   r11,*stack            ; Save return address
0231                       ;------------------------------------------------------
0232                       ; Hide command buffer pane
0233                       ;------------------------------------------------------
0234 7BA6 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7BA8 A11A 
     7BAA A118 
0235                       ;------------------------------------------------------
0236                       ; Adjust frame buffer size if error pane visible
0237                       ;------------------------------------------------------
0238 7BAC C820  54         mov   @tv.error.visible,@tv.error.visible
     7BAE A020 
     7BB0 A020 
0239 7BB2 1302  14         jeq   !
0240 7BB4 0620  34         dec   @fb.scrrows
     7BB6 A118 
0241                       ;------------------------------------------------------
0242                       ; Clear error/hint & status line
0243                       ;------------------------------------------------------
0244 7BB8 06A0  32 !       bl    @hchar
     7BBA 2794 
0245 7BBC 1C00                   byte pane.botrow-1,0,32,80*2
     7BBE 20A0 
0246 7BC0 FFFF                   data EOL
0247                       ;------------------------------------------------------
0248                       ; Hide command buffer pane (rest)
0249                       ;------------------------------------------------------
0250 7BC2 C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7BC4 A304 
     7BC6 832A 
0251 7BC8 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7BCA A302 
0252 7BCC 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7BCE A116 
0253 7BD0 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7BD2 A01C 
0254                       ;------------------------------------------------------
0255                       ; Reload current color scheme
0256                       ;------------------------------------------------------
0257 7BD4 0720  34         seto  @parm1                ; Do not turn screen off while
     7BD6 2F20 
0258                                                   ; reloading color scheme
0259               
0260 7BD8 06A0  32         bl    @pane.action.colorscheme.load
     7BDA 7950 
0261                                                   ; Reload color scheme
0262                                                   ; i  parm1 = Skip screen off if >FFFF
0263                       ;------------------------------------------------------
0264                       ; Show cursor again
0265                       ;------------------------------------------------------
0266 7BDC 06A0  32         bl    @pane.cursor.blink
     7BDE 78A6 
0267                       ;------------------------------------------------------
0268                       ; Exit
0269                       ;------------------------------------------------------
0270               pane.cmdb.hide.exit:
0271 7BE0 C2F9  30         mov   *stack+,r11           ; Pop r11
0272 7BE2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0183                       copy  "pane.errline.asm"    ; Error line
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
0026 7BE4 0649  14         dect  stack
0027 7BE6 C64B  30         mov   r11,*stack            ; Save return address
0028 7BE8 0649  14         dect  stack
0029 7BEA C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7BEC 0649  14         dect  stack
0031 7BEE C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 7BF0 0205  20         li    tmp1,>00f6            ; White on dark red
     7BF2 00F6 
0034 7BF4 C805  38         mov   tmp1,@parm1
     7BF6 2F20 
0035               
0036 7BF8 06A0  32         bl    @pane.action.colorcombo.errline
     7BFA 7A1E 
0037                                                   ; \ Set colors for error line
0038                                                   ; / i  parm1 = FG/BG color
0039               
0040                       ;------------------------------------------------------
0041                       ; Show error line content
0042                       ;------------------------------------------------------
0043 7BFC 06A0  32         bl    @putat                ; Display error message
     7BFE 2450 
0044 7C00 1C00                   byte pane.botrow-1,0
0045 7C02 A022                   data tv.error.msg
0046               
0047 7C04 C120  34         mov   @fb.scrrows.max,tmp0
     7C06 A11A 
0048 7C08 0604  14         dec   tmp0
0049 7C0A C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7C0C A118 
0050               
0051 7C0E 0720  34         seto  @tv.error.visible     ; Error line is visible
     7C10 A020 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               pane.errline.show.exit:
0056 7C12 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7C14 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7C16 C2F9  30         mov   *stack+,r11           ; Pop r11
0059 7C18 045B  20         b     *r11                  ; Return to caller
0060               
0061               
0062               
0063               ***************************************************************
0064               * pane.errline.hide
0065               * Hide error line
0066               ***************************************************************
0067               * bl @pane.errline.hide
0068               *--------------------------------------------------------------
0069               * INPUT
0070               * none
0071               *--------------------------------------------------------------
0072               * OUTPUT
0073               * none
0074               *--------------------------------------------------------------
0075               * Register usage
0076               * none
0077               *--------------------------------------------------------------
0078               * Hiding the error line passes pane focus to frame buffer.
0079               ********|*****|*********************|**************************
0080               pane.errline.hide:
0081 7C1A 0649  14         dect  stack
0082 7C1C C64B  30         mov   r11,*stack            ; Save return address
0083 7C1E 0649  14         dect  stack
0084 7C20 C644  30         mov   tmp0,*stack           ; Push tmp0
0085                       ;------------------------------------------------------
0086                       ; Hide command buffer pane
0087                       ;------------------------------------------------------
0088 7C22 06A0  32 !       bl    @errline.init         ; Clear error line
     7C24 6F9E 
0089               
0090 7C26 C120  34         mov   @tv.color,tmp0        ; Get colors
     7C28 A018 
0091 7C2A 0984  56         srl   tmp0,8                ; Right aligns
0092 7C2C C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7C2E 2F20 
0093               
0094 7C30 06A0  32         bl    @pane.action.colorcombo.errline
     7C32 7A1E 
0095                                                   ; \ Set colors for error line
0096                                                   ; / i  parm1 LSB = FG/BG color
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100               pane.errline.hide.exit:
0101 7C34 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7C36 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7C38 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2405726
0184                       copy  "pane.botline.asm"    ; Status line
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
0021 7C3A 0649  14         dect  stack
0022 7C3C C64B  30         mov   r11,*stack            ; Save return address
0023 7C3E 0649  14         dect  stack
0024 7C40 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7C42 C820  54         mov   @wyx,@fb.yxsave
     7C44 832A 
     7C46 A114 
0027                       ;------------------------------------------------------
0028                       ; Show separators
0029                       ;------------------------------------------------------
0030 7C48 06A0  32         bl    @hchar
     7C4A 2794 
0031 7C4C 1D2A                   byte pane.botrow,42,16,1       ; Vertical line 1
     7C4E 1001 
0032 7C50 1D32                   byte pane.botrow,50,16,1       ; Vertical line 2
     7C52 1001 
0033 7C54 1D47                   byte pane.botrow,71,16,1       ; Vertical line 3
     7C56 1001 
0034 7C58 FFFF                   data eol
0035                       ;------------------------------------------------------
0036                       ; Show buffer number
0037                       ;------------------------------------------------------
0038               pane.botline.bufnum:
0039 7C5A 06A0  32         bl    @putat
     7C5C 2450 
0040 7C5E 1D00                   byte  pane.botrow,0
0041 7C60 334C                   data  txt.bufnum
0042                       ;------------------------------------------------------
0043                       ; Show current file
0044                       ;------------------------------------------------------
0045               pane.botline.show_file:
0046 7C62 06A0  32         bl    @at
     7C64 26A0 
0047 7C66 1D03                   byte  pane.botrow,3   ; Position cursor
0048 7C68 C160  34         mov   @edb.filename.ptr,tmp1
     7C6A A20E 
0049                                                   ; Get string to display
0050 7C6C 06A0  32         bl    @xutst0               ; Display string
     7C6E 242E 
0051                       ;------------------------------------------------------
0052                       ; Show text editing mode
0053                       ;------------------------------------------------------
0054               pane.botline.show_mode:
0055 7C70 C120  34         mov   @edb.insmode,tmp0
     7C72 A20A 
0056 7C74 1605  14         jne   pane.botline.show_mode.insert
0057                       ;------------------------------------------------------
0058                       ; Overwrite mode
0059                       ;------------------------------------------------------
0060               pane.botline.show_mode.overwrite:
0061 7C76 06A0  32         bl    @putat
     7C78 2450 
0062 7C7A 1D2C                   byte  pane.botrow,44
0063 7C7C 3318                   data  txt.ovrwrite
0064 7C7E 1004  14         jmp   pane.botline.show_changed
0065                       ;------------------------------------------------------
0066                       ; Insert  mode
0067                       ;------------------------------------------------------
0068               pane.botline.show_mode.insert:
0069 7C80 06A0  32         bl    @putat
     7C82 2450 
0070 7C84 1D2C                   byte  pane.botrow,44
0071 7C86 331C                   data  txt.insert
0072                       ;------------------------------------------------------
0073                       ; Show if text was changed in editor buffer
0074                       ;------------------------------------------------------
0075               pane.botline.show_changed:
0076 7C88 C120  34         mov   @edb.dirty,tmp0
     7C8A A206 
0077 7C8C 1305  14         jeq   pane.botline.show_linecol
0078                       ;------------------------------------------------------
0079                       ; Show "*"
0080                       ;------------------------------------------------------
0081 7C8E 06A0  32         bl    @putat
     7C90 2450 
0082 7C92 1D30                   byte pane.botrow,48
0083 7C94 3320                   data txt.star
0084 7C96 1000  14         jmp   pane.botline.show_linecol
0085                       ;------------------------------------------------------
0086                       ; Show "line,column"
0087                       ;------------------------------------------------------
0088               pane.botline.show_linecol:
0089 7C98 C820  54         mov   @fb.row,@parm1
     7C9A A106 
     7C9C 2F20 
0090 7C9E 06A0  32         bl    @fb.row2line          ; Row to editor line
     7CA0 6910 
0091                                                   ; \ i @fb.topline = Top line in frame buffer
0092                                                   ; | i @parm1      = Row in frame buffer
0093                                                   ; / o @outparm1   = Matching line in EB
0094               
0095 7CA2 05A0  34         inc   @outparm1             ; Add base 1
     7CA4 2F30 
0096                       ;------------------------------------------------------
0097                       ; Show line
0098                       ;------------------------------------------------------
0099 7CA6 06A0  32         bl    @putnum
     7CA8 2A24 
0100 7CAA 1D3B                   byte  pane.botrow,59  ; YX
0101 7CAC 2F30                   data  outparm1,rambuf
     7CAE 2F64 
0102 7CB0 3020                   byte  48              ; ASCII offset
0103                             byte  32              ; Padding character
0104                       ;------------------------------------------------------
0105                       ; Show comma
0106                       ;------------------------------------------------------
0107 7CB2 06A0  32         bl    @putat
     7CB4 2450 
0108 7CB6 1D40                   byte  pane.botrow,64
0109 7CB8 3309                   data  txt.delim
0110                       ;------------------------------------------------------
0111                       ; Show column
0112                       ;------------------------------------------------------
0113 7CBA 06A0  32         bl    @film
     7CBC 2244 
0114 7CBE 2F69                   data rambuf+5,32,12   ; Clear work buffer with space character
     7CC0 0020 
     7CC2 000C 
0115               
0116 7CC4 C820  54         mov   @fb.column,@waux1
     7CC6 A10C 
     7CC8 833C 
0117 7CCA 05A0  34         inc   @waux1                ; Offset 1
     7CCC 833C 
0118               
0119 7CCE 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7CD0 29A6 
0120 7CD2 833C                   data  waux1,rambuf
     7CD4 2F64 
0121 7CD6 3020                   byte  48              ; ASCII offset
0122                             byte  32              ; Fill character
0123               
0124 7CD8 06A0  32         bl    @trimnum              ; Trim number to the left
     7CDA 29FE 
0125 7CDC 2F64                   data  rambuf,rambuf+5,32
     7CDE 2F69 
     7CE0 0020 
0126               
0127 7CE2 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     7CE4 0600 
0128 7CE6 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     7CE8 2F69 
0129               
0130                       ;------------------------------------------------------
0131                       ; Decide if row length is to be shown
0132                       ;------------------------------------------------------
0133 7CEA C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     7CEC A10C 
0134 7CEE 0584  14         inc   tmp0                  ; /
0135 7CF0 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     7CF2 A108 
0136 7CF4 1101  14         jlt   pane.botline.show_linecol.linelen
0137 7CF6 102B  14         jmp   pane.botline.show_linecol.colstring
0138                                                   ; Yes, skip showing row length
0139                       ;------------------------------------------------------
0140                       ; Add '/' delimiter and length of line to string
0141                       ;------------------------------------------------------
0142               pane.botline.show_linecol.linelen:
0143 7CF8 C120  34         mov   @fb.column,tmp0       ; \
     7CFA A10C 
0144 7CFC 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '-' char
     7CFE 2F6B 
0145 7D00 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     7D02 0009 
0146 7D04 1101  14         jlt   !                     ; | column.
0147 7D06 0585  14         inc   tmp1                  ; /
0148               
0149 7D08 0204  20 !       li    tmp0,>2d00            ; \ ASCII 2d '-'
     7D0A 2D00 
0150 7D0C DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0151               
0152 7D0E C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     7D10 833C 
0153               
0154 7D12 06A0  32         bl    @mknum
     7D14 29A6 
0155 7D16 A108                   data  fb.row.length,rambuf
     7D18 2F64 
0156 7D1A 3020                   byte  48              ; ASCII offset
0157                             byte  32              ; Padding character
0158               
0159 7D1C C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7D1E 833C 
0160               
0161 7D20 C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     7D22 A108 
0162 7D24 0284  22         ci    tmp0,10               ; /
     7D26 000A 
0163 7D28 110B  14         jlt   pane.botline.show_line.1digit
0164                       ;------------------------------------------------------
0165                       ; Sanity check
0166                       ;------------------------------------------------------
0167 7D2A 0284  22         ci    tmp0,80
     7D2C 0050 
0168 7D2E 1204  14         jle   pane.botline.show_line.2digits
0169                       ;------------------------------------------------------
0170                       ; Sanity checks failed
0171                       ;------------------------------------------------------
0172 7D30 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     7D32 FFCE 
0173 7D34 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7D36 2030 
0174                       ;------------------------------------------------------
0175                       ; Show length of line (2 digits)
0176                       ;------------------------------------------------------
0177               pane.botline.show_line.2digits:
0178 7D38 0204  20         li    tmp0,rambuf+3
     7D3A 2F67 
0179 7D3C DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0180 7D3E 1002  14         jmp   pane.botline.show_line.rest
0181                       ;------------------------------------------------------
0182                       ; Show length of line (1 digits)
0183                       ;------------------------------------------------------
0184               pane.botline.show_line.1digit:
0185 7D40 0204  20         li    tmp0,rambuf+4
     7D42 2F68 
0186               pane.botline.show_line.rest:
0187 7D44 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0188 7D46 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D48 2F64 
0189 7D4A DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7D4C 2F64 
0190                       ;------------------------------------------------------
0191                       ; Show column string
0192                       ;------------------------------------------------------
0193               pane.botline.show_linecol.colstring:
0194 7D4E 06A0  32         bl    @putat
     7D50 2450 
0195 7D52 1D41                   byte pane.botrow,65
0196 7D54 2F69                   data rambuf+5         ; Show string
0197                       ;------------------------------------------------------
0198                       ; Show lines in buffer unless on last line in file
0199                       ;------------------------------------------------------
0200 7D56 C820  54         mov   @fb.row,@parm1
     7D58 A106 
     7D5A 2F20 
0201 7D5C 06A0  32         bl    @fb.row2line
     7D5E 6910 
0202 7D60 8820  54         c     @edb.lines,@outparm1
     7D62 A204 
     7D64 2F30 
0203 7D66 1605  14         jne   pane.botline.show_lines_in_buffer
0204               
0205 7D68 06A0  32         bl    @putat
     7D6A 2450 
0206 7D6C 1D49                   byte pane.botrow,73
0207 7D6E 3312                   data txt.bottom
0208               
0209 7D70 1009  14         jmp   pane.botline.exit
0210                       ;------------------------------------------------------
0211                       ; Show lines in buffer
0212                       ;------------------------------------------------------
0213               pane.botline.show_lines_in_buffer:
0214 7D72 C820  54         mov   @edb.lines,@waux1
     7D74 A204 
     7D76 833C 
0215               
0216 7D78 06A0  32         bl    @putnum
     7D7A 2A24 
0217 7D7C 1D49                   byte pane.botrow,73   ; YX
0218 7D7E 833C                   data waux1,rambuf
     7D80 2F64 
0219 7D82 3020                   byte 48
0220                             byte 32
0221                       ;------------------------------------------------------
0222                       ; Exit
0223                       ;------------------------------------------------------
0224               pane.botline.exit:
0225 7D84 C820  54         mov   @fb.yxsave,@wyx
     7D86 A114 
     7D88 832A 
0226 7D8A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0227 7D8C C2F9  30         mov   *stack+,r11           ; Pop r11
0228 7D8E 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.2405726
0185                       ;-----------------------------------------------------------------------
0186                       ; Dialogs
0187                       ;-----------------------------------------------------------------------
0188                       copy  "dialog.about.asm"    ; Dialog "About"
**** **** ****     > dialog.about.asm
0001               * FILE......: dialog.about.asm
0002               * Purpose...: Stevie Editor - About dialog
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - About dialog
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *---------------------------------------------------------------
0009               * Show Stevie welcome/about dialog
0010               *---------------------------------------------------------------
0011               edkey.action.about:
0012                       ;-------------------------------------------------------
0013                       ; Setup dialog
0014                       ;-------------------------------------------------------
0015 7D90 0204  20         li    tmp0,id.dialog.about
     7D92 0066 
0016 7D94 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7D96 A31A 
0017               
0018 7D98 06A0  32         bl    @dialog.about.content ; display content in modal dialog
     7D9A 7DB8 
0019               
0020 7D9C 0204  20         li    tmp0,txt.head.about
     7D9E 3566 
0021 7DA0 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7DA2 A31C 
0022               
0023 7DA4 0204  20         li    tmp0,txt.hint.about
     7DA6 3574 
0024 7DA8 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7DAA A31E 
0025               
0026 7DAC 0204  20         li    tmp0,txt.keys.about
     7DAE 35A2 
0027 7DB0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7DB2 A320 
0028               
0029 7DB4 0460  28         b     @edkey.action.cmdb.show
     7DB6 67C4 
0030                                                   ; Show dialog in CMDB pane
0031               
0032               
0033               
0034               
0035               
0036               ***************************************************************
0037               * dialog.about.content
0038               * Show content in modal dialog
0039               ***************************************************************
0040               * bl  @dialog.about.content
0041               *--------------------------------------------------------------
0042               * OUTPUT
0043               * none
0044               *--------------------------------------------------------------
0045               * Register usage
0046               * tmp0
0047               ********|*****|*********************|**************************
0048               dialog.about.content:
0049 7DB8 0649  14         dect  stack
0050 7DBA C64B  30         mov   r11,*stack            ; Save return address
0051 7DBC 0649  14         dect  stack
0052 7DBE C644  30         mov   tmp0,*stack           ; Push tmp0
0053 7DC0 0649  14         dect  stack
0054 7DC2 C645  30         mov   tmp1,*stack           ; Push tmp1
0055 7DC4 0649  14         dect  stack
0056 7DC6 C646  30         mov   tmp2,*stack           ; Push tmp2
0057               
0058 7DC8 C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     7DCA 832A 
     7DCC A114 
0059                       ;-------------------------------------------------------
0060                       ; Clear VDP screen buffer
0061                       ;-------------------------------------------------------
0062 7DCE 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7DD0 7888 
0063               
0064 7DD2 C160  34         mov   @fb.scrrows,tmp1
     7DD4 A118 
0065 7DD6 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7DD8 A10E 
0066                                                   ; 16 bit part is in tmp2!
0067               
0068 7DDA 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0069 7DDC 0205  20         li    tmp1,32               ; Character to fill
     7DDE 0020 
0070               
0071 7DE0 06A0  32         bl    @xfilv                ; Fill VDP memory
     7DE2 22A2 
0072                                                   ; \ i  tmp0 = VDP target address
0073                                                   ; | i  tmp1 = Byte to fill
0074                                                   ; / i  tmp2 = Bytes to copy
0075                       ;------------------------------------------------------
0076                       ; Show About dialog
0077                       ;------------------------------------------------------
0078 7DE4 06A0  32 !       bl    @hchar
     7DE6 2794 
0079 7DE8 0214                   byte 2,20,3,40
     7DEA 0328 
0080 7DEC 0C14                   byte 12,20,3,40
     7DEE 0328 
0081 7DF0 FFFF                   data EOL
0082               
0083 7DF2 06A0  32         bl    @putat
     7DF4 2450 
0084 7DF6 0421                   byte   4,33
0085 7DF8 3192                   data   txt.about.program
0086 7DFA 06A0  32         bl    @putat
     7DFC 2450 
0087 7DFE 0616                   byte   6,22
0088 7E00 31A0                   data   txt.about.purpose
0089 7E02 06A0  32         bl    @putat
     7E04 2450 
0090 7E06 0719                   byte   7,25
0091 7E08 31C4                   data   txt.about.author
0092 7E0A 06A0  32         bl    @putat
     7E0C 2450 
0093 7E0E 091A                   byte   9,26
0094 7E10 31E2                   data   txt.about.website
0095 7E12 06A0  32         bl    @putat
     7E14 2450 
0096 7E16 0B1D                   byte   11,29
0097 7E18 31FE                   data   txt.about.build
0098               
0099 7E1A 06A0  32         bl    @putat
     7E1C 2450 
0100 7E1E 0E03                   byte   14,3
0101 7E20 3214                   data   txt.about.msg1
0102 7E22 06A0  32         bl    @putat
     7E24 2450 
0103 7E26 0F03                   byte   15,3
0104 7E28 323A                   data   txt.about.msg2
0105 7E2A 06A0  32         bl    @putat
     7E2C 2450 
0106 7E2E 1003                   byte   16,3
0107 7E30 325E                   data   txt.about.msg3
0108 7E32 06A0  32         bl    @putat
     7E34 2450 
0109 7E36 0E32                   byte   14,50
0110 7E38 3278                   data   txt.about.msg4
0111 7E3A 06A0  32         bl    @putat
     7E3C 2450 
0112 7E3E 0F32                   byte   15,50
0113 7E40 3296                   data   txt.about.msg5
0114 7E42 06A0  32         bl    @putat
     7E44 2450 
0115 7E46 1032                   byte   16,50
0116 7E48 32B4                   data   txt.about.msg6
0117               
0118 7E4A 06A0  32         bl    @putat
     7E4C 2450 
0119 7E4E 120A                   byte   18,10
0120 7E50 32D0                   data   txt.about.msg7
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               _dialog.about.content.exit:
0125 7E52 C820  54         mov   @fb.yxsave,@wyx
     7E54 A114 
     7E56 832A 
0126 7E58 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0127 7E5A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0128 7E5C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0129 7E5E C2F9  30         mov   *stack+,r11           ; Pop r11
0130 7E60 045B  20         b     *r11                  ; Return
0131               
**** **** ****     > stevie_b1.asm.2405726
0189                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
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
0027                       ;-------------------------------------------------------
0028                       ; Show dialog "unsaved changes" if editor buffer dirty
0029                       ;-------------------------------------------------------
0030 7E62 C120  34         mov   @edb.dirty,tmp0
     7E64 A206 
0031 7E66 1302  14         jeq   dialog.load.setup
0032 7E68 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7E6A 7ED8 
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036               dialog.load.setup:
0037 7E6C 0204  20         li    tmp0,id.dialog.load
     7E6E 000A 
0038 7E70 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7E72 A31A 
0039               
0040 7E74 0204  20         li    tmp0,txt.head.load
     7E76 336E 
0041 7E78 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7E7A A31C 
0042               
0043 7E7C 0204  20         li    tmp0,txt.hint.load
     7E7E 337E 
0044 7E80 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7E82 A31E 
0045               
0046 7E84 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     7E86 A44E 
0047 7E88 1303  14         jeq   !
0048                       ;-------------------------------------------------------
0049                       ; Show that FastMode is on
0050                       ;-------------------------------------------------------
0051 7E8A 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     7E8C 3404 
0052 7E8E 1002  14         jmp   dialog.load.keylist
0053                       ;-------------------------------------------------------
0054                       ; Show that FastMode is off
0055                       ;-------------------------------------------------------
0056 7E90 0204  20 !       li    tmp0,txt.keys.load
     7E92 33CC 
0057                       ;-------------------------------------------------------
0058                       ; Show dialog
0059                       ;-------------------------------------------------------
0060               dialog.load.keylist:
0061 7E94 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7E96 A320 
0062               
0063 7E98 0460  28         b     @edkey.action.cmdb.show
     7E9A 67C4 
0064                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2405726
0190                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
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
0027                       ;-------------------------------------------------------
0028                       ; Crunch current row if dirty
0029                       ;-------------------------------------------------------
0030 7E9C 8820  54         c     @fb.row.dirty,@w$ffff
     7E9E A10A 
     7EA0 202C 
0031 7EA2 1604  14         jne   !                     ; Skip crunching if clean
0032 7EA4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7EA6 6CA6 
0033 7EA8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7EAA A10A 
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037 7EAC 0204  20 !       li    tmp0,id.dialog.save
     7EAE 000B 
0038 7EB0 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7EB2 A31A 
0039               
0040 7EB4 0204  20         li    tmp0,txt.head.save
     7EB6 343C 
0041 7EB8 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7EBA A31C 
0042               
0043 7EBC 0204  20         li    tmp0,txt.hint.save
     7EBE 344C 
0044 7EC0 C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7EC2 A31E 
0045               
0046 7EC4 0204  20         li    tmp0,txt.keys.save
     7EC6 348C 
0047 7EC8 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7ECA A320 
0048               
0049 7ECC 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     7ECE A44E 
0050               
0051 7ED0 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     7ED2 78A6 
0052               
0053 7ED4 0460  28         b     @edkey.action.cmdb.show
     7ED6 67C4 
0054                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2405726
0191                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
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
0027 7ED8 0204  20         li    tmp0,id.dialog.unsaved
     7EDA 0065 
0028 7EDC C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7EDE A31A 
0029               
0030 7EE0 0204  20         li    tmp0,txt.head.unsaved
     7EE2 34B6 
0031 7EE4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7EE6 A31C 
0032               
0033 7EE8 0204  20         li    tmp0,txt.hint.unsaved
     7EEA 34C8 
0034 7EEC C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7EEE A31E 
0035               
0036 7EF0 0204  20         li    tmp0,txt.keys.unsaved
     7EF2 3508 
0037 7EF4 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7EF6 A320 
0038               
0039 7EF8 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7EFA 7888 
0040               
0041 7EFC 0460  28         b     @edkey.action.cmdb.show
     7EFE 67C4 
0042                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2405726
0192                       ;-----------------------------------------------------------------------
0193                       ; Program data
0194                       ;-----------------------------------------------------------------------
0195                       copy  "data.keymap.actions.asm"
**** **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard actions)
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7F00 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7F02 0000 
     7F04 65F0 
0012 7F06 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7F08 0000 
     7F0A 6172 
0013 7F0C 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7F0E 0000 
     7F10 6188 
0014 7F12 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7F14 0000 
     7F16 6288 
0015 7F18 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7F1A 0000 
     7F1C 62DA 
0016 7F1E 8100             data  key.ctrl.a, pane.focus.fb, edkey.action.home
     7F20 0000 
     7F22 61A0 
0017 7F24 8600             data  key.ctrl.f, pane.focus.fb, edkey.action.end
     7F26 0000 
     7F28 61B8 
0018 7F2A 9300             data  key.ctrl.s, pane.focus.fb, edkey.action.pword
     7F2C 0000 
     7F2E 61D6 
0019 7F30 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.nword
     7F32 0000 
     7F34 6228 
0020 7F36 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7F38 0000 
     7F3A 6346 
0021 7F3C 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7F3E 0000 
     7F40 637A 
0022 7F42 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7F44 0000 
     7F46 63C8 
0023 7F48 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7F4A 0000 
     7F4C 63DE 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7F4E 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7F50 0000 
     7F52 6408 
0028 7F54 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7F56 0000 
     7F58 64BA 
0029 7F5A 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7F5C 0000 
     7F5E 6486 
0030               
0031                       ;-------------------------------------------------------
0032                       ; Modifier keys - Insert
0033                       ;-------------------------------------------------------
0034 7F60 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7F62 0000 
     7F64 6532 
0035 7F66 B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7F68 0000 
     7F6A 6660 
0036 7F6C 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7F6E 0000 
     7F70 65AC 
0037                       ;-------------------------------------------------------
0038                       ; Other action keys
0039                       ;-------------------------------------------------------
0040 7F72 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7F74 0000 
     7F76 66D4 
0041 7F78 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7F7A 0000 
     7F7C 78C6 
0042                       ;-------------------------------------------------------
0043                       ; Dialog keys
0044                       ;-------------------------------------------------------
0045 7F7E 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7F80 0000 
     7F82 66E6 
0046 7F84 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7F86 0000 
     7F88 66F2 
0047 7F8A 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7F8C 0000 
     7F8E 7D90 
0048 7F90 8B00             data  key.ctrl.k, pane.focus.fb, dialog.save
     7F92 0000 
     7F94 7E9C 
0049 7F96 8C00             data  key.ctrl.l, pane.focus.fb, dialog.load
     7F98 0000 
     7F9A 7E62 
0050                       ;-------------------------------------------------------
0051                       ; End of list
0052                       ;-------------------------------------------------------
0053 7F9C FFFF             data  EOL                           ; EOL
0054               
0055               
0056               
0057               
0058               *---------------------------------------------------------------
0059               * Action keys mapping table: Command Buffer (CMDB)
0060               *---------------------------------------------------------------
0061               keymap_actions.cmdb:
0062                       ;-------------------------------------------------------
0063                       ; Dialog specific: File load / save
0064                       ;-------------------------------------------------------
0065 7F9E 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7FA0 000A 
     7FA2 6852 
0066                       ;-------------------------------------------------------
0067                       ; Dialog specific: Unsaved changes
0068                       ;-------------------------------------------------------
0069 7FA4 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7FA6 0065 
     7FA8 6828 
0070 7FAA 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7FAC 0065 
     7FAE 7E9C 
0071                       ;-------------------------------------------------------
0072                       ; Dialog specific: About
0073                       ;-------------------------------------------------------
0074 7FB0 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7FB2 0066 
     7FB4 685E 
0075                       ;-------------------------------------------------------
0076                       ; Movement keys
0077                       ;-------------------------------------------------------
0078 7FB6 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7FB8 0001 
     7FBA 671C 
0079 7FBC 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7FBE 0001 
     7FC0 672E 
0080 7FC2 8100             data  key.ctrl.a, pane.focus.cmdb, edkey.action.cmdb.home
     7FC4 0001 
     7FC6 6746 
0081 7FC8 8600             data  key.ctrl.f, pane.focus.cmdb, edkey.action.cmdb.end
     7FCA 0001 
     7FCC 675A 
0082                       ;-------------------------------------------------------
0083                       ; Modifier keys
0084                       ;-------------------------------------------------------
0085 7FCE 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7FD0 0001 
     7FD2 6772 
0086 7FD4 0D00             data  key.enter, pane.focus.cmdb, edkey.action.cmdb.enter
     7FD6 0001 
     7FD8 67B6 
0087                       ;-------------------------------------------------------
0088                       ; Other action keys
0089                       ;-------------------------------------------------------
0090 7FDA 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7FDC 0001 
     7FDE 685E 
0091 7FE0 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7FE2 0001 
     7FE4 66D4 
0092 7FE6 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7FE8 0001 
     7FEA 78C6 
0093                       ;------------------------------------------------------
0094                       ; End of list
0095                       ;-------------------------------------------------------
0096 7FEC FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.2405726
0196                                                   ; Data segment - Keyboard actions
0200 7FEE 7FEE                   data $                ; Bank 1 ROM size OK.
0202               
0203               *--------------------------------------------------------------
0204               * Video mode configuration
0205               *--------------------------------------------------------------
0206      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0207      0004     spfbck  equ   >04                   ; Screen background color.
0208      3084     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0209      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0210      0050     colrow  equ   80                    ; Columns per row
0211      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0212      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0213      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0214      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
